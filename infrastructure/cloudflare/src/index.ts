import { D1Database, AnalyticsEngineDataset } from '@cloudflare/workers-types';

interface Env {
  DB: D1Database;
  ANALYTICS_ENGINE: AnalyticsEngineDataset;
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

// Helper function to convert tags array to comma-separated string
function formatTags(tags: string | string[]): string {
  if (Array.isArray(tags)) {
    return tags.join(', ');
  }
  return tags;
}

// Helper function to convert comma-separated string to tags array
function parseTags(tags: string): string[] {
  return tags.split(',').map(tag => tag.trim()).filter(tag => tag.length > 0);
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);
    const path = url.pathname;
    const method = request.method;

    // Record analytics for all requests
    const analyticsData = {
      timestamp: Date.now(),
      method: method,
      path: path,
      userAgent: request.headers.get('user-agent') || '',
      referer: request.headers.get('referer') || '',
      ip: request.headers.get('cf-connecting-ip') || '',
    };

    // Send analytics data to Analytics Engine
    try {
      env.ANALYTICS_ENGINE.writeDataPoint({
        blobs: [analyticsData.method, analyticsData.path, analyticsData.userAgent, analyticsData.referer, analyticsData.ip],
        doubles: [analyticsData.timestamp],
        indexes: [analyticsData.path],
      });
    } catch (error) {
      console.error('Failed to write analytics data:', error);
    }

