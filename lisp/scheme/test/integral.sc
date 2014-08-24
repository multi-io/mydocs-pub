(load "streams.sc")

(define (stream-integral s dt C)
  (make-stream
   C
   (stream-integral
    (stream-tail s)
    dt
    (+ (stream-head s) C))))
