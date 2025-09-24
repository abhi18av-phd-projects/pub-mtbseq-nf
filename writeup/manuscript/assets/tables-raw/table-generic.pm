#lang pollen

◊(define data-file "table-1-data.csv") ; Change this to use different data sources

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
◊render-table[◊load-table-data[data-file]]
```

}◊when-docx{

◊render-table[◊load-table-data[data-file]]

}