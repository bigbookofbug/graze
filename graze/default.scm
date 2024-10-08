;; change this line to whichever directory "graze.scm" is located in
(add-to-load-path (string-append (getenv "HOME") "/Documents/graze/"))
(use-modules (graze shell-utils))

(define site-packages
  "define your shell packages as a list using the shell util 'make-package-list'. takes a list of symbols, but it may later be changed to take strings if that proves more efficient."
  (list
   'coreutils
   'bash
   'gcc-toolchain))

(define hello-dependencies
  "if you would like to seperate out your deps, you may do so."
(list 'hello))

(define site-options
  "a list of options to pass to `guix shell`. see `guix shell --help` for a list of available options"
  (list ""))

(define pre-shell-hooks
  "a guile command to run before 'guix shell' is invoked. this allows for the evaluation of guile code before entering the shell environment if there is the need for such.
example:
(define write-manifest
  (call-with-output-file \"manifest.scm\"
    (lambda (output-port)
      (pretty-print '(specifications->manifest '(\"hello\")) output-port))))
...
(define shell
  (make-gshell
   #:pre-shell-hooks (lambda () write-manifest)
   #:packages site-packages
   #:options (list \"-m manifest.scm\")
   #:command \"sh\"))")

(define shell
  (make-gshell
   #:pre-shell-hooks #f
   #:packages (append site-packages hello-dependencies)
   #:options site-options
   ;; Commands to run upon entering the shell environment
   #:command "hello"))
