# Data Extraction Pattern Validation Protocol

## Overview
When creating scripts that parse structured text data (markdown, documentation, etc.), use Claude's prose interpretation abilities to systematically validate regex patterns against real data before execution. This protocol implements test-driven development for data extraction by validating parsing logic against actual data formats before running the extraction.

## Prerequisites
- Source data file must be accessible to Claude
- Claude must be able to read the file format
- Extraction script is in development but not yet executed
- Clear understanding of what data needs to be extracted

## Workflow Steps

### 1. Read the Source Data File
Understand actual format variations before creating patterns. Use Claude's Read tool to examine the complete source data file, identifying all variations in structure, formatting, and edge cases.

**Actions:**
- Read the entire source data file
- Document observed format patterns and variations
- Note any inconsistencies or edge cases in the data
- Identify the data elements that need to be extracted

### 2. Validate Each Parsing Pattern
For each parsing pattern in the script, systematically validate it against all instances in the source data.

**Actions:**
- Ask Claude to examine all instances of that pattern type in the source data
- Have Claude identify edge cases where the current regex would fail
- Request specific examples of problematic matches or non-matches
- Fix patterns incrementally based on real data, not assumptions

**Example validation prompts:**
```
"Are there any entries in @source_file where the [pattern name] pattern fails to properly detect the [target data]?"

"Looking at the [data type] in @source_file, can you identify specific examples where the current [pattern name] pattern might fail?"
```

### 3. Continue Pattern-by-Pattern
Repeat the validation process until all parsing logic is validated against actual data.

**Actions:**
- Validate each pattern independently before moving to the next
- Document fixes and rationale for pattern changes
- Re-validate modified patterns against the source data
- Ensure patterns handle all identified edge cases

### 4. Execute After Validation
Only execute the extraction script after all patterns are validated.

**Actions:**
- Run the extraction script on the source data
- Verify that extracted data matches expectations
- Check for any missed data or incorrect extractions
- Document extraction results

## Error Handling

### Pattern Validation Failures
**Problem:** Regex pattern fails to match expected data in source file.

**Solution:**
1. Ask Claude to identify specific examples where the pattern fails
2. Analyze the failing cases to understand format variations
3. Refine the regex pattern to handle the edge cases
4. Re-validate the updated pattern against all instances
5. Continue iteration until 100% match coverage achieved

### Ambiguous Data Formats
**Problem:** Source data has inconsistent formatting or multiple valid formats.

**Solution:**
1. Document all format variations identified by Claude
2. Decide whether to normalize data or handle multiple formats
3. Create separate patterns for distinct format types if needed
4. Validate each pattern variant against its target subset
5. Test extraction script handles all format variations correctly

### File Access Issues
**Problem:** Claude cannot read the source file or file format is unsupported.

**Solution:**
1. Verify file path is correct and accessible
2. Check file permissions and format compatibility
3. Convert unsupported formats to readable format (e.g., PDF → text)
4. For binary formats, extract text content first before validation
5. If file is too large, validate patterns on representative sample

### Script Execution Errors
**Problem:** Extraction script fails during execution despite pattern validation.

**Solution:**
1. Check for syntax errors in the script itself (unrelated to patterns)
2. Verify script logic correctly implements the validated patterns
3. Test script on small data subset first to isolate issues
4. Review extraction output for missed or incorrectly captured data
5. Return to pattern validation if data extraction is incomplete

## Example Usage

### Scenario: Extracting Requirements from Markdown Documentation

**Context:** You have a requirements document (`requirements.md`) with 50 requirements written in markdown. Each requirement follows this general format:
```markdown
## REQ-001: User Authentication
Category: Security
Priority: High

Users must be able to log in using email and password...
```

You want to create a Python script to extract requirement IDs, titles, categories, priorities, and descriptions.

**Step 1: Read the Source Data**
```
User: "Please read @requirements.md and help me create an extraction script."
Claude: [Reads file, identifies format patterns]
"I can see the requirements follow a pattern with ## headers containing REQ-ID and title,
followed by Category and Priority lines, then description text. However, I notice some
variations: REQ-023 has 'Criticality' instead of 'Priority', and REQ-045 has no category line."
```

