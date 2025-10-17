#!/bin/bash
# create-all-files.sh - TÜM DOSYALARI OLUŞTUR
# Run: bash create-all-files.sh

echo "🚀 NGO Management System - TÜM DOSYALAR OLUŞTURULUYOR..."
echo "=================================================="

# =====================================================
# 1. STYLES DOSYASI
# =====================================================
echo "📝 [1/20] Global styles oluşturuluyor..."

cat > styles/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --background: 0 0% 100%;
  --foreground: 222.2 84% 4.9%;
  --card: 0 0% 100%;
  --card-foreground: 222.2 84% 4.9%;
  --primary: 221.2 83.2% 53.3%;
  --primary-foreground: 210 40% 98%;
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

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  background: hsl(var(--background));
  color: hsl(var(--foreground));
  font-family: system-ui, -apple-system, sans-serif;
}

.container {
  width: 100%;
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 1rem;
}
EOF

# =====================================================
# 2. ANA LAYOUT
# =====================================================
echo "📝 [2/20] Ana layout oluşturuluyor..."

cat > app/layout.tsx << 'EOF'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import '@/styles/globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'NGO Management System',
  description: 'STK Yönetim Sistemi',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="tr">
      <body className={inter.className}>
        {children}
      </body>
    </html>
  )
}
EOF

# =====================================================
# 3. ANA SAYFA
# =====================================================
echo "📝 [3/20] Ana sayfa oluşturuluyor..."

cat > app/page.tsx << 'EOF'
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
EOF

# =====================================================
# 4. AUTH LAYOUT
# =====================================================
echo "📝 [4/20] Auth layout oluşturuluyor..."

cat > 'app/(auth)/layout.tsx' << 'EOF'
export default function AuthLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 via-white to-purple-50">
      {children}
    </div>
  )
}
EOF

# =====================================================
# 5. LOGIN SAYFASI
# =====================================================
echo "📝 [5/20] Login sayfası oluşturuluyor..."

cat > 'app/(auth)/login/page.tsx' << 'EOF'
'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'

export default function LoginPage() {
  const router = useRouter()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    // Simulated login
    setTimeout(() => {
      if (email === 'admin@ngo.org' && password === 'admin123') {
        localStorage.setItem('authToken', 'demo-token-123')
        localStorage.setItem('userEmail', email)
        router.push('/dashboard')
      } else {
        setError('Geçersiz email veya şifre')
        setLoading(false)
      }
    }, 1000)
  }

  return (
    <div className="w-full max-w-md">
      <div className="bg-white rounded-2xl shadow-xl p-8">
        {/* Logo */}
        <div className="text-center mb-8">
          <div className="w-20 h-20 bg-gradient-to-br from-blue-500 to-purple-600 rounded-2xl flex items-center justify-center mx-auto mb-4">
            <span className="text-3xl text-white">❤️</span>
          </div>
          <h1 className="text-2xl font-bold text-gray-800">NGO Management System</h1>
          <p className="text-gray-600 mt-2">STK Yönetim Platformu</p>
        </div>

        {/* Error Message */}
        {error && (
          <div className="mb-4 p-3 bg-red-50 border border-red-200 text-red-700 rounded-lg text-sm">
            {error}
          </div>
        )}

        {/* Login Form */}
        <form onSubmit={handleLogin} className="space-y-6">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Email Adresi
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="admin@ngo.org"
              className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              required
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Şifre
            </label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••••"
              className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              required
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full py-3 px-4 bg-gradient-to-r from-blue-500 to-purple-600 text-white font-medium rounded-lg hover:from-blue-600 hover:to-purple-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed transition-all"
          >
            {loading ? 'Giriş yapılıyor...' : 'Giriş Yap'}
          </button>
        </form>

        {/* Demo Info */}
        <div className="mt-6 p-4 bg-blue-50 rounded-lg">
          <p className="text-sm text-center text-gray-700">
            <strong>Demo Bilgileri:</strong><br />
            Email: admin@ngo.org<br />
            Şifre: admin123
          </p>
        </div>
      </div>

      {/* Footer */}
      <p className="text-center text-sm text-gray-500 mt-6">
        © 2025 NGO Management System by ongassamaniger-blip
      </p>
    </div>
  )
}
EOF

