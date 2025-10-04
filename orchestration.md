# Orchestration

Multi-agent coordination system for managing complex tasks across specialized Claude agents.

## Architecture Overview

### Agent Types
- **Workflow Architect**: Analyzes plans and designs multi-agent workflows with validation checkpoints
- **Design Verifier Agent**: Reviews workflow designs for completeness and consistency before execution
- **Workflow Executor**: Executes the workflow plan by launching agents in the sequence specified by the Workflow Architecture Group, detects escalations, and coordinates resolution through the Architecture Group. The Executor does not make planning or sequencing decisions - it simply runs the workflow as designed.
- **Solution Architect Agent**: Makes technical architecture decisions, reviews architecture-related escalations from doer agents
- **Do'er Agents**: Perform specific work (database, API, frontend, etc.)
- **Verifier Agents**: Validate do'er agent outputs and completion drive reviews
- **Archival Agent**: Manages session cleanup and token optimization

### Directory Structure
```
project/
├── orchestration/
│   ├── conversation_summary_[taskname].md    # plan context for Workflow Architect
│   ├── workflow_coordination_plan.md         # workflow design for Workflow Executor
│   ├── shared_status.json                    # overall coordination state
│   └── agents/
│       ├── solution_architect_agent/
│       │   ├── agent_instructions.md         # architecture decision tasks
│       │   ├── completion_drive/
│       │   │   ├── session_current.json
│       │   │   └── session_20250928_143022.json
│       │   └── task_output/                  # architecture decisions, design guidance
│       ├── database_agent/
│       │   ├── agent_instructions.md         # specific instructions for this agent
│       │   ├── completion_drive/
│       │   │   ├── session_current.json
│       │   │   └── session_20250928_143022.json
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
  "session_start": "2025-09-28T14:30:00Z",
  "agents": {
    "database_agent": {
      "status": "completion_drive_review",
      "completion_drive_notes_count": 3,
      "unresolved_notes": 1,
      "last_update": "2025-09-28T10:45:00Z"
    },
    "api_agent": {
      "status": "working",
      "completion_drive_notes_count": 0,
      "last_update": "2025-09-28T10:30:00Z"
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
- **Triggers archival**: Session end signal moves `session_current.json` → `session_YYYYMMDD_HHMMSS_taskname.json`
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
  - Generated by Workflow Architecture Group when creating task
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
  - Example: "Should email be unique?" → Escalate to user via Architecture Group
- **Conflicting guidance**: Contradictions between agent_instructions.md, conversation_summary.md, or other documentation
  - Example: "Instructions say optimize for speed but summary emphasizes accuracy" → Escalate to Architecture Group

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

**Note**: Complete escalation rules are specified in the Agent Contract Protocol (`~/.claude/protocols/orchestration_agent_contract.md`), which all doer agents must follow. See "Critical Issues Requiring Resolution: Issue 1" for protocol creation requirements.

## Agent Coordination Patterns

### Dependency Management
- Agents declare dependencies in shared_status.json
- Workflow Executor prevents agents from starting until dependencies are `verified`
- Cascading updates when upstream agents complete

### Verification Workflow
1. Do'er agent completes work and completion drive review
2. Status changes to `ready_for_verification`
3. Verifier assigned via shared_status.json
4. Verifier reviews both output and completion drive notes
5. Status changes to `verified` or back to `working` if issues found

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

2. **Workflow Executor routes to Workflow Architecture Group**:
   - Presents all escalated questions/issues to Workflow Architect (or designated agent in Architecture Group)
   - **ALL user questions and answers MUST route through Workflow Architecture Group** for validation
   - If multiple notes escalated, all are presented together

3. **Workflow Architecture Group evaluates escalations and routes appropriately**:
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
   - Provides validated responses (from user, Solution Architect output, or Architecture Group analysis)
   - Updates workflow plan as needed (new agents, dependencies, tasks)

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
2. Escalates to Workflow Architecture Group with full context:
   - `task_id` experiencing the loop
   - All escalation history for that task_id (all repeated questions)
   - Current agent status and dependencies
   - Related agent states that might be involved in circular dependency
3. Architecture Group examines root cause:
   - Circular dependency between agents requiring workflow restructuring?
   - Fundamental planning gap requiring additional agents/tasks?
   - Insufficient requirements clarity needing deeper user consultation?
4. Architecture Group provides solution:
   - Workflow restructuring to break dependency cycles
   - Deeper requirements clarification with user
   - Add intermediate agents/tasks to resolve dependencies
   - Update workflow_coordination_plan.md to reflect structural changes

#### Why Route Through Workflow Architecture Group

**Always routing questions and answers through the Architecture Group ensures:**
- Answers that change workflow assumptions trigger workflow updates
- Planning gaps revealed by questions get addressed (new agents created, dependencies added)
- Answers don't create conflicts with other agents' work
- workflow_coordination_plan.md stays synchronized with execution reality
- Design Verifier validation may be triggered if significant changes occur

### Error Handling
- Failed verification sends agents back to `working` status with specific feedback

## Agent Coordination Mechanics

### Turn-Based Execution Model

The orchestration system uses a **turn-based execution model** where the Workflow Executor controls agent invocation and monitors state changes through file system updates.

#### How Agents Are Invoked

The Workflow Executor uses the **Task tool** to launch agents:

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

When agents need **clarifications or encounter blocking conditions**, they escalate through the Workflow Executor and Workflow Architecture Group.

**See detailed protocol**: "Escalation Resolution Protocol" section (lines 195-248)

**Summary flow**:
1. Agent creates escalated completion drive note in `session_current.json`
2. Agent sets status to `blocked` in `shared_status.json` and ends turn
3. Workflow Executor detects blockage and reads escalated note
4. **Workflow Executor routes ALL questions through Workflow Architecture Group** for validation
5. Architecture Group evaluates answer's impact on workflow and provides validated response
6. Workflow Executor updates completion drive note with resolution
7. Workflow Executor relaunches agent
8. Agent reads resolution, continues work

**Why Architecture Group validation**: Ensures answers don't break workflow assumptions, reveals planning gaps, prevents conflicts with other agents' tasks.

### Agent Contract

All agents must follow a standard contract (detailed in protocol: `~/.claude/protocols/orchestration_agent_contract.md`):

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

## Workflow Architect Workflow

### Activation Pattern
The Workflow Architect is manually activated after plan development with the default Claude agent:

1. **Plan Development**: User works with default Claude agent to develop a rough plan
2. **Conversation Summary**: Default Claude writes comprehensive summary to `orchestration/conversation_summary_[taskname].md`
3. **Manual Activation**: User explicitly activates Workflow Architect
4. **Interactive Analysis**: Workflow Architect reads summary and asks clarifying questions
5. **Workflow Design**: Workflow Architect designs multi-agent workflow with validation checkpoints

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

### Workflow Architect Responsibilities

#### Critical Analysis Requirements
The Workflow Architect must think deeply about:
- **Agent requirements**: What types of specialized agents are needed to effectively deliver the task
- **New agent creation**: Can call for agents that don't yet exist and guide the user through creating them
- **Validation checkpoints**: Every handoff point between agents must include validation
- **Failure modes**: What can go wrong at each step
- **Dependency chains**: Explicit ordering and blocking dependencies
- **Context requirements**: What information each agent needs from upstream agents
- **Success criteria**: How each agent proves completion

#### Interactive Clarification
When analyzing conversation summaries, the Workflow Architect should:
- Identify gaps in validation requirements
- Question unclear handoff points
- Probe for implicit assumptions
- Verify success criteria are measurable
- Confirm dependencies are complete

The Workflow Architect can ask questions back to the user or request consultation with the default Claude agent for clarification.

#### Output: Workflow Design
The Workflow Architect produces:
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

#### Workflow Architect Sub-Agent Delegation

For complex workflows, the Workflow Architect may **spawn specialized sub-agents** to handle detailed design work:

**Delegation Pattern**:
1. Workflow Architect analyzes conversation summary
2. Determines workflow complexity
3. For complex workflows, spawns sub-agents:
   - **Instruction Writer Agent**: Creates detailed `agent_instructions.md` for each agent
   - **File Structure Designer**: Plans file communication paths and contracts
   - **Validation Checkpoint Designer**: Defines validation points and success criteria
4. Workflow Architect integrates sub-agent outputs into cohesive workflow design
5. Produces final workflow coordination plan

**Benefits**:
- Distributes cognitive load for complex workflows
- Each sub-agent can be thorough in their domain
- Workflow Architect maintains overall design authority
- Scales naturally with workflow complexity

**Simple workflows**: Workflow Architect handles directly without delegation

### Design Philosophy
- **Context over templates**: Conversation summaries capture the "why" not just the "what"
- **Universal format**: Single summary format works for software delivery, data analysis, categorization, research, etc.
- **Interactive refinement**: Workflow Architect asks questions rather than making assumptions
- **Adaptive agent creation**: Workflow Architect identifies needed agent types and guides creation of missing agents
- **Validation-first**: Every agent transition must include explicit validation

## Design Verification

### Design Verifier Agent

Before workflow execution begins, a **Design Verifier Agent** reviews the Workflow Architect's design for completeness and consistency.

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
   - If gaps found: Workflow Architect addresses issues
   - If design approved: Proceed to workflow execution
   - User makes final approval decision

#### When Verification Occurs

Design verification happens **after Workflow Architect completes design** and **before Workflow Executor begins coordination**:

```
Plan Development
    ↓
