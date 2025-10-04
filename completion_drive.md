# Completion Drive

In the context of AI agents, completion drive is the tendency to push toward finishing or "completing" a task even when:

- The task isn't fully defined or understood
- Critical information is missing
- The user hasn't actually asked for completion
- Stopping to ask clarifying questions would be more appropriate

This manifests as agents jumping to implementation before understanding requirements, claiming tasks are "done" without proper validation, or continuing to work when they should pause for user input or clarification.

It's the bias toward action and closure rather than deliberate investigation, questioning, or incremental progress with user feedback loops.

## Implementation Approach

### Completion Drive Marking
Agents should flag completion drive moments as they occur:

**For code work:** Insert comments like `// #COMPLETION_DRIVE: assuming user wants validation here`

**For non-code work:** Add explicit callouts in responses:
```
⚠️ COMPLETION_DRIVE: Moving to implementation without confirming data format requirements
⚠️ COMPLETION_DRIVE: Assuming table relationships based on naming patterns
```

### Multi-Agent Systems
In orchestrated environments, completion drive becomes critical because:
- Do'er agents might claim "done" while having unresolved assumptions
- Orchestrator makes decisions based on incomplete status reports
- Poor handoffs between agents due to undocumented assumptions

### Gated Completion Drive Review
**Mandatory gate:** Agents cannot report "done" until completion drive review is complete.

**Process:**
1. Agent tracks completion drive notes throughout work
2. Before claiming "done", agent must review and resolve all notes
3. Unresolvable assumptions must be escalated for clarification
4. Only after clean completion drive review can agent report "done"

### Session-Based Tracking
**File structure:**
```
orchestration/agents/<agent_name>/completion_drive/
├── session_current.json     # active session notes
├── session_20250928_143022.json  # archived sessions
└── session_20250928_091544.json
```

**JSON format:**
```json
{
  "agent_id": "database_agent",
  "task_id": "create_user_table",
  "session_start": "2025-09-28T14:30:00Z",
  "notes": [
    {
      "timestamp": "2025-09-28T14:45:00Z",
      "type": "assumption",
      "description": "Assuming email field should be unique",
      "context": "Creating users table without explicit uniqueness requirements",
      "status": "resolved",
      "resolution": "Confirmed with user - email uniqueness required"
    }
  ]
}
```

**Note statuses:**
- `open` - assumption identified, needs resolution
- `resolved` - agent addressed the assumption
- `escalated` - requires orchestrator/user clarification

### Session Lifecycle
1. **Session start:** Agent creates `session_current.json`
2. **Work phase:** Agent logs completion drive notes as they occur
3. **Completion review:** Agent resolves all notes before claiming "done"
4. **Session end:** Orchestrator signals task complete → archival agent moves to timestamped archive

This ensures agents start each new task with clean completion drive context while maintaining audit trail of assumptions and resolutions.
