(in-package :telegram-bot)

(defun main (bot)
  (as:with-event-loop ()
	  (as:with-interval (1)
		(telegram-bot::get-updates bot))))
