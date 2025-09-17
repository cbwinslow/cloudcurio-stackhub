#!/bin/bash

# D1 Database Setup Script
# This script helps set up the D1 database for CloudCurio StackHub

echo "D1 Database Setup Script"
echo "======================"

echo "To create the D1 database, you have two options:"
echo ""
echo "Option 1: Using Cloudflare Dashboard (Recommended)"
echo "================================================"
echo "1. Go to Cloudflare Dashboard: https://dash.cloudflare.com"
echo "2. Navigate to Workers & Pages > D1"
echo "3. Click 'Create database'"
echo "4. Enter database name: stackhub_db"
echo "5. Click 'Create'"
echo "6. Note the database ID from the database details page"
echo ""
echo "Option 2: Using Wrangler (if API token has correct permissions)"
echo "=============================================================="
echo "Run this command:"
echo "npx wrangler d1 create stackhub_db"
echo ""
echo "After creating the database:"
echo "=========================="
echo "1. Update the wrangler.toml file:"
echo "   - Replace 'REPLACE_WITH_YOUR_D1_ID' with your actual database ID"
echo "2. Apply the database schema:"
echo "   npx wrangler d1 execute stackhub_db --file=infrastructure/cloudflare/d1/schema.sql --config infrastructure/cloudflare/wrangler.toml"
echo ""
echo "Note: Your API token needs D1:Edit permission to create databases."
echo "If you're having permission issues, check your token permissions at:"
echo "https://dash.cloudflare.com/968ff4ee9f5e59bc6c72758269d6b9d6/api-tokens"