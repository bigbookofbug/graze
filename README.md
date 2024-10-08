# graze: a `guix shell` automation system

## about
this is a (very) wip project intended to make writing complex `guix shell` invocations a bit easier. it is based loosely off of nix's flake system, `guile hall`, and my own personal gripes with how many flags have to be passed in order to create a complex, containerized shell environment like the ones described in[this blog post](https://guix.gnu.org/en/blog/2023/the-filesystem-hierarchy-standard-comes-to-guix-containers/).

## usage
currently, only the default `shell.scm` is functional. invocing `graze.scm init` will place such a file in the current directory if one does not already exist. this file can then be modified, and `graze.scm shell` can be run to enter the shell environment.

the default file looks like this:
```lisp
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
```

and below is an example of a `shell.scm` modified to build rust programs:
``` lisp
(add-to-load-path (string-append (getenv "HOME") "/Documents/graze/"))
(use-modules (graze shell-utils)
	     (guix gexp)
	     (ice-9 pretty-print))

(define site-packages
  (list
   'rust
   'bash
   'dbus
   'eudev
   'elogind
   'gcc-toolchain
   'pkg-config
   'rust-analyzer
   'rust-libdbus-sys
   'rust-nix
   'rust-libudev-sys
   'rust-cargo
   'gcc-toolchain
   'wayland
   'libxkbcommon
   'libinput
   'egl-gbm
   'libseat
   'xorg-server-xwayland))

(define shell
  (make-gshell
   #:packages site-packages
   #:command "sh"))
```

## installing
currently, there is no package build option, though i hope to add that later down the line. assuming you are running gnu guix, you may clone this repository and either add the project root to your `GUILE_LOAD_PATH` or run it from the command line via `/path/to/graze.scm`.

## contributing
any and all is welcome :)
