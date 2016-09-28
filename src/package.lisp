(in-package :cl-user)

(defpackage :telegram-bot-json
  (:use :cl :cl-json)
  (:export :get-value :add-value :unset-value :set-value :from-json :to-json))

(defpackage :telegram-bot-commands
  (:use :cl :cl-async :telegram-bot-json)
  (:export :hello :say-my-name :help :bye))

(defpackage :telegram-bot-server
  (:use :cl :cl-async :wookie :telegram-bot-json))

(defpackage :telegram-bot
  (:use :cl :drakma :cl-async :wookie :telegram-bot-json :telegram-bot-commands)
  (:export :main :rpc-call :get-me :get-updates :handle-message :send-message :add-user :get-user :del-user :bot :bot-s))
