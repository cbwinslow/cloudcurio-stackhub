# CloudCurio StackHub - Repository Setup Instructions

This document provides instructions for setting up remote repositories for CloudCurio StackHub on GitHub and GitLab.

## GitHub Setup

1. Go to https://github.com/new
2. Create a new repository with the name `cloudcurio-stackhub`
3. Do NOT initialize with a README, .gitignore, or license
4. Copy the repository URL (e.g., `https://github.com/yourusername/cloudcurio-stackhub.git`)
5. Run the following commands in your terminal:

```bash
cd /home/cbwinslow/server_setup/cloudcurio-stackhub
git remote add origin https://github.com/yourusername/cloudcurio-stackhub.git
git branch -M main
git push -u origin main
```

## GitLab Setup

1. Go to https://gitlab.com/projects/new
2. Create a new project with the name `cloudcurio-stackhub`
3. Do NOT initialize with a README, .gitignore, or license
4. Copy the repository URL (e.g., `https://gitlab.com/yourusername/cloudcurio-stackhub.git`)
5. Run the following commands in your terminal:

```bash
cd /home/cbwinslow/server_setup/cloudcurio-stackhub
git remote add gitlab https://gitlab.com/yourusername/cloudcurio-stackhub.git
git push -u gitlab main
```

## Cloudflare Deployment

To deploy to Cloudflare Pages:

1. Go to the Cloudflare dashboard
2. Navigate to Pages
3. Click "Create a project"
4. Connect to your Git provider (GitHub or GitLab)
5. Select the `cloudcurio-stackhub` repository
6. Configure the build settings:
   - Build command: `cd apps/web && npm install && npm run build`
   - Build output directory: `.next`
7. Click "Save and Deploy"

Your site will be deployed to a *.pages.dev URL.