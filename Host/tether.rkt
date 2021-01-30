#lang racket

(provide serial-open serial-send-byte serial-recv-byte serial-flush serial-close (struct-out io-port))

#|
    Implement connection to device
|#

(struct io-port (in out name))

(define current-serial-port (make-parameter #f))


(define (serial-open dev baud)
  (let ([stty-cmd (string-append "stty --file=" dev " " baud " raw -echo cs8 cread clocal")])
    (system stty-cmd)
    (let-values ([(to from) (open-input-output-file dev #:mode 'binary #:exists 'append)])
      (current-serial-port (io-port to from dev) ) ) ) )

(define (serial-send-byte b)
  (write-byte b (io-port-out (current-serial-port))))

(define (serial-recv-byte)
  (read-byte (io-port-in (current-serial-port))))
  
(define (serial-close)
  (close-input-port (io-port-in (current-serial-port)))
  (close-output-port (io-port-out (current-serial-port))))

(define (serial-flush)
  (flush-output (io-port-out (current-serial-port))))
