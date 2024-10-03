(define-module (graze shell-utils)
  #:export (make-gshell))
(use-modules (guix build utils)
	     (ice-9 pretty-print)
	     (ice-9 command-line)
	     (ice-9 regex)
	     (ice-9 match))

(define-public (make-package-list packages)
  "Returns a list of packages as a spaced string"
  (string-join
   (map symbol->string packages)
   " "))

(define-public (make-shell-options opts)
  (string-join opts " "))

(define* (make-gshell #:key
		      (packages #f)
		      (shell-hook #f)
		      (options #f))
  (define (or-empty x)
    (or x ""))
  (let ((shell-invoke
	 (string-join (list
		       "guix shell"
		       (or-empty (make-package-list packages))
		       (or-empty (make-shell-options options))
		       (if (nil? shell-hook)
			   ""
			   (string-append "-- " shell-hook)))
		      " ")))
    (system shell-invoke)))
