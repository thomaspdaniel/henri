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
- **Tactical Solution Architect Agent**: Makes tactical architecture decisions during execution, reviews architecture-related escalations from doer agents
- **Solution Architect** (Interactive): Conducts upfront architecture design and technology selection (see Interactive Agents section)
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
- **Risk Assessment & Validation Agent** (user-activated after Workflow Designer) - Collaborative risk analysis
- **Escalation Resolution Agent** (user-activated when Workflow Executor encounters blocked agents) - Interactive resolution of blocked agents
- **Workflow Adaptation Agent** (user-activated when workflow changes needed) - Collaborative workflow updates
- **Solution Architect** (e.g., `/persona-solution-architect`) - Upfront architecture design and technology selection

**Characteristics:**
- User can ask questions and get immediate responses
- Agent can ask clarifying questions
- Conversation continues until user exits the agent persona
- Same Claude session, different persona/role

#### Autonomous Agents (Task Tool Pattern)
These agents are launched via Task tool for autonomous work without user interaction:

- **Do'er Agents** (SQL agent, API agent, database agent, frontend agent, etc.)
- **Verifier Agents** (validate do'er agent outputs)
- **Tactical Solution Architect Agent** (works like doer agent when invoked for specific architecture decisions during execution)
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
│   ├── technology_stack.json                # technology selections (from Solution Architect)
│   ├── architecture_decisions.md            # architecture rationale (from Solution Architect)
│   ├── agent_roster.json                     # agents needed with existence flags (from Agent Roster Designer)
│   ├── workflow_sequence.json                # execution phases and parallelism (from Workflow Sequencing Agent)
│   ├── workflow_coordination_plan.md         # workflow design for Workflow Executor
│   ├── shared_status.json                    # overall coordination state
│   ├── architecture_feedback/
│   │   ├── review_sequence.md                # Documents order and rationale
│   │   ├── security_review.md                # From Security Reviewer
│   │   ├── database_storage_review.md        # From Database/Storage Reviewer
│   │   ├── api_dataflow_review.md            # From API/Data Flow Reviewer
│   │   ├── frontend_review.md                # From Frontend Reviewer
│   │   └── tsa_changelog.md                  # From TSA instances (cumulative log)
│   └── agents/
│       ├── tactical_solution_architect_agent/
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
  - Example: "Should I use Python or bash to parse this log file?" → Escalate to Tactical Solution Architect
  - Even if technology seems obvious, doer agents lack authority to make these decisions
- **Architecture decisions**: System design, component structure, integration patterns
  - Example: "Should this be REST or GraphQL?" → Escalate to Tactical Solution Architect
- **Security decisions**: Authentication methods, encryption algorithms, access control patterns
  - Example: "Which password hashing algorithm?" → Escalate to Tactical Solution Architect
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
- Technology stack (from Solution Architect)
- Draft workflow plan from Workflow Designer Agent
- Agent roster (from Agent Roster Designer)

**Specialized Sub-Agents:**

1. **Technology Best Practices Research Agent(s)** (Claude agent via Task tool)
   - Searches internet for best practices for specific technologies identified in workflow
   - Searches for common failure patterns and technology-specific risks
   - May leverage MCP servers for enhanced research capabilities
   - Output: Best practices documentation per technology/task type
   - **Storage:** Research preserved long-term for reuse across workflows (storage location TBD)

2. **Risk Category Checklist Agent** (Claude agent via Task tool)
   - Generates domain-specific risk checklists for each agent type based on best practices research
   - Creates structured risk assessment frameworks tailored to specific technologies
   - Identifies critical risk categories (data loss, security, performance, availability, reversibility, dependencies)
   - Provides consultation prompts for Risk Coordinator to use when consulting Doer agents
   - **Inputs**: Conversation summary, technology stack (from Solution Architect), agent roster, best practices research outputs
   - **Output**: Structured risk checklists per agent type with consultation prompts
   - **Context Efficiency Rationale**: Generates checklists on-demand during risk assessment only; keeps Doer agent contexts clean during normal work execution (no risk assessment content loaded when unnecessary)
   - **Example checklist categories**:
     - Data Loss & Corruption: backup mechanisms, rollback procedures, data integrity validation
     - Security: authentication, authorization, encryption, injection risks
     - Performance: scalability, resource exhaustion, bottlenecks
     - Availability: downtime, cascading failures, timeout handling
     - Reversibility: rollback capability, recovery procedures
     - Dependencies: external services, version compatibility, breaking changes

3. **Doer Agent Consultation** (coordinated by Risk Coordinator)
   - Risk Coordinator identifies which specialized Doer agents to consult based on agent roster
   - Uses risk checklists from Risk Category Checklist Agent to guide structured consultation
   - Consults Doer agents (via prompts/questions) with task-specific checklists for technology-specific risk identification
   - Doer agents review checklists and identify applicable risks in their specialty areas
   - Output: Technology-specific risk assessments from domain experts (structured by checklist categories)

4. **PoC Recommendation Agent** (Claude agent via Task tool)
   - Takes research outputs + doer consultations + risk checklists
   - Synthesizes inputs into specific PoC task recommendations
   - Specifies evidence requirements for each PoC (what success/failure looks like)
   - Output: PoC task specifications with success/failure criteria

5. **PoC Integration Agent** (Claude agent via Task tool)
   - Takes PoC recommendations + workflow sequence
   - Determines where PoCs should run (early, before dependent tasks)
   - Updates workflow sequence to include PoCs in correct positions
   - Output: Updated workflow sequence with PoCs integrated

6. **Best Practices Integration Agent** (Claude agent via Task tool)
   - Takes best practices research + agent roster + agent instructions (drafts)
   - Embeds relevant best practices into each Doer agent's instructions
   - Ensures Doer agents follow best practices during work (not just risk assessment)
   - Output: Enhanced agent instructions with embedded best practices

**Coordinator Outputs:**
- Risk assessment report
- Risk category checklists per agent type
- PoC task specifications with success/failure criteria
- Updated workflow plan with PoC tasks integrated
- Enhanced agent instructions with best practices embedded
- Preserved research for long-term reuse

**Example risky assumptions:**
- "Database schema migration will work without conflicts"
- "Data migration won't lose or corrupt existing records"
- "Rollback procedures can safely restore previous state"
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
5. User activates Solution Architect (slash command: /persona-solution-architect)
6. Solution Architect conducts architecture design conversation
7. Solution Architect writes DRAFT technology_stack.json and architecture_decisions.md
8. Solution Architect analyzes project to determine architecture review order
9. Solution Architect documents review order in architecture_feedback/review_sequence.md
10. Solution Architect executes Stage 1: Serial specialized reviewer agents (analysis)
    - Security Reviewer → security_review.md
    - Database/Storage Reviewer → database_storage_review.md
    - API/Data Flow Reviewer → api_dataflow_review.md
    - Frontend Reviewer → frontend_review.md
11. Solution Architect executes Stage 2: Serial TSA instances (decision-making)
    - TSA instances read feedback files and update architecture documents
    - Updates logged to architecture_feedback/tsa_changelog.md
12. Solution Architect presents final architecture to user
13. User exits Solution Architect
14. User activates Workflow Designer Agent (slash command: /persona-workflow-designer)
15. Workflow Designer Agent creates initial workflow design
16. Workflow Designer Agent signals completion, prompts user to activate Risk Assessment
17. User exits Workflow Designer Agent
18. User activates Risk Assessment & Validation Agent (slash command: /persona-risk-assessment)
19. Risk Assessment Agent analyzes for risky assumptions, inserts PoC tasks where needed
20. User exits Risk Assessment Agent
21. User activates Design Verifier Agent (slash command: /persona-design-verifier)
22. Design Verifier Agent reviews complete design (including PoCs)
23. User approves final design
24. User exits Design Verifier Agent
25. User activates Workflow Executor (slash command: /persona-workflow-executor)
26. Workflow execution begins - Executor launches autonomous agents via Task tool
    ↓
27. PoC tasks execute early in workflow (before dependent tasks) - autonomous agents via Task tool
28. Workflow Executor pauses and prompts user to activate Risk Assessment for PoC review
29. User activates Risk Assessment Agent to review PoC evidence
30. If needed: Risk Assessment Agent prompts user to activate Workflow Adaptation Agent
31. Main workflow continues with validated assumptions - autonomous agents via Task tool
```

**Note**: All steps use user-activated slash commands. Interactive agents (slash commands) cannot programmatically invoke other interactive agents - user must manually activate each persona.

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

2. **Workflow Executor prompts user to activate Escalation Resolution Agent**:
   - Workflow Executor detects blockage and pauses execution
   - Prompts user: "Agent blocked. Please activate Escalation Resolution Agent via `/persona-escalation-resolution`"
   - User exits Workflow Executor and activates Escalation Resolution Agent
   - **ALL user questions and answers MUST route through Escalation Resolution Agent** for validation
   - All escalated questions/issues presented together

3. **Escalation Resolution Agent (user-activated) evaluates escalations and routes appropriately**:
   - Reviews all escalated questions/issues
   - Categorizes each escalation:
     - **User requirements questions**: Interacts with user directly to gather answers
     - **Technical/architecture questions**: Creates task for Tactical Solution Architect Agent
     - **Workflow/planning issues**: Handles internally (planning gaps, dependency conflicts)
   - For Tactical Solution Architect tasks:
     - Creates task with `task_id` following standard format
     - Tactical Solution Architect works like any doer agent (has own completion_drive/, agent_instructions.md, task_output/)
     - Tactical Solution Architect completes work, goes through completion drive review and verification
     - Tactical Solution Architect's output (design decisions, architecture guidance) provided in task_output/
   - Validates all answers don't create conflicts with other agent tasks
   - Provides validated responses (from user, Tactical Solution Architect output, or Escalation Resolution Agent analysis)
   - If answers require workflow changes: prompts user to activate Workflow Adaptation Agent (writes change requirements to file for Workflow Adaptation Agent to read)
   - Otherwise: proceeds with resolution without workflow changes

4. **Escalation Resolution Agent updates completion drive notes and signals completion**:
   - For each escalated note in `agents/{agent_name}/completion_drive/session_current.json`:
     - Changes `status: "escalated"` → `status: "resolved"`
     - Adds `resolution: "{validated answer}"` - content varies by source:
       - User answers (direct from user via Escalation Resolution Agent)
       - Tactical Solution Architect output (from Tactical Solution Architect's task_output/)
       - Escalation Resolution Agent analysis (workflow/planning resolutions)
     - Sets `resolved_by: "user"` (if user provided answer) or `"escalation_resolution"` (if resolved via Tactical Solution Architect or Agent analysis)
     - Sets `resolution_timestamp`
   - Updates `shared_status.json` agent status from `blocked` → `working`
   - **Signals to user**: "Escalations resolved. Please re-activate Workflow Executor to continue."
   - User exits Escalation Resolution Agent and re-activates Workflow Executor

5. **Workflow Executor (re-activated) relaunches original Doer agent**:
   - Agent reads updated `session_current.json`
   - Sees resolutions for all escalated notes (including any from Tactical Solution Architect work)
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
   - Workflow Adaptation Agent updates workflow_sequence.json (execution plan) and workflow_coordination_plan.md (narrative) to reflect structural changes

#### Why Route Through Escalation Resolution Agent

**Always routing questions and answers through the Escalation Resolution Agent ensures:**
- Answers that change workflow assumptions are identified (prompts user to activate Workflow Adaptation Agent)
- Planning gaps revealed by questions get addressed (via user-activated Workflow Adaptation Agent)
- Answers don't create conflicts with other agents' work
- workflow_sequence.json and workflow_coordination_plan.md stay synchronized with execution reality
- Design Verifier validation may be triggered if significant changes occur (user manually activates)

## Agent Coordination Mechanics

### Turn-Based Execution Model

The orchestration system uses a **turn-based execution model** for autonomous agents, where the Workflow Executor controls agent invocation and monitors state changes through file system updates.

**Note**: This section describes coordination for **autonomous agents** (Task tool pattern). Interactive agents (slash command pattern) coordinate through normal conversational interaction with the user.

#### How Autonomous Agents Are Invoked

The Workflow Executor (running as interactive agent via slash command) uses the **Task tool** to launch autonomous agents:

1. Workflow Executor reads `workflow_sequence.json` to determine execution phases and parallelism (machine-readable format from Workflow Sequencing Agent)
2. For current phase, identifies agents ready to work (dependencies satisfied, status = `pending`)
3. If phase is parallel, launches all phase agents simultaneously via multiple Task tool calls
4. If phase is sequential, launches single agent via Task tool
5. **Task tool blocks** until the agent completes its turn
6. When Task tool returns, Workflow Executor knows the turn has ended
7. Workflow Executor reads updated `shared_status.json` and agent files to see results
8. Once all agents in phase complete, advances to next phase per workflow_sequence.json
9. Handles escalations, verification failures, and errors as they occur during execution

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
- Escalation Resolution Agent cannot directly invoke Tactical Solution Architect → must return to Workflow Executor
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
4. **Workflow Executor prompts user to activate Escalation Resolution Agent**
5. User exits Workflow Executor and activates Escalation Resolution Agent
6. Escalation Resolution Agent evaluates answer's impact on workflow and provides validated response
7. If workflow changes needed: Escalation Resolution Agent prompts user to activate Workflow Adaptation Agent
8. Escalation Resolution Agent updates completion drive notes with resolution
9. User re-activates Workflow Executor
10. Workflow Executor relaunches agent
11. Agent reads resolution, continues work

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

## Solution Architect Interactive Persona

### Overview

The Solution Architect is an interactive persona (slash command pattern) responsible for upfront architecture design and technology selection. This persona runs after Plan Development and before Workflow Design, providing technology context for all downstream agents.

### Activation Pattern

User activates Solution Architect via slash command after Plan Development Agent completes:

```
1. Plan Development Agent writes conversation_summary_[taskname].md
2. User exits Plan Development Agent
3. User activates Solution Architect (e.g., `/persona-solution-architect`)
4. Solution Architect conducts architecture design conversation
5. Solution Architect writes DRAFT technology_stack.json and architecture_decisions.md
6. Solution Architect analyzes project to determine architecture review order
7. Solution Architect documents review order in architecture_feedback/review_sequence.md
8. Solution Architect executes two-stage architecture review process:
   - Stage 1: Serial specialized reviewer agents (analysis)
   - Stage 2: Serial Tactical Solution Architect instances (decision-making)
9. Solution Architect presents final architecture to user
10. User exits Solution Architect
11. User activates Workflow Designer Agent
```

### Responsibilities

#### Technology Stack Selection
- Analyze requirements from conversation summary
- Ask clarifying questions about:
  - Scale and performance requirements
  - Team expertise and constraints
  - Integration requirements with existing systems
  - Security and compliance requirements
  - Deployment environment constraints
- Select appropriate technologies for each layer:
  - Database technologies
  - Backend languages and frameworks
  - Frontend frameworks and libraries
  - Infrastructure and deployment tools
  - Third-party services and APIs
- Document technology selections with rationale

#### Architecture Decisions
- Define high-level system architecture
- Establish integration patterns
- Document key architectural principles
- Identify architectural constraints
- Define deployment architecture
- Establish security architecture

#### Interactive Clarification
When analyzing conversation summaries, the Solution Architect should:
- Identify gaps in technology requirements
- Question unclear scale or performance needs
- Probe for integration constraints
- Verify technology constraints are understood
- Confirm team expertise and learning capacity

### Output: technology_stack.json

**Location:** `orchestration/technology_stack.json`

**Format:**
```json
{
  "task_id": "implement_user_management",
  "created": 1729008000,
  "technology_stack": {
    "database": {
      "primary": "PostgreSQL 15",
      "rationale": "ACID compliance required for user data, strong JSON support for flexible schemas",
      "alternatives_considered": ["MySQL", "MongoDB"],
      "constraints": ["Must support existing PostgreSQL infrastructure"]
    },
    "backend": {
      "language": "Python 3.11",
      "framework": "FastAPI",
      "rationale": "Team expertise in Python, FastAPI provides async support and automatic API documentation",
      "alternatives_considered": ["Django REST Framework", "Flask"],
      "constraints": ["Must integrate with existing Python microservices"]
    },
    "frontend": {
      "framework": "React 18",
      "language": "TypeScript",
      "rationale": "Type safety required, React component library already in use",
      "alternatives_considered": ["Vue.js", "Angular"],
      "constraints": ["Must use existing component library"]
    },
    "infrastructure": {
      "deployment": "Docker containers",
      "orchestration": "Kubernetes",
      "rationale": "Existing K8s infrastructure, need scalability",
      "alternatives_considered": ["AWS ECS", "Direct VM deployment"],
      "constraints": ["Must deploy to existing K8s cluster"]
    },
    "third_party_services": {
      "authentication": "Auth0",
      "rationale": "OAuth2/OIDC compliance required, reduces security implementation burden",
      "alternatives_considered": ["Custom JWT", "AWS Cognito"],
      "constraints": ["Must support enterprise SSO"]
    }
  },
  "architecture_patterns": [
    "Microservices architecture",
    "RESTful API design",
    "Event-driven for async operations",
    "Database per service"
  ],
  "integration_requirements": [
    "Must integrate with existing user service via REST API",
    "Event bus for user lifecycle events (Kafka)",
    "Shared authentication via Auth0"
  ],
  "performance_targets": {
    "api_response_time": "< 200ms p95",
    "database_query_time": "< 50ms p95",
    "concurrent_users": "10000+"
  },
  "security_requirements": [
    "OAuth2/OIDC authentication",
    "Role-based access control (RBAC)",
    "Data encryption at rest and in transit",
    "PII handling compliance (GDPR)"
  ]
}
```

### Output: architecture_decisions.md

**Location:** `orchestration/architecture_decisions.md`

**Format:**
```markdown
# Architecture Decisions: [Task Name]

## Document Control
- **Created:** 2025-10-16
- **Task ID:** implement_user_management
- **Architect:** Solution Architect (interactive persona)
- **Status:** Initial Design

## Executive Summary
[High-level architecture overview - 2-3 paragraphs describing the system architecture, key technology choices, and architectural principles]

## Technology Stack Overview
[Summary of major technology selections with primary rationale]

## Architecture Decisions

### Decision 1: [Decision Title]
**Context:** [What problem or question required a decision]

**Decision:** [What was decided]

**Rationale:**
- [Key reason 1]
- [Key reason 2]
- [Key reason 3]

**Alternatives Considered:**
- **[Alternative 1]**: [Why rejected]
- **[Alternative 2]**: [Why rejected]

**Constraints:**
- [Constraint 1 that influenced decision]
- [Constraint 2 that influenced decision]

**Implications:**
- [Implication 1 for implementation]
- [Implication 2 for implementation]

**Risks:**
- [Risk 1 and mitigation approach]
- [Risk 2 and mitigation approach]

---

[Repeat for each major architecture decision]

## Architecture Principles
1. **[Principle 1]**: [Description]
2. **[Principle 2]**: [Description]
3. **[Principle 3]**: [Description]

## Integration Architecture
[How this system integrates with existing systems, data flows, API contracts]

## Security Architecture
[Security approach, authentication/authorization strategy, data protection]

## Deployment Architecture
[How the system will be deployed, infrastructure requirements, scaling approach]

## Open Questions
- [Question 1 requiring resolution during implementation]
- [Question 2 requiring resolution during implementation]

## Evolution Notes
[Section for Tactical Solution Architect agent to append tactical decisions made during execution]

---

**Note:** Tactical architecture decisions made during workflow execution will be appended to the "Evolution Notes" section by the Tactical Solution Architect agent.
```

### Design Philosophy
- **Upfront architecture**: Make major technology and architecture decisions before workflow design
- **Constraint documentation**: Explicitly document all constraints influencing decisions
- **Rationale over rules**: Capture "why" behind every decision for future reference
- **Living document**: Architecture decisions document grows during execution via Tactical Solution Architect
- **Context for agents**: Technology stack provides context for Agent Roster Designer, Risk Assessment, and all doer agents

### Two-Stage Architecture Review Process

After the Solution Architect creates draft architecture documents, a comprehensive two-stage review process validates and refines the architecture through specialized reviewer agents (analysis) followed by Tactical Solution Architect instances (decision-making).

#### Overview

**Design Philosophy:**
- **Separation of concerns**: Reviewers analyze without decision authority; TSA instances make architecture changes
- **Cumulative intelligence**: Serial execution allows each agent to build on prior insights
- **Context-driven ordering**: Review sequence adapts to project nature (data-driven, API-first, user-facing, security-critical)
- **Cross-domain validation**: Later reviewers catch conflicts between earlier recommendations
- **Consistent decision-making**: TSA agent established as architecture decision-maker from upfront design through execution

**Stage 1: Specialized Feedback Analysis (Serial)**
Four specialized reviewer agents execute serially, each reading prior feedback to avoid contradictions and identify cross-domain implications:
1. Reviewer #1 (determined by project analysis)
2. Reviewer #2 (reads Reviewer #1 feedback)
3. Reviewer #3 (reads Reviewer #1-2 feedback)
4. Reviewer #4 (reads Reviewer #1-3 feedback)

**Stage 2: Tactical Decision Making (Serial, Same Order)**
Four TSA instances execute serially in the same order, each reading one reviewer's feedback and updating architecture documents cumulatively:
1. TSA #1 incorporates Reviewer #1 feedback
2. TSA #2 incorporates Reviewer #2 feedback, sees TSA #1 changes
3. TSA #3 incorporates Reviewer #3 feedback, sees TSA #1-2 changes
4. TSA #4 incorporates Reviewer #4 feedback, sees TSA #1-3 changes

#### Context-Driven Review Ordering

**Ordering Determination:**
Solution Architect analyzes conversation summary to determine optimal review sequence based on:
1. **Primary project domain**: Data migration, API redesign, user-facing feature, infrastructure change
2. **Risk profile**: Security requirements, performance criticality, compliance needs
3. **Dependency chains**: Database decisions constrain API design, which constrains frontend

**Standard Ordering Patterns:**

**Pattern A: Data-Driven Projects** (migrations, analytics, data processing)
```
1. Security (establish constraints early)
2. Database/Storage (data model foundation)
3. API/Data Flow (how data moves)
4. Frontend (presentation layer)
```

**Pattern B: API-First Projects** (microservices, integrations, backend services)
```
1. Security (authentication/authorization constraints)
2. API/Data Flow (service contracts)
3. Database/Storage (persistence layer)
4. Frontend (if applicable, otherwise skip)
```

**Pattern C: User-Facing Projects** (customer portals, dashboards, apps)
```
1. Security (user authentication/authorization)
2. Frontend (user experience requirements)
3. API/Data Flow (backend for frontend)
4. Database/Storage (state management)
```

**Pattern D: Security-Critical Projects** (compliance, financial, healthcare)
```
1. Security (establish compliance framework)
2. Database/Storage (data protection, encryption)
3. API/Data Flow (secure communication)
4. Frontend (secure UI patterns)
```

#### File Structure

```
orchestration/
├── conversation_summary_[taskname].md
├── technology_stack.json                 # Updated by TSA instances (cumulative)
├── architecture_decisions.md             # Updated by TSA instances (cumulative)
└── architecture_feedback/
    ├── review_sequence.md                # Documents order and rationale
    ├── security_review.md                # From Security Reviewer
    ├── database_storage_review.md        # From Database/Storage Reviewer
    ├── api_dataflow_review.md            # From API/Data Flow Reviewer
    ├── frontend_review.md                # From Frontend Reviewer
    └── tsa_changelog.md                  # From TSA instances (cumulative log)
```

#### Review Sequence Documentation Format

**File**: `orchestration/architecture_feedback/review_sequence.md`

```markdown
# Architecture Review Sequence

**Project Type**: [Description based on conversation summary]
**Ordering Pattern**: Pattern A/B/C/D or Custom
**Created**: [unix epoch timestamp]

## Rationale

[2-3 paragraphs explaining project focus, primary technical challenges, and why this review order was chosen]

**Why this order:**
1. **[Domain 1] first** - [Rationale for starting here]
2. **[Domain 2] second** - [Rationale and dependencies on Domain 1]
3. **[Domain 3] third** - [Rationale and dependencies on prior domains]
4. **[Domain 4] last** - [Rationale for final position]

## Review Sequence

1. **[Reviewer Name]** → `[filename].md`
2. **[Reviewer Name]** → `[filename].md`
3. **[Reviewer Name]** → `[filename].md`
4. **[Reviewer Name]** → `[filename].md`

## TSA Instance Sequence (Same Order)

1. **TSA Instance #1** - Incorporates [domain] feedback
2. **TSA Instance #2** - Incorporates [domain] feedback
3. **TSA Instance #3** - Incorporates [domain] feedback
4. **TSA Instance #4** - Incorporates [domain] feedback
```

####Reviewer Agent Specifications

**Four Specialized Reviewer Agents:**

1. **Security Architecture Reviewer**
   - **Focus**: Authentication, authorization, encryption, compliance, data protection, secure communication, vulnerability mitigation
   - **Output**: Security concerns, compliance gaps, threat model considerations

2. **Database & Storage Architecture Reviewer**
   - **Focus**: Data modeling, storage technology selection, scalability, data integrity, migration strategies, backup/recovery
   - **Output**: Data architecture concerns, schema design issues, storage optimization recommendations

3. **API & Data Flow Architecture Reviewer**
   - **Focus**: Service contracts, integration patterns, data flow, API design, inter-service communication, event handling
   - **Output**: API design concerns, integration issues, data flow bottlenecks

4. **Frontend Architecture Reviewer**
   - **Focus**: UI/UX architecture, frontend technology selection, state management, performance, accessibility, responsive design
   - **Output**: Frontend concerns, user experience issues, client-side architecture recommendations

**Standard Reviewer Context (All Reviewers):**
- Read `conversation_summary_[taskname].md`
- Read `technology_stack.json` (draft)
- Read `architecture_decisions.md` (draft)

**Cumulative Context (Reviewer #2, #3, #4 only):**
- Read all prior reviewer feedback files
- Reference prior concerns in analysis
- Flag conflicts or gaps identified
- Build on prior insights

**Output Format (Structured Markdown):**
```markdown
# [Domain] Architecture Review

## Context Awareness
[If Reviewer #2+: Reference prior reviewers' key concerns and how they inform this analysis]

## Strengths
- [What's well-designed in this domain]
- [Aspects that align with best practices]

## Concerns
- [Potential issues, missing considerations]
- [Anti-patterns or risks identified]
- [Cross-domain conflicts with prior feedback]

## Recommendations
- [Specific suggestions for improvement]
- [Alternative approaches to consider]
- [Solutions that integrate multiple domain concerns]

## Questions for User/Architect
- [Clarifications needed]
- [Ambiguities requiring resolution]

## Risk Factors
- [Domain-specific risks identified]
- [Mitigation strategies needed]
```

#### Tactical Solution Architect (TSA) Instance Specifications

**TSA Instance Pattern:**
Each TSA instance reads one reviewer's feedback and has authority to update architecture documents based on that feedback.

**TSA Instance Context (Each Instance):**
- Read `conversation_summary_[taskname].md`
- Read `technology_stack.json` (with prior TSA edits if TSA #2+)
- Read `architecture_decisions.md` (with prior TSA edits if TSA #2+)
- Read assigned reviewer feedback file
- **TSA #2-4 see cumulative changes** from earlier TSA instances

**TSA Instance Responsibilities:**
- Evaluate reviewer feedback for validity and priority
- Update `technology_stack.json` with technology changes
- Update `architecture_decisions.md` with new/revised decisions
- Append to `tsa_changelog.md` documenting what was incorporated and why
- Document rationale for feedback NOT incorporated

**TSA Changelog Format:**

**File**: `orchestration/architecture_feedback/tsa_changelog.md`

```markdown
# Tactical Solution Architect Change Log

## TSA Instance #1: [Domain] Review
**Timestamp**: [unix epoch]
**Reviewer Feedback**: [filename].md

### Changes Made:
1. **technology_stack.json - [section].[field]**: Changed from "[old]" to "[new]"
   - **Reason**: [Why this change was made based on reviewer feedback]
   - **Supporting evidence**: [Reference to conversation summary or constraints]

2. **architecture_decisions.md - Decision [N]**: Added new decision "[Title]"
   - **Reason**: [Why this decision was needed]
   - **Implication**: [Impact on implementation]

### Feedback Not Incorporated:
1. **Suggestion**: [Specific reviewer suggestion]
   - **Reason**: [Why not incorporated - not justified, premature optimization, conflicts with constraints, etc.]
   - **Deferred**: [If applicable, conditions under which this could be revisited]

---

## TSA Instance #2: [Domain] Review
**Timestamp**: [unix epoch]
**Reviewer Feedback**: [filename].md

[Same structure as TSA Instance #1]
```

#### Execution Sequence

**Complete two-stage workflow:**

```
1. Solution Architect conducts architecture design conversation
2. Solution Architect writes DRAFT technology_stack.json and architecture_decisions.md
3. Solution Architect analyzes conversation summary to determine review order
4. Solution Architect creates architecture_feedback/ directory
5. Solution Architect writes review_sequence.md documenting order and rationale

6. STAGE 1: Specialized Reviewer Agents (Serial, Order from review_sequence.md)

   Reviewer #1 (e.g., Security Architecture Reviewer):
   - Reads: conversation_summary.md, technology_stack.json (draft), architecture_decisions.md (draft)
   - Writes: architecture_feedback/security_review.md

   Reviewer #2 (e.g., Database/Storage Architecture Reviewer):
   - Reads: all documents + security_review.md (from Reviewer #1)
   - Writes: architecture_feedback/database_storage_review.md
   - References Security concerns in analysis

   Reviewer #3 (e.g., API/Data Flow Architecture Reviewer):
   - Reads: all documents + security_review.md + database_storage_review.md
   - Writes: architecture_feedback/api_dataflow_review.md
   - References Security and Database concerns

   Reviewer #4 (e.g., Frontend Architecture Reviewer):
   - Reads: all documents + all prior feedback (security, database, API)
   - Writes: architecture_feedback/frontend_review.md
   - References all prior domain concerns

7. STAGE 2: Tactical Solution Architect Instances (Serial, Same Order)

   TSA Instance #1:
   - Reads: conversation_summary.md, technology_stack.json (draft), architecture_decisions.md (draft), security_review.md
   - Updates: technology_stack.json and architecture_decisions.md
   - Appends: tsa_changelog.md with changes/rationale

   TSA Instance #2:
   - Reads: conversation_summary.md, technology_stack.json (WITH TSA #1 edits), architecture_decisions.md (WITH TSA #1 edits), database_storage_review.md
   - Updates: technology_stack.json and architecture_decisions.md (sees and builds on TSA #1 changes)
   - Appends: tsa_changelog.md

   TSA Instance #3:
   - Reads: all documents with TSA #1-2 edits + api_dataflow_review.md
   - Updates: architecture documents (builds on TSA #1-2 changes)
   - Appends: tsa_changelog.md

   TSA Instance #4:
   - Reads: all documents with TSA #1-3 edits + frontend_review.md
   - Updates: architecture documents (builds on TSA #1-3 changes)
   - Appends: tsa_changelog.md

8. Solution Architect presents final architecture to user with:
   - Review order rationale (from review_sequence.md)
   - Summary of key changes (from tsa_changelog.md)
   - Final technology_stack.json and architecture_decisions.md
```

#### Integration with Workflow Execution

**Consistency Throughout Project Lifecycle:**

**Upfront Design Phase (Solution Architect):**
- TSA instances review specialized feedback and update architecture documents
- Establishes TSA as the architecture decision-making agent type
- TSA operates within conversation summary constraints

**Execution Phase (via Escalation Resolution Agent):**
- When doer agents escalate architecture questions during execution, Escalation Resolution Agent spawns TSA agent instances
- Same TSA agent type used, maintaining consistency
- TSA reads `architecture_decisions.md` for context, makes tactical decisions within established architecture constraints
- TSA appends tactical decisions to "Evolution Notes" section of architecture_decisions.md

**Benefits of consistent TSA usage:**
- ✅ Same decision-making framework throughout project
- ✅ TSA familiar with architecture from upfront involvement
- ✅ Clear accountability for all architecture decisions
- ✅ Seamless transition from upfront to tactical architecture

#### Key Benefits

✅ **Cumulative intelligence**: Each reviewer builds on prior insights

✅ **Conflict prevention**: Later reviewers catch contradictions early

✅ **Cross-domain validation**: Security reviewer sees database concerns, flags implications

✅ **Richer recommendations**: Reviewers propose solutions integrating multiple domains

✅ **Context-driven flexibility**: Review order adapts to project nature

✅ **Clear role separation**: Reviewers analyze, TSA decides

✅ **Accountability**: TSA owns all architecture changes (traceable via changelog)

✅ **Consistent pattern**: Same serial pattern for reviewers and TSA instances

✅ **Complete audit trail**: review_sequence.md + feedback files + tsa_changelog.md document entire analysis → decision flow

✅ **Context efficiency**: Each agent has focused, relevant context only

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
- `agent_roster.json` containing:
  - Agents needed with existence flags
  - Basic agent-level dependencies
  - Missing agent specifications (if any)
- `workflow_sequence.json` containing:
  - Execution phases with parallelism specifications
  - Dependency graph
  - Critical path analysis
- `workflow_coordination_plan.md` containing:
  - Narrative description of workflow design
  - Validation checkpoints and escalation procedures
  - Human-readable execution plan overview
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

   **Detailed Specification:**

   **Inputs:**
   1. `orchestration/conversation_summary_[taskname].md`
      - "Dependencies & Integration Points" section
      - Technical context about system integration
      - External service dependencies
   2. `orchestration/agent_roster.json`
      - Agent-level dependencies (from Agent Roster Designer)
      - Example: `"api_agent": {"dependencies": ["database_agent"]}`
      - Capabilities required by each agent
   3. File communication contracts (from File Structure Designer)
      - What files each agent reads/writes
      - Data flow between agents
   4. Validation checkpoint specifications (from Validation Checkpoint Designer)
      - Which agents require verification
      - When verification should occur

   **What Agent Roster Designer Provides vs What Sequencing Agent Determines:**
   - **Agent Roster Designer provides**: WHAT agents are needed + basic agent-level dependencies
   - **Workflow Sequencing Agent determines**: WHEN agents run + HOW they coordinate (sequential/parallel)

   **Example:**
   - Agent Roster Designer: "api_agent depends on database_agent"
   - Workflow Sequencing Agent: "Step 1: database_agent. Step 2: database_verifier. Step 3 (parallel): api_agent + frontend_agent. Step 4: api_verifier + frontend_verifier."

   **Decision Algorithm:**

   1. **Build Dependency Graph**
      - Read agent dependencies from agent_roster.json
      - Add verification dependencies (verifier must follow doer)
      - Add file-based dependencies (agent reads another's output)
      - Detect circular dependencies → error if found

   2. **Identify Parallelization Opportunities**
      - Agents with no dependencies can start immediately
      - Agents with satisfied dependencies can run in parallel IF:
        - They don't write to the same files
        - They don't have resource conflicts
        - They have independent data flows
      - Example: api_agent and frontend_agent can run in parallel if both depend only on database_agent

   3. **Insert Verification Steps**
      - After each doer agent completes → verifier step
      - Verification must complete before dependent agents start
      - Multiple independent verifiers can run in parallel

   4. **Determine Execution Phases**
      - Phase = set of agents that can run in parallel
      - Phase boundaries = synchronization points
      - Example:
        ```
        Phase 1: [database_agent]
        Phase 2: [database_verifier]
        Phase 3: [api_agent, frontend_agent, docs_agent]  # Parallel
        Phase 4: [api_verifier, frontend_verifier, docs_verifier]  # Parallel
        Phase 5: [integration_test_agent]
        Phase 6: [integration_verifier]
        ```

   5. **Handle Special Cases**
      - PoC tasks run before dependent main workflow tasks
      - Archival agent runs last (after all verifiers)
      - Tactical Solution Architect agent runs on-demand (escalation-driven, not in main sequence)

   **Output Format:**

   Location: `orchestration/workflow_sequence.json`

   ```json
   {
     "task_id": "implement_user_management",
     "created": 1729008000,
     "execution_phases": [
       {
         "phase_id": 1,
         "phase_name": "Database Schema Creation",
         "parallel": false,
         "agents": [
           {
             "agent_name": "database_agent",
             "agent_type": "doer",
             "dependencies_satisfied_by_phase": null,
             "estimated_duration": "unknown"
           }
         ]
       },
       {
         "phase_id": 2,
         "phase_name": "Database Verification",
         "parallel": false,
         "agents": [
           {
             "agent_name": "database_verifier",
             "agent_type": "verifier",
             "verifies": ["database_agent"],
             "dependencies_satisfied_by_phase": 1
           }
         ]
       },
       {
         "phase_id": 3,
         "phase_name": "Service Layer Implementation",
         "parallel": true,
         "agents": [
           {
             "agent_name": "api_agent",
             "agent_type": "doer",
             "dependencies_satisfied_by_phase": 2,
             "estimated_duration": "unknown"
           },
           {
             "agent_name": "frontend_agent",
             "agent_type": "doer",
             "dependencies_satisfied_by_phase": 2,
             "estimated_duration": "unknown"
           }
         ]
       },
       {
         "phase_id": 4,
         "phase_name": "Service Layer Verification",
         "parallel": true,
         "agents": [
           {
             "agent_name": "api_verifier",
             "agent_type": "verifier",
             "verifies": ["api_agent"],
             "dependencies_satisfied_by_phase": 3
           },
           {
             "agent_name": "frontend_verifier",
             "agent_type": "verifier",
             "verifies": ["frontend_agent"],
             "dependencies_satisfied_by_phase": 3
           }
         ]
       }
     ],
     "total_phases": 4,
     "parallelization_summary": {
       "total_agents": 6,
       "max_parallel_agents": 2,
       "sequential_phases": 2,
       "parallel_phases": 2
     },
     "critical_path": [
       "database_agent",
       "database_verifier",
       "api_agent",
       "api_verifier"
     ],
     "dependency_graph": {
       "database_agent": [],
       "database_verifier": ["database_agent"],
       "api_agent": ["database_verifier"],
       "frontend_agent": ["database_verifier"],
       "api_verifier": ["api_agent"],
       "frontend_verifier": ["frontend_agent"]
     }
   }
   ```

   **Edge Cases and Error Handling:**

   1. **Circular Dependencies**
      - Detection: Depth-first search in dependency graph
      - Action: Error with description of cycle
      - Example: "Circular dependency detected: api_agent → database_agent → migration_agent → api_agent"
      - Resolution: Escalate to user via Workflow Designer Agent

   2. **Missing Dependencies**
      - Detection: Agent references dependency not in agent roster
      - Action: Error with missing agent name
      - Resolution: Agent Roster Designer re-runs to add missing agent

   3. **Resource Conflicts**
      - Detection: Two agents write to same file path
      - Action: Force sequential execution (cannot parallelize)
      - Document in workflow_sequence.json

   4. **Verification Assignment Conflicts**
      - Detection: Single verifier assigned to multiple doer agents in same phase
      - Action: Error - verifier cannot verify in parallel
      - Resolution: Create separate verifier instances or serialize verification

   **Integration with Workflow Executor:**

   The Workflow Executor reads `workflow_sequence.json` and:
   1. Executes phases in order (phase N must complete before phase N+1)
   2. Within a phase marked `"parallel": true`, launches all agents simultaneously via Task tool
   3. Within a phase marked `"parallel": false`, launches single agent via Task tool
   4. Waits for all agents in a phase to complete before advancing
   5. Uses dependency_graph to validate state before launching agents

   **Example Workflow Executor Logic:**
   ```
   FOR each phase in execution_phases:
     IF phase.parallel == true:
       Launch all phase.agents in parallel via Task tool
       Wait for all Task tool calls to return
     ELSE:
       FOR each agent in phase.agents:
         Launch agent via Task tool
         Wait for Task tool to return

     Verify all agents in phase reached expected status
     Advance to next phase
   ```

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

8. **Risk Assessment & Validation Agent** (Interactive agent via slash command)
   - Identifies risky assumptions requiring validation
   - Evaluates likelihood and impact
   - Determines appropriate Proof of Concept strategies
   - User activates after Workflow Designer Agent completes (see "Risk Assessment & Proof of Concept Workflow" section)

**Delegation Pattern - Explicit Execution Order**:

The Workflow Designer Agent orchestrates sub-agents in the following sequence:

1. **Workflow Designer Agent reads conversation summary**
2. **Asks user clarifying questions** about gaps/ambiguities
3. **Phase 1: Agent Roster Design** (sequential - required first)
   - Launches **Agent Roster Designer** (Claude agent via Task tool)
   - Waits for completion
   - Reads `orchestration/agent_roster.json`
   - Presents roster to user for approval (including any missing agent creation)
   - Waits for user approval before proceeding

4. **Phase 2: Parallel Design Work** (parallel - all depend on agent roster)
   - Launches these agents simultaneously via multiple Task tool calls:
     - **File Structure Designer** (Claude agent via Task tool)
     - **Validation Checkpoint Designer** (Claude agent via Task tool)
     - **Directory Setup Agent** (Script - not Claude)
   - Waits for all three to complete before proceeding

5. **Phase 3: Instruction Writing and Sequencing** (parallel - both depend on Phase 2 outputs)
   - Launches these agents simultaneously via multiple Task tool calls:
     - **Instruction Writer Agent** (Claude agent via Task tool)
       - Requires: agent roster, file contracts, validation specs
     - **Workflow Sequencing Agent** (Claude agent via Task tool)
       - Requires: agent roster, file contracts, validation specs
   - Waits for both to complete before proceeding

6. **Phase 4: Shared Status Initialization** (sequential - depends on workflow sequence)
   - Launches **Shared Status Initializer Agent** (Script - not Claude)
   - Waits for completion

7. **Finalization and Handoff**
   - Integrates all outputs into cohesive workflow design
   - Produces final `workflow_coordination_plan.md`
   - Signals completion to user
   - **Prompts user to exit and activate Risk Assessment & Validation Agent**

**Note**: After Phase 7, the Workflow Designer Agent cannot directly invoke the Risk Assessment & Validation Agent (both are slash command personas). The user must manually exit Workflow Designer and activate Risk Assessment via `/persona-risk-assessment`.

**Key Parallelization Points**:
- Phase 2 agents can run in parallel (all only need agent roster)
- Phase 3 agents can run in parallel (both need same inputs from Phase 2)
- Phases 1 and 4 must run sequentially due to dependencies
- Phase 7 (finalization) runs sequentially after all sub-agents complete

**Benefits**:
- Distributes cognitive load across specialized agents
- Each sub-agent can be thorough in their domain
- Workflow Designer Agent maintains overall design authority
- Scripts handle mechanical operations efficiently
- No complexity penalty for using specialized agents

## Agent Discovery and Registration

### Agent Registry Structure

**Location:** `~/.claude/protocols/orchestration_agent_registry.json`

**Purpose:** Single source of truth for all available agent types in the orchestration system.

**Format:**
```json
{
  "version": "1.0",
  "last_updated": 1729008000,
  "agent_types": {
    "database_agent": {
      "invocation_pattern": "task_tool",
      "template": "~/.claude/protocols/orchestration_doer_agent_template.md",
      "capabilities": ["sql", "schema_design", "migrations", "data_modeling"],
      "description": "Creates and modifies database schemas, writes SQL migrations"
    },
    "api_agent": {
      "invocation_pattern": "task_tool",
      "template": "~/.claude/protocols/orchestration_doer_agent_template.md",
      "capabilities": ["rest_api", "http", "endpoint_design"],
      "description": "Designs and implements REST API endpoints"
    },
    "frontend_agent": {
      "invocation_pattern": "task_tool",
      "template": "~/.claude/protocols/orchestration_doer_agent_template.md",
      "capabilities": ["ui", "react", "forms", "validation"],
      "description": "Implements frontend components and user interfaces"
    },
    "verifier_agent": {
      "invocation_pattern": "task_tool",
      "template": "~/.claude/protocols/orchestration_verifier_agent_template.md",
      "capabilities": ["validation", "testing", "evidence_review"],
      "description": "Validates doer agent outputs and completion drive reviews"
    },
    "tactical_solution_architect_agent": {
      "invocation_pattern": "task_tool",
      "template": "~/.claude/protocols/orchestration_tactical_solution_architect_agent_template.md",
      "capabilities": ["tactical_architecture", "execution_phase_decisions", "architecture_evolution"],
      "description": "Makes tactical architecture decisions during execution and handles escalations from doer agents"
    },
    "archival_agent": {
      "invocation_pattern": "task_tool",
      "template": "~/.claude/protocols/orchestration_archival_agent_template.md",
      "capabilities": ["cleanup", "archival", "session_management"],
      "description": "Archives session files and manages workspace cleanup"
    }
  },
  "interactive_agents": {
    "plan_developer": {
      "invocation_pattern": "slash_command",
      "slash_command": "/persona-plan-developer",
      "command_file": "~/.claude/commands/persona-plan-developer.md",
      "description": "Conducts requirements gathering conversation with user"
    },
    "workflow_designer": {
      "invocation_pattern": "slash_command",
      "slash_command": "/persona-workflow-designer",
      "command_file": "~/.claude/commands/persona-workflow-designer.md",
      "description": "Creates multi-agent workflow designs from conversation summaries"
    },
    "design_verifier": {
      "invocation_pattern": "slash_command",
      "slash_command": "/persona-design-verifier",
      "command_file": "~/.claude/commands/persona-design-verifier.md",
      "description": "Reviews workflow designs for completeness and consistency"
    },
    "workflow_executor": {
      "invocation_pattern": "slash_command",
      "slash_command": "/persona-workflow-executor",
      "command_file": "~/.claude/commands/persona-workflow-executor.md",
      "description": "Executes workflow plans by launching agents in sequence"
    },
    "risk_assessment": {
      "invocation_pattern": "slash_command",
      "slash_command": "/persona-risk-assessment",
      "command_file": "~/.claude/commands/persona-risk-assessment.md",
      "description": "Identifies risky assumptions and coordinates PoC validation"
    },
    "escalation_resolution": {
      "invocation_pattern": "slash_command",
      "slash_command": "/persona-escalation-resolution",
      "command_file": "~/.claude/commands/persona-escalation-resolution.md",
      "description": "Handles escalations from blocked agents"
    },
    "workflow_adaptation": {
      "invocation_pattern": "slash_command",
      "slash_command": "/persona-workflow-adaptation",
      "command_file": "~/.claude/commands/persona-workflow-adaptation.md",
      "description": "Makes surgical runtime updates to workflow plans"
    },
    "solution_architect": {
      "invocation_pattern": "slash_command",
      "slash_command": "/persona-solution-architect",
      "command_file": "~/.claude/commands/persona-solution-architect.md",
      "description": "Conducts upfront architecture design and technology selection"
    }
  }
}
```

### Agent Roster Designer Process

The Agent Roster Designer (ARD) is a specialized sub-agent launched by the Workflow Designer Agent to determine which agents are needed for a workflow.

#### Phase 1: Analyze Requirements
**Input:** Conversation summary, technology stack
**Actions:**
1. Read conversation summary to understand required work
2. Read technology_stack.json to understand technology choices
3. Identify technical domains (database, API, frontend, DevOps, etc.)
4. Map domains to potential agent types based on technology stack
5. Determine agent capabilities needed
6. **Extract specific plan actions from conversation summary**
7. **Map plan actions to appropriate agents**

**Output:** Draft agent roster with action mappings (internal, not written to disk)

#### Phase 2: Check Agent Existence
**Input:** Draft agent roster
**Actions:**
1. Read `~/.claude/protocols/orchestration_agent_registry.json`
2. For each agent in draft roster:
   - Check if agent type exists in registry
   - Verify template file exists (for task_tool agents)
   - Verify slash command file exists (for interactive agents)
3. Flag agents as `exists: true` or `exists: false`

**Output:** Validated agent roster with existence flags

#### Phase 3: Generate Agent Roster Document
**Location:** `orchestration/agent_roster.json`

**Format:**
```json
{
  "task_id": "implement_user_management",
  "created": 1729008000,
  "agents": {
    "database_agent": {
      "role": "Create users table with authentication fields",
      "invocation_pattern": "task_tool",
      "template": "~/.claude/protocols/orchestration_doer_agent_template.md",
      "exists": true,
      "dependencies": [],
      "capabilities_required": ["sql", "schema_design", "migrations"],
      "plan_actions": [
        "Design user table schema with id, email, password_hash, created_at, updated_at fields",
        "Create migration script for users table",
        "Add unique constraint on email field",
        "Create indexes for common query patterns"
      ]
    },
    "api_agent": {
      "role": "Implement user CRUD endpoints",
      "invocation_pattern": "task_tool",
      "template": "~/.claude/protocols/orchestration_doer_agent_template.md",
      "exists": true,
      "dependencies": ["database_agent"],
      "capabilities_required": ["rest_api", "http", "endpoint_design"],
      "plan_actions": [
        "Create POST /users endpoint for user registration",
        "Create GET /users/:id endpoint for user retrieval",
        "Create PUT /users/:id endpoint for user updates",
        "Create DELETE /users/:id endpoint for user deletion",
        "Add authentication middleware to protected endpoints"
      ]
    },
    "data_migration_agent": {
      "role": "Migrate legacy user data to new schema",
      "invocation_pattern": "task_tool",
      "template": "~/.claude/protocols/orchestration_doer_agent_template.md",
      "exists": false,
      "creation_guidance": {
        "reason": "Need specialized agent for safe data migration with rollback capability",
        "base_template": "orchestration_doer_agent_template.md",
        "additional_capabilities": ["data_migration", "rollback", "validation"],
        "slash_command_name": null,
        "registry_entry": {
          "agent_type": "data_migration_agent",
          "invocation_pattern": "task_tool",
          "template": "~/.claude/protocols/orchestration_doer_agent_template.md",
          "capabilities": ["data_migration", "rollback", "validation", "data_integrity"],
          "description": "Safely migrates data between schemas with rollback capability"
        }
      },
      "dependencies": ["database_agent"],
      "capabilities_required": ["data_migration", "rollback", "validation"],
      "plan_actions": [
        "Extract user data from legacy system",
        "Transform legacy data to match new schema",
        "Validate data integrity before insertion",
        "Load data into new users table with transaction safety",
        "Create rollback script in case of migration failure"
      ]
    },
    "verifier_agent": {
      "role": "Validate all agent outputs",
      "invocation_pattern": "task_tool",
      "template": "~/.claude/protocols/orchestration_verifier_agent_template.md",
      "exists": true,
      "dependencies": [],
      "capabilities_required": ["validation", "testing", "evidence_review"],
      "plan_actions": [
        "Verify database schema matches requirements",
        "Verify API endpoints return correct responses",
        "Verify data migration completed without data loss",
        "Review completion drive notes for all agents"
      ]
    }
  },
  "missing_agents": ["data_migration_agent"],
  "requires_user_action": true
}
```

### Missing Agent Handling Workflow

When the Agent Roster Designer detects that required agents don't exist in the registry, the Workflow Designer Agent offers to guide the user through creating them one at a time.

#### Guided Creation Workflow

**Workflow Designer Agent orchestrates one-at-a-time guided creation:**

1. **Present roster with missing agents identified** (already in agent_roster.json)
2. **Offer to create missing agents**:
   - "I can guide you through creating these agents, one at a time."
   - Start with first missing agent
3. **For each missing agent, conduct interactive creation conversation**:
   - Ask clarifying questions about agent requirements
   - Understand data types, operations, constraints
   - Determine validation and rollback strategies
   - Discuss capabilities and responsibilities
4. **Create agent artifacts**:
   - Add entry to `orchestration_agent_registry.json`
   - Write custom template if needed (beyond base template)
   - Update agent_roster.json to mark agent as existing
5. **Move to next missing agent** (if any remain)
6. **Continue workflow design** once all agents exist

**Example user presentation:**
```markdown
## Agent Roster Analysis Complete

I've identified the agents needed for this workflow. However, some agents don't exist yet:

### Existing Agents (Ready to Use)
✅ database_agent - Create users table with authentication fields
✅ api_agent - Implement user CRUD endpoints
✅ verifier_agent - Validate all agent outputs

### Missing Agents (Need Creation)
❌ **data_migration_agent** - Migrate legacy user data to new schema
   - **Why needed:** Specialized agent for safe data migration with rollback capability
   - **Base template:** orchestration_doer_agent_template.md
   - **Additional capabilities:** data_migration, rollback, validation
   - **Invocation:** Task tool (autonomous agent)
   - **Plan actions:**
     - Extract user data from legacy system
     - Transform legacy data to match new schema
     - Validate data integrity before insertion
     - Load data into new users table with transaction safety
     - Create rollback script in case of migration failure

### Next Steps

I can guide you through creating the data_migration_agent. We'll:
1. Use the orchestration_doer_agent_template.md as base
2. Add data migration-specific guidance through conversation
3. Create registry entry in orchestration_agent_registry.json
4. Mark as existing and continue workflow design

**Would you like to proceed with creating data_migration_agent?**
```

#### All Agents Exist - Approval Request

**Example user presentation when all agents exist:**
```markdown
## Agent Roster Analysis Complete

I've identified the agents needed for this workflow. All agents exist and are ready to use:

### Proposed Agent Roster

**database_agent** - Create users table with authentication fields
- Dependencies: None
- Plan actions:
  1. Design user table schema with id, email, password_hash, created_at, updated_at fields
  2. Create migration script for users table
  3. Add unique constraint on email field
  4. Create indexes for common query patterns

**api_agent** - Implement user CRUD endpoints
- Dependencies: database_agent
- Plan actions:
  1. Create POST /users endpoint for user registration
  2. Create GET /users/:id endpoint for user retrieval
  3. Create PUT /users/:id endpoint for user updates
  4. Create DELETE /users/:id endpoint for user deletion
  5. Add authentication middleware to protected endpoints

**frontend_agent** - Build user management UI components
- Dependencies: api_agent
- Plan actions:
  1. Create user registration form with validation
  2. Create user profile page with edit capability
  3. Create user list view for admin
  4. Add loading states and error handling

**verifier_agent** - Validate all agent outputs
- Dependencies: None
- Plan actions:
  1. Verify database schema matches requirements
  2. Verify API endpoints return correct responses
  3. Verify frontend components render properly
  4. Review completion drive notes for all agents

### Workflow Flow
```
database_agent → database_verifier
                       ↓
                 api_agent → api_verifier
                       ↓
              frontend_agent → frontend_verifier
```

**Does this agent selection look correct? Would you like to:**
- **Proceed** with this agent roster?
- **Modify** the agent selection or responsibilities?
- **Add/remove** agents from the roster?
```

### Integration with Workflow Designer Agent

#### Workflow Designer Agent Startup Sequence

```
1. Read conversation_summary.md
2. Launch Agent Roster Designer (Task tool)
3. Read orchestration/agent_roster.json
4. ALWAYS present roster to user for approval:
   → Show all agents with roles/responsibilities
   → Show mapping of agents to plan actions
   → Show dependencies between agents
   → IF missing_agents array is not empty:
      → Offer guided creation: "I can guide you through creating these agents, one at a time."
      → For each missing agent, conduct interactive creation conversation
      → Create agent artifacts (registry entry, templates, mark as existing)
   → ELSE:
      → Request approval to proceed with agent selection
5. Wait for user approval/decision
6. Continue with workflow design (once all agents exist)
```

#### Agent Roster Designer Contract

**Inputs:**
- `orchestration/conversation_summary_[taskname].md`
- `orchestration/technology_stack.json`
- `~/.claude/protocols/orchestration_agent_registry.json`

**Outputs:**
- `orchestration/agent_roster.json` (structured format shown above)

**Agent must:**
- Check existence of every agent it proposes
- **Map agents to specific plan actions** from conversation summary
- Provide `plan_actions` array for each agent showing concrete tasks
- Ensure plan_actions are specific, actionable, and traceable to requirements
- Provide complete creation guidance for missing agents
- Set `requires_user_action: true` if any agents missing
- Include registry entry specifications for missing agents

**Plan action mapping requirements:**
- Each agent must have 3-7 specific actions listed
- Actions should be concrete and verifiable (not vague)
- Actions must be traceable to conversation summary requirements
- Actions should show the full scope of agent's responsibilities

### Benefits of This Approach

✅ **Clear discovery mechanism** - Registry provides single source of truth
✅ **User validation required** - Roster always presented for approval before proceeding
✅ **Transparent agent selection** - User sees exactly which agents will do what work
✅ **Action-level visibility** - Mapping from requirements to concrete agent tasks
✅ **Early course correction** - User can modify agent selection before workflow design completes
✅ **Guided agent creation** - One-at-a-time interactive creation with complete specifications
✅ **Conversational workflow** - User guides agent creation through natural dialogue
✅ **Structured output** - Machine-readable agent roster format with action mappings
✅ **File-based** - Consistent with orchestration system philosophy

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
Solution Architecture (Solution Architect)
    ↓
Technology Stack & Architecture Decisions
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

3. **`~/.claude/protocols/orchestration_tactical_solution_architect_agent_template.md`**
   - Template for Tactical Solution Architect agent (works like doer agent, handles escalations)
   - Includes architecture decision-making guidance within established architecture constraints

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
   - Creates `agent_roster.json` with agent specifications
   - Creates `workflow_sequence.json` with execution phases and parallelism
   - Creates `workflow_coordination_plan.md` with narrative workflow description
   - Creates `completion_drive/`, `task_output/` subdirectories for each agent

3. **Workflow Executor** (activated via `/persona-workflow-executor`):
   - Reads `workflow_sequence.json` (machine-readable execution plan) and `shared_status.json`
   - Reads `workflow_coordination_plan.md` for human-readable context if needed
   - Begins launching autonomous agents via Task tool according to execution phases
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

Yes, multiple independent agents can work in parallel if the Workflow Sequencing Agent (part of the Workflow Architecture Group) specifies parallel execution in `workflow_sequence.json`. The decision about sequential vs parallel execution is made during workflow design, not by the Workflow Executor at runtime. The Executor simply follows the execution phases specified in workflow_sequence.json, launching all agents in a parallel phase simultaneously via multiple Task tool calls.

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
**Status**: ✅ **ANSWERED**

See "Agent Discovery and Registration" section (line 1117) for complete specification including agent registry structure, Agent Roster Designer process, missing agent handling workflow, and integration with Workflow Designer Agent.

### Q10: Escalation Priority with Multiple Blocked Agents
**Status**: ✅ **ANSWERED**

First Come First Serve - handle blockers in the order they occurred (using `last_update` timestamp in `shared_status.json`).

**Rationale**: If the Workflow Architecture Group designed agents to run in parallel, they determined the agents' work is independent. Therefore, their escalations are also independent, and resolution order doesn't matter. For serial execution, simultaneous blockers are not possible.