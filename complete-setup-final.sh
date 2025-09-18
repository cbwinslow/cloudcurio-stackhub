#!/bin/bash

# Complete CloudCurio StackHub Setup Script
# This script helps you set up the complete CloudCurio StackHub with all services

echo "Complete CloudCurio StackHub Setup Script"
echo "======================================"

echo "Current Status:"
echo "=============="
echo "✓ API token: Working for basic account access"
echo "✓ D1 database: Confirmed (stackhub_db)"
echo "✓ KV namespace: Confirmed (db_kvstore)"
echo "✗ Worker deployment: API token may need additional permissions"

echo ""
echo "It looks like your API token works for D1 and KV, but may not have Worker deployment permissions."
echo "Let's create a new API token with all the required permissions."

echo ""
echo "Step 1: Create a new API token with all required permissions"
echo "========================================================"
echo "1. Go to: https://dash.cloudflare.com/profile/api-tokens"
echo "2. Click 'Create Token'"
echo "3. Choose 'Custom Token'"
echo "4. Give it a name like 'StackHub-Complete-Token'"
echo "5. Set permissions:"
echo "   - Zone Resources: Include:All zones"
echo "   - Account Resources: Include:All accounts"
echo "   - Permissions:"
echo "     * Workers Scripts:Edit"
echo "     * D1:Edit"
echo "     * Analytics Engine:Edit"
echo "     * Workers KV Storage:Edit"
echo "6. Click 'Continue to summary' and then 'Create Token'"
echo "7. Copy the API token"

echo ""
read -p "Have you created a new API token with all permissions? (y/N): " -n 1 -r
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
    echo "Step 2: Verify the new token works"
    echo "================================"
    if npx wrangler whoami >/dev/null 2>&1; then
        echo "✓ Authentication successful!"
        
        echo ""
        echo "Step 3: Deploy the Worker"
        echo "======================="
        echo "Deploying the Worker with D1, Analytics Engine, and KV..."
        if npx wrangler deploy --config infrastructure/cloudflare/wrangler.toml; then
            echo ""
            echo "✓ Worker deployed successfully!"
            echo ""
            echo "Next steps:"
            echo "1. Note the deployed Worker URL"
            echo "2. Update your Cloudflare Pages environment variables:"
            echo "   - Go to Cloudflare Dashboard > Pages > cloudcurio-stackhub > Settings > Environment Variables"
            echo "   - Add variable:"
            echo "     * Key: NEXT_PUBLIC_API_URL"
            echo "     * Value: Your deployed Worker URL"
            echo "3. Redeploy your Pages project"
        else
            echo ""
            echo "✗ Worker deployment failed. Check the error message above."
        fi
    else
        echo "✗ Authentication failed with new token."
    fi
else
    echo ""
    echo "Please create a new API token with all required permissions and run this script again."
fi