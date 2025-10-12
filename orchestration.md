# Orchestration

Multi-agent coordination system for managing complex tasks across specialized Claude agents.

## Architecture Overview

### Agent Types

#### Workflow Architecture Group
The Workflow Architecture Group consists of specialized agents that handle workflow design, adaptation, and coordination:

- **Workflow Designer Agent**: Creates initial multi-agent workflow designs from conversation summaries with validation checkpoints
- **Risk Assessment & Validation Agent**: Identifies risky assumptions during design, inserts Proof of Concept (PoC) tasks, validates PoC evidence
- **Workflow Adaptation Agent**: Makes surgical runtime updates to workflow plans (laser-focused on workflow modifications only)
- **Escalation Resolution Agent**: Handles rare/unexpected escalations that slip through design and risk assessment processes
- **[TBD] Loop Detection & Resolution**: Detects repeated escalations, analyzes root causes, restructures workflows
- **[TBD] Archival Coordinator**: Invokes Archival Agent at workflow start/end

#### Execution & Work Agents
- **Design Verifier Agent**: Reviews workflow designs for completeness and consistency before execution
- **Workflow Executor**: Executes the workflow plan by launching agents in sequence specified by Workflow Architecture Group. Does not make planning or sequencing decisions.
- **Solution Architect Agent**: Makes technical architecture decisions, reviews architecture-related escalations from doer agents
- **Do'er Agents**: Perform specific work (database, API, frontend, etc.)
- **Verifier Agents**: Validate do'er agent outputs and completion drive reviews
- **Archival Agent**: Manages session cleanup and token optimization
- **Plan Development Agent**: Conducts structured requirements gathering conversation with user, produces conversation summary

### Agent Invocation Patterns

The orchestration system uses two different patterns for agent activation:

#### Interactive Agents (Slash Command Pattern)
These agents are activated via slash commands and engage in interactive conversation with the user in the main Claude session:

- **Plan Development Agent** (e.g., `/persona-plan-developer`) - Requirements gathering conversation
- **Workflow Designer Agent** (e.g., `/persona-workflow-designer`) - Interactive workflow design with clarifying questions
- **Design Verifier Agent** (e.g., `/persona-design-verifier`) - Review and discussion of workflow design
- **Workflow Executor** (e.g., `/persona-workflow-executor`) - Orchestrates execution, handles escalations interactively
- **Risk Assessment & Validation Agent** (invoked by Workflow Designer) - Collaborative risk analysis
- **Escalation Resolution Agent** (invoked by Workflow Executor) - Interactive resolution of blocked agents
- **Workflow Adaptation Agent** (invoked by Escalation Resolution or Risk Assessment) - Collaborative workflow updates

**Characteristics:**
- User can ask questions and get immediate responses
- Agent can ask clarifying questions
- Conversation continues until user exits the agent persona
- Same Claude session, different persona/role

#### Autonomous Agents (Task Tool Pattern)
These agents are launched via Task tool for autonomous work without user interaction:

- **Do'er Agents** (SQL agent, API agent, database agent, frontend agent, etc.)
- **Verifier Agents** (validate do'er agent outputs)
- **Solution Architect Agent** (works like doer agent when invoked for specific architecture decisions)
- **Archival Agent** (session cleanup at workflow start/end)

**Characteristics:**
- Launched by Workflow Executor (or other interactive agents)
- Read agent_instructions.md for task-specific guidance
- Work autonomously without conversation
- Return final report when complete
- Fresh agent instance for each invocation

### Directory Structure
```
project/
├── orchestration/
│   ├── conversation_summary_[taskname].md    # plan context for Workflow Designer Agent
│   ├── workflow_coordination_plan.md         # workflow design for Workflow Executor
│   ├── shared_status.json                    # overall coordination state
│   └── agents/
│       ├── solution_architect_agent/
│       │   ├── agent_instructions.md         # architecture decision tasks
│       │   ├── completion_drive/
│       │   │   ├── session_current.json
│       │   │   └── session_20250928_1430_create_user_table.json
│       │   └── task_output/                  # architecture decisions, design guidance
│       ├── database_agent/
│       │   ├── agent_instructions.md         # specific instructions for this agent
│       │   ├── completion_drive/
│       │   │   ├── session_current.json
│       │   │   └── session_20250928_1430_create_user_table.json
│       │   ├── verification_results.json     # feedback from verifier (if verification failed)
│       │   └── task_output/                  # outputs for downstream agents
│       ├── api_agent/
│       │   ├── agent_instructions.md
│       │   ├── completion_drive/
│       │   └── task_output/
│       ├── verifier_agent/
│       │   ├── agent_instructions.md
│       │   └── completion_drive/
│       └── archival_agent/
│           ├── agent_instructions.md
│           ├── completion_drive/
│           ├── cleanup_log.json
│           └── archive_index.json
```

## Shared Status Coordination

### shared_status.json Structure
```json
{
  "task_id": "implement_user_management",
  "status": "in_progress",
  "session_start": 1727539800,
  "agents": {
    "database_agent": {
      "status": "completion_drive_review",
      "completion_drive_notes_count": 3,
      "unresolved_notes": 1,
      "last_update": 1727540700
    },
    "api_agent": {
      "status": "working",
      "completion_drive_notes_count": 0,
      "last_update": 1727539800
    },
    "frontend_agent": {
      "status": "pending",
      "completion_drive_notes_count": 0,
      "dependencies": ["database_agent", "api_agent"],
      "last_update": null
    }
  },
  "verification": {
    "database_verifier": {
      "status": "pending",
      "assigned_agents": ["database_agent"]
    }
  },
  "overall_completion_drive_gate": "blocked"
}
```

### Agent Status Values
- `pending` - not started, waiting for dependencies
- `working` - actively performing assigned work
- `completion_drive_review` - reviewing assumptions before claiming done
- `ready_for_verification` - passed completion drive review
- `verified` - verifier approved work output
- `blocked` - needs orchestrator/user input
- `session_complete` - orchestrator marked task complete

## Session Management

### Session Lifecycle
1. **Session Start**: Workflow Executor assigns task → agents create `session_current.json`
2. **Work Phase**: Agents perform work, track completion drive notes
3. **Completion Review**: Agents resolve completion drive notes
4. **Verification**: Verifier agents validate work and completion drive reviews
5. **Session End**: Workflow Executor signals "task complete" → archival agent archives session files

### Session Boundaries
- **Controlled by Workflow Executor**: Only workflow executor determines when task is complete
- **Triggers archival**: Session end signal moves `session_current.json` → `session_YYYYMMDD_HHMM_taskname.json`
- **Clean context**: New sessions start with fresh completion drive context

## Completion Drive Integration

### Mandatory Gates
- **No "done" without review**: Agents cannot report completion until all completion drive notes are resolved or escalated
- **Workflow Executor enforcement**: `overall_completion_drive_gate` blocks task completion while unresolved notes exist
- **Verifier validation**: Verifiers must review both work output AND completion drive resolution

### Token Management
- **Session-based archival**: Only current session files loaded into agent context
- **Automatic cleanup**: Archival agent moves resolved completion drive notes to timestamped archives
- **Context optimization**: Agents only read `session_current.json` for completion drive context

### Completion Drive File Format

**Timestamp Standard:** All timestamps across all orchestration files use **Unix epoch integers** (not ISO strings) for consistency and efficient comparison.

Each agent maintains a `session_current.json` file in their `completion_drive/` directory with the following structure:

```json
{
  "task_id": "create_user_table_1727539200",
  "session_start": 1727539800,
  "notes": [
    {
      "note_id": "note_001",
      "timestamp": 1727540700,
      "description": "Assuming email field should be unique",
      "context": "Creating users table without explicit uniqueness requirements",
      "status": "resolved",
      "resolution": "Confirmed with user - email uniqueness required",
      "resolved_by": "workflow_executor",
      "resolution_timestamp": 1727541600,
      "escalation_reason": null
    }
  ]
}
```

#### Field Specifications

**File-level fields:**
- `task_id` (string, required): Task identifier in format `{slug}_{unix_epoch_timestamp}`
  - Generated by Workflow Designer Agent when creating task
  - Example: `create_user_table_1727539200`, `api_endpoint_design_1727539284`
  - Must be unique across the workflow (validated by Design Verifier Agent)
- `session_start` (integer, required): Unix epoch timestamp when agent starts execution
  - Generated by doer agent when creating session_current.json
  - Marks when agent begins working on the task (not when assigned)

**Note-level fields:**
- `note_id` (string, required): Simple sequential identifier (note_001, note_002, etc.)
  - Generated by doer agent when creating each note
  - Must be unique within this session only (not globally unique)
  - Used for referencing specific notes in discussions/feedback
- `timestamp` (integer, required): Unix epoch timestamp when the note was created
- `description` (string, required): What assumption or uncertainty was encountered
- `context` (string, required): What the agent was doing when this arose
- `status` (enum, required): `"open"` | `"resolved"` | `"escalated"`
- `resolution` (string, required if status=resolved): How the note was addressed
- `resolved_by` (enum, required if status=resolved): `"agent_self"` | `"workflow_executor"` | `"user"`
- `resolution_timestamp` (integer, required if status=resolved): Unix epoch timestamp when resolved
- `escalation_reason` (string, required if status=escalated): Why this needs orchestrator/user input

#### Note Lifecycle
1. **Creation**: Agent encounters assumption/uncertainty → creates note with `status: "open"`
   - Notes can be created during both `working` and `completion_drive_review` statuses
   - Agent discovers issues during work OR during review of completed work
2. **During work**: Note remains open while agent continues other work
3. **Completion review**: Agent reviews all open notes when transitioning to `completion_drive_review` status
   - May discover new issues during review and create additional notes
4. **Resolution paths**:
   - Agent can resolve directly → `status: "resolved"`, `resolved_by: "agent_self"`
   - Agent escalates → `status: "escalated"` with `escalation_reason`
   - Workflow Executor provides clarification → `status: "resolved"`, `resolved_by: "workflow_executor"`
   - User provides clarification → `status: "resolved"`, `resolved_by: "user"`

#### Escalation Rules for Doer Agents

Doer agents must understand when to self-resolve vs escalate completion drive notes. These rules ensure appropriate decision-making authority.

**MUST ESCALATE (cannot self-resolve):**
- **Technology/tool choices**: Programming languages, frameworks, libraries, databases
  - Example: "Should I use Python or bash to parse this log file?" → Escalate to Solution Architect
  - Even if technology seems obvious, doer agents lack authority to make these decisions
- **Architecture decisions**: System design, component structure, integration patterns
  - Example: "Should this be REST or GraphQL?" → Escalate to Solution Architect
- **Security decisions**: Authentication methods, encryption algorithms, access control patterns
  - Example: "Which password hashing algorithm?" → Escalate to Solution Architect
- **Requirements assumptions**: Business logic, data constraints, user requirements
  - Example: "Should email be unique?" → Escalate to user via Escalation Resolution Agent
- **Conflicting guidance**: Contradictions between agent_instructions.md, conversation_summary.md, or other documentation
  - Example: "Instructions say optimize for speed but summary emphasizes accuracy" → Escalate to Escalation Resolution Agent

**CAN SELF-RESOLVE:**
- **Code consistency fixes**: Naming conventions, formatting, matching existing patterns
  - Example: "Field name should be capitalized to match other tables" → Self-resolve with evidence
- **Obvious bugs**: Clear errors in logic or implementation
  - Example: "Off-by-one error in loop counter" → Self-resolve with fix
- **Implementation details**: Low-level choices within already-established technology/architecture
  - Example: "Variable name for loop counter" → Self-resolve
  - Example: "Function organization within already-specified module" → Self-resolve
- **Documentation improvements**: Comments, README updates, inline documentation
  - Example: "Add comment explaining algorithm" → Self-resolve

**When in doubt, escalate.** Doer agents should prefer escalation over making assumptions about authority.

**Note**: Escalation rules are embedded in each agent's `agent_instructions.md` file. Workflow Designer Agent uses agent instruction templates (`~/.claude/protocols/orchestration_doer_agent_template.md`) to ensure consistent escalation guidance across all doer agents. See "Critical Issues Requiring Resolution: Issue 1" for template requirements.

## Risk Assessment & Proof of Concept Workflow

### Design Philosophy: Proactive vs Reactive Risk Management

**Key Principle:** Escalations during workflow execution should be **rare failure modes**, not normal operation. If doer agents frequently escalate with design questions or assumption uncertainties, this indicates inadequate workflow design.

**Proactive approach:** Identify risky assumptions during workflow design and insert Proof of Concept (PoC) tasks to validate them early, before main workflow execution begins.

### Risk Assessment Architecture

**Core Insight:** Risk identification requires specialized domain knowledge. Rather than expecting a single agent to understand risks across all technologies, we leverage:
1. Specialized Doer agents who understand their technology domains
2. Technology best practices research from the internet
3. Synthesis of both sources into actionable PoC recommendations

**Architecture:** Risk Assessment is coordinated by a Risk Assessment Coordinator Agent that orchestrates multiple specialized sub-agents.

### Risk Assessment Coordinator Agent

The Risk Assessment Coordinator Agent drives the risk assessment process and works in two phases:

#### Phase 1: During Workflow Design (works with Workflow Designer Agent)

**Timing:** After Workflow Designer Agent creates initial workflow design, before Design Verifier Agent review

**Inputs:**
- Conversation summary
- Draft workflow plan from Workflow Designer Agent
- Agent roster (from Agent Roster Designer)

**Specialized Sub-Agents:**

1. **Technology Best Practices Research Agent(s)** (Claude agent via Task tool)
   - Searches internet for best practices for specific technologies identified in workflow
   - Searches for common failure patterns and technology-specific risks
   - May leverage MCP servers for enhanced research capabilities
   - Output: Best practices documentation per technology/task type
   - **Storage:** Research preserved long-term for reuse across workflows (storage location TBD)

2. **Doer Agent Consultation** (coordinated by Risk Coordinator)
   - Risk Coordinator identifies which specialized Doer agents to consult based on agent roster
   - Consults Doer agents (via prompts/questions) for technology-specific risk identification
   - Doer agents provide domain expertise on risks in their specialty areas
   - Output: Technology-specific risk assessments from domain experts

3. **PoC Recommendation Agent** (Claude agent via Task tool)
   - Takes research outputs + doer consultations
   - Synthesizes inputs into specific PoC task recommendations
   - Specifies evidence requirements for each PoC (what success/failure looks like)
   - Output: PoC task specifications with success/failure criteria

4. **PoC Integration Agent** (Claude agent via Task tool)
   - Takes PoC recommendations + workflow sequence
   - Determines where PoCs should run (early, before dependent tasks)
   - Updates workflow sequence to include PoCs in correct positions
   - Output: Updated workflow sequence with PoCs integrated

5. **Best Practices Integration Agent** (Claude agent via Task tool)
   - Takes best practices research + agent roster + agent instructions (drafts)
   - Embeds relevant best practices into each Doer agent's instructions
   - Ensures Doer agents follow best practices during work (not just risk assessment)
   - Output: Enhanced agent instructions with embedded best practices

**Coordinator Outputs:**
- Risk assessment report
- PoC task specifications with success/failure criteria
- Updated workflow plan with PoC tasks integrated
- Enhanced agent instructions with best practices embedded
- Preserved research for long-term reuse

**Example risky assumptions:**
- "Database schema migration will work without conflicts"
- "Third-party API rate limits won't affect our workflow"
- "Legacy codebase uses consistent naming patterns"
- "Performance requirements are achievable with current architecture"

#### Phase 2: During Workflow Execution (after PoC completion)

**Timing:** After each PoC task completes and produces evidence

**Inputs:**
- PoC task outputs and evidence from doer agent's `task_output/`
- Original risk assessment and success/failure criteria

**Specialized Sub-Agents:**

1. **PoC Evidence Reviewer Agent** (Claude agent via Task tool)
   - Reads PoC task outputs and evidence
   - Compares evidence against predefined success/failure criteria
   - Output: Evidence assessment (pass/partial/fail) with rationale

2. **PoC Decision Agent** (Claude agent via Task tool)
   - Takes evidence assessment
   - Determines outcome: **proceed as planned** / **adapt workflow** / **escalate to user**
   - If adapt: specifies required changes for Workflow Adaptation Agent
   - Output: Decision with rationale and action requirements

**Coordinator Outputs:**
- PoC validation decision with rationale
- Workflow adaptation requirements (if needed)
- Triggers Workflow Adaptation Agent if structural changes required

**Decision outcomes:**
- **Proceed as planned:** Assumption validated, continue with original workflow
- **Adapt workflow:** Assumption partially validated, requires workflow adjustments (e.g., add error handling, change approach, add intermediate tasks)
- **Escalate to user:** Assumption invalidated, fundamental approach needs reconsideration

### Best Practices Flow

**Critical Design Principle:** Best practices research flows to two destinations:
1. **PoC recommendations** - Inform what to validate
2. **Doer agent instructions** - Ensure work follows best practices (proactive risk reduction)

This dual flow ensures risks are both detected (via PoC) and prevented (via best practices adherence).

### Updated Workflow Design Sequence

```
1. User activates Plan Development Agent (slash command: /persona-plan-developer)
2. Plan Development Agent conducts requirements gathering conversation
3. Plan Development Agent writes conversation_summary_[taskname].md
4. User exits Plan Development Agent
5. User activates Workflow Designer Agent (slash command: /persona-workflow-designer)
6. Workflow Designer Agent creates initial workflow design
7. Workflow Designer Agent invokes Risk Assessment & Validation Agent (interactive collaboration)
8. Risk Assessment Agent analyzes for risky assumptions, inserts PoC tasks where needed
9. User exits Workflow Designer Agent (or continues to Design Verifier)
10. User activates Design Verifier Agent (slash command: /persona-design-verifier)
11. Design Verifier Agent reviews complete design (including PoCs)
12. User approves final design
13. User activates Workflow Executor (slash command: /persona-workflow-executor)
14. Workflow execution begins - Executor launches autonomous agents via Task tool
    ↓
15. PoC tasks execute early in workflow (before dependent tasks) - autonomous agents via Task tool
16. Workflow Executor invokes Risk Assessment Agent (interactive) to review PoC evidence
17. If needed: Risk Assessment Agent invokes Workflow Adaptation Agent (interactive) to adjust plan
18. Main workflow continues with validated assumptions - autonomous agents via Task tool
```

**Note**: Steps 1-13 use interactive agents (slash commands), steps 14-18 mix interactive orchestration with autonomous task execution.

### PoC Task Characteristics

**Early in dependency chains:** PoC tasks should run before tasks that depend on the risky assumption being validated.

**Evidence-focused:** PoC tasks must produce concrete evidence (test results, performance metrics, sample outputs, error logs).

**Fast feedback:** PoC tasks should be designed for quick validation, not full implementation.

**Clear success criteria:** Each PoC task has explicit pass/fail criteria defined by Risk Assessment Agent during design.

### Impact on Escalations

With proactive risk assessment and PoC validation:

**Expected escalations (rare):**
- Edge cases that couldn't be anticipated during design
- Runtime discoveries from external factors
- User requirement changes mid-workflow

**Eliminated escalations (formerly common):**
- ~~"Will this approach work?"~~ → Answered by PoC
- ~~"I'm not sure about this assumption"~~ → Validated by PoC
- ~~"This might have performance issues"~~ → Tested by PoC

## Agent Coordination Patterns

### Dependency Management
- Agents declare dependencies in shared_status.json
- Workflow Executor prevents agents from starting until dependencies are `verified`
- Cascading updates when upstream agents complete

### Verification Workflow

**Success Path:**
1. Do'er agent completes work and completion drive review
2. Status changes to `ready_for_verification`
3. Verifier assigned via shared_status.json
4. Verifier reviews both output and completion drive notes
5. If validation passes:
   - Verifier deletes `verification_results.json` (if exists from previous attempt)
   - Verifier updates shared_status.json: status = `verified`

**Failure Path (Missing Evidence):**
1. Verifier identifies missing evidence or incomplete work
2. Verifier writes `verification_results.json` to doer agent's directory:
   ```json
   {
     "task_id": "create_user_table_1727539200",
     "timestamp": 1727540700,
     "result": "fail",
     "missing_evidence": [
       "Database migration script not found",
       "No test coverage for user table constraints"
     ]
   }
   ```
3. Verifier exits Task (returns control to Workflow Executor)
4. Workflow Executor reads `verification_results.json` from doer agent's directory
5. Workflow Executor re-invokes doer agent with instruction to read `verification_results.json` and `agent_instructions.md`
6. Doer agent (fresh context) reads both files, understands what's missing, fixes issues
7. Doer agent completes fixes, signals ready for verification
8. Cycle repeats: verifier reviews again → either passes (deletes verification_results.json) or fails (updates verification_results.json)

**Retry Limits:**
- After 5 verification failures for a task, Workflow Executor escalates to user with:
  - Failing task details (task_id, agent_instructions.md)
  - All verification feedback history (verification_results.json contents from each attempt)
  - Workflow pause for user decision (modify task, provide guidance, abandon)

**Note:** Evidence requirements should be specified in the doer agent's task from the Workflow Designer Agent. A bug in a feature would manifest as missing evidence that the feature works correctly (e.g., failing tests).

**Key Constraint:** Agents invoked via Task tool do not have access to Task tool themselves. Therefore, verification agents cannot loop directly with doer agents - Workflow Executor must coordinate the retry loop.

### Escalation Resolution Protocol

When doer agents encounter blocking issues during work, they follow this escalation and resolution flow:

#### Escalation Process

1. **Doer agent identifies blocking issue(s)** (unclear requirements, missing information, conflicting guidance)
2. **Agent creates completion drive note(s)** in `session_current.json`:
   - Sets `status: "escalated"` for each note requiring escalation
   - Provides clear question/issue in `description`
   - Includes `escalation_reason` explaining why this blocks progress
   - Includes `context` showing what agent was doing
   - **Multiple notes can be escalated simultaneously** (agent reviews all notes during completion drive review)
3. **Agent updates shared_status.json** to `status: "blocked"`
4. **Agent ends turn** (Task tool returns control to Workflow Executor)

#### Resolution Process

1. **Workflow Executor detects blockage**:
   - Reads `shared_status.json` after Task tool returns
   - Sees agent status changed to `blocked`
   - Reads agent's `completion_drive/session_current.json` to find escalated notes

2. **Workflow Executor routes to Escalation Resolution Agent**:
   - Presents all escalated questions/issues to Escalation Resolution Agent
   - **ALL user questions and answers MUST route through Escalation Resolution Agent** for validation
   - If multiple notes escalated, all are presented together

3. **Escalation Resolution Agent evaluates escalations and routes appropriately**:
   - Reviews all escalated questions/issues
   - Categorizes each escalation:
     - **User requirements questions**: Interacts with user directly to gather answers
     - **Technical/architecture questions**: Creates task for Solution Architect Agent
     - **Workflow/planning issues**: Handles internally (planning gaps, dependency conflicts)
   - For Solution Architect tasks:
     - Creates task with `task_id` following standard format
     - Solution Architect works like any doer agent (has own completion_drive/, agent_instructions.md, task_output/)
     - Solution Architect completes work, goes through completion drive review and verification
     - Solution Architect's output (design decisions, architecture guidance) provided in task_output/
   - Validates all answers don't create conflicts with other agent tasks
   - Provides validated responses (from user, Solution Architect output, or Escalation Resolution Agent analysis)
   - If answers require workflow changes: triggers Workflow Adaptation Agent with change requirements
   - Otherwise: proceeds with resolution without workflow changes

4. **Workflow Executor updates completion drive notes**:
   - For each escalated note in `agents/{agent_name}/completion_drive/session_current.json`:
     - Changes `status: "escalated"` → `status: "resolved"`
     - Adds `resolution: "{validated answer}"` - content varies by source:
       - User answers (direct from user via Architecture Group)
       - Solution Architect output (from Solution Architect's task_output/)
       - Architecture Group analysis (workflow/planning resolutions)
     - Sets `resolved_by: "user"` (if user provided answer) or `"workflow_executor"` (if resolved via Solution Architect or Architecture Group)
     - Sets `resolution_timestamp`
   - Updates `shared_status.json` agent status from `blocked` → `working`

5. **Workflow Executor relaunches original Doer agent**:
   - Agent reads updated `session_current.json`
   - Sees resolutions for all escalated notes (including any from Solution Architect work)
   - Continues work with clarifications and architectural guidance

#### Loop Detection

**Problem:** Agents may repeatedly escalate the same question for the same task, indicating circular dependencies or fundamental planning issues.

**Detection mechanism:**
1. Workflow Executor maintains in-memory tracking of escalated questions by `task_id`
2. When processing new escalation, compares question `description` against previous escalations for same `task_id`
3. **Threshold:** If same/similar question appears 3+ times (more than twice) → loop detected

**Loop handling:**
1. Workflow Executor halts normal resolution process
2. Escalates to [TBD: Loop Detection & Resolution Agent] with full context:
   - `task_id` experiencing the loop
   - All escalation history for that task_id (all repeated questions)
   - Current agent status and dependencies
   - Related agent states that might be involved in circular dependency
3. Loop Detection & Resolution Agent examines root cause:
   - Circular dependency between agents requiring workflow restructuring?
   - Fundamental planning gap requiring additional agents/tasks?
   - Insufficient requirements clarity needing deeper user consultation?
4. Loop Detection & Resolution Agent determines solution approach and triggers Workflow Adaptation Agent:
   - Workflow restructuring to break dependency cycles
   - Deeper requirements clarification with user
   - Add intermediate agents/tasks to resolve dependencies
   - Workflow Adaptation Agent updates workflow_coordination_plan.md to reflect structural changes

#### Why Route Through Escalation Resolution Agent

**Always routing questions and answers through the Escalation Resolution Agent ensures:**
- Answers that change workflow assumptions trigger Workflow Adaptation Agent
- Planning gaps revealed by questions get addressed (via Workflow Adaptation Agent)
- Answers don't create conflicts with other agents' work
- workflow_coordination_plan.md stays synchronized with execution reality
- Design Verifier validation may be triggered if significant changes occur

## Agent Coordination Mechanics

### Turn-Based Execution Model

The orchestration system uses a **turn-based execution model** for autonomous agents, where the Workflow Executor controls agent invocation and monitors state changes through file system updates.

**Note**: This section describes coordination for **autonomous agents** (Task tool pattern). Interactive agents (slash command pattern) coordinate through normal conversational interaction with the user.

#### How Autonomous Agents Are Invoked

The Workflow Executor (running as interactive agent via slash command) uses the **Task tool** to launch autonomous agents:

1. Workflow Executor reads `workflow_coordination_plan.md` to determine which agent should work next (following the sequencing plan created by the Workflow Architecture Group)
2. Identifies agents ready to work according to the plan (dependencies satisfied, status = `pending`)
3. Launches agent using Task tool: `Task(subagent_type="database_agent", prompt="...")`
4. **Task tool blocks** until the agent completes its turn
5. When Task tool returns, Workflow Executor knows the turn has ended
6. Workflow Executor reads updated `shared_status.json` and agent files to see results
7. Decides next action based on the workflow plan (launch next agent per sequencing, handle escalations, invoke verifier, etc.)

**Note**: The Workflow Executor does not make scheduling or sequencing decisions. It executes the plan created by the Workflow Architecture Group, which specifies agent order, parallelism, and coordination logic.

#### When Turns End

An agent's turn ends when:
- Agent completes its assigned work and updates its status
- Agent encounters a blocking condition and sets status to `blocked`
- Agent finishes completion drive review and sets status to `ready_for_verification`
- Agent completes verification and sets status to `verified`

The agent must:
1. Update its status in `shared_status.json`
2. Write any outputs to its `task_output/` directory
3. Update `session_current.json` with completion drive notes
4. Return control (Task tool completes)

#### Agent State Awareness

**Important**: Agents do NOT monitor files in real-time. State changes are only detected at turn boundaries:

- Workflow Executor reads state **after** each agent turn completes
- Agents read state **at the beginning** of their turn
- No polling, file watching, or real-time coordination
- State synchronization happens through turn-based handoffs

#### Task Tool Constraint: No Recursive Agent Invocation

**Critical architectural constraint:** Agents launched via Task tool do NOT have access to the Task tool themselves.

**What this means:**
- Agents cannot invoke other agents
- Agents cannot create loops with other agents
- All agent coordination MUST go through Workflow Executor

**Implications for design:**
- Verification agents cannot loop directly with doer agents → Workflow Executor coordinates retry loops
- Escalation Resolution Agent cannot directly invoke Solution Architect → must return to Workflow Executor
- Any multi-agent coordination requires Workflow Executor as intermediary

**Why this matters:**
- Prevents recursive agent invocation patterns
- Forces clear coordination through central orchestrator
- Ensures all agent interactions are visible in workflow execution flow

This constraint was verified through experimental testing (2025-10-06).

### Agent Communication Patterns

#### Pattern 1: Direct File Access for Work Outputs

When agents need outputs from completed upstream agents, they use **direct file access**:

**Example**: API agent needs database schema from database agent

```markdown
# agents/api_agent/agent_instructions.md

## Input Requirements
- Read database schema from: `agents/database_agent/task_output/schema.sql`
- Read table definitions from: `agents/database_agent/task_output/tables.md`
```

**Benefits**:
- Token efficient (no Workflow Executor intermediary)
- Clear file-based contracts
- Easy to debug and inspect

**Prerequisites**:
- Upstream agent must have status = `verified`
- Workflow Executor enforces dependency ordering
- File paths specified in agent_instructions.md

#### Pattern 2: Escalation Through Workflow Executor

When agents need **clarifications or encounter blocking conditions**, they escalate through the Workflow Executor and Escalation Resolution Agent.

**See detailed protocol**: "Escalation Resolution Protocol" section (lines 195-248)

**Summary flow**:
1. Agent creates escalated completion drive note in `session_current.json`
2. Agent sets status to `blocked` in `shared_status.json` and ends turn
3. Workflow Executor detects blockage and reads escalated note
4. **Workflow Executor routes ALL questions through Escalation Resolution Agent** for validation
5. Escalation Resolution Agent evaluates answer's impact on workflow and provides validated response
6. If workflow changes needed: Escalation Resolution Agent triggers Workflow Adaptation Agent
7. Workflow Executor updates completion drive note with resolution
8. Workflow Executor relaunches agent
9. Agent reads resolution, continues work

**Why Escalation Resolution Agent validation**: Ensures answers don't break workflow assumptions, reveals planning gaps, prevents conflicts with other agents' tasks.

### Agent Contract

All autonomous agents follow a standard contract embedded in their `agent_instructions.md` files. Workflow Designer Agent uses agent templates to ensure consistency:

**On Turn Start**:
- Read `agent_instructions.md` for task-specific guidance
- Read `shared_status.json` to understand dependencies and context
- Read `session_current.json` for current completion drive notes
- Read required files from upstream agents' `task_output/` directories

**During Turn**:
- Perform assigned work
- Log completion drive notes to `session_current.json` as assumptions arise
- Write outputs to own `task_output/` directory

**On Turn End**:
- Review completion drive notes (if ready to complete)
- Update status in `shared_status.json`
- Return control to Workflow Executor

**Status Transitions**:
- `pending` → `working`: When agent starts work (begins executing assigned task)
- `working` → `blocked`: When agent has completion drive notes it cannot resolve (sets notes to `status: "escalated"`, ends turn for Workflow Executor to handle)
- `working` → `completion_drive_review`: When agent believes task is complete (triggers review of all accumulated completion drive notes)
- `completion_drive_review` → `ready_for_verification`: When ALL completion drive notes are resolved (no `"escalated"` or `"open"` notes remain)
- `completion_drive_review` → `blocked`: When agent determines notes cannot be self-resolved during review (same as working → blocked)
- `ready_for_verification` → `verified`: After verifier approval (verifier validates both work output AND completion drive resolution)
- `verified` → `session_complete`: Workflow Executor marks session complete (triggers archival)
- Any status → `working`: After failed verification or after blockage is resolved by Workflow Executor

## Workflow Designer Agent Workflow

### Activation Pattern
The orchestration workflow begins with interactive agents activated via slash commands:

1. **Plan Development**: User activates Plan Development Agent via slash command (e.g., `/persona-plan-developer`)
   - Agent conducts structured requirements gathering conversation
   - Agent asks clarifying questions about requirements, constraints, dependencies
   - Agent writes comprehensive summary to `orchestration/conversation_summary_[taskname].md`
   - User exits Plan Development Agent
2. **Workflow Design**: User activates Workflow Designer Agent via slash command (e.g., `/persona-workflow-designer`)
   - Agent reads conversation summary
   - Agent asks clarifying questions about workflow structure, validation needs, agent requirements
   - Agent designs multi-agent workflow with validation checkpoints
   - Agent produces workflow_coordination_plan.md and agent_instructions.md files
   - User exits Workflow Designer Agent

### Conversation Summary Format
Domain-agnostic format that captures context for any task type:

```markdown
# Conversation Summary: [Task Name]

## What We're Trying to Accomplish
[The goal in plain language]

## Key Decisions Made
- Decision: [what was decided]
  - Rationale: [why]
  - Alternatives considered: [what we rejected and why]

## Constraints & Assumptions
- [Things we're taking as given]
- [Limitations we're working within]

## Questions Resolved
- Q: [question that came up]
- A: [how we answered it]

## Open Items
- [Things still unclear or needing resolution]

## Dependencies & Integration Points
- [What this connects to or depends on]
```

### Workflow Designer Agent Responsibilities

#### Critical Analysis Requirements
The Workflow Designer Agent must think deeply about:
- **Agent requirements**: What types of specialized agents are needed to effectively deliver the task
- **New agent creation**: Can call for agents that don't yet exist and guide the user through creating them
- **Validation checkpoints**: Every handoff point between agents must include validation
- **Failure modes**: What can go wrong at each step
- **Dependency chains**: Explicit ordering and blocking dependencies
- **Context requirements**: What information each agent needs from upstream agents
- **Success criteria**: How each agent proves completion

#### Interactive Clarification
When analyzing conversation summaries, the Workflow Designer Agent should:
- Identify gaps in validation requirements
- Question unclear handoff points
- Probe for implicit assumptions
- Verify success criteria are measurable
- Confirm dependencies are complete

The Workflow Designer Agent can ask questions back to the user or request consultation with the default Claude agent for clarification.

#### Output: Workflow Design
The Workflow Designer Agent produces:
- `workflow_coordination_plan.md` containing:
  - Agent roster with roles and dependencies
  - Overall workflow sequencing (which agents run sequentially vs in parallel)
  - Validation checkpoints and escalation procedures
  - Execution plan for Workflow Executor (order of agent invocation, parallelism specifications)
- Initial `shared_status.json` with all agents and dependencies
- `agent_instructions.md` for each agent (token-efficient, agent-specific guidance)
- List of required agent types (both existing and new agents to be created)
- For new agents: Specifications and guidance for user to create them
- File communication contracts (what each agent reads/writes)
- Success criteria for each agent

**Important**: The Workflow Architecture Group makes all decisions about agent sequencing and parallelism. The Workflow Executor simply executes this plan without making its own scheduling decisions.

#### Workflow Designer Agent Sub-Agent Delegation

The Workflow Designer Agent **always uses specialized sub-agents** to handle detailed design work:

**Design Philosophy**: There is no cognitive overhead or coordination friction with AI agents. A specialized agent on a simple task completes it quickly and efficiently. Therefore, we always use specialized agents rather than concentrating work in a single generalized agent.

**Specialized Sub-Agents**:

1. **Agent Roster Designer** (Claude agent via Task tool)
   - Analyzes conversation summary to determine required agent types
   - Identifies which agents need creation
   - Produces specifications for new agents
   - Output: Agent roster with roles and creation requirements

2. **Workflow Sequencing Agent** (Claude agent via Task tool)
   - Determines execution order and parallelism decisions
   - Analyzes task dependencies and blocking conditions
   - Understands what can safely run in parallel
   - Output: Workflow sequence with dependency chains

3. **Instruction Writer Agent** (Claude agent via Task tool)
   - Reads agent templates from `~/.claude/protocols/orchestration_*_agent_template.md`
   - Customizes templates with task-specific context from conversation summary
   - Synthesizes guidance for each agent
   - Output: `agent_instructions.md` file for each agent

4. **File Structure Designer** (Claude agent via Task tool)
   - Designs data flow between agents
   - Creates file communication contracts
   - Determines what outputs each agent produces and what inputs others need
   - Output: File path specifications and format requirements

5. **Validation Checkpoint Designer** (Claude agent via Task tool)
   - Defines measurable success criteria
   - Determines what requires validation and when
   - Understands failure modes and remediation paths
   - Assigns verifier agents to appropriate doer agents
   - Output: Validation specifications with success criteria

6. **Directory Setup Agent** (Script - not Claude)
   - Input: Agent roster (list of names)
   - Creates fixed directory pattern for each agent:
     ```
     orchestration/agents/{name}/
     orchestration/agents/{name}/completion_drive/
     orchestration/agents/{name}/task_output/
     ```
   - Pure mechanical file operations

7. **Shared Status Initializer Agent** (Script - not Claude)
   - Input: Structured data files (agent roster with dependencies, workflow sequence)
   - Populates `shared_status.json` template with agent entries
   - Pure template filling with structured inputs

8. **Risk Assessment & Validation Agent** (Claude agent via interactive invocation)
   - Identifies risky assumptions requiring validation
   - Evaluates likelihood and impact
   - Determines appropriate Proof of Concept strategies
   - Invoked interactively by Workflow Designer Agent (see "Risk Assessment & Proof of Concept Workflow" section)

**Delegation Pattern**:
1. Workflow Designer Agent reads conversation summary
2. Asks user clarifying questions about gaps/ambiguities
3. Launches specialized sub-agents via Task tool (agents 1-7)
4. Invokes Risk Assessment & Validation Agent (interactive collaboration)
5. Integrates all outputs into cohesive workflow design
6. Produces final `workflow_coordination_plan.md`

**Benefits**:
- Distributes cognitive load across specialized agents
- Each sub-agent can be thorough in their domain
- Workflow Designer Agent maintains overall design authority
- Scripts handle mechanical operations efficiently
- No complexity penalty for using specialized agents

### Design Philosophy
- **Context over templates**: Conversation summaries capture the "why" not just the "what"
- **Universal format**: Single summary format works for software delivery, data analysis, categorization, research, etc.
- **Interactive refinement**: Workflow Designer Agent asks questions rather than making assumptions
- **Adaptive agent creation**: Workflow Designer Agent identifies needed agent types and guides creation of missing agents
- **Validation-first**: Every agent transition must include explicit validation

## Design Verification

### Design Verifier Agent

Before workflow execution begins, a **Design Verifier Agent** reviews the Workflow Designer Agent's design for completeness and consistency.

#### Verification Checklist

The Design Verifier reviews:

**Agent Instructions Completeness**:
- Each agent has clear, specific instructions in `agent_instructions.md`
- Input requirements are explicit (file paths, dependencies)
- Output requirements specify what files to create and where
- Success criteria are measurable and unambiguous
- Completion drive guidance provided

**File Communication Contracts**:
- All file paths are consistent across agents
- Downstream agents reference correct upstream output locations
- No circular dependencies in file access patterns
- File formats are specified where needed

**Validation Checkpoints**:
- Validation points exist at every agent handoff
- Success criteria defined for each validation
- Verifier agents assigned to appropriate do'er agents
- Failure modes and remediation paths specified

**Dependency Consistency**:
- Dependency chains in `shared_status.json` are complete
- No circular dependencies between agents
- All dependencies are satisfiable
- Dependency ordering allows for workflow completion

**Task Identifier Uniqueness**:
- All task_id values across the workflow are unique
- task_id format follows `{slug}_{unix_epoch_timestamp}` specification
- No duplicate task identifiers exist in the workflow plan

**Escalation Procedures**:
- Clear procedures for handling blocked agents
- Escalation paths documented in workflow_coordination_plan.md
- User intervention points identified

**Gap Identification**:
- Missing agent types that should exist
- Ambiguous handoff points between agents
- Unclear success criteria
- Unspecified validation requirements

#### Verification Process

1. **Design Verifier Agent reads**:
   - `workflow_coordination_plan.md`
   - All `agent_instructions.md` files
   - Initial `shared_status.json`

2. **Design Verifier produces**:
   - Verification report with findings
   - List of gaps or inconsistencies
   - Recommended corrections

3. **Resolution**:
   - If gaps found: Workflow Designer Agent addresses issues
   - If design approved: Proceed to workflow execution
   - User makes final approval decision

#### When Verification Occurs

Design verification happens **after Workflow Designer Agent completes design** and **before Workflow Executor begins coordination**:

```
Plan Development
    ↓
Conversation Summary
    ↓
Workflow Design (Workflow Designer Agent)
    ↓
Risk Assessment & PoC Integration (Risk Assessment & Validation Agent)
    ↓
Design Verification (Design Verifier Agent)
    ↓
Workflow Execution (Workflow Executor)
```

This gate ensures workflow quality before committing agent resources to execution.

## Design Principles

### Local Development Focus
- **File system based**: JSON files for coordination (no database/message bus overhead)
- **Single machine**: Designed for one human, one machine, multiple Claude agents
- **Token efficient**: Session-based archival prevents context bloat
- **Debug friendly**: Human-readable JSON files for easy inspection

### Separation of Concerns
- **Completion drive**: Problem identification and assumption tracking
- **Orchestration**: Task coordination and workflow management
- **Agent focus**: Work agents stay focused on primary tasks, archival agent handles cleanup

### Scalability Considerations
- Start with file system, migrate to database if concurrent agents needed
- Message bus only if real-time coordination becomes requirement
- Archive strategy prevents unbounded growth of coordination files

## Critical Issues Requiring Resolution

The following critical issues were identified during design verification and must be addressed for successful implementation:

### Issue 1: Missing Agent Instruction Templates - **⚠️ HIGH PRIORITY**
**Problem**: Workflow Designer Agent needs template files to create consistent agent_instructions.md files for autonomous agents.

**Impact**: Without templates, Workflow Designer Agent cannot reliably create agent_instructions.md files that include all necessary orchestration mechanics. Each agent needs embedded instructions for:
- When to escalate vs self-resolve (escalation rules)
- File read/write requirements (which files to read on turn start, when to write updates)
- Status update protocols (when to update shared_status.json, what fields to modify)
- Completion drive note management (when to create notes, format requirements, resolution criteria)
- Turn lifecycle specifications (turn start actions, during turn requirements, turn end actions)

**Resolution Needed - HIGH PRIORITY**: Create agent instruction template files:

1. **`~/.claude/protocols/orchestration_doer_agent_template.md`**
   - Template for autonomous work agents (database, API, SQL, frontend, etc.)
   - Includes all orchestration mechanics listed above
   - Workflow Designer Agent customizes with task-specific instructions

2. **`~/.claude/protocols/orchestration_verifier_agent_template.md`**
   - Template for verification agents
   - Includes verification-specific mechanics (reading outputs, writing verification_results.json)

3. **`~/.claude/protocols/orchestration_solution_architect_agent_template.md`** (optional)
   - Template for Solution Architect agent (works like doer agent per line 422)
   - May be same as doer template with architecture-specific guidance

**Templates are reference material for Workflow Designer Agent, not read by autonomous agents themselves. Agent instructions are self-contained.**

---

### Issue 2: Undefined Archival Agent Behavior
**Status**: ✅ **RESOLVED**

**Solution implemented:**

**Who invokes:** [TBD: Archival Coordinator Agent]

**When:**
1. **Workflow start** - One of Archival Coordinator's first acts to prepare workspace (archive/remove stale `session_current.json` files from previous crashed workflows)
2. **Workflow end** - After all verifiers have completed

**Workflow end sequence:**
```
All do'er agents complete work
    ↓
All verifiers validate outputs
    ↓
All verifiers reach `verified` status
    ↓
Archival Agent runs (archives session files)
    ↓
Workflow complete
```

**Scope:** Single invocation processes all agents' `session_current.json` files

**Archive filename format:** `session_YYYYMMDD_HHMM_taskname.json`
- Example: `session_20250928_1430_create_user_table.json`

**Operations:**
- **Start:** Archive/remove stale `session_current.json` from crashed workflows
- **End:** Move all `session_current.json` → `session_YYYYMMDD_HHMM_taskname.json`

**Failure handling:** Archival Coordinator Agent notifies user (no automatic retry, no rollback procedures)

**File outputs:**
- `cleanup_log.json` - Record of archival operations
- `archive_index.json` - Index of archived sessions

---

### Issue 3: Inconsistent Session Filename Format
**Status**: ✅ **RESOLVED**

**Solution implemented:**

**Standardized format:** `session_YYYYMMDD_HHMM_taskname.json`

**Format specification:**
- `YYYYMMDD` - Date (e.g., 20250928)
- `HHMM` - Time in 24-hour format (e.g., 1430 for 2:30 PM)
- `taskname` - Descriptive task identifier (e.g., create_user_table)

**Example:** `session_20250928_1430_create_user_table.json`

All references in the document have been updated to use this format consistently.

---

### Issue 4: Missing Workflow Executor Core Specifications
**Status**: ✅ **FULLY RESOLVED**

**Resolved items:**

1. **How does it detect escalations?**
   - Task tool returns (agent turn ends)
   - Workflow Executor reads `shared_status.json`
   - If agent status = `blocked`, escalation detected
   - Workflow Executor reads `agents/{agent_name}/completion_drive/session_current.json` to find escalated notes

2. **What is the decision algorithm for choosing next agent?**
   - Workflow Executor follows the sequencing and parallelism decisions documented in `workflow_coordination_plan.md`
   - The Workflow Architecture Group decides which agents run sequentially vs in parallel during workflow design
   - No complex selection logic needed - Executor simply executes the plan as specified

3. **How does it initialize `shared_status.json` at workflow start?**
   - Workflow Executor reads `workflow_coordination_plan.md` created by Architecture Group
   - Creates `shared_status.json` based on agent roster, dependencies, and sequencing specified in the plan

4. **How does it handle multiple simultaneous blockers?**
   - **Serial execution**: No simultaneous blockers possible (only one agent working at a time)
   - **Parallel execution**: If Architecture Group determined agents can run in parallel, their escalations are independent
   - **Priority**: First Come First Serve - handle blockers in the order they occurred (use `last_update` timestamp in `shared_status.json`)
   - **Rationale**: If agents were designed to run in parallel, their work (and therefore escalations) are independent, so resolution order doesn't matter

5. **What happens if an agent crashes mid-turn?**
   - Task tool returns error to Workflow Executor
   - Workflow Executor retries the agent up to 3 times
   - After 3 failed attempts, marks agent as `failed` in `shared_status.json` and escalates to user
   - If other agents running in parallel, allows them to finish before escalating

All sub-items resolved. Timeout handling addressed in Issue 5.

---

### Issue 5: Undefined Turn Completion Semantics
**Status**: ✅ **RESOLVED**

**Solution implemented:**

1. **Error handling for agent crashes during turn:**
   - Task tool returns error to Workflow Executor when agent crashes
   - Workflow Executor retries the agent up to 3 times
   - After 3 failed attempts, marks agent as `failed` in `shared_status.json` and escalates to user
   - If other agents running in parallel, allows them to finish before escalating

2. **Timeout handling decision:**
   - **DECISION**: Task tool does NOT have timeout mechanism
   - **DECISION**: Workflow Executor will NOT implement timeout monitoring
   - **RATIONALE**: Timeout handling is lower priority than core orchestration features
   - **FUTURE**: Timeout handling can be added later if needed
   - **IMPLICATION**: Long-running agents may run indefinitely until completion or crash

---

### Issue 6: Verification Failure Recovery Process
**Status**: ✅ **RESOLVED**

**Solution implemented: Simple retry loop coordinated by Workflow Executor**

**Feedback location:** `agents/{doer_agent_name}/verification_results.json`

**File format:**
```json
{
  "task_id": "create_user_table_1727539200",
  "timestamp": 1727540700,
  "result": "fail",
  "missing_evidence": [
    "Database migration script not found",
    "No test coverage for user table constraints"
  ]
}
```

**Recovery flow (Simple):**
1. Verifier writes `verification_results.json` to doer agent's directory with missing evidence list
2. Verifier exits Task (returns control to Workflow Executor)
3. Workflow Executor reads `verification_results.json`, sees "fail"
4. Workflow Executor re-invokes doer agent with: "Read verification_results.json and agent_instructions.md, fix the missing evidence"
5. Doer agent (fresh context) reads both files, fixes issues, completes work
6. Verifier reviews again → either passes (deletes verification_results.json, status = verified) or fails (updates verification_results.json)
7. Cycle repeats until verification passes OR retry limit reached

**Retry limits:** After 5 verification failures, Workflow Executor escalates to user with:
- Failing task details (task_id, agent_instructions.md)
- All verification feedback history
- Workflow pause for user decision (modify task, provide guidance, abandon)

**Key insights:**
- **No separate Verification Failure Handler Agent needed** - Workflow Executor handles simple retry logic
- **Verification agent deletes verification_results.json on success** - file only exists when there's a problem
- **Task tool constraint:** Agents cannot invoke other agents, so Workflow Executor must coordinate the loop
- **Evidence-based validation:** Tasks include evidence requirements from Workflow Designer Agent. Bugs manifest as missing evidence (e.g., failing tests).

---

### Issue 7: Missing Initial State Creation Process
**Status**: ✅ **RESOLVED**

**Bootstrap sequence:**

1. **Plan Development Agent** (activated via `/persona-plan-developer`):
   - Creates `orchestration/` directory if needed
   - Writes `conversation_summary_[taskname].md`

2. **Workflow Designer Agent** (activated via `/persona-workflow-designer`):
   - Creates `orchestration/agents/` directory structure
   - Creates subdirectories for each agent (e.g., `orchestration/agents/database_agent/`)
   - Reads agent templates from `~/.claude/protocols/orchestration_*_agent_template.md`
   - Creates `agent_instructions.md` for each agent by customizing templates
   - Creates initial `shared_status.json` with all agents and dependencies
   - Creates `workflow_coordination_plan.md` with execution sequence
   - Creates `completion_drive/`, `task_output/` subdirectories for each agent

3. **Workflow Executor** (activated via `/persona-workflow-executor`):
   - Reads `workflow_coordination_plan.md` and `shared_status.json`
   - Begins launching autonomous agents via Task tool
   - Autonomous agents create their own `session_current.json` files when they start work

**File creation responsibility**: Interactive agents (slash command pattern) create orchestration files. Autonomous agents (Task tool pattern) only create their session files.

---

### Issue 8: Escalation Resolution Mechanism Underspecified
**Status**: ✅ **RESOLVED** (see "Escalation Resolution Protocol" section, lines 195-248)

**Solution implemented:**
- Clarification storage: Updates existing note in `session_current.json` with `resolution` field
- Agent notification: Status change from `blocked` → `working` in `shared_status.json`
- File-based protocol: Workflow Executor modifies completion drive note directly
- All user questions/answers route through Workflow Architecture Group for validation
- Complete 5-step resolution process documented

---

## Additional Open Questions

### Q1: Concurrent Agent Execution
**Status**: ✅ **ANSWERED**

Yes, multiple independent agents can work in parallel if the Workflow Architecture Group specifies parallel execution in `workflow_coordination_plan.md`. The decision about sequential vs parallel execution is made during workflow design, not by the Workflow Executor at runtime. The Executor simply follows the sequencing plan created by the Architecture Group.

### Q2: User Intervention Points
**Status**: ✅ **ANSWERED**

User interacts through two patterns:
1. **Interactive agents (slash commands)**: Plan Development, Workflow Designer, Design Verifier, Workflow Executor, Risk Assessment, Escalation Resolution - all conversational
2. **Escalations during execution**: Workflow Executor (running as interactive agent) prompts user when autonomous agents escalate blocking issues
3. **Manual workflow approval**: User approves final design before execution begins

### Q3: Session Recovery After Crash
If the system crashes mid-workflow, how does it recover? Can it resume from `shared_status.json`?

### Q4: Multiple Verification Round Limits
**Status**: ✅ **ANSWERED**

After 5 verification failures for a task (not counting rework tasks), Workflow Executor escalates to user with:
- The failing task details (task_id, agent_instructions.md)
- All verification feedback (verification_results.json history)
- Workflow pause for user decision

User can then modify/reduce the task scope, provide additional guidance, change the approach, or abandon the task. This allows iterative refinement while preventing infinite loops.

### Q5: Task Output Versioning
If an agent updates outputs after failed verification, how do downstream agents know to re-read? Is there versioning?

### Q6: Design Verifier Agent Invocation
**Status**: ✅ **ANSWERED**

User manually activates Design Verifier Agent via slash command (e.g., `/persona-design-verifier`) after Workflow Designer Agent completes. This allows user to review the design and decide whether to proceed.

### Q7: Workflow Architect Activation Mechanism
**Status**: ✅ **ANSWERED** (renamed from "Workflow Architect" to "Workflow Designer Agent")

User explicitly activates Workflow Designer Agent via slash command (e.g., `/persona-workflow-designer`) after Plan Development Agent completes and writes conversation_summary.md.

### Q8: Simple vs Complex Workflow Threshold
What defines "simple" workflows that don't need sub-agent delegation? Agent count? Complexity metric?

### Q9: Agent Discovery and Registration
How does the system know what agent types exist? Is there a registry?

### Q10: Escalation Priority with Multiple Blocked Agents
**Status**: ✅ **ANSWERED**

First Come First Serve - handle blockers in the order they occurred (using `last_update` timestamp in `shared_status.json`).

**Rationale**: If the Workflow Architecture Group designed agents to run in parallel, they determined the agents' work is independent. Therefore, their escalations are also independent, and resolution order doesn't matter. For serial execution, simultaneous blockers are not possible.