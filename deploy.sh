#!/bin/bash

# CloudCurio StackHub Deployment Script
# This script contains commands for deploying CloudCurio StackHub to various platforms

echo "CloudCurio StackHub Deployment Script"
echo "===================================="

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
    echo "Warning: Git is not installed. You'll need to manually set up repositories."
fi

if ! command_exists node; then
    echo "Warning: Node.js is not installed. You'll need to install it to run the application."
fi

if ! command_exists npm; then
    echo "Warning: npm is not installed. You'll need to install it to run the application."
fi

echo ""
echo "=== GitHub Setup ==="
echo "# 1. Create a new repository on GitHub at https://github.com/new"
echo "# 2. Name it 'cloudcurio-stackhub'"
echo "# 3. Do NOT initialize with a README, .gitignore, or license"
echo "# 4. Run these commands:"
echo "git remote add origin https://github.com/YOUR_USERNAME/cloudcurio-stackhub.git"
echo "git branch -M main"
echo "git push -u origin main"
echo ""

echo "=== GitLab Setup ==="
echo "# 1. Create a new project on GitLab at https://gitlab.com/projects/new"
echo "# 2. Name it 'cloudcurio-stackhub'"
echo "# 3. Do NOT initialize with a README, .gitignore, or license"
echo "# 4. Run these commands:"
echo "git remote add gitlab https://gitlab.com/YOUR_USERNAME/cloudcurio-stackhub.git"
echo "git push -u gitlab main"
echo ""

echo "=== Cloudflare Pages Deployment ==="
echo "# 1. Go to the Cloudflare dashboard"
echo "# 2. Navigate to Pages"
echo "# 3. Click 'Create a project'"
echo "# 4. Connect to your Git provider (GitHub or GitLab)"
echo "# 5. Select the 'cloudcurio-stackhub' repository"
echo "# 6. Configure the build settings:"
echo "#    - Build command: cd apps/web && npm install && npm run build"
echo "#    - Build output directory: .next"
echo "# 7. Click 'Save and Deploy'"
echo ""

echo "=== Local Development ==="
echo "# To run the development server:"
echo "cd apps/web"
echo "npm install"
echo "npm run dev"
echo "# Open http://localhost:3000 in your browser"
echo ""

echo "=== Cloudflare Workers (Optional) ==="
echo "# To deploy the Workers API:"
echo "# 1. Install Wrangler: npm install -g wrangler"
echo "# 2. Authenticate: wrangler login"
echo "# 3. Update the wrangler.toml file with your D1 database ID"
echo "# 4. Deploy: wrangler deploy"
echo ""

echo "=== D1 Database Setup (Optional) ==="
echo "# To create and configure a D1 database:"
echo "# 1. Create a new D1 database in the Cloudflare dashboard"
echo "# 2. Update the database ID in infrastructure/cloudflare/wrangler.toml"
echo "# 3. Apply the schema: wrangler d1 execute stackhub_db --file=infrastructure/cloudflare/d1/schema.sql"