#!/usr/bin/env bash
# init.sh — Bootstrap speckit in a new project
# Usage: bash scripts/init.sh [--integration copilot|claude|all] [--preset PRESET_NAME]
set -euo pipefail

# ── Color output ──────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { echo -e "${CYAN}ℹ ${RESET}$*"; }
success() { echo -e "${GREEN}✅ ${RESET}$*"; }
warn()    { echo -e "${YELLOW}⚠️  ${RESET}$*"; }
error()   { echo -e "${RED}❌ ${RESET}$*" >&2; }
header()  { echo -e "\n${BOLD}$*${RESET}"; }

# ── Argument parsing ──────────────────────────────────────────────────────────
INTEGRATION="all"
PRESET=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --integration)
      INTEGRATION="$2"
      shift 2
      ;;
    --preset)
      PRESET="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: bash scripts/init.sh [--integration copilot|claude|all] [--preset PRESET_NAME]"
      echo ""
      echo "Options:"
      echo "  --integration   Which AI agent to configure (default: all)"
      echo "  --preset        Apply a preconfigured project template"
      echo "  -h, --help      Show this help message"
      exit 0
      ;;
    *)
      error "Unknown argument: $1"
      exit 1
      ;;
  esac
done

# ── Detect project root ───────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# If running from inside speckit itself, target cwd
if [[ "$PROJECT_ROOT" == *"/speckit" ]] && [[ ! -f "$PROJECT_ROOT/scripts/init.sh" ]]; then
  PROJECT_ROOT="$(pwd)"
fi

# Allow override
TARGET_DIR="${SPECKIT_TARGET:-$(pwd)}"

header "🚀 Speckit Init"
echo "Target directory: $TARGET_DIR"
echo ""

# ── Gather project info ───────────────────────────────────────────────────────
if [[ -t 0 ]]; then
  # Interactive mode
  read -rp "Project name: " PROJECT_NAME
  read -rp "Project type (e.g., REST API, CLI tool, Web App, Library): " PROJECT_TYPE
  read -rp "Primary language/stack (e.g., TypeScript/Node.js, Python, Go): " STACK
  read -rp "Team size (e.g., solo, 2-5, 10+): " TEAM_SIZE
else
  # Non-interactive mode — use defaults
  PROJECT_NAME="$(basename "$TARGET_DIR")"
  PROJECT_TYPE="[NEEDS CLARIFICATION: specify project type]"
  STACK="[NEEDS CLARIFICATION: specify language and stack]"
  TEAM_SIZE="[NEEDS CLARIFICATION: specify team size]"
  warn "Non-interactive mode: using defaults. Edit .specify/memory/constitution.md to fill in project details."
fi

DATE="$(date +%Y-%m-%d)"

# ── Create directory structure ────────────────────────────────────────────────
header "📁 Creating directory structure..."

mkdir -p \
  "$TARGET_DIR/.specify/memory" \
  "$TARGET_DIR/.specify/templates" \
  "$TARGET_DIR/.specify/extensions" \
  "$TARGET_DIR/.specify/presets" \
  "$TARGET_DIR/.specify/overrides" \
  "$TARGET_DIR/.specify/scripts" \
  "$TARGET_DIR/specs"

success "Directory structure created"

# ── Find speckit source templates ─────────────────────────────────────────────
SPECKIT_SOURCE=""

# Look for speckit templates in common locations
for candidate in \
  "$SCRIPT_DIR/../.specify/templates" \
  "$HOME/.speckit/.specify/templates" \
  "/usr/local/share/speckit/.specify/templates"
do
  if [[ -d "$candidate" ]]; then
    SPECKIT_SOURCE="$(dirname "$candidate")"
    break
  fi
done

