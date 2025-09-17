#!/bin/bash

# CloudCurio StackHub Final Push Script
# This script pushes the code to GitHub and GitLab after SSH keys are set up

echo "CloudCurio StackHub Final Push Script"
echo "==================================="

# Check if we're in the correct directory
if [ ! -f "README.md" ]; then
    echo "Error: Please run this script from the root of the cloudcurio-stackhub directory"
    exit 1
fi

echo "This script assumes you have already:"
echo "1. Added your SSH key to your GitHub account"
echo "2. Added your SSH key to your GitLab account"
echo ""
echo "If you haven't done this yet, please:"
echo "1. Go to https://github.com/settings/keys and add your SSH key"
echo "2. Go to https://gitlab.com/-/profile/keys and add your SSH key"
echo ""
read -p "Press Enter to continue once you've added your SSH keys, or Ctrl+C to cancel..."

# Push to GitHub
echo "Pushing to GitHub..."
git push -u origin master

if [ $? -eq 0 ]; then
    echo "Successfully pushed to GitHub!"
else
    echo "Failed to push to GitHub."
    echo "Try running this command manually:"
    echo "git push -u origin master"
fi

# Push to GitLab
echo "Pushing to GitLab..."
git push -u gitlab master

if [ $? -eq 0 ]; then
    echo "Successfully pushed to GitLab!"
else
    echo "Failed to push to GitLab."
    echo "Try running this command manually:"
    echo "git push -u gitlab master"
fi

echo ""
echo "Push process completed!"
echo "If you still have issues, please make sure:"
echo "1. Your SSH keys are properly added to your GitHub and GitLab accounts"
echo "2. Your repositories exist on GitHub and GitLab"
echo "3. Your repository names are exactly 'cloudcurio-stackhub'"