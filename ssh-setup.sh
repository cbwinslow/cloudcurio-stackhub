#!/bin/bash

# SSH Key Setup Script
# This script generates new SSH keys with the correct email address

echo "SSH Key Setup Script"
echo "==================="

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required tools
if ! command_exists ssh-keygen; then
    echo "Error: ssh-keygen is not available. Please install OpenSSH and try again."
    exit 1
fi

# Remove existing SSH keys (with confirmation)
if [ -f ~/.ssh/id_ed25519 ] || [ -f ~/.ssh/id_rsa ]; then
    echo "Existing SSH keys found:"
    [ -f ~/.ssh/id_ed25519 ] && echo "  - ~/.ssh/id_ed25519"
    [ -f ~/.ssh/id_rsa ] && echo "  - ~/.ssh/id_rsa"
    read -p "Do you want to remove them and generate new ones? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Removing existing SSH keys..."
        rm -f ~/.ssh/id_ed25519 ~/.ssh/id_ed25519.pub ~/.ssh/id_rsa ~/.ssh/id_rsa.pub
        echo "Existing SSH keys removed."
    else
        echo "Keeping existing SSH keys. Exiting."
        exit 0
    fi
fi

# Generate new SSH key with correct email
echo "Generating new SSH key with email: blaine.winslow@gmail.com"
ssh-keygen -t ed25519 -C "blaine.winslow@gmail.com" -f ~/.ssh/id_ed25519 -N ""

if [ $? -eq 0 ]; then
    echo "SSH key generated successfully!"
    echo ""
    echo "Your public SSH key is:"
    echo "======================"
    cat ~/.ssh/id_ed25519.pub
    echo "======================"
    echo ""
    echo "Instructions:"
    echo "1. Copy the public key above"
    echo "2. Add it to your GitHub account:"
    echo "   - Go to https://github.com/settings/keys"
    echo "   - Click 'New SSH key'"
    echo "   - Title: CloudCurio StackHub"
    echo "   - Key type: Authentication Key"
    echo "   - Paste the key and click 'Add SSH key'"
    echo ""
    echo "3. Add it to your GitLab account:"
    echo "   - Go to https://gitlab.com/-/profile/keys"
    echo "   - Title: CloudCurio StackHub"
    echo "   - Paste the key and click 'Add key'"
    echo ""
    echo "Once you've added the key to both accounts, you can run the repository setup scripts."
else
    echo "Failed to generate SSH key."
    exit 1
fi