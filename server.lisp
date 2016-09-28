(in-package :cl)

(ql:quickload :telegram-bot)

(defvar token (sb-ext:posix-getenv "TOKEN"))
(defvar port 8080)
(when (sb-ext:posix-getenv "PORT")
  (setq port (parse-integer (sb-ext:posix-getenv "PORT"))))

(telegram-bot:main token port)
