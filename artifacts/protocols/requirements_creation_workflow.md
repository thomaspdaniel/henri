# Requirements Creation Workflow Protocol

## Overview
This protocol provides a standardized workflow for creating new requirements in the requirements database. Use this workflow when users request creation of new requirements or when requirements need to be added based on conversation context.

## Prerequisites
- PostgreSQL permissions configured for requirements database access
- Connection information available in project CLAUDE.md file
- Understanding of requirements table structure and constraints

## Workflow Steps

### 1. Database Connection
Connect to the requirements database using information from CLAUDE.md:
```bash
psql -d requirements -c "SELECT 1;" # Test connection
```

### 2. Context Analysis and Information Gathering

#### A. Analyze Context for Parent Requirement
- **If 95% clear from context** that this is a child requirement and which requirement is the parent:
  - Proceed with identified parent_id
  - Inform user: "Creating child requirement for requirement [ID]"
- **If unclear or ambiguous**:
  - Ask user: "Is this a child requirement? If so, what is the parent requirement ID?"

#### B. Collect Required Information

**Description (Required):**
- Prompt: "Please provide the requirement description:"
- Validation: Ensure starts with "The software must..." for consistency
- If not following pattern, suggest: "Should this be phrased as 'The software must...'?"

**Project Assignment:**
```bash
# Read current project from rover config
PROJECT=$(grep "^project" @rover/config | cut -d'=' -f2 | tr -d ' ')
```
- Suggest: "Project: $PROJECT (from rover config) - press Enter to use this or specify different project:"
- Allow override with any valid project name

**Rough Priority (Optional):**
- Ask: "Rough priority? (1=Low, 2=Medium, 3=High, or leave blank):"
- Validate: Must be 1, 2, 3, or empty
- **Do not ask for priority field** - only use rough_priority

### 3. Category Suggestion
Analyze the requirement description and suggest categories based on keywords:

**Keyword-to-Category Mapping:**
- Combat/attack/damage/weapon → "Combat Mechanics"
- Character/descriptor/type/focus → "Character Creation"
- Cypher/artifact/depletion → "Cypher System"
- Campaign/GM/gamemaster → "Campaign Management"
- Ability/skill/effort → "Ability System"
- Experience/XP/advancement → "Character Advancement"
- Rules/optional/variant → "Optional Rules"

**Present suggestions:**
"Suggested categories based on content: [category1, category2]"
"Add these categories? (y/n) or specify different categories:"

### 4. Database Insertion

#### A. Insert Requirements Record
```sql
INSERT INTO requirements (description, project, rough_priority, parent_id)
VALUES (%s, %s, %s, %s)
RETURNING id;
```

**Parameters:**
- description: User-provided requirement text
- project: From config or user override
- rough_priority: 1, 2, 3, or NULL
- parent_id: From context analysis or NULL

#### B. Insert Categories (if selected)
```sql
INSERT INTO requirement_categories (requirement_id, category)
VALUES (%s, %s);
```

### 5. Error Handling

**Common Constraints:**
- rough_priority must be 1, 2, or 3
- parent_id must reference existing requirement
- description cannot be empty

**Error Recovery:**
```sql
-- If error occurs, rollback
ROLLBACK;
```
- Inform user of validation error
- Request corrected information
- Retry insertion

### 6. Post-Creation Integration

**Success Message:**
"✓ Created requirement ID [new_id] in project '[project]'"

**Rover Integration Offer:**
"Would you like me to run `@rover/rover.py --download` to retrieve the new requirement as a markdown file? (y/n)"

If yes:
```bash
cd @rover && python3 rover.py --download
```

### 7. Validation and Verification

**Verify creation:**
```sql
SELECT id, description, project, rough_priority, parent_id
FROM requirements
WHERE id = [new_id];
```

**Check categories:**
```sql
SELECT category
FROM requirement_categories
WHERE requirement_id = [new_id];
```

## Example Usage

```
User: "Create a requirement for spell resistance mechanics"

Claude: "Creating new requirement...
Description: The software must support spell resistance mechanics where creatures can resist magical effects based on their resistance rating.
Project: badPenny (from rover config) - press Enter to use this or specify different project:
[User presses Enter]
Rough priority? (1=Low, 2=Medium, 3=High, or leave blank): 2
Suggested categories based on content: Combat Mechanics, Optional Rules
Add these categories? (y/n): y
✓ Created requirement ID 508 in project 'badPenny'
Would you like me to run `@rover/rover.py --download` to retrieve the new requirement? y
[Downloads requirement as 508.md]"
```

## Integration Notes

- This workflow integrates with existing rover tooling
- Created requirements immediately become available for rover operations
- Categories can be modified later using rover upload workflow
- Maintains consistency with existing requirement patterns

## Quality Standards

- All requirements should start with "The software must..."
- Descriptions should be specific and actionable
- Categories should reflect actual content, not aspirational assignments
- Parent-child relationships should be logical and well-defined

## Security Considerations

- Use parameterized queries to prevent SQL injection
- Validate all user inputs before database insertion
- Use transactions to ensure data consistency
- Rollback on any constraint violations

## Change Log
- **2025-10-17** - Added Change Log section to comply with protocol authoring standards (Claude - Protocol Compliance Agent)
- **2025-10-17** - Initial creation with comprehensive requirements creation workflow including rover integration, database validation, and category suggestion features (Tom - Project Owner)