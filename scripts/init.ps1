# init.ps1 — Bootstrap speckit in a new project
# Usage: .\scripts\init.ps1 [-Integration copilot|claude|all] [-Preset PRESET_NAME]
param(
    [ValidateSet("copilot", "claude", "all")]
    [string]$Integration = "all",

    [string]$Preset = "",

    [switch]$Help
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── Helper functions ──────────────────────────────────────────────────────────
function Write-Info    { param($msg) Write-Host "ℹ  $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "✅ $msg" -ForegroundColor Green }
function Write-Warn    { param($msg) Write-Host "⚠️  $msg" -ForegroundColor Yellow }
function Write-Err     { param($msg) Write-Host "❌ $msg" -ForegroundColor Red }
function Write-Header  { param($msg) Write-Host "`n$msg" -ForegroundColor White }

if ($Help) {
    Write-Host "Usage: .\scripts\init.ps1 [-Integration copilot|claude|all] [-Preset PRESET_NAME]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -Integration   Which AI agent to configure (default: all)"
    Write-Host "  -Preset        Apply a preconfigured project template"
    Write-Host "  -Help          Show this help message"
    exit 0
}

# ── Detect target directory ───────────────────────────────────────────────────
$TargetDir = if ($env:SPECKIT_TARGET) { $env:SPECKIT_TARGET } else { (Get-Location).Path }
$ScriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent
$Date      = Get-Date -Format "yyyy-MM-dd"

Write-Header "🚀 Speckit Init"
Write-Host "Target directory: $TargetDir"

# ── Gather project info ───────────────────────────────────────────────────────
$IsInteractive = [Environment]::UserInteractive -and (-not [System.Console]::IsInputRedirected)

if ($IsInteractive) {
    $ProjectName = Read-Host "Project name"
    $ProjectType = Read-Host "Project type (e.g., REST API, CLI tool, Web App, Library)"
    $Stack       = Read-Host "Primary language/stack (e.g., TypeScript/Node.js, Python, Go)"
    $TeamSize    = Read-Host "Team size (e.g., solo, 2-5, 10+)"
} else {
    $ProjectName = Split-Path $TargetDir -Leaf
    $ProjectType = "[NEEDS CLARIFICATION: specify project type]"
    $Stack       = "[NEEDS CLARIFICATION: specify language and stack]"
    $TeamSize    = "[NEEDS CLARIFICATION: specify team size]"
    Write-Warn "Non-interactive mode: using defaults. Edit .specify\memory\constitution.md to fill in project details."
}

# ── Create directory structure ────────────────────────────────────────────────
Write-Header "📁 Creating directory structure..."

$dirs = @(
    "$TargetDir\.specify\memory",
    "$TargetDir\.specify\templates",
    "$TargetDir\.specify\extensions",
    "$TargetDir\.specify\presets",
    "$TargetDir\.specify\overrides",
    "$TargetDir\.specify\scripts",
    "$TargetDir\specs"
)

foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}
Write-Success "Directory structure created"

# ── Find speckit source templates ─────────────────────────────────────────────
$SpeckitSource = ""
$candidates = @(
    "$ScriptDir\..\  .specify",
    "$HOME\.speckit\.specify",
    "C:\ProgramData\speckit\.specify"
)

foreach ($candidate in $candidates) {
    $resolved = [System.IO.Path]::GetFullPath($candidate)
    if (Test-Path "$resolved\templates") {
        $SpeckitSource = $resolved
        break
    }
}

# ── Copy templates ────────────────────────────────────────────────────────────
if ($SpeckitSource -and ($SpeckitSource -ne "$TargetDir\.specify")) {
    Write-Header "📋 Copying templates..."
    $templateFiles = Get-ChildItem "$SpeckitSource\templates\*.md" -ErrorAction SilentlyContinue
    foreach ($file in $templateFiles) {
        $dest = "$TargetDir\.specify\templates\$($file.Name)"
        if (-not (Test-Path $dest)) { Copy-Item $file.FullName $dest }
    }
    foreach ($scriptFile in @("update-context.sh", "update-context.ps1")) {
        $src  = "$SpeckitSource\scripts\$scriptFile"
        $dest = "$TargetDir\.specify\scripts\$scriptFile"
        if ((Test-Path $src) -and (-not (Test-Path $dest))) { Copy-Item $src $dest }
    }
    Write-Success "Templates copied"
} else {
    Write-Warn "Could not find speckit source templates. You may need to copy them manually."
}

# ── Create constitution ───────────────────────────────────────────────────────
Write-Header "📜 Creating project constitution..."

$ConstitutionPath = "$TargetDir\.specify\memory\constitution.md"

if (Test-Path $ConstitutionPath) {
    Write-Warn "Constitution already exists at $ConstitutionPath — skipping"
} else {
    $constitution = @"
# Project Constitution

**Project**: $ProjectName
**Version**: 1.0
**Last Updated**: $Date
**Status**: DRAFT

---

## Preamble

This constitution defines the non-negotiable principles governing all development decisions for $ProjectName ($ProjectType, $Stack). Every contributor — human or AI — must read and follow these principles.

---

## Article I: Library-First Principle

**Principle**: Prefer well-maintained libraries over custom implementations.

**Enforcement Rules**:
- Before writing any utility, search for an existing library
- Custom implementations require written justification in research.md
- [NEEDS CLARIFICATION: List approved package registries for $Stack]

---

## Article II: Test-First Development

**Principle**: Tests are written before implementation code. No exceptions.

**Enforcement Rules**:
- Every tasks.md orders test tasks before implementation tasks
- PRs without tests are rejected
- [NEEDS CLARIFICATION: Which test framework does $Stack use?]

---

## Article III: Minimal Dependencies

**Principle**: Every dependency is a liability. Add only what is necessary.

**Enforcement Rules**:
- New dependencies require team approval
- Run dependency audit on every PR

---

## Article IV: Single Source of Truth

**Principle**: Every piece of data or logic lives in exactly one place.

**Enforcement Rules**:
- No copy-pasted code blocks larger than 5 lines
- Configuration in one place (env vars or single config file)

---

## Article V: Explicit Over Implicit

**Principle**: Prefer explicit, readable code over clever, implicit code.

**Enforcement Rules**:
- No global mutable state
- Type annotations required where supported
- Named constants over magic strings/numbers

---

## Article VI: Documentation as Code

**Principle**: Documentation lives in the repository.

**Enforcement Rules**:
- Every public API has inline documentation
- Architectural decisions in specs/NNN/plan.md
- README updated with every user-facing change

---

## Article VII: Simplicity Gate

**Principle**: Maximum 3 services. No future-proofing code.

**Enforcement Rules**:
- Features may not require more than 3 distinct services
- No code for requirements not in current spec
- Interfaces need 2+ concrete implementations

---

## Article VIII: Anti-Abstraction Gate

**Principle**: Use frameworks directly. One model per entity.

**Enforcement Rules**:
- Do not wrap framework primitives
- Each entity has one canonical model representation

---

## Article IX: Security & Privacy Baseline

**Principle**: Security and privacy are never deferred.

**Enforcement Rules**:
- No secrets in source code — ever
- All user input validated and sanitized
- PII documented in data-model.md
- HIGH/CRITICAL vulnerabilities block merging
- [NEEDS CLARIFICATION: Compliance framework (GDPR/CCPA/HIPAA/none)?]

---

## Amendments

| Version | Date | Change | Author |
|---------|------|--------|--------|
| 1.0 | $Date | Initial constitution | speckit init |
"@
    $constitution | Set-Content -Path $ConstitutionPath -Encoding UTF8
    Write-Success "Constitution created at $ConstitutionPath"
}

# ── Configure AI agent integrations ──────────────────────────────────────────
if ($Integration -in @("copilot", "all")) {
    Write-Header "🤖 Configuring GitHub Copilot integration..."
    $copilotDir = "$TargetDir\.github\copilot-instructions.d"
    New-Item -ItemType Directory -Path $copilotDir -Force | Out-Null

    if ($SpeckitSource) {
        $copilotSrc = "$([System.IO.Path]::GetDirectoryName($SpeckitSource))\.github\copilot-instructions.d"
        if (Test-Path $copilotSrc) {
            Get-ChildItem "$copilotSrc\*.md" | ForEach-Object {
                $dest = "$copilotDir\$($_.Name)"
                if (-not (Test-Path $dest)) { Copy-Item $_.FullName $dest }
            }
            Write-Success "Copilot slash commands installed in .github\copilot-instructions.d\"
        } else {
            Write-Warn "Copilot command files not found at $copilotSrc"
        }
    }
}

if ($Integration -in @("claude", "all")) {
    Write-Header "🤖 Configuring Claude Code integration..."
    $claudeDir = "$TargetDir\.claude\commands"
    New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null

    if ($SpeckitSource) {
        $claudeSrc = "$([System.IO.Path]::GetDirectoryName($SpeckitSource))\.claude\commands"
        if (Test-Path $claudeSrc) {
            Get-ChildItem "$claudeSrc\*.md" | ForEach-Object {
                $dest = "$claudeDir\$($_.Name)"
                if (-not (Test-Path $dest)) { Copy-Item $_.FullName $dest }
            }
            Write-Success "Claude slash commands installed in .claude\commands\"
        } else {
            Write-Warn "Claude command files not found at $claudeSrc"
        }
    }
}

# ── Initialize specs directory ────────────────────────────────────────────────
Write-Header "📂 Initializing specs directory..."

$specsDir  = "$TargetDir\specs"
$gitkeep   = "$specsDir\.gitkeep"
$hasContent = (Get-ChildItem $specsDir -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0

if (-not $hasContent) {
    New-Item -ItemType File -Path $gitkeep -Force | Out-Null
    Write-Success "specs\ directory initialized"
} else {
    Write-Success "specs\ directory already has content"
}

# ── Print next steps ──────────────────────────────────────────────────────────
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor White
Write-Host "✅ Speckit initialized for $ProjectName" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:"
Write-Host ""
Write-Host "  1. Review and complete your constitution:"
Write-Host "     $ConstitutionPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "  2. Define your first feature spec:"
if ($Integration -eq "claude") {
    Write-Host "     /speckit:specify Add user authentication" -ForegroundColor Cyan
} else {
    Write-Host "     /speckit.specify Add user authentication" -ForegroundColor Cyan
}
Write-Host ""
Write-Host "  3. Run the full workflow:"
if ($Integration -eq "claude") {
    Write-Host "     /speckit:specify → /speckit:clarify → /speckit:plan → /speckit:tasks → /speckit:implement" -ForegroundColor Cyan
} else {
    Write-Host "     /speckit.specify → /speckit.clarify → /speckit.plan → /speckit.tasks → /speckit.implement" -ForegroundColor Cyan
}
Write-Host ""
Write-Host "  4. Keep AI context updated:"
Write-Host "     .\.specify\scripts\update-context.ps1" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Docs: see specs\000-example\ for a filled-in example" -ForegroundColor Cyan
Write-Host ""
