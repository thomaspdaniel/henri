# Document Update Review Protocol

## Overview
This protocol establishes a systematic, multi-stage review process for updating any documentation files. It prevents errors, inconsistencies, and missed changes by using independent review agents with fresh context at each critical stage. This workflow applies automatically to all document changes unless explicitly bypassed.

## When This Protocol Applies

**Automatic activation** for changes to any documentation files including:
- Markdown files (.md)
- Text files (.txt)
- Documentation files (.rst, .adoc, etc.)
- Protocol documents
- README files
- Configuration documentation
- Any non-code document files

**Opt-out triggers** - Skip this protocol when user says:
- "quick changes"
- "direct edit"
- "skip review"
- "skip review process"
- "simple edit"
- "minor change"

**Exclusions** - This protocol does NOT apply to:
- Code files (.py, .js, .java, etc.)
- Data files (.json, .xml, .csv, etc.)
- Binary files

## Prerequisites

Before starting this workflow:
- Original document file exists and is readable
- User has provided clear change requirements
- Sufficient context about the changes is available

## Workflow Steps

### 1. Draft Proposed Changes
**Action**: Create a markdown file documenting all proposed changes

**Requirements**:
- File naming: `[original_filename]_proposed_changes_[timestamp].md`
- Use a structured format showing:
  - Section being changed
  - Current content (if modifying existing content)
  - Proposed new content
  - Rationale for each change
- Include line numbers or section headers for precise location references
- Make changes comprehensive and complete

**Example format**:
```markdown
# Proposed Changes for example_protocol.md

## Change 1: Update Purpose Section
**Location**: Lines 3-5 (Purpose section)

**Current content**:
> This protocol does X and Y.

**Proposed content**:
> This protocol establishes comprehensive standards for X, Y, and Z.

**Rationale**: Added Z to reflect expanded scope discussed with user.

## Change 2: Add New Section
**Location**: After line 47 (after Examples section)

**Proposed content**:
[Full new section content here]

**Rationale**: User requested troubleshooting guidance.
```

**Output**: Path to proposed changes file

### 2. Create Backup of Original Document
**Action**: Create timestamped backup of the original document before any modifications

**Requirements**:
- File naming: `[original_filename]_backup_[timestamp].[ext]`
- Exact copy of original file
- Preserve all formatting, whitespace, and metadata
- Confirm backup creation successful

**Implementation**:
```bash
cp original_file.md original_file_backup_20251016_143022.md
```

**Output**: Path to backup file

### 3. Launch Pre-Implementation Review Agent
**Action**: Spin up Task agent with fresh context to review proposed changes against original document

**Agent task prompt**:
```
Review the proposed changes for consistency and correctness.

Original document: [path_to_original]
Proposed changes: [path_to_proposed_changes]

Analyze:
1. **Consistency**: Do proposed changes maintain document structure, terminology, and style?
2. **Completeness**: Are all referenced sections, line numbers, and locations valid?
3. **Conflicts**: Do any changes contradict existing content elsewhere in the document?
4. **Clarity**: Are the proposed changes clear and unambiguous for implementation?
5. **Standards compliance**: Do changes follow any applicable protocol standards (formatting, structure, etc.)?

Provide:
- List of inconsistencies found (with specific locations)
- List of errors or issues (with severity: critical/major/minor)
- Recommendations for resolving each issue
- Overall assessment: APPROVED / NEEDS_REVISION

Format your response as a structured review report.
```

**Requirements**:
- Use Task tool with subagent_type="general-purpose"
- Provide both file paths to the agent
- Agent works with independent context (no prior conversation history)
- Wait for agent completion

**Output**: Review report with approval status and any issues identified

### 4. Resolve Review Issues with User
**Action**: If pre-implementation review identifies issues, work with user to resolve them

**Requirements**:
- Present review findings clearly to user
- For each issue, show:
  - Location in proposed changes
  - Description of the problem
  - Severity level
  - Recommended resolution (if agent provided one)
- Discuss resolution approach with user
- Update proposed changes file with resolutions
- If changes were substantial, optionally re-run Step 3

**Decision point**:
- If review status = APPROVED and no critical/major issues → Proceed to Step 5
- If review status = NEEDS_REVISION or critical/major issues → Must resolve before proceeding
- User can override and proceed at their discretion (but this should be noted)

**Output**: Confirmed readiness to proceed with implementation

### 5. Launch Implementation Agent
**Action**: Spin up Task agent with fresh context to apply the approved changes to the original document

