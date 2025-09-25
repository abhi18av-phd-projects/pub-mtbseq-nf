#!/usr/bin/env bash

# Script to generate QMD files from Pollen template
# Usage: ./generate-table.sh [typst|docx] [output-file]

set -euo pipefail

# Default values
FORMAT="${1:-typst}"
OUTPUT_FILE="${2:-table-1-generated.qmd}"
INPUT_FILE="table-1-csv.pm"

# Validate format
if [[ "$FORMAT" != "typst" && "$FORMAT" != "docx" ]]; then
    echo "Error: Format must be 'typst' or 'docx'"
    echo "Usage: $0 [typst|docx] [output-file]"
    exit 1
fi

# Check if input file exists
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: Input file $INPUT_FILE not found"
    exit 1
fi

echo "Generating $OUTPUT_FILE for format: $FORMAT"

# Use racket to generate the file
racket generate-qmd.rkt --format "$FORMAT" --input "$INPUT_FILE" --output "$OUTPUT_FILE"

echo "Done! Generated $OUTPUT_FILE"