**Step 2: Validate Parsing Patterns**

*Initial pattern for requirement headers:*
```python
pattern = r'^## (REQ-\d{3}): (.+)$'
```

```
User: "Will this pattern match all requirement headers in @requirements.md?"
Claude: "Let me check... Yes, this pattern matches all 50 requirement headers.
However, I notice REQ-032 has a colon in the title: 'REQ-032: API Design: REST Endpoints',
which your pattern will capture correctly as 'API Design: REST Endpoints'."
```

*Initial pattern for category:*
```python
pattern = r'^Category: (.+)$'
```

```
User: "Are there any requirements where this category pattern would fail?"
Claude: "Yes, there are issues:
- REQ-045 has no Category line at all
- REQ-017 uses 'Categories: Security, Performance' (plural with multiple values)
- REQ-023 uses 'Type: Functional' instead of Category
The pattern needs to handle missing categories and possibly capture alternate field names."
```

**Step 3: Fix Patterns Based on Validation**

*Updated category extraction logic:*
```python
# Make category optional, handle multiple formats
category_pattern = r'^(?:Category|Categories|Type): (.+)$'
# Add logic to handle missing categories with default value
```

```
User: "Now can you validate this updated pattern against all requirements?"
Claude: "Much better! This now matches:
- REQ-017: Captures 'Security, Performance'
- REQ-023: Captures 'Functional' from Type field
- REQ-045: Pattern won't match (no category line), so default handling will work
All 50 requirements are now covered."
```

**Step 4: Execute After Validation**
```
User: "All patterns validated. Please run the extraction script."
Claude: [Executes script]
"Extraction complete! Successfully extracted all 50 requirements:
- 50/50 requirement IDs captured
- 50/50 titles captured
- 49/50 categories captured (1 default used for REQ-045)
- 48/50 priorities captured (2 defaults used)
- 50/50 descriptions captured
Results saved to requirements_extracted.json"
```

**Outcome:** Zero failed extractions, complete data capture, all edge cases handled before execution.

## Integration Notes

### Connection to Testing Quality Standards
This protocol implements test-driven development principles for data extraction:
- **Validate before execute** - Like writing tests before code
- **Real data validation** - Like testing against production-like data
- **Edge case coverage** - Like comprehensive test case design
- **Iterative refinement** - Like test-fix-retest cycles

When used alongside Testing Quality Standards protocol, apply the same rigorous validation mindset to data extraction as you would to code testing.

### Relationship to Risk-Aware Change Management
When extracting data for migration or transformation:
1. **MUST** validate patterns using this protocol before running extraction on production data
2. Test extraction scripts on copy of data first (per Risk-Aware Change Management)
3. Validate extraction results against source data for accuracy
4. This protocol provides the "test on non-production data" step for extraction workflows

### When to Use This Protocol
Apply this protocol for any task involving:
- Parsing structured or semi-structured text data (markdown, logs, documentation)
- Extracting data from files using regex or pattern matching
- Creating scripts that transform or migrate data
- Any situation where silent data loss would be problematic

**Do NOT use** for simple, one-time file reads where pattern validation overhead exceeds value.

## Why This Works

- **Claude's prose interpretation** catches format variations humans miss when scanning data
- **Systematic validation** prevents silent data loss from incorrectly matched patterns
- **Edge case discovery** before execution saves debugging cycles and prevents data loss
- **Real data validation** beats theoretical pattern design and assumption-based coding

## Benefits

- Zero failed extractions due to parsing issues
- Complete data capture without manual verification
- Robust patterns that handle natural language variation and edge cases
- Faster development cycle (validate → execute vs execute → debug → fix → re-execute)
- Higher confidence in extraction accuracy and completeness
- Reduced risk of silent data loss

## Change Log
- **2025-10-17** - Restructured as Type B Workflow protocol with Prerequisites, Error Handling, Example Usage, and Integration Notes sections; expanded Workflow Steps with detailed actions; improved Overview with TDD framing (Claude - Protocol Architect)
- **2025-10-16** - Initial creation (Claude - Protocol Architect)