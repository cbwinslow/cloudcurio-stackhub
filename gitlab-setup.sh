#!/bin/bash

# Complete GitLab Setup Script
# This script handles everything from SSH key generation to pushing to GitLab

echo "Complete GitLab Setup Script"
echo "=========================="

# Check if we're in the correct directory
if [ ! -f "README.md" ]; then
    echo "Error: Please run this script from the root of the cloudcurio-stackhub directory"
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required tools
if ! command_exists git; then
    echo "Error: Git is not installed. Please install Git and try again."
    exit 1
fi

if ! command_exists ssh-keygen; then
    echo "Error: ssh-keygen is not available. Please install OpenSSH and try again."
    exit 1
fi

# Generate SSH key if it doesn't exist
if [ ! -f ~/.ssh/id_rsa ] && [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "Generating new SSH key..."
    ssh-keygen -t ed25519 -C "blaine.winslow@gmail.com" -f ~/.ssh/id_ed25519 -N ""
    echo "SSH key generated successfully!"
else
    echo "SSH key already exists."
fi

# Start ssh-agent and add SSH key
echo "Starting ssh-agent and adding SSH key..."
eval "$(ssh-agent -s)" > /dev/null
if [ -f ~/.ssh/id_ed25519 ]; then
    ssh-add ~/.ssh/id_ed25519
else
    ssh-add ~/.ssh/id_rsa
fi

# Display public key for user to add to GitLab
echo ""
echo "=== Add this SSH key to your GitLab account ==="
echo "1. Go to https://gitlab.com/-/profile/keys"
echo "2. Title: CloudCurio StackHub Setup"
echo "3. Copy and paste the key below into the 'Key' field:"
echo ""
if [ -f ~/.ssh/id_ed25519.pub ]; then
    cat ~/.ssh/id_ed25519.pub
elif [ -f ~/.ssh/id_rsa.pub ]; then
    cat ~/.ssh/id_rsa.pub
fi
echo ""
echo "================================================"
echo ""
read -p "Press Enter after you've added the SSH key to GitLab..."

# Test SSH connection to GitLab
echo "Testing SSH connection to GitLab..."
ssh -T git@gitlab.com 2>&1 | grep -E "(successfully authenticated|Welcome)" || {
    echo "SSH connection test completed. If you see a permission message, that's normal."
}

# Set up git configuration
echo "Setting up git configuration..."
git config --global user.name "cbwinslow"
git config --global user.email "blaine.winslow@gmail.com"

# Initialize repository if not already done
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit: CloudCurio StackHub"
fi

# Set up GitLab remote
echo "Setting up GitLab remote..."
git remote remove gitlab 2>/dev/null
git remote add gitlab git@gitlab.com:cbwinslow/cloudcurio-stackhub.git

# Check if branch is named master or main
BRANCH_NAME="master"
if git branch | grep -q "main"; then
    BRANCH_NAME="main"
fi

# Push to GitLab
echo "Pushing to GitLab..."
git push -u gitlab $BRANCH_NAME

if [ $? -eq 0 ]; then
    echo "Successfully pushed to GitLab!"
    echo "Your repository is now available at: https://gitlab.com/cbwinslow/cloudcurio-stackhub"
else
    echo "Failed to push to GitLab."
    echo "Please make sure:"
    echo "1. You've added the SSH key to your GitLab account"
    echo "2. The project 'cloudcurio-stackhub' exists on GitLab"
    echo "3. You have write permissions to the project"
fi

echo ""
echo "Setup complete!"