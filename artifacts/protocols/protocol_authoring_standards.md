# Protocol Authoring Standards Protocol

## Purpose
This protocol establishes comprehensive standards for creating, modifying, and validating all Claude protocol documents. It ensures consistent structure, formatting, and quality across the protocol ecosystem, making protocols easier to understand, maintain, and apply.

## When This Protocol Applies
Trigger this protocol when the user mentions:
- "create protocol"
- "new protocol"
- "protocol standards"
- "save protocol"
- "protocol authoring"
- "generate protocol"
- When creating or modifying any protocol document

## Standard Terminology

To maintain consistency across all protocols, use these standard terms:

| Preferred Term | Instead of |
|----------------|-----------|
| Core Principles | fundamental rules, basic rules |
| Quality Standards | quality criteria, standards criteria |
| Examples | Examples Section |
| Example Usage | Usage Examples, Sample Usage |
| Change Log | Version History, Revision History |
| Integration Requirements | Integration Notes (when discussing requirements) |

## Protocol Types and Structures

### Choosing the Right Protocol Type

| If your protocol... | Use Type | Example Protocols |
|---------------------|----------|-------------------|
| Defines quality requirements and compliance criteria | A - Standards | database_documentation_standards.md, verification_completion_standards.md |
| Describes step-by-step process with user interaction | B - Workflow | requirements_creation_workflow.md, risk_aware_change_management.md |
| Provides technical specs and reference material | C - Specification | freeplane_creation.md, workflow_documentation_standards.md |
| Manages terminology and definitions | C - Specification | glossary_standards.md |

### Type A: Standards Protocols
**Purpose**: Define mandatory requirements, quality criteria, and enforcement rules for specific practices.

**Examples**: database_documentation_standards.md, verification_completion_standards.md, testing_quality_standards.md

**Required Structure**:
1. **Title**: `# [Protocol Name] Protocol`
2. **Purpose**: 1-3 sentences explaining why this protocol exists
3. **Core Principles**: Fundamental rules that govern the standard
4. **Required Elements**: What must be included/done
5. **Prohibited Elements**: What must be avoided (optional but recommended)
6. **Quality Standards**: Criteria for compliance
7. **Examples**: Good and bad examples showing correct application
8. **Enforcement Rules**: How compliance is verified and maintained
9. **Change Log**: Version history with dates, changes, and attribution

**Optional Sections**:
- **When This Protocol Applies**: Trigger conditions (recommended for clarity)
- **Integration Requirements**: How this protocol connects to others

**Template**:
```markdown
# [Protocol Name] Protocol

## Purpose
[1-3 sentences: What problem does this protocol solve?]

## Core Principles
[2-5 fundamental rules that govern this standard]

## Required Elements
[Specific requirements that must be met]

## Prohibited Elements
[Specific practices that must be avoided]

## Quality Standards
[Criteria for measuring compliance]

## Examples

### Good Examples
[Show correct application]

### Bad Examples
[Show violations to avoid]

## Enforcement Rules
[How compliance is verified and maintained]

## Integration Requirements
[Optional: How this protocol connects to other protocols]

## Change Log
- **2025-10-16** - Initial creation (Author Name - Role)
```

### Type B: Workflow Protocols
**Purpose**: Define step-by-step processes for completing specific tasks with user oversight and validation.

**Examples**: step_through_workflow_protocol.md, requirements_creation_workflow.md, data_extraction_validation.md, risk_aware_change_management.md

**Required Structure**:
1. **Title**: `# [Protocol Name] Protocol`
2. **Overview/Purpose**: What this workflow accomplishes
3. **Prerequisites**: Required setup, permissions, or context (if applicable)
4. **Workflow Steps**: Numbered, sequential process with clear actions
5. **Error Handling**: How to handle failures and validation issues
6. **Integration Notes**: How this workflow connects to other protocols/tools
7. **Example Usage**: Real-world scenario showing complete workflow
8. **Change Log**: Version history with dates, changes, and attribution

**Optional Sections**:
- **When This Protocol Applies**: Trigger conditions (recommended for clarity)

