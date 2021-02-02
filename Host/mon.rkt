#lang racket

(require "../host/tether.rkt")

(define (load-file fn adr)
  (with-input-from-file fn #:mode 'binary
    (λ ()
      (for ([b (current-input-port)])
        (Store adr b)
        (set! adr (add1 adr) )))))

(define (fetch-word adr)
  (for/fold ([sum 0])
            ([i 4])
    (+ sum (* (expt 256 (- 3 i)) (Fetch (+ adr i))))))


;; example: (~r (fetch-word #x100) #:base 16)
;;   Should display start of dtb: d00dfeed


