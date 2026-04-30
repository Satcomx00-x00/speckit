# Data Model: [FEATURE_NAME]

**Feature**: [NNN-kebab-case-name]  
**Date**: [YYYY-MM-DD]  
**Spec**: [specs/NNN-feature/spec.md](./spec.md)

---

## Entities

### [EntityName]

**Description**: [What this entity represents in the domain.]

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string (UUID)` | ✅ | Primary key |
| `[field]` | `[type]` | ✅ | [Description] |
| `[field]` | `[type]` | ❌ | [Description — nullable] |
| `createdAt` | `timestamp` | ✅ | Record creation time (UTC) |
| `updatedAt` | `timestamp` | ✅ | Last modification time (UTC) |

**PII Fields**: `[field1]`, `[field2]` _(handled per Article IX of constitution)_

**Indexes**:
- Primary: `id`
- Unique: `[field]`
- Index: `[field]` _(for query performance)_

---

### [EntityName2]

**Description**: [What this entity represents.]

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string (UUID)` | ✅ | Primary key |
| `[foreignKeyField]` | `string (UUID)` | ✅ | FK → [EntityName].id |
| `[field]` | `[type]` | ✅ | [Description] |
| `createdAt` | `timestamp` | ✅ | Record creation time (UTC) |

**PII Fields**: _None_

**Indexes**:
- Primary: `id`
- FK Index: `[foreignKeyField]`

---

## Relationships

```
[EntityName] ──< [EntityName2]
    one-to-many: one [EntityName] has many [EntityName2]s

[EntityName] >──< [EntityName3]
    many-to-many via [JunctionTable]
```

| From | To | Type | Description |
|------|----|------|-------------|
| [EntityName] | [EntityName2] | one-to-many | [Describe the relationship] |
| [EntityName] | [EntityName3] | many-to-many | [Describe the relationship] |

---

## Constraints

| Constraint | Entity | Rule |
|------------|--------|------|
| Unique | [EntityName] | `[field]` must be unique per `[scope]` |
| Non-null | [EntityName] | `[field]` cannot be null |
| Range | [EntityName] | `[field]` must be between [min] and [max] |
| Referential integrity | [EntityName2] | `[foreignKeyField]` must reference a valid [EntityName] |
| Cascade delete | [EntityName2] | Deleted when parent [EntityName] is deleted |

---

## Storage Notes

| Property | Value |
|----------|-------|
| Storage engine | [e.g., SQLite / PostgreSQL / DynamoDB / in-memory] |
| Schema location | [e.g., db/schema.sql / prisma/schema.prisma] |
| Migration tool | [e.g., Flyway / Alembic / Prisma Migrate / manual] |

---

## Migration Notes

> Steps required to apply this data model to an existing system.

### New Installation
1. Run `[migration command]` to create all tables
2. Seed initial data with `[seed command]` (if applicable)

### Upgrading from [Previous Version]
1. [Step 1 — e.g., add column X to table Y]
2. [Step 2 — e.g., backfill column X from column Z]
3. [Step 3 — e.g., drop old column Z]

**Breaking changes**: [Yes/No — describe if yes]

**Rollback**: [Describe rollback procedure]
