<!DOCTYPE style-sheet PUBLIC "-//James Clark//DTD DSSSL Style Sheet//EN" [
<!ENTITY docbook.dsl SYSTEM "/usr/share/sgml/docbook/stylesheet/dsssl/modular/html/docbook.dsl" CDATA DSSSL >
]>

<style-sheet>
<style-specification id="html" use="docbook">
<style-specification-body>

;;; If you want everything on one page
;(define nochunks #t)

;;; If you need a CSS
;(define %stylesheet% "pleac.css")

;; I want depth 1 in the TOC; set to 2 to have all individual
;; entry show up in the TOC
(define (toc-depth nd) 1)


;; name for the root html file (default t1.html)
(define %root-filename% "index")

;; extension for HTML output files (default .htm)
(define %html-ext% ".html")

(define %use-id-as-filename% #t)

;; I want a TOC
(define %generate-article-toc% #t)

(define %shade-verbatim% #t)

(define ($shade-verbatim-attr$) (list (list "BORDER" "0")
                                      (list "BGCOLOR" "#2F4F4F")
                                      (list "WIDTH" "100%")))


</style-specification-body>
</style-specification>

<external-specification id="docbook" document="docbook.dsl">

</style-sheet>
