# Step-Through Workflow Protocol v3.0

## Overview
A systematic approach for coordinating multiple specialized agents in complex, multi-step processes. The protocol ensures proper handoffs between agents while maintaining user control, creating comprehensive audit trails, and optimizing context efficiency.

## File Organization System

### Directory Structure
```
workflows/logs/
├── cake-baking-001/
│   ├── current.md      ← Lightweight, current state only
│   ├── step01.md       ← Backup after Agent A completes
│   ├── step02.md       ← Backup after Agent C completes
│   └── step03.md       ← Backup after Agent B completes
├── cake-baking-002/    ← Next test run
├── cypher-migration-001/
└── database-cleanup-001/
```

### File Management Rules
- **current.md**: Always lightweight - just handoff info and key context
- **stepXX.md**: Full backup created when agent completes their work
- **Directory naming**: `[workflow-name]-[###]` with auto-incrementing numbers
- **File system timestamps**: Provide creation time automatically

## Core Principles

### 1. User Orchestration
- **User maintains control** of workflow progression between all agent handoffs
- **User approval required** before each new agent begins work
- **User directs** each agent transition based on documented workflow requirements
- **All agent-to-agent communication occurs through documented files** with user oversight

### 2. Context-Efficient Documentation with Agent Boundary Intelligence
- **Same Agent Type**: Lightweight handoffs with cumulative updates only
- **Different Agent Type**: Comprehensive multi-step summaries with full context
- **Audit Agents**: Detailed summaries with evidence, confidence ratings, and verification data
- **Complete audit trail preserved** in numbered backup files
- **Documentation serves as communication medium** between agents in the workflow
- **Standardized format** ensures consistency across all agent types

### 3. Explicit Agent Handoffs with Summary Intelligence
- **Completing agent updates current.md** with appropriate summary level based on next agent type
- **Completing agent creates full backup** with detailed work documentation
- **User reviews** agent completion before initiating next agent
- **Next agent reads** contextually appropriate summary for their function

### 4. Multi-Step Summary Rules
- **Structure maps to workflow document steps** for easy cross-reference
- **Detail level adapts to next agent's function** (execution vs. audit vs. validation)
- **Agent-type boundaries trigger summary format changes** to optimize context transfer
- **Quality control agents receive comprehensive audit trails** for proper verification

## Updated Agent Workflow

### Agent Completion Process
1. **Read context**: `workflows/logs/[workflow-run]/current.md`
2. **Execute assigned step** per workflow document
3. **Create backup**: Copy current.md to `stepXX.md` with full details of completed work
4. **Update current.md**: Replace with lightweight handoff summary
5. **Present results** onscreen with next agent instruction

### Agent Handoff Format

#### Lightweight Handoff (Same Agent Type)
```markdown
# Workflow: [Workflow Name] - Step X Complete

## Current Status
**Step**: X of Y completed
**Last Agent**: Agent [Name] ([specialty])
**Confidence**: XX%
**Next**: Agent [Name], Step [X+1] ([Task Description])

## Key Context for Next Agent
- [Key point 1] ✅
- [Key point 2] ✅
- [Key point 3] ⚠️

## Handoff Instruction
Ready for Agent [Name] to execute Step [X+1]: [Task Name]
Reference: workflows/logs/[workflow-run]/current.md
```

