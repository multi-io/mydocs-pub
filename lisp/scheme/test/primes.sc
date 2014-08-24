(load "streams.sc")

(define (sieve s)
  (make-stream (stream-head s)
               (sieve
                (stream-filter
                 (lambda (x) (not (= 0 (modulo x (stream-head s)))))
                 (stream-tail s)))))

(define primes
  (sieve (make-int-interval-stream 2 '())))