**Agent task prompt**:
```
Apply the proposed changes to the document.

Original document: [path_to_original]
Proposed changes document: [path_to_proposed_changes]
Backup location: [path_to_backup] (for reference only - DO NOT modify)

Instructions:
1. Read the original document completely
2. Read all proposed changes
3. Apply each change precisely as specified in the proposed changes document
4. Maintain all existing formatting, structure, and style unless explicitly changed
5. Preserve line breaks, spacing, and indentation appropriately
6. Use Edit tool for modifications (NOT Write tool unless creating entirely new document)

Deliverables:
- Updated document with all changes applied
- Summary list of changes actually made (with line numbers/sections)
- Confirmation that all proposed changes have been implemented
```

**Requirements**:
- Use Task tool with subagent_type="general-purpose"
- Provide paths to original, proposed changes, and backup
- Agent works with independent context
- Agent should use Edit tool for surgical changes
- Wait for agent completion

**Output**: Updated document and implementation summary

### 6. Launch Post-Implementation Validation Agent
**Action**: Spin up Task agent with fresh context to validate the updated document against the backup and proposed changes

**Agent task prompt**:
```
Validate that all proposed changes were correctly implemented.

Backup document (original): [path_to_backup]
Proposed changes: [path_to_proposed_changes]
Updated document: [path_to_original]

Validation tasks:
1. **Completeness check**: Verify every change in the proposed changes document was applied
2. **Accuracy check**: Verify each change matches what was specified (no deviations)
3. **Integrity check**: Verify no unintended changes were made to other parts of the document
4. **Quality check**: Verify formatting, structure, and syntax are valid

For each proposed change:
- [ ] Change applied: YES/NO
- [ ] Applied correctly: YES/NO/N/A
- [ ] Issues found: [description or NONE]

Provide:
- Complete validation report
- List of missing changes (not implemented)
- List of incorrect implementations (deviations from proposed)
- List of unintended changes (changes not in proposed document)
- Overall assessment: VALIDATED / ISSUES_FOUND

If issues found, categorize by severity: critical/major/minor
```

**Requirements**:
- Use Task tool with subagent_type="general-purpose"
- Provide all three file paths to agent
- Agent works with independent context
- Wait for agent completion

**Output**: Validation report with status and any issues found

### 7. Fix Validation Issues
**Action**: If validation identifies missing or incorrect changes, fix them

**Requirements**:
- Review validation report with user
- For each issue:
  - Show what was expected vs. what was implemented
  - Determine correct resolution
- Apply fixes directly using Edit tool
- If fixes are substantial, optionally re-run Step 6

**Decision point**:
- If validation status = VALIDATED and no issues → Proceed to Step 8
- If validation status = ISSUES_FOUND with critical/major issues → **MUST** fix before proceeding
- Minor issues can be addressed based on user preference

**Output**: Confirmation that document is now correct and complete

### 8. Cleanup Temporary Files
**Action**: Remove backup file and proposed changes document after successful validation

**Requirements**:
- Only proceed with cleanup if:
  - Validation passed (or all issues resolved)
  - User confirms satisfaction with updated document
- Delete backup file: `[original_filename]_backup_[timestamp].[ext]`
- Delete proposed changes file: `[original_filename]_proposed_changes_[timestamp].md`
- Confirm deletion successful

**User override option**: User may request to keep backup/proposed changes files for their records

**Output**: Confirmation of cleanup completion

## Error Handling

### Review Failures (Step 3)
**Scenario**: Pre-implementation review agent identifies critical issues or fails to complete

**Response**:
1. Present review findings to user immediately
2. Do NOT proceed to implementation until issues resolved
3. Work with user to revise proposed changes
4. Update proposed changes document
5. Re-run review agent if changes were substantial
6. Only proceed when review approval obtained

### Implementation Failures (Step 5)
**Scenario**: Implementation agent fails to apply changes or encounters errors

**Response**:
1. Stop immediately - do not proceed to validation
2. Original document should be unchanged (or restore from backup if partially modified)
3. Review implementation agent's error messages
4. Determine if issue is with:
   - Proposed changes document (unclear, invalid locations)
   - Original document (unexpected format, syntax issues)
   - Agent execution (tool failures, permission issues)
5. Resolve root cause with user
6. Restart from Step 5 with corrected inputs

### Validation Failures (Step 6)
**Scenario**: Validation agent finds missing, incorrect, or unintended changes

**Response**:
1. Present validation report to user with specific issues
2. Categorize issues by severity
3. For critical issues: **MUST** fix before cleanup
4. For major issues: Should fix (discuss with user)
5. For minor issues: User decides whether to fix
6. Apply fixes in Step 7
7. Optionally re-validate if fixes were substantial
8. Only proceed to cleanup when document is confirmed correct

