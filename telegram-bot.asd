(defsystem telegram-bot
  :author "Vadim Radovel <vadim@radovel.ru>"
  :version "0.1"
  :depends-on (:drakma :cl-json :cl-async)
  :components ((:module "src"
                        :components (
                                     (:file "package")
                                     (:file "commands" :depends-on ("package" "json-routines"))
                                     (:file "json-routines" :depends-on ("package"))
                                     (:file "bot" :depends-on ("package" "json-routines" "commands"))
                                     (:file "main" :depends-on ("package" "bot")))))
  :description "Telegram bot api")
