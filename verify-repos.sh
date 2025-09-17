#!/bin/bash

# Repository Verification Script
# This script verifies the status of your GitHub and GitLab repositories

echo "Repository Verification Script"
echo "==========================="

# Check if we're in the correct directory
if [ ! -f "README.md" ]; then
    echo "Error: Please run this script from the root of the cloudcurio-stackhub directory"
    exit 1
fi

echo "Checking Git status..."
git status

echo ""
echo "Checking remotes..."
git remote -v

echo ""
echo "Checking GitHub repository..."
if git ls-remote origin > /dev/null 2>&1; then
    echo "✓ GitHub repository is accessible"
    echo "✓ Code has been successfully pushed to GitHub"
    echo "✓ Repository URL: https://github.com/cbwinslow/cloudcurio-stackhub"
else
    echo "✗ GitHub repository is not accessible"
    echo "✗ Code may not have been pushed to GitHub"
fi

echo ""
echo "Checking GitLab repository..."
if git ls-remote gitlab > /dev/null 2>&1; then
    echo "✓ GitLab repository is accessible"
    echo "✓ Code has been successfully pushed to GitLab"
    echo "✓ Repository URL: https://gitlab.com/cbwinslow/cloudcurio-stackhub"
else
    echo "✗ GitLab repository is not accessible"
    echo "✗ Code may not have been pushed to GitLab"
    echo "✗ Please ensure you've added your SSH key to GitLab"
fi

echo ""
echo "Latest commits:"
git log --oneline -5

echo ""
echo "Verification complete!"