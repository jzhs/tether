#lang racket
(provide (all-defined-out))

(require "tether.rkt")
(require file/sha1) ; for hex- ...

(define (load-file fn adr)
  (with-input-from-file fn #:mode 'binary
    (λ ()
      (for ([b (current-input-port)]
            [i (in-naturals adr)])
        (Store i b)))))

(define (fetch-bytes adr n)
  (define bs (make-bytes n))
  (for ([i (in-range 0 n)])
    (bytes-set! bs i (Fetch (+ adr i))))
  bs)

(define (store-bytes! adr byts)  
  (for ([i (in-range 0 (- (bytes-length byts) 1))])
    (Store (+ adr i) (bytes-ref byts i))))

(define (byte->hex-string b)
  (~r b #:base 16 #:min-width 2 #:pad-string "0") )

(define (byte->dec-string b)
  (~r b #:base 10 #:min-width 3 #:pad-string " ") )

(define (word->hex-string w)
  (~r w #:base 16 #:min-width 4 #:pad-string "0") )


(define (dump-bytes adr n)
  (define bs (fetch-bytes adr n))
  (for ([i (in-range 0 n)])
    (define b (bytes-ref bs i))
    (printf "\n~a  ~a  ~a  ~a" (word->hex-string i) (byte->hex-string b) (byte->dec-string b) (integer->char b))))

(define (fetch-word adr)
  (for/fold ([sum 0])
            ([i 4])
    (+ sum (* (expt 256 (- 3 i)) (Fetch (+ adr i))))))

(define (bytes->int bs)
  (for/fold ([sum 0])
            ([i (bytes-length bs)])
    (+ (* 256 sum) (bytes-ref bs i))))


;; example: (~r (fetch-word #x100) #:base 16)
;;   Should display start of dtb: d00dfeed


(define (store-code adr bstr)
  (for ([i (bytes-length bstr)])
    (Store adr (bytes-ref bstr i))))

;; example: (store-code #x90000 (bytes #x00 #x00 #x38 #xd5 #xc0 #x03 #x5f #xd6))
;; puts the bytes at the address.



;; Assumption is that port p consists of lines. Each line consists
;; of a symbol and an address in hex form.
(define (read-syms p)
  (define (read-syms/acc lis)
    (let ([sym (read p)]
          [adr-str (read-line p)])
      
      (if (eof-object? sym)
          (reverse lis)
          (let* ([trimmed (string-trim adr-str)]
                 [byts (hex-string->bytes trimmed)]
                 [val (bytes->int byts)])
            (read-syms/acc (cons (list sym val) lis)) ) ) ) )
  (read-syms/acc '()))



(define-syntax-rule (load-lib path addr syms)
  (begin
    (load-file (string-append path ".bin") addr)
    (define s* (read-syms (open-input-file "../extns/stuff.sym")))
    (define syms (map (λ (x) (list (car x) (+ addr (cadr x)))) s*))))


(define (call/sym id)
  (Call (cadr (assoc id syms))))

(define (exception-level)
  (arithmetic-shift (call/sym 'elev) -2))


(open-serial "/dev/ttyUSB1" 115200)
(load-lib "../extns/stuff" #x90000 syms)
