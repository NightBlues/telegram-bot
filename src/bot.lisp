(in-package :telegram-bot)

(defparameter *basic-url* "https://api.telegram.org/bot~a/~a")

(defun get-result (resp)
  (when (get-value resp :|ok|)
    (get-value resp :|result|)))

(defun get-text (resp)
  (get-value resp :|message| :|text|))

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
(defgeneric get-user (self username))
(defgeneric del-user (self username))

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
  (let* ((recepient (if (integerp recepient) (write-to-string recepient) recepient))
         (data (list (cons "chat_id" recepient) (cons "text" message))))
    (rpc-call self "sendMessage" data)))


(defmethod handle-message ((self bot) message)
  (format t "Message:  ~a~%" message)
  (let (
        ;; (msg (to-json message))
        (text (get-text message)))
    ;; (format t "Message: ~a~%" msg)
    (cond
      ((equal text "/help") (help self message))
      ((equal text "/hello") (hello self message))
      ((equal text "/saymyname") (say-my-name self message))
      ((equal text "/bye") (bye self message))
      (t (format t "Dont know how to react to message~%")))))


(defmethod add-user ((self bot) username chat-id)
  (setf (users self) (add-value (users self) username (write-to-string chat-id))))


(defmethod get-user ((self bot) username)
  (get-value (users self) username))


(defmethod del-user ((self bot) username)
  (setf (users self) (unset-value (users self) username)))
