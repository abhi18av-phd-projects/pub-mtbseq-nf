#lang pollen

◊(define table-data 
  '(("User-friendliness" "Ease of download")
    ("User-friendliness" "Explicit samplesheet")
    ("User-friendliness" "Graphical user interface")
    ("User-friendliness" "MultiQC Summary report")
    ("User-friendliness" "CSV and TSV format cleanup")
    ("User-friendliness" "Remote monitoring")
    ("User-friendliness" "Manual steps")
    ("User-friendliness" "Flexible output location")
    ("Maintainability" "Extensibility")
    ("Maintainability" "Module testing")
    ("Maintainability" "Test dataset")
    ("Scalability" "Parallel execution")
    ("Scalability" "HPC compatibility")
    ("Scalability" "Resource allocation")
    ("Scalability" "Dynamic retries")
    ("Scalability" "Execution cache")
    ("Scalability" "Reduced data footprint")
    ("Scalability" "Reduced cloud computing costs")
    ("Reproducibility" "Declarative parameters file")
    ("Reproducibility" "Portability")
    ("Reproducibility" "Save intermediate files")))

---
title: ""
author: ""

format:
    docx: default
    typst:
        mainfont: "Ubuntu"
        keep-typ: true
execute:
  echo: false
  warning: false

---

◊when-typst{
```{=typst}
#set page(numbering: none)
```

}### Table 1. Summary of key enhancements in MTBseq-nf, Nextflow wrapper for the original MTBseq pipeline.

◊when-typst{
```{=typst}
\\
\\
```

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
◊render-table[table-data]
```

}◊when-docx{

◊render-table[table-data]

}