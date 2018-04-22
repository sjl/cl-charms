;;;; panels.lisp

(in-package #:cl-charms)

(defclass panel ()
  ((pointer :initarg :pointer
            :accessor panel-pointer
            :documentation "Pointer to the underlying representation of a panel pointer. (This is of CFFI type `CHARMS/LL:PANEL-PTR'.)")
   (window :initarg :window
           :accessor panel-window
           :documentation "This panel's window."))
  (:documentation "A curses panel."))


(defun make-panel (window)
  "Make a new panel for the given WINDOW."
  (let ((pointer (charms/ll:new-panel (window-pointer window))))
    (when (cffi:null-pointer-p pointer)
      (error "Failed to allocate a new panel."))
    (make-instance 'panel :pointer pointer :window window)))

(defun destroy-panel (panel)
  "Destroy the panel PANEL."
  (check-status (charms/ll:del-panel (panel-pointer panel)))
  (slot-makunbound panel 'pointer)
  t)


(defun show-panel (panel)
  "Show the panel PANEL."
  (check-status (charms/ll:show-panel (panel-pointer panel)))
  t)

(defun hide-panel (panel)
  "Hide the panel PANEL."
  (check-status (charms/ll:hide-panel (panel-pointer panel)))
  t)


(defun move-panel-to-top (panel)
  "Move the panel PANEL to the top of the stack."
  (check-status (charms/ll:top-panel (panel-pointer panel)))
  t)

(defun move-panel-to-bottom (panel)
  "Move the panel PANEL to the bottom of the stack."
  (check-status (charms/ll:bottom-panel (panel-pointer panel)))
  t)


(defun move-panel (panel x y)
  "Move the panel PANEL to the coordinates (X, Y)."
  (check-status (charms/ll:move-panel (panel-pointer panel) y x))
  t)

(defun update-panels ()
  "Update all panels."
  (charms/ll:update-panels)
  t)


;; todo: panel-above and panel-below... it would be nice to get the actual CLOS
;; objects instead of just the pointers, so we'd need to maintain a hash table
;; of pointers to panel objects.

