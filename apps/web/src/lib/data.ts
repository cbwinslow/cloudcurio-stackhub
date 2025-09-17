import type { ScriptItem } from './types'

// API URL - you'll need to update this after deploying the Worker
const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8787';

export async function listItems(): Promise<ScriptItem[]> {
  try {
    const response = await fetch(`${API_URL}/api/items`);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.error('Failed to fetch items:', error);
    // Fallback to static data if API is unavailable
    const seed = await import('./seed.json');
    return seed.items as ScriptItem[];
  }
}

export async function getItem(id: string): Promise<ScriptItem | null> {
  try {
    const response = await fetch(`${API_URL}/api/items/${id}`);
    if (!response.ok) {
      return null;
    }
    return await response.json();
  } catch (error) {
    console.error('Failed to fetch item:', error);
    return null;
  }
}

export async function createItem(item: Omit<ScriptItem, 'id'>): Promise<ScriptItem> {
  try {
    const response = await fetch(`${API_URL}/api/items`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(item),
    });
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error('Failed to create item:', error);
    throw error;
  }
}

export async function updateItem(id: string, item: Partial<ScriptItem>): Promise<ScriptItem> {
  try {
    const response = await fetch(`${API_URL}/api/items/${id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(item),
    });
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error('Failed to update item:', error);
    throw error;
  }
}

export async function deleteItem(id: string): Promise<void> {
  try {
    const response = await fetch(`${API_URL}/api/items/${id}`, {
      method: 'DELETE',
    });
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
  } catch (error) {
    console.error('Failed to delete item:', error);
    throw error;
  }
}

export async function exportItems(itemIds: string[], format: 'bash' | 'ansible'): Promise<string> {
  try {
    const response = await fetch(`${API_URL}/api/export`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ items: itemIds, format }),
    });
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    return await response.text();
  } catch (error) {
    console.error('Failed to export items:', error);
    throw error;
  }
}
