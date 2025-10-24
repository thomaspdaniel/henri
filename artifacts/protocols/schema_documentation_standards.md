# Schema Documentation Standards Protocol

## Purpose
This protocol solves the problem of undocumented structured data schemas (SQL databases, JSON Schema, XML Schema, etc.) that are difficult to understand, maintain, and modify. Without inline documentation, developers must reverse-engineer schema purposes, field meanings, and relationship logic from code or tribal knowledge. This protocol establishes comprehensive inline documentation standards that create self-documenting schemas, reducing maintenance burden and facilitating knowledge transfer across teams.

## Core Principles

1. **Inline Documentation is Mandatory** - Schema documentation is not optional; every table, field, property, relationship, and constraint must be documented at the point of definition.

2. **Explain Purpose, Not Syntax** - Comments must describe *why* something exists and *what it represents*, not merely restate what the schema syntax already shows.

3. **Comprehensive Coverage Required** - Documentation must address all critical aspects: table purpose, field meanings, data formats, relationship logic, constraints, and business rules.

4. **Context Over Brevity** - Comments should provide enough context for a developer unfamiliar with the system to understand the schema's intent and usage patterns.

5. **Self-Documenting Schemas Reduce Maintenance Burden** - Upfront documentation effort pays dividends by eliminating reverse-engineering time and preventing misinterpretation of schema intent.

## Mandatory Inline Documentation Policy
**Claude MUST always include comprehensive inline documentation when creating or modifying schemas.** Never create schema definitions without proper documentation.

## Required Documentation Elements

### SQL Database Documentation

#### 1. Table Purpose Comment
Every CREATE TABLE must start with a comment block explaining the table's purpose
```sql
-- Stores user authentication and profile information for application access
CREATE TABLE users (
```

#### 2. Field Documentation
Every field must have an inline comment explaining its purpose
```sql
user_id INTEGER PRIMARY KEY AUTOINCREMENT, -- Unique identifier for each user account
username TEXT NOT NULL UNIQUE, -- Login name, must be unique across system
email TEXT NOT NULL, -- User's email address for notifications and recovery
created_date DATE DEFAULT (date('now')), -- Timestamp when account was created
```

#### 3. Data Format Specification
Document expected data formats, especially for JSON/TEXT fields
```sql
preferences TEXT, -- JSON object containing user settings and configurations
tags TEXT, -- JSON array of user-defined category tags
status TEXT CHECK(status IN ('active', 'inactive', 'suspended')), -- Account status
```

#### 4. Relationship Documentation
Explain foreign keys and relationships
```sql
campaign_id INTEGER NOT NULL, -- Foreign key to campaigns.id, which campaign this belongs to
FOREIGN KEY (campaign_id) REFERENCES campaigns(id)
```

#### 5. Section Headers
Use comment headers to group related fields
```sql
CREATE TABLE characters (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    
    -- Basic Identity
    name TEXT NOT NULL, -- Character name as chosen by player
    level INTEGER NOT NULL CHECK(level BETWEEN 1 AND 10), -- Character power level
    
    -- Statistics
    might_pool INTEGER NOT NULL, -- Physical capability pool points
    speed_pool INTEGER NOT NULL, -- Agility/reflexes pool points
    intellect_pool INTEGER NOT NULL, -- Mental capacity pool points
    
    -- Relationships
    campaign_id INTEGER NOT NULL, -- Foreign key to campaigns.id
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id)
);
```

### JSON Schema Documentation

JSON Schema should include comprehensive `description` fields and `$comment` annotations.

