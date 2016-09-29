(defsystem telegram-bot
  :author "Vadim Radovel <vadim@radovel.ru>"
  :version "0.1"
  :depends-on (
               :carrier
               :babel
               :blackbird
               :cl-json
               :cl-async
               :wookie)
  :components
  ((:module "src"
    :components ((:file "package")
                 (:file "commands" :depends-on ("package" "json-routines"))
                 (:file "json-routines" :depends-on ("package"))
                 (:file "bot" :depends-on ("package" "json-routines" "commands"))
                 (:file "server" :depends-on ("package" "json-routines"))
                 (:file "main" :depends-on ("package" "bot")))))
  :description "My awesome telegram bot=)")
