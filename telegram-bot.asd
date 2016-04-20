(defsystem telegram-bot
  :author "Vadim Radovel <vadim@radovel.ru>"
  :version "0.1"
  :depends-on (:drakma :cl-json)
  :components ((:module "src"
                :components ((:file "bot"))))
  :description "Telegram bot api")
