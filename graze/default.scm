#!/usr/bin/env -S guile -e shell -s
!#
(add-to-load-path (string-append (getenv "HOME") "/Documents/graze/"))
(use-modules (graze shell-utils))

(define site-packages
  ;;Define your shell packages as a list using the shell util 'make-package-list'. You can use multple package lists if you'd like!
  (list
   'coreutils
   'bash
   'gcc-toolchain))

(define hello-dependencies
(list 'hello))

(define site-options
  (list "--network"
	"--container"))

(define shell
  (make-gshell
   #:packages (append site-packages hello-dependencies)
   #:options site-options
   #:shell-hook "hello"))
