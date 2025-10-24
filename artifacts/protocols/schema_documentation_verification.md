# Schema Documentation Verification Protocol

## Overview
This protocol ensures schema documentation meets quality standards through independent verification. It solves the problem of incomplete or poor-quality schema documentation by providing a systematic workflow with independent review before finalizing any structured data schema (SQL databases, JSON Schema, XML Schema, etc.). The workflow focuses exclusively on verifying documentation quality—not schema correctness or risk assessment—to prevent documentation gaps before schemas are implemented.

**When to use**: Apply this protocol when creating or modifying any structured data schema that requires inline documentation per schema_documentation_standards.md.

**Value proposition**: Independent verification catches documentation gaps, ambiguities, and quality issues early, preventing the creation of schemas that require reverse-engineering to understand.

## Prerequisites

Before starting this workflow:
- Requirements for the schema change (any format acceptable - text, document, verbal description, etc.)
- Access to schema_documentation_standards.md for quality criteria
- Schema definition language/format decided (SQL, JSON Schema, XML Schema, etc.)

## Workflow Steps

### 1. Receive and Document Requirements

**Objective**: Establish clear understanding of what schema changes are needed.

**Actions**:
- Ask clarifying questions to understand the schema requirements completely
- Document requirements in any format the user provides (freeform text, structured document, verbal description, etc.)
- **No specific format required** - workflow accepts requirements in whatever form is most natural for the context
- Confirm understanding with user before proceeding

**Output**: Clear documented requirements that both you and the user agree capture the schema needs

### 2. Create Schema with Documentation

**Objective**: Implement the schema with comprehensive inline documentation per schema_documentation_standards.md.

**Actions**:
- Implement the schema changes in the appropriate format (SQL, JSON Schema, XML Schema, etc.)
- Add inline documentation following all requirements from schema_documentation_standards.md:
  - **Every element documented**: All tables/objects/elements, fields/properties, relationships
  - **Format-specific documentation**: SQL comments, JSON `description` fields, XML `xs:documentation` elements
  - **Explanatory comments**: Explain *why* elements exist and *what* they represent, not just syntax
  - **Data format specifications**: Document expected formats for complex fields (JSON, TEXT, enumerations)
  - **Relationship documentation**: Explain foreign keys and how entities relate
  - **Section headers**: Group related fields logically with comment headers
  - **Constraint documentation**: Explain CHECK constraints, ranges, and business rules

**Critical Requirement**: **NEVER** create undocumented schema elements. Every table, field, property, and relationship **MUST** have inline documentation before proceeding to verification.

**Output**: Complete schema definition with comprehensive inline documentation

### 3. Launch Independent Verification Agent

**Objective**: Obtain independent validation that documentation meets quality standards.

**Agent Mandate**:
Create a specialized verification agent with the following explicit scope:

**VERIFICATION SCOPE - What the agent checks:**
- ✅ Documentation completeness (every element has documentation)
- ✅ Documentation quality per schema_documentation_standards.md criteria
- ✅ Documentation covers full scope of schema changes
- ✅ Comments explain purpose and meaning, not just syntax
- ✅ Data formats specified for complex fields
- ✅ Relationships and constraints documented
- ✅ Section organization is logical and clear

**NOT IN SCOPE - What the agent does NOT check:**
- ❌ Schema correctness or validity (syntax errors, type mismatches, etc.)
- ❌ Risk assessment or production impact
- ❌ Requirements alignment beyond documentation scope
- ❌ Performance implications
- ❌ Security considerations

**Agent Deliverables**:
The verification agent **MUST** provide:
1. **Verification report** identifying any documentation gaps or quality issues
2. **Specific recommendations** for each issue found (with exact locations)
3. **Approval status**: APPROVED or NEEDS_REVISION

