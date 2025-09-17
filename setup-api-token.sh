#!/bin/bash

# API Token Setup Script
# This script helps you check and set up your Cloudflare API token

echo "Cloudflare API Token Setup Script"
echo "=============================="

echo "Current API Token Status:"
echo "========================"
if [ -n "$CLOUDFLARE_API_TOKEN" ]; then
    echo "✓ CLOUDFLARE_API_TOKEN is set"
    echo "Token: ${CLOUDFLARE_API_TOKEN:0:5}...${CLOUDFLARE_API_TOKEN: -5}"
else
    echo "✗ CLOUDFLARE_API_TOKEN is not set"
fi

echo ""
echo "To fix the permissions issue, you need to create a new API token with the correct permissions:"
echo ""
echo "Step 1: Create a new API token"
echo "============================"
echo "1. Go to: https://dash.cloudflare.com/profile/api-tokens"
echo "2. Click 'Create Token'"
echo "3. Choose 'Custom Token'"
echo "4. Give it a name like 'StackHub-Worker-Token'"
echo "5. Set permissions:"
echo "   - Zone Resources: Include:All zones"
echo "   - Account Resources: Include:All accounts"
echo "   - Permissions:"
echo "     * Workers Scripts:Edit"
echo "     * D1:Edit"
echo "     * Analytics Engine:Edit"
echo "6. Click 'Continue to summary' and then 'Create Token'"
echo "7. Copy the API token (you won't see it again)"
echo ""
read -p "Have you created a new API token? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Enter your new API token: " new_token
    
    # Set the new token for the current session
    export CLOUDFLARE_API_TOKEN=$new_token
    
    # Add it to .bashrc for future sessions
    echo "export CLOUDFLARE_API_TOKEN=$new_token" >> ~/.bashrc
    
    echo ""
    echo "Environment variable set for current session and added to ~/.bashrc"
    
    echo ""
    echo "Step 2: Test Authentication"
    echo "========================="
    echo "Testing Wrangler authentication..."
    if npx wrangler whoami >/dev/null 2>&1; then
        echo "✓ Authentication successful!"
        echo ""
        echo "Step 3: Try Deploying Again"
        echo "========================="
        echo "Now try deploying with:"
        echo "npx wrangler deploy --config infrastructure/cloudflare/wrangler-minimal.toml"
    else
        echo "✗ Authentication failed. Please check your API token and try again."
    fi
else
    echo "Please create a new API token with the correct permissions and run this script again."
fi