# =====================================================
# 6. MAIN LAYOUT
# =====================================================
echo "📝 [6/20] Main layout oluşturuluyor..."

cat > 'app/(main)/layout.tsx' << 'EOF'
'use client'

import { useState, useEffect } from 'react'
import { useRouter, usePathname } from 'next/navigation'
import Link from 'next/link'

export default function MainLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const router = useRouter()
  const pathname = usePathname()
  const [sidebarOpen, setSidebarOpen] = useState(true)

  useEffect(() => {
    const token = localStorage.getItem('authToken')
    if (!token) {
      router.push('/login')
    }
  }, [router])

  const handleLogout = () => {
    localStorage.removeItem('authToken')
    localStorage.removeItem('userEmail')
    router.push('/login')
  }

  const menuItems = [
    { href: '/dashboard', label: 'Dashboard', icon: '📊' },
    { href: '/cash', label: 'Kasa Yönetimi', icon: '💰' },
    { href: '/projects', label: 'Projeler', icon: '📂' },
    { href: '/personnel', label: 'Personel', icon: '👥' },
    { href: '/facilities', label: 'Tesisler', icon: '🏢' },
    { href: '/sacrifice', label: 'Kurban', icon: '🐑' },
    { href: '/approvals', label: 'Onaylar', icon: '✅' },
    { href: '/reports', label: 'Raporlar', icon: '📈' },
    { href: '/settings', label: 'Ayarlar', icon: '⚙️' },
  ]

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Sidebar */}
      <aside className={`fixed left-0 top-0 h-full bg-white shadow-lg transition-all duration-300 z-40 ${
        sidebarOpen ? 'w-64' : 'w-20'
      }`}>
        <div className="p-4 border-b">
          <div className="flex items-center justify-between">
            <h1 className={`font-bold text-xl ${!sidebarOpen && 'hidden'}`}>NGO System</h1>
            <button
              onClick={() => setSidebarOpen(!sidebarOpen)}
              className="p-2 hover:bg-gray-100 rounded-lg"
            >
              {sidebarOpen ? '◀️' : '▶️'}
            </button>
          </div>
        </div>
        
        <nav className="p-4">
          {menuItems.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className={`flex items-center gap-3 px-3 py-2 rounded-lg mb-1 transition-colors ${
                pathname === item.href
                  ? 'bg-blue-50 text-blue-600'
                  : 'hover:bg-gray-100'
              }`}
            >
              <span className="text-xl">{item.icon}</span>
              {sidebarOpen && <span>{item.label}</span>}
            </Link>
          ))}
        </nav>

        <div className="absolute bottom-0 left-0 right-0 p-4 border-t">
          <button
            onClick={handleLogout}
            className="w-full flex items-center gap-3 px-3 py-2 bg-red-50 text-red-600 rounded-lg hover:bg-red-100 transition-colors"
          >
            <span>🚪</span>
            {sidebarOpen && <span>Çıkış Yap</span>}
          </button>
        </div>
      </aside>

      {/* Main Content */}
      <div className={`transition-all duration-300 ${sidebarOpen ? 'ml-64' : 'ml-20'}`}>
        {/* Header */}
        <header className="bg-white shadow-sm px-6 py-4">
          <div className="flex items-center justify-between">
            <h2 className="text-xl font-semibold text-gray-800">
              {menuItems.find(item => item.href === pathname)?.label || 'NGO Management System'}
            </h2>
            <div className="flex items-center gap-4">
              <span className="text-sm text-gray-600">
                {localStorage.getItem('userEmail') || 'admin@ngo.org'}
              </span>
              <div className="w-8 h-8 bg-blue-500 rounded-full flex items-center justify-center text-white">
                A
              </div>
            </div>
          </div>
        </header>

        {/* Page Content */}
        <main className="p-6">
          {children}
        </main>
      </div>
    </div>
  )
}
EOF

# =====================================================
# 7. DASHBOARD SAYFASI
# =====================================================
echo "📝 [7/20] Dashboard sayfası oluşturuluyor..."

