#!/bin/bash
# install-ngo-system-part2.sh - Component Dosyaları

echo -e "${CYAN}════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}[6/10] Component dosyaları oluşturuluyor...${NC}"
echo -e "${CYAN}════════════════════════════════════════════════${NC}"

# =====================================================
# GLOBAL STYLES
# =====================================================

echo -e "${BLUE}📝 Global stil dosyası oluşturuluyor...${NC}"

cat > styles/globals.css << 'ENDOFSTYLES'
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --card: 0 0% 100%;
    --card-foreground: 222.2 84% 4.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 222.2 84% 4.9%;
    --primary: 221.2 83.2% 53.3%;
    --primary-foreground: 210 40% 98%;
    --secondary: 210 40% 96.1%;
    --secondary-foreground: 222.2 47.4% 11.2%;
    --muted: 210 40% 96.1%;
    --muted-foreground: 215.4 16.3% 46.9%;
    --accent: 210 40% 96.1%;
    --accent-foreground: 222.2 47.4% 11.2%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;
    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --ring: 221.2 83.2% 53.3%;
    --radius: 0.5rem;
  }

  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    --card: 222.2 84% 4.9%;
    --card-foreground: 210 40% 98%;
    --popover: 222.2 84% 4.9%;
    --popover-foreground: 210 40% 98%;
    --primary: 217.2 91.2% 59.8%;
    --primary-foreground: 222.2 47.4% 11.2%;
    --secondary: 217.2 32.6% 17.5%;
    --secondary-foreground: 210 40% 98%;
    --muted: 217.2 32.6% 17.5%;
    --muted-foreground: 215 20.2% 65.1%;
    --accent: 217.2 32.6% 17.5%;
    --accent-foreground: 210 40% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 40% 98%;
    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;
    --ring: 224.3 76.3% 48%;
  }
}

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground;
    font-feature-settings: "rlig" 1, "calt" 1;
  }
}

@layer components {
  .gradient-bg {
    @apply bg-gradient-to-br from-primary/10 via-accent/5 to-background;
  }
  
  .glass-effect {
    @apply bg-white/80 dark:bg-gray-900/80 backdrop-blur-lg;
  }
  
  .card-hover {
    @apply transition-all duration-200 hover:shadow-lg hover:-translate-y-1;
  }
  
  .text-gradient {
    @apply bg-gradient-to-r from-primary to-primary/60 bg-clip-text text-transparent;
  }

  .stat-card {
    @apply p-6 rounded-xl border bg-card shadow-sm hover:shadow-md transition-all;
  }

  .sidebar-link {
    @apply flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-medium transition-all hover:bg-accent hover:text-accent-foreground;
  }

  .sidebar-link-active {
    @apply bg-primary text-primary-foreground hover:bg-primary/90;
  }

  .btn-primary {
    @apply px-4 py-2 bg-primary text-primary-foreground rounded-lg hover:bg-primary/90 transition-colors;
  }

  .btn-secondary {
    @apply px-4 py-2 bg-secondary text-secondary-foreground rounded-lg hover:bg-secondary/80 transition-colors;
  }

  .btn-danger {
    @apply px-4 py-2 bg-destructive text-destructive-foreground rounded-lg hover:bg-destructive/90 transition-colors;
  }

  .input-base {
    @apply w-full px-4 py-2 bg-background border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary;
  }
}

/* Custom scrollbar */
@layer utilities {
  ::-webkit-scrollbar {
    width: 8px;
    height: 8px;
  }

  ::-webkit-scrollbar-track {
    @apply bg-muted;
  }

  ::-webkit-scrollbar-thumb {
    @apply bg-muted-foreground/30 rounded-md;
  }

  ::-webkit-scrollbar-thumb:hover {
    @apply bg-muted-foreground/40;
  }
}

/* Loading spinner */
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.animate-spin {
  animation: spin 1s linear infinite;
}

/* Print styles */
@media print {
  .no-print {
    display: none !important;
  }
}
ENDOFSTYLES

echo -e "${GREEN}✅ Stil dosyaları oluşturuldu${NC}"

# =====================================================
# APP LAYOUT DOSYALARI
# =====================================================

