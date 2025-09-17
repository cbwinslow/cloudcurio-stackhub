#!/bin/bash

# CloudCurio StackHub Database Setup Script
# This script helps set up Cloudflare D1 database for full functionality

echo "CloudCurio StackHub Database Setup Script"
echo "======================================"

# Check if we're in the correct directory
if [ ! -f "README.md" ]; then
    echo "Error: Please run this script from the root of the cloudcurio-stackhub directory"
    exit 1
fi

echo "Current Data Storage Options:"
echo "============================"
echo "1. Static JSON (default) - No database needed, data stored in apps/web/src/lib/seed.json"
echo "2. Cloudflare D1 (SQLite) - Full database functionality"
echo "3. Cloudflare Vectorize + KV - Advanced features like semantic search"
echo ""
echo "This script will help you set up option 2 (Cloudflare D1)."
echo ""

echo "Prerequisites:"
echo "============="
echo "1. Cloudflare account with D1 enabled"
echo "2. Wrangler CLI installed: npm install -g wrangler"
echo "3. Authenticated with Cloudflare: wrangler login"
echo ""
echo "If you haven't installed Wrangler yet, please do so now:"
echo "npm install -g wrangler"
echo ""
read -p "Press Enter to continue after installing Wrangler (or Ctrl+C to exit)..."

echo ""
echo "Step 1: Authenticate with Cloudflare"
echo "=================================="
wrangler login

echo ""
echo "Step 2: Create D1 Database"
echo "========================"
echo "Creating D1 database 'stackhub_db'..."
wrangler d1 create stackhub_db

echo ""
echo "Step 3: Get Database ID"
echo "====================="
echo "Please note the database ID from the output above. You'll need it for the next steps."
echo "The database ID looks like a long string of characters and numbers."
echo ""
read -p "Press Enter after noting the database ID..."

echo ""
echo "Step 4: Update wrangler.toml"
echo "=========================="
echo "Please update the infrastructure/cloudflare/wrangler.toml file:"
echo "1. Replace 'REPLACE_WITH_YOUR_D1_ID' with your actual database ID"
echo "2. Save the file"
echo ""
read -p "Press Enter after updating the wrangler.toml file..."

echo ""
echo "Step 5: Apply Database Schema"
echo "=========================="
echo "Applying the database schema..."
wrangler d1 execute stackhub_db --file=infrastructure/cloudflare/d1/schema.sql --config infrastructure/cloudflare/wrangler.toml

echo ""
echo "Step 6: Create API Worker"
echo "======================="
echo "We need to create an API Worker to interact with the D1 database."
echo "This requires creating a few files. Let's do that now."
echo ""

# Create the src directory if it doesn't exist
mkdir -p infrastructure/cloudflare/src

# Create the Worker index.ts file
cat > infrastructure/cloudflare/src/index.ts << 'EOF'
import { D1Database } from '@cloudflare/workers-types';

interface Env {
  DB: D1Database;
}

interface ScriptItem {
  id: string;
  name: string;
  category: string;
  description: string;
  tags: string; // comma separated
  script_bash: string;
  script_ansible: string;
  terraform?: string;
  pulumi?: string;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);
    const path = url.pathname;

    // CORS headers
    const corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
    };

    // Handle CORS preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders });
    }

    try {
      // Get all items
      if (path === '/api/items' && request.method === 'GET') {
        const { results } = await env.DB.prepare('SELECT * FROM items').all<ScriptItem>();
        return new Response(JSON.stringify(results), {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        });
      }

      // Get item by ID
      if (path.startsWith('/api/items/') && request.method === 'GET') {
        const id = path.split('/')[3];
        const item = await env.DB.prepare('SELECT * FROM items WHERE id = ?').bind(id).first<ScriptItem>();
        if (item) {
          return new Response(JSON.stringify(item), {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' }
          });
        } else {
          return new Response('Item not found', { status: 404, headers: corsHeaders });
        }
      }

      // Create new item
      if (path === '/api/items' && request.method === 'POST') {
        const data = await request.json<ScriptItem>();
        await env.DB.prepare(
          'INSERT INTO items (id, name, category, description, tags, script_bash, script_ansible, terraform, pulumi) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)'
        ).bind(
          data.id,
          data.name,
          data.category,
          data.description,
          data.tags,
          data.script_bash,
          data.script_ansible,
          data.terraform || null,
          data.pulumi || null
        ).run();

        return new Response(JSON.stringify(data), {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 201
        });
      }

      // Update item
      if (path.startsWith('/api/items/') && request.method === 'PUT') {
        const id = path.split('/')[3];
        const data = await request.json<ScriptItem>();
        await env.DB.prepare(
          'UPDATE items SET name = ?, category = ?, description = ?, tags = ?, script_bash = ?, script_ansible = ?, terraform = ?, pulumi = ? WHERE id = ?'
        ).bind(
          data.name,
          data.category,
          data.description,
          data.tags,
          data.script_bash,
          data.script_ansible,
          data.terraform || null,
          data.pulumi || null,
          id
        ).run();

        return new Response(JSON.stringify(data), {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        });
      }

      // Delete item
      if (path.startsWith('/api/items/') && request.method === 'DELETE') {
        const id = path.split('/')[3];
        await env.DB.prepare('DELETE FROM items WHERE id = ?').bind(id).run();
        return new Response(null, { status: 204, headers: corsHeaders });
      }

      // Health check
      if (path === '/api/health' && request.method === 'GET') {
        return new Response('OK', { headers: corsHeaders });
      }

      return new Response('Not found', { status: 404, headers: corsHeaders });
    } catch (error: any) {
      return new Response(error.message || 'Internal Server Error', { 
        status: 500, 
        headers: corsHeaders 
      });
    }
  }
};
EOF