    // CORS headers
    const corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    };

    // Handle CORS preflight
    if (method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders });
    }

    try {
      // Get all items
      if (path === '/api/items' && method === 'GET') {
        const { results } = await env.DB.prepare('SELECT * FROM items').all<ScriptItem>();
        return new Response(JSON.stringify(results), {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        });
      }

      // Get item by ID
      if (path.startsWith('/api/items/') && method === 'GET') {
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
      if (path === '/api/items' && method === 'POST') {
        const data = await request.json() as any;
        const id = data.id || crypto.randomUUID();
        
        await env.DB.prepare(
          'INSERT INTO items (id, name, category, description, tags, script_bash, script_ansible, terraform, pulumi) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)'
        ).bind(
          id,
          data.name,
          data.category,
          data.description,
          formatTags(data.tags),
          data.script_bash,
          data.script_ansible,
          data.terraform || null,
          data.pulumi || null
        ).run();

        // Record analytics for item creation
        try {
          env.ANALYTICS_ENGINE.writeDataPoint({
            blobs: ['item_created', data.category, data.name],
            doubles: [Date.now()],
            indexes: [data.category],
          });
        } catch (error) {
          console.error('Failed to write item creation analytics:', error);
        }

        const newItem = {
          id,
          ...data,
          tags: Array.isArray(data.tags) ? data.tags : parseTags(data.tags)
        };

        return new Response(JSON.stringify(newItem), {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 201
        });
      }

      // Update item
      if (path.startsWith('/api/items/') && method === 'PUT') {
        const id = path.split('/')[3];
        const data = await request.json() as any;
        
        await env.DB.prepare(
          'UPDATE items SET name = ?, category = ?, description = ?, tags = ?, script_bash = ?, script_ansible = ?, terraform = ?, pulumi = ? WHERE id = ?'
        ).bind(
          data.name,
          data.category,
          data.description,
          formatTags(data.tags),
          data.script_bash,
          data.script_ansible,
          data.terraform || null,
          data.pulumi || null,
          id
        ).run();

        // Record analytics for item update
        try {
          env.ANALYTICS_ENGINE.writeDataPoint({
            blobs: ['item_updated', data.category, data.name],
            doubles: [Date.now()],
            indexes: [data.category],
          });
        } catch (error) {
          console.error('Failed to write item update analytics:', error);
        }

        const updatedItem = {
          id,
          ...data,
          tags: Array.isArray(data.tags) ? data.tags : parseTags(data.tags)
        };

        return new Response(JSON.stringify(updatedItem), {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        });
      }

      // Delete item
      if (path.startsWith('/api/items/') && method === 'DELETE') {
        const id = path.split('/')[3];
        
        // Get item before deletion for analytics
        const item = await env.DB.prepare('SELECT * FROM items WHERE id = ?').bind(id).first<ScriptItem>();
        
        await env.DB.prepare('DELETE FROM items WHERE id = ?').bind(id).run();
        
        // Record analytics for item deletion
        if (item) {
          try {
            env.ANALYTICS_ENGINE.writeDataPoint({
              blobs: ['item_deleted', item.category, item.name],
              doubles: [Date.now()],
              indexes: [item.category],
            });
          } catch (error) {
            console.error('Failed to write item deletion analytics:', error);
          }
        }

        return new Response(null, { status: 204, headers: corsHeaders });
      }

      // Export endpoint
      if (path === '/api/export' && method === 'POST') {
        const { items, format } = await request.json() as { items: string[]; format: string };
        
        // Record analytics for export
        try {
          env.ANALYTICS_ENGINE.writeDataPoint({
            blobs: ['export', format, items.length.toString()],
            doubles: [Date.now(), items.length],
            indexes: [format],
          });
        } catch (error) {
          console.error('Failed to write export analytics:', error);
        }

        let result = '';
        if (format === 'bash') {
          result = '#!/bin/bash\n\n';
          result += '# CloudCurio StackHub Export\n';
          result += '# Generated: ' + new Date().toISOString() + '\n\n';
          result += 'set -e  # Exit on any error\n';
          result += 'echo "Starting StackHub export..."\n\n';
          
          for (const id of items) {
            const item = await env.DB.prepare('SELECT * FROM items WHERE id = ?').bind(id).first<ScriptItem>();
            if (item) {
              result += `# === ${item.name} ===\n`;
              result += `${item.script_bash}\n\n`;
            }
          }
          
          result += 'echo "Export completed successfully!"\n';
        } else if (format === 'ansible') {
          result = '---\n';
          result += '# CloudCurio StackHub Export\n';
          result += '# Generated: ' + new Date().toISOString() + '\n';
          result += '- name: StackHub Export\n';
          result += '  hosts: localhost\n';
          result += '  gather_facts: true\n';
          result += '  become: true\n';
          result += '  tasks:\n';
          
          for (const id of items) {
            const item = await env.DB.prepare('SELECT * FROM items WHERE id = ?').bind(id).first<ScriptItem>();
            if (item) {
              result += `    # === ${item.name} ===\n`;
              // Parse the ansible script to indent properly
              const lines = item.script_ansible.split('\n');
              for (const line of lines) {
                if (line.trim()) {
                  result += `    ${line}\n`;
                }
              }
              result += '\n';
            }
          }
        }

        return new Response(result, {
          headers: { 
            ...corsHeaders, 
            'Content-Type': 'text/plain',
            'Content-Disposition': `attachment; filename="stackhub-export.${format === 'bash' ? 'sh' : 'yml'}"`
          }
        });
      }

      // Analytics endpoint - get recent analytics data
      if (path === '/api/analytics' && method === 'GET') {
        // Note: Analytics Engine data is not directly queryable in this way
        // This is just a placeholder to show where you might implement
        // a more sophisticated analytics solution
        return new Response(JSON.stringify({ 
          message: 'Analytics data is being collected in Cloudflare Analytics Engine',
          note: 'Direct querying of Analytics Engine data requires a separate solution'
        }), {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        });
      }

      // Health check
      if (path === '/api/health' && method === 'GET') {
        return new Response('OK', { headers: corsHeaders });
      }

      return new Response('Not found', { status: 404, headers: corsHeaders });
    } catch (error: any) {
      console.error('API Error:', error);
      
      // Record error analytics
      try {
        env.ANALYTICS_ENGINE.writeDataPoint({
          blobs: ['error', error.message || 'Unknown error', path, method],
          doubles: [Date.now()],
          indexes: ['error'],
        });
      } catch (analyticsError) {
        console.error('Failed to write error analytics:', analyticsError);
      }
      
      return new Response(error.message || 'Internal Server Error', { 
        status: 500, 
        headers: corsHeaders 
      });
    }
  }
};