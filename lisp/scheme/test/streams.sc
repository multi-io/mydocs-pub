;--------interface------------

;; primitives:

; empty-stream
; (stream-empty? s)
; (make-stream head tail-stream)
; (stream-head s)
; (stream-tail s)

; axioms:

;  (stream-head (make-stream head tail-stream)) == head
;  (stream-tail (make-stream head tail-stream)) == tail-stream
;  (stream-head empty-stream) == <undefined>
;  (stream-tail empty-stream) == <undefined>
;  (stream-empty? empty-stream) == #t
;  (stream-empty? (make-stream head tail-stream)) == #f



; utilities:

; (take-first n s)   => stream
; (stream-map mapping-proc s)   => stream
; (stream-accumulate combiner-proc startval s)  => object (return value of proc)
; (stream-filter filter-proc s)  => stream


; various constructors:

; (make-loop-stream startval incrementor continue-pred)
; (make-int-interval-stream start stop)  ; if (null? stop): infinite stream starting at start


;--------representation-------

; - uses "lazy evaluation":

; - the empty stream is '()

; - a nonempty stream is a cons whose car is the stream's head, and whose cdr is a
;     procedure of 0 arguments that returns the stream's tail (which is again a stream)

(use-syntax (ice-9 syncase))   ; for Guile

(define empty-stream '())

(define stream-empty? null?)

(define-syntax make-stream
  (syntax-rules ()
                ((make-stream head tail)
                 (cons head (lambda () tail)))))


(define stream-head car)

(define (stream-tail s)
  ((cdr s)))


;;TODO: tail recursiveness

(define (take-first n s)
  (cond ((<= n 0) empty-stream)
        ((stream-empty? s) empty-stream)
        (else
         (make-stream
          (stream-head s)
          (take-first (1- n) (stream-tail s))))))

(define (stream-map mapping-proc s)
  (make-stream (mapping-proc (stream-head s))
               (stream-map mapping-proc (stream-tail s))))

;; don't use for infinite streams...
(define (stream-accumulate combiner-proc startval s)
  (if (stream-empty? s)
      startval
      (stream-accumulate combiner-proc
                         (combiner-proc (stream-head s) startval)
                         (stream-tail s))))

;; don't use for infinite streams...
(define (stream-to-list s)
  (stream-accumulate cons '() s))


(define (stream-filter filter-proc s)
  (let ((h (filter-proc (stream-head s))))
    (if h
        (make-stream (stream-head s) (stream-filter filter-proc
                                                    (stream-tail s)))
        (stream-filter filter-proc
                       (stream-tail s)))))



(define (make-loop-stream startval incrementor continue-pred)
  (if (not (continue-pred startval))
      empty-stream
      (make-stream
       startval
       (make-loop-stream (incrementor startval) incrementor continue-pred))))

(define (make-int-interval-stream start stop)
  (make-loop-stream start
                    1+
                    (lambda (x) (or (null? stop)
                                    (<= x stop)))))


; all natural numbers (infinite stream)
(define naturals-stream
  (make-int-interval-stream 0 '()))
