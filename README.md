# telegram bot

* `TOKEN="177892372:AAHwGRGhUazjzA0Um5sIUSiXVhKKT0eu9zs" sbcl --load server.lisp`

or

* `(defvar bot (make-instance 'telegram-bot:bot :token "177892372:AAHwGRGhUazjzA0Um5sIUSiXVhKKT0eu9zs"))`
* `(telegram-bot:main bot)`
