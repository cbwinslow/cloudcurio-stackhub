#!/bin/bash

# CloudCurio StackHub Push Script
# This script pushes the code to GitHub and GitLab

echo "CloudCurio StackHub Push Script"
echo "=============================="

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

# Check if remotes exist
if ! git remote get-url origin > /dev/null 2>&1; then
    echo "Error: GitHub remote (origin) not found. Please set up the GitHub remote first."
    exit 1
fi

if ! git remote get-url gitlab > /dev/null 2>&1; then
    echo "Error: GitLab remote (gitlab) not found. Please set up the GitLab remote first."
    exit 1
fi

echo "Pushing to GitHub..."
git push -u origin master

if [ $? -eq 0 ]; then
    echo "Successfully pushed to GitHub!"
else
    echo "Failed to push to GitHub. Please check your credentials and network connection."
fi

echo "Pushing to GitLab..."
git push -u gitlab master

if [ $? -eq 0 ]; then
    echo "Successfully pushed to GitLab!"
else
    echo "Failed to push to GitLab. Please check your credentials and network connection."
fi

echo ""
echo "Push process completed!"