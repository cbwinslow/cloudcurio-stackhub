import { NextRequest, NextResponse } from 'next/server'
import { exportItems } from '@/lib/data'

export async function GET(req: NextRequest) {
  const { searchParams } = new URL(req.url)
  const ids = (searchParams.get('ids') || '').split(',').filter(Boolean)
  const mode = (searchParams.get('mode') || 'bash') as 'bash' | 'ansible'

  try {
    // Use the API-based export functionality
    const content = await exportItems(ids, mode)
    const filename = mode === 'bash' ? 'stackhub-export.sh' : 'stackhub-export.yml'
    
    return new NextResponse(content, {
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Content-Disposition': `attachment; filename=${filename}`
      }
    })
  } catch (error) {
    console.error('Export failed:', error)
    return new NextResponse('Export failed', { status: 500 })
  }
}
