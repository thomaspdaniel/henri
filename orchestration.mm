<?xml version="1.0" encoding="UTF-8"?>
<map version="freeplane 1.11.5">
  <node TEXT="Orchestration System" ID="ID_ROOT" BACKGROUND_COLOR="#FFFFFF">
    <font NAME="SansSerif" SIZE="14" BOLD="true"/>

    <!-- Workflow Lifecycle Branch -->
    <node TEXT="Workflow Lifecycle" POSITION="right" BACKGROUND_COLOR="#CCE5FF">
      <font NAME="SansSerif" SIZE="12" BOLD="true"/>

      <node TEXT="Plan Development" BACKGROUND_COLOR="#E6FFE6">
        <icon BUILTIN="button_ok"/>
        <node TEXT="User works with default Claude agent to develop rough plan"/>
        <node TEXT="Conversation captures whats and whys"/>
      </node>

      <node TEXT="Conversation Summary" BACKGROUND_COLOR="#FFF9E6">
        <icon BUILTIN="info"/>
        <node TEXT="Document: conversation_summary_[taskname].md"/>
        <node TEXT="Contains: goals, decisions, constraints, dependencies"/>
      </node>

      <node TEXT="Workflow Design" BACKGROUND_COLOR="#E6FFE6">
        <icon BUILTIN="button_ok"/>
        <node TEXT="User activates Workflow Architect"/>
        <node TEXT="Architect analyzes summary"/>
        <node TEXT="Architect asks clarifying questions"/>
        <node TEXT="Architect designs multi-agent workflow"/>
      </node>

      <node TEXT="Agent Coordination" BACKGROUND_COLOR="#E6FFE6">
        <icon BUILTIN="button_ok"/>
        <node TEXT="Workflow Executor coordinates tasks"/>
        <node TEXT="Do&apos;er agents perform work"/>
        <node TEXT="Track completion drive notes"/>
      </node>

      <node TEXT="Completion Review" BACKGROUND_COLOR="#FFF9E6">
        <icon BUILTIN="messagebox_warning"/>
        <node TEXT="Do&apos;er agents review all completion drive notes"/>
        <node TEXT="Resolve open assumptions or escalate"/>
        <node TEXT="Cannot claim &quot;done&quot; until all notes addressed"/>
        <node TEXT="Status changes to ready_for_verification"/>
      </node>

      <node TEXT="Verification" BACKGROUND_COLOR="#E6FFE6">
        <icon BUILTIN="button_ok"/>
        <node TEXT="Step 1: Do&apos;er agent completes work and completion drive review"/>
        <node TEXT="Step 2: Status changes to ready_for_verification"/>
        <node TEXT="Step 3: Verifier assigned via shared_status.json"/>
        <node TEXT="Step 4: Verifier reviews both output AND completion drive notes"/>
        <node TEXT="Step 5: Status changes to verified OR back to working with feedback"/>
        <node TEXT="Purpose">
          <node TEXT="Validate outputs"/>
          <node TEXT="Review completion drive resolution"/>
          <node TEXT="Approve or send back for rework"/>
        </node>
      </node>

      <node TEXT="Session Completion" BACKGROUND_COLOR="#E6FFE6">
        <icon BUILTIN="button_ok"/>
        <node TEXT="Workflow Executor signals complete"/>
        <node TEXT="Archival agent archives session files"/>
        <node TEXT="Context cleaned for next session"/>
      </node>
    </node>

    <!-- Agent Types Branch -->
    <node TEXT="Agent Types" POSITION="right" BACKGROUND_COLOR="#E6F3FF">
      <font NAME="SansSerif" SIZE="12" BOLD="true"/>

      <node TEXT="Workflow Architect" BACKGROUND_COLOR="#E6F3FF">
        <icon BUILTIN="idea"/>
        <node TEXT="Analyzes conversation summaries"/>
        <node TEXT="Critical Analysis Requirements">
          <node TEXT="Agent requirements identification"/>
          <node TEXT="New agent creation guidance"/>
          <node TEXT="Failure mode analysis"/>
          <node TEXT="Dependency chains with ordering"/>
          <node TEXT="Context requirements per agent"/>
          <node TEXT="Success criteria definition"/>
        </node>
        <node TEXT="Interactive Clarification">
          <node TEXT="Identifies validation gaps"/>
          <node TEXT="Questions unclear handoffs"/>
          <node TEXT="Probes implicit assumptions"/>
          <node TEXT="Verifies measurable success criteria"/>
          <node TEXT="Can consult with default Claude"/>
        </node>
        <node TEXT="Workflow Design Output">
          <node TEXT="Initial shared_status.json"/>
          <node TEXT="Required agent types list"/>
          <node TEXT="New agent specifications"/>
          <node TEXT="Validation requirements at handoffs"/>
          <node TEXT="Verifier agents needed"/>
          <node TEXT="Escalation paths"/>
        </node>
      </node>

      <node TEXT="Workflow Executor" BACKGROUND_COLOR="#FFE6F0">
        <icon BUILTIN="idea"/>
        <node TEXT="Coordinates tasks during execution"/>
        <node TEXT="Manages dependencies"/>
        <node TEXT="Controls session boundaries"/>
        <node TEXT="Enforces completion drive gates"/>
        <node TEXT="Reviews escalated issues"/>
      </node>

      <node TEXT="Do&apos;er Agents" BACKGROUND_COLOR="#E6FFE6">
        <icon BUILTIN="idea"/>
        <node TEXT="Database Agent"/>
        <node TEXT="API Agent"/>
        <node TEXT="Frontend Agent"/>
        <node TEXT="Other specialized agents"/>
        <node TEXT="Perform specific work tasks"/>
        <node TEXT="Track completion drive notes"/>
      </node>

      <node TEXT="Verifier Agents" BACKGROUND_COLOR="#FFF9E6">
        <icon BUILTIN="yes"/>
        <node TEXT="Validate do&apos;er agent outputs"/>
        <node TEXT="Review completion drive resolution"/>
        <node TEXT="Approve or reject work"/>
        <node TEXT="Provide specific feedback"/>
      </node>

      <node TEXT="Archival Agent" BACKGROUND_COLOR="#F0E6FF">
        <icon BUILTIN="idea"/>
        <node TEXT="Manages session cleanup"/>
        <node TEXT="Archives completed sessions"/>
        <node TEXT="Optimizes token usage"/>
        <node TEXT="Maintains archive index"/>
      </node>
    </node>

    <!-- Key Documents Branch -->
    <node TEXT="Key Documents" POSITION="left" BACKGROUND_COLOR="#FFF9E6">
      <font NAME="SansSerif" SIZE="12" BOLD="true"/>

      <node TEXT="conversation_summary_[taskname].md" BACKGROUND_COLOR="#FFF9E6">
        <icon BUILTIN="info"/>
        <node TEXT="Document Purpose">
          <node TEXT="Captures context for Workflow Architect"/>
        </node>
        <node TEXT="Section Structure">
          <node TEXT="What We&apos;re Trying to Accomplish"/>
          <node TEXT="Key Decisions Made">
            <node TEXT="Decision: what was decided"/>
            <node TEXT="Rationale: why"/>
            <node TEXT="Alternatives considered: what we rejected"/>
          </node>
          <node TEXT="Constraints &amp; Assumptions"/>
          <node TEXT="Questions Resolved (Q&amp;A format)"/>
          <node TEXT="Open Items"/>
          <node TEXT="Dependencies &amp; Integration Points"/>
        </node>
        <node TEXT="Design Philosophy">
          <node TEXT="Context over templates"/>
          <node TEXT="Universal format for all task types"/>
          <node TEXT="Interactive refinement approach"/>
        </node>
      </node>

      <node TEXT="shared_status.json" BACKGROUND_COLOR="#FFF9E6">
        <icon BUILTIN="info"/>
        <node TEXT="Overall coordination state"/>
        <node TEXT="Agent statuses"/>
        <node TEXT="Completion drive note counts"/>
        <node TEXT="Dependencies between agents"/>
        <node TEXT="Verification assignments"/>
        <node TEXT="Overall completion drive gate"/>
      </node>

      <node TEXT="session_current.json" BACKGROUND_COLOR="#FFF9E6">
        <icon BUILTIN="info"/>
        <node TEXT="Per-agent completion drive context"/>
        <node TEXT="Current session notes only"/>
        <node TEXT="Archived when session ends"/>
      </node>

      <node TEXT="session_[timestamp]_[taskname].json" BACKGROUND_COLOR="#FFF9E6">
        <icon BUILTIN="info"/>
        <node TEXT="Archived session files"/>
        <node TEXT="Historical completion drive notes"/>
        <node TEXT="Prevents context bloat"/>
      </node>
    </node>

    <!-- Coordination Mechanisms Branch -->
    <node TEXT="Coordination Mechanisms" POSITION="left" BACKGROUND_COLOR="#CCFFCC">
      <font NAME="SansSerif" SIZE="12" BOLD="true"/>

      <node TEXT="Dependency Management" BACKGROUND_COLOR="#E6FFE6">
        <icon BUILTIN="button_ok"/>
        <node TEXT="Agents declare dependencies in shared_status.json"/>
        <node TEXT="Workflow Executor blocks agents until dependencies verified"/>
        <node TEXT="Cascading updates when upstream completes"/>
      </node>

      <node TEXT="Completion Drive Gates" BACKGROUND_COLOR="#FFF9E6">
        <icon BUILTIN="messagebox_warning"/>
        <node TEXT="No &quot;done&quot; without review"/>
        <node TEXT="All notes must be resolved or escalated"/>
        <node TEXT="Workflow Executor enforces gates"/>
        <node TEXT="Verifiers validate resolution"/>
      </node>

      <node TEXT="Session Management" BACKGROUND_COLOR="#E6FFE6">
        <icon BUILTIN="button_ok"/>
        <node TEXT="Controlled by Workflow Executor only"/>
        <node TEXT="4-Phase Lifecycle">
          <node TEXT="1. Session start: Agent creates session_current.json"/>
          <node TEXT="2. Work phase: Agent logs completion drive notes"/>
          <node TEXT="3. Completion review: Agent resolves all notes"/>
          <node TEXT="4. Session end: Archival agent archives session files"/>
        </node>
        <node TEXT="Session end triggers archival"/>
        <node TEXT="Clean context for new sessions"/>
        <node TEXT="Token optimization through archival"/>
      </node>

      <node TEXT="Validation Checkpoints" BACKGROUND_COLOR="#FFF9E6">
        <icon BUILTIN="messagebox_warning"/>
        <node TEXT="Required at every agent handoff"/>
        <node TEXT="Explicit success criteria"/>
        <node TEXT="Failure modes defined"/>
        <node TEXT="Escalation paths clear"/>
      </node>

      <node TEXT="Agent Status Values" BACKGROUND_COLOR="#E6FFE6">
        <icon BUILTIN="info"/>
        <node TEXT="pending - not started, waiting for dependencies"/>
        <node TEXT="working - actively performing assigned work"/>
        <node TEXT="completion_drive_review - reviewing assumptions before claiming done"/>
        <node TEXT="ready_for_verification - passed completion drive review"/>
        <node TEXT="verified - verifier approved work output"/>
        <node TEXT="blocked - needs orchestrator/user input"/>
        <node TEXT="session_complete - orchestrator marked task complete"/>
      </node>

      <node TEXT="Completion Drive System" BACKGROUND_COLOR="#FFF9E6">
        <icon BUILTIN="messagebox_warning"/>
        <node TEXT="Note Structure">
          <node TEXT="timestamp, type, description, context, status, resolution"/>
          <node TEXT="Stored in session_current.json"/>
        </node>
        <node TEXT="Note Types">
          <node TEXT="assumption (requires resolution)"/>
        </node>
        <node TEXT="Note Statuses">
          <node TEXT="open - needs resolution"/>
          <node TEXT="resolved - agent addressed"/>
          <node TEXT="escalated - requires orchestrator/user input"/>
        </node>
        <node TEXT="Marking Formats">
          <node TEXT="Code: // #COMPLETION_DRIVE: [description]"/>
          <node TEXT="Non-code: ⚠️ COMPLETION_DRIVE: [description]"/>
        </node>
        <node TEXT="Why Multi-Agent Systems Need This">
          <node TEXT="Prevents premature &quot;done&quot; claims"/>
          <node TEXT="Surfaces incomplete status reports"/>
          <node TEXT="Documents assumptions for handoffs"/>
        </node>
      </node>

      <node TEXT="Error Handling" BACKGROUND_COLOR="#FFCCCC">
        <icon BUILTIN="button_cancel"/>
        <node TEXT="Blocked agents escalate via completion drive"/>
        <node TEXT="Workflow Executor provides clarification"/>
        <node TEXT="Failed verification returns to working status"/>
      </node>
    </node>

    <!-- Design Principles Branch -->
    <node TEXT="Design Principles" POSITION="left" BACKGROUND_COLOR="#F0E6FF">
      <font NAME="SansSerif" SIZE="12" BOLD="true"/>

      <node TEXT="Local Development Focus" BACKGROUND_COLOR="#F0E6FF">
        <node TEXT="File system based coordination"/>
        <node TEXT="Single machine, multiple agents"/>
        <node TEXT="Human-readable JSON files"/>
        <node TEXT="Debug friendly"/>
      </node>

      <node TEXT="Token Efficiency" BACKGROUND_COLOR="#F0E6FF">
        <node TEXT="Session-based archival"/>
        <node TEXT="Only current session in context"/>
        <node TEXT="Prevents context bloat"/>
      </node>

      <node TEXT="Separation of Concerns" BACKGROUND_COLOR="#F0E6FF">
        <node TEXT="Completion drive: problem identification"/>
        <node TEXT="Orchestration: workflow management"/>
        <node TEXT="Agents: focused on primary tasks"/>
      </node>

      <node TEXT="Adaptive Agent Creation" BACKGROUND_COLOR="#F0E6FF">
        <node TEXT="Workflow Architect identifies needed agents"/>
        <node TEXT="Guides creation of missing agents"/>
        <node TEXT="Specifications for new agents"/>
      </node>

      <node TEXT="Validation-First" BACKGROUND_COLOR="#F0E6FF">
        <node TEXT="Explicit validation at every transition"/>
        <node TEXT="No assumptions about completion"/>
        <node TEXT="Evidence-based verification"/>
      </node>
    </node>

  </node>
</map>
