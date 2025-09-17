# Cloudflare Deployment Instructions

This document provides instructions for deploying CloudCurio StackHub to Cloudflare.

## Cloudflare Pages Deployment

CloudCurio StackHub can be deployed to Cloudflare Pages using the following settings:

1. Build command: `cd apps/web && npm install && npm run build`
2. Build output directory: `.next`

Note: Cloudflare Pages automatically detects Next.js projects and applies the correct settings.

## Cloudflare Workers, D1, and Vectorize

For advanced features, you can deploy additional Cloudflare services:

### Workers API

The `wrangler.toml` file in `infrastructure/cloudflare/` configures a Worker that can serve as a backend API.

To deploy:
1. Install Wrangler: `npm install -g wrangler`
2. Authenticate: `wrangler login`
3. Update the `wrangler.toml` file with your D1 database ID
4. Deploy: `wrangler deploy`

### D1 Database

The D1 database schema is defined in `infrastructure/cloudflare/d1/schema.sql`.

To create and configure a D1 database:
1. Create a new D1 database in the Cloudflare dashboard
2. Update the database ID in `wrangler.toml`
3. Apply the schema: `wrangler d1 execute stackhub_db --file=infrastructure/cloudflare/d1/schema.sql`

### Vectorize (Optional)

Vectorize can be used for semantic search features. Configuration details are in `infrastructure/cloudflare/vectorize/README.md`.

## Environment Variables

Set the following environment variables in the Cloudflare Pages dashboard:

- `NEXT_PUBLIC_API_URL` - URL of your deployed Workers API (if using D1)
- Any other custom environment variables your application requires

## Custom Domain

To use a custom domain:
1. Add a custom domain in the Cloudflare Pages settings
2. Update your DNS records to point to the Cloudflare Pages domain
3. Wait for SSL certificate provisioning

## CI/CD

Cloudflare Pages automatically builds and deploys your site when you push to your connected Git repository.

For more advanced CI/CD workflows, consider using GitHub Actions or GitLab CI with Wrangler.