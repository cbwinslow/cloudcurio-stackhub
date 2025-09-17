#!/bin/bash

# CloudCurio StackHub Status and Next Steps Script
# This script shows the current status and provides clear next steps

echo "CloudCurio StackHub Status and Next Steps"
echo "======================================="

# Check if we're in the correct directory
if [ ! -f "README.md" ]; then
    echo "Error: Please run this script from the root of the cloudcurio-stackhub directory"
    exit 1
fi

echo "Current Status:"
echo "=============="
echo "✓ GitHub repository: https://github.com/cbwinslow/cloudcurio-stackhub"
echo "✓ Local repository: Configured and up to date"
echo "✓ SSH keys: Configured with blaine.winslow@gmail.com"
echo "✓ Development scripts: Available"
echo "□ GitLab repository: Not yet pushed (SSH key needs to be added)"
echo "□ Web deployment: Not yet deployed"

echo ""
echo "Next Steps:"
echo "=========="
echo "1. Add SSH key to GitLab (if you want to push to GitLab):"
echo "   - Go to https://gitlab.com/-/profile/keys"
echo "   - Add the SSH key from ssh-setup.sh"
echo "   - Run: git push gitlab master"
echo ""
echo "2. Test the application locally:"
echo "   - Run: ./test-local.sh"
echo "   - Visit: http://localhost:3000"
echo ""
echo "3. Deploy to the web (Cloudflare Pages):"
echo "   - Run: ./deploy-cloudflare.sh"
echo "   - Follow the instructions for your preferred deployment option"
echo ""
echo "4. Optional - Set up both GitHub and GitLab repositories:"
echo "   - Run: ./verify-repos.sh (to check current status)"
echo ""
echo "Useful Commands:"
echo "==============="
echo "./test-local.sh      - Start local development server"
echo "./deploy-cloudflare.sh - Deploy to Cloudflare Pages"
echo "./verify-repos.sh    - Check repository status"
echo "./complete-setup.sh  - Push to both GitHub and GitLab"
echo ""
echo "All scripts are in the root directory of your project."