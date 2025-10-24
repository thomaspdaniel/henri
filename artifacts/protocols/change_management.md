# Change Management Protocol

## Purpose
This protocol serves as an umbrella for coordinating all change management concerns across software development, schema modifications, configuration changes, and system updates. It provides a comprehensive taxonomy of risks and controls, coordinates existing change management protocols, and establishes guidelines for determining which protocols apply in different scenarios.

## When This Protocol Applies
Trigger this protocol when the user mentions:
- "change management"
- "change control"
- "production change"
- "deployment planning"
- "risk assessment"
- "what protocols should I use"
- When making any significant system, schema, or code changes

## Overview
Change management encompasses documentation, risk assessment, testing, validation, and controlled deployment across all types of system changes. This umbrella protocol coordinates multiple specialized protocols, each addressing specific aspects of change management.

**Key Principles:**
- Not all changes require all protocols - depends on risk level and change type
- Protocol ecosystem is growing - this documents current state and future direction
- Use integration guidelines to determine which protocols apply to your specific scenario
- When uncertain, err on the side of caution by using more protocols rather than fewer

**Change Management Scope:**
- Database schema modifications and data migrations
- Code changes affecting functionality, performance, or security
- Configuration changes across environments
- Deployment procedures and release management
- Technology evaluation and proof-of-concept testing
- Documentation quality and knowledge capture

## Change Management Risk Taxonomy

The following risks have been identified through collaborative analysis. Each risk represents a potential negative outcome from system, schema, or code changes.

⚠️ **Note**: Many of these risks do not yet have dedicated protocols or detailed mitigation procedures. This taxonomy serves as a planning document for future protocol development. Risk importance varies by context - not all risks are equally critical for every project.

### 1. Loss of Existing Production Data *(Original - Tom)*
- **Description**: Permanent data deletion or corruption due to schema changes, migrations, or system updates
- **Examples**: DROP TABLE on production, failed migration with no backup, data transformation errors
- **Current Protocol Coverage**: risk_aware_change_management.md (partial)
- **Status**: ⚠️ Additional protocol development needed for backup procedures and data validation

### 2. Loss of Pre-existing Functionality *(Original - Tom)*
- **Description**: Working features break or behave incorrectly after code or schema changes
- **Examples**: API endpoints fail, UI features stop working, business logic errors introduced
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for regression testing and functionality validation

### 3. Reduction in Solution Performance Due to Code Change *(Original - Tom)*
- **Description**: Code modifications introduce performance regressions (slower execution, higher resource usage)
- **Examples**: Inefficient algorithms, memory leaks, unnecessary database queries, blocking operations
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for performance testing and benchmarking

### 4. Reduction in Solution Performance Due to Increased Data Scale *(Original - Tom)*
- **Description**: System performs adequately with test data but degrades under production data volumes
- **Examples**: Query timeouts with large datasets, memory exhaustion, unbounded loops, missing indexes
- **Current Protocol Coverage**: risk_aware_change_management.md mentions realistic data volumes in testing
- **Status**: ⚠️ Additional protocol development needed for capacity planning and load testing

### 5. Cybersecurity Risk Introduced Due to Code Change *(Original - Tom)*
- **Description**: Code changes introduce security vulnerabilities or expand attack surface
- **Examples**: SQL injection, XSS vulnerabilities, authentication bypasses, exposed secrets, privilege escalation
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for security code review, scanning, and threat modeling

### 6. Loss of Data Integrity
- **Description**: Data corruption, inconsistency, or constraint violations (beyond total data loss)
- **Examples**: Broken foreign keys, duplicate records violating uniqueness, invalid state transitions, checksum failures
- **Current Protocol Coverage**: risk_aware_change_management.md (partial - via POC testing)
- **Status**: ⚠️ Additional protocol development needed for data validation and reconciliation procedures

### 7. Deployment Failure or Partial Deployment
- **Description**: Change deployment fails partway through or applies inconsistently across systems
- **Examples**: Schema migration fails midway leaving database in inconsistent state, rolling deployment fails on some servers, transaction rollback incomplete
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for deployment verification and atomic deployment procedures

