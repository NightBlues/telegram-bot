(defpackage :telegram-bot-json
  (:use :cl :cl-json)
  (:export :get-value :add-value :unset-value :set-value :from-json :to-json))
(in-package :telegram-bot-json)
  


;; (defun from-json (data)
;;   (jonathan:parse data :as :hash-table))

;; (defun to-json (obj)
;;   (jonathan:to-json obj))

;; (defun get-result (resp)
;;   (when (gethash "ok" resp)
;;     (gethash "result" resp)))

;; (defun get-last-update-id (messages)
;;   (1+ (gethash "update_id" (car (last messages)))))

;; Abstraction from different implementations of key-value storages
(defun get-value (data &rest keys)
  "Get value and subvalues if given. "
  (let ((res data))
    (dolist (key keys res)
      (setq res (assoc key res :test #'equal))
      (when res
        (setq res (cdr res))))))

(defun add-value (data key value)
  "Add value if not exist, do nothing otherwise"
  (if (get-value data key)
      data
      (acons key value data)))

(defun unset-value (data key)
  "Remove pair from list."
  (remove-if (lambda (elt) (equal (car elt) key)) data))
  
(defun set-value (data key value)
  "Set value, override if already exist."
  (add-value (unset-value data key) key value))


(defun from-json (data)
  (let ((*json-identifier-name-to-lisp*  #'identity))
    (json:decode-json-from-string data)))

(defun to-json (obj)
  (let ((*lisp-identifier-name-to-json* #'identity))
    (json:encode-json-to-string obj)))
