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
