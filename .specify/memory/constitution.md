# Project Constitution
<!-- Fill this in for your project. Replace [PLACEHOLDER] values throughout. -->

**Project**: [PROJECT_NAME]  
**Version**: 1.0  
**Last Updated**: [DATE]  
**Status**: [DRAFT | ACTIVE]

---

## Preamble

This constitution defines the non-negotiable principles governing all development decisions for [PROJECT_NAME]. Every contributor — human or AI — must read and follow these principles. When in doubt, this document is the final arbiter.

---

## Article I: Library-First Principle

**Principle**: Prefer well-maintained libraries over custom implementations.

**Rationale**: Reinventing solved problems wastes time, introduces bugs, and creates maintenance burden. Established libraries carry years of battle-testing and community scrutiny.

**Enforcement Rules**:
- Before writing any utility, search for an existing library that does it
- A library must have >1,000 stars or be an official SDK to qualify as "well-maintained"
- Custom implementations require a written justification in the relevant `research.md`
- [NEEDS CLARIFICATION: List approved libraries or package registries for this project]

---

## Article II: Test-First Development

**Principle**: Tests are written before implementation code. No exceptions.

**Rationale**: Writing tests first forces clarity about requirements, prevents scope creep, and ensures every line of production code has a reason to exist.

**Enforcement Rules**:
- Every feature task list (tasks.md) must order test tasks before implementation tasks
- A pull request that adds implementation without a corresponding test is rejected
- Tests must fail before the implementation is written (verified via CI)
- Minimum coverage threshold: [NEEDS CLARIFICATION: e.g., 80%]
- Test framework: [NEEDS CLARIFICATION: e.g., Jest, pytest, go test]

---

## Article III: Minimal Dependencies

**Principle**: Every dependency is a liability. Add only what is necessary.

**Rationale**: Dependencies introduce security vulnerabilities, upgrade friction, and unexpected breaking changes. The fewer dependencies, the simpler and more secure the system.

**Enforcement Rules**:
- New dependencies require team approval (open a discussion before adding)
- Peer dependencies do not count; only direct production dependencies
- Dev dependencies have a higher tolerance but should still be justified
- Run `npm audit` / `pip-audit` / equivalent on every PR
- Dependency count ceiling: [NEEDS CLARIFICATION: e.g., max 20 prod deps]

---

## Article IV: Single Source of Truth

**Principle**: Every piece of data or logic lives in exactly one place.

**Rationale**: Duplication causes drift. When the same data or logic exists in two places, they will eventually diverge.

**Enforcement Rules**:
- No copy-pasted code blocks larger than 5 lines; extract to a shared module
- Database schema is the source of truth for data shapes; types/interfaces are generated from it
- Configuration lives in one place (environment variables or a single config file)
- API contracts defined in `specs/NNN/contracts/` are the source of truth; code adapts to them
- [NEEDS CLARIFICATION: Where does canonical configuration live in this project?]

---

## Article V: Explicit Over Implicit

**Principle**: Prefer explicit, readable code over clever, implicit code.

**Rationale**: Code is read far more than it is written. Implicit magic — metaclasses, dynamic dispatch, global state — may save keystrokes but costs comprehension.

**Enforcement Rules**:
- No global mutable state
- Function signatures must show all inputs/outputs (no hidden side-effects without documentation)
- Type annotations are required in [NEEDS CLARIFICATION: language/strict mode]
- Magic strings/numbers must be named constants
- Prefer verbose, descriptive variable names over abbreviations

---

## Article VI: Documentation as Code

**Principle**: Documentation lives in the repository and is versioned alongside code.

**Rationale**: External wikis rot. Documentation that cannot be reviewed in a pull request will not be reviewed at all.

**Enforcement Rules**:
- Every public API must have inline documentation (JSDoc, docstrings, etc.)
- Architectural decisions are recorded in `specs/NNN/plan.md`
- The `specs/` directory is the single source of truth for feature decisions
- README must be updated with every user-facing change
- [NEEDS CLARIFICATION: Is an ADR (Architecture Decision Record) process required?]

---

## Article VII: Simplicity Gate

**Principle**: If a design requires more than 3 projects/services or adds future-proofing code, it must be rejected and redesigned.

**Rationale**: Complexity is the enemy of reliability. Systems with more moving parts fail in more ways. Code written for hypothetical future requirements is dead weight today.

**Enforcement Rules**:
- **≤3 Projects/Services**: A feature may not require standing up more than 3 distinct services. Violating this requires architecture review.
- **No Future-Proofing**: No code for requirements that aren't in the current spec. Mark such ideas as `[OUT OF SCOPE]` in the spec.
- **No Speculative Abstractions**: Interfaces, base classes, and plugin systems must have ≥2 concrete implementations at creation time. A "we might need this later" abstraction is not allowed.
- Gate check is documented in `plan.md` under "Constitution Check"

---

## Article VIII: Anti-Abstraction Gate

**Principle**: Use frameworks and languages directly. One model represents one entity.

**Rationale**: Abstractions over abstractions create indirection that slows onboarding and debugging. Most projects don't need a "framework on top of a framework."

**Enforcement Rules**:
- **Use Framework Directly**: Do not wrap framework primitives (e.g., no `MyRouter` wrapping `express.Router`). Use them as documented.
- **Single Model Representation**: An entity (e.g., `User`) has one canonical model/schema. It is not re-represented as a DTO, a view model, and a database model unless each representation serves a distinct, documented boundary.
- ORM/database layer models are the canonical data shape; mapping layers require written justification
- [NEEDS CLARIFICATION: What is the canonical data layer for this project?]

---

## Article IX: Security & Privacy Baseline

**Principle**: Security and privacy are not features — they are requirements. They are never deferred.

**Rationale**: Retrofitting security is far more expensive than building it in. Data breaches and privacy violations have legal, financial, and reputational consequences.

**Enforcement Rules**:
- No secrets (API keys, passwords, tokens) in source code — ever. Use environment variables.
- All user-facing input must be validated and sanitized before use
- Authentication and authorization must be implemented in the spec before any user-data endpoint goes live
- PII (Personally Identifiable Information) is enumerated in `specs/NNN/data-model.md` and handled per [NEEDS CLARIFICATION: privacy regulation — e.g., GDPR, CCPA, HIPAA]
- Dependency vulnerabilities flagged as HIGH or CRITICAL block merging
- [NEEDS CLARIFICATION: What compliance framework applies to this project?]

---

## Amendments

| Version | Date | Change | Author |
|---------|------|--------|--------|
| 1.0     | [DATE] | Initial constitution | [AUTHOR] |

---

*This constitution is enforced by code review, CI gates, and AI agent instructions. Violations must be documented with justification or the code is not merged.*