**Agent Creation**:
Use the Task tool to launch the verification agent with a prompt like:
```
Review the schema documentation against schema_documentation_standards.md.

Your verification scope is LIMITED to documentation quality only:
- Check that every table/object/element is documented
- Check that every field/property is documented
- Verify comments explain purpose and meaning, not just syntax
- Verify data formats are specified for complex fields
- Verify relationships and constraints are documented
- Check that documentation is clear and unambiguous

DO NOT check schema correctness, risk, or requirements alignment.

Provide:
1. List of documentation gaps (if any) with specific locations
2. List of quality issues (if any) with specific recommendations
3. Approval status: APPROVED or NEEDS_REVISION
```

**Output**: Independent verification report with clear findings and approval status

### 4. Review Verification Results

**Objective**: Address any issues found and achieve documentation approval.

**Actions**:
- Present verification report to user
- **If NEEDS_REVISION**:
  - Review specific gaps and recommendations
  - Make corrections to schema documentation
  - Re-run verification (return to Step 3) with updated documentation
- **If APPROVED**:
  - Confirm with user that documentation verification is complete
  - Proceed to Step 5

**Iteration**: Continue the revision cycle (Step 3 → Step 4) until verification agent approves documentation quality.

**Output**: Approved schema documentation that meets all quality standards

### 5. Complete and Hand Off

**Objective**: Finalize documentation verification and hand off to appropriate next steps.

**Actions**:
- Confirm documentation verification is complete
- Assess whether schema change is high-risk or low-risk
- **For high-risk changes** (existing data, migrations, schema modifications with impact):
  - Inform user that the change should be reviewed under risk_aware_change_management.md
  - Explain that risk assessment and proof-of-concept testing are recommended
  - Hand off to risk_aware_change_management.md workflow
- **For low-risk changes** (new tables/schemas, no existing data impact):
  - Inform user that documentation verification is complete
  - Schema is ready for implementation

**Output**: Completed documentation verification with clear next steps based on risk level

## Error Handling

### Issue: Verification Agent Finds Incomplete Documentation
**Symptoms**: Agent reports missing documentation for tables, fields, or relationships.

**Solution**:
1. Review specific gaps identified in verification report
2. Add missing documentation per schema_documentation_standards.md requirements
3. Re-run verification (return to Step 3) with updated schema
4. Continue iteration until all elements are documented

### Issue: User Disagrees with Verification Feedback
**Symptoms**: User believes documentation is adequate but agent reports issues.

**Solution**:
1. Discuss specific concerns raised by verification agent
2. Review relevant sections of schema_documentation_standards.md together
3. Clarify what documentation standards require for this specific case
4. Reach agreement on what documentation is needed
5. Either revise documentation or adjust standards if legitimate edge case discovered

### Issue: Requirements Are Unclear or Ambiguous
**Symptoms**: Cannot create schema because requirements are incomplete or contradictory.

**Solution**:
1. Stop schema creation immediately
2. Return to Step 1 (Receive and Document Requirements)
3. Ask specific clarifying questions about ambiguous aspects
4. Document clarified requirements
5. Confirm understanding with user before proceeding to Step 2

### Issue: Verification Agent Exceeds Scope
**Symptoms**: Agent reports issues about schema correctness, risk, or requirements alignment instead of just documentation quality.

**Solution**:
1. Acknowledge the agent provided feedback outside verification scope
2. Remind agent that verification scope is **documentation quality only**
3. Re-launch verification agent with clearer scope boundaries (Step 3)
4. If schema correctness issues are legitimate, address them separately from documentation verification

## Integration Notes

### Integration with schema_documentation_standards.md
This workflow **enforces** the standards defined in schema_documentation_standards.md:
- Verification agent uses schema_documentation_standards.md as the quality criteria checklist
- All schema documentation **MUST** comply with standards protocol requirements
- Step 2 (Create Schema with Documentation) directly implements standards protocol
- Step 3 verification validates compliance with standards protocol

**Dependency**: This workflow requires schema_documentation_standards.md to exist and define clear quality criteria.

