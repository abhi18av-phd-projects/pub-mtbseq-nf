#lang racket/base

(require pollen/render
         pollen/core
         pollen/setup
         racket/file
         racket/path
         racket/cmdline
         racket/string)

;; Load our pollen configuration
(require "pollen.rkt")

(define output-format 'typst)
(define input-file "table-1.pm")
(define output-file "table-1-generated.qmd")

;; Command line argument parsing
(define args
  (command-line
   #:program "generate-qmd"
   #:once-each
   [("-f" "--format") format-str
    "Output format (typst or docx)"
    (set! output-format (string->symbol format-str))]
   [("-i" "--input") input-path
    "Input Pollen file (.pm)"
    (set! input-file input-path)]
   [("-o" "--output") output-path
    "Output QMD file"
    (set! output-file output-path)]
   #:args ()
   '()))

;; Set the current output format parameter before rendering
(current-output-format output-format)

;; Generate the content by rendering the Pollen file as text
(define content
  (parameterize ([current-output-format output-format]
                 [current-poly-target 'txt])
    (dynamic-require `(file ,(path->string (build-path (current-directory) input-file))) 'doc)))

;; Clean up the content by removing unwanted parentheses and fix formatting
(define clean-content
  (let* ([step1 (regexp-replace* #rx"\\(([^()\r\n]+)\\)" content "\\1")]
         [step2 (regexp-replace* #rx"^\\)\\s*$" step1 "")]
         [step3 (regexp-replace* #rx"\\(\\s*\n" step2 "")]
         [step4 (regexp-replace* #rx"\n\\s*\\)" step3 "")]
         [step5 (regexp-replace* #rx"\\(\\s*```" step4 "```")]
         [step6 (regexp-replace* #rx"```\\s*\\)" step5 "```")]
         [step7 (regexp-replace* #rx"\\)###" step6 "\n\n###")]
         [step8 (regexp-replace* #rx"```\\s+###" step7 "```\n\n###")]
         [step9 (regexp-replace* #rx"```\\s###" step8 "```\n\n###")])
    step9))

;; Write the generated content to file
(display-to-file clean-content output-file #:exists 'replace)

(printf "Generated ~a for format: ~a\n" output-file output-format)
