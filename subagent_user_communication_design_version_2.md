# Subagent User Communication Design - Version 2

## Problem Statement

In Claude Code workflows with nested subagents (subagent → subagent → subagent), direct user interaction is impossible because:
- Only the main Claude agent can interact with users via Claude Code UI
- Subagents launched via Task tool are stateless (no context preservation across invocations)
- Synchronous bash commands have 10-minute timeout limit
- Users may need >10 minutes to respond to questions

**Current workaround is token-expensive:** Subagent exits → Main agent asks user → Main agent relaunches subagent with updated instructions → High token cost for multiple Q&A rounds.

## Design Constraints

1. Nested subagents (potentially multiple levels deep)
2. Each subagent invocation is stateless
3. 10-minute timeout on any synchronous bash command
4. Only the main agent can interact via Claude Code UI
5. Main agent can `/resume`, subagents cannot
6. Users require >10 minute response times
7. Avoid context bloat from repeated "keep waiting" messages

## Solution: Hybrid Quick-Response with Graceful Escalation

### Core Principle

**Subagents attempt quick direct communication with users (via file-based messaging), but gracefully escalate to main agent if user doesn't respond within a safe timeout window.** This provides:
- Fast completion path when users are present and responsive
- Robust unlimited-wait path when users are slow or absent
- No risk of hitting the 10-minute Bash timeout
- No context bloat or wasted work

### The Flow

```
Subagent needs user input
   ↓
   Post question via notification + wait for response
   ↓
   Poll for answer (with safe timeout, e.g., 5 minutes)
   ↓
   ┌─────────────────────────────────────┐
   │ User responds within timeout?       │
   └─────────────────────────────────────┘
          │                    │
         YES                  NO
          │                    │
          ↓                    ↓
   Read answer          Save checkpoint
   Continue work        Post question for main agent
   Complete workflow    Exit cleanly
                        │
                        ↓
                   Main agent detects question
                   Uses AskUserQuestion (unlimited time)
                   Relaunches subagent with answer
```

### Architecture Components

**Directory Structure:**
```
~/.claude/questions/
├── pending/          # Subagents post questions here (for escalation)
└── answered/         # Main agent writes completed Q&A here (cleanup)

~/.claude/answers/    # Users post quick answers here (for fast path)

/tmp/workflows/       # Workflow checkpoint files
```

## Implementation Patterns

### Pattern: Subagent Attempts Quick Response

**When subagent encounters a decision point requiring user input:**

```bash
WORKFLOW_ID="workflow_$(date +%s)"
QUESTION_ID="${WORKFLOW_ID}_q1"

# Create question file for potential main agent escalation
cat > ~/.claude/questions/pending/${QUESTION_ID}.json <<EOF
{
  "question": "Which auth method: OAuth or JWT?",
  "options": ["oauth", "jwt"],
  "workflow_id": "${WORKFLOW_ID}",
  "checkpoint": "/tmp/${WORKFLOW_ID}_checkpoint.json",
  "asked_at": "$(date -Iseconds)"
}
EOF

# Try quick response via notification
notify-send "Claude Question" "Auth method needed. Answer in: ~/.claude/answers/${QUESTION_ID}.txt (5 min timeout)"

# Poll for quick response (5 minutes = 300 seconds)
WAIT_SECONDS=0
MAX_QUICK_WAIT=300  # 5 minutes - leaves safety margin before 10min timeout

echo "Waiting for quick user response (timeout: ${MAX_QUICK_WAIT}s)..."

while [ $WAIT_SECONDS -lt $MAX_QUICK_WAIT ]; do
  if [ -f ~/.claude/answers/${QUESTION_ID}.txt ]; then
    # Quick response received!
    ANSWER=$(cat ~/.claude/answers/${QUESTION_ID}.txt)

    # Cleanup
    rm ~/.claude/answers/${QUESTION_ID}.txt
    rm ~/.claude/questions/pending/${QUESTION_ID}.json

    echo "Quick response received: $ANSWER"

    # Continue with workflow using answer
    case "$ANSWER" in
      oauth)
        # Implement OAuth...
        ;;
      jwt)
        # Implement JWT...
        ;;
    esac

    # Complete workflow
    echo "WORKFLOW_COMPLETE"
    exit 0
  fi

  sleep 5
  WAIT_SECONDS=$((WAIT_SECONDS + 5))
done

# Timeout - escalate to main agent
echo "No quick response. Escalating to main agent for unlimited-wait question..."

# Save checkpoint with current state
cat > /tmp/${WORKFLOW_ID}_checkpoint.json <<EOF
{
  "workflow_id": "${WORKFLOW_ID}",
  "current_step": "auth_method_selection",
  "completed_steps": ["analyze_requirements", "design_system"],
  "pending_steps": ["implement_auth", "add_tests"],
  "context": "Need auth method choice to continue implementation",
  "next_action": "implement_selected_auth_method"
}
EOF

# Exit with special signal
echo "QUESTION_ESCALATED:${QUESTION_ID}"
exit 0
```

