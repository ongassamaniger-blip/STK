#!/bin/bash
# upgrade-2a-dashboard-base.sh
# Modern Dashboard Part 1 - Base Structure
# Date: 2025-10-17 14:42:16
# User: ongassamaniger-blip

echo "📊 =========================================="
echo "   MODERN DASHBOARD UPGRADE - PART 1"
echo "   Temel yapı oluşturuluyor..."
echo "📊 =========================================="

# Backup
echo "📦 Backup alınıyor..."
cp "app/(main)/dashboard/page.tsx" "app/(main)/dashboard/page.tsx.backup" 2>/dev/null || true

# Dashboard Base Component
cat > "app/(main)/dashboard/page.tsx" << 'EOF'
'use client'

import { useState, useEffect } from 'react'
import { motion } from 'framer-motion'
import { 
  TrendingUp, Users, DollarSign, FolderOpen,
  ArrowUpRight, ArrowDownRight, Activity,
  Calendar, Clock, AlertCircle, CheckCircle,
  RefreshCw, Plus, Wallet, Heart, Building2,
  BarChart3, ChevronRight, Settings2
} from 'lucide-react'
import {
  LineChart, Line, AreaChart, Area, BarChart, Bar,
  XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
  PieChart, Pie, Cell
} from 'recharts'

// Data generation
const generateChartData = () => {
  const months = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz']
  return months.map(month => ({
    month,
    gelir: Math.floor(Math.random() * 50000) + 50000,
    gider: Math.floor(Math.random() * 40000) + 30000
  }))
}

const pieData = [
  { name: 'Eğitim', value: 35, color: '#3b82f6' },
  { name: 'Sağlık', value: 25, color: '#10b981' },
  { name: 'Yardım', value: 20, color: '#f59e0b' },
  { name: 'Altyapı', value: 15, color: '#8b5cf6' },
  { name: 'Diğer', value: 5, color: '#ef4444' }
]

