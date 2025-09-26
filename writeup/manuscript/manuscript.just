# === Default Task ===
default:
    @just --list

# Manuscript Management Tasks

# === Setup and Initialization ===

manuscript-init: # Initialize manuscript structure
    mkdir -p src assets/{figures,tables,supplementary} _output/{pdf,docx,html}/{draft,final} reviews/{feedback,responses,revisions} submissions/{preprint} versions
    touch src/{index,abstract,introduction,methods,results,discussion}.qmd
    touch src/references.bib
    touch _quarto.yml

# === Manuscript Preview and Render ===

manuscript-preview format="apaquarto-html" version="draft": # Preview HTML with live reload
    quarto preview src/index.qmd --to {{format}} --output-dir _output/{{format}}/{{version}}

manuscript-render-docx version="final": # Render manuscript DOCX and PDF
    quarto render src/index.qmd --to apaquarto-docx --output-dir _output/{{version}} && \
    cp src/index.qmd _output/{{version}}/src/ && \
    cp src/references.bib _output/{{version}}/src/


manuscript-render-typst version="final": # Render manuscript DOCX and PDF
    quarto render src/index.qmd --to apaquarto-typst --output-dir _output/{{version}} && \
    mv src/index.typ _output/{{version}}/src/ && \
    cp src/index.qmd _output/{{version}}/src/ && \
    cp src/references.bib _output/{{version}}/src/


manuscript-render:
    manuscript-render-docx manuscript-render-typst

manuscript-clean: # Clean generated files
    rm -rf _output


# === Versions ===

manuscript-version version:
    VERSION_DIR="v{{version}}-$(date +%Y-%m-%dT%H-%M-%S)" && \
    mkdir -p versions/${VERSION_DIR}/feedback && \
    cp _output/final/src/index.* versions/${VERSION_DIR}/ && \
    echo "Version created: versions/${VERSION_DIR}"


# === MANUSCRIPT MERGE ===

assets-merge-pdfs version:
    qpdf --empty --pages *pdf  -- final_document.pdf

assets-svg-to-pdf:
    inkscape --export-filename=out.pdf combined.svg

# === Submissions ===

#TODO: Automatically move the latest folder in a specific version series to submission.
#NOTE: Also move all figtable-index, figures, tables and supplemental-material into a submission.

manuscript-prepare-preprint platform="bioarxiv": # Prepare preprint submission
    mkdir -p submissions/preprint/{{platform}}/$(date +%Y%m%d)
    cp _output/pdf/final/* submissions/preprint/{{platform}}/$(date +%Y%m%d)/
    cp _output/html/final/* submissions/preprint/{{platform}}/$(date +%Y%m%d)/
    echo "Preprint prepared for {{platform}} on $(date)" > submissions/preprint/{{platform}}/$(date +%Y%m%d)/README.md
