#!/bin/bash
# upgrade-3-modern-cash.sh
# Modern Cash Management System
# Date: 2025-10-17 14:46:24
# User: ongassamaniger-blip

echo "💰 =========================================="
echo "   MODERN KASA YÖNETİMİ UPGRADE"
echo "   Gelişmiş özellikler ekleniyor..."
echo "💰 =========================================="

# Backup
echo "📦 Backup alınıyor..."
cp "app/(main)/cash/page.tsx" "app/(main)/cash/page.tsx.backup" 2>/dev/null || true

# Modern Cash Management Page
cat > "app/(main)/cash/page.tsx" << 'EOF'
'use client'

import { useState, useRef } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import {
  Plus, Minus, ArrowLeftRight, Filter, Search, Download,
  Upload, FileText, Eye, Edit, Trash2, Check, X,
  DollarSign, TrendingUp, TrendingDown, Calendar,
  Clock, AlertCircle, CheckCircle, XCircle, MoreVertical,
  Paperclip, Image, FileSpreadsheet, Receipt, Printer,
  RefreshCw, Settings, ChevronDown, ChevronRight,
  CreditCard, Wallet, Building2, PieChart
} from 'lucide-react'
import {
  LineChart, Line, AreaChart, Area, BarChart, Bar,
  XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
  PieChart as RePieChart, Pie, Cell
} from 'recharts'

interface Transaction {
  id: string
  type: 'income' | 'expense' | 'transfer'
  category: string
  subcategory?: string
  amount: number
  currency: string
  description: string
  date: string
  status: 'pending' | 'approved' | 'rejected' | 'completed'
  attachments: {
    id: string
    name: string
    type: string
    size: number
    url: string
  }[]
  approver?: string
  approvedAt?: string
  notes?: string
  tags?: string[]
  relatedCash?: string
  createdBy: string
  createdAt: string
}

