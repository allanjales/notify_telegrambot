# Sendmessage Telegram Bot

This will allow you send messagem by a telegram bot with a single commnad like:

```shell
python3 sendmessage.py "Message!"
```

## Possibilities

The most useful way to use it is sourcing the `telegrambot.sh`file, which allows you to use commands in simple way like

```shell
sendme "Message!"
```

and recieve this exact same message by your telegram bot. But also includes a more elegant command like

```shell
notifyme <command ...>
```

Which will send a message **before** and right **after** the execution of the command with the following informations:

- Exit code status;
- Command executed;
- Duration;
- Current Working Directory (CWD);
- Branch (if it is a git repository);
- Last few lines of output.

## Prerequisites

You must have a **Telegram Bot**.
> If you do not have one, you may create by accessing chatting with [BotFather](https://telegram.me/BotFather) on Telegram.

Once you have a bot, you must have the following infos:
1. Bot Token (informe by [BotFather](https://telegram.me/BotFather);
2. Your chat_id. The best way to get this one is sending any message for [Json Dump Bot](https://t.me/JsonDumpBot) and looking for your chat_id there.

## Setup

You must create a `.env` file aside of this README with the following informations:

```
TOKEN=123456789:ABCDefghIjKlmnOPQrsTUVwxyZ
CHAT_ID=123456789
```
> Please remember setting your TOKEN and CHAT_ID

You may want to set some restricted permitions to this file by typing:

```
chmod 600 .env
```

This command allows only the owner of the file (you) to edit or read it since it has some kind of sensitve content.

## Sourcing

To source the file, go to this folder and run on it:

```shell
echo "source $(pwd)/telegrambot.sh" >> ~/.bashrc
source ~/.bashrc
```

It will grant the command of this project be available to you everytime you open the terminal by including it on your `~/.bashrc` file and sourcing it.

Have fun! :)