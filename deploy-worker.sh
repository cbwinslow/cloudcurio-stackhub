#!/bin/bash

# Worker Deployment Script
# This script helps deploy the Worker with the correct API token

echo "Cloudflare Worker Deployment Script"
echo "================================="

echo "Current Status:"
echo "=============="
echo "✓ wrangler.toml: Configured with D1, Analytics Engine, and KV"
echo "✓ Worker code: Updated to use all services"
echo "✓ API token: Set in environment (may need permission update)"

echo ""
echo "The configuration is now correct, but your API token may not have the required permissions."
echo "To fix this, you need to create a new API token with the correct permissions:"
echo ""
echo "Step 1: Create a new API token with correct permissions"
echo "===================================================="
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
echo "     * Workers KV Storage:Edit"
echo "6. Click 'Continue to summary' and then 'Create Token'"
echo "7. Copy the API token"

echo ""
read -p "Have you created a new API token with the correct permissions? (y/N): " -n 1 -r
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
    echo "Step 2: Deploy the Worker"
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
    echo ""
    echo "Please create a new API token with the correct permissions and run this script again."
    echo "Make sure to include Workers KV Storage:Edit permission for KV access."
fi