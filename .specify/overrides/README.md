# Overrides

Overrides let you replace default speckit templates and command definitions with project-specific versions, without modifying the core files (which may be updated).

## How overrides work

When speckit commands run, they look for files in this order:

1. `.specify/overrides/<filename>` — **your override** (wins if present)
2. `.specify/templates/<filename>` — built-in template (fallback)

This means you can customize any template by placing a file with the same name in `.specify/overrides/`.

## What you can override

| File | Override path | Purpose |
|------|---------------|---------|
| `spec-template.md` | `.specify/overrides/spec-template.md` | Custom spec structure |
| `plan-template.md` | `.specify/overrides/plan-template.md` | Custom plan structure |
| `tasks-template.md` | `.specify/overrides/tasks-template.md` | Custom task format |
| `research-template.md` | `.specify/overrides/research-template.md` | Custom research format |
| `data-model-template.md` | `.specify/overrides/data-model-template.md` | Custom data model format |
| `constitution.md` | `.specify/memory/constitution.md` | Your live project constitution |

## Example: Override the spec template

If your team uses a different format for acceptance criteria:

```bash
cp .specify/templates/spec-template.md .specify/overrides/spec-template.md
# Edit .specify/overrides/spec-template.md to your liking
```

Now `/speckit.specify` will use your version instead of the default.

## Override vs. Extension

| | Override | Extension |
|-|----------|-----------|
| Replaces existing behavior | ✅ | ❌ |
| Adds new commands | ❌ | ✅ |
| Requires changing agent files | ❌ | ✅ (copy to `.github/` or `.claude/`) |
| Risk of conflict on update | Low (isolated) | None |

## Keeping overrides in sync

When speckit releases a new version of a template, your override won't auto-update. Review the changelog and apply relevant improvements manually.
