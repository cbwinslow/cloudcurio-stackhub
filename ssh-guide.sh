#!/bin/bash

# SSH Key Addition Guide Script
# This script guides you through adding your SSH key to GitHub and GitLab

echo "SSH Key Addition Guide"
echo "====================="

# Display the public key
echo "Your public SSH key is:"
echo "======================"
cat ~/.ssh/id_ed25519.pub
echo "======================"
echo ""

# GitHub instructions
echo "GitHub Instructions:"
echo "==================="
echo "1. Copy the public SSH key above"
echo "2. Go to https://github.com/settings/keys"
echo "3. Click 'New SSH key'"
echo "4. Title: CloudCurio StackHub"
echo "5. Key type: Authentication Key"
echo "6. Paste the key and click 'Add SSH key'"
echo ""

# GitLab instructions
echo "GitLab Instructions:"
echo "==================="
echo "1. Copy the same public SSH key above"
echo "2. Go to https://gitlab.com/-/profile/keys"
echo "3. Title: CloudCurio StackHub"
echo "4. Paste the key and click 'Add key'"
echo ""

# Test connections
echo "After adding the key to both accounts, test the connections:"
echo "========================================================="
echo "Test GitHub connection: ssh -T git@github.com"
echo "Test GitLab connection: ssh -T git@gitlab.com"
echo ""

echo "Once both connections work, you can run the repository setup scripts:"
echo "===================================================================="
echo "./complete-setup.sh    # For both GitHub and GitLab"
echo "./github-setup.sh      # For GitHub only"
echo "./gitlab-setup.sh      # For GitLab only"
echo ""