# ── Copy templates ────────────────────────────────────────────────────────────
if [[ -n "$SPECKIT_SOURCE" ]] && [[ "$SPECKIT_SOURCE/.specify/templates" != "$TARGET_DIR/.specify/templates" ]]; then
  header "📋 Copying templates..."
  cp -n "$SPECKIT_SOURCE/templates/"*.md "$TARGET_DIR/.specify/templates/" 2>/dev/null || true
  cp -n "$SPECKIT_SOURCE/scripts/update-context.sh" "$TARGET_DIR/.specify/scripts/" 2>/dev/null || true
  cp -n "$SPECKIT_SOURCE/scripts/update-context.ps1" "$TARGET_DIR/.specify/scripts/" 2>/dev/null || true
  chmod +x "$TARGET_DIR/.specify/scripts/update-context.sh" 2>/dev/null || true
  success "Templates copied"
else
  warn "Could not find speckit source templates. You may need to copy them manually."
  warn "Expected templates at: .specify/templates/"
fi

# ── Create constitution ───────────────────────────────────────────────────────
header "📜 Creating project constitution..."

CONSTITUTION_FILE="$TARGET_DIR/.specify/memory/constitution.md"

if [[ -f "$CONSTITUTION_FILE" ]]; then
  warn "Constitution already exists at $CONSTITUTION_FILE — skipping"
else
  cat > "$CONSTITUTION_FILE" << EOF
# Project Constitution

**Project**: $PROJECT_NAME
**Version**: 1.0
**Last Updated**: $DATE
**Status**: DRAFT

---

## Preamble

This constitution defines the non-negotiable principles governing all development decisions for $PROJECT_NAME ($PROJECT_TYPE, $STACK). Every contributor — human or AI — must read and follow these principles.

---

## Article I: Library-First Principle

**Principle**: Prefer well-maintained libraries over custom implementations.

**Enforcement Rules**:
- Before writing any utility, search for an existing library that does it
- Custom implementations require a written justification in the relevant research.md
- [NEEDS CLARIFICATION: List approved package registries for $STACK]

---

## Article II: Test-First Development

**Principle**: Tests are written before implementation code. No exceptions.

**Enforcement Rules**:
- Every feature task list (tasks.md) orders test tasks before implementation tasks
- A PR that adds implementation without a test is rejected
- [NEEDS CLARIFICATION: Which test framework does $STACK use?]

---

## Article III: Minimal Dependencies

**Principle**: Every dependency is a liability. Add only what is necessary.

**Enforcement Rules**:
- New dependencies require team approval (open a discussion first)
- Run dependency audit on every PR
- [NEEDS CLARIFICATION: Maximum allowed production dependencies?]

---

## Article IV: Single Source of Truth

**Principle**: Every piece of data or logic lives in exactly one place.

**Enforcement Rules**:
- No copy-pasted code blocks larger than 5 lines
- Configuration lives in one place (environment variables or single config file)

---

## Article V: Explicit Over Implicit

**Principle**: Prefer explicit, readable code over clever, implicit code.

**Enforcement Rules**:
- No global mutable state
- Type annotations required where supported by $STACK
- Named constants over magic strings/numbers

---

## Article VI: Documentation as Code

**Principle**: Documentation lives in the repository, versioned alongside code.

**Enforcement Rules**:
- Every public API must have inline documentation
- Architectural decisions are recorded in specs/NNN/plan.md
- README must be updated with every user-facing change

---

## Article VII: Simplicity Gate

**Principle**: Maximum 3 projects/services. No future-proofing code.

**Enforcement Rules**:
- A feature may not require more than 3 distinct services
- No code for requirements not in the current spec
- Interfaces require ≥2 concrete implementations at creation time

---

## Article VIII: Anti-Abstraction Gate

**Principle**: Use frameworks directly. One model represents one entity.

**Enforcement Rules**:
- Do not wrap framework primitives
- Each entity has one canonical model representation
- [NEEDS CLARIFICATION: What is the canonical data layer for $STACK?]

---

## Article IX: Security & Privacy Baseline

**Principle**: Security and privacy are never deferred.

