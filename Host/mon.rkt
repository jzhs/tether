#lang racket
(provide (all-defined-out))

(require "tether.rkt")

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


(define (store-code adr bstr)
  (for ([i (bytes-length bstr)])
    (Store adr (bytes-ref bstr i))))

;; example: (store-code #x90000 (bytes #x00 #x00 #x38 #xd5 #xc0 #x03 #x5f #xd6))
;; puts the bytes at the address.



(define (read-syms p) 
  (define (read-syms/acc lis)
    (define data (read p))
    (if (not (eof-object? data))
        (read-syms/acc (cons data lis))
        (reverse lis) ) )
  (read-syms/acc '()))


        
(define-syntax-rule (load-lib path addr syms)
  (begin
    (load-file (string-append path ".bin") addr)
    (define s* (read-syms (open-input-file "../extns/stuff.sym")))
    (define syms (map (λ (x) (list (car x) (+ addr (cadr x)))) s*))))



(open-serial "/dev/ttyUSB1" 115200)
(load-lib "../extns/stuff" #x90000 syms)

(define (call/sym id)
  (Call (cadr (assoc id syms))))