### Pattern: Main Agent Handles Escalated Question

**Main agent orchestration logic after subagent exits:**

```bash
# After subagent exits, check output
SUBAGENT_OUTPUT=$(cat /tmp/subagent_output.txt)

if [[ "$SUBAGENT_OUTPUT" == *"QUESTION_ESCALATED"* ]]; then
  # Extract question ID
  QUESTION_ID=$(echo "$SUBAGENT_OUTPUT" | grep -o 'QUESTION_ESCALATED:[^ ]*' | cut -d: -f2)

  # Read question details
  QUESTION_FILE=~/.claude/questions/pending/${QUESTION_ID}.json
  QUESTION=$(jq -r '.question' "$QUESTION_FILE")
  OPTIONS=$(jq -r '.options[]' "$QUESTION_FILE")
  CHECKPOINT=$(jq -r '.checkpoint' "$QUESTION_FILE")

  # Ask user via Claude Code UI (unlimited wait time)
  # User can take hours, days, whatever
  # AskUserQuestion tool used here...
  # User responds: "oauth"

  # Update checkpoint with answer
  jq '.user_answer = "oauth"' "$CHECKPOINT" > "${CHECKPOINT}.tmp"
  mv "${CHECKPOINT}.tmp" "$CHECKPOINT"

  # Cleanup question file
  mv "$QUESTION_FILE" ~/.claude/questions/answered/${QUESTION_ID}.json

  # Relaunch subagent with answer
  claude -p "Resume workflow from checkpoint: ${CHECKPOINT}. User selected: oauth. Continue implementation." \
    --dangerously-skip-permissions

elif [[ "$SUBAGENT_OUTPUT" == *"WORKFLOW_COMPLETE"* ]]; then
  # Quick response path succeeded - workflow done!
  echo "Workflow completed successfully via quick response path"
fi
```

### Pattern: Subagent Resumes After Escalation

**Relaunched subagent after main agent gets answer:**

```bash
# Read checkpoint (includes user answer from main agent)
CHECKPOINT_FILE="/tmp/workflow_${WORKFLOW_ID}_checkpoint.json"
CHECKPOINT=$(cat "$CHECKPOINT_FILE")
USER_CHOICE=$(echo "$CHECKPOINT" | jq -r '.user_answer')

# Restore state from checkpoint
CURRENT_STEP=$(echo "$CHECKPOINT" | jq -r '.current_step')
COMPLETED_STEPS=$(echo "$CHECKPOINT" | jq -r '.completed_steps[]')
PENDING_STEPS=$(echo "$CHECKPOINT" | jq -r '.pending_steps[]')

# Continue from exactly where we left off
case "$USER_CHOICE" in
  oauth)
    # Implement OAuth...
    ;;
  jwt)
    # Implement JWT...
    ;;
esac

# Continue with remaining workflow steps...
echo "WORKFLOW_COMPLETE"
exit 0
```

## User Tools

### Quick Response Helper Script

**`~/bin/claude-answer`** - For users to quickly respond to subagent questions:

```bash
#!/bin/bash
# Helper for users to quickly respond to subagent questions

QUESTIONS_DIR=~/.claude/questions/pending
ANSWERS_DIR=~/.claude/answers

# Create answers dir if needed
mkdir -p "$ANSWERS_DIR"

# List pending questions
echo "=== Pending Questions ==="
for qfile in "$QUESTIONS_DIR"/*.json; do
  [ -e "$qfile" ] || continue

  QUESTION_ID=$(basename "$qfile" .json)
  QUESTION=$(jq -r '.question' "$qfile")
  OPTIONS=$(jq -r '.options[]' "$qfile" | paste -sd '|')
  ASKED_AT=$(jq -r '.asked_at' "$qfile")

  echo ""
  echo "ID: $QUESTION_ID"
  echo "Asked: $ASKED_AT"
  echo "Question: $QUESTION"
  echo "Options: $OPTIONS"
done

echo ""
read -p "Question ID to answer: " QUESTION_ID
read -p "Your answer: " ANSWER

# Write answer
echo "$ANSWER" > "$ANSWERS_DIR/${QUESTION_ID}.txt"
echo "Answer saved! Subagent will pick it up."
```

**Usage:**
```bash
# User sees notification
# User runs helper script
$ claude-answer

=== Pending Questions ===

ID: workflow_1729350000_q1
Asked: 2025-10-19T14:32:00Z
Question: Which auth method: OAuth or JWT?
Options: oauth|jwt

Question ID to answer: workflow_1729350000_q1
Your answer: oauth
Answer saved! Subagent will pick it up.
```

### Manual Quick Response

Users can also respond manually without the helper script:

```bash
# User sees notification with file path
$ echo "oauth" > ~/.claude/answers/workflow_1729350000_q1.txt
```

## Timeout Safety Margins

```
10:00 - Total Bash timeout limit (hard constraint)
 8:00 - Maximum safe quick-wait (aggressive)
 5:00 - Conservative quick-wait (recommended)
 2:00 - Buffer for checkpoint saving, file operations, cleanup
```

**Recommendation:** Use **5-minute quick-wait** to provide comfortable safety margin.

## Key Advantages

✅ **Fast path for quick responses** - If user is present and responsive, workflow completes without interruption
✅ **Graceful degradation** - If user is slow/absent, cleanly hands off to main agent
✅ **No timeout pressure** - Conservative 5-minute quick-wait leaves safety margin
✅ **User choice** - User can respond via quick file method OR wait for UI prompt
✅ **No wasted work** - Subagent doesn't repeat work; checkpoint preserves state
✅ **No context bloat** - Only one relaunch if escalation needed
✅ **Unlimited wait time** - Main agent can wait indefinitely via `/resume`
✅ **Clean state management** - Checkpoint contains exactly what's needed
✅ **Works at any nesting level** - Pattern applies to deeply nested subagents

## User Experience Scenarios

### Scenario 1: User Is Present and Quick

```
Notification: "Claude Question: Auth method needed"
User runs: claude-answer → selects oauth
Subagent: Receives answer in 30 seconds, continues, completes
Total time: ~2 minutes
Token cost: Minimal (single subagent run)
```

### Scenario 2: User Is Busy/Away

```
Notification: "Claude Question: Auth method needed"
User: Ignores for now (in meeting, away from desk, etc.)
Subagent: Times out after 5 min, escalates, exits cleanly
Main agent: Detects escalation, uses AskUserQuestion in UI
User: Returns 2 hours later, sees question in Claude Code UI, responds
Main agent: Relaunches subagent with answer
Subagent: Loads checkpoint, continues, completes
Total time: 2+ hours (no problem)
Token cost: Moderate (subagent runs twice, but with minimal context)
```

### Scenario 3: User Chooses to Wait for UI