**Enforcement Rules**:
- No secrets in source code — ever
- All user-facing input validated and sanitized
- PII enumerated in data-model.md
- HIGH/CRITICAL dependency vulnerabilities block merging
- [NEEDS CLARIFICATION: What compliance framework applies? (GDPR/CCPA/HIPAA/none)]

---

## Amendments

| Version | Date | Change | Author |
|---------|------|--------|--------|
| 1.0 | $DATE | Initial constitution | speckit init |
EOF

  success "Constitution created at $CONSTITUTION_FILE"
fi

# ── Configure AI agent integrations ──────────────────────────────────────────
if [[ "$INTEGRATION" == "copilot" ]] || [[ "$INTEGRATION" == "all" ]]; then
  header "🤖 Configuring GitHub Copilot integration..."
  mkdir -p "$TARGET_DIR/.github/copilot-instructions.d"
  
  if [[ -n "$SPECKIT_SOURCE" ]]; then
    COPILOT_SRC="$(dirname "$SPECKIT_SOURCE")/.github/copilot-instructions.d"
    if [[ -d "$COPILOT_SRC" ]]; then
      cp -n "$COPILOT_SRC/"*.md "$TARGET_DIR/.github/copilot-instructions.d/" 2>/dev/null || true
      success "Copilot slash commands installed in .github/copilot-instructions.d/"
    else
      warn "Copilot command files not found at $COPILOT_SRC"
    fi
  else
    warn "Could not copy Copilot commands — source not found"
  fi
fi

if [[ "$INTEGRATION" == "claude" ]] || [[ "$INTEGRATION" == "all" ]]; then
  header "🤖 Configuring Claude Code integration..."
  mkdir -p "$TARGET_DIR/.claude/commands"
  
  if [[ -n "$SPECKIT_SOURCE" ]]; then
    CLAUDE_SRC="$(dirname "$SPECKIT_SOURCE")/.claude/commands"
    if [[ -d "$CLAUDE_SRC" ]]; then
      cp -n "$CLAUDE_SRC/"*.md "$TARGET_DIR/.claude/commands/" 2>/dev/null || true
      success "Claude slash commands installed in .claude/commands/"
    else
      warn "Claude command files not found at $CLAUDE_SRC"
    fi
  else
    warn "Could not copy Claude commands — source not found"
  fi
fi

# ── Initialize specs directory ────────────────────────────────────────────────
header "📂 Initializing specs directory..."

if [[ ! -f "$TARGET_DIR/specs/.gitkeep" ]] && [[ -z "$(ls -A "$TARGET_DIR/specs" 2>/dev/null)" ]]; then
  touch "$TARGET_DIR/specs/.gitkeep"
  success "specs/ directory initialized"
else
  success "specs/ directory already exists"
fi

# ── Print next steps ──────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${GREEN}${BOLD}✅ Speckit initialized for $PROJECT_NAME${RESET}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo "Next steps:"
echo ""
echo "  1. Review and complete your constitution:"
echo "     ${CYAN}$CONSTITUTION_FILE${RESET}"
echo ""
echo "  2. Define your first feature spec:"
if [[ "$INTEGRATION" == "claude" ]]; then
  echo "     ${CYAN}/speckit:specify Add user authentication${RESET}"
else
  echo "     ${CYAN}/speckit.specify Add user authentication${RESET}"
fi
echo ""
echo "  3. Run the full workflow:"
if [[ "$INTEGRATION" == "claude" ]]; then
  echo "     ${CYAN}/speckit:specify → /speckit:clarify → /speckit:plan → /speckit:tasks → /speckit:implement${RESET}"
else
  echo "     ${CYAN}/speckit.specify → /speckit.clarify → /speckit.plan → /speckit.tasks → /speckit.implement${RESET}"
fi
echo ""
echo "  4. Keep AI context updated:"
echo "     ${CYAN}bash .specify/scripts/update-context.sh${RESET}"
echo ""
echo "  Docs: see ${CYAN}specs/000-example/${RESET} for a filled-in example"
echo ""
