# Qwen Configuration for CloudCurio StackHub

This document contains configuration details and instructions specific to using Qwen with the CloudCurio StackHub project.

## Project Context

CloudCurio StackHub is a Next.js + Tailwind application for curating and exporting technology stacks. The project includes:

- A web interface for browsing and selecting scripts/configurations
- Export functionality to generate bash scripts or Ansible playbooks
- Cloudflare deployment setup with Pages, Workers, D1, and Vectorize
- Docker configurations for Flowise and n8n automation tools

## Key Directories and Files

- `apps/web/` - Main Next.js application
- `apps/web/src/lib/data.ts` - Data adapters (static JSON vs D1)
- `apps/web/src/app/api/export/route.ts` - Export functionality
- `infrastructure/cloudflare/` - Cloudflare configurations
- `docker/` - Flowise and n8n docker-compose files

## Development Workflow

1. Use `pnpm dev` to start the development server
2. Access the application at http://localhost:3000
3. For Cloudflare features, use `wrangler` commands

## Qwen-Specific Instructions

### File Operations
- Always use absolute paths when referencing files
- Check for file existence before operations
- Use appropriate tools for different file types (read_file, write_file, edit, etc.)

### Code Generation
- Follow existing code patterns in the repository
- Maintain TypeScript type safety
- Use Tailwind CSS for styling components

### Deployment
- Understand the difference between static JSON and D1 database modes
- Know how to configure Cloudflare bindings in wrangler.toml
- Be familiar with Next.js build process for Cloudflare Pages

### Security
- Never commit secrets to the repository
- Always use environment variables for sensitive data
- Follow defensive programming practices in generated scripts

## Common Tasks

### Adding New Export Formats
1. Create a new export function in `apps/web/src/lib/export/`
2. Update the API route in `apps/web/src/app/api/export/route.ts`
3. Add UI elements for the new format in the export interface

### Modifying Data Structure
1. Update the seed data in `apps/web/src/lib/seed.json`
2. If using D1, modify the schema in `infrastructure/cloudflare/d1/schema.sql`
3. Update data adapters in `apps/web/src/lib/data.ts`

### Adding New Components
1. Create component files in `apps/web/src/components/`
2. Follow existing patterns for props and styling
3. Ensure components are responsive and accessible

## Tools and Commands

### Development
- `pnpm dev` - Start development server
- `pnpm build` - Build for production
- `pnpm lint` - Run linter

### Cloudflare
- `wrangler deploy` - Deploy Workers
- `wrangler dev` - Develop Workers locally
- Cloudflare Pages deployment through dashboard

### Docker
- `docker-compose -f docker/flowise/docker-compose.yml up` - Start Flowise
- `docker-compose -f docker/n8n/docker-compose.yml up` - Start n8n

## Troubleshooting

### Common Issues
1. Port conflicts: Change ports in docker-compose files or development server
2. D1 database issues: Verify wrangler.toml configuration and bindings
3. Build errors: Check for TypeScript errors and missing dependencies

### Debugging Tips
- Use console.log for server-side debugging
- Use browser developer tools for client-side issues
- Check Cloudflare dashboard for deployment logs