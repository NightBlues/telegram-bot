# telegram bot

## Start
* `TOKEN="177892372:AAHwGRGhUazjzA0Um5sIUSiXVhKKT0eu9zs" sbcl --load server.lisp`

or

```
(defvar token "177892372:AAHwGRGhUazjzA0Um5sIUSiXVhKKT0eu9zs")
(defvar port 8080)
(telegram-bot-server:main token port :interval 3)
```

## Usage:

* from chat say `/hello` to bot
* to notify user `echo -e "Your build $BUILD_ID has $STATUS. $BUILD_URL" | curl -d @- localhost:8080/nightblues`
* say `/help` to bot for more commands
