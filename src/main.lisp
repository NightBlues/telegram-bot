(in-package :telegram-bot)

(defvar bot-s '() "Bot singleton.")

(defun main (token port &key (interval 5))
  (unless bot-s
	(setq bot-s (make-instance 'telegram-bot:bot :token token)))

  (as:with-event-loop ()
	(let* ((updater (as:with-interval (interval)
					 (telegram-bot:get-updates bot-s)))
		  (listener (make-instance 'listener
								   :bind nil
								   :port port))
		   (server (start-server listener)))
	  (as:signal-handler 2
						 (lambda (sig)
						   (declare (ignore sig))
						   (format t "Going down~%")
						   (as:free-signal-handler 2)
						   (as:close-tcp-server server)
						   (as:remove-interval updater))))))

