# Subagent User Communication Design - Version 1

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

## Solution: Main Agent as Orchestrator with Clean Handoff

### Core Principle

**Subagents never wait for user input.** Instead, they checkpoint state, post questions, and exit cleanly. The main agent mediates all user interaction and relaunches subagents with answers.

### Architecture Components

**Directory Structure:**
```
~/.claude/questions/
├── pending/          # Subagents post questions here
└── answered/         # Main agent writes answers here (optional)

/tmp/workflows/       # Workflow checkpoint files
```

### Pattern: Subagent Needs User Input

**When subagent encounters a decision point requiring user input:**

```bash
# Save complete state checkpoint
cat > /tmp/workflow_${WORKFLOW_ID}_checkpoint.json <<EOF
{
  "workflow_id": "${WORKFLOW_ID}",
  "current_step": "pre_implementation_review",
  "completed_steps": ["draft_changes", "create_backup"],
  "files": {
    "proposed_changes": "/tmp/doc_proposed_changes_123.md",
    "backup": "/tmp/doc_backup_123.md",
    "original": "/path/to/doc.md"
  },
  "context": "Review found merge conflict issue. Need user decision on approach.",
  "next_action": "apply_user_choice_and_continue"
}
EOF

# Post question for main agent
cat > ~/.claude/questions/pending/${WORKFLOW_ID}.json <<EOF
{
  "question": "Review found content overlap. How should we proceed?",
  "options": {
    "merge": "Merge into existing section",
    "restructure": "Restructure both sections",
    "proceed": "Proceed with cross-references"
  },
  "workflow_id": "${WORKFLOW_ID}",
  "checkpoint": "/tmp/workflow_${WORKFLOW_ID}_checkpoint.json"
}
EOF

# Exit cleanly - job done for now
echo "QUESTION_POSTED:${WORKFLOW_ID}"
exit 0  # Normal exit, not error
```

### Pattern: Main Agent Handles Question

**Main agent (running in Claude Code UI):**

```bash
# After subagent completes, check if question posted
if [ -f ~/.claude/questions/pending/${WORKFLOW_ID}.json ]; then
  # Read question details
  QUESTION_FILE=~/.claude/questions/pending/${WORKFLOW_ID}.json
  QUESTION=$(jq -r '.question' "$QUESTION_FILE")
  CHECKPOINT=$(jq -r '.checkpoint' "$QUESTION_FILE")

  # Use AskUserQuestion tool (can wait indefinitely)
  # User responds (minutes, hours, days later - doesn't matter)
  # User chose: "restructure"

  # Write answer to checkpoint
  jq '.user_answer = "restructure"' "$CHECKPOINT" > "${CHECKPOINT}.tmp"
  mv "${CHECKPOINT}.tmp" "$CHECKPOINT"

  # Move question to answered (cleanup)
  mv "$QUESTION_FILE" ~/.claude/questions/answered/${WORKFLOW_ID}.json

  # Relaunch subagent with updated checkpoint
  claude -p "Resume workflow from checkpoint at ${CHECKPOINT}.
             User chose: restructure. Continue with next steps." \
    --dangerously-skip-permissions
fi
```

### Pattern: Subagent Resumes with Answer

**Relaunched subagent:**

```bash
# Read checkpoint (includes user answer now)
CHECKPOINT_FILE="/tmp/workflow_${WORKFLOW_ID}_checkpoint.json"
CHECKPOINT=$(cat "$CHECKPOINT_FILE")
USER_CHOICE=$(echo "$CHECKPOINT" | jq -r '.user_answer')

# Restore state from checkpoint
CURRENT_STEP=$(echo "$CHECKPOINT" | jq -r '.current_step')
PROPOSED_CHANGES=$(echo "$CHECKPOINT" | jq -r '.files.proposed_changes')
BACKUP=$(echo "$CHECKPOINT" | jq -r '.files.backup')
ORIGINAL=$(echo "$CHECKPOINT" | jq -r '.files.original')

# Continue from exactly where we left off
case "$USER_CHOICE" in
  restructure)
    # Update proposed changes with restructuring approach
    # Continue workflow from current_step...
    ;;
  merge)
    # Update proposed changes with merge approach
    # Continue workflow...
    ;;
  proceed)
    # Add cross-references to proposed changes
    # Continue workflow...
    ;;
esac

# Continue with remaining workflow steps...
```