echo "Created infrastructure/cloudflare/src/index.ts"

# Create tsconfig.json for the Worker
cat > infrastructure/cloudflare/tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "CommonJS",
    "lib": ["ES2020"],
    "types": ["@cloudflare/workers-types"],
    "moduleResolution": "node",
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "skipLibCheck": true
  }
}
EOF

echo "Created infrastructure/cloudflare/tsconfig.json"

echo ""
echo "Step 7: Update Data Adapter"
echo "========================="
echo "We need to update the data adapter to use the API instead of static JSON."
echo "This requires modifying apps/web/src/lib/data.ts"
echo ""
echo "Replace the content of apps/web/src/lib/data.ts with the following:"
echo ""
echo '```javascript'
echo "import type { ScriptItem } from './types'"
echo ""
echo "// API URL - you'll need to update this after deploying the Worker"
echo "const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8787';"
echo ""
echo "export async function listItems(): Promise<ScriptItem[]> {"
echo "  try {"
echo "    const response = await fetch(\`$\{API_URL\}/api/items\`);"
echo "    if (!response.ok) {"
echo "      throw new Error(\`HTTP error! status: $\{response.status\}\`);"
echo "    }"
echo "    return await response.json();"
echo "  } catch (error) {"
echo "    console.error('Failed to fetch items:', error);"
echo "    // Fallback to static data if API is unavailable"
echo "    const seed = await import('./seed.json');"
echo "    return seed.items as ScriptItem[];"
echo "  }"
echo "}"
echo ""
echo "export async function getItem(id: string): Promise<ScriptItem | null> {"
echo "  try {"
echo "    const response = await fetch(\`$\{API_URL\}/api/items/$\{id\}\`);"
echo "    if (!response.ok) {"
echo "      return null;"
echo "    }"
echo "    return await response.json();"
echo "  } catch (error) {"
echo "    console.error('Failed to fetch item:', error);"
echo "    return null;"
echo "  }"
echo "}"
echo '```'
echo ""
read -p "Press Enter after updating the data adapter..."

echo ""
echo "Step 8: Seed the Database"
echo "======================="
echo "We need to populate the database with initial data from seed.json"
echo "Create a script to do this:"
echo ""
cat > seed-database.js << 'EOF'
const seed = require('./apps/web/src/lib/seed.json');

async function seedDatabase() {
  const apiUrl = process.env.API_URL || 'http://localhost:8787';
  
  console.log('Seeding database with', seed.items.length, 'items...');
  
  for (const item of seed.items) {
    try {
      const response = await fetch(`${apiUrl}/api/items`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ...item,
          tags: item.tags.join(', '), // Convert array to comma-separated string
        }),
      });
      
      if (!response.ok) {
        console.error(`Failed to insert item ${item.id}:`, await response.text());
      } else {
        console.log(`Inserted item ${item.id}`);
      }
    } catch (error) {
      console.error(`Error inserting item ${item.id}:`, error);
    }
  }
  
  console.log('Database seeding complete!');
}

seedDatabase();
EOF

echo "Created seed-database.js"
echo "Run this script after deploying the Worker to seed the database:"
echo "node seed-database.js"

echo ""
echo "Step 9: Deploy the Worker"
echo "======================="
echo "Deploying the API Worker..."
wrangler deploy --config infrastructure/cloudflare/wrangler.toml

echo ""
echo "Step 10: Update Environment Variables"
echo "=================================="
echo "After deployment, update your Cloudflare Pages project with these environment variables:"
echo "1. Go to Cloudflare Dashboard > Pages > cloudcurio-stackhub > Settings > Environment Variables"
echo "2. Add variable:"
echo "   - Key: NEXT_PUBLIC_API_URL"
echo "   - Value: Your deployed Worker URL (from the previous step)"
echo ""
read -p "Press Enter after setting the environment variable..."

echo ""
echo "Step 11: Redeploy Cloudflare Pages"
echo "================================"
echo "Redeploy your Pages project to use the new API:"
echo "1. Go to Cloudflare Dashboard > Pages > cloudcurio-stackhub > Deployments"
echo "2. Click 'Create deployment'"
echo "3. Select the master branch and deploy"
echo ""

echo "Database setup complete!"
echo "========================"
echo "Your application should now be using Cloudflare D1 database instead of static JSON."
echo "You can now add, edit, and delete items through the web interface."