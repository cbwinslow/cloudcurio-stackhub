#!/bin/bash

# CloudCurio StackHub Full Setup Script
# This script sets up the complete CloudCurio StackHub with D1 database and Analytics Engine

echo "CloudCurio StackHub Full Setup Script"
echo "==================================="

# Check if we're in the correct directory
if [ ! -f "README.md" ]; then
    echo "Error: Please run this script from the root of the cloudcurio-stackhub directory"
    exit 1
fi

echo "This script will help you set up the complete CloudCurio StackHub with:"
echo "- Cloudflare D1 database for dynamic data management"
echo "- Cloudflare Analytics Engine for usage tracking"
echo "- API Worker for backend functionality"
echo ""

echo "Prerequisites:"
echo "============="
echo "1. Cloudflare account with D1 and Analytics Engine enabled"
echo "2. Wrangler CLI installed: npm install -g wrangler"
echo "3. Authenticated with Cloudflare (see ./wrangler-auth.sh for instructions)"
echo ""
read -p "Press Enter to continue (or Ctrl+C to exit)..."

echo ""
echo "Step 1: Check Wrangler Authentication"
echo "=================================="
echo "Checking if Wrangler is authenticated..."
if npx wrangler whoami >/dev/null 2>&1; then
    echo "✓ Wrangler is already authenticated"
else
    echo "✗ Wrangler is not authenticated"
    echo ""
    echo "Please authenticate Wrangler using one of these methods:"
    echo "1. Run: ./wrangler-auth.sh - for instructions on API token authentication (recommended)"
    echo "2. Run: npx wrangler login - for interactive authentication (requires browser access)"
    echo ""
    echo "After authenticating, run this script again."
    exit 1
fi

echo ""
echo "Step 2: Create D1 Database"
echo "========================"
echo "Creating D1 database 'stackhub_db'..."
npx wrangler d1 create stackhub_db

echo ""
echo "Step 3: Get Database ID"
echo "====================="
echo "Please note the database ID from the output above."
echo "You'll need to update the wrangler.toml file with this ID."
echo ""
read -p "Press Enter after noting the database ID..."

echo ""
echo "Step 4: Update wrangler.toml"
echo "=========================="
echo "Please update the infrastructure/cloudflare/wrangler.toml file:"
echo "1. Replace 'REPLACE_WITH_YOUR_D1_ID' with your actual database ID"
echo "2. Make sure the analytics engine configuration is correct"
echo "3. Save the file"
echo ""
read -p "Press Enter after updating the wrangler.toml file..."

echo ""
echo "Step 5: Apply Database Schema"
echo "=========================="
npx wrangler d1 execute stackhub_db --file=infrastructure/cloudflare/d1/schema.sql --config infrastructure/cloudflare/wrangler.toml

echo ""
echo "Step 6: Deploy the Worker"
echo "======================="
echo "Deploying the API Worker with D1 and Analytics Engine support..."
npx wrangler deploy --config infrastructure/cloudflare/wrangler.toml

echo ""
echo "Step 7: Get Worker URL"
echo "===================="
echo "Please note the deployed Worker URL from the output above."
echo "It will look something like: https://cloudcurio-stackhub-api.YOUR_SUBDOMAIN.workers.dev"
echo ""
read -p "Press Enter after noting the Worker URL..."

echo ""
echo "Step 8: Update Environment Variables"
echo "=================================="
echo "Update your Cloudflare Pages project with these environment variables:"
echo "1. Go to Cloudflare Dashboard > Pages > cloudcurio-stackhub > Settings > Environment Variables"
echo "2. Add variable:"
echo "   - Key: NEXT_PUBLIC_API_URL"
echo "   - Value: Your deployed Worker URL (from the previous step)"
echo ""
read -p "Press Enter after setting the environment variable..."

echo ""
echo "Step 9: Install Seed Script Dependencies"
echo "======================================"
npm install

echo ""
echo "Step 10: Seed the Database"
echo "========================"
echo "Seeding the database with initial data..."
npm run seed

echo ""
echo "Step 11: Redeploy Cloudflare Pages"
echo "================================"
echo "Redeploy your Pages project to use the new API:"
echo "1. Go to Cloudflare Dashboard > Pages > cloudcurio-stackhub > Deployments"
echo "2. Click 'Create deployment'"
echo "3. Select the master branch and deploy"
echo ""

echo "Full setup complete!"
echo "==================="
echo "Your application should now be using Cloudflare D1 database and Analytics Engine."
echo "You can now add, edit, and delete items through the web interface."
echo "Analytics data is being collected in Cloudflare Analytics Engine."