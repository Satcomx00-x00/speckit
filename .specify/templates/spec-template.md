# Feature Specification: [FEATURE_NAME]

**Branch**: `[NNN-kebab-case-name]`  
**Date**: [YYYY-MM-DD]  
**Status**: `DRAFT` | `REVIEW` | `APPROVED` | `IN PROGRESS` | `DONE`  
**Input**: $ARGUMENTS

---

## User Scenarios & Testing

> Each scenario is independently testable. Priorities: P1 = must-have, P2 = should-have, P3 = nice-to-have.

### [US1] [P1] [Short User Story Title]

**Story**: As a [user type], I want [goal] so that [benefit].

**Scenario 1: [Happy path name]**
- **Given** [initial context / preconditions]
- **When** [action the user takes]
- **Then** [expected outcome]

**Scenario 2: [Error or edge case name]**
- **Given** [initial context]
- **When** [action]
- **Then** [expected outcome]

**Independent Test**: [Describe how to test this story in isolation, without needing other stories to be complete]

---

### [US2] [P1] [Short User Story Title]

**Story**: As a [user type], I want [goal] so that [benefit].

**Scenario 1: [Happy path name]**
- **Given** [initial context]
- **When** [action]
- **Then** [expected outcome]

**Independent Test**: [Describe how to test this story in isolation]

---

### [US3] [P2] [Short User Story Title]

**Story**: As a [user type], I want [goal] so that [benefit].

**Scenario 1: [Happy path name]**
- **Given** [initial context]
- **When** [action]
- **Then** [expected outcome]

**Independent Test**: [Describe how to test this story in isolation]

---

### [US4] [P3] [Short User Story Title]

**Story**: As a [user type], I want [goal] so that [benefit].

**Scenario 1: [Happy path name]**
- **Given** [initial context]
- **When** [action]
- **Then** [expected outcome]

**Independent Test**: [Describe how to test this story in isolation]

---

## Edge Cases

| ID | Edge Case | Expected Behavior |
|----|-----------|-------------------|
| EC-001 | [Description of edge condition] | [What the system should do] |
| EC-002 | [Description of edge condition] | [What the system should do] |
| EC-003 | [Description of edge condition] | [What the system should do] |

---

## Functional Requirements

> Requirements map directly to user stories. Mark gaps with `[NEEDS CLARIFICATION: specific question]`.

| ID | Requirement | User Story | Priority |
|----|-------------|------------|----------|
| FR-001 | [Specific, testable requirement statement] | US1 | P1 |
| FR-002 | [Specific, testable requirement statement] | US1 | P1 |
| FR-003 | [Specific, testable requirement statement] | US2 | P1 |
| FR-004 | [NEEDS CLARIFICATION: Is [specific behavior] required?] | US2 | P1 |
| FR-005 | [Specific, testable requirement statement] | US3 | P2 |
| FR-006 | [Specific, testable requirement statement] | US4 | P3 |

---

## Key Entities

> Data entities this feature introduces or modifies. Do NOT specify implementation details.

| Entity | Description | New or Modified |
|--------|-------------|-----------------|
| [EntityName] | [What it represents] | New |
| [EntityName] | [What it represents] | Modified |

---

## Success Criteria

> Measurable outcomes that define "done". These become acceptance tests.

| ID | Criterion | Measurement |
|----|-----------|-------------|
| SC-001 | [Specific, measurable outcome] | [How to verify] |
| SC-002 | [Specific, measurable outcome] | [How to verify] |
| SC-003 | [Specific, measurable outcome] | [How to verify] |
| SC-004 | [Performance/scale requirement] | [Measurement method] |

---

## Assumptions

> Assumptions made while writing this spec. Each must be validated before implementation begins.

1. [ASSUMPTION: Describe what is being assumed and why]
2. [ASSUMPTION: Describe what is being assumed and why]
3. [NEEDS CLARIFICATION: Open question that blocks progress if left unresolved]

---

## Out of Scope

> Explicitly list what this feature does NOT cover to prevent scope creep.

- [Feature or behavior intentionally excluded]
- [Feature or behavior intentionally excluded]
- [Future work that belongs in a separate spec]
