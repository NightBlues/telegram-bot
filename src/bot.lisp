(in-package :cl-user)
(defpackage :telegram-bot
  (:use :cl :drakma :telegram-bot-json)
  (:export :rpc-call :get-me :get-updates :handle-message :send-message :bot))
(in-package :telegram-bot)

;; (defparameter *access-token* "177892372:AAHwGRGhUazjzA0Um5sIUSiXVhKKT0eu9zs")
;; (defvar bot (make-instance 'telegram-bot:bot :token "177892372:AAHwGRGhUazjzA0Um5sIUSiXVhKKT0eu9zs"))
(defparameter *basic-url* "https://api.telegram.org/bot~a/~a")

(defun get-result (resp)
  (when (get-value resp :|ok|)
    (get-value resp :|result|)))

(defun get-text (resp)
  (get-value resp :|message| :|text|))

(defun get-username (resp)
  (get-value resp :|message| :|from| :|username|))

(defun get-chat-id (resp)
  (get-value resp :|message| :|from| :|id|))

(defun get-last-update-id (messages)
  (1+ (get-value (car (last messages))  :|update_id|)))


(defclass bot ()
  ((token :reader token
          :initarg :token
          :type string)
   (update-id :accessor update-id
              :type integer
              :initform 0)
   (users :accessor users :initform '()))
  (:documentation "Telegram bot main class"))

(defgeneric rpc-call (self method &optional data))
(defgeneric get-me (self))
(defgeneric get-updates (self))
(defgeneric handle-message (self message))
(defgeneric send-message (self recepient message))
(defgeneric add-user (self username chat-id))
(defgeneric show-users (self))

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
      (setf (update-id self) (get-last-update-id result))
      (mapc (lambda (message) (funcall #'handle-message self message)) result)
      nil)))


(defmethod send-message ((self bot) recepient message)
  (let ((data (list (cons "chat_id" recepient) (cons "text" message))))
    (rpc-call self "sendMessage" data)))


(defmethod handle-message ((self bot) message)
  (format t "Message:  ~a~%" message)
  (let (
        ;; (msg (to-json message))
        (text (get-text message)))
    ;; (format t "Message: ~a~%" msg)
    (cond
      ((equal text "hello") (add-user self (get-username message) (get-chat-id message)))
      (t (format t "Dont know how to react to message")))))


(defmethod add-user ((self bot) username chat-id)
  (setf (users bot) (add-value (users bot) username (write-to-string chat-id))))