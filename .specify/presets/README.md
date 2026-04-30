# Presets

Presets are pre-configured speckit setups for common project types. Instead of filling in every template from scratch, a preset gives you an opinionated starting point.

## Available presets

| Preset | Description |
|--------|-------------|
| `rest-api` | Node.js/TypeScript REST API with Express, Jest, SQLite |
| `cli-tool` | Single-binary CLI tool with argument parsing and test suite |
| `python-service` | Python FastAPI service with pytest and SQLAlchemy |
| `go-service` | Go HTTP service with standard library and testify |
| `react-app` | React + TypeScript frontend with Vitest and Testing Library |

## Using a preset

Run the init script with the `--preset` flag:

```bash
bash scripts/init.sh --preset rest-api
```

Or in PowerShell:

```powershell
.\scripts\init.ps1 -Preset rest-api
```

The preset will:
1. Pre-fill the constitution with stack-specific rules
2. Set the Technical Context defaults in `plan-template.md`
3. Configure the test framework references in `tasks-template.md`

## Creating a preset

A preset is a directory under `.specify/presets/` with overrides for the default templates.

### Structure

```
.specify/presets/my-preset/
├── preset.json          # Metadata and variable values
├── constitution.md      # Constitution with preset-specific rules filled in
└── plan-template.md     # Plan template with Technical Context pre-filled
```

### `preset.json`

```json
{
  "name": "my-preset",
  "description": "Description of what this preset targets",
  "variables": {
    "LANGUAGE": "TypeScript 5.4",
    "TEST_FRAMEWORK": "Jest",
    "STORAGE": "PostgreSQL"
  }
}
```

The init script reads `preset.json` and substitutes `[PLACEHOLDER]` values in templates.

## Contributing presets

Presets live in `.specify/presets/` and are committed to the repository. Open a pull request to add a new preset.
