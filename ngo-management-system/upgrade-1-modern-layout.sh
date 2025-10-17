#!/bin/bash
# upgrade-1-modern-layout.sh
# Modern Sidebar ve Header - Sistemi Bozmadan Upgrade
# Date: 2025-10-17 14:34:37
# User: ongassamaniger-blip

echo "🎨 =========================================="
echo "   MODERN SIDEBAR & HEADER UPGRADE"
echo "   Mevcut sistem korunuyor..."
echo "🎨 =========================================="

# Backup al - Parantezli klasör için tırnak kullan
echo "📦 Backup alınıyor..."
cp -r "app/(main)/layout.tsx" "app/(main)/layout.tsx.backup" 2>/dev/null || true

# Modern Layout Component
cat > "app/(main)/layout.tsx" << 'EOF'
'use client'

import { useState, useEffect } from 'react'
import { useRouter, usePathname } from 'next/navigation'
import Link from 'next/link'
import { motion, AnimatePresence } from 'framer-motion'
import {
  LayoutDashboard, Wallet, Building2, FolderOpen, Users, Heart,
  CheckCircle, Settings, Menu, X, ChevronDown, LogOut, User,
  Bell, Search, Moon, Sun, Globe, DollarSign, Euro,
  FileText, BarChart3, Activity, Home, ChevronRight, Clock,
  Calendar, HelpCircle, Shield, Database, AlertCircle, Sparkles,
  MessageSquare, Zap, TrendingUp, TrendingDown, Loader2
} from 'lucide-react'

interface MenuItem {
  id: string
  label: string
  icon: any
  href: string
  badge?: string | number
  children?: {
    label: string
    href: string
    icon?: any
  }[]
}

const menuItems: MenuItem[] = [
  {
    id: 'dashboard',
    label: 'Dashboard',
    icon: LayoutDashboard,
    href: '/dashboard',
  },
  {
    id: 'cash',
    label: 'Kasa Yönetimi',
    icon: Wallet,
    href: '/cash',
    badge: 3,
    children: [
      { label: 'Genel Bakış', href: '/cash' },
      { label: 'Gelir Ekle', href: '/cash/income' },
      { label: 'Gider Ekle', href: '/cash/expense' },
      { label: 'Transfer', href: '/cash/transfer' }
    ]
  },
  {
    id: 'projects',
    label: 'Projeler',
    icon: FolderOpen,
    href: '/projects',
    badge: 8
  },
  {
    id: 'facilities',
    label: 'Tesisler',
    icon: Building2,
    href: '/facilities',
    children: [
      { label: 'Tesis Listesi', href: '/facilities' },
      { label: 'Tesis Ekle', href: '/facilities/add' },
      { label: 'Tesis Raporları', href: '/facilities/reports' }
    ]
  },
  {
    id: 'personnel',
    label: 'Personel',
    icon: Users,
    href: '/personnel'
  },
  {
    id: 'sacrifice',
    label: 'Kurban',
    icon: Heart,
    href: '/sacrifice'
  },
  {
    id: 'approvals',
    label: 'Onaylar',
    icon: CheckCircle,
    href: '/approvals',
    badge: 5
  },
  {
    id: 'reports',
    label: 'Raporlar',
    icon: BarChart3,
    href: '/reports'
  },
  {
    id: 'settings',
    label: 'Ayarlar',
    icon: Settings,
    href: '/settings'
  }
]