### Backup/Cleanup Failures
**Scenario**: Cannot create backup (Step 2) or delete files (Step 8)

**Response**:
- **Backup creation failure**: **MUST** stop workflow - do NOT proceed without backup
- **Cleanup failure**: Non-critical - inform user, they can manually delete files
- Check file permissions, disk space, file locks
- Provide user with exact file paths for manual intervention if needed

## Integration Requirements

### Alignment with Protocol Authoring Standards
When this workflow is used to update protocol documents:
- Validation agent in Step 6 **MUST** check compliance with `protocol_authoring_standards.md`
- Include protocol-specific validation items:
  - Header hierarchy correct
  - Required sections present
  - Formatting standards followed
  - Change log updated properly
  - Examples follow standard format

### Alignment with Verification and Completion Standards
This workflow embodies verification standards by:
- Requiring specific evidence at each stage (review reports, implementation summaries, validation reports)
- Using independent agent contexts for unbiased review
- Mandating validation before completion
- Preventing false completion claims through multi-stage verification

### Alignment with Risk-Aware Change Management
For high-value documents (protocols, critical documentation):
- User approval required before implementation (Step 4)
- Backup always created before modifications (Step 2)
- Multiple validation stages reduce risk of errors
- Rollback capability via backup file

## Example Usage

### Scenario: Updating a Protocol Document

**User request**: "Update the Testing Quality Standards protocol to add a new section about integration testing requirements."

**Step 1 - Draft proposed changes**:
```
I'll create a proposed changes document outlining the new integration testing section.

Created: testing_quality_standards_proposed_changes_20251016_143500.md

The proposed changes add:
- New H2 section "Integration Testing Requirements" after line 234
- 5 subsections covering test scope, environment setup, data handling,
  assertion patterns, and CI/CD integration
- Updated table of contents to include new section
- Change log entry for this update
```

**Step 2 - Create backup**:
```
Created backup: testing_quality_standards_backup_20251016_143500.md
Backup confirmed: 15,234 bytes
```

**Step 3 - Pre-implementation review**:
```
Launching review agent to validate proposed changes...

Review agent completed. Status: NEEDS_REVISION

Issues found:
1. [MAJOR] Proposed section placement conflicts with existing "Test
   Execution Standards" section which already covers some integration
   testing topics
2. [MINOR] Change log format uses MM-DD-YYYY instead of required YYYY-MM-DD
3. [MINOR] New section uses H4 headers where H3 would be more appropriate

Recommendation: Restructure to merge integration content into existing
section rather than creating duplicate coverage.
```

**Step 4 - Resolve issues with user**:
```
The review identified that the new section overlaps with existing content.

Options:
1. Merge new integration requirements into existing "Test Execution
   Standards" section
2. Restructure both sections to clearly separate unit vs integration testing
3. Proceed as planned but add cross-references to avoid confusion

Which approach would you prefer?
```

*User chooses option 2*

```
I'll revise the proposed changes to restructure both sections with clear
separation.

Updated: testing_quality_standards_proposed_changes_20251016_143500.md
- Restructured approach
- Fixed change log date format
- Corrected header hierarchy

Re-running review agent...
Review status: APPROVED - No issues found
```

**Step 5 - Implementation**:
```
Launching implementation agent to apply changes...

Implementation completed.
Changes applied:
- Restructured "Test Execution Standards" (lines 180-234)
- Added new "Integration Testing Requirements" (lines 235-312)
- Updated table of contents (lines 8-15)
- Added change log entry (line 789)

All 4 change groups from proposed changes document have been implemented.
```

**Step 6 - Validation**:
```
Launching validation agent to verify implementation...

Validation completed. Status: ISSUES_FOUND

Issues:
1. [MINOR] Table of contents shows page reference "p.15" but protocols
   don't use page numbers (line 12)
2. [CRITICAL] Change log entry missing - was specified in proposed changes
   but not found in updated document

Missing changes: Change log entry (proposed change #4)
Unintended changes: NONE
```

**Step 7 - Fix issues**:
```
Validation found 1 critical issue (missing change log) and 1 minor issue
(incorrect TOC format).

Fixing:
✅ Added change log entry at line 789
✅ Removed page reference from TOC at line 12

All validation issues resolved.
```

**Step 8 - Cleanup**:
```
Document update completed successfully. Removing temporary files...

Deleted: testing_quality_standards_backup_20251016_143500.md
Deleted: testing_quality_standards_proposed_changes_20251016_143500.md

Workflow complete. Updated protocol validated and ready for use.
```

## Change Log
- **2025-10-16** - Initial creation (Claude - Protocol Architect)
