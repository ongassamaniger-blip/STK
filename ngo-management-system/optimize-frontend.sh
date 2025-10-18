#!/bin/bash
# optimize-frontend.sh
# Frontend optimizasyonları
# Date: 2025-10-18 12:16:47
# User: ongassamaniger-blip

echo "🎨 =========================================="
echo "   FRONTEND OPTİMİZASYONU"
echo "   State, Cache, Performance..."
echo "🎨 =========================================="

# 1. Gerekli paketleri yükle
echo "📦 Paketler yükleniyor..."
npm install zustand @tanstack/react-query dexie react-hook-form zod react-hot-toast react-loading-skeleton

# 2. Lib klasörünü oluştur
mkdir -p lib
mkdir -p components/ui

# 3. Global Store oluştur
cat > "lib/store.ts" << 'ENDMARKER'
import { create } from 'zustand'
import { persist } from 'zustand/middleware'

interface Transaction {
  id: string
  type: 'income' | 'expense' | 'transfer'
  amount: number
  description: string
  date: string
  status: string
}

interface AppState {
  user: any | null
  setUser: (user: any) => void
  
  transactions: Transaction[]
  addTransaction: (transaction: Transaction) => void
  updateTransaction: (id: string, data: Partial<Transaction>) => void
  deleteTransaction: (id: string) => void
  
  projects: any[]
  addProject: (project: any) => void
  
  darkMode: boolean
  toggleDarkMode: () => void
  
  clearStore: () => void
}

export const useStore = create<AppState>()(
  persist(
    (set) => ({
      user: null,
      transactions: [],
      projects: [],
      darkMode: false,
      
      setUser: (user) => set({ user }),
      
      addTransaction: (transaction) =>
        set((state) => ({
          transactions: [...state.transactions, transaction]
        })),
        
      updateTransaction: (id, data) =>
        set((state) => ({
          transactions: state.transactions.map((t) =>
            t.id === id ? { ...t, ...data } : t
          )
        })),
        
      deleteTransaction: (id) =>
        set((state) => ({
          transactions: state.transactions.filter((t) => t.id !== id)
        })),
        
      addProject: (project) =>
        set((state) => ({
          projects: [...state.projects, project]
        })),
        
      toggleDarkMode: () =>
        set((state) => ({ darkMode: !state.darkMode })),
        
      clearStore: () =>
        set({
          user: null,
          transactions: [],
          projects: [],
        })
    }),
    {
      name: 'ngo-storage',
    }
  )
)
ENDMARKER

# 4. IndexedDB Setup
cat > "lib/db.ts" << 'ENDMARKER'
import Dexie, { Table } from 'dexie'

export interface Transaction {
  id?: number
  type: string
  amount: number
  description: string
  date: Date
  category: string
  attachments?: any[]
  createdAt: Date
  updatedAt: Date
}

export interface Project {
  id?: number
  name: string
  description: string
  status: string
  budget: number
  startDate: Date
  endDate: Date
  createdAt: Date
}

class NGODatabase extends Dexie {
  transactions!: Table<Transaction>
  projects!: Table<Project>
  
  constructor() {
    super('NGODatabase')
    this.version(1).stores({
      transactions: '++id, type, date, category',
      projects: '++id, name, status, startDate'
    })
  }
}

export const db = new NGODatabase()
ENDMARKER

# 5. Toast Notifications
cat > "lib/notifications.ts" << 'ENDMARKER'
import toast from 'react-hot-toast'

export const notify = {
  success: (message: string) => {
    toast.success(message, {
      duration: 4000,
      position: 'top-right',
      style: {
        background: '#10b981',
        color: '#fff',
      },
    })
  },
  
  error: (message: string) => {
    toast.error(message, {
      duration: 4000,
      position: 'top-right',
      style: {
        background: '#ef4444',
        color: '#fff',
      },
    })
  },
  
  loading: (message: string) => {
    return toast.loading(message, {
      position: 'top-right',
    })
  },
  
  dismiss: (id: string) => {
    toast.dismiss(id)
  }
}
ENDMARKER

# 6. Form Validations
cat > "lib/validations.ts" << 'ENDMARKER'
import { z } from 'zod'

export const loginSchema = z.object({
  email: z.string().email('Geçerli email giriniz'),
  password: z.string().min(6, 'Şifre en az 6 karakter olmalı')
})

export const transactionSchema = z.object({
  type: z.enum(['income', 'expense', 'transfer']),
  amount: z.number().positive('Tutar pozitif olmalı'),
  description: z.string().min(3, 'Açıklama en az 3 karakter olmalı'),
  category: z.string(),
  date: z.date()
})

