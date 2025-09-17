#!/bin/bash

# CloudCurio StackHub Repository Setup Script
# This script helps set up SSH keys and push to GitHub and GitLab

echo "CloudCurio StackHub Repository Setup Script"
echo "========================================="

# Check if we're in the correct directory
if [ ! -f "README.md" ]; then
    echo "Error: Please run this script from the root of the cloudcurio-stackhub directory"
    exit 1
fi

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Error: Git is not installed. Please install Git and try again."
    exit 1
fi

# Check if SSH key exists
if [ ! -f ~/.ssh/id_rsa.pub ] && [ ! -f ~/.ssh/id_ed25519.pub ]; then
    echo "No SSH key found. Let's generate one:"
    echo "1. Press Enter to accept the default file location"
    echo "2. Optionally enter a passphrase for extra security (or leave empty)"
    ssh-keygen -t ed25519 -C "blaine.winslow@gmail.com"
else
    echo "SSH key already exists."
fi

# Display SSH key for GitHub
echo ""
echo "=== GitHub SSH Setup ==="
echo "1. Copy the following SSH key:"
if [ -f ~/.ssh/id_ed25519.pub ]; then
    cat ~/.ssh/id_ed25519.pub
elif [ -f ~/.ssh/id_rsa.pub ]; then
    cat ~/.ssh/id_rsa.pub
fi
echo ""
echo "2. Go to https://github.com/settings/keys"
echo "3. Click 'New SSH key'"
echo "4. Give it a title like 'CloudCurio StackHub'"
echo "5. Paste the key and click 'Add SSH key'"

# Display SSH key for GitLab
echo ""
echo "=== GitLab SSH Setup ==="
echo "1. Copy the same SSH key above"
echo "2. Go to https://gitlab.com/-/profile/keys"
echo "3. Give it a title like 'CloudCurio StackHub'"
echo "4. Paste the key and click 'Add key'"

# Update git remotes to use SSH instead of HTTPS
echo ""
echo "=== Updating Git Remotes to SSH ==="
echo "Updating GitHub remote..."
git remote set-url origin git@github.com:cbwinslow/cloudcurio-stackhub.git

echo "Updating GitLab remote..."
git remote set-url gitlab git@gitlab.com:cbwinslow/cloudcurio-stackhub.git

# Test SSH connections
echo ""
echo "=== Testing SSH Connections ==="
echo "Testing GitHub connection..."
ssh -T git@github.com 2>&1 | grep -E "(successfully authenticated|Welcome)" || echo "GitHub SSH test completed (you may see a permission message, which is normal)"

echo "Testing GitLab connection..."
ssh -T git@gitlab.com 2>&1 | grep -E "(Welcome|successfully authenticated)" || echo "GitLab SSH test completed (you may see a permission message, which is normal)"

# Push to repositories
echo ""
echo "=== Pushing to Repositories ==="
echo "Pushing to GitHub..."
git push -u origin master

if [ $? -eq 0 ]; then
    echo "Successfully pushed to GitHub!"
else
    echo "Failed to push to GitHub. You may need to:"
    echo "1. Ensure you've added your SSH key to GitHub"
    echo "2. Try running: git push -u origin master"
fi

echo "Pushing to GitLab..."
git push -u gitlab master

if [ $? -eq 0 ]; then
    echo "Successfully pushed to GitLab!"
else
    echo "Failed to push to GitLab. You may need to:"
    echo "1. Ensure you've added your SSH key to GitLab"
    echo "2. Try running: git push -u gitlab master"
fi

echo ""
echo "Setup process completed!"
echo "If you had any issues with pushing, please follow the manual steps above."