**Good Example**:
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "User Profile Schema",
  "description": "Defines the structure for user profile data stored in the profiles collection",
  "type": "object",
  "properties": {
    "userId": {
      "type": "string",
      "format": "uuid",
      "description": "Unique identifier for the user account, matches users.id in the authentication database"
    },
    "email": {
      "type": "string",
      "format": "email",
      "description": "User's email address for notifications and account recovery"
    },
    "preferences": {
      "type": "object",
      "description": "User-configured application settings and preferences",
      "$comment": "Preferences are merged with system defaults at runtime",
      "properties": {
        "theme": {
          "type": "string",
          "enum": ["light", "dark", "auto"],
          "description": "UI theme selection"
        },
        "notifications": {
          "type": "boolean",
          "description": "Whether to send email notifications"
        }
      }
    }
  },
  "required": ["userId", "email"],
  "$comment": "This schema is validated on write operations to the profiles collection"
}
```

### XML Schema Documentation

XML Schema (XSD) should use `<xs:annotation>` and `<xs:documentation>` elements.

**Good Example**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xs:annotation>
    <xs:documentation>
      Campaign Configuration Schema
      Defines the structure for campaign data exported from the campaign management system.
    </xs:documentation>
  </xs:annotation>

  <xs:element name="campaign">
    <xs:annotation>
      <xs:documentation>
        Root element representing a single campaign with all associated metadata and settings.
      </xs:documentation>
    </xs:annotation>
    <xs:complexType>
      <xs:sequence>
        <xs:element name="campaignId" type="xs:string">
          <xs:annotation>
            <xs:documentation>
              Unique identifier for the campaign, matches campaigns.id in the database.
            </xs:documentation>
          </xs:annotation>
        </xs:element>
        <xs:element name="name" type="xs:string">
          <xs:annotation>
            <xs:documentation>
              Campaign name as displayed to users, must be unique within the organization.
            </xs:documentation>
          </xs:annotation>
        </xs:element>
        <xs:element name="status">
          <xs:annotation>
            <xs:documentation>
              Current campaign status, controls whether campaign is active in the system.
            </xs:documentation>
          </xs:annotation>
          <xs:simpleType>
            <xs:restriction base="xs:string">
              <xs:enumeration value="draft"/>
              <xs:enumeration value="active"/>
              <xs:enumeration value="paused"/>
              <xs:enumeration value="completed"/>
            </xs:restriction>
          </xs:simpleType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>

</xs:schema>
```

## Comment Quality Standards

- **Be Specific**: "User ID" not just "ID"
- **Explain Constraints**: Document CHECK constraints, ranges, and business rules
- **Clarify Abbreviations**: Explain any non-obvious abbreviations
- **Document Nullability**: When NULL has special meaning, document it
- **Include Examples**: For complex formats, provide example values

## Enforcement Rules

1. **No exceptions**: Every table creation must include comments
2. **Review requirement**: Before executing DDL, verify all fields are documented
3. **Consistency**: Follow the same comment patterns across all tables
4. **Updates**: When modifying tables, ensure comments remain accurate

## Prohibited Elements

The following documentation anti-patterns are **prohibited**:

- **Undocumented tables or fields** - Every element must have a comment; no exceptions.
- **Redundant comments** - Comments that only repeat the field name (e.g., `user_id INTEGER -- user id`)
- **Ambiguous generic comments** - Vague descriptions like "data field", "ID", or "information" that provide no meaningful context
- **Missing format specifications** - JSON, TEXT, or BLOB fields without data structure documentation
- **Unexplained constraints** - CHECK constraints, ranges, or validation rules without business logic explanation
- **Orphaned relationship documentation** - Foreign key comments that don't explain the relationship's purpose or usage

## Bad Example (Never Do This)
```sql
CREATE TABLE data (
    id INTEGER PRIMARY KEY,
    name TEXT,
    value INTEGER,
    status TEXT
);
```

## Good Example (Always Do This)
```sql
-- Stores configuration key-value pairs for application settings
CREATE TABLE configuration_data (
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- Unique identifier for each config entry
    setting_name TEXT NOT NULL UNIQUE, -- Configuration parameter name (e.g., 'max_users', 'timeout_seconds')
    setting_value INTEGER NOT NULL, -- Numeric value for the configuration parameter
    status TEXT CHECK(status IN ('active', 'deprecated', 'disabled')) NOT NULL -- Whether this setting is currently in use
);
```

**Claude must treat inline schema documentation as mandatory, not optional. Failure to include comprehensive documentation should be considered an error in the schema design process.**

## Change Log
- **2025-10-24** - Renamed from database_documentation_standards.md to schema_documentation_standards.md; expanded scope to include JSON Schema and XML Schema examples; updated terminology from "database" to "schema" for broader applicability (Claude - Protocol Refactoring Agent)
- **2025-10-17** - Protocol standardization: Added Purpose, Core Principles, and Change Log sections to comply with Protocol Authoring Standards (Claude - Protocol Compliance Agent)
- **[Original Date Unknown]** - Initial creation of Database Documentation Standards Protocol (Author Unknown)