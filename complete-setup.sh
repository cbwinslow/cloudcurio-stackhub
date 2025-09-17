#!/bin/bash

# Complete Repository Setup Script
# This script handles everything from SSH key generation to pushing to both GitHub and GitLab

echo "Complete Repository Setup Script"
echo "=============================="

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

# Display public key for user to add to both GitHub and GitLab
echo ""
echo "=== Add this SSH key to your GitHub and GitLab accounts ==="
echo "GitHub:"
echo "1. Go to https://github.com/settings/ssh/new"
echo "2. Title: CloudCurio StackHub Setup"
echo "3. Copy and paste the key below into the 'Key' field:"
echo ""
echo "GitLab:"
echo "1. Go to https://gitlab.com/-/profile/keys"
echo "2. Title: CloudCurio StackHub Setup"
echo "3. Copy and paste the same key below into the 'Key' field:"
echo ""
if [ -f ~/.ssh/id_ed25519.pub ]; then
    cat ~/.ssh/id_ed25519.pub
elif [ -f ~/.ssh/id_rsa.pub ]; then
    cat ~/.ssh/id_rsa.pub
fi
echo ""
echo "============================================================"
echo ""
read -p "Press Enter after you've added the SSH key to both GitHub and GitLab..."

# Test SSH connections
echo "Testing SSH connection to GitHub..."
ssh -T git@github.com 2>&1 | grep -E "(successfully authenticated|Welcome)" || {
    echo "GitHub SSH connection test completed. If you see a permission message, that's normal."
}

echo "Testing SSH connection to GitLab..."
ssh -T git@gitlab.com 2>&1 | grep -E "(successfully authenticated|Welcome)" || {
    echo "GitLab SSH connection test completed. If you see a permission message, that's normal."
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

# Set up remotes
echo "Setting up GitHub remote..."
git remote remove origin 2>/dev/null
git remote add origin git@github.com:cbwinslow/cloudcurio-stackhub.git

echo "Setting up GitLab remote..."
git remote remove gitlab 2>/dev/null
git remote add gitlab git@gitlab.com:cbwinslow/cloudcurio-stackhub.git

# Check if branch is named master or main
BRANCH_NAME="master"
if git branch | grep -q "main"; then
    BRANCH_NAME="main"
fi

# Push to GitHub
echo "Pushing to GitHub..."
git push -u origin $BRANCH_NAME

if [ $? -eq 0 ]; then
    echo "Successfully pushed to GitHub!"
    echo "Your repository is now available at: https://github.com/cbwinslow/cloudcurio-stackhub"
else
    echo "Failed to push to GitHub."
    echo "Please make sure you've added the SSH key to your GitHub account."
fi

# Push to GitLab
echo "Pushing to GitLab..."
git push -u gitlab $BRANCH_NAME

if [ $? -eq 0 ]; then
    echo "Successfully pushed to GitLab!"
    echo "Your repository is now available at: https://gitlab.com/cbwinslow/cloudcurio-stackhub"
else
    echo "Failed to push to GitLab."
    echo "Please make sure you've added the SSH key to your GitLab account."
fi

echo ""
echo "Setup complete!"
echo "If you had any issues, you can run the individual scripts:"
echo "- ./github-setup.sh for GitHub only"
echo "- ./gitlab-setup.sh for GitLab only"