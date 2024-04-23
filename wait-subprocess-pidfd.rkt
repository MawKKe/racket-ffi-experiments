#lang racket

(require ffi/unsafe
     ffi/unsafe/define)

(require ffi/unsafe/port)

(define-ffi-definer mylib (ffi-lib "mylib"))

(mylib pidfd-open (_fun _int64 _uint64 -> _int64) #:c-id my_pidfd_open)
(mylib pidfd-close (_fun _int64 -> _void) #:c-id my_pidfd_close)
(mylib pidfd-wait (_fun _int64 -> _int ) #:c-id my_pidfd_wait)

(define-values (sp out in err)
  (subprocess #f #f #f (find-executable-path "sleep") "5s"))

(unless (eq? (subprocess-status sp) 'running)
  (error "problem launching 'sleep'"))

(displayln
  (format "launched 'sleep 5s' into the background (pid: ~a)" (subprocess-pid sp)))

(define fd (pidfd-open (subprocess-pid sp) 0))

(when (fd . < . 0)
  (subprocess-kill sp #t)
  (error (format "error: pidfd_open() returned ~a~%" fd)))

; create semaphore that observes events in the pidfd
; alternative is to use poll/select/epoll or whatever in C land
(define sema (unsafe-file-descriptor->semaphore fd 'read))

(unless sema
  (error "Could not create semaphore from fd?"))

(displayln "waiting to be notified via pidfd...")

(semaphore-wait sema)

(displayln "done")

(pidfd-close fd)