```
Notification: "Claude Question: Auth method needed"
User: Prefers to answer via Claude Code UI, ignores file-based option
Subagent: Times out after 5 min, escalates
Main agent: Asks via UI (user's preferred method)
User: Answers immediately via UI
Main agent: Relaunches subagent
Subagent: Completes
Total time: ~7 minutes
Token cost: Moderate (intentional trade-off for UX preference)
```

## File Format Specifications

### Question File Format

**Location:** `~/.claude/questions/pending/${QUESTION_ID}.json`

```json
{
  "question": "The question text for the user",
  "options": ["option1", "option2", "option3"],
  "workflow_id": "unique_workflow_identifier",
  "checkpoint": "/absolute/path/to/checkpoint.json",
  "asked_at": "2025-10-19T14:32:00Z",
  "asked_by": "subagent_name",
  "context": "Brief context about why this question is being asked"
}
```

### Answer File Format (Quick Response)

**Location:** `~/.claude/answers/${QUESTION_ID}.txt`

**Content:** Plain text, single line with the answer
```
oauth
```

### Checkpoint File Format

**Location:** `/tmp/${WORKFLOW_ID}_checkpoint.json`

```json
{
  "workflow_id": "unique_identifier",
  "workflow_type": "document_update_review",
  "current_step": "step_name",
  "completed_steps": ["step1", "step2"],
  "pending_steps": ["step4", "step5"],
  "files": {
    "key": "/absolute/path/to/file"
  },
  "state_variables": {
    "any": "workflow-specific state"
  },
  "context": "Human-readable context about where workflow is",
  "next_action": "What to do after user responds",
  "user_answer": null  // Filled in by main agent after escalation
}
```

## Error Handling

### Quick Response Path Errors

**Answer file contains invalid option:**
```bash
ANSWER=$(cat ~/.claude/answers/${QUESTION_ID}.txt)

# Validate answer against options
if [[ ! " ${VALID_OPTIONS[@]} " =~ " ${ANSWER} " ]]; then
  # Invalid - escalate to main agent for proper validation
  echo "Invalid quick response: $ANSWER. Escalating to main agent..."
  # Fall through to escalation path
fi
```

**Answer file is corrupted/unreadable:**
```bash
if [ -f ~/.claude/answers/${QUESTION_ID}.txt ]; then
  ANSWER=$(cat ~/.claude/answers/${QUESTION_ID}.txt 2>/dev/null)
  if [ $? -ne 0 ] || [ -z "$ANSWER" ]; then
    # Corrupted - ignore and continue waiting or escalate
    rm ~/.claude/answers/${QUESTION_ID}.txt
    continue
  fi
fi
```

### Escalation Path Errors

**Question file missing/corrupted:**
```bash
# Main agent trying to read escalated question
if [ ! -f "$QUESTION_FILE" ]; then
  echo "ERROR: Question file missing for ${QUESTION_ID}"
  # Report to user, may need to restart workflow
  exit 1
fi
```

**Checkpoint file missing/corrupted:**
```bash
# Relaunched subagent trying to load checkpoint
if [ ! -f "$CHECKPOINT_FILE" ]; then
  echo "ERROR: Checkpoint file missing. Cannot resume workflow."
  exit 1
fi

# Validate checkpoint has required fields
USER_ANSWER=$(jq -r '.user_answer' "$CHECKPOINT_FILE" 2>/dev/null)
if [ -z "$USER_ANSWER" ] || [ "$USER_ANSWER" = "null" ]; then
  echo "ERROR: Checkpoint missing user_answer. Cannot resume."
  exit 1
fi
```

### Directory Permissions

**Ensure directories exist and are writable:**
```bash
# Initialization (run once, or check in each subagent)
mkdir -p ~/.claude/questions/pending
mkdir -p ~/.claude/questions/answered
mkdir -p ~/.claude/answers
mkdir -p /tmp/workflows

# Verify write permissions
if [ ! -w ~/.claude/questions/pending ]; then
  echo "ERROR: Cannot write to ~/.claude/questions/pending"
  exit 1
fi
```

## Integration with Document Update Review Protocol

The Document Update Review Protocol can be enhanced to use this hybrid approach:

### Step 3: Pre-Implementation Review Agent

**When review agent finds issues needing user decision:**

```bash
# Review found: content overlap requires user decision
QUESTION_ID="${WORKFLOW_ID}_review_decision"

# Create question for both paths
cat > ~/.claude/questions/pending/${QUESTION_ID}.json <<EOF
{
  "question": "Review found content overlap. How should we proceed?",
  "options": ["merge", "restructure", "proceed"],
  "workflow_id": "${WORKFLOW_ID}",
  "checkpoint": "/tmp/${WORKFLOW_ID}_checkpoint.json",
  "asked_at": "$(date -Iseconds)",
  "context": "Pre-implementation review found duplicate coverage between new section and existing 'Test Execution Standards' section"
}
EOF

# Try quick response (5 min timeout)
notify-send "Claude Code - Document Review" "User decision needed. See: ~/.claude/questions/pending/${QUESTION_ID}.json"

# Poll with timeout...
# (Same polling logic as above)

# If quick response: Update proposed changes and continue
# If escalation: Save checkpoint and exit for main agent handling
```

This makes the entire protocol responsive to user availability while maintaining robustness.

## Future Enhancements

### Enhanced Notification System

Instead of basic `notify-send`, create richer notifications:
- **Desktop notification with action buttons** (if desktop environment supports it)
- **Sound alerts** for urgent questions
- **Integration with system tray** showing pending question count

### Question Queuing

Support for multiple questions from single subagent:
```json
{
  "questions": [
    {"id": "q1", "question": "...", "options": [...]},
    {"id": "q2", "question": "...", "options": [...]}
  ],
  "workflow_id": "...",
  "all_required": true  // Must answer all before continuing
}
```

### Smart Timeout Adjustment

Adjust timeout based on question complexity:
```bash
# Simple yes/no - short timeout (2 min)
MAX_QUICK_WAIT=120

# Complex architectural decision - longer timeout (7 min)
MAX_QUICK_WAIT=420
```

### Answer Validation

More sophisticated validation in quick response path:
```bash
# Define validators per question type
validate_answer() {
  local question_type=$1
  local answer=$2

  case "$question_type" in
    choice)
      # Validate against allowed options
      ;;
    path)
      # Validate path exists
      ;;
    regex)
      # Validate against regex pattern
      ;;
  esac
}
```

### Audit Trail

Log all questions and answers:
```bash
cat >> ~/.claude/audit/questions.log <<EOF
$(date -Iseconds) | ${QUESTION_ID} | ${QUESTION} | ${ANSWER} | ${RESPONSE_TIME}s | ${PATH}
EOF
```

### Web-Based Question UI

For users who prefer graphical interfaces:
- Local web server showing pending questions
- Browser-based response form
- Real-time updates when questions arrive
- Still uses same file-based backend

## Comparison: Version 1 vs Version 2

| Aspect | Version 1 | Version 2 |
|--------|-----------|-----------|
| **Quick user response** | ❌ Always escalates | ✅ Tries quick path first |
| **Slow user response** | ✅ Handles well | ✅ Handles well |
| **Token efficiency (quick user)** | ❌ Moderate (always relaunches) | ✅ High (single run) |
| **Token efficiency (slow user)** | ✅ Moderate (one relaunch) | ✅ Moderate (one relaunch) |
| **User experience** | 🟡 Always UI-based | ✅ User choice of method |
| **Complexity** | ✅ Simpler | 🟡 More complex |
| **Risk of timeout** | ✅ Zero risk | ✅ Zero risk (with safety margin) |
| **Best for** | Always-slow responses | Mixed response times |

## Recommendation

**Use Version 2 (Hybrid) when:**
- Users are sometimes available for quick responses
- Workflow benefits significantly from fast completion
- User base is comfortable with file-based quick responses

**Use Version 1 (Always Escalate) when:**
- Users are rarely available quickly
- Simplicity is valued over optimization
- All interactions should be UI-based for consistency

**For most use cases, Version 2 provides the best balance of performance and robustness.**