cat > 'app/(main)/dashboard/page.tsx' << 'EOF'
'use client'

import { useState, useEffect } from 'react'

export default function DashboardPage() {
  const [stats, setStats] = useState({
    income: 780000,
    expense: 520000,
    balance: 260000,
    projects: 8,
    personnel: 24,
    facilities: 5,
    sacrifices: 45,
    pendingApprovals: 3
  })

  const recentTransactions = [
    { id: 1, type: 'income', description: 'Kurumsal Bağış', amount: 50000, date: '2025-10-17' },
    { id: 2, type: 'expense', description: 'Personel Maaşları', amount: 35000, date: '2025-10-15' },
    { id: 3, type: 'income', description: 'Kurban Bağışları', amount: 25000, date: '2025-10-14' },
    { id: 4, type: 'expense', description: 'Proje Harcaması', amount: 12000, date: '2025-10-13' },
    { id: 5, type: 'income', description: 'Zakat', amount: 8500, date: '2025-10-12' },
  ]

  return (
    <div className="space-y-6">
      {/* Page Title */}
      <div>
        <h1 className="text-2xl font-bold text-gray-800">Dashboard</h1>
        <p className="text-gray-600">Genel bakış ve özet bilgiler</p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white rounded-lg shadow p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm">Toplam Gelir</p>
              <p className="text-2xl font-bold text-green-600 mt-1">₺{stats.income.toLocaleString()}</p>
            </div>
            <span className="text-3xl">💰</span>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm">Toplam Gider</p>
              <p className="text-2xl font-bold text-red-600 mt-1">₺{stats.expense.toLocaleString()}</p>
            </div>
            <span className="text-3xl">💸</span>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm">Net Bakiye</p>
              <p className="text-2xl font-bold text-blue-600 mt-1">₺{stats.balance.toLocaleString()}</p>
            </div>
            <span className="text-3xl">💎</span>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-500 text-sm">Aktif Projeler</p>
              <p className="text-2xl font-bold text-purple-600 mt-1">{stats.projects}</p>
            </div>
            <span className="text-3xl">📊</span>
          </div>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <a href="/cash/income" className="bg-green-50 border border-green-200 rounded-lg p-4 text-center hover:bg-green-100 transition-colors">
          <span className="text-2xl">➕</span>
          <p className="mt-2 font-medium text-green-700">Gelir Ekle</p>
        </a>
        <a href="/cash/expense" className="bg-red-50 border border-red-200 rounded-lg p-4 text-center hover:bg-red-100 transition-colors">
          <span className="text-2xl">➖</span>
          <p className="mt-2 font-medium text-red-700">Gider Ekle</p>
        </a>
        <a href="/projects" className="bg-blue-50 border border-blue-200 rounded-lg p-4 text-center hover:bg-blue-100 transition-colors">
          <span className="text-2xl">📁</span>
          <p className="mt-2 font-medium text-blue-700">Yeni Proje</p>
        </a>
        <a href="/reports" className="bg-purple-50 border border-purple-200 rounded-lg p-4 text-center hover:bg-purple-100 transition-colors">
          <span className="text-2xl">📈</span>
          <p className="mt-2 font-medium text-purple-700">Rapor Al</p>
        </a>
      </div>

      {/* Recent Transactions */}
      <div className="bg-white rounded-lg shadow">
        <div className="p-6 border-b">
          <h2 className="text-lg font-semibold">Son İşlemler</h2>
        </div>
        <div className="p-6">
          <div className="space-y-3">
            {recentTransactions.map(transaction => (
              <div key={transaction.id} className="flex items-center justify-between p-3 hover:bg-gray-50 rounded-lg">
                <div className="flex items-center gap-3">
                  <span className={`text-2xl ${transaction.type === 'income' ? '🟢' : '🔴'}`}></span>
                  <div>
                    <p className="font-medium">{transaction.description}</p>
                    <p className="text-sm text-gray-500">{transaction.date}</p>
                  </div>
                </div>
                <p className={`font-bold ${transaction.type === 'income' ? 'text-green-600' : 'text-red-600'}`}>
                  {transaction.type === 'income' ? '+' : '-'}₺{transaction.amount.toLocaleString()}
                </p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}
EOF

# =====================================================
# 8. CASH SAYFASI
# =====================================================
echo "📝 [8/20] Cash sayfası oluşturuluyor..."

cat > 'app/(main)/cash/page.tsx' << 'EOF'
'use client'

import { useState } from 'react'
import Link from 'next/link'

export default function CashPage() {
  const [transactions] = useState([
    { id: 1, type: 'income', category: 'Bağış', description: 'Kurumsal bağış', amount: 50000, date: '2025-10-17', status: 'completed' },
    { id: 2, type: 'expense', category: 'Personel', description: 'Maaş ödemesi', amount: 35000, date: '2025-10-15', status: 'completed' },
    { id: 3, type: 'transfer', category: 'Transfer', description: 'Nijer kasası transferi', amount: 25000, date: '2025-10-14', status: 'pending' },
    { id: 4, type: 'income', category: 'Kurban', description: 'Kurban bağışı', amount: 8500, date: '2025-10-13', status: 'completed' },
    { id: 5, type: 'expense', category: 'Proje', description: 'Su kuyusu projesi', amount: 12000, date: '2025-10-12', status: 'completed' },
  ])

  const totalIncome = transactions.filter(t => t.type === 'income').reduce((sum, t) => sum + t.amount, 0)
  const totalExpense = transactions.filter(t => t.type === 'expense').reduce((sum, t) => sum + t.amount, 0)
  const balance = totalIncome - totalExpense

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-800">Kasa Yönetimi</h1>
          <p className="text-gray-600">Gelir, gider ve transfer işlemleri</p>
        </div>
        <div className="flex gap-2">
          <Link href="/cash/income" className="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600">
            + Gelir Ekle
          </Link>
          <Link href="/cash/expense" className="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600">
            - Gider Ekle
          </Link>
          <Link href="/cash/transfer" className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600">
            ↔ Transfer
          </Link>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white rounded-lg shadow p-6">
          <p className="text-gray-500 text-sm">Toplam Gelir</p>
          <p className="text-2xl font-bold text-green-600">₺{totalIncome.toLocaleString()}</p>
        </div>
        <div className="bg-white rounded-lg shadow p-6">
          <p className="text-gray-500 text-sm">Toplam Gider</p>
          <p className="text-2xl font-bold text-red-600">₺{totalExpense.toLocaleString()}</p>
        </div>
        <div className="bg-white rounded-lg shadow p-6">
          <p className="text-gray-500 text-sm">Bakiye</p>
          <p className="text-2xl font-bold text-blue-600">₺{balance.toLocaleString()}</p>
        </div>
      </div>

      {/* Transactions Table */}
      <div className="bg-white rounded-lg shadow">
        <div className="p-6 border-b">
          <h2 className="text-lg font-semibold">İşlem Listesi</h2>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tür</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Kategori</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Açıklama</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tutar</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tarih</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Durum</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {transactions.map(transaction => (
                <tr key={transaction.id} className="hover:bg-gray-50">
                  <td className="px-6 py-4">
                    <span className={`px-2 py-1 text-xs rounded-full ${
                      transaction.type === 'income' ? 'bg-green-100 text-green-700' :
                      transaction.type === 'expense' ? 'bg-red-100 text-red-700' :
                      'bg-blue-100 text-blue-700'
                    }`}>
                      {transaction.type === 'income' ? 'Gelir' :
                       transaction.type === 'expense' ? 'Gider' : 'Transfer'}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-sm">{transaction.category}</td>
                  <td className="px-6 py-4 text-sm">{transaction.description}</td>
                  <td className="px-6 py-4 text-sm font-medium">
                    <span className={transaction.type === 'income' ? 'text-green-600' : 'text-red-600'}>
                      {transaction.type === 'income' ? '+' : '-'}₺{transaction.amount.toLocaleString()}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-sm">{transaction.date}</td>
                  <td className="px-6 py-4">
                    <span className={`px-2 py-1 text-xs rounded-full ${
                      transaction.status === 'completed' ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'
                    }`}>
                      {transaction.status === 'completed' ? 'Tamamlandı' : 'Bekliyor'}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  )
}
EOF

# =====================================================
# 9-13. DİĞER ANA SAYFALAR
# =====================================================
echo "📝 [9-13/20] Diğer sayfalar oluşturuluyor..."

# Projects
cat > 'app/(main)/projects/page.tsx' << 'EOF'
export default function ProjectsPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Proje Yönetimi</h1>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="font-semibold mb-2">Su Kuyusu Projesi</h3>
          <p className="text-gray-600 text-sm mb-4">Nijer'de 10 köye temiz su</p>
          <div className="w-full bg-gray-200 rounded-full h-2">
            <div className="bg-blue-500 h-2 rounded-full" style={{width: '65%'}}></div>
          </div>
          <p className="text-sm mt-2">%65 Tamamlandı</p>
        </div>
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="font-semibold mb-2">Eğitim Merkezi</h3>
          <p className="text-gray-600 text-sm mb-4">Senegal'de eğitim tesisi</p>
          <div className="w-full bg-gray-200 rounded-full h-2">
            <div className="bg-green-500 h-2 rounded-full" style={{width: '45%'}}></div>
          </div>
          <p className="text-sm mt-2">%45 Tamamlandı</p>
        </div>
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="font-semibold mb-2">Sağlık Taraması</h3>
          <p className="text-gray-600 text-sm mb-4">Mali'de sağlık hizmetleri</p>
          <div className="w-full bg-gray-200 rounded-full h-2">
            <div className="bg-purple-500 h-2 rounded-full" style={{width: '80%'}}></div>
          </div>
          <p className="text-sm mt-2">%80 Tamamlandı</p>
        </div>
      </div>
    </div>
  )
}
EOF

# Personnel
cat > 'app/(main)/personnel/page.tsx' << 'EOF'
export default function PersonnelPage() {
  const personnel = [
    { id: 1, name: 'Ahmet Yılmaz', position: 'Proje Yöneticisi', department: 'Operasyon', status: 'active' },
    { id: 2, name: 'Fatma Kaya', position: 'Muhasebe Uzmanı', department: 'Finans', status: 'active' },
    { id: 3, name: 'Mehmet Öz', position: 'Saha Koordinatörü', department: 'Operasyon', status: 'active' },
    { id: 4, name: 'Ayşe Demir', position: 'İK Uzmanı', department: 'İnsan Kaynakları', status: 'active' },
  ]

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-2xl font-bold">Personel Yönetimi</h1>
        <button className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600">
          + Yeni Personel
        </button>
      </div>
      <div className="bg-white rounded-lg shadow">
        <table className="w-full">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Ad Soyad</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Pozisyon</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Departman</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Durum</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-200">
            {personnel.map(person => (
              <tr key={person.id} className="hover:bg-gray-50">
                <td className="px-6 py-4">{person.name}</td>
                <td className="px-6 py-4">{person.position}</td>
                <td className="px-6 py-4">{person.department}</td>
                <td className="px-6 py-4">
                  <span className="px-2 py-1 text-xs bg-green-100 text-green-700 rounded-full">Aktif</span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}
EOF

# Facilities
cat > 'app/(main)/facilities/page.tsx' << 'EOF'
export default function FacilitiesPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Tesis Yönetimi</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {['Merkez Ofis', 'Nijer Tesisi', 'Senegal Tesisi', 'Mali Tesisi', 'Burkina Faso Tesisi'].map((facility, index) => (
          <div key={index} className="bg-white p-6 rounded-lg shadow">
            <h3 className="font-semibold mb-2">{facility}</h3>
            <p className="text-sm text-gray-600 mb-4">Aktif - {5 + index} Personel</p>
            <button className="text-blue-500 hover:underline text-sm">Detaylar →</button>
          </div>
        ))}
      </div>
    </div>
  )
}
EOF

# Sacrifice
cat > 'app/(main)/sacrifice/page.tsx' << 'EOF'
export default function SacrificePage() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Kurban Yönetimi</h1>
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="bg-white p-4 rounded-lg shadow">
          <p className="text-gray-500 text-sm">Toplam Kurban</p>
          <p className="text-2xl font-bold">45</p>
        </div>
        <div className="bg-white p-4 rounded-lg shadow">
          <p className="text-gray-500 text-sm">Satılan Hisse</p>
          <p className="text-2xl font-bold">127/315</p>
        </div>
        <div className="bg-white p-4 rounded-lg shadow">
          <p className="text-gray-500 text-sm">Toplanan Tutar</p>
          <p className="text-2xl font-bold">₺892,500</p>
        </div>
        <div className="bg-white p-4 rounded-lg shadow">
          <p className="text-gray-500 text-sm">Faydalanıcı</p>
          <p className="text-2xl font-bold">2,250</p>
        </div>
      </div>
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="font-semibold mb-4">Kurban Listesi</h2>
        <div className="space-y-3">
          {[1, 2, 3, 4, 5].map(i => (
            <div key={i} className="flex justify-between items-center p-3 border rounded-lg">
              <div>
                <p className="font-medium">Kurban #{i.toString().padStart(3, '0')}</p>
                <p className="text-sm text-gray-600">Büyükbaş - Nijer</p>
              </div>
              <div className="text-right">
                <p className="font-medium">{i * 2}/{7} Hisse</p>
                <p className="text-sm text-green-600">₺{(12000 * i * 2).toLocaleString()}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
EOF

# =====================================================
# 14-17. ALT SAYFALAR
# =====================================================
echo "📝 [14-17/20] Alt sayfalar oluşturuluyor..."

# Income
cat > 'app/(main)/cash/income/page.tsx' << 'EOF'
export default function IncomePage() {
  return (
    <div className="max-w-2xl mx-auto">
      <h1 className="text-2xl font-bold mb-6">Gelir Ekle</h1>
      <form className="bg-white rounded-lg shadow p-6 space-y-4">
        <div>
          <label className="block text-sm font-medium mb-2">Kategori</label>
          <select className="w-full px-3 py-2 border rounded-lg">
            <option>Bağış</option>
            <option>Hibe</option>
            <option>Kurban</option>
            <option>Zakat</option>
          </select>
        </div>
        <div>
          <label className="block text-sm font-medium mb-2">Tutar</label>
          <input type="number" className="w-full px-3 py-2 border rounded-lg" placeholder="0.00" />
        </div>
        <div>
          <label className="block text-sm font-medium mb-2">Açıklama</label>
          <textarea className="w-full px-3 py-2 border rounded-lg" rows={3}></textarea>
        </div>
        <div className="flex gap-2">
          <button type="submit" className="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600">
            Kaydet
          </button>
          <a href="/cash" className="px-4 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600">
            İptal
          </a>
        </div>
      </form>
    </div>
  )
}
EOF

# Expense
cat > 'app/(main)/cash/expense/page.tsx' << 'EOF'
export default function ExpensePage() {
  return (
    <div className="max-w-2xl mx-auto">
      <h1 className="text-2xl font-bold mb-6">Gider Ekle</h1>
      <form className="bg-white rounded-lg shadow p-6 space-y-4">
        <div>
          <label className="block text-sm font-medium mb-2">Kategori</label>
          <select className="w-full px-3 py-2 border rounded-lg">
            <option>Personel</option>
            <option>Operasyon</option>
            <option>Proje</option>
            <option>Yardım</option>
          </select>
        </div>
        <div>
          <label className="block text-sm font-medium mb-2">Tutar</label>
          <input type="number" className="w-full px-3 py-2 border rounded-lg" placeholder="0.00" />
        </div>
        <div>
          <label className="block text-sm font-medium mb-2">Açıklama</label>
          <textarea className="w-full px-3 py-2 border rounded-lg" rows={3}></textarea>
        </div>
        <div className="flex gap-2">
          <button type="submit" className="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600">
            Kaydet
          </button>
          <a href="/cash" className="px-4 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600">
            İptal
          </a>
        </div>
      </form>
    </div>
  )
}
EOF

# Transfer
cat > 'app/(main)/cash/transfer/page.tsx' << 'EOF'
export default function TransferPage() {
  return (
    <div className="max-w-2xl mx-auto">
      <h1 className="text-2xl font-bold mb-6">Transfer Yap</h1>
      <form className="bg-white rounded-lg shadow p-6 space-y-4">
        <div>
          <label className="block text-sm font-medium mb-2">Kaynak Kasa</label>
          <select className="w-full px-3 py-2 border rounded-lg">
            <option>Ana Kasa</option>
            <option>Banka Hesabı</option>
          </select>
        </div>
        <div>
          <label className="block text-sm font-medium mb-2">Hedef Kasa</label>
          <select className="w-full px-3 py-2 border rounded-lg">
            <option>Nijer Kasa</option>
            <option>Senegal Kasa</option>
            <option>Mali Kasa</option>
          </select>
        </div>
        <div>
          <label className="block text-sm font-medium mb-2">Tutar</label>
          <input type="number" className="w-full px-3 py-2 border rounded-lg" placeholder="0.00" />
        </div>
        <div className="flex gap-2">
          <button type="submit" className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600">
            Transfer Yap
          </button>
          <a href="/cash" className="px-4 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600">
            İptal
          </a>
        </div>
      </form>
    </div>
  )
}
EOF

# =====================================================
# 18-20. KALAN SAYFALAR
# =====================================================
echo "📝 [18-20/20] Kalan sayfalar oluşturuluyor..."

# Approvals
cat > 'app/(main)/approvals/page.tsx' << 'EOF'
export default function ApprovalsPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Onay Bekleyenler</h1>
      <div className="bg-white rounded-lg shadow">
        <div className="p-6 space-y-4">
          <div className="border rounded-lg p-4">
            <div className="flex justify-between items-start">
              <div>
                <h3 className="font-semibold">Transfer İşlemi</h3>
                <p className="text-sm text-gray-600 mt-1">Ana Kasa → Nijer Kasa</p>
                <p className="text-lg font-bold mt-2">₺25,000</p>
              </div>
              <div className="flex gap-2">
                <button className="px-3 py-1 bg-green-500 text-white rounded hover:bg-green-600">Onayla</button>
                <button className="px-3 py-1 bg-red-500 text-white rounded hover:bg-red-600">Reddet</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
EOF

# Reports
cat > 'app/(main)/reports/page.tsx' << 'EOF'
export default function ReportsPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Raporlar</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="font-semibold mb-2">Finansal Rapor</h3>
          <p className="text-gray-600 text-sm mb-4">Gelir-Gider analizi</p>
          <button className="text-blue-500 hover:underline">Oluştur →</button>
        </div>
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="font-semibold mb-2">Proje Raporu</h3>
          <p className="text-gray-600 text-sm mb-4">Proje durumları</p>
          <button className="text-blue-500 hover:underline">Oluştur →</button>
        </div>
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="font-semibold mb-2">Personel Raporu</h3>
          <p className="text-gray-600 text-sm mb-4">Personel performansı</p>
          <button className="text-blue-500 hover:underline">Oluştur →</button>
        </div>
      </div>
    </div>
  )
}
EOF

# Settings
cat > 'app/(main)/settings/page.tsx' << 'EOF'
export default function SettingsPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Ayarlar</h1>
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="font-semibold mb-4">Genel Ayarlar</h2>
        <div className="space-y-4">
          <div>
            <label className="block text-sm font-medium mb-2">Kurum Adı</label>
            <input type="text" className="w-full px-3 py-2 border rounded-lg" defaultValue="NGO Management System" />
          </div>
          <div>
            <label className="block text-sm font-medium mb-2">Dil</label>
            <select className="w-full px-3 py-2 border rounded-lg">
              <option>Türkçe</option>
              <option>English</option>
            </select>
          </div>
          <button className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600">
            Kaydet
          </button>
        </div>
      </div>
    </div>
  )
}
EOF

echo "✅ TÜM DOSYALAR OLUŞTURULDU!"
echo ""
echo "🚀 Şimdi şu komutları çalıştırın:"
echo "   1. npm run dev"
echo "   2. Tarayıcıda http://localhost:3000 açın"
echo ""
echo "📧 Giriş bilgileri:"
echo "   Email: admin@ngo.org"
echo "   Şifre: admin123"