Conversation Summary
    ↓
Workflow Design (Workflow Architect)
    ↓
Design Verification (Design Verifier Agent)  ← NEW STEP
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

### Issue 1: Missing Agent Contract Protocol - **⚠️ HIGH PRIORITY**
**Problem**: References `~/.claude/protocols/orchestration_agent_contract.md` which does not exist.

**Impact**: Agents cannot implement the standard contract without this specification. This is the foundational contract all doer agents must follow. Without this protocol:
- Doer agents don't know when to escalate vs self-resolve
- File read/write requirements are unclear
- Status update protocols are unspecified
- Turn lifecycle behavior is undefined

**Resolution Needed - HIGH PRIORITY**: Create the complete agent contract protocol specifying:
- **Escalation rules** (technology choices, architecture decisions, requirements assumptions - see "Escalation Rules for Doer Agents" section)
- Exact file read/write requirements (which files to read on turn start, when to write updates)
- Status update protocols (when to update shared_status.json, what fields to modify)
- Completion drive note management (when to create notes, format requirements, resolution criteria)
- Turn lifecycle specifications (turn start actions, during turn requirements, turn end actions)
- Error handling requirements (crash recovery, timeout behavior)

**This protocol is foundational and should be created before implementing doer agents.**

---

### Issue 2: Undefined Archival Agent Behavior
**Problem**: The Archival Agent is mentioned in multiple places but critical details are missing:
- Who invokes the archival agent?
- When exactly does archival happen?
- What triggers it to run?
- What happens if archival fails?