### 8. Inability to Rollback
- **Description**: Change is irreversible or rollback procedure fails when needed
- **Examples**: One-way data transformation with no backup, destructive schema change, stateful change with no undo procedure
- **Current Protocol Coverage**: risk_aware_change_management.md mentions rollback verification
- **Status**: ⚠️ Additional protocol development needed for rollback testing and reversibility verification

### 9. Breaking Changes to Integrations/APIs
- **Description**: Changes break downstream systems, client applications, or API consumers
- **Examples**: API contract violation, schema change breaks clients, removed endpoints still in use, changed data format
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for API versioning, deprecation procedures, and integration testing

### 10. Configuration Errors
- **Description**: Wrong configuration applied to production environment
- **Examples**: Development database URL in production, feature flags incorrectly set, resource limits too low, wrong API keys
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for configuration validation and environment-specific config management

### 11. Dependency/Library Vulnerabilities or Incompatibilities
- **Description**: Dependency updates introduce vulnerabilities, breaking changes, or version conflicts
- **Examples**: Library update introduces known CVE, breaking API changes in minor version, transitive dependency conflicts
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for dependency scanning, version pinning, and update testing

### 12. Documentation Debt/Knowledge Loss
- **Description**: Changes made without proper documentation leading to knowledge loss and maintenance difficulty
- **Examples**: Complex logic without comments, undocumented schema changes, tribal knowledge not captured, outdated documentation
- **Current Protocol Coverage**: schema_documentation_verification.md (for schemas only)
- **Status**: ⚠️ Additional protocol development needed for code documentation standards and knowledge capture

### 13. Environment Drift
- **Description**: Development, staging, and production environments become inconsistent
- **Examples**: Production has manual patches not in version control, staging missing production configuration, dependency version mismatches
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for environment consistency verification and infrastructure as code

### 14. Monitoring/Observability Gaps
- **Description**: Insufficient monitoring prevents detection or diagnosis of issues
- **Examples**: New features have no metrics, errors not logged, no alerting on critical failures, missing distributed tracing
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for observability requirements and monitoring standards

### 15. Service Availability/Downtime During Deployment
- **Description**: Service becomes unavailable or degraded during change deployment
- **Examples**: Database locked during long migration, API unavailable during restart, zero-downtime deployment fails
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for deployment strategies (blue-green, canary, etc.) and availability requirements

### 16. Access Control/Permission Errors
- **Description**: Permissions set incorrectly - either too broad (security risk) or too narrow (functionality break)
- **Examples**: New service has unnecessary admin access, users can't access new feature, role misconfiguration
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for permission review and least-privilege validation

### 17. Compliance Violations
- **Description**: Changes violate regulatory, policy, or contractual requirements
- **Examples**: PII handling violates GDPR, audit trail removed violates SOC2, data retention policy violated, accessibility standards broken
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for compliance review and regulatory requirements tracking

## Change Management Control Taxonomy

The following controls have been identified as potential mitigation strategies for change management risks. Each control represents a practice, process, or technical safeguard that can prevent or detect problems during changes.

⚠️ **Note**: Many of these controls do not yet have detailed implementation protocols. This taxonomy serves as a planning document for future protocol development. Control applicability and priority varies by project context - not all controls are necessary for every change.

### 1. Backup Data *(Original - Tom)*
- **Purpose**: Enable recovery from data loss or corruption
- **Mitigates Risks**: #1 (data loss), #6 (data integrity), #8 (rollback)
- **Current Protocol Coverage**: risk_aware_change_management.md (mentioned as prerequisite)
- **Status**: ⚠️ Additional protocol development needed for backup procedures, retention, and restoration testing

### 2. Test Changes to Ensure Data Is Not Lost *(Original - Tom)*
- **Purpose**: Validate data preservation through proof-of-concept testing before production
- **Mitigates Risks**: #1 (data loss), #6 (data integrity), #8 (rollback)
- **Current Protocol Coverage**: risk_aware_change_management.md (comprehensive POC testing workflow)
- **Status**: ✅ Well-covered by existing protocol

### 3. Automate Testing and Perform Regression Testing *(Original - Tom)*
- **Purpose**: Detect functionality breakage through automated test suites
- **Mitigates Risks**: #2 (functionality loss), #3 (performance - code), #9 (API breaking changes)
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for test automation standards, regression test requirements, and CI/CD integration