echo -e "${BLUE}📝 Ana layout dosyaları oluşturuluyor...${NC}"

# app/layout.tsx
cat > app/layout.tsx << 'ENDOFLAYOUT'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import '@/styles/globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'NGO Management System - STK Yönetim Sistemi',
  description: 'Modern ve kapsamlı STK yönetim platformu',
  authors: [{ name: 'ongassamaniger-blip' }],
  keywords: ['NGO', 'STK', 'Yönetim', 'Management', 'System'],
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="tr" suppressHydrationWarning>
      <body className={inter.className}>
        {children}
      </body>
    </html>
  )
}
ENDOFLAYOUT

# app/page.tsx
cat > app/page.tsx << 'ENDOFPAGE'
import { redirect } from 'next/navigation'

export default function Home() {
  redirect('/login')
}
ENDOFPAGE

# app/(auth)/layout.tsx
cat > 'app/(auth)/layout.tsx' << 'ENDOFAUTHLAYOUT'
export default function AuthLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-primary/10 via-accent/5 to-background">
      <div className="w-full max-w-md">
        {children}
      </div>
    </div>
  )
}
ENDOFAUTHLAYOUT

# app/(main)/layout.tsx
cat > 'app/(main)/layout.tsx' << 'ENDOFMAINLAYOUT'
import MainLayout from '@/components/layout/MainLayout'

export default function Layout({
  children,
}: {
  children: React.ReactNode
}) {
  return <MainLayout>{children}</MainLayout>
}
ENDOFMAINLAYOUT

# =====================================================
# LOGIN PAGE
# =====================================================

echo -e "${BLUE}📝 Login sayfası oluşturuluyor...${NC}"

cat > 'app/(auth)/login/page.tsx' << 'ENDOFLOGIN'
'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { motion } from 'framer-motion'
import { 
  Heart, Mail, Lock, Eye, EyeOff, 
  ArrowRight, Loader2, Github, Chrome
} from 'lucide-react'

