#!/bin/bash
# install-ngo-system-part3.sh - Dashboard ve Core Components
# Date: 2025-10-17 11:13:09
# User: ongassamaniger-blip

echo -e "${CYAN}════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}[7/10] Dashboard ve Core Component'ler oluşturuluyor...${NC}"
echo -e "${CYAN}════════════════════════════════════════════════${NC}"

# =====================================================
# DASHBOARD PAGE
# =====================================================

echo -e "${BLUE}📊 Dashboard sayfası oluşturuluyor...${NC}"

cat > 'app/(main)/dashboard/page.tsx' << 'ENDOFDASHBOARDPAGE'
import Dashboard from '@/components/dashboard/Dashboard'

export const metadata = {
  title: 'Dashboard - NGO Management System',
  description: 'Ana kontrol paneli'
}

export default function DashboardPage() {
  return <Dashboard />
}
ENDOFDASHBOARDPAGE

# Dashboard Component
cat > 'components/dashboard/Dashboard.tsx' << 'ENDOFDASHBOARD'
'use client'

import React, { useState, useEffect } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import {
  TrendingUp, TrendingDown, Wallet, Users, Building2, FolderOpen,
  Heart, AlertCircle, Calendar, Activity, DollarSign, Euro,
  ArrowUpRight, ArrowDownRight, MoreVertical, Download, Filter,
  ChevronRight, Clock, CheckCircle, XCircle, AlertTriangle,
  BarChart3, PieChart, Target, Zap, Eye, RefreshCw
} from 'lucide-react'
import {
  LineChart, Line, AreaChart, Area, BarChart, Bar,
  PieChart as RePieChart, Pie, Cell, XAxis, YAxis,
  CartesianGrid, Tooltip, ResponsiveContainer, Legend,
  RadialBarChart, RadialBar, ComposedChart
} from 'recharts'

// Sample data - Production'da API'den gelecek
const financeData = [
  { month: 'Ocak', income: 45000, expense: 32000, net: 13000 },
  { month: 'Şubat', income: 52000, expense: 38000, net: 14000 },
  { month: 'Mart', income: 48000, expense: 35000, net: 13000 },
  { month: 'Nisan', income: 61000, expense: 42000, net: 19000 },
  { month: 'Mayıs', income: 55000, expense: 40000, net: 15000 },
  { month: 'Haziran', income: 67000, expense: 45000, net: 22000 },
  { month: 'Temmuz', income: 72000, expense: 48000, net: 24000 },
  { month: 'Ağustos', income: 69000, expense: 46000, net: 23000 },
  { month: 'Eylül', income: 75000, expense: 50000, net: 25000 },
  { month: 'Ekim', income: 78000, expense: 52000, net: 26000 }
]

const categoryExpenses = [
  { name: 'Personel', value: 35000, percentage: 35, color: '#3b82f6' },
  { name: 'Proje', value: 25000, percentage: 25, color: '#10b981' },
  { name: 'Operasyon', value: 20000, percentage: 20, color: '#f59e0b' },
  { name: 'Yardım', value: 15000, percentage: 15, color: '#8b5cf6' },
  { name: 'Diğer', value: 5000, percentage: 5, color: '#ef4444' }
]

const projectStatus = [
  { name: 'Tamamlanan', value: 12, color: '#10b981' },
  { name: 'Devam Eden', value: 8, color: '#3b82f6' },
  { name: 'Planlanan', value: 5, color: '#f59e0b' },
  { name: 'Bekleyen', value: 3, color: '#6b7280' }
]

const facilityPerformance = [
  { name: 'Nijer', efficiency: 92, budget: 85000, spent: 78200 },
  { name: 'Senegal', efficiency: 88, budget: 75000, spent: 66000 },
  { name: 'Mali', efficiency: 85, budget: 70000, spent: 59500 },
  { name: 'Burkina Faso', efficiency: 90, budget: 80000, spent: 72000 },
  { name: 'Türkiye', efficiency: 95, budget: 100000, spent: 95000 }
]

const recentTransactions = [
  { id: 1, type: 'income', description: 'Bağış - Kurumsal', amount: 50000, date: '2025-10-15', status: 'completed' },
  { id: 2, type: 'expense', description: 'Personel Maaşları', amount: 35000, date: '2025-10-14', status: 'completed' },
  { id: 3, type: 'transfer', description: 'Nijer Tesisi Transfer', amount: 25000, date: '2025-10-13', status: 'pending' },
  { id: 4, type: 'expense', description: 'Proje X Harcaması', amount: 12000, date: '2025-10-12', status: 'completed' },
  { id: 5, type: 'income', description: 'Kurban Bağışı', amount: 8500, date: '2025-10-11', status: 'completed' }
]

