#!/bin/bash

# CloudCurio StackHub Cloudflare Deployment Script
# This script helps deploy the application to Cloudflare Pages

echo "CloudCurio StackHub Cloudflare Deployment Script"
echo "============================================="

# Check if we're in the correct directory
if [ ! -f "README.md" ]; then
    echo "Error: Please run this script from the root of the cloudcurio-stackhub directory"
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "Deployment Options:"
echo "=================="
echo "1. Cloudflare Pages (Recommended - Static Site)"
echo "2. Cloudflare Pages + Workers API (Advanced - With Database)"
echo ""
echo "Option 1 is recommended for getting started quickly."
echo "Option 2 provides full functionality with database support."
echo ""

read -p "Which deployment option would you like? (1 or 2): " -n 1 -r
echo

if [[ $REPLY =~ ^[1]$ ]]; then
    echo ""
    echo "Cloudflare Pages Deployment Instructions:"
    echo "========================================"
    echo "1. Go to the Cloudflare dashboard: https://dash.cloudflare.com/"
    echo "2. If you don't have an account, create one (free tier available)"
    echo "3. Navigate to 'Pages' in the left sidebar"
    echo "4. Click 'Create a project'"
    echo "5. Select 'Connect to Git' and choose your provider (GitHub or GitLab)"
    echo "6. Select the 'cloudcurio-stackhub' repository"
    echo "7. Configure the build settings:"
    echo "   - Project name: cloudcurio-stackhub"
    echo "   - Build command: cd apps/web && npm install && npm run build"
    echo "   - Build output directory: .next"
    echo "8. Click 'Save and Deploy'"
    echo ""
    echo "Your site will be deployed to a *.pages.dev URL"
    echo "You can later add a custom domain in the Cloudflare Pages settings"
    
elif [[ $REPLY =~ ^[2]$ ]]; then
    echo ""
    echo "Cloudflare Pages + Workers API Deployment Instructions:"
    echo "====================================================="
    echo "Part 1: Set up Cloudflare Pages (Frontend)"
    echo "------------------------------------------"
    echo "1. Go to the Cloudflare dashboard: https://dash.cloudflare.com/"
    echo "2. Navigate to 'Pages' in the left sidebar"
    echo "3. Click 'Create a project'"
    echo "4. Select 'Connect to Git' and choose your provider (GitHub or GitLab)"
    echo "5. Select the 'cloudcurio-stackhub' repository"
    echo "6. Configure the build settings:"
    echo "   - Project name: cloudcurio-stackhub"
    echo "   - Build command: cd apps/web && npm install && npm run build"
    echo "   - Build output directory: .next"
    echo "7. Click 'Save and Deploy'"
    echo ""
    echo "Part 2: Set up Cloudflare Workers API (Backend)"
    echo "-----------------------------------------------"
    echo "1. Install Wrangler CLI: npm install -g wrangler"
    echo "2. Authenticate with Cloudflare: wrangler login"
    echo "3. Create a D1 database:"
    echo "   - Go to Cloudflare dashboard > Workers & Pages > D1"
    echo "   - Click 'Create database'"
    echo "   - Name: stackhub_db"
    echo "   - Note the database ID"
    echo "4. Update the database ID in infrastructure/cloudflare/wrangler.toml"
    echo "5. Apply the database schema:"
    echo "   wrangler d1 execute stackhub_db --file=infrastructure/cloudflare/d1/schema.sql"
    echo "6. Deploy the Worker:"
    echo "   wrangler deploy --config infrastructure/cloudflare/wrangler.toml"
    echo ""
    echo "Part 3: Connect Pages to Workers"
    echo "-------------------------------"
    echo "1. In the Cloudflare dashboard, go to Pages > cloudcurio-stackhub > Settings > Functions"
    echo "2. Click 'Add bindings'"
    echo "3. Add a D1 database binding:"
    echo "   - Variable name: DB"
    echo "   - Database: stackhub_db"
    echo "4. Add an environment variable:"
    echo "   - Key: NEXT_PUBLIC_API_URL"
    echo "   - Value: Your deployed Worker URL (e.g., https://cloudcurio-stackhub-api.YOUR_SUBDOMAIN.workers.dev)"
    echo ""
    echo "Your site will be deployed to a *.pages.dev URL with full backend functionality"
else
    echo "Invalid option. Please run the script again and choose 1 or 2."
    exit 1
fi

echo ""
echo "Deployment instructions complete!"
echo "For additional help, refer to the CLOUDFLARE_DEPLOYMENT.md file in this repository."