export default function LoginPage() {
  const router = useRouter()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState('')
  const [rememberMe, setRememberMe] = useState(false)

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)
    setError('')

    // Validation
    if (!email || !password) {
      setError('Lütfen tüm alanları doldurun')
      setIsLoading(false)
      return
    }

    // Simulated login - replace with actual API call
    setTimeout(() => {
      if (email === 'admin@ngo.org' && password === 'admin123') {
        // Store auth token
        localStorage.setItem('authToken', 'demo-token-123')
        localStorage.setItem('userEmail', email)
        if (rememberMe) {
          localStorage.setItem('rememberMe', 'true')
        }
        router.push('/dashboard')
      } else {
        setError('Geçersiz email veya şifre')
        setIsLoading(false)
      }
    }, 1500)
  }

  const handleDemoLogin = () => {
    setEmail('admin@ngo.org')
    setPassword('admin123')
  }

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5 }}
      className="w-full"
    >
      <div className="bg-card rounded-2xl shadow-xl p-8">
        {/* Logo and Header */}
        <div className="text-center mb-8">
          <motion.div 
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={{ 
              type: "spring",
              stiffness: 260,
              damping: 20,
              delay: 0.1 
            }}
            className="w-20 h-20 bg-gradient-to-br from-primary to-primary/70 rounded-2xl flex items-center justify-center mx-auto mb-4 shadow-lg"
          >
            <Heart className="w-10 h-10 text-primary-foreground" />
          </motion.div>
          <h1 className="text-2xl font-bold bg-gradient-to-r from-primary to-primary/60 bg-clip-text text-transparent">
            NGO Management System
          </h1>
          <p className="text-muted-foreground mt-2">STK Yönetim Platformuna Hoş Geldiniz</p>
        </div>

        {/* Login Form */}
        <form onSubmit={handleLogin} className="space-y-6">
          {/* Error Message */}
          {error && (
            <motion.div
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              className="p-3 bg-red-500/10 border border-red-500/20 text-red-600 rounded-lg text-sm flex items-center gap-2"
            >
              <AlertCircle className="w-4 h-4" />
              {error}
            </motion.div>
          )}

          {/* Email Input */}
          <div className="space-y-2">
            <label htmlFor="email" className="text-sm font-medium block">
              Email Adresi
            </label>
            <div className="relative">
              <Mail className="w-5 h-5 absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
              <input
                id="email"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="admin@ngo.org"
                className="w-full pl-10 pr-4 py-3 bg-background border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary transition-all"
                required
                autoComplete="email"
              />
            </div>
          </div>

          {/* Password Input */}
          <div className="space-y-2">
            <label htmlFor="password" className="text-sm font-medium block">
              Şifre
            </label>
            <div className="relative">
              <Lock className="w-5 h-5 absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
              <input
                id="password"
                type={showPassword ? 'text' : 'password'}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••"
                className="w-full pl-10 pr-12 py-3 bg-background border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary transition-all"
                required
                autoComplete="current-password"
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute right-3 top-1/2 -translate-y-1/2 p-1 hover:bg-accent rounded transition-colors"
              >
                {showPassword ? (
                  <EyeOff className="w-5 h-5 text-muted-foreground" />
                ) : (
                  <Eye className="w-5 h-5 text-muted-foreground" />
                )}
              </button>
            </div>
          </div>

          {/* Remember Me & Forgot Password */}
          <div className="flex items-center justify-between">
            <label className="flex items-center gap-2 cursor-pointer">
              <input 
                type="checkbox" 
                checked={rememberMe}
                onChange={(e) => setRememberMe(e.target.checked)}
                className="w-4 h-4 rounded border-gray-300 text-primary focus:ring-primary"
              />
              <span className="text-sm select-none">Beni hatırla</span>
            </label>
            <a href="/forgot-password" className="text-sm text-primary hover:underline">
              Şifremi unuttum
            </a>
          </div>

          {/* Login Button */}
          <button
            type="submit"
            disabled={isLoading}
            className="w-full py-3 bg-gradient-to-r from-primary to-primary/80 text-primary-foreground rounded-lg font-medium hover:shadow-lg disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 transition-all"
          >
            {isLoading ? (
              <>
                <Loader2 className="w-5 h-5 animate-spin" />
                Giriş yapılıyor...
              </>
            ) : (
              <>
                Giriş Yap
                <ArrowRight className="w-5 h-5" />
              </>
            )}
          </button>

          {/* Divider */}
          <div className="relative">
            <div className="absolute inset-0 flex items-center">
              <div className="w-full border-t"></div>
            </div>
            <div className="relative flex justify-center text-sm">
              <span className="px-4 bg-card text-muted-foreground">veya</span>
            </div>
          </div>

          {/* Demo Login Button */}
          <button
            type="button"
            onClick={handleDemoLogin}
            className="w-full py-3 bg-accent hover:bg-accent/80 rounded-lg font-medium flex items-center justify-center gap-2 transition-all"
          >
            <Chrome className="w-5 h-5" />
            Demo Hesabı ile Giriş
          </button>
        </form>

        {/* Demo Info */}
        <div className="mt-6 p-4 bg-gradient-to-r from-primary/10 to-accent/10 rounded-lg border border-primary/20">
          <p className="text-sm text-center font-medium">
            📧 Demo Bilgileri
          </p>
          <p className="text-xs text-center text-muted-foreground mt-1">
            Email: admin@ngo.org | Şifre: admin123
          </p>
        </div>
      </div>

      {/* Footer */}
      <div className="text-center mt-6 space-y-2">
        <p className="text-sm text-muted-foreground">
          Developed by{' '}
          <a 
            href="https://github.com/ongassamaniger-blip" 
            target="_blank" 
            rel="noopener noreferrer"
            className="text-primary hover:underline inline-flex items-center gap-1"
          >
            <Github className="w-3 h-3" />
            ongassamaniger-blip
          </a>
        </p>
        <p className="text-xs text-muted-foreground">
          © 2025 NGO Management System v1.0.0
        </p>
      </div>
    </motion.div>
  )
}
ENDOFLOGIN

echo -e "${GREEN}✅ Login sayfası oluşturuldu${NC}"

# =====================================================
# MAIN LAYOUT COMPONENT
# =====================================================

echo -e "${BLUE}📝 MainLayout component oluşturuluyor...${NC}"

