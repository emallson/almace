#lang racket/base

(require ffi/unsafe
         ffi/unsafe/define
         "../drm.rkt")

(define-ffi-definer defwl (ffi-lib "libwayland-server"))

; When we do not need to inspect the structs, we just use the -pointer versions
; to preserve sanity

;;; wl_list
(define-cstruct _wl_list ([prev _wl_list-pointer/null]
                          [next _wl_list-pointer/null]))

(defwl wl_list_init (_fun _wl_list-pointer -> _void))

;;; wl_signal
(define-cstruct _wl_signal ([listener_list _wl_list]))

; this function is inlined, so I wrap it here
(define (wl_signal_init signal :: _wl_signal-pointer)
  (wl_list_init (wl_signal-listener_list signal)))

;;; wl_event_source
(define-cpointer-type _wl_event_source-pointer)

(defwl wl_event_source_remove (_fun _wl_event_source-pointer -> _int))

;;; wl_event_loop
(define-cpointer-type _wl_event_loop-pointer)

(define _wl_event_loop_fd_func_t (_fun _int _uint32 _pointer -> _int))
(define _wl_event_loop_timer_func_t (_fun _pointer -> _int))

(defwl wl_event_loop_add_fd (_fun _wl_event_loop-pointer
                                  _int
                                  _uint32
                                  _wl_event_loop_fd_func_t
                                  _pointer
                                  -> _wl_event_source-pointer))

;;; wl_display
(define-cpointer-type _wl_display-pointer)

(defwl wl_display_create (_fun -> _wl_display-pointer))
(defwl wl_display_add_socket (_fun _wl_display-pointer _string -> _int))
(defwl wl_display_run (_fun _wl_display-pointer -> _void))
(defwl wl_display_destroy (_fun _wl_display-pointer -> _void))

(defwl wl_display_get_event_loop
  (_fun _wl_display-pointer -> _wl_event_loop-pointer))

(provide wl_signal_init
         wl_event_source_remove
         wl_event_loop_add_fd
         wl_display_create
         wl_display_add_socket
         wl_display_run
         wl_display_destroy
         wl_display_get_event_loop)
