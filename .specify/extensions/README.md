# Extensions

Extensions add new slash commands or behaviors to speckit without modifying the core files.

## What is an extension?

An extension is a markdown file placed in `.specify/extensions/` that defines a custom slash command for your project. Extensions are picked up automatically by AI agents that read the `.specify/` directory.

## Creating an extension

### 1. Create the command file

```
.specify/extensions/my-command.md
```

### 2. Structure your command

```markdown
# /speckit.my-command

## Description
[What this command does]

## Prerequisites
- [Files to read before running]

## Your task
[Step-by-step instructions for the AI agent]

## Output
[What the agent should produce]

User input: $ARGUMENTS
```

### 3. Register with agent instructions

For **GitHub Copilot**, copy your command to:
```
.github/copilot-instructions.d/speckit.my-command.md
```

For **Claude Code**, copy your command to:
```
.claude/commands/speckit.my-command.md
```
with a frontmatter header:
```yaml
---
description: "What this command does"
---
```

## Extension examples

### `speckit.diagram` — Generate architecture diagrams

Creates Mermaid diagrams from the plan and data model documents.

### `speckit.review` — Spec quality review

Reviews a spec for completeness before planning starts.

### `speckit.release` — Release checklist

Runs all checklist items and prepares a release summary.

## Best practices

- Extensions should read existing spec files rather than requiring user input for context
- Extensions should produce files in `specs/NNN-feature/` to keep everything discoverable
- Use `$ARGUMENTS` for optional user overrides, not required inputs
- Extensions that produce code should follow the same TDD principles as built-in commands
