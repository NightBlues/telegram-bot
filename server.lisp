(in-package :cl)

(ql:quickload :telegram-bot)

(defvar token (sb-ext:posix-getenv "TOKEN"))

(telegram-bot:main token 8080)
