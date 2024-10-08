(define-module (graze common))

(use-modules (ice-9 pretty-print))

(define-public (pp-display str)
  (pretty-print str #:display? #t))
(define-public (shell-file-found?)
  (if (file-exists? (string-append (getcwd) "/" "shell.scm"))
      #t
      #f))

(define-public (dir-empty? dir)
    (cond ((eof-object? (readdir dir))
	   (closedir dir)
	   #t)
	  (else
	   (cond ((equal? (readdir dir) (and "." ".."))
	   (readdir dir)
	   (dir-empty? dir))
		 (else
		  (closedir dir)
		  #f)))))