#### Comprehensive Handoff (Different Agent Type or Audit Agent)
```markdown
# Workflow: [Workflow Name] - Step X Complete

## Current Status
**Step**: X of Y completed
**Last Agent**: Agent [Name] ([specialty])
**Confidence**: XX%
**Next**: Agent [Name], Step [X+1] ([Task Description])

## Multi-Step Progress Summary
### Step 1: [Step Name] - [Status] ✅/⚠️/❌
- **Agent**: [Agent Name] ([Specialty])
- **Confidence**: XX%
- **Key Outcomes**: [Brief outcome summary]
- **Evidence**: [Specific evidence or validation performed]

### Step 2: [Step Name] - [Status] ✅/⚠️/❌
- **Agent**: [Agent Name] ([Specialty])
- **Confidence**: XX%
- **Key Outcomes**: [Brief outcome summary]
- **Evidence**: [Specific evidence or validation performed]

[Continue for all completed steps]

## Key Context for Next Agent
- [Comprehensive context from all completed steps]
- [Critical findings that affect next steps]
- [Risk factors identified]

## Handoff Instruction
Ready for Agent [Name] to execute Step [X+1]: [Task Name]
Reference: workflows/logs/[workflow-run]/current.md
```

### User Commands Simplified
```
"Agent A, execute your step using workflows/logs/[workflow-run]/current.md"
```

## Protocol Implementation

### Agent Completion Requirements
When any agent completes a task in a Step-Through Workflow:
1. **Present results** with confidence ratings and evidence
2. **Create full backup** with detailed work documentation
3. **Determine handoff format** based on next agent type and function:
   - **Same agent type**: Lightweight cumulative update
   - **Different execution agent**: Comprehensive multi-step summary
   - **Audit/quality control agent**: Detailed summary with evidence and confidence ratings
4. **Update current.md** with appropriate handoff format
5. **Display handoff summary** onscreen in well-formatted, readable format
6. **Specify next agent** and step per the workflow document
7. **Wait for user approval** before any workflow progression

### Agent Type Classification for Summary Intelligence
- **Execution Agents**: Focus on implementation (content-migration-specialist, database-architect, etc.)
- **Quality Control Agents**: Focus on verification (doubting-thomas, ttrpg-balance-advisor in review mode)
- **Analysis Agents**: Focus on assessment (ttrpg-balance-advisor, system-analyst)
- **Audit Agents**: Focus on validation and compliance checking

### Implementation Guidelines for Agents

#### When to Use Lightweight Handoff Format
- Next agent is **same type** as current agent (e.g., content-migration-specialist → content-migration-specialist)
- Workflow step is **sequential continuation** of same agent's work
- Context requirements are **minimal** for next step execution

#### When to Use Comprehensive Handoff Format
- Next agent is **different type** from current agent (e.g., ttrpg-balance-advisor → content-migration-specialist)
- Next agent is **quality control or audit agent** (doubting-thomas, review-mode agents)
- Workflow involves **multiple completed steps** that affect next agent's work
- Next agent needs **full context** to perform verification, validation, or complex analysis

#### Evidence Requirements for Quality Control Agents
When handing off to quality control or audit agents, include:
- **Specific evidence** of work performed (file changes, test results, validation steps)
- **Confidence ratings** with justification for each completed step
- **Risk assessments** and mitigation steps taken
- **Verification methods** used to validate outcomes
- **Assumptions made** and their impact on conclusions

### User Coordination Steps
For each agent transition:
1. **Review** completed agent's results and onscreen handoff summary
2. **Assess** workflow progression and next steps required
3. **Initiate next agent** with simple command referencing current.md
4. **Monitor** agent execution and maintain workflow oversight

### Documentation Display Standards
- **Well-formatted presentation** using markdown rendering or structured text display
- **Clear section headers** for easy scanning
- **Highlighted key information** (confidence ratings, next steps, critical findings)
- **Concise handoff summary** with essential context only
- **File path reference** for detailed documentation when needed

## Benefits of v2.0
- ✅ **Context efficient** - Agents only read lightweight current state
- ✅ **Complete audit trail** - All details preserved in numbered backups  
- ✅ **Simple commands** - Same file reference every time
- ✅ **Easy debugging** - Can examine any step's full details
- ✅ **Clean organization** - Dedicated workflow logging space
- ✅ **Seamless user experience** - No application switching required
- ✅ **Maintains user control** over complex automated processes
- ✅ **Scales effectively** across projects and agent types

## Example Usage

### Real-World Scenario: Cypher to PostgreSQL Database Migration

