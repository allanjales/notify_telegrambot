#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ENV_FILE="$SCRIPT_DIR/.env"
BASHRC_FILE="$HOME/.bashrc"
BOT_SCRIPT="$SCRIPT_DIR/telegrambot.sh"

echo "========================================"
echo "       Setup Notify Telegram Bot"
echo "========================================"
echo ""

read -p "Your Telegram bot TOKEN: " token
read -p "Your Telegram CHAT_ID: " chat_id

NEW_CONTENT="TOKEN=$token\nCHAT_ID=$chat_id"

# Method for write/overwrite file
write_env() {
	echo -e "$NEW_CONTENT" > "$1"
	chmod 600 "$1"
}

# .env file handling
if [ -f "$ENV_FILE" ]; then
	
	echo ""
	read -p "⚠️ .env file already exists. Do you want to overwrite it? (y/n): " overwrite

	if [[ "$overwrite" =~ ^[Ss]$ ]]; then
		# Creates a temporary file whihch is removed on exit or interrupt
		TMP_ENV=$(mktemp)
		trap "rm -f '$TMP_ENV'" EXIT INT
		write_env "$TMP_ENV"
		
		# Show differences
		echo ""
		echo "🔍 Difference between the current .env and the new:"
		echo "----------------------------------------"
		diff -u "$ENV_FILE" "$TMP_ENV" || true 
		echo "----------------------------------------"
		
		# Confirmation
		read -p "Confirm the replacement? (y/n): " confirm
		if [[ "$confirm" =~ ^[Yy]$ ]]; then
			mv "$TMP_ENV" "$ENV_FILE"
			echo "✅ .env file updated successfully!"
		else
			echo "❌ Overwrite canceled. Keeping the original .env file."
		fi
	else
		echo "✅ Keeping the original .env file."
	fi
else
	write_env "$ENV_FILE"
	echo "✅ .env file created successfully!"
fi

echo ""
echo "========================================"

# .bashrc file handling
if grep -q "source.*$BOT_SCRIPT" "$BASHRC_FILE"; then
	echo "ℹ️ The teletegrambot.sh seems to be already configured in your ~/.bashrc."
else
	read -p "Want to add telegrambot.sh to your ~/.bashrc for automatic loading? (y/n): " add_bashrc
	if [[ "$add_bashrc" =~ ^[Yy]$ ]]; then
		echo "" >> "$BASHRC_FILE"
		echo "# Telegram Bot Notify" >> "$BASHRC_FILE"
		echo "source \"$BOT_SCRIPT\"" >> "$BASHRC_FILE"
		echo "✅ Added source line to ~/.bashrc successfully!"
		echo "⚠️ remember to run 'source ~/.bashrc' or reopen the terminal for the commands to work."
	else
		echo "ℹ️  You chose not to add to ~/.bashrc."
		echo "Remember to run 'source telegrambot.sh' manually."
	fi
fi

echo ""
echo "🎉 Setup finished! Have fun! :)"