#!/bin/bash

# Complete CloudCurio StackHub Setup Script
# This script guides you through the complete setup process

echo "Complete CloudCurio StackHub Setup Script"
echo "======================================"

# Check if we're in the correct directory
if [ ! -f "README.md" ]; then
    echo "Error: Please run this script from the root of the cloudcurio-stackhub directory"
    exit 1
fi

echo "This script will guide you through setting up the complete CloudCurio StackHub with:"
echo "- Cloudflare D1 database for dynamic data management"
echo "- Cloudflare Analytics Engine for usage tracking"
echo "- API Worker for backend functionality"
echo ""

echo "Step 1: Verify Authentication"
echo "============================"
echo "Checking Wrangler authentication..."
if export CLOUDFLARE_API_TOKEN=gKob2mQisfZo4JlzOmNct1VR9IEK0rn2rTFM4hH0 && npx wrangler whoami >/dev/null 2>&1; then
    echo "✓ Authentication successful"
else
    echo "✗ Authentication failed"
    echo "Please check your API token and permissions."
    exit 1
fi

echo ""
echo "Step 2: Create D1 Database"
echo "========================"
echo "You need to create the D1 database. You have two options:"
echo ""
echo "Option 1: Create via Cloudflare Dashboard (Recommended)"
echo "1. Go to: https://dash.cloudflare.com"
echo "2. Navigate to Workers & Pages > D1"
echo "3. Click 'Create database'"
echo "4. Enter database name: stackhub_db"
echo "5. Click 'Create'"
echo "6. Note the database ID from the database details page"
echo ""
echo "Option 2: Create via Wrangler (if permissions allow)"
echo "Run: npx wrangler d1 create stackhub_db"
echo ""
read -p "Have you created the D1 database? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Please create the D1 database first, then run this script again."
    exit 1
fi

echo ""
echo "Step 3: Update wrangler.toml"
echo "=========================="
read -p "Enter your D1 database ID: " db_id

# Update the wrangler.toml file with the database ID
sed -i "s/database_id = \"REPLACE_WITH_YOUR_D1_ID\"/database_id = \"$db_id\"/g" infrastructure/cloudflare/wrangler.toml

echo "Updated wrangler.toml with database ID: $db_id"

echo ""
echo "Step 4: Apply Database Schema"
echo "=========================="
echo "Applying the database schema..."
if export CLOUDFLARE_API_TOKEN=gKob2mQisfZo4JlzOmNct1VR9IEK0rn2rTFM4hH0 && npx wrangler d1 execute stackhub_db --file=infrastructure/cloudflare/d1/schema.sql --config infrastructure/cloudflare/wrangler.toml; then
    echo "✓ Database schema applied successfully"
else
    echo "✗ Failed to apply database schema"
    echo "Please check the database ID and try again."
    exit 1
fi

echo ""
echo "Step 5: Deploy the Worker"
echo "======================="
echo "Deploying the API Worker with D1 and Analytics Engine support..."
if export CLOUDFLARE_API_TOKEN=gKob2mQisfZo4JlzOmNct1VR9IEK0rn2rTFM4hH0 && npx wrangler deploy --config infrastructure/cloudflare/wrangler.toml; then
    echo "✓ Worker deployed successfully"
else
    echo "✗ Failed to deploy Worker"
    exit 1
fi

echo ""
echo "Step 6: Get Worker URL"
echo "===================="
echo "Please note the deployed Worker URL from the output above."
echo "It will look something like: https://cloudcurio-stackhub-api.YOUR_SUBDOMAIN.workers.dev"
echo ""
read -p "Enter your deployed Worker URL: " worker_url

echo ""
echo "Step 7: Update Environment Variables in Cloudflare Pages"
echo "====================================================="
echo "Update your Cloudflare Pages project with these environment variables:"
echo "1. Go to Cloudflare Dashboard > Pages > cloudcurio-stackhub > Settings > Environment Variables"
echo "2. Add variable:"
echo "   - Key: NEXT_PUBLIC_API_URL"
echo "   - Value: $worker_url"
echo ""
read -p "Have you updated the environment variables? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Please update the environment variables, then redeploy your Pages project."
fi

echo ""
echo "Step 8: Install Seed Script Dependencies"
echo "======================================"
if npm install; then
    echo "✓ Dependencies installed successfully"
else
    echo "✗ Failed to install dependencies"
    exit 1
fi

echo ""
echo "Step 9: Seed the Database"
echo "========================"
echo "Seeding the database with initial data..."
if npm run seed; then
    echo "✓ Database seeded successfully"
else
    echo "✗ Failed to seed database"
    exit 1
fi

echo ""
echo "Step 10: Redeploy Cloudflare Pages"
echo "================================"
echo "Redeploy your Pages project to use the new API:"
echo "1. Go to Cloudflare Dashboard > Pages > cloudcurio-stackhub > Deployments"
echo "2. Click 'Create deployment'"
echo "3. Select the master branch and deploy"
echo ""
read -p "Have you redeployed the Pages project? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Please redeploy your Pages project to complete the setup."
fi

echo ""
echo "Complete setup finished!"
echo "======================"
echo "Your application should now be using Cloudflare D1 database and Analytics Engine."
echo "You can now add, edit, and delete items through the web interface."
echo "Analytics data is being collected in Cloudflare Analytics Engine."