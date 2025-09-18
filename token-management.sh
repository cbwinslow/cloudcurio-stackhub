#!/bin/bash

# Complete Token Management Script
# This script guides you through creating and managing API tokens

echo "Complete Token Management Script"
echo "============================"

echo "Step 1: Create a token with API token management permissions"
echo "======================================================"
./create-token-manager.sh

echo ""
echo "Step 2: Once you have the token manager token, get the permission IDs"
echo "=================================================================="
echo "Run this command with your token manager token:"
echo "node get-permission-ids.js <token-manager-token>"

echo ""
echo "Step 3: Modify your deployment token permissions"
echo "============================================="
echo "Run this command with your token manager token and the deployment token ID:"
echo "node modify-token.js <token-manager-token> <deployment-token-id>"

echo ""
echo "Note: You'll need to find the token ID of your deployment token in the Cloudflare dashboard."
echo "The deployment token is: o06OEmL7UVyGogNB2rSpofass8RNn9BO95FAg389"