#!/bin/bash

# CloudCurio StackHub Setup Script
# This script automates the setup process for CloudCurio StackHub

echo "CloudCurio StackHub Setup Script"
echo "================================="

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
echo "Checking for required tools..."
if ! command_exists git; then
    echo "Error: Git is not installed. Please install Git and try again."
    exit 1
fi

if ! command_exists node; then
    echo "Error: Node.js is not installed. Please install Node.js and try again."
    exit 1
fi

if ! command_exists npm; then
    echo "Error: npm is not installed. Please install npm and try again."
    exit 1
fi

echo "All required tools are installed."

# Initialize git repository (if not already done)
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit: CloudCurio StackHub with agents.md, qwen.md, and tasks.md"
else
    echo "Git repository already initialized."
fi

# Install dependencies
echo "Installing dependencies..."
cd apps/web
npm install

# Go back to root directory
cd ../..

# Display setup summary
echo ""
echo "Setup Complete!"
echo "==============="
echo "The following steps need to be done manually:"
echo "1. Create repositories on GitHub and GitLab"
echo "2. Add remotes and push code:"
echo "   git remote add origin https://github.com/yourusername/cloudcurio-stackhub.git"
echo "   git remote add gitlab https://gitlab.com/yourusername/cloudcurio-stackhub.git"
echo "   git push -u origin main"
echo "   git push -u gitlab main"
echo ""
echo "3. To start the development server, run:"
echo "   cd apps/web"
echo "   npm run dev"
echo "   Then open http://localhost:3000 in your browser"
echo ""
echo "4. For Cloudflare deployment, follow the instructions in CLOUDFLARE_DEPLOYMENT.md"