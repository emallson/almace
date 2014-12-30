#lang racket/base

(require racket/file)

(define-struct drm-device (path primary?))

(define (list-drm-devices [path "/dev/dri"])
  (let* ([devices (directory-list path)]
         [files (map (lambda (device-path)
                       (build-path "/sys/class/drm" device-path "device/boot_vga"))
                     devices)]
         [primary?s (map (lambda (file)
                           (= (file->value file) 1)) files)])
    (map drm-device
         (map (lambda (device)
                (path->complete-path device path)) devices)
         primary?s)))

(define primary-device (findf drm-device-primary? (list-drm-devices)))

(provide primary-device
         list-drm-devices
         (struct-out drm-device))