This example demonstrates a complete workflow execution from start to finish, showing agent handoffs, file management, and user oversight throughout the process.

#### Initial Setup
**Workflow document**: `workflows/cypher_to_postgres_migration_workflow.md` (defines 5 steps)
**Log directory**: `workflows/logs/cypher-migration-001/`
**Participating agents**:
- Agent A: content-migration-specialist (execution agent)
- Agent B: database-architect (execution agent)
- Agent C: doubting-thomas (quality control agent)

#### Step 1: Requirements Analysis
**User initiates**:
```
"Agent A (content-migration-specialist), execute Step 1 using workflows/logs/cypher-migration-001/current.md"
```

**Agent A actions**:
1. Reads `current.md` (contains initial workflow parameters)
2. Analyzes Cypher database requirements from source files
3. Documents findings (125 nodes, 8 relationship types, 3 constraints)
4. Creates full backup: `step01.md` (detailed analysis, 450 lines)
5. Updates `current.md` with lightweight handoff (next: Agent B, same type)

**Agent A handoff summary** (displayed onscreen):
```markdown
# Workflow: Cypher to PostgreSQL Migration - Step 1 Complete

## Current Status
**Step**: 1 of 5 completed
**Last Agent**: Agent A (content-migration-specialist)
**Confidence**: 92%
**Next**: Agent B (database-architect), Step 2 (Schema Design)

## Key Context for Next Agent
- ✅ Identified 125 nodes across 4 entity types
- ✅ Mapped 8 relationship types with cardinality
- ✅ Found 3 uniqueness constraints requiring indexes
- ⚠️ Temporal data patterns need datetime strategy

## Handoff Instruction
Ready for Agent B to execute Step 2: PostgreSQL Schema Design
Reference: workflows/logs/cypher-migration-001/current.md
```

**User action**: Reviews results, approves progression

#### Step 2: Schema Design
**User initiates**:
```
"Agent B (database-architect), execute Step 2 using workflows/logs/cypher-migration-001/current.md"
```

**Agent B actions**:
1. Reads `current.md` (lightweight summary from Agent A)
2. Designs PostgreSQL schema (tables, relationships, indexes)
3. Creates DDL scripts with inline documentation
4. Creates full backup: `step02.md` (schema design, DDL, 380 lines)
5. Updates `current.md` with comprehensive handoff (next: Agent C, different type - quality control)

**Agent B handoff summary** (displayed onscreen):
```markdown
# Workflow: Cypher to PostgreSQL Migration - Step 2 Complete

## Current Status
**Step**: 2 of 5 completed
**Last Agent**: Agent B (database-architect)
**Confidence**: 88%
**Next**: Agent C (doubting-thomas), Step 3 (Schema Validation)

## Multi-Step Progress Summary
### Step 1: Requirements Analysis - Complete ✅
- **Agent**: Agent A (content-migration-specialist)
- **Confidence**: 92%
- **Key Outcomes**: Identified 125 nodes, 8 relationships, 3 constraints
- **Evidence**: Analyzed 15 Cypher query files, documented all entity types

### Step 2: PostgreSQL Schema Design - Complete ✅
- **Agent**: Agent B (database-architect)
- **Confidence**: 88%
- **Key Outcomes**: Created normalized schema with 12 tables, 15 indexes, 8 foreign keys
- **Evidence**: Generated DDL scripts, validated naming conventions, applied best practices

## Key Context for Next Agent
- All Cypher entities mapped to relational tables
- Temporal data using TIMESTAMP WITH TIME ZONE
- Graph relationships converted to junction tables
- Performance indexes designed for expected query patterns
- Schema follows PostgreSQL naming conventions

## Handoff Instruction
Ready for Agent C to execute Step 3: Schema Validation and Risk Assessment
Reference: workflows/logs/cypher-migration-001/current.md
```

**User action**: Reviews schema design, approves validation step

