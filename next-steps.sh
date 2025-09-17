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
echo "✓ Build fixes: Applied (path aliases and webpack configuration)"
echo "□ GitLab repository: Not yet pushed (SSH key needs to be added)"
echo "□ Web deployment: In progress (should complete automatically)"

echo ""
echo "Next Steps:"
echo "=========="
echo "1. Cloudflare Pages should automatically rebuild with the latest changes"
echo "   - Check your deployment at: https://dash.cloudflare.com/ -> Pages -> cloudcurio-stackhub"
echo "   - If it doesn't trigger automatically, run: ./redeploy-cloudflare.sh"
echo ""
echo "2. Add SSH key to GitLab (if you want to push to GitLab):"
echo "   - Go to https://gitlab.com/-/profile/keys"
echo "   - Add the SSH key from ssh-setup.sh"
echo "   - Run: git push gitlab master"
echo ""
echo "3. Test the application locally:"
echo "   - Run: ./test-local.sh"
echo "   - Visit: http://localhost:3000"
echo ""
echo "4. Optional - Set up both GitHub and GitLab repositories:"
echo "   - Run: ./verify-repos.sh (to check current status)"
echo ""
echo "Useful Commands:"
echo "==============="
echo "./test-local.sh           - Start local development server"
echo "./redeploy-cloudflare.sh  - Redeploy to Cloudflare Pages"
echo "./verify-repos.sh         - Check repository status"
echo "./complete-setup.sh       - Push to both GitHub and GitLab"
echo ""
echo "All scripts are in the root directory of your project."