# update-context.ps1 — Rebuild AI context for speckit
# Usage: .\\.specify\scripts\update-context.ps1 [SpecsDir]
param(
    [string]$SpecsDir = "specs"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$OutputFile = ".specify\memory\context.md"
$Timestamp  = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

# Ensure output directory exists
$OutputDir = Split-Path $OutputFile
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add("# Speckit Context")
$lines.Add("Generated: $Timestamp")
$lines.Add("")

if (-not (Test-Path $SpecsDir)) {
    $lines.Add("No specs directory found at '$SpecsDir'.")
    $lines | Set-Content -Path $OutputFile -Encoding UTF8
    Write-Host "Context written to $OutputFile (empty)"
    exit 0
}

$lines.Add("## Active Features")
$lines.Add("")

$featureCount = 0

Get-ChildItem -Path $SpecsDir -Directory | Sort-Object Name | ForEach-Object {
    $specDir  = $_.FullName
    $specFile = Join-Path $specDir "spec.md"

    if (Test-Path $specFile) {
        $feature = $_.Name
        $lines.Add("### $feature")

        # Extract status line from spec.md
        $statusLine = Select-String -Path $specFile -Pattern "^\*\*Status\*\*:" -SimpleMatch | Select-Object -First 1
        if ($statusLine) {
            $lines.Add($statusLine.Line.Trim())
        } else {
            $lines.Add("**Status**: Unknown")
        }

        # List available documents
        $docs = [System.Collections.Generic.List[string]]::new()
        if (Test-Path (Join-Path $specDir "plan.md"))       { $docs.Add("plan") }
        if (Test-Path (Join-Path $specDir "tasks.md"))      { $docs.Add("tasks") }
        if (Test-Path (Join-Path $specDir "research.md"))   { $docs.Add("research") }
        if (Test-Path (Join-Path $specDir "data-model.md")) { $docs.Add("data-model") }
        if (Test-Path (Join-Path $specDir "contracts"))     { $docs.Add("contracts") }

        if ($docs.Count -gt 0) {
            $lines.Add("**Docs**: " + ($docs -join ", "))
        } else {
            $lines.Add("**Docs**: spec only")
        }

        # Count open tasks if tasks.md exists
        $tasksFile = Join-Path $specDir "tasks.md"
        if (Test-Path $tasksFile) {
            $content   = Get-Content $tasksFile
            $openTasks = ($content | Where-Object { $_ -match "^- \[ \]" }).Count
            $doneTasks = ($content | Where-Object { $_ -match "^- \[x\]" }).Count
            $lines.Add("**Tasks**: $doneTasks done / $openTasks remaining")
        }

        $lines.Add("")
        $featureCount++
    }
}

if ($featureCount -eq 0) {
    $lines.Add("_No features found in $SpecsDir_")
    $lines.Add("")
}

$lines.Add("---")
$lines.Add("")
$lines.Add("## Constitution")
$lines.Add("")

$constitutionPath = ".specify\memory\constitution.md"
if (Test-Path $constitutionPath) {
    $lines.Add("Constitution found at ``$constitutionPath``")
    $projectLine = Select-String -Path $constitutionPath -Pattern "^\*\*Project\*\*:" -SimpleMatch | Select-Object -First 1
    if ($projectLine) {
        $lines.Add($projectLine.Line.Trim())
    }
} else {
    $lines.Add("⚠️ No constitution found. Run ``/speckit.constitution`` to create one.")
}

$lines | Set-Content -Path $OutputFile -Encoding UTF8

Write-Host ""
Write-Host "✅ Context written to $OutputFile"
Write-Host "   Features indexed: $featureCount"
