#!/usr/bin/env bash

# Clean QMD generator using direct Racket approach (no regex needed!)
# Usage: ./generate-clean.sh [typst|docx] [output-file] [data-file]

set -euo pipefail

# Default values
FORMAT="${1:-typst}"
OUTPUT_FILE="${2:-table-1-clean.qmd}"
DATA_FILE="${3:-table-1-data.csv}"

# Validate format
if [[ "$FORMAT" != "typst" && "$FORMAT" != "docx" ]]; then
    echo "Error: Format must be 'typst' or 'docx'"
    echo "Usage: $0 [typst|docx] [output-file] [data-file]"
    exit 1
fi

# Check if data file exists
if [[ ! -f "$DATA_FILE" ]]; then
    echo "Error: Data file $DATA_FILE not found"
    exit 1
fi

echo "Generating $OUTPUT_FILE for format: $FORMAT using data: $DATA_FILE"

# Use the direct Racket generator (no Pollen, no regex!)
racket generate-direct.rkt --format "$FORMAT" --data "$DATA_FILE" --output "$OUTPUT_FILE"

echo "✅ Done! Generated $OUTPUT_FILE (completely clean, no regex post-processing needed)"