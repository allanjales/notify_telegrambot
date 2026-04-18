TELEGRAMBOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Telegram bot send message to target
sendme() { python3 $TELEGRAMBOT_DIR/sendmessage.py "$@"; }

# Telegram bot send message upon beginning and ending a task
notifyme()
{
	# Need arguments
	if [ $# -eq 0 ]; then
		echo "Use: notifyme <command ...>"
		return 1
	fi

	# Seconds to human-readable format
	format_time()
	{
		local total_seconds=$1
		local h=$((total_seconds / 3600))
		local m=$(( (total_seconds % 3600) / 60 ))
		local s=$((total_seconds % 60))
		local duration=""
		[ $h -gt 0 ] && duration+="${h}h "
		[ $m -gt 0 ] || [ $h -gt 0 ] && duration+="${m}m "
		duration+="${s}s"

		echo "$duration"
	}

	# Get infos before command execution
	local escaped_cmd=$(echo "$*" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
	local host="$(hostname -s)"
	local cwd=$PWD
	local git_branch=$(git branch --show-current 2>/dev/null)
	local git_info=""
	[ -n "$git_branch" ] && git_info="\n🌿 Branch: <code>$git_branch</code>"
	
	# Send start message
	local text="▶️ Started running"
	text+="\n<pre language=sh>$escaped_cmd</pre>"
	text+="\n🖥️ Host: <code>$host</code>"
	text+="\n📂 CWD: <code>$cwd</code>"
	text+="${git_info}"
	sendme "$text"

	# Run command and capture output
	local start_time=$SECONDS
	local tmp_log=$(mktemp)
	trap "rm -f '$tmp_log'; trap - RETURN" RETURN
	bash -lc "$*" 2>&1 | tee "$tmp_log"

	# Get exit status, last log lines and duration
	local status=${PIPESTATUS[0]}
	local end_time=$SECONDS
	local duration=$(format_time $((end_time - start_time)))

	# Prepare message based on status
	local header="✅ Finished running (Exit code: $status)"
	local lines=10
	if [ $status -eq 0 ]; then
		header="✅ Finished successfully"
		lines=5
	elif [ $status -eq 130 ]; then
		header="🛑 Cancelled (Interrupted)"
	else
		header="❌ Finished with error ($status)"
	fi

	local raw_output=$(tail -n $lines "$tmp_log" 2>/dev/null)
	local escaped_output=$(echo "$raw_output" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')

	# Send end message
	text="$header"
	text+="\n<pre language=sh>$escaped_cmd</pre>"
	text+="\n⏱️ Duration: $duration"
	text+="\n🖥️ Host: <code>$host</code>"
	text+="\n📂 CWD: <code>$cwd</code>"
	text+="${git_info}"
	text+="\n📄 Last output:<pre language=textile>$escaped_output</pre>"
	sendme "$text"

	return $status
}