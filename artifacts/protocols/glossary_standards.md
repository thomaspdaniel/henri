# Glossary Standards Protocol

## Purpose
This protocol establishes comprehensive standards for creating and managing glossary sections in documentation, ensuring consistent terminology management and clear definitions across all documents.

## When This Protocol Applies
Trigger this protocol when the user mentions:
- "glossary"
- "terminology"
- "definitions"
- "term definitions"
- When creating substantial documents that introduce specialized terminology
- When inconsistent term usage is detected across documents

## Technical Specifications

### Glossary Entry Format
When creating glossary entries, use this format:

**Term Name**: Clear, concise definition that explains the concept in context.
- *Also referred to as:* Alternative names or abbreviations used in the document
- *Related terms:* Other glossary terms that are conceptually connected

### Glossary Placement Standards
- **Location**: Glossary section should be placed near the end of the document, before appendices or change logs
- **Ordering**: Terms **MUST** be listed in alphabetical order for easy reference
- **Completeness**: Include all specialized terms, abbreviations, and project-specific terminology used in the document

### Terminology Consistency Requirements
- **Canonical terms**: Each concept **MUST** have one primary term used consistently throughout the document
- **Cross-references**: When alternative terms exist, use "Also referred to as" to link them to the canonical term
- **Related term links**: Connect conceptually related glossary entries to help readers understand relationships

## Implementation Guidelines

### Step 1: Identify Need for Glossary
When creating or reviewing documents, assess whether a glossary would be beneficial:
- Document introduces 3+ specialized terms
- Document uses abbreviations or acronyms
- Document is intended for mixed audiences (technical and non-technical)
- Project-specific terminology is used

### Step 2: Propose Glossary to User
**ALWAYS** prompt the user proactively when creating substantial documents:
- Ask: "Would you like me to add a Glossary section to help track terminology and ensure consistent term usage?"
- Explain the benefits: terminology consistency, context preservation, improved documentation quality
- **NEVER** create a glossary without user approval

### Step 3: Identify Terms to Include
Scan the document for:
- Technical terms specific to the domain
- Abbreviations and acronyms
- Terms used with specialized meaning in context
- Project-specific terminology
- Terms that readers might misunderstand without definition

### Step 4: Create Glossary Entries
For each term:
1. Write clear, concise definition explaining the concept in context
2. Identify alternative names or abbreviations (if any)
3. Identify related glossary terms for cross-referencing
4. Use the standard entry format from Technical Specifications

### Step 5: Place and Format Glossary
- Add "## Glossary" H2 section near end of document
- Order terms alphabetically
- Apply consistent formatting to all entries
- Review for completeness and clarity

## Templates/Examples

### Glossary Section Template
```markdown
## Glossary

**[Term Name]**: Clear, concise definition that explains the concept in context.
- *Also referred to as:* Alternative names or abbreviations
- *Related terms:* Other glossary terms that are conceptually connected

**[Second Term]**: Definition of second term.
- *Also referred to as:* Alternative names (if applicable)
- *Related terms:* Related terms (if applicable)
```

### Example: Simple Glossary Entry
**API Endpoint**: A specific URL path that accepts HTTP requests and returns data or performs actions in the application.
- *Also referred to as:* endpoint, route
- *Related terms:* REST API, HTTP methods

### Example: Complex Glossary Entry with Multiple Cross-References
**Development Work Journaling System**: A command-line tool that captures and merges chronological development activities from git repositories and Claude Code sessions into unified work journals for analysis and automation planning.
- *Also referred to as:* "the system"
- *Related terms:* journal-work.sh, Timeline merging, Dual format output

### Example: Minimal Entry (No Alternatives or Relations)
**Pull Request**: A request to merge code changes from one branch into another, typically reviewed before integration.

## Best Practices

### Terminology Consistency
- Use the canonical term consistently throughout the document
- Avoid switching between alternative terms for the same concept
- When introducing a new term, add it to the glossary immediately
- Review document after completion to ensure term usage aligns with glossary definitions

### Context Preservation
- Write definitions that explain the term's meaning **in the specific context** of the document
- Avoid generic dictionary definitions; focus on how the term is used in your project
- Include enough detail for readers unfamiliar with the domain
- Explain acronyms and abbreviations even if they seem common

### Documentation Quality
- Keep definitions concise but complete (1-3 sentences ideal)
- Use clear, accessible language in definitions
- Define terms using concepts the reader likely already understands
- Test definitions with someone unfamiliar with the domain when possible

### Knowledge Transfer
- Think of the glossary as onboarding documentation for new team members
- Include terms that experienced team members use casually but newcomers might not know
- Cross-reference related terms to help readers build mental models
- Update glossary as terminology evolves or new terms are introduced

## Validation Checklist

When creating or reviewing glossary sections:
- [ ] All specialized terms used in document are included in glossary
- [ ] Terms are listed in alphabetical order
- [ ] Each entry uses the standard format (Term: Definition, Also referred to as, Related terms)
- [ ] Definitions are clear, concise (1-3 sentences), and contextually appropriate
- [ ] Alternative names and abbreviations are documented in "Also referred to as"
- [ ] Related terms are cross-referenced where applicable
- [ ] Glossary placed near end of document (before appendices/change logs)
- [ ] No circular definitions (Term A defined using Term B which is defined using Term A)
- [ ] Definitions use language accessible to the target audience
- [ ] User approved glossary creation before implementation

## Common Issues and Solutions

### Issue: Inconsistent Terminology Usage
**Symptoms**: Same concept referred to by different terms throughout document, reader confusion

**Solution**:
1. Identify all variations of the term used in the document
2. Select one canonical term (usually the most precise or widely recognized)
3. Add canonical term to glossary with "Also referred to as" listing all variations
4. Update document to use canonical term consistently
5. Use search/replace carefully to avoid changing unrelated text

### Issue: Missing Related Terms
**Symptoms**: Glossary entries exist in isolation without cross-references, readers don't discover related concepts

**Solution**:
1. Review each glossary entry and identify conceptually connected terms
2. Add "Related terms" field linking to other glossary entries
3. Ensure relationships are bidirectional (if Term A relates to Term B, Term B should relate to Term A)
4. Group related terms near each other alphabetically when possible (consider term naming)

### Issue: Incomplete Definitions
**Symptoms**: Definitions are too vague, rely on undefined terms, or lack context

**Solution**:
1. Read definition from perspective of someone unfamiliar with the domain
2. Ensure definition explains **what** the term is and **why** it matters in context
3. Replace jargon in definitions with simpler terms or add those terms to glossary
4. Include 1-2 sentences of context about how the term is used in the project
5. Test definitions with a colleague or through the user

### Issue: Glossary Created Without User Approval
**Symptoms**: Glossary appears in document without user requesting it

**Solution**:
- **NEVER** create glossaries proactively without asking user first
- Always prompt user: "Would you like me to add a Glossary section?"
- Explain benefits to help user make informed decision
- Only create glossary after explicit user approval
- Remember: Being user-driven is a core principle of this protocol

## Change Log
- **2025-10-17** - Restructured to comply with Type C Specification protocol standards: added Purpose, When This Protocol Applies, expanded Technical Specifications, Implementation Guidelines, Templates/Examples, Best Practices, Validation Checklist, and Common Issues and Solutions sections (Claude - Protocol Compliance Agent)