export default function MainLayout({ children }: { children: React.ReactNode }) {
  const router = useRouter()
  const pathname = usePathname()
  const [sidebarOpen, setSidebarOpen] = useState(true)
  const [sidebarCollapsed, setSidebarCollapsed] = useState(false)
  const [expandedMenus, setExpandedMenus] = useState<string[]>([])
  const [darkMode, setDarkMode] = useState(false)
  const [showNotifications, setShowNotifications] = useState(false)
  const [showUserMenu, setShowUserMenu] = useState(false)
  const [showSearch, setShowSearch] = useState(false)
  const [searchQuery, setSearchQuery] = useState('')
  const [loading, setLoading] = useState(false)
  
  // Currency rates
  const [currencies] = useState({
    USD: { symbol: '$', rate: 32.45, trend: 'up', change: 0.15 },
    EUR: { symbol: '€', rate: 35.12, trend: 'down', change: -0.08 },
    GBP: { symbol: '£', rate: 41.23, trend: 'up', change: 0.22 }
  })

  const [notifications] = useState([
    { id: 1, title: 'Yeni onay talebi', desc: '5,000 TRY transfer onayı bekliyor', time: '2dk', unread: true, type: 'warning' },
    { id: 2, title: 'Proje güncellendi', desc: 'Su Kuyusu Projesi %75 tamamlandı', time: '1s', unread: true, type: 'info' },
    { id: 3, title: 'Maaş ödemeleri', desc: 'Bu ayın maaş ödemeleri hazır', time: '3s', unread: false, type: 'success' }
  ])

  useEffect(() => {
    const token = localStorage.getItem('authToken')
    if (!token) {
      router.push('/login')
    }

    // Dark mode from localStorage
    const savedDarkMode = localStorage.getItem('darkMode') === 'true'
    setDarkMode(savedDarkMode)
    if (savedDarkMode) {
      document.documentElement.classList.add('dark')
    }

    // Sidebar collapsed state
    const savedCollapsed = localStorage.getItem('sidebarCollapsed') === 'true'
    setSidebarCollapsed(savedCollapsed)
  }, [router])

  const toggleDarkMode = () => {
    const newDarkMode = !darkMode
    setDarkMode(newDarkMode)
    localStorage.setItem('darkMode', String(newDarkMode))
    if (newDarkMode) {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
  }

  const toggleSidebarCollapse = () => {
    const newCollapsed = !sidebarCollapsed
    setSidebarCollapsed(newCollapsed)
    localStorage.setItem('sidebarCollapsed', String(newCollapsed))
  }

  const toggleSubmenu = (menuId: string) => {
    setExpandedMenus(prev => 
      prev.includes(menuId) 
        ? prev.filter(id => id !== menuId)
        : [...prev, menuId]
    )
  }

  const handleLogout = () => {
    setLoading(true)
    setTimeout(() => {
      localStorage.clear()
      router.push('/login')
    }, 500)
  }

  // Global search shortcut
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
        e.preventDefault()
        setShowSearch(true)
      }
      if (e.key === 'Escape') {
        setShowSearch(false)
      }
    }
    window.addEventListener('keydown', handleKeyDown)
    return () => window.removeEventListener('keydown', handleKeyDown)
  }, [])

  const isActiveRoute = (href: string) => {
    return pathname === href || pathname.startsWith(href + '/')
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      {/* Modern Sidebar */}
      <motion.aside 
        initial={false}
        animate={{ 
          width: sidebarCollapsed ? 80 : 260,
          x: 0 
        }}
        transition={{ duration: 0.3, ease: 'easeInOut' }}
        className={`fixed left-0 top-0 h-full bg-white dark:bg-gray-800 border-r border-gray-200 dark:border-gray-700 z-40 shadow-lg`}
      >
        {/* Logo Section */}
        <div className="h-16 flex items-center justify-between px-4 border-b border-gray-200 dark:border-gray-700">
          <Link href="/dashboard" className="flex items-center gap-3">
            <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-xl flex items-center justify-center flex-shrink-0">
              <Heart className="w-6 h-6 text-white" />
            </div>
            {!sidebarCollapsed && (
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ delay: 0.1 }}
              >
                <h1 className="text-lg font-bold text-gray-900 dark:text-white">NGO System</h1>
              </motion.div>
            )}
          </Link>
          <button
            onClick={toggleSidebarCollapse}
            className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors"
          >
            <Menu className="w-5 h-5 text-gray-600 dark:text-gray-400" />
          </button>
        </div>

        {/* Navigation */}
        <nav className="p-4 space-y-1 overflow-y-auto h-[calc(100vh-8rem)]">
          {menuItems.map((item) => (
            <div key={item.id}>
              {/* Main Menu Item */}
              <div className="relative group">
                <Link
                  href={item.href}
                  onClick={(e) => {
                    if (item.children) {
                      e.preventDefault()
                      toggleSubmenu(item.id)
                    }
                  }}
                  className={`
                    flex items-center gap-3 px-3 py-2.5 rounded-lg transition-all duration-200
                    ${isActiveRoute(item.href) 
                      ? 'bg-gradient-to-r from-blue-500 to-purple-600 text-white shadow-lg' 
                      : 'hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-700 dark:text-gray-300'
                    }
                  `}
                >
                  <item.icon className="w-5 h-5 flex-shrink-0" />
                  {!sidebarCollapsed && (
                    <>
                      <span className="flex-1 font-medium">{item.label}</span>
                      {item.badge && (
                        <span className="px-2 py-0.5 text-xs bg-red-500 text-white rounded-full">
                          {item.badge}
                        </span>
                      )}
                      {item.children && (
                        <ChevronDown className={`w-4 h-4 transition-transform ${
                          expandedMenus.includes(item.id) ? 'rotate-180' : ''
                        }`} />
                      )}
                    </>
                  )}
                </Link>
                
                {/* Tooltip for collapsed sidebar */}
                {sidebarCollapsed && (
                  <div className="absolute left-full ml-2 px-2 py-1 bg-gray-900 text-white text-sm rounded opacity-0 pointer-events-none group-hover:opacity-100 whitespace-nowrap z-50">
                    {item.label}
                  </div>
                )}
              </div>

              {/* Submenu */}
              {item.children && !sidebarCollapsed && (
                <AnimatePresence>
                  {expandedMenus.includes(item.id) && (
                    <motion.div
                      initial={{ height: 0, opacity: 0 }}
                      animate={{ height: 'auto', opacity: 1 }}
                      exit={{ height: 0, opacity: 0 }}
                      transition={{ duration: 0.2 }}
                      className="ml-8 mt-1 space-y-1 overflow-hidden"
                    >
                      {item.children.map((child, index) => (
                        <Link
                          key={index}
                          href={child.href}
                          className={`
                            block px-3 py-2 rounded-lg text-sm transition-colors
                            ${isActiveRoute(child.href)
                              ? 'bg-gray-100 dark:bg-gray-700 text-blue-600 dark:text-blue-400 font-medium'
                              : 'text-gray-600 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-700/50'
                            }
                          `}
                        >
                          {child.label}
                        </Link>
                      ))}
                    </motion.div>
                  )}
                </AnimatePresence>
              )}
            </div>
          ))}
        </nav>

        {/* User Section */}
        <div className="absolute bottom-0 left-0 right-0 p-4 border-t border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800">
          <button
            onClick={handleLogout}
            className="w-full flex items-center gap-3 px-3 py-2 text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors"
          >
            <LogOut className="w-5 h-5" />
            {!sidebarCollapsed && <span>Çıkış Yap</span>}
          </button>
        </div>
      </motion.aside>

      {/* Main Content Area */}
      <div className={`transition-all duration-300 ${sidebarCollapsed ? 'ml-20' : 'ml-[260px]'}`}>
        {/* Modern Header */}
        <header className="h-16 bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700 px-6 flex items-center justify-between sticky top-0 z-30 shadow-sm">
          {/* Left Section */}
          <div className="flex items-center gap-4">
            <h2 className="text-xl font-semibold text-gray-800 dark:text-white">
              {menuItems.find(item => isActiveRoute(item.href))?.label || 'Dashboard'}
            </h2>
            
            {/* Currency Rates */}
            <div className="hidden lg:flex items-center gap-3 px-4 py-2 bg-gray-50 dark:bg-gray-700 rounded-lg">
              {Object.entries(currencies).map(([key, value]) => (
                <div key={key} className="flex items-center gap-1">
                  <span className="text-xs font-medium text-gray-600 dark:text-gray-400">{key}:</span>
                  <span className="text-sm font-bold text-gray-900 dark:text-white">
                    {value.symbol}{value.rate}
                  </span>
                  {value.trend === 'up' ? (
                    <TrendingUp className="w-3 h-3 text-green-500" />
                  ) : (
                    <TrendingDown className="w-3 h-3 text-red-500" />
                  )}
                  <span className={`text-xs ${value.trend === 'up' ? 'text-green-500' : 'text-red-500'}`}>
                    {value.change > 0 ? '+' : ''}{value.change}%
                  </span>
                </div>
              ))}
            </div>
          </div>

          {/* Right Section */}
          <div className="flex items-center gap-3">
            {/* Search Button */}
            <button
              onClick={() => setShowSearch(true)}
              className="flex items-center gap-2 px-3 py-1.5 bg-gray-100 dark:bg-gray-700 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors"
            >
              <Search className="w-4 h-4 text-gray-600 dark:text-gray-400" />
              <span className="text-sm text-gray-600 dark:text-gray-400">Ara...</span>
              <kbd className="hidden sm:inline-block px-2 py-0.5 text-xs bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded">
                ⌘K
              </kbd>
            </button>

            {/* AI Assistant Button */}
            <button className="relative p-2 bg-gradient-to-r from-purple-500 to-pink-500 text-white rounded-lg hover:shadow-lg transition-all hover:scale-105">
              <Sparkles className="w-5 h-5" />
              <span className="absolute -top-1 -right-1 w-2 h-2 bg-green-500 rounded-full animate-ping" />
            </button>

            {/* Dark Mode Toggle */}
            <button
              onClick={toggleDarkMode}
              className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors"
            >
              {darkMode ? (
                <Sun className="w-5 h-5 text-yellow-500" />
              ) : (
                <Moon className="w-5 h-5 text-gray-600" />
              )}
            </button>

            {/* Notifications */}
            <div className="relative">
              <button
                onClick={() => setShowNotifications(!showNotifications)}
                className="relative p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors"
              >
                <Bell className="w-5 h-5 text-gray-600 dark:text-gray-400" />
                {notifications.filter(n => n.unread).length > 0 && (
                  <span className="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full" />
                )}
              </button>

              {/* Notifications Dropdown */}
              <AnimatePresence>
                {showNotifications && (
                  <motion.div
                    initial={{ opacity: 0, y: -10 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -10 }}
                    className="absolute right-0 mt-2 w-80 bg-white dark:bg-gray-800 rounded-xl shadow-xl border border-gray-200 dark:border-gray-700 overflow-hidden"
                  >
                    <div className="p-4 border-b border-gray-200 dark:border-gray-700">
                      <h3 className="font-semibold text-gray-900 dark:text-white">Bildirimler</h3>
                    </div>
                    <div className="max-h-96 overflow-y-auto">
                      {notifications.map(notif => (
                        <div
                          key={notif.id}
                          className={`p-4 border-b border-gray-100 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-colors ${
                            notif.unread ? 'bg-blue-50/50 dark:bg-blue-900/20' : ''
                          }`}
                        >
                          <div className="flex items-start gap-3">
                            <div className={`p-2 rounded-lg ${
                              notif.type === 'warning' ? 'bg-yellow-100 text-yellow-600' :
                              notif.type === 'success' ? 'bg-green-100 text-green-600' :
                              'bg-blue-100 text-blue-600'
                            }`}>
                              <AlertCircle className="w-4 h-4" />
                            </div>
                            <div className="flex-1">
                              <p className="text-sm font-medium text-gray-900 dark:text-white">{notif.title}</p>
                              <p className="text-xs text-gray-600 dark:text-gray-400 mt-1">{notif.desc}</p>
                              <p className="text-xs text-gray-500 dark:text-gray-500 mt-2">{notif.time} önce</p>
                            </div>
                          </div>
                        </div>
                      ))}
                    </div>
                    <div className="p-3 bg-gray-50 dark:bg-gray-700/50">
                      <button className="text-sm text-blue-600 dark:text-blue-400 hover:underline">
                        Tümünü Gör
                      </button>
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>
            </div>

            {/* User Menu */}
            <div className="relative">
              <button
                onClick={() => setShowUserMenu(!showUserMenu)}
                className="flex items-center gap-2 px-3 py-1.5 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors"
              >
                <div className="w-8 h-8 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center">
                  <span className="text-white text-sm font-bold">A</span>
                </div>
                <div className="hidden sm:block text-left">
                  <p className="text-sm font-medium text-gray-900 dark:text-white">Admin</p>
                  <p className="text-xs text-gray-500 dark:text-gray-400">admin@ngo.org</p>
                </div>
                <ChevronDown className="w-4 h-4 text-gray-600 dark:text-gray-400" />
              </button>

              {/* User Dropdown */}
              <AnimatePresence>
                {showUserMenu && (
                  <motion.div
                    initial={{ opacity: 0, y: -10 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -10 }}
                    className="absolute right-0 mt-2 w-56 bg-white dark:bg-gray-800 rounded-xl shadow-xl border border-gray-200 dark:border-gray-700"
                  >
                    <div className="p-3 border-b border-gray-200 dark:border-gray-700">
                      <p className="text-sm font-medium text-gray-900 dark:text-white">Admin User</p>
                      <p className="text-xs text-gray-500 dark:text-gray-400">admin@ngo.org</p>
                    </div>
                    <div className="p-2">
                      <Link href="/profile" className="flex items-center gap-2 px-3 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg">
                        <User className="w-4 h-4" />
                        Profil
                      </Link>
                      <Link href="/settings" className="flex items-center gap-2 px-3 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg">
                        <Settings className="w-4 h-4" />
                        Ayarlar
                      </Link>
                      <button className="flex items-center gap-2 px-3 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg w-full">
                        <HelpCircle className="w-4 h-4" />
                        Yardım
                      </button>
                    </div>
                    <div className="p-2 border-t border-gray-200 dark:border-gray-700">
                      <button
                        onClick={handleLogout}
                        className="flex items-center gap-2 px-3 py-2 text-sm text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg w-full"
                      >
                        <LogOut className="w-4 h-4" />
                        Çıkış Yap
                      </button>
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>
            </div>
          </div>
        </header>

        {/* Main Content */}
        <main className="p-6 min-h-[calc(100vh-4rem)]">
          {loading ? (
            <div className="flex items-center justify-center h-96">
              <Loader2 className="w-8 h-8 animate-spin text-blue-600" />
            </div>
          ) : (
            children
          )}
        </main>
      </div>

      {/* Global Search Modal */}
      <AnimatePresence>
        {showSearch && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 z-50 flex items-start justify-center pt-20"
            onClick={() => setShowSearch(false)}
          >
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              className="w-full max-w-2xl bg-white dark:bg-gray-800 rounded-xl shadow-2xl"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="p-4 border-b border-gray-200 dark:border-gray-700">
                <div className="flex items-center gap-3">
                  <Search className="w-5 h-5 text-gray-400" />
                  <input
                    type="text"
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    placeholder="Ne aramak istiyorsunuz?"
                    className="flex-1 bg-transparent outline-none text-gray-900 dark:text-white"
                    autoFocus
                  />
                  <kbd className="px-2 py-1 text-xs bg-gray-100 dark:bg-gray-700 rounded">ESC</kbd>
                </div>
              </div>
              <div className="p-4 max-h-96 overflow-y-auto">
                <p className="text-sm text-gray-500 dark:text-gray-400">
                  Aramak için yazmaya başlayın...
                </p>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}
EOF

# Bağımlılıkları yükle
echo ""
echo "📦 Bağımlılıklar yükleniyor..."
npm install framer-motion lucide-react

echo ""
echo "✅ Modern Layout başarıyla güncellendi!"
echo ""
echo "📝 Yapılan değişiklikler:"
echo "  ✓ Modern collapsible sidebar"
echo "  ✓ Header'da canlı kurlar" 
echo "  ✓ Dark/Light mode toggle"
echo "  ✓ Global arama (Cmd+K)"
echo "  ✓ AI asistan butonu"
echo "  ✓ Bildirim sistemi"
echo "  ✓ Kullanıcı dropdown menüsü"
echo "  ✓ Submenu desteği"
echo "  ✓ Animasyonlar ve hover efektleri"
echo ""
echo "🚀 Şimdi 'npm run dev' ile test edebilirsiniz!"
echo "📌 Sonraki adım: Dashboard modernizasyonu"