### 4. Perform Performance Tests as Part of QA and User Acceptance Testing *(Original - Tom)*
- **Purpose**: Detect performance regressions and scalability issues before production
- **Mitigates Risks**: #3 (performance - code), #4 (performance - scale)
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for performance testing standards, benchmarking, and acceptance criteria

### 5. Run Security Code Scans, Monitor Libraries for Vulnerabilities, Run Threat Analysis, Run Intrusion Tests *(Original - Tom)*
- **Purpose**: Identify and mitigate security vulnerabilities in code and dependencies
- **Mitigates Risks**: #5 (security vulnerabilities), #11 (dependency vulnerabilities)
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for security review standards, scanning tools, threat modeling, and penetration testing

### 6. Version Control All Changes
- **Purpose**: Track what changed, when, and by whom for auditability and rollback capability
- **Applies To**: Code, configuration, schema, infrastructure
- **Mitigates Risks**: #8 (rollback), #12 (documentation debt), #13 (environment drift), #17 (compliance - audit trails)
- **Current Protocol Coverage**: None (assumed standard practice)
- **Status**: ⚠️ Protocol development needed for version control standards and commit requirements

### 7. Code Review Requirements
- **Purpose**: Catch issues through peer review before merge
- **Applies To**: Code changes, schema changes, configuration changes
- **Mitigates Risks**: #2 (functionality loss), #3 (performance), #5 (security), #10 (configuration errors), #12 (documentation debt)
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for code review standards, approval workflows, and review checklists

### 8. Automated Deployment Processes
- **Purpose**: Reduce manual errors through CI/CD pipelines and infrastructure as code
- **Mitigates Risks**: #7 (deployment failure), #10 (configuration errors), #13 (environment drift)
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for deployment automation standards and pipeline requirements

### 9. Environment Parity
- **Purpose**: Ensure dev/staging mirrors production for realistic testing
- **Mitigates Risks**: #4 (performance - scale), #7 (deployment failure), #13 (environment drift)
- **Current Protocol Coverage**: risk_aware_change_management.md mentions realistic test environments
- **Status**: ⚠️ Additional protocol development needed for environment consistency requirements

### 10. Gradual Rollout Strategies
- **Purpose**: Limit blast radius through canary deployments, blue-green, feature flags
- **Mitigates Risks**: #7 (deployment failure), #8 (rollback), #15 (downtime)
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for deployment strategy standards and gradual rollout procedures

### 11. Post-Deployment Verification
- **Purpose**: Confirm deployment succeeded through smoke tests and health checks
- **Mitigates Risks**: #7 (deployment failure), #2 (functionality loss), #15 (downtime)
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for deployment verification standards and health check requirements

### 12. Monitoring and Alerting
- **Purpose**: Detect issues quickly through metrics, logs, and traces
- **Mitigates Risks**: #14 (observability gaps), #3 (performance), #15 (downtime)
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for monitoring standards, alerting requirements, and observability best practices

### 13. Rollback Procedures
- **Purpose**: Ensure reversibility through documented and tested rollback
- **Mitigates Risks**: #8 (inability to rollback), #7 (deployment failure), #15 (downtime)
- **Current Protocol Coverage**: risk_aware_change_management.md mentions rollback verification
- **Status**: ⚠️ Additional protocol development needed for rollback testing and reversibility standards

### 14. Change Approval Workflows
- **Purpose**: Human oversight at critical decision points for high-risk changes
- **Mitigates Risks**: All risks (general risk reduction through oversight)
- **Current Protocol Coverage**: risk_aware_change_management.md (user approval at key stages)
- **Status**: ⚠️ Additional protocol development needed for approval criteria and escalation procedures

### 15. Audit Logging
- **Purpose**: Track who did what when for accountability and forensics
- **Mitigates Risks**: #17 (compliance), #5 (security), accountability for all risks
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for audit logging standards and retention requirements

### 16. Documentation Requirements
- **Purpose**: Capture knowledge through inline comments, architecture docs, runbooks
- **Mitigates Risks**: #12 (documentation debt), #2 (functionality loss - via better understanding)
- **Current Protocol Coverage**:
  - schema_documentation_verification.md (for schemas)
  - schema_documentation_standards.md (for schema documentation standards)
- **Status**: ⚠️ Additional protocol development needed for code documentation standards and architecture documentation

