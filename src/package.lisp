(in-package :cl-user)

(defpackage :telegram-bot-json
  (:use :cl :cl-json)
  (:export :get-value :add-value :unset-value :set-value :from-json :to-json))

(defpackage :telegram-bot
  (:use :cl :drakma :telegram-bot-json)
  (:export :rpc-call :get-me :get-updates :handle-message :send-message :bot))
