#!/usr/bin/env bash
# update-context.sh — Rebuild AI context for speckit
# Usage: bash .specify/scripts/update-context.sh [specs-dir]
set -euo pipefail

SPECS_DIR="${1:-specs}"
OUTPUT_FILE=".specify/memory/context.md"

echo "# Speckit Context" > "$OUTPUT_FILE"
echo "Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

if [ ! -d "$SPECS_DIR" ]; then
  echo "No specs directory found at '$SPECS_DIR'." >> "$OUTPUT_FILE"
  echo "Context written to $OUTPUT_FILE (empty)"
  exit 0
fi

echo "## Active Features" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

feature_count=0

for spec_dir in "$SPECS_DIR"/*/; do
  if [ -f "$spec_dir/spec.md" ]; then
    feature=$(basename "$spec_dir")
    echo "### $feature" >> "$OUTPUT_FILE"

    # Extract status line from spec.md
    status=$(grep -m1 "^\*\*Status\*\*:" "$spec_dir/spec.md" 2>/dev/null || echo "**Status**: Unknown")
    echo "$status" >> "$OUTPUT_FILE"

    # List available documents
    docs=""
    [ -f "$spec_dir/plan.md" ]       && docs="$docs plan"
    [ -f "$spec_dir/tasks.md" ]      && docs="$docs tasks"
    [ -f "$spec_dir/research.md" ]   && docs="$docs research"
    [ -f "$spec_dir/data-model.md" ] && docs="$docs data-model"
    [ -d "$spec_dir/contracts" ]     && docs="$docs contracts"

    if [ -n "$docs" ]; then
      echo "**Docs**:$docs" >> "$OUTPUT_FILE"
    else
      echo "**Docs**: spec only" >> "$OUTPUT_FILE"
    fi

    # Count open tasks if tasks.md exists
    if [ -f "$spec_dir/tasks.md" ]; then
      open_tasks=$(grep -c "^\- \[ \]" "$spec_dir/tasks.md" 2>/dev/null || echo "0")
      done_tasks=$(grep -c "^\- \[x\]" "$spec_dir/tasks.md" 2>/dev/null || echo "0")
      echo "**Tasks**: $done_tasks done / $open_tasks remaining" >> "$OUTPUT_FILE"
    fi

    echo "" >> "$OUTPUT_FILE"
    feature_count=$((feature_count + 1))
  fi
done

if [ "$feature_count" -eq 0 ]; then
  echo "_No features found in $SPECS_DIR_" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

echo "---" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "## Constitution" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

if [ -f ".specify/memory/constitution.md" ]; then
  echo "Constitution found at \`.specify/memory/constitution.md\`" >> "$OUTPUT_FILE"
  # Extract the project name if set
  project_name=$(grep -m1 "^\*\*Project\*\*:" ".specify/memory/constitution.md" 2>/dev/null || echo "**Project**: [not set]")
  echo "$project_name" >> "$OUTPUT_FILE"
else
  echo "⚠️ No constitution found. Run \`/speckit.constitution\` to create one." >> "$OUTPUT_FILE"
fi

echo ""
echo "✅ Context written to $OUTPUT_FILE"
echo "   Features indexed: $feature_count"
