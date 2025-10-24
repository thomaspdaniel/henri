# Risk-Aware Change Management Protocol

## Overview
This protocol protects production data by requiring comprehensive risk assessment before any potentially destructive changes to databases, schemas, files, or critical systems. It ensures that high-risk operations are validated through isolated proof-of-concept testing with explicit user approval before production execution, preventing data loss and system damage through systematic verification.

## Prerequisites

Before applying this workflow:
- Ability to create isolated test environments (separate databases/directories)
- Understanding of production vs. non-production data identification criteria
- User availability for approval at risk assessment and production execution checkpoints
- Access to backup/restore capabilities for the systems being modified

## Mandatory Risk Assessment Process
**Claude MUST perform risk assessment before making any potentially destructive changes to production systems, databases, or critical files.** Never proceed directly to implementation when data loss or system damage is possible.

## Production Data Identification
**Claude must treat data as production unless explicitly told otherwise by the user.** Assume data has value and requires protection.

**Production indicators include:**
- Data in active project directories (not explicitly marked as test/temp)
- Existing databases with meaningful names and substantial record counts
- Files containing real business data, configurations, or user content
- Any data the user references as important or existing work
- Auto-increment sequences with gaps (indicates real usage over time)

**Non-production indicators:**
- Files/databases explicitly in `/tmp/`, `/test/`, or similar directories
- Empty or newly created databases/tables
- Data explicitly described as "test" or "sample" by user
- Throwaway scripts or temporary files

**When uncertain: Ask the user to clarify if data should be treated as production.**

## The Problem-Solution-Validation Cycle

### 1. Problem Identification
- **Document the specific problem** being solved
- **Identify what data/systems are at risk** during the solution
- **Assess impact scope**: How many records, files, or systems affected?

### 2. Solution Design & Risk Assessment
- **Propose the solution approach** with specific steps
- **Identify all risks**: What could go wrong? What data could be lost?
- **Document assumptions**: What are we assuming will work?
- **Classify risk level** based on criteria below

### 3. Risk Classification
**High Risk Changes** (require proof-of-concept):
- Database schema modifications with existing data
- Batch data migrations or transformations  
- File system operations affecting multiple files
- Auto-increment/primary key modifications
- Foreign key relationship changes
- Any operation that could cause data loss

**Low Risk Changes** (can proceed directly):
- Adding new empty tables/columns
- Creating new files
- Read-only operations
- Adding indexes to existing tables

### 4. User Approval for Testing
**For High Risk changes, Claude MUST present to user:**
```
RISK ASSESSMENT RESULTS:
Problem: [Description of issue being solved]
Proposed Solution: [Step-by-step approach]
Risk Level: HIGH RISK
Impact: [What production data/systems are affected]
Potential Consequences: [What could go wrong]

PROPOSED PROOF-OF-CONCEPT TEST:
Test Environment: [Where/how test will be created]
Test Data: [What kind of test data will be used]
Test Scope: [What aspects will be validated]
Expected Outcomes: [What results prove success]

Do you want me to proceed with creating and running this proof-of-concept test?
```

**Wait for explicit user approval before creating any test environments or executing proof-of-concept tests.**

### 5. Proof-of-Concept Execution (After User Approval)
- **Create isolated test environment** (separate database/directory)
- **Replicate the problem scenario** with realistic test data
- **Execute the complete proposed solution** on test data
- **Verify all aspects work correctly** including edge cases
- **Document test results** and present to user for production approval

### 6. Test Design Standards
**Test environments must:**
- **Mirror production complexity**: Similar data volumes, relationships, constraints
- **Include edge cases**: Gaps, nulls, duplicates, boundary conditions
- **Test complete end-to-end process**: Every step of the proposed solution
- **Verify preservation**: Confirm no data loss or corruption
- **Test rollback procedures**: Ensure recovery is possible if needed

### 7. Production Execution (After Test Success)
**Present test results to user:**
```
PROOF-OF-CONCEPT TEST RESULTS:
✅ Test completed successfully
✅ [Specific validations that passed]
✅ Edge cases handled correctly
✅ No data loss occurred
✅ Rollback procedure confirmed

The validated approach is ready for production execution.
Do you want me to proceed with applying this solution to your production data?
```

**Only execute on production data after explicit user approval.**

## Example Usage

```
RISK ASSESSMENT RESULTS:
Problem: Requirements tables lack inline SQL comments
Proposed Solution: Backup → Drop → Recreate → Migrate → Reset sequences
Risk Level: HIGH RISK
Impact: 436 requirements records, 783 category relationships, 7 cross-references
Potential Consequences: Data loss, broken foreign keys, auto-increment sequence corruption

PROPOSED PROOF-OF-CONCEPT TEST:
Test Environment: Create test database in /tmp/ directory
Test Data: 100 records with similar ID gaps and relationships
Test Scope: Complete backup/recreation process, gap preservation, sequence reset
Expected Outcomes: All gaps preserved, auto-increment continues correctly, comments added

Do you want me to proceed with creating and running this proof-of-concept test?
```

## Enforcement Rules

1. **Always assume production**: Treat data as valuable unless explicitly told otherwise
2. **Always get approval**: Never run tests without explicit user consent
3. **No exceptions**: High-risk changes require proof-of-concept testing
4. **Conservative bias**: When uncertain about risk level, choose proof-of-concept
5. **Double approval**: Get approval for testing AND for production execution
6. **Clear communication**: Present risk assessment and test plans clearly

## Quality Gates

**Before proposing any high-risk change:**
- [ ] Risk assessment completed and documented
- [ ] User informed of risk level and impact scope
- [ ] Proof-of-concept test plan presented to user
- [ ] User approval obtained before creating test environment

**Before production execution:**
- [ ] Test environment created with realistic data (after user approval)
- [ ] Complete solution tested end-to-end
- [ ] Test results documented and presented to user
- [ ] User approval obtained for production execution
- [ ] Rollback procedure confirmed

**Claude must never assume the user wants potentially destructive changes executed without explicit discussion and approval at each stage.**

## Change Log
- **2025-10-17** - Added Overview and Prerequisites sections, renamed Example section, added Change Log to comply with protocol authoring standards (Claude - Protocol Architect)
- **2025-10-15** - Initial creation with comprehensive risk assessment workflow and proof-of-concept testing procedures (Tom - Project Owner)