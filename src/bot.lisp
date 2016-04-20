(in-package :cl-user)
(defpackage :telegram-bot
  (:use :cl :drakma :cl-json)
  (:export :rpc-call :get-me :get-updates :handle-message :send-message :bot))
(in-package :telegram-bot)

;; (defparameter *access-token* "177892372:AAHwGRGhUazjzA0Um5sIUSiXVhKKT0eu9zs")
;; (defvar bot (make-instance 'telegram-bot:bot :token "177892372:AAHwGRGhUazjzA0Um5sIUSiXVhKKT0eu9zs"))
(defparameter *basic-url* "https://api.telegram.org/bot~a/~a")

(defclass bot ()
  ((token :reader token
          :initarg :token
          :type string)
   (update-id :accessor update-id
              :type integer
              :initform 0))
  (:documentation "Telegram bot main class"))

;; (defun from-json (data)
;;   (jonathan:parse data :as :hash-table))

;; (defun to-json (obj)
;;   (jonathan:to-json obj))

;; (defun get-result (resp)
;;   (when (gethash "ok" resp)
;;     (gethash "result" resp)))

;; (defun get-last-update-id (messages)
;;   (1+ (gethash "update_id" (car (last messages)))))

(defun from-json (data)
  (let ((*json-identifier-name-to-lisp*  #'identity))
    (json:decode-json-from-string data)))

(defun to-json (obj)
  (let ((*lisp-identifier-name-to-json* #'identity))
    (json:encode-json-to-string obj)))

(defun get-result (resp)
  (when (assoc :|ok| resp :test #'equal)
    (cdr (assoc :|result| resp :test #'equal))))

(defun get-last-update-id (messages)
  (1+ (cdr (assoc :|update_id| (car (last messages)) :test #'equal))))


(defgeneric rpc-call (self method &optional data))
(defgeneric get-me (self))
(defgeneric get-updates (self))
(defgeneric handle-message (self message))
(defgeneric send-message (self recepient message))

(defmethod rpc-call ((self bot) method &optional data)
  (let* ((url (format nil *basic-url* (token self) method))
         ;; (call-args (list url :want-stream t))
         (call-args (list url :external-format-in :utf-8))
         (result nil))
    (when data
      (setq call-args (nconc call-args `(:method :post :external-format-out :utf-8 :parameters ,data))))
    (setq result (apply #'drakma:http-request call-args))
    (setq result (flexi-streams:octets-to-string result))
    (from-json result)))

(defmethod get-me ((self bot))
  (let ((resp (rpc-call self "getMe")))
    (get-result resp)))

(defmethod get-updates ((self bot))
  (let* ((offset (format nil "~a" (update-id self)))
         (resp (rpc-call self "getUpdates" (list (cons "offset" offset))))
         (result (get-result resp)))
    (when result
      ;; (setf (update-id self) (get-last-update-id result))
      (mapc (lambda (message) (funcall #'handle-message self message)) result)
      nil)))


(defmethod send-message ((self bot) recepient message)
  (let ((data (list (cons "chat_id" recepient) (cons "text" message))))
    (rpc-call self "sendMessage" data)))

  
(defmethod handle-message ((self bot) message)
  (let ((msg (to-json message)))
    (format t "Raw:  ~a~%" message)
    (format t "Message: ~a~%" msg)))