### 17. Dependency Management
- **Purpose**: Control third-party risk through version pinning, vulnerability scanning, update testing
- **Mitigates Risks**: #11 (dependency vulnerabilities), #5 (security)
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for dependency management standards, scanning tools, and update procedures

### 18. Data Validation Checks
- **Purpose**: Verify data integrity through constraints, checksums, reconciliation
- **Mitigates Risks**: #6 (data integrity), #1 (data loss - via early detection)
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for data validation standards and reconciliation procedures

### 19. Capacity Planning and Load Testing
- **Purpose**: Prevent performance degradation under load through capacity testing
- **Mitigates Risks**: #4 (performance - scale), #15 (downtime)
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for capacity planning standards and load testing requirements

### 20. Security Review for Sensitive Changes
- **Purpose**: Identify attack vectors through threat modeling and penetration testing
- **Mitigates Risks**: #5 (security vulnerabilities), #16 (access control), #17 (compliance)
- **Current Protocol Coverage**: None
- **Status**: ⚠️ Protocol development needed for security review standards and threat modeling procedures

## Existing Change Management Protocols

### schema_documentation_verification.md (Type B - Workflow)
- **Purpose**: Ensures schema documentation meets quality standards through independent verification
- **Covers**: Documentation quality control (Control #16 - partial)
- **Risks Mitigated**: #12 (documentation debt - for schemas)
- **When to Use**: When creating or modifying structured data schemas (SQL, JSON Schema, XML Schema, etc.)
- **File Location**: `~/.claude/protocols/schema_documentation_verification.md`

### risk_aware_change_management.md (Type B - Workflow)
- **Purpose**: Protects production data through risk assessment and proof-of-concept testing
- **Covers**:
  - Risk assessment (general framework)
  - POC testing (Control #2 - comprehensive)
  - Backup mention (Control #1 - partial)
  - Rollback verification (Control #13 - partial)
  - User approval (Control #14 - partial)
  - Environment parity mention (Control #9 - partial)
- **Risks Mitigated**:
  - #1 (data loss) - comprehensive coverage
  - #4 (performance - scale) - partial coverage via realistic test environments
  - #6 (data integrity) - partial coverage via POC testing
  - #8 (rollback) - partial coverage
- **When to Use**: When making high-risk changes to databases, schemas, files, or critical systems
- **File Location**: `~/.claude/protocols/risk_aware_change_management.md`

## Future Change Management Protocols

The following protocols represent anticipated needs based on the risk and control taxonomy. These are placeholders for future development as patterns emerge and priorities are established.

### technology_proof_of_concept.md
- **Purpose**: Evaluate new technologies or approaches before adoption
- **Would Cover**: POC testing for new tech (Control #2 variant)
- **Risks Would Mitigate**: #3 (performance), #5 (security), #11 (dependencies)
- **Priority**: Medium - useful for technology evaluation decisions

### code_documentation_standards.md
- **Purpose**: Define inline documentation requirements for code
- **Would Cover**: Code documentation (Control #16 expansion)
- **Risks Would Mitigate**: #12 (documentation debt)
- **Priority**: Medium - complements existing schema documentation standards

### performance_testing_standards.md
- **Purpose**: Define performance testing and benchmarking requirements
- **Would Cover**: Performance testing (Control #4), load testing (Control #19)
- **Risks Would Mitigate**: #3 (performance - code), #4 (performance - scale)
- **Priority**: Medium - important for production readiness

### security_review_standards.md
- **Purpose**: Define security review, scanning, and threat modeling requirements
- **Would Cover**: Security controls (Control #5, #20)
- **Risks Would Mitigate**: #5 (security), #16 (access control), #17 (compliance - partial)
- **Priority**: High - critical for security-sensitive changes

### deployment_verification_standards.md
- **Purpose**: Define deployment verification and health check requirements
- **Would Cover**: Post-deployment verification (Control #11)
- **Risks Would Mitigate**: #7 (deployment failure), #15 (downtime)
- **Priority**: Medium - important for reliable deployments

### regression_testing_standards.md
- **Purpose**: Define automated regression testing requirements
- **Would Cover**: Regression testing (Control #3)
- **Risks Would Mitigate**: #2 (functionality loss), #9 (API breaking changes)
- **Priority**: High - critical for preventing functionality regressions

### Additional Future Protocols
Additional protocols will be developed as patterns emerge based on:
- Risk priority for the specific project context
- Control effectiveness and implementation feasibility
- User needs and observed gaps during change management activities
- Integration requirements with existing protocols

## Integration Guidelines

Use these guidelines to determine which protocols apply to your specific change scenario.

### For Schema Changes

**Always apply:**
1. **schema_documentation_verification.md** - Ensure documentation quality for all schema changes

**Also apply if high-risk:**
2. **risk_aware_change_management.md** - When schema changes affect existing data or critical systems

**High-risk indicators for schema changes:**
- Existing production data in tables being modified
- Schema migrations that transform data
- Changes to primary keys, foreign keys, or critical constraints
- Operations that could cause data loss (DROP, ALTER with data conversion)

### For Code Changes

**Currently no specific protocols** - Future protocols will address code documentation and testing

**Consider applying:**
- **risk_aware_change_management.md** - If code changes affect production data or critical systems

**High-risk indicators for code changes:**
- Database queries that modify production data
- Performance-critical code paths
- Security-sensitive authentication/authorization code
- API contracts with external consumers

### For New Technology Evaluation

**Currently no specific protocol** - Future: technology_proof_of_concept.md

**Can adapt existing protocol:**
- **risk_aware_change_management.md** - POC workflow can be adapted for technology evaluation

**Evaluation criteria:**
- Performance characteristics under load
- Security implications and vulnerability landscape
- Integration complexity with existing systems
- Long-term maintenance and support considerations

### For Configuration Changes

**Currently no specific protocols** - Future development needed

**Consider applying:**
- **risk_aware_change_management.md** - For high-risk configuration changes

**High-risk indicators for configuration changes:**
- Production environment configuration
- Database connection strings and credentials
- Feature flags affecting critical functionality
- Resource limits and capacity settings

### For Deployment Planning

**Currently no specific protocols** - Future: deployment_verification_standards.md

**Consider applying:**
- **risk_aware_change_management.md** - For deployments with data migration or high risk

**High-risk indicators for deployments:**
- Schema migrations during deployment
- Zero-downtime requirements
- Multi-step deployments requiring coordination
- Deployments with rollback complexity

### General Decision Framework

**Use this decision tree:**

1. **Is there a schema change?**
   - Yes → Apply schema_documentation_verification.md
   - Then → Does schema change affect existing data? If yes, also apply risk_aware_change_management.md

2. **Is there potential for data loss or corruption?**
   - Yes → Apply risk_aware_change_management.md

3. **Is there potential for breaking existing functionality?**
   - Yes → Consider risk_aware_change_management.md (adapt POC workflow)
   - Future → Will use regression_testing_standards.md when available

4. **Are security implications significant?**
   - Yes → Manual security review required
   - Future → Will use security_review_standards.md when available

5. **When uncertain about risk level:**
   - **Always err on the side of caution** - use more protocols rather than fewer
   - **Consult with user** about risk assessment if unclear
   - **Default to production assumptions** unless explicitly told data is non-production

## Best Practices

### 1. Assume Production
Treat all data and systems as valuable unless explicitly told otherwise. Default to protection over convenience.

### 2. Independent Verification
Use separate agents or reviewers for validation to catch issues the implementer missed. Independent eyes provide quality gates.

### 3. Test Before Production
Always validate changes in isolated environments before applying to production. POC testing saves production systems.

### 4. Document Everything
Capture knowledge inline (comments, docs, runbooks) while context is fresh. Future maintainers depend on documentation.

### 5. Incremental Changes
Make small, reversible changes rather than large, risky ones. Small changes reduce blast radius and simplify debugging.

### 6. User Approval for Risk
Always get explicit user approval before high-risk operations. Users own the risk decisions for their data.

### 7. Automate When Possible
Reduce manual errors through automation, but maintain human oversight for critical decisions. Automation increases consistency.

### 8. Monitor and Alert
Instrument changes to enable detection and diagnosis of issues. Observability enables rapid response.

### 9. Plan for Rollback
Ensure reversibility before proceeding with changes. Rollback capability is a safety net for production changes.

### 10. Learn and Improve
Update protocols based on lessons learned from incidents and near-misses. Protocol evolution improves future outcomes.

## Change Log
- **2025-10-24** - Initial creation as umbrella protocol (Claude - Protocol Architect)
