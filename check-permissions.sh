#!/bin/bash

# API Token Permissions Check Script
# This script helps check if your API token has the required permissions

echo "API Token Permissions Check Script"
echo "================================"

echo "Checking if your API token has the required permissions..."
echo ""

# Check D1 permissions
echo "1. Checking D1 permissions..."
echo "   Required: D1:Edit"
echo "   To check manually, visit:"
echo "   https://dash.cloudflare.com/968ff4ee9f5e59bc6c72758269d6b9d6/api-tokens"
echo ""

# Check Workers permissions
echo "2. Checking Workers permissions..."
echo "   Required: Workers Scripts:Edit"
echo ""

# Check Analytics Engine permissions
echo "3. Checking Analytics Engine permissions..."
echo "   Required: Analytics Engine:Edit"
echo ""

echo "To verify your token permissions:"
echo "1. Go to: https://dash.cloudflare.com/968ff4ee9f5e59bc6c72758269d6b9d6/api-tokens"
echo "2. Find your token in the list"
echo "3. Click the '•••' menu next to your token and select 'Permissions'"
echo "4. Verify that it has the required permissions listed above"
echo ""
echo "If any permissions are missing, you'll need to create a new token with the correct permissions."