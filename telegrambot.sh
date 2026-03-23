TELEGRAMBOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Telegram bot send message to target
sendme() { python3 $TELEGRAMBOT_DIR/sendmessage.py "$@"; }

# Telegram bot send message upon beginning and ending a task
notifyme() {
        # Need arguments
        if [ $# -eq 0 ]; then
                echo "Use: notifyme <command ...>"
                return 1
        fi

        local host="$(hostname -s)"
        local cwd=$PWD
        sendme "▶️ Started running\n<pre language=ba>$*</pre>\n🖥️ Host: $host\n📂 CWD: $cwd"

        bash -lc "$*"
        local status=$?
        local emoji="✅"
        [ $status -ne 0 ] && emoji="❌"
        sendme "$emoji Finished running\n<pre language=sh>$*</pre>\n🖥️ Host: $host\n📂 CWD: $cwd"

        return $status
}