export const projectSchema = z.object({
  name: z.string().min(3, 'Proje adı en az 3 karakter olmalı'),
  description: z.string().optional(),
  budget: z.number().positive(),
  startDate: z.date(),
  endDate: z.date()
})
ENDMARKER

# 7. Loading Component
cat > "components/ui/Loading.tsx" << 'ENDMARKER'
import { motion } from 'framer-motion'

export function Loading() {
  return (
    <div className="flex items-center justify-center min-h-[400px]">
      <motion.div
        animate={{ rotate: 360 }}
        transition={{ duration: 1, repeat: Infinity, ease: 'linear' }}
        className="w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full"
      />
    </div>
  )
}

export function TableSkeleton({ rows = 5 }: { rows?: number }) {
  return (
    <div className="space-y-2">
      {Array.from({ length: rows }).map((_, i) => (
        <div key={i} className="h-16 bg-gray-100 dark:bg-gray-800 rounded-lg animate-pulse" />
      ))}
    </div>
  )
}
ENDMARKER

# 8. Updated Login Page with Store
cat > "app/(auth)/login/page-updated.tsx" << 'ENDMARKER'
'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { motion } from 'framer-motion'
import { Lock, Mail, Eye, EyeOff, LogIn } from 'lucide-react'
import { useStore } from '@/lib/store'
import { notify } from '@/lib/notifications'
import { Toaster } from 'react-hot-toast'

export default function LoginPage() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [loading, setLoading] = useState(false)
  const router = useRouter()
  const setUser = useStore((state) => state.setUser)

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)

    // Simulate login delay
    await new Promise(resolve => setTimeout(resolve, 1000))

    if (email === 'admin@ngo.org' && password === 'admin123') {
      const user = {
        id: '1',
        email,
        name: 'Admin User',
        role: 'admin'
      }
      
      setUser(user)
      localStorage.setItem('user', JSON.stringify(user))
      notify.success('Giriş başarılı! Yönlendiriliyorsunuz...')
      
      setTimeout(() => {
        router.push('/dashboard')
      }, 1000)
    } else {
      notify.error('Hatalı email veya şifre!')
      setLoading(false)
    }
  }

  return (
    <>
      <Toaster />
      <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-gray-900 dark:to-gray-800">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
          className="bg-white dark:bg-gray-800 p-8 rounded-2xl shadow-xl w-full max-w-md"
        >
          <div className="text-center mb-8">
            <h1 className="text-3xl font-bold text-gray-900 dark:text-white">STK Yönetim Sistemi</h1>
            <p className="text-gray-500 dark:text-gray-400 mt-2">Hesabınıza giriş yapın</p>
          </div>

          <form onSubmit={handleLogin} className="space-y-6">
            <div>
              <label htmlFor="email" className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                E-posta Adresi
              </label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
                <input
                  id="email"
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="w-full pl-10 pr-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="admin@ngo.org"
                  required
                  disabled={loading}
                />
              </div>
            </div>

            <div>
              <label htmlFor="password" className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Şifre
              </label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
                <input
                  id="password"
                  type={showPassword ? 'text' : 'password'}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="w-full pl-10 pr-12 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="••••••••"
                  required
                  disabled={loading}
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                  disabled={loading}
                >
                  {showPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
                </button>
              </div>
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-blue-600 text-white py-3 rounded-lg hover:bg-blue-700 transition-colors flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? (
                <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
              ) : (
                <>
                  <LogIn className="w-5 h-5" />
                  Giriş Yap
                </>
              )}
            </button>
          </form>

          <div className="mt-6 p-4 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
            <p className="text-sm text-gray-600 dark:text-gray-400">
              <strong>Test Girişi:</strong><br />
              Email: admin@ngo.org<br />
              Şifre: admin123
            </p>
          </div>
        </motion.div>
      </div>
    </>
  )
}
ENDMARKER

echo ""
echo "✅ Frontend optimizasyonları tamamlandı!"
echo ""
echo "📋 Eklenen özellikler:"
echo "  • Zustand (Global State Management)"
echo "  • IndexedDB (Offline Storage)"
echo "  • React Hot Toast (Bildirimler)"
echo "  • Form Validation (Zod)"
echo "  • Loading Components"
echo ""
echo "📌 Login sayfasını güncellemek için:"
echo "   mv app/(auth)/login/page-updated.tsx app/(auth)/login/page.tsx"
echo ""
echo "🚀 Test için: npm run dev"