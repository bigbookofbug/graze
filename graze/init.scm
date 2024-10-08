(add-to-load-path (string-append (getenv "HOME") "/Documents/graze/"))

(define-module (graze init))
(use-modules (graze common)
	     (guix build utils)
	     (ice-9 pretty-print)
	     (ice-9 command-line)
	     (ice-9 regex)
	     (ice-9 match))

(define gshell-templates-dir
  (let ((dir-local (getenv "GSHELL_TEMPLATES_DIR")))
    (if dir-local
	(if (string-match "/$" dir-local)
	    dir-local
	    (string-append dir-local "/"))
	#f)))

(define shell-file (string-append (getcwd)"/""shell.scm"))

(define (init-default)
  (if (not (dir-empty? (opendir (getcwd))))
      (pretty-print "WARNING: Directory not empty!" #:display? #t))
  (cond ((shell-file-found?)
	 (pp-display
	  "ERROR: Directory already contains a 'shell.scm'!
Unable to create a shell file in directory where one already exists.
Exiting."))
	(else (pp-display (string-append "Created a default 'shell.scm' in "
					   (getcwd)))
	      ;; TODO absolute path needs fixing
	      (copy-file (string-append (getenv "HOME") "/Documents/graze/graze/default.scm")
			 (string-append
			  (getcwd) "/" "shell.scm"))
	      (chmod shell-file #o775))))

(define (contains-arg? arg lst)
  (not (every* nil? (map (lambda (x)
			   (string-match arg x))
			 lst))))

(define-public (init-func args)
  "Default template or recursive-copy of the directory specified in the ARGS. If GSHELL_TEMPLATES_DIR is valid, will look for ARGS in that directory. Else, search for ARGS path in filesystem."
  (cond ((nil? args)
	 (pretty-print "No template specified!" #:display? #t)
	 (pretty-print (string-append "Creating a default 'shell.scm' in "
				      (getcwd) "\n") #:display? #t)
	 (init-default))
	(else
(display args)
	 (let ((argument (car args)))
	   ;; testing
	   (display (string-append "CAR: " argument "\n"))
	   (display (string-append "CDR: " (string-concatenate (cdr args)) "\n"))
	   (cond
	    ((string-match "--default" argument)
	     (init-default))

	    ;; make part of its own init-template function vvv
	    (gshell-templates-dir
	     (if (directory-exists? (string-append gshell-templates-dir (car args)))
		 (copy-recursively (string-append gshell-templates-dir (car args))
				   (getcwd))
		 (pretty-print "Template not found!")))
	    (else
	     (if (directory-exists? (car args))
		 (copy-recursively (car args)
				   (getcwd))
		 (pretty-print "Template not found!"))))))))
;; make part of its own init-template function ^^^


;;; OPTIONS for INIT-FUNC
;; ADDED:
;; --default -- use the default template (default arg)
;;
;; (tentatively) PLANNED:
;; --template [-t] -- select the template
;; --list [-l] -- list known templates
;; --dry-run -- display output of running command, without running.
;; --help [-h] -- show help
;; --force [-f] -- for non-empty dirs
