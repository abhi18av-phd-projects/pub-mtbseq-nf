#lang racket/base

(require racket/file
         racket/path
         racket/cmdline
         racket/string
         racket/format
         racket/list
         json)

(define output-format 'typst)
(define data-file "table-1-data.csv")
(define output-file "table-1-generated.qmd")

;; Command line argument parsing
(define args
  (command-line
   #:program "generate-direct"
   #:once-each
   [("-f" "--format") format-str
    "Output format (typst or docx)"
    (set! output-format (string->symbol format-str))]
   [("-d" "--data") data-path
    "Data file (CSV, JSON, YAML)"
    (set! data-file data-path)]
   [("-o" "--output") output-path
    "Output QMD file"
    (set! output-file output-path)]
   #:args ()
   '()))

;; Data loading functions
(define (load-csv-data filename)
  (let ([lines (file->lines filename)])
    (map (lambda (line)
           (let ([parts (string-split line ",")])
             (list (string-trim (first parts))
                   (string-trim (second parts)))))
         (rest lines)))) ; Skip header row

(define (load-json-data filename)
  (let ([json-data (call-with-input-file filename read-json)])
    (if (list? json-data)
        (map (lambda (item)
               (if (hash? item)
                   (list (hash-ref item "theme" "")
                         (hash-ref item "feature" ""))
                   (list "" "")))
             json-data)
        '())))

(define (load-yaml-data filename)
  (let ([lines (file->lines filename)])
    (filter-map (lambda (line)
                  (let ([trimmed (string-trim line)])
                    (if (and (not (string=? trimmed ""))
                             (not (string-prefix? trimmed "#"))
                             (string-contains? trimmed ":"))
                        (let ([parts (string-split trimmed ":")])
                          (list (string-trim (first parts))
                                (string-trim (second parts))))
                        #f)))
                lines)))

(define (load-table-data filename)
  (cond
    [(string-suffix? filename ".json") (load-json-data filename)]
    [(string-suffix? filename ".csv") (load-csv-data filename)]
    [(or (string-suffix? filename ".yaml")
         (string-suffix? filename ".yml")) (load-yaml-data filename)]
    [else (error "Unsupported file format")]))

;; YAML front matter
(define yaml-header
  "---
title: \"\"
author: \"\"

format:
    docx: default
    typst:
        mainfont: \"Ubuntu\"
        keep-typ: true
execute:
  echo: false
  warning: false

---

")

;; Table rendering functions
(define (render-table-row theme feature output-fmt)
  (cond
    [(eq? output-fmt 'typst) (format "  | ~a | ~a |\n" theme feature)]
    [(eq? output-fmt 'docx) (format "| ~a | ~a |\n" theme feature)]
    [else (format "| ~a | ~a |\n" theme feature)]))

(define (render-table-header output-fmt)
  (cond
    [(eq? output-fmt 'typst)
     "  | *Theme*         | *Feature*                   |\n  |-------------------|-------------------------------|\n"]
    [(eq? output-fmt 'docx)
     "| *Theme*         | *Feature*                   |\n|-------------------|-------------------------------|\n"]
    [else "| *Theme*         | *Feature*                   |\n|-------------------|-------------------------------|\n"]))

(define (render-table-data table-data output-fmt)
  (apply string-append
    (cons (render-table-header output-fmt)
          (map (lambda (row) (render-table-row (car row) (cadr row) output-fmt)) table-data))))

;; Main content generators
(define (generate-typst-content table-data)
  (string-append
    yaml-header
    "```{=typst}\n#set page(numbering: none)\n```\n\n"
    "### Table 1. Summary of key enhancements in MTBseq-nf, Nextflow wrapper for the original MTBseq pipeline.\n\n"
    "```{=typst}\n\n"
    "#import \"@preview/tablem:0.2.0\": tablem, three-line-table\n\n"
    "#let three-line-table = tablem.with(\n"
    "  render: (columns: auto, ..args) => {\n"
    "    table(\n"
    "      columns: columns,\n"
    "      stroke: none,\n"
    "      align: left + horizon,\n"
    "      table.hline(y: 0),\n"
    "      table.hline(y: 1),\n"
    "      ..args,\n"
    "      table.hline(),\n"
    "    )\n"
    "  }\n"
    ")\n\n"
    "```\n\n"
    "```{=typst}\n"
    "#three-line-table[\n"
    (render-table-data table-data 'typst)
    "]\n"
    "```\n"))

(define (generate-docx-content table-data)
  (string-append
    yaml-header
    "### Table 1. Summary of key enhancements in MTBseq-nf, Nextflow wrapper for the original MTBseq pipeline.\n\n"
    (render-table-data table-data 'docx)))

;; Main execution
(define table-data (load-table-data data-file))
(define content
  (cond
    [(eq? output-format 'typst) (generate-typst-content table-data)]
    [(eq? output-format 'docx) (generate-docx-content table-data)]
    [else (error "Unsupported output format")]))

(display-to-file content output-file #:exists 'replace)
(printf "Generated ~a for format: ~a (completely clean, no regex needed!)\n" output-file output-format)