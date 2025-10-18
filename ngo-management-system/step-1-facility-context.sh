#!/bin/bash
# step-1-facility-context.sh
# Tesis bazlı context ve seçici sistemi
# Date: 2025-10-18 12:42:00

echo "🏗️ =========================================="
echo "   ADIM 1: TESİS CONTEXT SİSTEMİ"
echo "   Global facility selector & context..."
echo "🏗️ =========================================="

# 1. Context Provider oluştur
cat > "contexts/FacilityContext.tsx" << 'ENDMARKER'
'use client'

import React, { createContext, useContext, useState, useEffect } from 'react'
import { useStore } from '@/lib/store'

interface Facility {
  id: string
  name: string
  location: string
  country: string
  currency: string
  language: string
  timezone: string
}

interface FacilityContextType {
  facilities: Facility[]
  currentFacility: Facility | null
  setCurrentFacility: (facility: Facility) => void
  switchFacility: (facilityId: string) => void
  userFacilities: Facility[] // Kullanıcının erişebildiği tesisler
}

const FacilityContext = createContext<FacilityContextType | undefined>(undefined)

export function FacilityProvider({ children }: { children: React.ReactNode }) {
  const user = useStore((state) => state.user)
  
  // Tüm tesisler (normalde API'den gelecek)
  const allFacilities: Facility[] = [
    {
      id: 'nijer',
      name: 'Nijer Ana Merkez',
      location: 'Niamey',
      country: 'Nijer',
      currency: 'XOF',
      language: 'fr',
      timezone: 'Africa/Niamey'
    },
    {
      id: 'senegal',
      name: 'Senegal Şubesi',
      location: 'Dakar',
      country: 'Senegal',
      currency: 'XOF',
      language: 'fr',
      timezone: 'Africa/Dakar'
    },
    {
      id: 'mali',
      name: 'Mali Temsilcilik',
      location: 'Bamako',
      country: 'Mali',
      currency: 'XOF',
      language: 'fr',
      timezone: 'Africa/Bamako'
    },
    {
      id: 'global',
      name: 'Genel Merkez',
      location: 'İstanbul',
      country: 'Türkiye',
      currency: 'TRY',
      language: 'tr',
      timezone: 'Europe/Istanbul'
    }
  ]
  
  const [currentFacility, setCurrentFacility] = useState<Facility | null>(null)
  const [userFacilities, setUserFacilities] = useState<Facility[]>([])
  
  useEffect(() => {
    // Kullanıcının yetkili olduğu tesisleri belirle
    if (user) {
      if (user.role === 'admin') {
        setUserFacilities(allFacilities)
      } else if (user.facilityIds) {
        setUserFacilities(
          allFacilities.filter(f => user.facilityIds.includes(f.id))
        )
      }
      
      // İlk tesisi seç
      if (!currentFacility && userFacilities.length > 0) {
        setCurrentFacility(userFacilities[0])
      }
    }
  }, [user])
  
  const switchFacility = (facilityId: string) => {
    const facility = userFacilities.find(f => f.id === facilityId)
    if (facility) {
      setCurrentFacility(facility)
      localStorage.setItem('selectedFacility', facilityId)
    }
  }
  
  return (
    <FacilityContext.Provider
      value={{
        facilities: allFacilities,
        currentFacility,
        setCurrentFacility,
        switchFacility,
        userFacilities
      }}
    >
      {children}
    </FacilityContext.Provider>
  )
}

export function useFacility() {
  const context = useContext(FacilityContext)
  if (context === undefined) {
    throw new Error('useFacility must be used within a FacilityProvider')
  }
  return context
}
ENDMARKER

# 2. Facility Selector Component
cat > "components/FacilitySelector.tsx" << 'ENDMARKER'
'use client'

import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { Building2, ChevronDown, Check, Globe } from 'lucide-react'
import { useFacility } from '@/contexts/FacilityContext'

export function FacilitySelector() {
  const [isOpen, setIsOpen] = useState(false)
  const { currentFacility, userFacilities, switchFacility } = useFacility()
  
  if (userFacilities.length <= 1) return null
  
  return (
    <div className="relative">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 px-3 py-2 bg-white dark:bg-gray-800 rounded-lg border border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
      >
        <Building2 className="w-4 h-4 text-gray-500" />
        <span className="text-sm font-medium">
          {currentFacility?.name || 'Tesis Seç'}
        </span>
        <ChevronDown className={`w-4 h-4 text-gray-500 transition-transform ${
          isOpen ? 'rotate-180' : ''
        }`} />
      </button>
      
      <AnimatePresence>
        {isOpen && (
          <>
            <div
              className="fixed inset-0 z-40"
              onClick={() => setIsOpen(false)}
            />
            <motion.div
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -10 }}
              className="absolute top-12 right-0 z-50 w-64 bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden"
            >
              <div className="p-2">
                {userFacilities.map((facility) => (
                  <button
                    key={facility.id}
                    onClick={() => {
                      switchFacility(facility.id)
                      setIsOpen(false)
                    }}
                    className={`w-full px-3 py-2 flex items-center justify-between rounded-lg transition-colors ${
                      currentFacility?.id === facility.id
                        ? 'bg-blue-50 dark:bg-blue-900/20 text-blue-600'
                        : 'hover:bg-gray-50 dark:hover:bg-gray-700'
                    }`}
                  >
                    <div className="flex items-center gap-3">
                      {facility.id === 'global' ? (
                        <Globe className="w-4 h-4" />
                      ) : (
                        <Building2 className="w-4 h-4" />
                      )}
                      <div className="text-left">
                        <p className="text-sm font-medium">{facility.name}</p>
                        <p className="text-xs text-gray-500">
                          {facility.location}, {facility.country}
                        </p>
                      </div>
                    </div>
                    {currentFacility?.id === facility.id && (
                      <Check className="w-4 h-4 text-blue-600" />
                    )}
                  </button>
                ))}
              </div>
              
              {userFacilities.some(f => f.id === 'global') && (
                <div className="border-t border-gray-200 dark:border-gray-700 p-3">
                  <p className="text-xs text-gray-500 text-center">
                    Global yetkiye sahipsiniz
                  </p>
                </div>
              )}
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </div>
  )
}
ENDMARKER