### Integration with risk_aware_change_management.md
After documentation verification completes, high-risk schema changes should trigger risk_aware_change_management.md:
- This workflow handles **documentation quality verification** only
- risk_aware_change_management.md handles **risk assessment and proof-of-concept testing**
- **Handoff point**: Step 5 (Complete and Hand Off) after documentation is verified
- **When to hand off**: Schema changes affecting existing data, migrations, or destructive operations
- **When NOT to hand off**: New schemas/tables with no existing data impact

**Separation of concerns**: Documentation verification happens first, risk assessment happens second (if needed).

### Integration with future change_management.md
This protocol will be listed as a component protocol under the change management umbrella:
- Handles the "documentation verification" control aspect of change management
- Provides quality gate before schema changes are implemented
- Ensures all schema changes are properly documented before risk assessment or implementation

## Example Usage

**Scenario**: Adding character inventory system to a game database

```
User: "I need to add an inventory system to track items that characters own."

=== Step 1: Receive and Document Requirements ===

Claude: "Let me clarify the requirements for the inventory system:
- Should characters be able to own multiple items?
- What information do we need to track about each item?
- How should items relate to characters?"

User: "Yes, multiple items per character. Track item type, quantity,
       and whether it's equipped. Items belong to a specific character."

Claude: "Understood. Requirements documented:
- Characters can own multiple items (one-to-many relationship)
- Track: item_type, quantity, equipped status
- Foreign key relationship: items → characters
Ready to proceed with schema creation."

=== Step 2: Create Schema with Documentation ===

Claude creates:

```sql
-- Stores inventory items owned by characters
CREATE TABLE character_inventory (
    inventory_id INTEGER PRIMARY KEY AUTOINCREMENT, -- Unique identifier for each inventory entry
    character_id INTEGER NOT NULL, -- Foreign key to characters.id, which character owns this item
    item_type TEXT NOT NULL, -- Type of item (e.g., 'weapon', 'armor', 'consumable', 'quest_item')
    item_name TEXT NOT NULL, -- Display name of the item
    quantity INTEGER NOT NULL DEFAULT 1, -- Number of identical items stacked together
    is_equipped BOOLEAN NOT NULL DEFAULT 0, -- Whether this item is currently equipped (1) or in backpack (0)
    acquired_date DATE DEFAULT (date('now')), -- When the character obtained this item

    FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE,
    CHECK (quantity > 0) -- Quantity must be positive; items with 0 quantity should be deleted
);
```

=== Step 3: Launch Independent Verification Agent ===

Claude: "I've created the schema with inline documentation.
         Now launching verification agent to review documentation quality..."

[Verification agent reviews and reports:]

Verification Report:
✅ Table purpose comment present and clear
✅ All 7 fields have inline documentation
✅ Foreign key relationship documented (character_id → characters.id)
✅ CHECK constraint documented with business logic rationale
✅ Data format specified for item_type (enumeration examples provided)
✅ Boolean field meaning clarified (equipped vs. backpack)
✅ All comments explain purpose, not just syntax

Approval Status: APPROVED

=== Step 4: Review Verification Results ===

Claude presents to user:
"Documentation verification PASSED. The verification agent confirmed:
- All elements are documented
- Documentation is clear and explanatory
- Relationships and constraints are explained
- Data formats are specified

Documentation quality meets schema_documentation_standards.md requirements."

=== Step 5: Complete and Hand Off ===

Claude: "Documentation verification is complete.

Risk Assessment:
- This is a new table (no existing data)
- No destructive operations
- No data migration required

Risk Level: LOW RISK

Since this is a low-risk change (new table, no existing data impact),
no additional risk assessment or proof-of-concept testing is required per
risk_aware_change_management.md. The schema is ready for implementation."

User: "Great, go ahead and create the table."

Claude executes the CREATE TABLE statement in the database.
```

## Change Log
- **2025-10-24** - Initial creation (Claude - Protocol Architect)