## Complete Flow Example

### Scenario: Document Update Review Protocol

```
Main Agent: "Update document X with new section Y"
   ↓
   Launches Subagent A: "Execute document update workflow for doc X"
   ↓
Subagent A:
   - Step 1: Draft proposed changes ✓
   - Step 2: Create backup ✓
   - Step 3: Launch pre-implementation review
   ↓
   Review finds content overlap issue
   ↓
   Saves checkpoint (completed steps, file paths, context)
   Posts question to ~/.claude/questions/pending/workflow_12345.json
   Exits normally (exit 0)
   ↓
Main Agent:
   Detects question file exists
   Reads question: "How to handle content overlap?"
   Uses AskUserQuestion tool
   ↓
   [User takes 2 hours to respond - no problem, main agent waits]
   ↓
   User selects: "restructure"
   Main agent updates checkpoint with answer
   Relaunches workflow subagent
   ↓
Subagent B (fresh context, but with checkpoint):
   Loads checkpoint from /tmp/workflow_12345_checkpoint.json
   Sees user_answer = "restructure"
   Sees completed_steps = ["draft_changes", "create_backup"]
   Sees current_step = "pre_implementation_review"
   ↓
   Updates proposed changes document with restructure approach
   Continues with Step 4: Launch implementation agent
   Continues with Step 5: Launch validation agent
   Completes workflow
   Returns final report to main agent
   ↓
Main Agent:
   Receives completion report
   Presents results to user
```

## Key Advantages

✅ **Zero context bloat** - Each subagent launch has clean, minimal context
✅ **Unlimited wait time** - Main agent can wait indefinitely via `/resume`
✅ **Clean state** - Checkpoint contains exactly what's needed, nothing more
✅ **No retries/loops** - Subagent exits once, gets relaunched once with answer
✅ **Main agent orchestrates** - Aligns with Claude Code's design
✅ **Works at any nesting level** - Questions bubble up through exit codes/files
✅ **Stateful via explicit checkpoints** - All state preserved in structured files

## Implementation Considerations

### Checkpoint File Format

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
  "user_answer": null  // Filled in by main agent
}
```

### Question File Format

```json
{
  "question": "The question text for the user",
  "options": {
    "option_key": "Option description",
    "another_key": "Another option"
  },
  "workflow_id": "matches checkpoint workflow_id",
  "checkpoint": "/absolute/path/to/checkpoint.json",
  "timestamp": "2025-10-19T14:32:00Z",
  "asked_by": "review-agent-L2"
}
```

### Error Handling

**Question posting fails:**
- Subagent should exit with error and report to parent
- Parent bubbles up to main agent
- Main agent reports error to user

**Checkpoint file missing/corrupted:**
- Relaunched subagent should detect and report
- Main agent should handle gracefully (may need to restart workflow)

**User cancels/abandons workflow:**
- Main agent can clean up pending questions and checkpoints
- Workflow state preserved for potential resume later

### Integration with Document Update Review Protocol

The Document Update Review Protocol could be updated to:
1. Accept a `WORKFLOW_ID` parameter
2. Create checkpoints at each step boundary
3. Post questions when review/validation finds issues requiring user decision
4. Resume from checkpoint when relaunched

This would make the protocol fully compatible with >10 minute user response times.

## Alternative Considered: Polling with Timeout Extension

**Why rejected:** Repeatedly relaunching a subagent with "keep waiting" messages would:
- Bloat context (each relaunch adds checkpoint + "still waiting" message)
- Degrade performance (massive context after 30+ relaunches)
- Waste tokens (exponentially expensive)
- Risk coherence loss (subagent loses track amid noise)

The clean handoff pattern is superior because each subagent invocation remains focused and efficient.

## Future Enhancements

- **Helper functions:** Create bash library for checkpoint save/load, question posting
- **Workflow registry:** Track all active workflows and their states
- **Timeout handling:** Optional timeout on questions (if user never responds)
- **Multi-question batching:** Allow subagent to post multiple questions at once
- **Rich question types:** Support for different question formats (yes/no, multiple choice, free text)
- **Audit trail:** Log all questions and answers for debugging/review
