# Enhanced Modular QMD Generator

This is the most advanced version of our QMD generation system, featuring:
- **External Template Files**: Typst code is separated into external `.typ` files
- **Content Templates**: Markdown content is modularized in external files
- **Style Selection**: Multiple Typst table styles can be chosen at generation time
- **Clean Output**: No regex post-processing needed
- **Multi-format Support**: Generates QMD for both Typst and DOCX outputs

## Directory Structure

```
├── generate-enhanced.rkt          # Main generator script
├── generate-enhanced.sh           # Shell wrapper
├── data.csv                      # Input data
├── typst-templates/              # External Typst templates
│   ├── page-setup.typ           # Page configuration
│   ├── table-imports-three-line.typ  # Three-line table style
│   └── table-imports-bordered.typ    # Bordered table style
└── content-templates/            # External content templates
    └── table-heading.md         # Table title/heading
```

## Usage

### Command Line

```bash
# Generate Typst output with three-line style
racket generate-enhanced.rkt --format typst --style three-line --output table.qmd

# Generate Typst output with bordered style
racket generate-enhanced.rkt --format typst --style bordered --output table-bordered.qmd

# Generate DOCX output (style parameter ignored for docx)
racket generate-enhanced.rkt --format docx --output table-docx.qmd
```

### Shell Wrapper

```bash
# Same functionality with simpler syntax
./generate-enhanced.sh typst three-line table.qmd
./generate-enhanced.sh typst bordered table-bordered.qmd
./generate-enhanced.sh docx three-line table-docx.qmd  # style ignored
```

## Supported Styles (Typst only)

- **three-line**: Classic academic table with minimal horizontal lines
- **bordered**: Full borders with alternating row colors for enhanced readability

## Data Sources

The generator supports multiple data formats:
- **CSV**: `data.csv` (default)
- **JSON**: `data.json` 
- **YAML**: `data.yaml`

The system automatically detects which data file exists and uses it.

## External Templates

### Typst Templates (`typst-templates/`)

- **page-setup.typ**: Contains page configuration (numbering, etc.)
- **table-imports-three-line.typ**: Defines the three-line table function
- **table-imports-bordered.typ**: Defines the bordered table function

### Content Templates (`content-templates/`)

- **table-heading.md**: Contains the table title and description

## Output Generation

The generator produces clean QMD files with:
- Proper YAML frontmatter
- Format-specific content (Typst code blocks vs Markdown tables)
- External template integration
- No post-processing artifacts

## Rendering

```bash
# Render to PDF via Typst
quarto render table.qmd --to typst

# Render to DOCX
quarto render table.qmd --to docx
```

## Advantages

1. **Modularity**: Templates are separated from generation logic
2. **Flexibility**: Multiple styles without code duplication
3. **Maintainability**: Easy to add new styles or modify existing ones
4. **Clean Output**: No regex cleanup needed
5. **Single Source**: One data file serves multiple formats
6. **Version Control Friendly**: Templates and data are in separate, trackable files

## Adding New Styles

1. Create a new template file: `typst-templates/table-imports-mystyle.typ`
2. Update the style mapping in `generate-enhanced.rkt`
3. Use the new style: `--style mystyle`

Example template structure:
```typst
#import "@preview/tablem:0.2.0": tablem

#let mystyle-table = tablem.with(
  render: (columns: auto, ..args) => {
    table(
      columns: columns,
      // Your custom styling here
      ..args,
    )
  }
)
```