**Impact**: Session cleanup and token management cannot be implemented without these specifications.

**Resolution Needed**: Document:
- Archival agent invocation mechanism
- Timing and triggers for archival
- Error handling for archival failures
- Rollback procedures if needed

---

### Issue 3: Inconsistent Session Filename Format
**Problem**: Two different formats shown:
- Line 27: `session_20250928_143022.json` (no taskname)
- Line 100: `session_YYYYMMDD_HHMMSS_taskname.json` (includes taskname)

**Impact**: Agents won't know the correct naming convention for archived sessions.

**Resolution Needed**: Choose one standard format and update all references.

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
**Status**: ✅ **PARTIALLY RESOLVED**

**Resolved items:**

1. **Error handling for agent crashes during turn:**
   - Task tool returns error to Workflow Executor when agent crashes
   - Workflow Executor retries the agent up to 3 times
   - After 3 failed attempts, marks agent as `failed` in `shared_status.json` and escalates to user
   - If other agents running in parallel, allows them to finish before escalating

**Implementation Assumptions (requires verification):**

2. **Timeout behavior when Task tool hangs:**
   - **ASSUMPTION**: Task tool has built-in timeout mechanism (similar to Bash tool)
   - **ASSUMPTION**: Task tool returns timeout error to Workflow Executor if agent exceeds timeout
   - **NEEDS VERIFICATION**: No timeout parameter is documented for Task tool
   - **IF TIMEOUT EXISTS**: Apply same retry logic as crashes (retry x3, then mark failed and escalate)
   - **IF NO TIMEOUT**: Workflow Executor may need to implement its own timeout monitoring

