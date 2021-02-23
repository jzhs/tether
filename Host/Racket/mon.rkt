#lang racket
(provide (all-defined-out))

(require "tether.rkt")

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
    (printf "\n~a  ~a  ~a  ~a"
            (word->hex-string (+ adr i))  ; address in hex
            (byte->hex-string b)          ; byte in hex
            (byte->dec-string b)          ; byte in decimal
            (integer->char b))))          ; character at that codepoint

(define (fetch-word adr)
  (for/fold ([sum 0])
            ([i 4])
    (+ sum (* (expt 256 (- 3 i)) (Fetch (+ adr i))))))


(open-serial "/dev/ttyUSB1" 115200)
(load-file "../Target/RPi3Bplus/extns/stuff.bin" #x90000)