**Template**:
```markdown
# [Protocol Name] Protocol

## Overview
[What this workflow accomplishes and when to use it]

## Prerequisites
[Required setup, permissions, or context - omit if none]

## Workflow Steps

### 1. [First Step Name]
[Detailed instructions for step 1]

### 2. [Second Step Name]
[Detailed instructions for step 2]

[Continue for all steps]

## Error Handling
[How to handle common failures and validation issues]

## Integration Notes
[How this workflow connects to other protocols/tools]

## Example Usage
[Real-world scenario showing complete workflow execution from start to finish]

## Change Log
- **2025-10-16** - Initial creation (Author Name - Role)
```

### Type C: Specification Protocols
**Purpose**: Provide comprehensive technical specifications, guidelines, and reference material for complex systems or formats.

**Examples**: freeplane_creation.md, workflow_documentation_standards.md, glossary_standards.md

**Required Structure**:
1. **Title**: `# [Protocol Name] Protocol`
2. **Purpose**: What this specification covers
3. **When This Protocol Applies**: Trigger conditions/keywords (required for Type C)
4. **Technical Specifications**: Detailed technical requirements and formats
5. **Implementation Guidelines**: How to apply the specifications
6. **Templates/Examples**: Reusable patterns and examples
7. **Validation Checklist**: Quality verification items
8. **Best Practices**: Recommended approaches
9. **Common Issues and Solutions**: Troubleshooting guide
10. **Change Log**: Version history with dates, changes, and attribution

**Optional Sections**:
- **Integration Requirements**: How this specification connects to other protocols

**Template**:
```markdown
# [Protocol Name] Protocol

## Purpose
[What this specification covers and why it exists]

## When This Protocol Applies
Trigger this protocol when the user mentions:
- "[trigger keyword 1]"
- "[trigger keyword 2]"
- [Other trigger conditions]

## Technical Specifications
[Detailed technical requirements, formats, and structures]

## Implementation Guidelines
[Step-by-step guidance for applying the specifications]

## Templates/Examples
[Reusable patterns and working examples]

## Validation Checklist

When creating/modifying [subject]:
- [ ] [Validation item 1]
- [ ] [Validation item 2]
[Continue for all validation items]

## Best Practices
[Recommended approaches and expert guidance]

## Common Issues and Solutions

### Issue: [Problem Description]
[Solution and explanation]

### Issue: [Second Problem]
[Solution and explanation]

## Change Log
- **2025-10-16** - Initial creation (Author Name - Role)
```

## Universal Formatting Standards

### Header Hierarchy
- **H1 (`#`)**: Protocol title only - format: `# [Protocol Name] Protocol`
- **H2 (`##`)**: Major sections (Purpose, Core Principles, Examples, etc.)
- **H3 (`###`)**: Subsections within major sections
- **H4 (`####`)**: Sub-subsections (use sparingly, only when needed for clarity)

