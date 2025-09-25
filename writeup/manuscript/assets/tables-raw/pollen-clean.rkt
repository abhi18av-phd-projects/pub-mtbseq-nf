#lang racket/base

(require pollen/core
         pollen/setup
         racket/format
         racket/file
         racket/string
         racket/list
         json
         markdown)

(provide (all-defined-out))

;; Define the output format as a parameter
(define current-output-format (make-parameter 'typst))

;; Clean helper functions that return strings directly
(define (when-format format . content)
  (if (eq? (current-output-format) format)
      (apply string-append (map ~a content))
      ""))

(define (unless-format format . content)
  (if (not (eq? (current-output-format) format))
      (apply string-append (map ~a content))
      ""))

;; Specific helper functions for your use case
(define (when-typst . content)
  (when-format 'typst content))

(define (when-docx . content)
  (when-format 'docx content))

(define (unless-typst . content)
  (unless-format 'typst content))

(define (unless-docx . content)
  (unless-format 'docx content))

;; Data loading functions (same as before)
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

(define (load-csv-data filename)
  (let ([lines (file->lines filename)])
    (map (lambda (line)
           (let ([parts (string-split line ",")])
             (list (string-trim (first parts))
                   (string-trim (second parts)))))
         (rest lines)))) ; Skip header row

(define (load-yaml-data filename)
  ;; Simple YAML parser for our use case (theme: feature format)
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
    [(string-suffix? filename ".json")
     (load-json-data filename)]
    [(string-suffix? filename ".csv")
     (load-csv-data filename)]
    [(or (string-suffix? filename ".yaml")
         (string-suffix? filename ".yml"))
     (load-yaml-data filename)]
    [else (error "Unsupported file format. Use .json, .csv, .yaml, or .yml")]))

;; Clean table rendering functions - return properly formatted strings
(define (render-table-header)
  (cond
    [(eq? (current-output-format) 'typst)
     "  | *Theme*         | *Feature*                   |\n  |-------------------|-------------------------------|\n"]
    [(eq? (current-output-format) 'docx)
     "| *Theme*         | *Feature*                   |\n|-------------------|-------------------------------|\n"]
    [else "| *Theme*         | *Feature*                   |\n|-------------------|-------------------------------|\n"]))

(define (render-table-row theme feature)
  (cond
    [(eq? (current-output-format) 'typst)
     (format "  | ~a | ~a |\n" theme feature)]
    [(eq? (current-output-format) 'docx)
     (format "| ~a | ~a |\n" theme feature)]
    [else (format "| ~a | ~a |\n" theme feature)]))

(define (render-table-data table-data)
  (apply string-append
    (render-table-header)
    (map (lambda (row) (render-table-row (car row) (cadr row))) table-data)))

;; Complete table rendering function - returns clean formatted text
(define (render-table table-data)
  (cond
    [(eq? (current-output-format) 'typst)
     (string-append "#three-line-table[\n" (render-table-data table-data) "]\n")]
    [(eq? (current-output-format) 'docx)
     (render-table-data table-data)]
    [else (render-table-data table-data)]))

;; Clean code block helpers
(define (typst-code . content)
  (when-typst (format "```{=typst}\n~a\n```\n" (apply string-append content))))

(define (yaml-header . content)
  (format "---\n~a\n---\n" (apply string-append content)))

;; Override the root function to return clean text
(define (root . elements)
  (apply string-append (filter (lambda (x) (not (string=? x ""))) (map ~a elements))))