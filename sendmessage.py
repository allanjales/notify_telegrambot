import os
import requests
import argparse

def load_env(filename=".env"):
    script_dir = os.path.dirname(os.path.realpath(__file__))
    filepath = os.path.join(script_dir, filename)

    env_vars = {}
    if not os.path.exists(filepath):
        raise FileNotFoundError(f"{filepath} not found")

    with open(filepath) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            key, value = line.split("=", 1)
            env_vars[key.strip()] = value.strip()
            os.environ[key.strip()] = value.strip()
    return env_vars

def send_telegram_message(token, chat_id, text):
    url = f"https://api.telegram.org/bot{token}/sendMessage"
    payload = {"chat_id": chat_id, "text": text}
    response = requests.post(url, data=payload)
    
    if response.status_code == 200:
        print("Message sent successfully ✅")
    else:
        print("Failed to send message:", response.text)

if __name__ == "__main__":
    # Load environment variables
    env = load_env()
    TOKEN = env["TOKEN"]
    CHAT_ID = env["CHAT_ID"]

    if not TOKEN or not CHAT_ID:
        raise ValueError("TOKEN and CHAT_ID not found in .env file")

    # Parse command-line arguments
    parser = argparse.ArgumentParser(description="Send a message via Telegram bot")
    parser.add_argument("message", type=str, help="The message to send")
    args = parser.parse_args()

    # Send the message
    send_telegram_message(TOKEN, CHAT_ID, args.message)
