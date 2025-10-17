'use client'

import { useEffect } from 'react'
import { useRouter } from 'next/navigation'

export default function Home() {
  const router = useRouter()

  useEffect(() => {
    router.push('/login')
  }, [router])

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <div className="text-center">
        <div className="animate-pulse">
          <h1 className="text-3xl font-bold text-gray-800 mb-2">NGO Management System</h1>
          <p className="text-gray-600">Yönlendiriliyorsunuz...</p>
        </div>
      </div>
    </div>
  )
}
