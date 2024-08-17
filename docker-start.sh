#!/bin/bash

# Export useful ENV variables, including all Runpod specific vars, to /etc/rp_environment
# This file can then later be sourced in a login shell
echo "Exporting environment variables..."
printenv |
	grep -E '^RUNPOD_|^PATH=|^HF_HOME=|^HUGGING_FACE_HUB_TOKEN=|^_=' |
	sed 's/^\(.*\)=\(.*\)$/export \1="\2"/' >>/etc/rp_environment

# Add it to Bash login script
echo 'source /etc/rp_environment' >>~/.bashrc

# Vast.ai uses $SSH_PUBLIC_KEY
if [[ $SSH_PUBLIC_KEY ]]; then
	PUBLIC_KEY="${SSH_PUBLIC_KEY}"
fi

# Runpod uses $PUBLIC_KEY
if [[ $PUBLIC_KEY ]]; then
	mkdir -p ~/.ssh
	chmod 700 ~/.ssh
	echo "${PUBLIC_KEY}" >>~/.ssh/authorized_keys
	chmod 700 -R ~/.ssh
fi

# Start SSH server
service ssh start

sleep infinity