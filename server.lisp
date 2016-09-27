(in-package :cl)

(ql:quickload :telegram-bot)

(defvar token (sb-ext:posix-getenv "TOKEN"))
(defvar bot (make-instance 'telegram-bot:bot :token token))


(telegram-bot::main bot)