**Still needs resolution:**
- Turn timeout duration values (if Task tool supports timeouts)
- Whether timeout duration should be:
  - System-wide default?
  - Configurable per agent in workflow plan?
  - Determined by Architecture Group during workflow design?

---

### Issue 6: Verification Failure Recovery Process Unclear
**Problem**: Document says "Status changes to `verified` or back to `working` if issues found" but:
- Who writes the feedback? (Verifier? Workflow Executor?)
- Where is feedback stored? (completion drive notes? new field?)
- How many verification attempts before escalation?
- Can a verifier block a do'er agent or only provide feedback?

**Impact**: Agents won't know how to handle verification failures.

**Resolution Needed**: Document:
- Feedback file format and location
- Feedback authoring responsibility
- Verification retry limits
- Verifier blocking authority

---

### Issue 7: Missing Initial State Creation Process
**Problem**: Document describes steady-state operation but not initialization:
- Who creates the initial `orchestration/` directory structure?
- Who creates the first `shared_status.json`?
- When are `agent_instructions.md` files created?
- What is the bootstrap sequence?

**Impact**: Cannot start a workflow from scratch.

**Resolution Needed**: Document complete bootstrap sequence:
1. Directory creation (who, when)
2. Initial file creation (who, when, what content)
3. Agent instruction file creation timing
4. First agent invocation process

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
Where and how does the user interact with the orchestration system? Does Workflow Executor prompt the user? Manual file editing?

### Q3: Session Recovery After Crash
If the system crashes mid-workflow, how does it recover? Can it resume from `shared_status.json`?

### Q4: Multiple Verification Round Limits
Is there a limit to verification retry attempts? Could agents get stuck in working→verification→working loops?

### Q5: Task Output Versioning
If an agent updates outputs after failed verification, how do downstream agents know to re-read? Is there versioning?

### Q6: Design Verifier Agent Invocation
Who invokes the Design Verifier? User manually or Workflow Architect automatically?

### Q7: Workflow Architect Activation Mechanism
What is the exact mechanism for "User explicitly activates Workflow Architect"? Command? File creation?

### Q8: Simple vs Complex Workflow Threshold
What defines "simple" workflows that don't need sub-agent delegation? Agent count? Complexity metric?

### Q9: Agent Discovery and Registration
How does the system know what agent types exist? Is there a registry?

### Q10: Escalation Priority with Multiple Blocked Agents
**Status**: ✅ **ANSWERED**

First Come First Serve - handle blockers in the order they occurred (using `last_update` timestamp in `shared_status.json`).

**Rationale**: If the Workflow Architecture Group designed agents to run in parallel, they determined the agents' work is independent. Therefore, their escalations are also independent, and resolution order doesn't matter. For serial execution, simultaneous blockers are not possible.