export default function CashManagementPage() {
  const [transactions, setTransactions] = useState<Transaction[]>([
    {
      id: '1',
      type: 'income',
      category: 'Bağış',
      subcategory: 'Kurumsal',
      amount: 50000,
      currency: 'TRY',
      description: 'ABC Holding kurumsal bağışı',
      date: '2025-10-17',
      status: 'completed',
      attachments: [
        { id: '1', name: 'makbuz.pdf', type: 'application/pdf', size: 245000, url: '#' }
      ],
      createdBy: 'Admin',
      createdAt: '2025-10-17T10:30:00Z'
    },
    {
      id: '2',
      type: 'expense',
      category: 'Personel',
      subcategory: 'Maaş',
      amount: 35000,
      currency: 'TRY',
      description: 'Ekim ayı personel maaşları',
      date: '2025-10-15',
      status: 'pending',
      attachments: [
        { id: '2', name: 'bordro.xlsx', type: 'application/excel', size: 128000, url: '#' },
        { id: '3', name: 'odeme-dekontu.pdf', type: 'application/pdf', size: 98000, url: '#' }
      ],
      createdBy: 'Muhasebe',
      createdAt: '2025-10-15T14:20:00Z'
    },
    {
      id: '3',
      type: 'transfer',
      category: 'Transfer',
      amount: 25000,
      currency: 'TRY',
      description: 'Nijer tesisi kasa transferi',
      date: '2025-10-14',
      status: 'approved',
      relatedCash: 'Nijer Kasa',
      attachments: [],
      approver: 'Yönetici',
      approvedAt: '2025-10-14T16:45:00Z',
      createdBy: 'Admin',
      createdAt: '2025-10-14T09:15:00Z'
    }
  ])

  const [showAddModal, setShowAddModal] = useState(false)
  const [showDetailModal, setShowDetailModal] = useState(false)
  const [selectedTransaction, setSelectedTransaction] = useState<Transaction | null>(null)
  const [transactionType, setTransactionType] = useState<'income' | 'expense' | 'transfer'>('income')
  const [filterStatus, setFilterStatus] = useState('all')
  const [searchQuery, setSearchQuery] = useState('')
  const [selectedPeriod, setSelectedPeriod] = useState('month')
  const fileInputRef = useRef<HTMLInputElement>(null)
  const [attachments, setAttachments] = useState<File[]>([])

  // Calculate statistics
  const totalIncome = transactions
    .filter(t => t.type === 'income' && t.status === 'completed')
    .reduce((sum, t) => sum + t.amount, 0)
  
  const totalExpense = transactions
    .filter(t => t.type === 'expense' && t.status === 'completed')
    .reduce((sum, t) => sum + t.amount, 0)
  
  const balance = totalIncome - totalExpense
  const pendingCount = transactions.filter(t => t.status === 'pending').length

  // Chart data
  const chartData = [
    { month: 'Oca', gelir: 85000, gider: 65000 },
    { month: 'Şub', gelir: 92000, gider: 72000 },
    { month: 'Mar', gelir: 78000, gider: 58000 },
    { month: 'Nis', gelir: 105000, gider: 85000 },
    { month: 'May', gelir: 95000, gider: 75000 },
    { month: 'Haz', gelir: 112000, gider: 88000 }
  ]

  const categoryData = [
    { name: 'Bağış', value: 45, color: '#3b82f6' },
    { name: 'Proje', value: 30, color: '#10b981' },
    { name: 'Kurban', value: 15, color: '#f59e0b' },
    { name: 'Zakat', value: 10, color: '#8b5cf6' }
  ]

  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files || [])
    setAttachments(prev => [...prev, ...files])
  }

  const removeAttachment = (index: number) => {
    setAttachments(prev => prev.filter((_, i) => i !== index))
  }

  const handleApprove = (id: string) => {
    setTransactions(prev => prev.map(t => 
      t.id === id 
        ? { ...t, status: 'approved', approver: 'Admin', approvedAt: new Date().toISOString() }
        : t
    ))
  }

  const handleReject = (id: string) => {
    setTransactions(prev => prev.map(t => 
      t.id === id ? { ...t, status: 'rejected' } : t
    ))
  }

  const exportData = (format: 'excel' | 'pdf') => {
    console.log(`Exporting as ${format}...`)
    // Export implementation
  }

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">Kasa Yönetimi</h1>
          <p className="text-gray-500 dark:text-gray-400 mt-1">
            Gelir, gider ve transfer işlemleri
          </p>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={() => { setTransactionType('income'); setShowAddModal(true) }}
            className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors flex items-center gap-2"
          >
            <Plus className="w-4 h-4" />
            Gelir Ekle
          </button>
          <button
            onClick={() => { setTransactionType('expense'); setShowAddModal(true) }}
            className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors flex items-center gap-2"
          >
            <Minus className="w-4 h-4" />
            Gider Ekle
          </button>
          <button
            onClick={() => { setTransactionType('transfer'); setShowAddModal(true) }}
            className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center gap-2"
          >
            <ArrowLeftRight className="w-4 h-4" />
            Transfer
          </button>
        </div>
      </div>

      {/* Statistics Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700"
        >
          <div className="flex items-center justify-between mb-4">
            <div className="p-3 bg-green-100 dark:bg-green-900/20 rounded-lg">
              <TrendingUp className="w-6 h-6 text-green-600" />
            </div>
            <span className="text-sm text-green-600">+12.5%</span>
          </div>
          <p className="text-2xl font-bold text-gray-900 dark:text-white">₺{totalIncome.toLocaleString()}</p>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">Toplam Gelir</p>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700"
        >
          <div className="flex items-center justify-between mb-4">
            <div className="p-3 bg-red-100 dark:bg-red-900/20 rounded-lg">
              <TrendingDown className="w-6 h-6 text-red-600" />
            </div>
            <span className="text-sm text-red-600">+8.3%</span>
          </div>
          <p className="text-2xl font-bold text-gray-900 dark:text-white">₺{totalExpense.toLocaleString()}</p>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">Toplam Gider</p>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700"
        >
          <div className="flex items-center justify-between mb-4">
            <div className="p-3 bg-blue-100 dark:bg-blue-900/20 rounded-lg">
              <Wallet className="w-6 h-6 text-blue-600" />
            </div>
            <span className="text-sm text-blue-600">+15.7%</span>
          </div>
          <p className="text-2xl font-bold text-gray-900 dark:text-white">₺{balance.toLocaleString()}</p>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">Net Bakiye</p>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700"
        >
          <div className="flex items-center justify-between mb-4">
            <div className="p-3 bg-yellow-100 dark:bg-yellow-900/20 rounded-lg">
              <Clock className="w-6 h-6 text-yellow-600" />
            </div>
            <span className="text-sm text-yellow-600">{pendingCount} bekliyor</span>
          </div>
          <p className="text-2xl font-bold text-gray-900 dark:text-white">{transactions.length}</p>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">Toplam İşlem</p>
        </motion.div>
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          className="lg:col-span-2 bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700"
        >
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold text-gray-900 dark:text-white">Nakit Akış</h3>
            <select className="text-sm px-3 py-1 bg-gray-100 dark:bg-gray-700 rounded-lg">
              <option>Bu Yıl</option>
              <option>Son 6 Ay</option>
              <option>Son 3 Ay</option>
            </select>
          </div>
          <ResponsiveContainer width="100%" height={250}>
            <AreaChart data={chartData}>
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
              <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
              <XAxis dataKey="month" stroke="#6b7280" />
              <YAxis stroke="#6b7280" />
              <Tooltip />
              <Area type="monotone" dataKey="gelir" stroke="#10b981" fillOpacity={1} fill="url(#colorIncome)" strokeWidth={2} />
              <Area type="monotone" dataKey="gider" stroke="#ef4444" fillOpacity={1} fill="url(#colorExpense)" strokeWidth={2} />
            </AreaChart>
          </ResponsiveContainer>
        </motion.div>

        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700"
        >
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">Kategori Dağılımı</h3>
          <ResponsiveContainer width="100%" height={200}>
            <RePieChart>
              <Pie
                data={categoryData}
                cx="50%"
                cy="50%"
                innerRadius={50}
                outerRadius={70}
                paddingAngle={5}
                dataKey="value"
              >
                {categoryData.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
              <Tooltip />
            </RePieChart>
          </ResponsiveContainer>
          <div className="space-y-2 mt-4">
            {categoryData.map((item) => (
              <div key={item.name} className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div className="w-3 h-3 rounded-full" style={{ backgroundColor: item.color }} />
                  <span className="text-sm text-gray-600 dark:text-gray-400">{item.name}</span>
                </div>
                <span className="text-sm font-medium">%{item.value}</span>
              </div>
            ))}
          </div>
        </motion.div>
      </div>

      {/* Transaction List will continue in next part... */}
EOF

echo "✅ Kasa Yönetimi Part 1 tamamlandı!"
echo "📌 Part 2'de işlem listesi ve modal'lar eklenecek..."