cat > 'components/layout/MainLayout.tsx' << 'ENDOFMAINLAYOUT'
'use client'

import React, { useState, useEffect } from 'react'
import Link from 'next/link'
import { usePathname, useRouter } from 'next/navigation'
import { motion, AnimatePresence } from 'framer-motion'
import {
  LayoutDashboard, Wallet, Building2, FolderOpen, Users, Heart,
  CheckCircle, Settings, Menu, X, ChevronDown, LogOut, User,
  Bell, Search, Moon, Sun, Globe, DollarSign, Euro, TrendingUp,
  FileText, BarChart3, Activity, Home, ChevronRight, Clock,
  Calendar, HelpCircle, Shield, Database, AlertCircle
} from 'lucide-react'

// Menu Items Configuration
const menuItems = [
  {
    id: 'dashboard',
    label: 'Dashboard',
    icon: LayoutDashboard,
    href: '/dashboard',
    badge: null
  },
  {
    id: 'cash',
    label: 'Kasa Yönetimi',
    icon: Wallet,
    href: '/cash',
    badge: '3',
    children: [
      { label: 'Genel Görünüm', href: '/cash' },
      { label: 'Gelirler', href: '/cash/income' },
      { label: 'Giderler', href: '/cash/expense' },
      { label: 'Transferler', href: '/cash/transfer' }
    ]
  },
  {
    id: 'facilities',
    label: 'Tesisler',
    icon: Building2,
    href: '/facilities',
    children: [
      { label: 'Tesis Listesi', href: '/facilities' },
      { label: 'Tesis Kasaları', href: '/facilities/cash' },
      { label: 'Tesis Personeli', href: '/facilities/personnel' }
    ]
  },
  {
    id: 'projects',
    label: 'Projeler',
    icon: FolderOpen,
    href: '/projects',
    children: [
      { label: 'Aktif Projeler', href: '/projects' },
      { label: 'Proje Planlaması', href: '/projects/planning' },
      { label: 'Faydalanıcılar', href: '/projects/beneficiaries' }
    ]
  },
  {
    id: 'personnel',
    label: 'Personel',
    icon: Users,
    href: '/personnel',
    children: [
      { label: 'Personel Listesi', href: '/personnel' },
      { label: 'Maaş Ödemeleri', href: '/personnel/payments' },
      { label: 'İzin Yönetimi', href: '/personnel/leaves' }
    ]
  },
  {
    id: 'sacrifice',
    label: 'Kurban',
    icon: Heart,
    href: '/sacrifice',
    children: [
      { label: 'Kurban Listesi', href: '/sacrifice' },
      { label: 'Hisse Yönetimi', href: '/sacrifice/shares' },
      { label: 'Kesim Takibi', href: '/sacrifice/slaughter' }
    ]
  },
  {
    id: 'approvals',
    label: 'Onaylar',
    icon: CheckCircle,
    href: '/approvals',
    badge: '5'
  },
  {
    id: 'reports',
    label: 'Raporlar',
    icon: BarChart3,
    href: '/reports',
    children: [
      { label: 'Finansal Raporlar', href: '/reports/financial' },
      { label: 'Operasyonel Raporlar', href: '/reports/operational' },
      { label: 'Özel Raporlar', href: '/reports/custom' }
    ]
  },
  {
    id: 'settings',
    label: 'Ayarlar',
    icon: Settings,
    href: '/settings',
    children: [
      { label: 'Genel Ayarlar', href: '/settings' },
      { label: 'Kullanıcılar', href: '/settings/users' },
      { label: 'Roller ve Yetkiler', href: '/settings/roles' }
    ]
  }
]

// Currencies
const currencies = [
  { code: 'TRY', symbol: '₺', flag: '🇹🇷' },
  { code: 'USD', symbol: '$', flag: '🇺🇸' },
  { code: 'EUR', symbol: '€', flag: '🇪🇺' }
]

// Languages
const languages = [
  { code: 'tr', label: 'Türkçe', flag: '🇹🇷' },
  { code: 'en', label: 'English', flag: '🇬🇧' },
  { code: 'fr', label: 'Français', flag: '🇫🇷' }
]

