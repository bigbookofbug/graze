#!/usr/bin/env -S guile -e main -s
!#

;; Testing
(define this-directory
  (dirname (current-filename)))
(add-to-load-path this-directory)
;; Testing

(use-modules (guix build utils)
	     (graze init)
	     (graze common)
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




(define* (main #:optional (args (command-line)))
  (cond ((nil? (cdr (command-line)))
	 (pretty-print "No commands provided! Please provide a command like `gshell template lisp` or `gshell build`"
		       #:display? #t))
	(else
	 (let* ((bin (car args))
		(cmd-line
		 (match args
		   ((bin cmd ...)
		    cmd)))
		(command (car cmd-line))
		(rest (cdr cmd-line)))
	   (cond ((equal? command "init")
		  (pretty-print "initializing site ..." #:display? #t)
		  (init-func rest))
		 ;;could make this into a macro maybe
		 ((equal? command "shell")
		  (pp-display "evaluating shell.scm...")
		  (if (shell-file-found?)
		      (system* "/usr/bin/env" "-S" "guile" "-e" "shell" "-s" "shell.scm")
		      (pp-display "ERROR: no shell.scm found!")))
		 ;; TODO - is this necessary ? we already have guix build
		 ;; probably worth removing - replace w/ help for now
		 ((equal? command "build")
		  (pretty-print "I will run build function" #:display? #t))
		 (else
		  (pretty-print "Command not recognized! Run `ghsell help` for a list of available commands" #:display? #t)))))))
