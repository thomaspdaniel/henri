# Verification and Completion Standards Protocol

## Purpose
This protocol addresses a critical problem: false completion claims and unverified assertions that undermine trust and quality. When Claude claims "verified" or "finished" without providing specific evidence, users cannot validate the work, leading to undetected errors and incomplete implementations. This protocol ensures all verification and completion claims are backed by concrete, measurable evidence that users can independently validate.

## Mandatory Evidence Requirements
**Claude MUST provide specific evidence when claiming verification or completion.** Never use terms like "verified" or "finished" without demonstrating proof.

## Verification Claims
**"Verified" means 100% checked with evidence provided.**

### Required for Verification Claims
- **Scope specification**: Exactly what was verified (e.g., "5 out of 21 records verified")
- **Method documentation**: How verification was performed
- **Evidence presentation**: Specific examples, counts, or test results
- **Gap identification**: What was NOT verified

### Prohibited Without Evidence
- ❌ "All changes verified" (without checking every change)
- ❌ "Conversion successful" (without comprehensive validation)
- ❌ "Text updates correct" (without sampling actual conversions)

## Completion Claims
**"Finished" means 100% complete with evidence provided.**

### Required for Completion Claims
- **Deliverable confirmation**: All specified outputs produced
- **Quality validation**: Results meet stated requirements
- **Edge case coverage**: Corner cases addressed
- **Success criteria met**: Measurable completion standards satisfied

## Evidence Standards
**When claiming verification or completion, Claude must provide:**
1. **Quantified scope**: "X out of Y items checked"
2. **Specific examples**: Show actual before/after comparisons
3. **Test results**: Concrete validation outcomes
4. **Limitation acknowledgment**: What remains unverified/incomplete

## Uncertainty Requirements
**When uncertain**: Claude must explicitly state "This claim requires additional verification" rather than implying completeness. Never present partial verification as complete verification.

## Examples

### Good Examples
**Good:** "Pool calculations verified for all 8 affected records (Records 233, 234, 235, 236, 276, 293, 294, 295). Each calculation confirmed against original values."

**Good:** "Text conversion verified via sampling: 3 out of 21 records spot-checked. Found 2 errors (Records 221, 254) which have been corrected. Remaining 18 records require validation."

### Bad Examples
**Bad:** "Pool calculations verified successfully."

**Bad:** "Text conversion completed successfully."

## Enforcement
**Claude must treat verification and completion claims as requiring proof, not assertions.** When uncertain about completeness, acknowledge limitations explicitly rather than overstating confidence.

**Violation consequences**: Claims of verification/completion without evidence constitute incomplete analysis and must be corrected immediately.

## User Enforcement Guidelines
**When Claude claims verification/completion without evidence, respond with**: "Provide specific evidence for this claim or acknowledge what remains unverified."

**Consistent user enforcement is essential for training proper behavior.**

## Change Log
- **2025-10-17** - Added Purpose section, renamed Examples section, added Change Log per protocol authoring standards (Claude - Protocol Compliance Agent)
- **2025-10-17** - Initial creation (Claude - Protocol Architect)