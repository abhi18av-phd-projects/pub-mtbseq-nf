# Pollen-based QMD Preprocessing

This directory contains a Pollen-based preprocessing system that allows you to create a single source file for your tables and generate format-specific QMD files for different output formats (Typst PDF, DOCX, etc.). The system supports external data loading from JSON, CSV, and YAML files.

## Problem Solved

Instead of maintaining separate files like `_table-1.qmd` and `_table_1.docx.qmd` with duplicated content and format-specific differences, you can now:
1. Maintain a single Pollen template file for formatting logic
2. Store table data separately in structured files (CSV, JSON, YAML)
3. Generate appropriate QMD files for your target format

## Files

### Core System
- `pollen.rkt` - Pollen configuration with conditional helper functions and data loading
- `generate-qmd.rkt` - Racket script that processes Pollen templates  
- `generate-table.sh` - Shell script wrapper for easy usage
- `README-pollen-preprocessing.md` - This documentation

### Template Examples
- `table-1-final.pm` - Template with inline data (original DRY approach)
- `table-1-csv.pm` - Template that loads data from CSV file
- `table-1-yaml.pm` - Template that loads data from YAML file
- `table-generic.pm` - Configurable template with variable data source

### Data Files
- `table-1-data.csv` - Table data in CSV format
- `table-1-data.json` - Table data in JSON format  
- `table-1-data.yaml` - Table data in YAML format

## Usage

### Quick Start

```bash
# Generate QMD for Typst/PDF output
./generate-table.sh typst output-table.qmd

# Generate QMD for DOCX output  
./generate-table.sh docx output-table.qmd
```

### Manual Usage

```bash
# Using the Racket script directly
racket generate-qmd.rkt --format typst --input table-1-simple.pm --output table-typst.qmd
racket generate-qmd.rkt --format docx --input table-1-simple.pm --output table-docx.qmd
```

## Template Format

Your Pollen template (`.pm` file) should use these conditional functions:

- `◊when-typst{content}` - Only include content for Typst/PDF output
- `◊when-docx{content}` - Only include content for DOCX output  
- `◊unless-typst{content}` - Include content for all formats except Typst
- `◊unless-docx{content}` - Include content for all formats except DOCX

### External Data Loading

To load table data from external files, use:
- `◊load-table-data["filename.csv"]` - Load from CSV file
- `◊load-table-data["filename.json"]` - Load from JSON file  
- `◊load-table-data["filename.yaml"]` - Load from YAML file
- `◊render-table[data]` - Render table with format-specific styling

## Data File Formats

### CSV Format
```csv
theme,feature
User-friendliness,Ease of download
User-friendliness,Explicit samplesheet
Maintainability,Extensibility
```

### JSON Format
```json
[
  {"theme": "User-friendliness", "feature": "Ease of download"},
  {"theme": "User-friendliness", "feature": "Explicit samplesheet"},
  {"theme": "Maintainability", "feature": "Extensibility"}
]
```

### YAML Format  
```yaml
# Comments are supported
User-friendliness: Ease of download
User-friendliness: Explicit samplesheet
Maintainability: Extensibility
```

### Example Template (External Data)

```pollen
#lang pollen

---
title: "My Table"
format:
    docx: default
    typst:
        mainfont: "Ubuntu"
        keep-typ: true
execute:
  echo: false
---

◊when-typst{
```{=typst}
#set page(numbering: none)
```
}

### Table 1. My awesome table

◊when-typst{
```{=typst}
#import "@preview/tablem:0.2.0": tablem, three-line-table

#let three-line-table = tablem.with(
  render: (columns: auto, ..args) => {
    table(
      columns: columns,
      stroke: none,
      align: left + horizon,
      table.hline(y: 0),
      table.hline(y: 1),
      ..args,
      table.hline(),
    )
  }
)

```

```{=typst}
◊render-table[◊load-table-data["my-data.csv"]]
```
}

◊when-docx{
◊render-table[◊load-table-data["my-data.csv"]]
}
```

## Benefits

1. **Single Source of Truth**: Maintain one template file instead of multiple copies
2. **Conditional Logic**: Include/exclude content based on output format
3. **Automated Generation**: Simple commands to generate format-specific files
4. **Extensible**: Easy to add support for new output formats
5. **Version Control Friendly**: Only track the source template, not generated files

## Integration with Your Workflow

You can integrate this into your build process:

```bash
# Generate both formats
./generate-table.sh typst _table-1.qmd
./generate-table.sh docx _table_1.docx.qmd

# Then proceed with your normal Quarto rendering
quarto render manuscript.qmd --to pdf
quarto render manuscript.qmd --to docx
```

## Requirements

- Racket (installed)
- Pollen package (installed)
- Basic knowledge of Pollen markup syntax

## Troubleshooting

- Ensure Racket and Pollen are properly installed
- Check that your template syntax uses the correct `◊` symbol (lozenge)
- Verify file paths are correct in your commands
- Make sure the shell script has execute permissions (`chmod +x generate-table.sh`)