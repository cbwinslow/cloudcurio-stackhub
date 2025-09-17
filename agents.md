# Agent Guidelines for CloudCurio StackHub

This document provides guidelines for AI agents working with the CloudCurio StackHub project.

## Project Overview

CloudCurio StackHub is a Next.js + Tailwind application for curating scripts, configurations, tools, and technology stacks. It allows users to export curated collections as monolithic files in various formats (bash scripts, Ansible playbooks).

## Agent Roles and Responsibilities

### Code Generation Agent
- Generates bash scripts and Ansible playbooks based on user selections
- Ensures generated code follows security best practices
- Includes defensive headers, dry-run guards, and proper logging

### UI/UX Agent
- Maintains consistent design language using Tailwind CSS
- Implements responsive components for all device sizes
- Follows accessibility guidelines (WCAG AA compliance)

### Infrastructure Agent
- Manages Cloudflare deployment configurations
- Handles D1 database schema updates
- Maintains Terraform and Pulumi IaC examples

### Documentation Agent
- Keeps README.md and other documentation up-to-date
- Creates and maintains markdown blog posts
- Documents API endpoints and data structures

## Code Standards

### Security
- No secrets should be committed to the repository
- All sensitive data should be handled through environment variables
- Shell exports include defensive headers and logging

### Code Quality
- TypeScript for all new code
- Follow existing code patterns and conventions
- Maintain consistent naming conventions

### Testing
- Unit tests for all business logic
- Integration tests for API endpoints
- End-to-end tests for critical user flows

## Communication Protocols

### With Users
- Provide clear explanations of technical concepts
- Offer multiple solutions when appropriate
- Flag potential security concerns

### With Other Agents
- Use structured data formats when sharing information
- Document assumptions and dependencies
- Coordinate on shared resources and state changes

## Deployment Guidelines

### Cloudflare Pages
- Build command: `pnpm install && pnpm build`
- Output directory: `.next`
- Environment variables should be set through Cloudflare dashboard

### Workers/D1/KV/Vectorize
- Configuration should be in `infrastructure/cloudflare/wrangler.toml`
- Database schema is in `infrastructure/cloudflare/d1/schema.sql`

## Error Handling

- Log errors with appropriate context
- Provide user-friendly error messages
- Implement graceful degradation for non-critical features

## Performance Considerations

- Optimize bundle sizes
- Implement proper caching strategies
- Use lazy loading for non-critical components