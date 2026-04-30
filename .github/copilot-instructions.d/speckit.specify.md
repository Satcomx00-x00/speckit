You are creating a feature specification for this project.

## Prerequisites
- Read `.specify/memory/constitution.md` for project principles
- Read `.specify/templates/spec-template.md` for the template structure (or `.specify/overrides/spec-template.md` if it exists)
- Scan `specs/` to determine the next feature number (NNN, e.g., 001, 002...)

## Your task
Transform the user's description into a complete, structured specification:

1. **Determine feature number**: Count existing spec directories in `specs/` and use the next number (zero-padded to 3 digits: 001, 002, etc.)
2. **Generate branch name**: Create a semantic branch name `NNN-<kebab-case-description>` (max 40 chars, lowercase, hyphens only)
3. **Create directory**: `specs/NNN-feature-name/`
4. **Generate spec.md**: Using the template from `.specify/templates/spec-template.md`, filling in:
   - Header with feature name, branch name, today's date, status `DRAFT`
   - User stories with P1/P2/P3 priorities (each independently testable)
   - Given/When/Then acceptance scenarios for each story
   - Edge cases table
   - Functional Requirements (FR-001, FR-002, ...)
   - Key Entities section
   - Success Criteria (SC-001, SC-002, ...)
   - Assumptions and Out of Scope sections
   - Mark ambiguities as `[NEEDS CLARIFICATION: specific question]`
5. **Save**: Write to `specs/NNN-feature-name/spec.md`

## Rules
- ✅ Focus on WHAT users need and WHY (requirements, not solutions)
- ✅ Each user story must be independently testable without other stories
- ✅ Success criteria must be measurable (no vague "works well" language)
- ❌ Avoid HOW to implement — no tech stack, APIs, code structure, or database schemas
- ❌ Never guess about requirements — mark unclear items as `[NEEDS CLARIFICATION: specific question]`

## Output
- Confirmation that `specs/NNN-feature-name/spec.md` was written
- Branch name to create: `git checkout -b NNN-feature-name`
- Count of `[NEEDS CLARIFICATION]` items found (if any)
- Recommended next command: `/speckit.clarify` (if clarifications needed) or `/speckit.plan`

User description: $ARGUMENTS