const upcomingTasks = [
  { id: 1, title: 'Maaş Ödemeleri', dueDate: '2025-10-25', priority: 'high', type: 'payment' },
  { id: 2, title: 'Proje Raporu Teslimi', dueDate: '2025-10-28', priority: 'medium', type: 'report' },
  { id: 3, title: 'Kurban Organizasyonu', dueDate: '2025-11-15', priority: 'high', type: 'event' },
  { id: 4, title: 'Tesis Denetimi', dueDate: '2025-11-01', priority: 'low', type: 'audit' },
  { id: 5, title: 'Bütçe Revizyonu', dueDate: '2025-10-30', priority: 'medium', type: 'finance' }
]

export default function Dashboard() {
  const [selectedPeriod, setSelectedPeriod] = useState('month')
  const [selectedCurrency, setSelectedCurrency] = useState('TRY')
  const [loading, setLoading] = useState(true)
  const [lastUpdate, setLastUpdate] = useState(new Date())

  useEffect(() => {
    // Simulate data loading
    setTimeout(() => setLoading(false), 1000)
    
    // Auto refresh every 5 minutes
    const interval = setInterval(() => {
      setLastUpdate(new Date())
      // Refresh data here
    }, 300000)

    return () => clearInterval(interval)
  }, [])

  const refreshData = () => {
    setLoading(true)
    setLastUpdate(new Date())
    setTimeout(() => setLoading(false), 1000)
  }

  // Stat Card Component
  const StatCard = ({ title, value, change, trend, icon: Icon, color, delay = 0 }: any) => (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5, delay }}
      className="stat-card relative overflow-hidden group"
    >
      <div className="flex items-start justify-between">
        <div className="space-y-2">
          <p className="text-sm text-muted-foreground">{title}</p>
          <p className="text-2xl font-bold">{value}</p>
          {change && (
            <div className="flex items-center gap-1">
              {trend === 'up' ? (
                <ArrowUpRight className="w-4 h-4 text-green-500" />
              ) : (
                <ArrowDownRight className="w-4 h-4 text-red-500" />
              )}
              <span className={`text-sm ${trend === 'up' ? 'text-green-500' : 'text-red-500'}`}>
                {change}%
              </span>
              <span className="text-xs text-muted-foreground">vs geçen ay</span>
            </div>
          )}
        </div>
        <div className={`p-3 rounded-lg ${color} transition-transform group-hover:scale-110`}>
          <Icon className="w-6 h-6 text-white" />
        </div>
      </div>
      <div className="absolute -right-8 -bottom-8 w-24 h-24 opacity-10">
        <Icon className="w-full h-full" />
      </div>
    </motion.div>
  )

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[600px]">
        <div className="text-center">
          <RefreshCw className="w-12 h-12 mx-auto mb-4 animate-spin text-primary" />
          <p className="text-lg font-medium">Veriler yükleniyor...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Page Header with Actions */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold bg-gradient-to-r from-primary to-primary/60 bg-clip-text text-transparent">
            Dashboard
          </h1>
          <p className="text-muted-foreground mt-1">
            Hoş geldiniz! İşte organizasyonunuzun genel durumu
          </p>
          <p className="text-xs text-muted-foreground mt-1">
            Son güncelleme: {lastUpdate.toLocaleTimeString('tr-TR')}
          </p>
        </div>
        <div className="flex items-center gap-2">
          <select
            value={selectedPeriod}
            onChange={(e) => setSelectedPeriod(e.target.value)}
            className="px-3 py-2 bg-card border rounded-lg text-sm"
          >
            <option value="today">Bugün</option>
            <option value="week">Bu Hafta</option>
            <option value="month">Bu Ay</option>
            <option value="year">Bu Yıl</option>
          </select>
          <button 
            onClick={refreshData}
            className="px-3 py-2 bg-card border rounded-lg text-sm hover:bg-accent transition-colors"
          >
            <RefreshCw className="w-4 h-4" />
          </button>
          <button className="px-4 py-2 bg-card border rounded-lg text-sm flex items-center gap-2 hover:bg-accent">
            <Filter className="w-4 h-4" />
            Filtre
          </button>
          <button className="px-4 py-2 bg-primary text-primary-foreground rounded-lg text-sm flex items-center gap-2 hover:bg-primary/90">
            <Download className="w-4 h-4" />
            Rapor İndir
          </button>
        </div>
      </div>

      {/* Quick Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard
          title="Toplam Gelir"
          value="₺780,000"
          change={12.5}
          trend="up"
          icon={TrendingUp}
          color="bg-green-500"
          delay={0}
        />
        <StatCard
          title="Toplam Gider"
          value="₺520,000"
          change={8.3}
          trend="down"
          icon={TrendingDown}
          color="bg-red-500"
          delay={0.1}
        />
        <StatCard
          title="Net Bakiye"
          value="₺260,000"
          change={15.7}
          trend="up"
          icon={Wallet}
          color="bg-blue-500"
          delay={0.2}
        />
        <StatCard
          title="Aktif Projeler"
          value="8"
          change={23.1}
          trend="up"
          icon={FolderOpen}
          color="bg-purple-500"
          delay={0.3}
        />
      </div>

      {/* Charts Row 1 */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Financial Overview */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          className="lg:col-span-2 bg-card p-6 rounded-xl border"
        >
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-lg font-semibold">Finansal Genel Bakış</h3>
            <button className="p-2 hover:bg-accent rounded-lg transition-colors">
              <MoreVertical className="w-4 h-4" />
            </button>
          </div>
          <ResponsiveContainer width="100%" height={300}>
            <ComposedChart data={financeData}>
              <defs>
                <linearGradient id="colorIncome" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#10b981" stopOpacity={0.3}/>
                  <stop offset="95%" stopColor="#10b981" stopOpacity={0}/>
                </linearGradient>
                <linearGradient id="colorExpense" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#ef4444" stopOpacity={0.3}/>
                  <stop offset="95%" stopColor="#ef4444" stopOpacity={0}/>
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" className="opacity-30" />
              <XAxis dataKey="month" />
              <YAxis />
              <Tooltip 
                contentStyle={{ 
                  backgroundColor: 'hsl(var(--card))',
                  border: '1px solid hsl(var(--border))',
                  borderRadius: '8px'
                }}
              />
              <Legend />
              <Area
                type="monotone"
                dataKey="income"
                stroke="#10b981"
                fillOpacity={1}
                fill="url(#colorIncome)"
                name="Gelir"
              />
              <Area
                type="monotone"
                dataKey="expense"
                stroke="#ef4444"
                fillOpacity={1}
                fill="url(#colorExpense)"
                name="Gider"
              />
              <Line
                type="monotone"
                dataKey="net"
                stroke="#3b82f6"
                strokeWidth={3}
                dot={{ fill: '#3b82f6' }}
                name="Net"
              />
            </ComposedChart>
          </ResponsiveContainer>
        </motion.div>

        {/* Category Distribution */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
          className="bg-card p-6 rounded-xl border"
        >
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-lg font-semibold">Harcama Dağılımı</h3>
            <button className="p-2 hover:bg-accent rounded-lg transition-colors">
              <MoreVertical className="w-4 h-4" />
            </button>
          </div>
          <ResponsiveContainer width="100%" height={200}>
            <RePieChart>
              <Pie
                data={categoryExpenses}
                cx="50%"
                cy="50%"
                innerRadius={60}
                outerRadius={80}
                paddingAngle={5}
                dataKey="value"
              >
                {categoryExpenses.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
              <Tooltip />
            </RePieChart>
          </ResponsiveContainer>
          <div className="mt-4 space-y-2">
            {categoryExpenses.map((category, index) => (
              <div key={index} className="flex items-center justify-between text-sm">
                <div className="flex items-center gap-2">
                  <div
                    className="w-3 h-3 rounded-full"
                    style={{ backgroundColor: category.color }}
                  />
                  <span>{category.name}</span>
                </div>
                <div className="flex items-center gap-2">
                  <span className="text-muted-foreground">%{category.percentage}</span>
                  <span className="font-medium">₺{category.value.toLocaleString()}</span>
                </div>
              </div>
            ))}
          </div>
        </motion.div>
      </div>

      {/* Middle Section */}
      <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
        {/* Recent Transactions */}
        <motion.div
          initial={{ opacity: 0, x: -20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ delay: 0.6 }}
          className="lg:col-span-2 bg-card p-6 rounded-xl border"
        >
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-lg font-semibold">Son İşlemler</h3>
            <button className="text-sm text-primary hover:underline flex items-center gap-1">
              Tümünü Gör
              <ChevronRight className="w-4 h-4" />
            </button>
          </div>
          <div className="space-y-3">
            {recentTransactions.map((transaction, index) => (
              <motion.div
                key={transaction.id}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.7 + index * 0.1 }}
                className="flex items-center justify-between p-3 bg-accent/50 rounded-lg hover:bg-accent transition-colors"
              >
                <div className="flex items-center gap-3">
                  <div className={`
                    p-2 rounded-lg
                    ${transaction.type === 'income' ? 'bg-green-500/10 text-green-500' : 
                      transaction.type === 'expense' ? 'bg-red-500/10 text-red-500' :
                      'bg-blue-500/10 text-blue-500'}
                  `}>
                    {transaction.type === 'income' ? <ArrowUpRight className="w-4 h-4" /> :
                     transaction.type === 'expense' ? <ArrowDownRight className="w-4 h-4" /> :
                     <ArrowUpRight className="w-4 h-4" />}
                  </div>
                  <div>
                    <p className="text-sm font-medium">{transaction.description}</p>
                    <p className="text-xs text-muted-foreground">{transaction.date}</p>
                  </div>
                </div>
                <div className="text-right">
                  <p className={`text-sm font-semibold ${
                    transaction.type === 'income' ? 'text-green-500' : 
                    transaction.type === 'expense' ? 'text-red-500' : ''
                  }`}>
                    {transaction.type === 'income' ? '+' : '-'}₺{transaction.amount.toLocaleString()}
                  </p>
                  <span className={`text-xs px-2 py-0.5 rounded-full ${
                    transaction.status === 'completed' ? 'bg-green-500/10 text-green-500' :
                    'bg-yellow-500/10 text-yellow-500'
                  }`}>
                    {transaction.status === 'completed' ? 'Tamamlandı' : 'Bekliyor'}
                  </span>
                </div>
              </motion.div>
            ))}
          </div>
        </motion.div>

        {/* Project Status */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.8 }}
          className="bg-card p-6 rounded-xl border"
        >
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-lg font-semibold">Proje Durumu</h3>
            <button className="p-2 hover:bg-accent rounded-lg transition-colors">
              <MoreVertical className="w-4 h-4" />
            </button>
          </div>
          <ResponsiveContainer width="100%" height={200}>
            <RadialBarChart cx="50%" cy="50%" innerRadius="10%" outerRadius="90%" data={projectStatus}>
              <RadialBar minAngle={15} clockWise dataKey="value">
                {projectStatus.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </RadialBar>
              <Tooltip />
            </RadialBarChart>
          </ResponsiveContainer>
          <div className="mt-4 grid grid-cols-2 gap-2">
            {projectStatus.map((status, index) => (
              <div key={index} className="flex items-center gap-2 text-sm">
                <div
                  className="w-3 h-3 rounded-full"
                  style={{ backgroundColor: status.color }}
                />
                <span className="text-xs">{status.name}</span>
                <span className="font-medium ml-auto">{status.value}</span>
              </div>
            ))}
          </div>
        </motion.div>

        {/* Upcoming Tasks */}
        <motion.div
          initial={{ opacity: 0, x: 20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ delay: 0.9 }}
          className="bg-card p-6 rounded-xl border"
        >
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-lg font-semibold">Yaklaşan Görevler</h3>
            <button className="text-sm text-primary hover:underline">
              Tümü
            </button>
          </div>
          <div className="space-y-3">
            {upcomingTasks.map((task, index) => (
              <motion.div
                key={task.id}
                initial={{ opacity: 0, x: 20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 1 + index * 0.1 }}
                className="p-3 bg-accent/50 rounded-lg hover:bg-accent transition-colors"
              >
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <p className="text-sm font-medium">{task.title}</p>
                    <div className="flex items-center gap-2 mt-1">
                      <Clock className="w-3 h-3 text-muted-foreground" />
                      <span className="text-xs text-muted-foreground">
                        {task.dueDate}
                      </span>
                    </div>
                  </div>
                  <span className={`
                    px-2 py-0.5 text-xs rounded-full
                    ${task.priority === 'high' ? 'bg-red-500/10 text-red-500' :
                      task.priority === 'medium' ? 'bg-yellow-500/10 text-yellow-500' :
                      'bg-green-500/10 text-green-500'}
                  `}>
                    {task.priority === 'high' ? 'Yüksek' :
                     task.priority === 'medium' ? 'Orta' : 'Düşük'}
                  </span>
                </div>
              </motion.div>
            ))}
          </div>
        </motion.div>
      </div>

      {/* Facility Performance */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 1.2 }}
        className="bg-card p-6 rounded-xl border"
      >
        <div className="flex items-center justify-between mb-6">
          <h3 className="text-lg font-semibold">Tesis Performansı</h3>
          <div className="flex items-center gap-2">
            <button className="px-3 py-1 text-sm bg-accent rounded-lg">
              Son 30 Gün
            </button>
            <button className="p-2 hover:bg-accent rounded-lg transition-colors">
              <MoreVertical className="w-4 h-4" />
            </button>
          </div>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b">
                <th className="text-left py-3 px-4">Tesis</th>
                <th className="text-left py-3 px-4">Verimlilik</th>
                <th className="text-left py-3 px-4">Bütçe</th>
                <th className="text-left py-3 px-4">Harcanan</th>
                <th className="text-left py-3 px-4">Kalan</th>
                <th className="text-left py-3 px-4">Durum</th>
              </tr>
            </thead>
            <tbody>
              {facilityPerformance.map((facility, index) => (
                <tr key={index} className="border-b hover:bg-accent/50 transition-colors">
                  <td className="py-3 px-4">
                    <div className="flex items-center gap-2">
                      <Building2 className="w-4 h-4 text-muted-foreground" />
                      <span className="font-medium">{facility.name}</span>
                    </div>
                  </td>
                  <td className="py-3 px-4">
                    <div className="flex items-center gap-2">
                      <div className="flex-1 bg-accent rounded-full h-2 overflow-hidden max-w-[100px]">
                        <div
                          className={`h-full transition-all ${
                            facility.efficiency >= 90 ? 'bg-green-500' :
                            facility.efficiency >= 80 ? 'bg-yellow-500' :
                            'bg-red-500'
                          }`}
                          style={{ width: `${facility.efficiency}%` }}
                        />
                      </div>
                      <span className="text-sm font-medium">{facility.efficiency}%</span>
                    </div>
                  </td>
                  <td className="py-3 px-4 text-sm">
                    ₺{facility.budget.toLocaleString()}
                  </td>
                  <td className="py-3 px-4 text-sm">
                    ₺{facility.spent.toLocaleString()}
                  </td>
                  <td className="py-3 px-4 text-sm">
                    ₺{(facility.budget - facility.spent).toLocaleString()}
                  </td>
                  <td className="py-3 px-4">
                    {facility.efficiency >= 90 ? (
                      <span className="flex items-center gap-1 text-green-500">
                        <CheckCircle className="w-4 h-4" />
                        <span className="text-xs">İyi</span>
                      </span>
                    ) : facility.efficiency >= 80 ? (
                      <span className="flex items-center gap-1 text-yellow-500">
                        <AlertTriangle className="w-4 h-4" />
                        <span className="text-xs">Orta</span>
                      </span>
                    ) : (
                      <span className="flex items-center gap-1 text-red-500">
                        <XCircle className="w-4 h-4" />
                        <span className="text-xs">Kritik</span>
                      </span>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </motion.div>

      {/* Quick Actions */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        {[
          { icon: Wallet, label: 'Yeni İşlem', color: 'primary', href: '/cash' },
          { icon: FolderOpen, label: 'Proje Oluştur', color: 'green-500', href: '/projects' },
          { icon: Users, label: 'Personel Ekle', color: 'purple-500', href: '/personnel' },
          { icon: BarChart3, label: 'Rapor Oluştur', color: 'red-500', href: '/reports' }
        ].map((action, index) => (
          <motion.button
            key={index}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 1.3 + index * 0.1 }}
            className="p-4 bg-card border rounded-xl hover:bg-accent transition-colors group"
          >
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className={`p-2 bg-${action.color}/10 rounded-lg`}>
                  <action.icon className={`w-5 h-5 text-${action.color}`} />
                </div>
                <span className="font-medium">{action.label}</span>
              </div>
              <ChevronRight className="w-5 h-5 text-muted-foreground group-hover:translate-x-1 transition-transform" />
            </div>
          </motion.button>
        ))}
      </div>
    </div>
  )
}
ENDOFDASHBOARD

echo -e "${GREEN}✅ Dashboard component oluşturuldu${NC}"
echo ""

# =====================================================
# CASH MANAGEMENT SAYFASI
# =====================================================

echo -e "${BLUE}💰 Cash Management sayfası oluşturuluyor...${NC}"

# Cash Main Page
cat > 'app/(main)/cash/page.tsx' << 'ENDOFCASHPAGE'
import CashManagement from '@/components/cash/CashManagement'

export const metadata = {
  title: 'Kasa Yönetimi - NGO Management System',
  description: 'Gelir, gider ve transfer yönetimi'
}

export default function CashPage() {
  return <CashManagement />
}
ENDOFCASHPAGE

echo -e "${GREEN}✅ Cash sayfası oluşturuldu${NC}"

echo -e "${CYAN}════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}Bölüm 3 tamamlandı. Devam ediliyor...${NC}"
echo -e "${CYAN}════════════════════════════════════════════════${NC}"