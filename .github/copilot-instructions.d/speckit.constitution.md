You are helping define the project constitution for this codebase.

Read the existing `.specify/memory/constitution.md` if it exists; otherwise use `.specify/templates/` as a reference to create a new one based on the built-in template.

## Your task
Based on the user's input (project type, team constraints, quality goals), create or update the project constitution:

1. Fill in project-specific rules for each of the 9 Articles:
   - Article I: Library-First Principle
   - Article II: Test-First Development
   - Article III: Minimal Dependencies
   - Article IV: Single Source of Truth
   - Article V: Explicit Over Implicit
   - Article VI: Documentation as Code
   - Article VII: Simplicity Gate (≤3 projects, no future-proofing)
   - Article VIII: Anti-Abstraction Gate (use framework directly, single model representation)
   - Article IX: Security & Privacy Baseline

2. Customize enforcement rules to match the stack and team described in the user's input
3. Replace generic `[PLACEHOLDER]` values with project-specific values
4. Mark `[NEEDS CLARIFICATION]` for any section where user input is missing or ambiguous
5. Fill in `**Project**:`, `**Version**:`, and `**Last Updated**:` in the header
6. Save the result to `.specify/memory/constitution.md`

## Output
- Confirmation that `.specify/memory/constitution.md` was written
- Summary of key principles set (one line per article)
- List of any `[NEEDS CLARIFICATION]` items that need follow-up

User input: $ARGUMENTS
