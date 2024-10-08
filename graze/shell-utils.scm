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
		      (pre-shell-hooks #f)
		      (packages #f)
		      (command #f)
		      (options #f))
  (let ((shell-invoke
	 (string-join (list
		       "guix shell"
		       (if (nil? packages) "" (make-package-list packages))
		       (if (nil? options) "" (make-shell-options options))
		       (if (nil? command)
			   ""
			   (string-append "-- " command)))
		      " ")))
    (pretty-print (string-append "Running shell with following command:\n" shell-invoke) #:display? #t)
    (if (nil? pre-shell-hooks) '() pre-shell-hooks)
    (system shell-invoke)))
