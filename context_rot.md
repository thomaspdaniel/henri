# Context Rot
The key insight is making context refresh intentional and systematic rather than hoping important information naturally stays visible.  (There is no evidence to back up that this works.)

## New terms
**token sequence**-- every word I've said to the model
**attention calculations** -- which of of the things in the token sequence are getting the most attention (weight).  Claude can not view its own attention weights.


## Context Refresh Patterns
These suggestions come from Claude with no evidence to back up their usefulness

### Periodic summarization of key constraints and objectives
- Set explicit milestones (every 5-10 exchanges, or at natural breakpoints) where I restate the core requirements and constraints
- Use a "constraint checklist" format that I refer back to before major decisions
- When switching between different aspects of a task, start with a brief summary of relevant constraints for that aspect

### Explicit "checkpoint" moments where critical information is restated
- Before starting implementation, summarize understanding and ask for confirmation
- At phase transitions (analysis → design → implementation), explicitly restate key requirements
- When returning to a task after working on something else, begin with a context reset
- Create formal "handoff summaries" when delegating to specialized agents

### Tools that maintain persistent state that don't get buried in conversation flow
- Use TodoWrite tool religiously to maintain external memory of objectives and progress
- Maintain a running "constraints file" that gets updated but never deleted
- Use file comments or documentation to capture decisions and rationale as we work
- Create explicit "session notes" files that persist key information across tool usage


## Structured Information Management

### Separating different types of context (requirements, constraints, current state, next actions)
- Create distinct "buckets" for different information types rather than mixing them in conversation flow
- Example: maintain separate sections for "what we're building" vs "how we must build it" vs "where we are now"
- This could prevent constraints from getting lost among status updates or requirements getting confused with implementation details

### Using external memory systems (files, databases) rather than relying solely on conversation context
- Store persistent information outside the token sequence entirely
- Examples: constraint files, decision logs, requirement databases, configuration files
- Information doesn't compete for attention weights because it's retrieved when needed rather than carried in context

### Explicit handoff protocols when transitioning between different phases of work
- Formal procedures for passing information between work phases or agents
- Example: "analysis complete, here are the 3 key constraints for implementation phase"
- Ensures critical information survives context transitions


## Intentional Context Boundaries

### Breaking complex tasks into discrete sessions with clear entry/exit criteria
- Define specific start/end conditions for each work session rather than letting tasks flow together
- Example: "Session 1: analyze requirements and identify constraints" with exit criteria of "documented constraint list approved"
- Each new session starts fresh with only the essential handoff information from previous sessions
- Prevents context accumulation from sprawling across multiple problem domains

### Using "fresh start" approaches when context becomes too heavy
- Recognize when conversation context has become unwieldy and deliberately reset
- Extract only essential information to carry forward into a new context
- Use /clear or new conversations when token sequence becomes too long or unfocused
- Transfer critical state through external files rather than trying to maintain it all in conversation

### Explicit context validation before major decisions or implementations
- Create formal checkpoints where current understanding is validated against original requirements
- Before significant work phases, explicitly confirm what information is driving decisions
- Use structured reviews: "Based on these 3 constraints and these 2 requirements, I'm about to..."
- Catch context drift before it leads to incorrect implementations



