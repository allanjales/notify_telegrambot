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

	# Get infos
	local host="$(hostname -s)"
	local cwd=$PWD
	local git_branch=$(git branch --show-current 2>/dev/null)
	local git_info=""
	[ -n "$git_branch" ] && git_info="\n🌿 Branch: <code>$git_branch</code>"
	
	local text="▶️ Started running"
	text="${text}\n<pre language=sh>$*</pre>"
	text="${text}\n🖥️ Host: <code>$host</code>"
	text="${text}\n📂 CWD: <code>$cwd</code>"
	text="${text}${git_info}"
	sendme "$text"

	# Run command and capture output
	local start_time=$SECONDS
	local tmp_log=$(mktemp)

	bash -lc "$*" 2>&1 | tee "$tmp_log"
	local status=${PIPESTATUS[0]}

	local end_time=$SECONDS
	local total_seconds=$((end_time - start_time))

	# Seconds to human-readable format
	local h=$((total_seconds / 3600))
	local m=$(( (total_seconds % 3600) / 60 ))
	local s=$((total_seconds % 60))
	local duration=""
	[ $h -gt 0 ] && duration+="${h}h "
	[ $m -gt 0 ] || [ $h -gt 0 ] && duration+="${m}m "
	duration+="${s}s"

	# Get last output and status
	local last_output=$(tail -n 5 "$tmp_log")
	local emoji="✅"
	[ $status -ne 0 ] && emoji="❌"

	text="$emoji Finished running"
	text="${text}\n<pre language=sh>$*</pre>"
	text="${text}\n⏱️ Duration: $duration"
	text="${text}\n🖥️ Host: <code>$host</code>"
	text="${text}\n📂 CWD: <code>$cwd</code>"
	text="${text}${git_info}"
	text="${text}\n📄 Last Output:<pre language=textile>$last_output</pre>"
	sendme "$text"

	# Remove temporary file and return status
	rm -f "$tmp_log"
	return $status
}