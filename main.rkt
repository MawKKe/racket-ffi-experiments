#lang racket

(require ffi/unsafe
     ffi/unsafe/define)

(define-ffi-definer mylib (ffi-lib "mylib"))

(mylib foo (_fun -> _void))
(mylib special-add1 (_fun _int -> _int) #:c-id add1)
(mylib special-add-float (_fun _float -> _float) #:c-id add_float)
(mylib special-add-double (_fun _double -> _double) #:c-id add_double)

(mylib swapparoo (_fun _int (o : (_ptr o _int)) (i : (_ptr o _int))
                               -> (r : _int)
                               -> (list o r i)))

(displayln "racket start")

(foo)

(displayln (special-add1 41))
;(displayln (special-add1 #t))  ; error, as it should be; bool is not int
;(displayln (special-add1 41.123))  ; error, as it should be; float is not int
(displayln (special-add-float 1.69))
(displayln (special-add-double 1.69))
(displayln (map special-add1 (range 10)))

(displayln (swapparoo 1))
(displayln (swapparoo 2))
(displayln (swapparoo 3))
(displayln (swapparoo 4))

(displayln "racket end")