#### Step 3: Quality Control Validation
**User initiates**:
```
"Agent C (doubting-thomas), execute Step 3 using workflows/logs/cypher-migration-001/current.md"
```

**Agent C actions**:
1. Reads `current.md` (comprehensive multi-step summary with evidence)
2. Validates schema design against requirements
3. Identifies 3 potential issues (2 minor, 1 moderate)
4. Provides recommendations for mitigation
5. Creates full backup: `step03.md` (validation report, 280 lines)
6. Updates `current.md` with lightweight handoff (returning to execution agent type)

**Agent C findings**:
- ✅ All entity types properly represented
- ✅ Constraints correctly implemented
- ⚠️ Index on user_events.timestamp may need partitioning at scale
- ⚠️ Missing index on junction table for reverse relationship queries
- ❌ Temporal precision mismatch (Cypher uses milliseconds, schema uses seconds)

**User action**: Reviews validation report, directs Agent B to address temporal precision issue

#### Step 4: Schema Refinement
**User initiates** (corrective action):
```
"Agent B, update the schema to address the temporal precision issue identified in Step 3"
```

**Agent B actions**:
1. Reads `current.md` (validation findings)
2. Updates DDL to use millisecond precision
3. Adds migration notes about precision handling
4. Creates backup: `step04.md`
5. Updates `current.md` with handoff

**User action**: Reviews refinement, approves migration script creation

#### Step 5: Migration Script Generation
**User continues** with remaining workflow steps following the same pattern through completion.

#### Workflow Completion
**Final state**:
- **Directory**: `workflows/logs/cypher-migration-001/`
- **Files created**: `current.md`, `step01.md` through `step05.md`
- **Audit trail**: Complete history of all agent work preserved in backups
- **Context efficiency**: Each agent only read lightweight `current.md` (avg 50 lines)
- **User control**: User approved each transition and directed corrective actions
- **Quality assurance**: Quality control agent validated work before proceeding

### Key Benefits Demonstrated
- ✅ **Lightweight handoffs** between same-type agents (Steps 1→2)
- ✅ **Comprehensive summaries** for quality control agents (Step 2→3)
- ✅ **Complete audit trail** preserved in numbered backups
- ✅ **User oversight** at every agent transition
- ✅ **Flexible workflow** allowing corrective actions (Step 3→4)
- ✅ **Context efficiency** - agents read ~50 lines vs. full 450+ line histories

## Application
Use Step-Through Workflow Protocol for:
- Multi-agent database migrations
- Complex code refactoring across multiple files
- System configuration changes requiring validation
- Any process requiring specialized agents with interdependent steps

This protocol transforms complex multi-agent processes into manageable, user-controlled workflows with comprehensive documentation, context efficiency, and quality assurance at every step.

---

## Change Log
- **2025-01-16** - Initial draft created based on multi-agent coordination requirements (Tom - Project Owner)
- **2025-01-16** - Corrected agent communication description to reflect documented file-based coordination (Tom - Project Owner)
- **2025-01-16** - Added documentation display requirements for seamless user experience (Tom - Project Owner)
- **2025-01-16** - **v2.0**: Updated with context-efficient file organization system, hierarchical directory structure, and simplified user commands (Tom - Project Owner)
- **2025-09-14** - Updated log location from "workflow/logs" to "workflows/logs" to match project directory structure (Tom - Project Owner)
- **2025-09-14** - **v2.1**: Implemented multi-step summary intelligence with agent boundary handling - addresses quality control agent context deficiency by providing comprehensive summaries for audit agents while maintaining lightweight handoffs for execution agents (Workflow Architect)
- **2025-09-14** - Added agent type classification system and summary format rules to ensure proper context transfer based on next agent's function (Workflow Architect)
- **2025-10-18** - **v3.0**: Enhanced Example Usage section with complete real-world workflow scenario demonstrating agent handoffs, file management, user oversight, and quality control validation (Claude - Documentation Specialist)