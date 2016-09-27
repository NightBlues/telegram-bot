(in-package :telegram-bot-server)

(defroute (:get "/.*") (req res)
  (send-response res :body "There is no spoon!~%"))

(defroute (:post "/([a-zA-Z]+)") (req res args)
  (let* ((username (car args))
		 (post-data (flexi-streams:octets-to-string (request-body req)))
		 (chat-id (telegram-bot:get-user telegram-bot:bot-s username))
		 (message (format nil "~a~%" post-data)))
	(when chat-id
	  (telegram-bot:send-message telegram-bot:bot-s chat-id message))
	(send-response res :body (format nil "Got message for user ~a~%" username))))

