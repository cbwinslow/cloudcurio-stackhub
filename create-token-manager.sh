#!/bin/bash

# API Token Management Script
# This script helps create a token with permissions to manage API tokens

echo "API Token Management Script"
echo "======================"

echo "To create a token with permissions to manage API tokens:"

echo ""
echo "1. Go to: https://dash.cloudflare.com/profile/api-tokens"
echo "2. Click 'Create Token'"
echo "3. Choose 'Custom Token'"
echo "4. Give it a name like 'Token-Manager'"
echo "5. Set permissions:"
echo "   - Zone Resources: Include:All zones"
echo "   - Account Resources: Include:All accounts"
echo "   - Permissions:"
echo "     * API Tokens:Edit"
echo "     * User:Read"
echo "6. Click 'Continue to summary' and then 'Create Token'"
echo "7. Copy the API token"

echo ""
echo "Once you have this token, we can use it to modify the permissions of your deployment token."
echo "Your deployment token is: o06OEmL7UVyGogNB2rSpofass8RNn9BO95FAg389"