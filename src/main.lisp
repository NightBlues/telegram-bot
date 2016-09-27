(in-package :telegram-bot)

(defun main (bot)
  (as:with-event-loop ()
	  (as:with-interval (3)
		(telegram-bot::get-updates bot))))
