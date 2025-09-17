#!/bin/bash

# Cloudflare Authentication Setup Script
# This script helps set up authentication for Wrangler on a remote server

echo "Cloudflare Authentication Setup Script"
echo "==================================="

echo "This script will help you set up authentication for Wrangler on your remote server."
echo ""

echo "Step 1: Create an API Token"
echo "========================="
echo "1. Go to Cloudflare Dashboard: https://dash.cloudflare.com/profile/api-tokens"
echo "2. Click 'Create Token'"
echo "3. Choose 'Custom Token'"
echo "4. Give it a name like 'StackHub-Worker-Token'"
echo "5. Set permissions:"
echo "   - Zone Resources: Include:All zones"
echo "   - Account Resources: Include:All accounts"
echo "   - Permissions:"
echo "     * Workers Scripts:Edit"
echo "     * Workers KV Storage:Edit"
echo "     * D1:Edit"
echo "     * Analytics Engine:Edit"
echo "6. Click 'Continue to summary' and then 'Create Token'"
echo "7. Copy the API token (you won't see it again)"
echo ""
read -p "Press Enter after creating and copying your API token..."

echo ""
echo "Step 2: Set Environment Variable"
echo "=============================="
read -p "Enter your Cloudflare API token: " api_token

# Set the environment variable for the current session
export CLOUDFLARE_API_TOKEN=$api_token

# Add it to .bashrc for future sessions
echo "export CLOUDFLARE_API_TOKEN=$api_token" >> ~/.bashrc

echo ""
echo "Environment variable set for current session and added to ~/.bashrc"

echo ""
echo "Step 3: Test Authentication"
echo "========================="
echo "Testing Wrangler authentication..."
if npx wrangler whoami >/dev/null 2>&1; then
    echo "✓ Authentication successful!"
    echo "You can now run the full setup script: ./full-setup.sh"
else
    echo "✗ Authentication failed. Please check your API token and try again."
    echo "You can manually set the token with: export CLOUDFLARE_API_TOKEN=your-token-here"
fi