---
description: "Resolve all [NEEDS CLARIFICATION] markers in the current feature spec by asking targeted questions and updating the spec with the answers."
---

You are resolving ambiguities in a feature specification before planning begins.

## Prerequisites
- Identify the feature: use `$ARGUMENTS` if provided (feature name or number), otherwise auto-detect from the most recently modified `specs/NNN-*/spec.md`
- Read the identified `specs/NNN-feature/spec.md`
- Read `.specify/memory/constitution.md`

## Your task

### Step 1: Find all ambiguities
Search `specs/NNN-feature/spec.md` for every instance of:
- `[NEEDS CLARIFICATION: ...]`
- `[ASSUMPTION: ...]` (assumptions that have not been validated)
- Requirements that are vague or unmeasurable (e.g., "should be fast", "easy to use")
- Edge cases listed as "TBD" or "unknown"

### Step 2: Present questions
For each ambiguity found, present a targeted, specific question:
- Quote the ambiguous text
- Ask the minimum question needed to resolve it
- Provide 2–3 example answers to make it easy to respond

Example format:
```
**Q1** (FR-004): The spec says "[NEEDS CLARIFICATION: Is email verification required?]"
→ Is email verification required at signup?
  a) Yes — send a verification email before allowing login
  b) No — users can log in immediately after registration
  c) Optional — allow login but show a "please verify" banner
```

### Step 3: Wait for answers
Do not proceed past this point until the user has answered the questions.

### Step 4: Update the spec
For each answer received:
1. Replace the `[NEEDS CLARIFICATION: ...]` marker with the concrete requirement
2. Convert `[ASSUMPTION: ...]` to a confirmed statement or a clarified requirement
3. Update any affected FR-* rows in the Functional Requirements table
4. Update Success Criteria if the answer changes measurable outcomes

### Step 5: Validate
Re-read the updated spec and confirm:
- No `[NEEDS CLARIFICATION]` markers remain
- No `[ASSUMPTION]` markers remain
- All requirements are specific and testable

## Output
- **Before answers**: Numbered list of questions
- **After answers**:
  - Confirmation that spec.md was updated
  - Summary of changes made (one line per resolution)
  - Confirmation: "✅ Spec is clarification-free and ready for planning"
  - Next command: `/speckit:plan`

Feature: $ARGUMENTS (or auto-detect from most recent spec)