export default function DashboardPage() {
  const [refreshing, setRefreshing] = useState(false)
  const [chartData, setChartData] = useState(generateChartData())

  // Stats data
  const stats = [
    { 
      label: 'Toplam Gelir', 
      value: '₺780,000', 
      change: 12.5, 
      trend: 'up', 
      icon: DollarSign, 
      color: 'green' 
    },
    { 
      label: 'Toplam Gider', 
      value: '₺520,000', 
      change: 8.3, 
      trend: 'down', 
      icon: TrendingUp, 
      color: 'red' 
    },
    { 
      label: 'Net Bakiye', 
      value: '₺260,000', 
      change: 15.7, 
      trend: 'up', 
      icon: Wallet, 
      color: 'blue' 
    },
    { 
      label: 'Aktif Projeler', 
      value: '24', 
      change: 2, 
      trend: 'up', 
      icon: FolderOpen, 
      color: 'purple' 
    }
  ]

  // Activities data
  const activities = [
    { 
      id: 1, 
      icon: CheckCircle, 
      text: 'Yeni proje onaylandı: Su Kuyusu Projesi', 
      time: '2 saat önce', 
      type: 'success' 
    },
    { 
      id: 2, 
      icon: Users, 
      text: '5 yeni personel sisteme eklendi', 
      time: '5 saat önce', 
      type: 'info' 
    },
    { 
      id: 3, 
      icon: AlertCircle, 
      text: 'Bütçe limiti uyarısı: %85 kullanıldı', 
      time: '1 gün önce', 
      type: 'warning' 
    },
    { 
      id: 4, 
      icon: Heart, 
      text: '12 yeni kurban bağışı alındı', 
      time: '2 gün önce', 
      type: 'success' 
    },
    { 
      id: 5, 
      icon: Building2, 
      text: 'Senegal tesisi faaliyete geçti', 
      time: '3 gün önce', 
      type: 'info' 
    }
  ]

  // Quick actions
  const quickActions = [
    { icon: Plus, label: 'Gelir Ekle', href: '/cash/income', color: 'green' },
    { icon: FolderOpen, label: 'Yeni Proje', href: '/projects/new', color: 'blue' },
    { icon: Users, label: 'Personel Ekle', href: '/personnel/new', color: 'purple' },
    { icon: Heart, label: 'Kurban Ekle', href: '/sacrifice/new', color: 'red' }
  ]

  const handleRefresh = () => {
    setRefreshing(true)
    setTimeout(() => {
      setChartData(generateChartData())
      setRefreshing(false)
    }, 1000)
  }

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">Dashboard</h1>
          <p className="text-gray-500 dark:text-gray-400 mt-1">
            Hoş geldiniz! İşte güncel durumunuz.
          </p>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={handleRefresh}
            className="p-2 bg-gray-200 dark:bg-gray-700 rounded-lg hover:bg-gray-300 dark:hover:bg-gray-600 transition-colors"
          >
            <RefreshCw className={`w-4 h-4 ${refreshing ? 'animate-spin' : ''}`} />
          </button>
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat, index) => (
          <motion.div
            key={index}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: index * 0.1 }}
            className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700"
          >
            <div className="flex items-center justify-between mb-4">
              <div className={`p-3 bg-${stat.color}-100 dark:bg-${stat.color}-900/20 rounded-lg`}>
                <stat.icon className={`w-6 h-6 text-${stat.color}-600`} />
              </div>
              <span className={`text-sm flex items-center gap-1 ${
                stat.trend === 'up' ? 'text-green-600' : 'text-red-600'
              }`}>
                {stat.trend === 'up' ? <ArrowUpRight className="w-3 h-3" /> : <ArrowDownRight className="w-3 h-3" />}
                {stat.change}%
              </span>
            </div>
            <p className="text-2xl font-bold text-gray-900 dark:text-white">{stat.value}</p>
            <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">{stat.label}</p>
          </motion.div>
        ))}
      </div>

      {/* Quick Actions */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
        {quickActions.map((action, index) => (
          <motion.a
            key={index}
            href={action.href}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2 + index * 0.05 }}
            className="p-4 bg-white dark:bg-gray-800 rounded-xl shadow hover:shadow-lg transition-all hover:scale-105 border border-gray-200 dark:border-gray-700"
          >
            <div className={`w-12 h-12 bg-${action.color}-100 dark:bg-${action.color}-900/20 rounded-lg flex items-center justify-center mb-3`}>
              <action.icon className={`w-6 h-6 text-${action.color}-600`} />
            </div>
            <p className="text-sm font-medium text-gray-900 dark:text-white">{action.label}</p>
          </motion.a>
        ))}
      </div>

      {/* Charts Section */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Main Chart */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.4 }}
          className="lg:col-span-2 bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700"
        >
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">Gelir/Gider Analizi</h3>
          <ResponsiveContainer width="100%" height={300}>
            <AreaChart data={chartData}>
              <defs>
                <linearGradient id="colorGelir" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#3b82f6" stopOpacity={0.3}/>
                  <stop offset="95%" stopColor="#3b82f6" stopOpacity={0}/>
                </linearGradient>
                <linearGradient id="colorGider" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#ef4444" stopOpacity={0.3}/>
                  <stop offset="95%" stopColor="#ef4444" stopOpacity={0}/>
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
              <XAxis dataKey="month" stroke="#6b7280" />
              <YAxis stroke="#6b7280" />
              <Tooltip />
              <Area type="monotone" dataKey="gelir" stroke="#3b82f6" fillOpacity={1} fill="url(#colorGelir)" strokeWidth={2} />
              <Area type="monotone" dataKey="gider" stroke="#ef4444" fillOpacity={1} fill="url(#colorGider)" strokeWidth={2} />
            </AreaChart>
          </ResponsiveContainer>
        </motion.div>

        {/* Pie Chart */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.5 }}
          className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700"
        >
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">Proje Dağılımı</h3>
          <ResponsiveContainer width="100%" height={250}>
            <PieChart>
              <Pie
                data={pieData}
                cx="50%"
                cy="50%"
                innerRadius={60}
                outerRadius={80}
                paddingAngle={5}
                dataKey="value"
              >
                {pieData.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
          <div className="space-y-2 mt-4">
            {pieData.map((item) => (
              <div key={item.name} className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div className="w-3 h-3 rounded-full" style={{ backgroundColor: item.color }} />
                  <span className="text-sm text-gray-600 dark:text-gray-400">{item.name}</span>
                </div>
                <span className="text-sm font-medium">{item.value}%</span>
              </div>
            ))}
          </div>
        </motion.div>
      </div>

      {/* Activities and Events */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Recent Activities */}
        <motion.div
          initial={{ opacity: 0, x: -20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ delay: 0.6 }}
          className="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700"
        >
          <div className="p-4 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between">
            <h3 className="text-lg font-semibold text-gray-900 dark:text-white">Son Aktiviteler</h3>
            <Activity className="w-5 h-5 text-gray-400" />
          </div>
          <div className="p-4 space-y-3">
            {activities.map((activity) => (
              <div key={activity.id} className="flex items-start gap-3 p-3 hover:bg-gray-50 dark:hover:bg-gray-700/50 rounded-lg transition-colors">
                <div className={`p-2 rounded-lg ${
                  activity.type === 'success' ? 'bg-green-100 text-green-600' :
                  activity.type === 'warning' ? 'bg-yellow-100 text-yellow-600' :
                  'bg-blue-100 text-blue-600'
                }`}>
                  <activity.icon className="w-4 h-4" />
                </div>
                <div className="flex-1">
                  <p className="text-sm font-medium text-gray-900 dark:text-white">{activity.text}</p>
                  <p className="text-xs text-gray-500 dark:text-gray-400 mt-1">{activity.time}</p>
                </div>
              </div>
            ))}
          </div>
          <div className="p-4 border-t border-gray-200 dark:border-gray-700">
            <button className="text-sm text-blue-600 dark:text-blue-400 hover:underline flex items-center gap-1">
              Tümünü Gör <ChevronRight className="w-4 h-4" />
            </button>
          </div>
        </motion.div>

        {/* Upcoming Events */}
        <motion.div
          initial={{ opacity: 0, x: 20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ delay: 0.7 }}
          className="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700"
        >
          <div className="p-4 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between">
            <h3 className="text-lg font-semibold text-gray-900 dark:text-white">Yaklaşan Etkinlikler</h3>
            <Calendar className="w-5 h-5 text-gray-400" />
          </div>
          <div className="p-4 space-y-3">
            <div className="flex items-start gap-3 p-3 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
              <div className="flex-shrink-0">
                <div className="text-center">
                  <p className="text-xs text-gray-500 dark:text-gray-400">Eki</p>
                  <p className="text-lg font-bold text-gray-900 dark:text-white">20</p>
                </div>
              </div>
              <div className="flex-1">
                <p className="text-sm font-medium text-gray-900 dark:text-white">Kurban Kesim Başlangıcı</p>
                <p className="text-xs text-gray-500 dark:text-gray-400">09:00 - Tüm tesislerde</p>
              </div>
            </div>
            <div className="flex items-start gap-3 p-3 hover:bg-gray-50 dark:hover:bg-gray-700/50 rounded-lg transition-colors">
              <div className="flex-shrink-0">
                <div className="text-center">
                  <p className="text-xs text-gray-500 dark:text-gray-400">Eki</p>
                  <p className="text-lg font-bold text-gray-900 dark:text-white">25</p>
                </div>
              </div>
              <div className="flex-1">
                <p className="text-sm font-medium text-gray-900 dark:text-white">Proje Değerlendirme Toplantısı</p>
                <p className="text-xs text-gray-500 dark:text-gray-400">14:00 - Online</p>
              </div>
            </div>
          </div>
          <div className="p-4 border-t border-gray-200 dark:border-gray-700">
            <button className="text-sm text-blue-600 dark:text-blue-400 hover:underline flex items-center gap-1">
              Takvime Git <ChevronRight className="w-4 h-4" />
            </button>
          </div>
        </motion.div>
      </div>
    </div>
  )
}
EOF

# Recharts yükle
echo ""
echo "📦 Recharts yükleniyor..."
npm install recharts

echo ""
echo "✅ Modern Dashboard (Part 1) başarıyla güncellendi!"
echo ""
echo "🎯 Eklenen özellikler:"
echo "  ✓ İstatistik kartları"
echo "  ✓ Hızlı eylemler"
echo "  ✓ Gelir/Gider grafiği"
echo "  ✓ Proje dağılım grafiği"
echo "  ✓ Son aktiviteler"
echo "  ✓ Yaklaşan etkinlikler"
echo "  ✓ Dark mode desteği"
echo ""
echo "🚀 Test edin: npm run dev"
echo "📌 Dashboard çalışıyorsa Part 2'ye geçebiliriz (Widget sistemi)"