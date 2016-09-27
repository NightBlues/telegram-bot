(in-package :telegram-bot)

(defun main (bot)
  (as:with-event-loop ()
	(let ((updater (as:with-interval (1)
					 (telegram-bot:get-updates bot))))
	  (as:signal-handler 2
						 (lambda (sig)
						   (format t "Going down~%")
						   (as:free-signal-handler 2)
						   (as:remove-interval updater))))))

