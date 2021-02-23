#lang racket
(provide Fetch Store Call
         open-serial close-serial serial-ports
         rx-byte tx-byte flush (struct-out io-port)
         current-serial-port)

(require libserialport)

(define current-serial-port (make-parameter #f))

(struct io-port (in out))

(define (open-serial dev baud)
  (let-values ([(in out) (open-serial-port dev #:baudrate baud)])
    (current-serial-port (io-port in out))))

(define (close-serial)
  (close-input-port (io-port-in (current-serial-port)))
  (close-output-port (io-port-out (current-serial-port))))

(define (flush)
  (flush-output (io-port-out (current-serial-port))))

(define (tx-byte b)
  (write-byte b (io-port-out (current-serial-port))))

(define (rx-byte)
  (read-byte (io-port-in (current-serial-port))))

(define (to-bytes n #:byte-order end)  
  (define (to-bytes/acc n cnt acc)
    (if (= cnt 0)
        (if (eq? end 'big)
            acc
            (reverse acc))
        (to-bytes/acc (quotient n 256) (sub1 cnt) (cons (remainder n 256) acc))) )
  (to-bytes/acc n 4 '()))

(define (Fetch adr)
  (tx-byte #x01)
  (for ([b (to-bytes adr #:byte-order 'big)])
    (tx-byte b))
  (flush)
  (rx-byte) )

(define (Store adr val)
  (tx-byte #x02)
  (for ([b (to-bytes adr #:byte-order 'big)])
    (tx-byte b))
  (tx-byte val)
  (flush) )

(define (Call adr)
  (tx-byte #x03)
  (for ([b (to-bytes adr #:byte-order 'big)])
    (tx-byte b))
  (flush)
  ; calculate return value
  (+ (* (rx-byte) (expt 256 3)) (* (rx-byte) (expt 256 2)) (* (rx-byte) (expt 256 1)) (rx-byte)))