export default function MainLayout({ children }: { children: React.ReactNode }) {
  const pathname = usePathname()
  const router = useRouter()
  const [sidebarOpen, setSidebarOpen] = useState(true)
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false)
  const [expandedMenus, setExpandedMenus] = useState<string[]>(['cash'])
  const [darkMode, setDarkMode] = useState(false)
  const [currentCurrency, setCurrentCurrency] = useState('TRY')
  const [currentLanguage, setCurrentLanguage] = useState('tr')
  const [showNotifications, setShowNotifications] = useState(false)
  const [showUserMenu, setShowUserMenu] = useState(false)
  const [notifications, setNotifications] = useState([
    { id: 1, title: 'Yeni onay talebi', desc: '5,000 TRY transfer talebi', time: '2 dakika önce', unread: true },
    { id: 2, title: 'İşlem onaylandı', desc: 'Personel maaş ödemesi tamamlandı', time: '1 saat önce', unread: true },
    { id: 3, title: 'Bütçe uyarısı', desc: 'Proje X bütçesinin %85\'i kullanıldı', time: '3 saat önce', unread: false }
  ])

  // Check authentication
  useEffect(() => {
    const token = localStorage.getItem('authToken')
    if (!token) {
      router.push('/login')
    }
  }, [router])

  // Dark mode persistence
  useEffect(() => {
    const isDark = localStorage.getItem('darkMode') === 'true'
    setDarkMode(isDark)
    if (isDark) {
      document.documentElement.classList.add('dark')
    }
  }, [])

  const toggleDarkMode = () => {
    const newMode = !darkMode
    setDarkMode(newMode)
    localStorage.setItem('darkMode', newMode.toString())
    if (newMode) {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
  }

  const toggleMenu = (menuId: string) => {
    setExpandedMenus(prev =>
      prev.includes(menuId)
        ? prev.filter(id => id !== menuId)
        : [...prev, menuId]
    )
  }

  const isActive = (href: string) => pathname === href || pathname.startsWith(href + '/')

  const handleLogout = () => {
    localStorage.removeItem('authToken')
    localStorage.removeItem('userEmail')
    router.push('/login')
  }

  return (
    <div className="min-h-screen bg-background">
      <div className="flex h-screen">
        {/* Sidebar */}
        <AnimatePresence mode="wait">
          {(sidebarOpen || mobileMenuOpen) && (
            <motion.aside
              initial={{ x: -280 }}
              animate={{ x: 0 }}
              exit={{ x: -280 }}
              transition={{ duration: 0.3, ease: 'easeInOut' }}
              className={`
                ${mobileMenuOpen ? 'fixed' : 'relative'}
                ${sidebarOpen ? 'w-64' : 'w-0'}
                z-40 flex flex-col h-full bg-card border-r shadow-lg
                lg:relative lg:w-64
              `}
            >
              {/* Sidebar Header */}
              <div className="p-4 border-b">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-gradient-to-br from-primary to-primary/70 rounded-lg flex items-center justify-center">
                      <Heart className="w-6 h-6 text-primary-foreground" />
                    </div>
                    <div>
                      <h1 className="text-lg font-bold">NGO System</h1>
                      <p className="text-xs text-muted-foreground">v1.0.0</p>
                    </div>
                  </div>
                  <button
                    onClick={() => {
                      setSidebarOpen(false)
                      setMobileMenuOpen(false)
                    }}
                    className="lg:hidden p-1 hover:bg-accent rounded-lg"
                  >
                    <X className="w-5 h-5" />
                  </button>
                </div>
              </div>

              {/* Navigation */}
              <nav className="flex-1 overflow-y-auto py-4">
                <ul className="space-y-1 px-3">
                  {menuItems.map((item) => (
                    <li key={item.id}>
                      <div className="relative">
                        <Link
                          href={item.href}
                          className={`
                            sidebar-link
                            ${isActive(item.href) ? 'sidebar-link-active' : ''}
                            ${item.children ? 'pr-8' : ''}
                          `}
                          onClick={(e) => {
                            if (item.children) {
                              e.preventDefault()
                              toggleMenu(item.id)
                            } else {
                              setMobileMenuOpen(false)
                            }
                          }}
                        >
                          <item.icon className="w-5 h-5 flex-shrink-0" />
                          <span className="flex-1">{item.label}</span>
                          {item.badge && (
                            <span className="px-2 py-0.5 text-xs bg-destructive text-destructive-foreground rounded-full">
                              {item.badge}
                            </span>
                          )}
                          {item.children && (
                            <ChevronDown
                              className={`
                                w-4 h-4 absolute right-2 top-1/2 -translate-y-1/2 transition-transform
                                ${expandedMenus.includes(item.id) ? 'rotate-180' : ''}
                              `}
                            />
                          )}
                        </Link>
                      </div>

                      {/* Submenu */}
                      <AnimatePresence>
                        {item.children && expandedMenus.includes(item.id) && (
                          <motion.ul
                            initial={{ height: 0, opacity: 0 }}
                            animate={{ height: 'auto', opacity: 1 }}
                            exit={{ height: 0, opacity: 0 }}
                            transition={{ duration: 0.2 }}
                            className="mt-1 ml-4 pl-4 border-l border-border space-y-1 overflow-hidden"
                          >
                            {item.children.map((child) => (
                              <li key={child.href}>
                                <Link
                                  href={child.href}
                                  className={`
                                    sidebar-link text-sm
                                    ${isActive(child.href) ? 'text-primary font-semibold' : 'text-muted-foreground'}
                                  `}
                                  onClick={() => setMobileMenuOpen(false)}
                                >
                                  {child.label}
                                </Link>
                              </li>
                            ))}
                          </motion.ul>
                        )}
                      </AnimatePresence>
                    </li>
                  ))}
                </ul>
              </nav>

              {/* Sidebar Footer */}
              <div className="p-4 border-t space-y-4">
                {/* Quick Stats */}
                <div className="grid grid-cols-2 gap-2 text-xs">
                  <div className="bg-accent rounded-lg p-2">
                    <p className="text-muted-foreground">Günlük İşlem</p>
                    <p className="text-lg font-bold">127</p>
                  </div>
                  <div className="bg-accent rounded-lg p-2">
                    <p className="text-muted-foreground">Aktif Proje</p>
                    <p className="text-lg font-bold">8</p>
                  </div>
                </div>

                {/* User Info */}
                <div className="flex items-center gap-3 p-2 bg-accent rounded-lg">
                  <div className="w-8 h-8 bg-primary rounded-full flex items-center justify-center">
                    <User className="w-4 h-4 text-primary-foreground" />
                  </div>
                  <div className="flex-1">
                    <p className="text-sm font-medium">Admin User</p>
                    <p className="text-xs text-muted-foreground">admin@ngo.org</p>
                  </div>
                </div>
              </div>
            </motion.aside>
          )}
        </AnimatePresence>

        {/* Main Content */}
        <div className="flex-1 flex flex-col overflow-hidden">
          {/* Header */}
          <header className="h-16 bg-card border-b px-4 lg:px-6 flex-shrink-0">
            <div className="h-full flex items-center justify-between">
              <div className="flex items-center gap-4">
                <button
                  onClick={() => setSidebarOpen(!sidebarOpen)}
                  className="p-2 hover:bg-accent rounded-lg hidden lg:block"
                >
                  <Menu className="w-5 h-5" />
                </button>
                <button
                  onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
                  className="p-2 hover:bg-accent rounded-lg lg:hidden"
                >
                  <Menu className="w-5 h-5" />
                </button>

                {/* Breadcrumb */}
                <div className="hidden md:flex items-center gap-2 text-sm">
                  <Home className="w-4 h-4" />
                  <ChevronRight className="w-4 h-4 text-muted-foreground" />
                  <span>Dashboard</span>
                </div>

                {/* Search */}
                <div className="relative hidden md:block">
                  <Search className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
                  <input
                    type="text"
                    placeholder="Ara... (Ctrl+K)"
                    className="pl-9 pr-4 py-2 w-64 bg-accent rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>
              </div>

              <div className="flex items-center gap-2">
                {/* Currency Selector */}
                <select
                  value={currentCurrency}
                  onChange={(e) => setCurrentCurrency(e.target.value)}
                  className="px-3 py-2 bg-accent rounded-lg text-sm"
                >
                  {currencies.map(curr => (
                    <option key={curr.code} value={curr.code}>
                      {curr.flag} {curr.code}
                    </option>
                  ))}
                </select>

                {/* Notifications */}
                <div className="relative">
                  <button
                    onClick={() => setShowNotifications(!showNotifications)}
                    className="relative p-2 hover:bg-accent rounded-lg"
                  >
                    <Bell className="w-5 h-5" />
                    {notifications.some(n => n.unread) && (
                      <span className="absolute top-1 right-1 w-2 h-2 bg-destructive rounded-full"></span>
                    )}
                  </button>

                  {/* Notifications Dropdown */}
                  {showNotifications && (
                    <div className="absolute right-0 top-full mt-2 w-80 bg-card border rounded-lg shadow-lg z-50">
                      <div className="p-3 border-b">
                        <h3 className="font-semibold">Bildirimler</h3>
                      </div>
                      <div className="max-h-96 overflow-y-auto">
                        {notifications.map(notif => (
                          <div key={notif.id} className="p-3 hover:bg-accent border-b last:border-0">
                            <div className="flex items-start gap-3">
                              <div className={`w-2 h-2 rounded-full mt-1.5 ${notif.unread ? 'bg-primary' : 'bg-muted'}`}></div>
                              <div className="flex-1">
                                <p className="text-sm font-medium">{notif.title}</p>
                                <p className="text-xs text-muted-foreground mt-1">{notif.desc}</p>
                                <p className="text-xs text-muted-foreground mt-1">{notif.time}</p>
                              </div>
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>
                  )}
                </div>

                {/* Dark Mode Toggle */}
                <button
                  onClick={toggleDarkMode}
                  className="p-2 hover:bg-accent rounded-lg"
                >
                  {darkMode ? <Sun className="w-5 h-5" /> : <Moon className="w-5 h-5" />}
                </button>

                {/* User Menu */}
                <div className="relative">
                  <button
                    onClick={() => setShowUserMenu(!showUserMenu)}
                    className="flex items-center gap-2 p-2 hover:bg-accent rounded-lg"
                  >
                    <div className="w-8 h-8 bg-primary rounded-full flex items-center justify-center">
                      <User className="w-4 h-4 text-primary-foreground" />
                    </div>
                    <ChevronDown className="w-4 h-4" />
                  </button>

                  {/* User Dropdown */}
                  {showUserMenu && (
                    <div className="absolute right-0 top-full mt-2 w-56 bg-card border rounded-lg shadow-lg z-50">
                      <div className="p-3 border-b">
                        <p className="font-medium">Admin User</p>
                        <p className="text-sm text-muted-foreground">admin@ngo.org</p>
                      </div>
                      <div className="p-2">
                        <Link href="/settings" className="flex items-center gap-2 px-3 py-2 hover:bg-accent rounded-lg">
                          <User className="w-4 h-4" />
                          <span>Profil</span>
                        </Link>
                        <Link href="/settings" className="flex items-center gap-2 px-3 py-2 hover:bg-accent rounded-lg">
                          <Settings className="w-4 h-4" />
                          <span>Ayarlar</span>
                        </Link>
                        <hr className="my-2" />
                        <button 
                          onClick={handleLogout}
                          className="w-full flex items-center gap-2 px-3 py-2 hover:bg-accent rounded-lg text-destructive"
                        >
                          <LogOut className="w-4 h-4" />
                          <span>Çıkış Yap</span>
                        </button>
                      </div>
                    </div>
                  )}
                </div>
              </div>
            </div>
          </header>

          {/* Page Content */}
          <main className="flex-1 overflow-y-auto bg-muted/30">
            <div className="p-4 lg:p-6">
              {children}
            </div>
          </main>
        </div>
      </div>
    </div>
  )
}
ENDOFMAINLAYOUT

echo -e "${GREEN}✅ MainLayout component oluşturuldu${NC}"
echo ""

# =====================================================
# DEVAM...
# =====================================================

echo -e "${CYAN}════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}Temel yapı tamamlandı. Dashboard ve diğer componentler oluşturuluyor...${NC}"
echo -e "${CYAN}════════════════════════════════════════════════${NC}"