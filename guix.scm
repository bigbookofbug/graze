(use-modules (guix build utils)
	     (guix gexp)
	     (guix packages)
	     (guix download)
	     (guix build-system copy) ;; change to guile???
	     (guix git-download)
	     (gnu packages guile)
	     (ice-9 command-line)
;	     (ice-9 format)
	     (ice-9 optargs)
	     (ice-9 pretty-print))

(define this-directory
  (dirname (current-filename)))

(define src
  (local-file this-directory
	      #:recursive? #t
	      #:select (git-predicate this-directory)))

(define-public guix-graze
  (package
    (name "guix-graze")
    (version "1.0")
    (source (local-file "/home/bigbug/guix-config/util/scheme/gshell.scm"))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan '(("gshell.scm"
			 "/bin/gshell"))
       #:phases (modify-phases %standard-phases
		  (add-after 'install 'make-exe
		    (lambda* (#:key outputs #:allow-other-keys)
		      (chmod (string-append (assoc-ref outputs "out") "/bin/gshell") 493))))))
    (home-page "https://bugbugbug.com")
    (synopsis "gshell")
    (description "bugbugbug")
    (license license:expat)))
