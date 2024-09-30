#!/usr/bin/env -S guile -e main -s
!#

(use-modules (guix build utils)
	     (ice-9 command-line)
	     (ice-9 match)
	     (ice-9 optargs)
	     (ice-9 pretty-print))

(define describe-make-gshell
  "This is a set of functions thats used to make a shell
  `make-gshell` is to be used by the user in the final template liek so:
	```
	gshell build shell.scm
	```")

(define (make-package-list packages)
  "Returns a list of packages as a spaced string"
  (string-join
   (map symbol->string packages)
   " "))

(define (make-shell-options opts)
  (string-join opts " "))

(define* (make-gshell #:key
		      (packages #f)
		      (shell-hook #f)
		      (options #f))
  (define (or-empty x)
    (or x ""))
  (let ((shell-invok
	 (string-join (list
		       "guix shell"
		       (or-empty (make-package-list packages))
		       (or-empty (make-shell-options options))
		       (if (nil? shell-hook)
			   ""
			   (string-append "-- " shell-hook)))
		      " ")))
    shell-invok))

(define gshell-templates-dir
  (let ((dir-local (getenv "GSHELL_TEMPLATES_DIR")))
    (if dir-local
	 (if (string= "/" (substring dir-local (1- (string-length dir-local))))
	     dir-local
	     (string-append dir-local "/"))
	#f)))

(define (init-func args)
  "Default template or recursive-copy of the directory specified in the ARGS. If GSHELL_TEMPLATES_DIR is valid, will look for ARGS in that directory. Else, search for ARGS path in filesystem."
  (cond ((nil? args)
	 (pretty-print (string-append "No template specified!
Creating a default 'shell.scm' in " (getcwd)) #:display? #t)
	 "TODO")
	(else (cond
	       (gshell-templates-dir
		(if (directory-exists? (string-append gshell-templates-dir (car args)))
		    (copy-recursively (string-append gshell-templates-dir (car args))
				      (getcwd))
		    (pretty-print "Template not found!")))
	       (else
		(if (directory-exists? (car args))
		    (copy-recursively (car args)
				      (getcwd))
		    (pretty-print "Template not found!")))))))

(define* (main #:optional (args (command-line)))
  (cond ((nil? (cdr (command-line)))
	 (pretty-print "No commands provided! Please provide a command like `gshell template lisp` or `gshell build`"
		       #:display? #t))
	(else
	 (let* ((cmd-line
		 (match args
		   (("./graze.scm" cmd \...)
		    cmd)))
		(command (car cmd-line))
		(rest (cdr cmd-line)))
	   (cond ((equal? command "init")
		  (pretty-print "I will run template functions ^_^" #:display? #t)
		  (init-func rest))
		 ;;could make this into a macro mayb
		 ((equal? command "develop")
		  (pretty-print "I will run develope function :3" #:display? #t))
		 ;; TODO - is this necessary ? we already have guix build
		 ;; probably worth removing - replace w/ help for now
		 ((equal? command "build")
		  (pretty-print "I will run build functions UwU" #:display? #t))
		 (else
		  (pretty-print "Command not recognized! Run `ghsell help` for a list of available commands" #:display? #t)))))))
