# Sendmessage Telegram Bot

This will allow you send messagem by a telegram bot with a single commnad like:

```
python3 sendmessage.py "Message!"
```

## Requisites

You must have a bot on telegram and get your Token for it and discover your chat_id.

## Preparations

You must add a `.env` file with the following informations:

```
TOKEN=123456789:ABCDefghIjKlmnOPQrsTUVwxyZ
CHAT_ID=123456789
```

You may want to set some restricted permitions to this file by typing:

```
chmod 600 .env
```

## Recomendation

I added on my .bashrc this:

```
# Telegram bot command
sendme() {python3 $afs/projects/personal/telegrambot/sendmessage.py "$@"}
```

Now, I can just type on terminal:

```
sendme "Message!"
```

And it will work! :)