# 3. Updated Layout with Facility Selector
cat > "app/(main)/layout-updated.tsx" << 'ENDMARKER'
'use client'

import { useState, useEffect } from 'react'
import { usePathname } from 'next/navigation'
import Link from 'next/link'
import { motion, AnimatePresence } from 'framer-motion'
import { FacilityProvider } from '@/contexts/FacilityContext'
import { FacilitySelector } from '@/components/FacilitySelector'
import {
  LayoutDashboard, CreditCard, FolderOpen, Users, Building2,
  Heart, CheckCircle, FileText, Settings, ChevronLeft, ChevronRight,
  Menu, X, Search, Bell, Moon, Sun, User, LogOut, HelpCircle,
  Globe, Command, DollarSign, TrendingUp, Activity
} from 'lucide-react'

// ... (sidebar code remains same, just add FacilityProvider wrapper)

export default function MainLayout({ children }: { children: React.ReactNode }) {
  // ... existing state and functions ...
  
  return (
    <FacilityProvider>
      <div className="flex h-screen bg-gray-50 dark:bg-gray-900">
        {/* Existing Sidebar */}
        
        <div className="flex-1 flex flex-col overflow-hidden">
          {/* Updated Header */}
          <header className="bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700">
            <div className="flex items-center justify-between px-6 py-4">
              <div className="flex items-center gap-4">
                <button onClick={() => setIsSidebarOpen(!isSidebarOpen)}>
                  <Menu className="w-6 h-6" />
                </button>
                <h1 className="text-xl font-semibold">
                  {menuItems.find(item => item.href === pathname)?.label || 'NGO Management'}
                </h1>
              </div>
              
              <div className="flex items-center gap-4">
                {/* Facility Selector */}
                <FacilitySelector />
                
                {/* Existing header buttons */}
                <button className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg">
                  <Search className="w-5 h-5" />
                </button>
                <button className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg">
                  <Bell className="w-5 h-5" />
                </button>
                {/* ... rest of header ... */}
              </div>
            </div>
          </header>
          
          {/* Main Content */}
          <main className="flex-1 overflow-y-auto p-6">
            {children}
          </main>
        </div>
      </div>
    </FacilityProvider>
  )
}
ENDMARKER

# 4. Hook for facility-aware data fetching
cat > "hooks/useFacilityData.ts" << 'ENDMARKER'
import { useEffect, useState } from 'react'
import { useFacility } from '@/contexts/FacilityContext'

export function useFacilityData<T>(
  dataType: 'cash' | 'projects' | 'personnel' | 'sacrifice'
) {
  const { currentFacility } = useFacility()
  const [data, setData] = useState<T[]>([])
  const [loading, setLoading] = useState(true)
  
  useEffect(() => {
    if (!currentFacility) return
    
    setLoading(true)
    
    // Simulate API call with facility filter
    const fetchData = async () => {
      // In real app: const response = await fetch(`/api/${dataType}?facilityId=${currentFacility.id}`)
      
      // For now, return filtered mock data
      const mockData = localStorage.getItem(`${dataType}_${currentFacility.id}`)
      if (mockData) {
        setData(JSON.parse(mockData))
      } else {
        setData([])
      }
      
      setLoading(false)
    }
    
    fetchData()
  }, [currentFacility, dataType])
  
  return { data, loading, facilityId: currentFacility?.id }
}
ENDMARKER

echo "✅ Adım 1 tamamlandı: Tesis Context Sistemi"
echo ""
echo "📌 Yapılan değişiklikler:"
echo "  • FacilityContext oluşturuldu"
echo "  • FacilitySelector component eklendi"
echo "  • useFacilityData hook eklendi"
echo "  • Layout güncellendi"
echo ""
echo "📌 Layout'u güncellemek için:"
echo "   mv app/(main)/layout-updated.tsx app/(main)/layout.tsx"
echo ""
echo "🚀 Sonraki: Adım 2 - Esnek Yetkilendirme Sistemi"