**Consistency Rule**: Never skip header levels (don't jump from H2 to H4)

### Text Emphasis

**Bold with All Caps for Critical Action Words**:
- Format: `**MUST**`, `**NEVER**`, `**ALWAYS**`
- Use for: Critical requirements and prohibitions
- Example: "Claude **MUST** validate all inputs before processing"
- Example: "**NEVER** execute untested code on production data"

**Bold Only (without all caps)**:
- Format: `**text**`
- Use for: Important warnings, requirements, emphasis
- Use for: Field names in technical documentation
- Use for: Section labels like "Required:", "Optional:", "Example:"

**Italic**:
- Format: `*text*`
- Use for: Technical terms on first introduction
- Use for: File paths and variable names
- Use for: Emphasis within sentences
- Use for: "Also referred to as" terminology notes

### List Formatting

**Unordered Lists** - Use `-` (dash):
```markdown
- First item
- Second item
  - Nested item (2 spaces indent)
- Third item
```

**Ordered Lists** - Use `1. 2. 3.`:
```markdown
1. First step
2. Second step
3. Third step
```

**Checklists** - Use `- [ ]` markdown syntax:
```markdown
- [ ] Unchecked item
- [x] Checked item (when showing completed state in examples)
```

**Consistency Rule**: Use dashes (`-`) for all unordered lists (not asterisks or plus signs)

### Code Block Standards

**Always specify language after opening backticks**:

```sql
-- SQL queries
SELECT * FROM requirements WHERE id = 123;
```

```bash
# Shell commands
psql -d mydb -c "SELECT version();"
```

```python
# Python code
def calculate_total(items):
    return sum(item.price for item in items)
```

**Common language tags**:
- `sql` - SQL queries
- `bash` - Shell commands
- `python` - Python code
- `markdown` - Markdown examples
- `xml` - XML documents
- `json` - JSON data

**Code block requirements**:
- Include descriptive comments within code
- Provide working examples, not pseudocode
- Show complete, executable code when possible
- Use realistic example data

### Status Indicators

Use Unicode symbols directly in text for visual clarity:

- ✅ - Completed, correct practice, approved, passed validation
- ❌ - Prohibited, incorrect practice, failed validation, error
- ⚠️ - Warning, caution, requires attention, potential issue

**For checklists**, use markdown syntax `- [ ]` which renders as a checkbox.

**Example usage**:
```markdown
## Examples

### Good Examples
✅ **Good:** "Pool calculations verified for all 8 affected records (Records 233, 234, 235, 236, 276, 293, 294, 295)"

### Bad Examples
❌ **Bad:** "Pool calculations verified successfully." (no specific evidence provided)
```

### Special Formatting Patterns

**Enforcement Statements**:
```markdown
**Claude **MUST** [requirement]** when [condition].
**NEVER** [prohibited action] without [safety condition].
```

**Evidence Requirements**:
```markdown
**Required Evidence:**
- Primary evidence: [main deliverable]
- Supporting evidence: [methodology documentation]
- Validation evidence: [independent verification results]
```

**Quality Gates**:
```markdown
**Before [action]:**
- [ ] Requirement 1 met
- [ ] Requirement 2 met
- [ ] Requirement 3 met
```

## Required Sections (All Protocol Types)

### Mandatory Sections

#### 1. Title (H1)
**Format**: `# [Protocol Name] Protocol`

**Requirements**:
- **MUST** include "Protocol" suffix
- Use title case (capitalize major words)
- Be descriptive and specific

**Examples**:
- ✅ Good: `# Database Documentation Standards Protocol`
- ✅ Good: `# Step-Through Workflow Protocol`
- ❌ Bad: `# Database Docs` (missing "Protocol", too abbreviated)

#### 2. Purpose (H2)
**Format**: 1-3 sentences explaining why this protocol exists

**Requirements**:
- Start with "This protocol..." or similar clear opening
- State the problem being solved
- Explain the value/benefit provided
- Keep concise (1-3 sentences maximum)

**Example**:
```markdown
## Purpose
This protocol establishes comprehensive standards for documenting workflows that prevent specification gaps, false completion claims, and role confusion while maintaining efficiency and quality. It addresses critical issues of evidence validation, success criteria quantification, and agent role separation.
```

#### 3. Core Content Sections (H2)
**Varies by protocol type** - see Type A, B, C structures above

**Requirements**:
- Use H2 headers for major sections
- Organize logically (general → specific, or sequential for workflows)
- Include sufficient detail for independent execution
- Cross-reference other protocols when integration is required

#### 4. Examples or Example Usage Section (H2)

**For Standards and Specification Protocols (Type A & C)**:

**Use**: `## Examples`

**Required Structure**:
```markdown
## Examples

### Good Examples
[Show correct application with explanatory text]

### Bad Examples
[Show what to avoid with explanatory text]
```

**For Workflow Protocols (Type B)**:

**Use**: `## Example Usage`

**Required Structure**:
```markdown
## Example Usage

[Complete real-world scenario showing workflow execution from start to finish]
```

**Universal Requirements**:
- Use real, working examples (not placeholder text)
- Explain WHY each example demonstrates the principle
- Use ✅ and ❌ indicators for clarity in Good/Bad examples
- Show complete examples (not fragments)

#### 5. Change Log (H2)
**Required for all protocols** - place at end of document after all core content

**Format**:
```markdown
## Change Log
- **2025-10-16** - Added validation checklist section (Tom - Project Owner)
- **2025-10-15** - Initial creation (Claude - Protocol Architect)
```

**Requirements**:
- Use `## Change Log` as H2 header
- Format each entry: `- **[YYYY-MM-DD]** - [what changed] ([author name] - [role])`
- **MUST** use reverse chronological order (newest first)
- Include date in YYYY-MM-DD format
- Describe WHAT changed, not just "updated" or "modified"
- Include author name and role
- For significant changes, include rationale

**Change Log Placement**:
- Place immediately after all core content sections
- Before any appendices or reference materials
- Should be the last substantive section in the protocol

### Optional But Recommended Sections

#### When This Protocol Applies (H2)
**Required for**: Type C (Specification) protocols
**Optional for**: Type A (Standards) and Type B (Workflow) protocols

**When to include for Type A/B**:
- Protocol has specific trigger keywords
- Clear conditions exist for when to apply the protocol
- Want to improve discoverability

**Format**:
```markdown
## When This Protocol Applies
Trigger this protocol when the user mentions:
- "[keyword1]"
- "[keyword2]"
- "[keyword3]"
- When [specific condition occurs]
```

#### Integration Requirements (H2)
**When to include**: Protocol references or depends on other protocols

**Format**:
```markdown
## Integration Requirements

### Alignment with [Other Protocol Name]
This protocol integrates with [protocol] by:
- [Specific integration point 1]
- [Specific integration point 2]

### [Second Protocol Name] Connection
[How the protocols work together]
```

**Requirements**:
- Explain HOW integration works, not just that it exists
- Link to specific protocol sections when possible
- Document handoff points between protocols
- Note any dependencies or prerequisites

#### Validation Checklist (H2)
**When to include**: Standards and Specification protocols benefit most

**Format**:
```markdown
## Validation Checklist

When [performing action covered by protocol]:
- [ ] [Validation item 1]
- [ ] [Validation item 2]
- [ ] [Validation item 3]
```

#### Common Issues and Solutions (H2)
**When to include**: Specification and Workflow protocols with known troubleshooting needs

**Format**:
```markdown
## Common Issues and Solutions

### Issue: [Problem Description]
[Symptoms and explanation]

**Solution**: [Step-by-step resolution]

### Issue: [Second Problem]
[Solution details]
```

## CLAUDE.md Integration Standards

### Trigger Section Format

**Standard template**:
```markdown
## [Protocol Name]
When the user mentions "[keyword1]", "[keyword2]", "[keyword3]", or [condition], read the detailed [standards/workflow/specifications] from ~/.claude/protocols/[filename].md. This protocol ensures [purpose statement].
```

**Requirements**:
- Use H2 header matching protocol name
- List 3-7 trigger keywords in quotes
- Include conditional triggers if applicable
- Specify protocol type (standards/workflow/specifications)
- Include exact file path
- End with purpose statement matching protocol's purpose section

**Example**:
```markdown
## Protocol Authoring Standards
When the user mentions "create protocol", "new protocol", "protocol standards", "save protocol", "protocol authoring", "generate protocol", or when creating/modifying protocol documents, read the detailed standards from ~/.claude/protocols/protocol_authoring_standards.md. This protocol ensures consistent structure, formatting, and quality across all Claude protocol documents.
```

### Available Protocols List Entry

**Format**:
```markdown
- **[Protocol Name]** - [Brief description] (triggered by: "[keyword1]", "[keyword2]", "[keyword3]")
```

**Requirements**:
- Add to "Available Protocols" section in CLAUDE.md
- Use bold for protocol name
- Include 1-sentence description
- List 2-3 primary trigger keywords
- Maintain alphabetical order within list

## Protocol Executive Summary Creation

### Purpose and Context

Executive summaries solve a critical knowledge management problem across two dimensions:

1. **Human recall**: Tom (and other protocol authors) can't easily recall which protocols exist, what they do, or when to use them after creating many protocols over time
2. **AI fresh session context**: Claude in fresh sessions needs a quick way to understand the full protocol ecosystem without reading all protocol documents

**End Goal**: All executive summaries will be compiled into `~/.claude/protocols/README.md` as a catalog file for quick reference by both humans and Claude.

**When summaries are created**:
- **For existing protocols**: Retrospectively, through collaborative refamiliarization workflow
- **For new protocols**: Immediately after protocol completion, while context is still fresh

### Executive Summary Format Specification

#### Core Fields (All Protocol Types)

Every protocol executive summary **MUST** include these fields:

```markdown
**[Protocol Name]**

**Problem Solved:** [1-2 sentence description of why this protocol exists]

**Documents Involved:** [List of file types/documents, or "None - conceptual standards"]

**Subagents Involved:** [List of agent roles/types, or "None - single agent execution"]

**Type:** [Standards / Workflow / Specification]
```

#### Additional Field for Type B (Workflow Protocols)

Workflow protocols **MUST** also include a workflow overview showing the high-level execution flow:

```markdown
**Workflow Overview:**
1. [High-level phase 1] → 2. [Phase 2] → 3. [Phase 3] → etc.

OR (for agent-heavy workflows):

**Workflow Overview:**
[Agent A] → [User review] → [Agent B] → [User approval] → [Agent C] → [Completion]
```

#### Example Summaries

**Document Update Review Protocol**

**Problem Solved:** Prevents errors, inconsistencies, and missed changes when updating documentation by using independent review agents at each critical stage.

**Documents Involved:**
- Original document being updated
- Proposed changes document (temporary)
- Backup file (temporary)

**Subagents Involved:**
- Pre-Implementation Review Agent
- Implementation Agent
- Post-Implementation Validation Agent

**Type:** Workflow

**Workflow Overview:**
Draft Changes → Backup → Pre-Review (agent) → Fix Issues → Implement (agent) → Validate (agent) → Fix Issues → Cleanup

---

**Database Documentation Standards Protocol**

**Problem Solved:** Prevents undocumented database schemas that require reverse-engineering to understand, maintain, and modify.

**Documents Involved:** SQL files (CREATE TABLE, ALTER TABLE statements)

**Subagents Involved:** None - single agent execution

**Type:** Standards

### Creation Workflow for Existing Protocols

Use this workflow when creating summaries retrospectively for protocols that already exist but need documentation.

**Context**: Tom may not be familiar with protocol details anymore, requiring collaborative refamiliarization.

**Best Practice**: Process one protocol at a time using a fresh Claude session for each.

#### Step 1: Refamiliarization

**Claude's actions**:
- Read the protocol document completely
- Present key protocol information to Tom:
  - Protocol purpose and problem solved
  - Protocol type (Standards/Workflow/Specification)
  - Major sections and workflow steps (if applicable)
  - Documents and subagents involved
  - Integration points with other protocols

**Tom's actions**:
- Review Claude's presentation
- Ask clarifying questions until comfortable with protocol understanding
- Request additional details about specific sections as needed

**Success criteria**: Tom feels comfortable discussing what should go in the executive summary

#### Step 2: Discussion

**Purpose**: Determine what information belongs in the executive summary through conversation

**Claude's actions**:
- Ask Tom what aspects of the protocol are most important to capture
- Discuss how to phrase the "Problem Solved" statement
- Identify all documents and subagents involved
- For workflows: Discuss the right level of abstraction for workflow overview

**Tom's actions**:
- Share perspective on what would be useful for quick reference
- Clarify which details matter vs. which can be omitted
- Confirm understanding of protocol's core value

**Success criteria**: Both Tom and Claude agree on what the summary should contain

#### Step 3: Collaborative Drafting

**Claude's actions**:
- Draft the executive summary based on the discussion
- Follow the format specification exactly
- Use appropriate level of detail (concise but complete)
- Present draft to Tom for review

**Tom's actions**:
- Review draft for accuracy
- Request revisions if needed
- Approve when summary accurately represents the protocol

**Critical rule**: **NEVER** create a draft without Tom's input from the discussion phase

#### Step 4: Review and Iteration

**Claude's actions**:
- Make requested revisions
- Ensure all format requirements met
- Verify terminology consistency with protocol document

**Tom's actions**:
- Provide specific feedback on what needs adjustment
- Final approval of completed summary

**Success criteria**: Summary is accurate, follows format specification, and Tom approves

### Creation Workflow for New Protocols

Use this workflow when creating summaries for newly completed protocol documents.

**Context**: Author has full context fresh in mind, making summary creation straightforward.

**Timing**: Create immediately after protocol document is finished and approved.

#### Step 1: Protocol Completion Verification

**Before creating summary, verify**:
- [ ] Protocol document is complete with all required sections
- [ ] Protocol follows appropriate type structure (Standards/Workflow/Specification)
- [ ] Protocol has been reviewed and approved
- [ ] Change log includes initial creation entry

**Success criteria**: Protocol is finalized and ready for summary

#### Step 2: Summary Creation

**Author actions** (Tom or Claude):
- Use the Executive Summary Format Specification
- Extract "Problem Solved" from the protocol's Purpose section
- List all documents involved in the protocol's scope
- List all subagents mentioned in the protocol
- Identify the protocol type
- For workflows: Create high-level workflow overview from workflow steps

**Claude-specific guidance**:
- Synthesize information directly from the protocol document
- Match terminology exactly to protocol content
- Use the example summaries as formatting reference
- Keep "Problem Solved" to 1-2 sentences maximum

**Success criteria**: Summary accurately reflects the protocol content

#### Step 3: Quick Validation

**Verify**:
- [ ] All required fields present for protocol type
- [ ] "Problem Solved" clearly states why protocol exists
- [ ] Documents and subagents lists are complete and accurate
- [ ] Workflow overview (if applicable) captures key phases
- [ ] Terminology matches protocol document
- [ ] Format follows specification exactly

**Success criteria**: Summary meets all format requirements and accurately represents the protocol

## Protocol Quality Checklist

When creating or modifying any protocol document, verify:

### Structure Quality
- [ ] Title follows format: `# [Protocol Name] Protocol`
- [ ] Purpose section present (1-3 sentences, clearly states problem solved)
- [ ] Appropriate structure for protocol type (Standards/Workflow/Specification)
- [ ] All required sections for protocol type included
- [ ] Examples or Example Usage section included with appropriate format
- [ ] Change log present with proper format (newest first)

### Formatting Quality
- [ ] Headers use consistent hierarchy (H1 → H2 → H3, no skipped levels)
- [ ] Critical action words use **MUST**/**NEVER**/**ALWAYS** (bold + all caps)
- [ ] Other emphasis uses bold or italic appropriately
- [ ] Code blocks specify language and include comments
- [ ] Status indicators (✅❌⚠️) used appropriately
- [ ] Checklists use `- [ ]` markdown syntax
- [ ] Lists use consistent markdown format (dashes for unordered)
- [ ] No markdown formatting errors (mismatched emphasis, broken links)

### Content Quality
- [ ] Purpose clearly states problem being solved
- [ ] Core principles/rules are specific and actionable (not vague)
- [ ] Examples show both correct and incorrect applications where appropriate
- [ ] Technical specifications are complete and accurate
- [ ] Integration with other protocols documented (if applicable)
- [ ] Enforcement/validation criteria clearly defined
- [ ] No ambiguous requirements (all **MUST** statements are measurable)

### CLAUDE.md Integration
- [ ] Trigger section added to CLAUDE.md (if protocol has specific triggers)
- [ ] Trigger keywords comprehensive and natural language
- [ ] Listed in "Available Protocols" section
- [ ] Purpose statement matches protocol purpose section
- [ ] File path correct: `~/.claude/protocols/[filename].md`

### Cross-Reference Validation
- [ ] All referenced protocols exist and are correctly named
- [ ] All file paths in examples are valid
- [ ] All trigger keywords match CLAUDE.md entries
- [ ] All protocol names use consistent terminology

### Language Quality
- [ ] Clear, professional technical writing
- [ ] No jargon without definition
- [ ] Consistent terminology throughout (using Standard Terminology table)
- [ ] Active voice used for instructions
- [ ] Complete sentences in prose sections

## Best Practices

### Writing Clear Requirements

**Use measurable, specific language**:
- ✅ Good: "Every CREATE TABLE **MUST** include inline comments for all fields"
- ❌ Bad: "Tables should be documented"

**Define success criteria explicitly**:
- ✅ Good: "100% of test cases **MUST** pass before deployment"
- ❌ Bad: "Tests should generally pass"

**Provide concrete examples**:
- Always show working code/examples, not pseudocode
- Include both simple and complex use cases
- Explain why examples are correct or incorrect

### Maintaining Protocol Evolution

**When to update existing protocols**:
- Edge cases discovered during application
- Integration needs with new protocols
- Clarification needed based on user confusion
- Standard refinements based on practical use

**Update requirements**:
- Add change log entry with date, description, author, role
- Update purpose statement if scope changes
- Add new examples showing updated guidance
- Cross-reference related protocol updates

### Protocol Naming Conventions

**File naming**:
- Use lowercase with underscores: `protocol_name.md`
- Be descriptive but concise
- Match the protocol title (converted to lowercase with underscores)
- Examples: `database_documentation_standards.md`, `step_through_workflow_protocol.md`

**Title naming**:
- Use title case
- Always end with "Protocol"
- Be specific enough to differentiate from other protocols
- Avoid generic names like "General Standards Protocol"

### Scope Management

**Keep protocols focused**:
- Each protocol should solve ONE specific problem
- Split large protocols into multiple focused protocols
- Use integration sections to connect related protocols
- Avoid protocol creep (adding unrelated requirements over time)

**When to create a new protocol vs. updating existing**:
- **New protocol**: Addresses different problem domain or workflow
- **Update existing**: Refines, clarifies, or extends current scope
- **Split protocol**: Original protocol has grown too large or covers multiple distinct concerns

## Common Issues and Solutions

### Issue: Protocol Structure Unclear
**Symptoms**: Confusion about what sections to include, inconsistent organization

**Solution**:
1. Identify protocol type (Standards, Workflow, or Specification) using the decision matrix
2. Use the appropriate template from this document
3. Follow required structure for that type
4. Include all mandatory sections

### Issue: Examples Too Abstract
**Symptoms**: Users cannot apply protocol guidance, examples use placeholder text

**Solution**:
1. Replace pseudocode with working code
2. Use real project scenarios from existing work
3. Show complete examples (not fragments)
4. Explain why each example demonstrates the principle

### Issue: Trigger Keywords Not Working
**Symptoms**: Protocol not activated when expected

**Solution**:
1. Review actual user language patterns
2. Add natural variations of keywords
3. Include action-oriented triggers ("create X", "modify Y")
4. Test triggers by mentioning them in conversation
5. Add "When This Protocol Applies" section if not present

### Issue: Protocol Integration Gaps
**Symptoms**: Users unsure how protocols relate, duplicated guidance across protocols

**Solution**:
1. Add Integration Requirements section
2. Explicitly reference related protocols by name
3. Document handoff points between protocols
4. Clarify which protocol takes precedence when overlap exists

### Issue: Enforcement Not Happening
**Symptoms**: Protocol standards not being followed consistently

**Solution**:
1. Use stronger language (**MUST** instead of "should")
2. Add enforcement rules section with verification steps
3. Include quality checklist
4. Provide clear examples of violations
5. Reference protocol in other protocols' integration sections

### Issue: Change Log Format Inconsistent
**Symptoms**: Different date formats, ordering, or missing attribution

**Solution**:
1. Use YYYY-MM-DD date format exclusively
2. Place newest entries first (reverse chronological)
3. Always include author name and role
4. Describe what changed, not just "updated"

## Change Log
- **2025-10-20** - Added Protocol Executive Summary Creation section with format specification and workflows for both existing and new protocols (Claude - Protocol Documentation Assistant)
- **2025-10-16** - Initial creation based on analysis of 10 existing protocols, incorporating review feedback to resolve inconsistencies (Claude - Protocol Architect)
