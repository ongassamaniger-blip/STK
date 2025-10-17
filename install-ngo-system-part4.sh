#!/bin/bash
# install-ngo-system-part4.sh - Cash Management Components
# Date: 2025-10-17 11:15:22
# User: ongassamaniger-blip

echo -e "${CYAN}════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}[8/10] Cash Management Components oluşturuluyor...${NC}"
echo -e "${CYAN}════════════════════════════════════════════════${NC}"

# =====================================================
# CASH MANAGEMENT COMPONENT
# =====================================================

echo -e "${BLUE}💰 Cash Management component oluşturuluyor...${NC}"

cat > 'components/cash/CashManagement.tsx' << 'ENDOFCASHMANAGEMENT'
'use client'

import React, { useState, useEffect } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import {
  Plus, Search, Filter, Download, Upload, Wallet, TrendingUp, TrendingDown,
  ArrowUpRight, ArrowDownRight, ArrowRight, Calendar, Building2, FolderOpen,
  Users, FileText, MoreVertical, Edit, Trash2, Eye, Check, X, AlertCircle,
  DollarSign, Euro, PoundSterling, Receipt, CreditCard, Banknote, Calculator,
  RefreshCw, Clock, CheckCircle, XCircle, Printer, Share2, Copy, Mail
} from 'lucide-react'
import { toast } from 'react-hot-toast'

// Transaction Types
type TransactionType = 'income' | 'expense' | 'transfer'
type TransactionStatus = 'pending' | 'approved' | 'rejected' | 'completed'
type Currency = 'TRY' | 'USD' | 'EUR' | 'GBP'

interface Transaction {
  id: string
  transactionNo: string
  type: TransactionType
  amount: number
  currency: Currency
  category: string
  description: string
  date: string
  fromAccount?: string
  toAccount?: string
  facility?: string
  project?: string
  personnel?: string
  documents: string[]
  status: TransactionStatus
  approver?: string
  approvedAt?: string
  createdBy: string
  createdAt: string
  tags?: string[]
  recurring?: boolean
  recurringPeriod?: 'daily' | 'weekly' | 'monthly' | 'yearly'
}

interface Account {
  id: string
  name: string
  type: 'cash' | 'bank'
  balance: number
  currency: Currency
  accountNumber?: string
  bankName?: string
  iban?: string
  lastActivity?: string
}

// Sample data - Production'da API'den gelecek
const initialTransactions: Transaction[] = [
  {
    id: '1',
    transactionNo: 'TRX-2025-001',
    type: 'income',
    amount: 50000,
    currency: 'TRY',
    category: 'Bağış',
    description: 'Kurumsal bağış - ABC Şirketi',
    date: '2025-10-15',
    fromAccount: 'Bağışçı',
    toAccount: 'Ana Kasa',
    documents: ['invoice.pdf', 'receipt.pdf'],
    status: 'completed',
    createdBy: 'Admin',
    createdAt: '2025-10-15 10:30',
    tags: ['kurumsal', 'bağış'],
    recurring: false
  },
  {
    id: '2',
    transactionNo: 'TRX-2025-002',
    type: 'expense',
    amount: 35000,
    currency: 'TRY',
    category: 'Personel',
    description: 'Ekim ayı personel maaşları',
    date: '2025-10-14',
    fromAccount: 'Ana Kasa',
    documents: ['salary_sheet.xlsx'],
    status: 'completed',
    createdBy: 'HR Manager',
    createdAt: '2025-10-14 15:45',
    tags: ['maaş', 'personel'],
    recurring: true,
    recurringPeriod: 'monthly'
  },
  {
    id: '3',
    transactionNo: 'TRX-2025-003',
    type: 'transfer',
    amount: 25000,
    currency: 'TRY',
    category: 'Transfer',
    description: 'Nijer tesisi bütçe transferi',
    date: '2025-10-13',
    fromAccount: 'Ana Kasa',
    toAccount: 'Nijer Kasa',
    facility: 'Nijer',
    documents: ['transfer_request.pdf'],
    status: 'pending',
    createdBy: 'Finance Manager',
    createdAt: '2025-10-13 09:15',
    tags: ['transfer', 'tesis']
  }
]

const categories = {
  income: [
    { id: '1', name: 'Bağış', color: 'bg-green-500', icon: Heart },
    { id: '2', name: 'Hibe', color: 'bg-blue-500', icon: FileText },
    { id: '3', name: 'Kurban', color: 'bg-purple-500', icon: Heart },
    { id: '4', name: 'Zakat', color: 'bg-orange-500', icon: DollarSign },
    { id: '5', name: 'Diğer Gelir', color: 'bg-gray-500', icon: Receipt }
  ],
  expense: [
    { id: '6', name: 'Personel', color: 'bg-red-500', icon: Users },
    { id: '7', name: 'Operasyon', color: 'bg-yellow-500', icon: Building2 },
    { id: '8', name: 'Proje', color: 'bg-indigo-500', icon: FolderOpen },
    { id: '9', name: 'Yardım', color: 'bg-pink-500', icon: Heart },
    { id: '10', name: 'Diğer Gider', color: 'bg-gray-500', icon: Receipt }
  ]
}

const initialAccounts: Account[] = [
  { id: '1', name: 'Ana Kasa', type: 'cash', balance: 260000, currency: 'TRY', lastActivity: '2025-10-17 10:00' },
  { id: '2', name: 'Banka Hesabı', type: 'bank', balance: 450000, currency: 'TRY', bankName: 'Ziraat Bankası', iban: 'TR12 0001 0001 1234 5678 9012 34' },
  { id: '3', name: 'USD Kasa', type: 'cash', balance: 15000, currency: 'USD' },
  { id: '4', name: 'EUR Kasa', type: 'cash', balance: 8000, currency: 'EUR' },
  { id: '5', name: 'Nijer Kasa', type: 'cash', balance: 120000, currency: 'TRY', lastActivity: '2025-10-16 14:30' },
  { id: '6', name: 'Senegal Kasa', type: 'cash', balance: 85000, currency: 'TRY' }
]

const currencySymbols: Record<Currency, string> = {
  TRY: '₺',
  USD: '$',
  EUR: '€',
  GBP: '£'
}

export default function CashManagement() {
  const [activeTab, setActiveTab] = useState<'all' | 'income' | 'expense' | 'transfer'>('all')
  const [showNewTransaction, setShowNewTransaction] = useState(false)
  const [transactionType, setTransactionType] = useState<TransactionType>('income')
  const [selectedTransaction, setSelectedTransaction] = useState<Transaction | null>(null)
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedPeriod, setSelectedPeriod] = useState('month')
  const [transactions, setTransactions] = useState<Transaction[]>(initialTransactions)
  const [accounts, setAccounts] = useState<Account[]>(initialAccounts)
  const [loading, setLoading] = useState(false)
  const [filters, setFilters] = useState({
    dateFrom: '',
    dateTo: '',
    category: '',
    status: '',
    minAmount: '',
    maxAmount: ''
  })
  const [showFilters, setShowFilters] = useState(false)
  const [selectedTransactions, setSelectedTransactions] = useState<string[]>([])
  const [showAccountDetails, setShowAccountDetails] = useState<string | null>(null)
  const [newTransaction, setNewTransaction] = useState({
    type: 'income' as TransactionType,
    amount: '',
    currency: 'TRY' as Currency,
    category: '',
    description: '',
    date: new Date().toISOString().split('T')[0],
    fromAccount: '',
    toAccount: '',
    facility: '',
    project: '',
    tags: [] as string[],
    recurring: false,
    recurringPeriod: 'monthly' as const
  })

  // Filter transactions based on active tab and search
  const filteredTransactions = transactions.filter(t => {
    const matchesTab = activeTab === 'all' || t.type === activeTab
    const matchesSearch = searchTerm === '' || 
      t.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
      t.transactionNo.toLowerCase().includes(searchTerm.toLowerCase()) ||
      t.category.toLowerCase().includes(searchTerm.toLowerCase())
    
    return matchesTab && matchesSearch
  })

  // Calculate totals
  const totals = {
    income: transactions.filter(t => t.type === 'income').reduce((sum, t) => sum + t.amount, 0),
    expense: transactions.filter(t => t.type === 'expense').reduce((sum, t) => sum + t.amount, 0),
    transfer: transactions.filter(t => t.type === 'transfer').reduce((sum, t) => sum + t.amount, 0)
  }

  const balance = totals.income - totals.expense

  // Status badge helper
  const getStatusBadge = (status: TransactionStatus) => {
    const badges = {
      pending: { bg: 'bg-yellow-500/10', text: 'text-yellow-600', label: 'Bekliyor' },
      approved: { bg: 'bg-blue-500/10', text: 'text-blue-600', label: 'Onaylandı' },
      rejected: { bg: 'bg-red-500/10', text: 'text-red-600', label: 'Reddedildi' },
      completed: { bg: 'bg-green-500/10', text: 'text-green-600', label: 'Tamamlandı' }
    }
    const badge = badges[status]
    return (
      <span className={`px-2 py-1 text-xs rounded-full ${badge.bg} ${badge.text}`}>
        {badge.label}
      </span>
    )
  }

  // Transaction icon helper
  const getTransactionIcon = (type: TransactionType) => {
    switch (type) {
      case 'income':
        return <ArrowUpRight className="w-4 h-4" />
      case 'expense':
        return <ArrowDownRight className="w-4 h-4" />
      case 'transfer':
        return <ArrowRight className="w-4 h-4" />
    }
  }

  // Handle transaction actions
  const handleApproveTransaction = (id: string) => {
    setTransactions(prev => 
      prev.map(t => 
        t.id === id 
          ? { ...t, status: 'approved' as TransactionStatus, approvedAt: new Date().toISOString() }
          : t
      )
    )
    toast.success('İşlem onaylandı')
  }

  const handleRejectTransaction = (id: string) => {
    setTransactions(prev =>
      prev.map(t =>
        t.id === id
          ? { ...t, status: 'rejected' as TransactionStatus }
          : t
      )
    )
    toast.error('İşlem reddedildi')
  }

  const handleDeleteTransaction = (id: string) => {
    if (confirm('Bu işlemi silmek istediğinizden emin misiniz?')) {
      setTransactions(prev => prev.filter(t => t.id !== id))
      toast.success('İşlem silindi')
    }
  }

  const handleBulkAction = (action: 'approve' | 'reject' | 'delete') => {
    if (selectedTransactions.length === 0) {
      toast.error('Lütfen işlem seçin')
      return
    }

    switch (action) {
      case 'approve':
        selectedTransactions.forEach(id => handleApproveTransaction(id))
        break
      case 'reject':
        selectedTransactions.forEach(id => handleRejectTransaction(id))
        break
      case 'delete':
        if (confirm(`${selectedTransactions.length} işlemi silmek istediğinizden emin misiniz?`)) {
          setTransactions(prev => prev.filter(t => !selectedTransactions.includes(t.id)))
          toast.success('İşlemler silindi')
        }
        break
    }
    setSelectedTransactions([])
  }

  const handleExport = (format: 'csv' | 'excel' | 'pdf') => {
    // Export logic here
    toast.success(`${format.toUpperCase()} olarak dışa aktarıldı`)
  }

  const handleCreateTransaction = (e: React.FormEvent) => {
    e.preventDefault()
    
    // Validation
    if (!newTransaction.amount || !newTransaction.category) {
      toast.error('Lütfen zorunlu alanları doldurun')
      return
    }

    const transaction: Transaction = {
      id: (transactions.length + 1).toString(),
      transactionNo: `TRX-2025-${String(transactions.length + 1).padStart(3, '0')}`,
      type: newTransaction.type,
      amount: parseFloat(newTransaction.amount),
      currency: newTransaction.currency,
      category: newTransaction.category,
      description: newTransaction.description,
      date: newTransaction.date,
      fromAccount: newTransaction.fromAccount,
      toAccount: newTransaction.toAccount,
      facility: newTransaction.facility,
      project: newTransaction.project,
      documents: [],
      status: 'pending',
      createdBy: 'Current User',
      createdAt: new Date().toISOString(),
      tags: newTransaction.tags,
      recurring: newTransaction.recurring,
      recurringPeriod: newTransaction.recurringPeriod
    }

    setTransactions(prev => [transaction, ...prev])
    setShowNewTransaction(false)
    toast.success('İşlem oluşturuldu')
    
    // Reset form
    setNewTransaction({
      type: 'income',
      amount: '',
      currency: 'TRY',
      category: '',
      description: '',
      date: new Date().toISOString().split('T')[0],
      fromAccount: '',
      toAccount: '',
      facility: '',
      project: '',
      tags: [],
      recurring: false,
      recurringPeriod: 'monthly'
    })
  }

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold">Kasa Yönetimi</h1>
          <p className="text-muted-foreground mt-1">
            Gelir, gider ve transfer işlemlerini yönetin
          </p>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={() => {
              setShowNewTransaction(true)
              setTransactionType('income')
            }}
            className="px-4 py-2 bg-green-500 text-white rounded-lg text-sm flex items-center gap-2 hover:bg-green-600 transition-colors"
          >
            <Plus className="w-4 h-4" />
            Gelir Ekle
          </button>
          <button
            onClick={() => {
              setShowNewTransaction(true)
              setTransactionType('expense')
            }}
            className="px-4 py-2 bg-red-500 text-white rounded-lg text-sm flex items-center gap-2 hover:bg-red-600 transition-colors"
          >
            <Plus className="w-4 h-4" />
            Gider Ekle
          </button>
          <button
            onClick={() => {
              setShowNewTransaction(true)
              setTransactionType('transfer')
            }}
            className="px-4 py-2 bg-blue-500 text-white rounded-lg text-sm flex items-center gap-2 hover:bg-blue-600 transition-colors"
          >
            <Plus className="w-4 h-4" />
            Transfer
          </button>
          <button
            onClick={() => setLoading(true)}
            className="px-3 py-2 border rounded-lg hover:bg-accent transition-colors"
          >
            <RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />
          </button>
        </div>
      </div>

      {/* Quick Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-card p-4 rounded-xl border"
        >
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-muted-foreground">Toplam Bakiye</p>
              <p className="text-2xl font-bold mt-1">
                {currencySymbols.TRY}{balance.toLocaleString()}
              </p>
              <p className="text-xs text-muted-foreground mt-1">
                {accounts.length} hesap
              </p>
            </div>
            <div className="p-3 bg-primary/10 rounded-lg">
              <Wallet className="w-6 h-6 text-primary" />
            </div>
          </div>
        </motion.div>
        
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="bg-card p-4 rounded-xl border"
        >
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-muted-foreground">Toplam Gelir</p>
              <p className="text-2xl font-bold mt-1 text-green-600">
                +{currencySymbols.TRY}{totals.income.toLocaleString()}
              </p>
              <p className="text-xs text-muted-foreground mt-1">
                Bu ay
              </p>
            </div>
            <div className="p-3 bg-green-500/10 rounded-lg">
              <TrendingUp className="w-6 h-6 text-green-500" />
            </div>
          </div>
        </motion.div>
        
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="bg-card p-4 rounded-xl border"
        >
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-muted-foreground">Toplam Gider</p>
              <p className="text-2xl font-bold mt-1 text-red-600">
                -{currencySymbols.TRY}{totals.expense.toLocaleString()}
              </p>
              <p className="text-xs text-muted-foreground mt-1">
                Bu ay
              </p>
            </div>
            <div className="p-3 bg-red-500/10 rounded-lg">
              <TrendingDown className="w-6 h-6 text-red-500" />
            </div>
          </div>
        </motion.div>
        
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          className="bg-card p-4 rounded-xl border"
        >
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-muted-foreground">Bekleyen İşlem</p>
              <p className="text-2xl font-bold mt-1">
                {transactions.filter(t => t.status === 'pending').length}
              </p>
              <p className="text-xs text-muted-foreground mt-1">
                Onay bekliyor
              </p>
            </div>
            <div className="p-3 bg-yellow-500/10 rounded-lg">
              <AlertCircle className="w-6 h-6 text-yellow-500" />
            </div>
          </div>
        </motion.div>
      </div>

      {/* Cash Accounts */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 xl:grid-cols-6 gap-4">
        {accounts.map((account, index) => (
          <motion.div
            key={account.id}
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ delay: index * 0.05 }}
            className="bg-card p-4 rounded-xl border hover:shadow-md transition-all cursor-pointer"
            onClick={() => setShowAccountDetails(account.id)}
          >
            <div className="flex items-start justify-between mb-3">
              <div className="p-2 bg-accent rounded-lg">
                {account.type === 'cash' ? (
                  <Banknote className="w-5 h-5 text-primary" />
                ) : (
                  <CreditCard className="w-5 h-5 text-primary" />
                )}
              </div>
              <button 
                onClick={(e) => {
                  e.stopPropagation()
                  // Account actions
                }}
                className="p-1 hover:bg-accent rounded-lg"
              >
                <MoreVertical className="w-4 h-4" />
              </button>
            </div>
            <p className="text-sm font-medium">{account.name}</p>
            <p className="text-xl font-bold mt-1">
              {currencySymbols[account.currency]}
              {account.balance.toLocaleString()}
            </p>
            <p className="text-xs text-muted-foreground mt-1">
              {account.type === 'cash' ? 'Nakit Kasa' : account.bankName || 'Banka Hesabı'}
            </p>
            {account.lastActivity && (
              <p className="text-xs text-muted-foreground mt-2">
                <Clock className="w-3 h-3 inline mr-1" />
                {new Date(account.lastActivity).toLocaleDateString('tr-TR')}
              </p>
            )}
          </motion.div>
        ))}
      </div>

      {/* Transactions Table */}
      <div className="bg-card rounded-xl border">
        {/* Table Header */}
        <div className="p-4 border-b">
          <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
            <div className="flex items-center gap-2 overflow-x-auto">
              <button
                onClick={() => setActiveTab('all')}
                className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors whitespace-nowrap ${
                  activeTab === 'all' ? 'bg-primary text-primary-foreground' : 'hover:bg-accent'
                }`}
              >
                Tümü ({transactions.length})
              </button>
              <button
                onClick={() => setActiveTab('income')}
                className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors whitespace-nowrap ${
                  activeTab === 'income' ? 'bg-green-500 text-white' : 'hover:bg-accent'
                }`}
              >
                Gelirler ({transactions.filter(t => t.type === 'income').length})
              </button>
              <button
                onClick={() => setActiveTab('expense')}
                className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors whitespace-nowrap ${
                  activeTab === 'expense' ? 'bg-red-500 text-white' : 'hover:bg-accent'
                }`}
              >
                Giderler ({transactions.filter(t => t.type === 'expense').length})
              </button>
              <button
                onClick={() => setActiveTab('transfer')}
                className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors whitespace-nowrap ${
                  activeTab === 'transfer' ? 'bg-blue-500 text-white' : 'hover:bg-accent'
                }`}
              >
                Transferler ({transactions.filter(t => t.type === 'transfer').length})
              </button>
            </div>
            <div className="flex items-center gap-2">
              <div className="relative">
                <Search className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
                <input
                  type="text"
                  placeholder="Ara..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-9 pr-4 py-2 bg-background border rounded-lg text-sm w-64"
                />
              </div>
              <button 
                onClick={() => setShowFilters(!showFilters)}
                className="px-3 py-2 border rounded-lg hover:bg-accent transition-colors"
              >
                <Filter className="w-4 h-4" />
              </button>
              <div className="relative group">
                <button className="px-3 py-2 border rounded-lg hover:bg-accent transition-colors">
                  <Download className="w-4 h-4" />
                </button>
                <div className="absolute right-0 top-full mt-1 bg-card border rounded-lg shadow-lg p-1 hidden group-hover:block z-10">
                  <button
                    onClick={() => handleExport('csv')}
                    className="block w-full px-3 py-2 text-left hover:bg-accent rounded text-sm"
                  >
                    CSV olarak indir
                  </button>
                  <button
                    onClick={() => handleExport('excel')}
                    className="block w-full px-3 py-2 text-left hover:bg-accent rounded text-sm"
                  >
                    Excel olarak indir
                  </button>
                  <button
                    onClick={() => handleExport('pdf')}
                    className="block w-full px-3 py-2 text-left hover:bg-accent rounded text-sm"
                  >
                    PDF olarak indir
                  </button>
                </div>
              </div>
            </div>
          </div>

          {/* Bulk Actions */}
          {selectedTransactions.length > 0 && (
            <div className="mt-4 p-3 bg-accent rounded-lg flex items-center justify-between">
              <span className="text-sm">
                {selectedTransactions.length} işlem seçildi
              </span>
              <div className="flex items-center gap-2">
                <button
                  onClick={() => handleBulkAction('approve')}
                  className="px-3 py-1 bg-green-500 text-white rounded text-sm hover:bg-green-600"
                >
                  Toplu Onayla
                </button>
                <button
                  onClick={() => handleBulkAction('reject')}
                  className="px-3 py-1 bg-red-500 text-white rounded text-sm hover:bg-red-600"
                >
                  Toplu Reddet
                </button>
                <button
                  onClick={() => handleBulkAction('delete')}
                  className="px-3 py-1 bg-destructive text-destructive-foreground rounded text-sm hover:bg-destructive/90"
                >
                  Toplu Sil
                </button>
              </div>
            </div>
          )}
        </div>

        {/* Table Body */}
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-muted/50">
              <tr>
                <th className="text-left p-4 text-sm font-medium">
                  <input
                    type="checkbox"
                    onChange={(e) => {
                      if (e.target.checked) {
                        setSelectedTransactions(filteredTransactions.map(t => t.id))
                      } else {
                        setSelectedTransactions([])
                      }
                    }}
                    checked={selectedTransactions.length === filteredTransactions.length && filteredTransactions.length > 0}
                  />
                </th>
                <th className="text-left p-4 text-sm font-medium">İşlem No</th>
                <th className="text-left p-4 text-sm font-medium">Tür</th>
                <th className="text-left p-4 text-sm font-medium">Kategori</th>
                <th className="text-left p-4 text-sm font-medium">Açıklama</th>
                <th className="text-left p-4 text-sm font-medium">Tutar</th>
                <th className="text-left p-4 text-sm font-medium">Tarih</th>
                <th className="text-left p-4 text-sm font-medium">Durum</th>
                <th className="text-left p-4 text-sm font-medium">İşlemler</th>
              </tr>
            </thead>
            <tbody>
              {filteredTransactions.map((transaction, index) => (
                <motion.tr
                  key={transaction.id}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: index * 0.05 }}
                  className="border-b hover:bg-muted/30 transition-colors"
                >
                  <td className="p-4">
                    <input
                      type="checkbox"
                      checked={selectedTransactions.includes(transaction.id)}
                      onChange={(e) => {
                        if (e.target.checked) {
                          setSelectedTransactions(prev => [...prev, transaction.id])
                        } else {
                          setSelectedTransactions(prev => prev.filter(id => id !== transaction.id))
                        }
                      }}
                    />
                  </td>
                  <td className="p-4">
                    <span className="text-sm font-mono">{transaction.transactionNo}</span>
                  </td>
                  <td className="p-4">
                    <div className={`
                      inline-flex items-center gap-1 px-2 py-1 rounded-lg text-sm
                      ${transaction.type === 'income' ? 'bg-green-500/10 text-green-600' :
                        transaction.type === 'expense' ? 'bg-red-500/10 text-red-600' :
                        'bg-blue-500/10 text-blue-600'}
                    `}>
                      {getTransactionIcon(transaction.type)}
                      <span>
                        {transaction.type === 'income' ? 'Gelir' :
                         transaction.type === 'expense' ? 'Gider' : 'Transfer'}
                      </span>
                    </div>
                  </td>
                  <td className="p-4">
                    <span className="text-sm">{transaction.category}</span>
                    {transaction.recurring && (
                      <span className="ml-1 text-xs text-muted-foreground">
                        (Tekrarlı)
                      </span>
                    )}
                  </td>
                  <td className="p-4">
                    <div>
                      <p className="text-sm">{transaction.description}</p>
                      {transaction.facility && (
                        <p className="text-xs text-muted-foreground mt-1">
                          <Building2 className="w-3 h-3 inline mr-1" />
                          {transaction.facility}
                        </p>
                      )}
                      {transaction.tags && transaction.tags.length > 0 && (
                        <div className="flex gap-1 mt-1">
                          {transaction.tags.map(tag => (
                            <span key={tag} className="px-2 py-0.5 bg-accent rounded text-xs">
                              {tag}
                            </span>
                          ))}
                        </div>
                      )}
                    </div>
                  </td>
                  <td className="p-4">
                    <span className={`text-sm font-semibold ${
                      transaction.type === 'income' ? 'text-green-600' :
                      transaction.type === 'expense' ? 'text-red-600' : ''
                    }`}>
                      {transaction.type === 'income' ? '+' : transaction.type === 'expense' ? '-' : ''}
                      {currencySymbols[transaction.currency]}
                      {transaction.amount.toLocaleString()}
                    </span>
                  </td>
                  <td className="p-4">
                    <span className="text-sm">{transaction.date}</span>
                  </td>
                  <td className="p-4">
                    {getStatusBadge(transaction.status)}
                  </td>
                  <td className="p-4">
                    <div className="flex items-center gap-1">
                      <button
                        onClick={() => setSelectedTransaction(transaction)}
                        className="p-1 hover:bg-accent rounded-lg transition-colors"
                      >
                        <Eye className="w-4 h-4" />
                      </button>
                      {transaction.status === 'pending' && (
                        <>
                          <button
                            onClick={() => handleApproveTransaction(transaction.id)}
                            className="p-1 hover:bg-green-500/10 text-green-600 rounded-lg transition-colors"
                          >
                            <Check className="w-4 h-4" />
                          </button>
                          <button
                            onClick={() => handleRejectTransaction(transaction.id)}
                            className="p-1 hover:bg-red-500/10 text-red-600 rounded-lg transition-colors"
                          >
                            <X className="w-4 h-4" />
                          </button>
                        </>
                      )}
                      <button className="p-1 hover:bg-accent rounded-lg transition-colors">
                        <Edit className="w-4 h-4" />
                      </button>
                      <button
                        onClick={() => handleDeleteTransaction(transaction.id)}
                        className="p-1 hover:bg-red-500/10 text-red-600 rounded-lg transition-colors"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>
                  </td>
                </motion.tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        <div className="p-4 border-t flex items-center justify-between">
          <p className="text-sm text-muted-foreground">
            {filteredTransactions.length} kayıttan 1-{Math.min(10, filteredTransactions.length)} gösteriliyor
          </p>
          <div className="flex items-center gap-2">
            <button className="px-3 py-1 border rounded hover:bg-accent disabled:opacity-50" disabled>
              Önceki
            </button>
            <button className="px-3 py-1 bg-primary text-primary-foreground rounded">1</button>
            <button className="px-3 py-1 border rounded hover:bg-accent">2</button>
            <button className="px-3 py-1 border rounded hover:bg-accent">3</button>
            <button className="px-3 py-1 border rounded hover:bg-accent">
              Sonraki
            </button>
          </div>
        </div>
      </div>

      {/* New Transaction Modal */}
      <AnimatePresence>
        {showNewTransaction && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50"
            onClick={() => setShowNewTransaction(false)}
          >
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              className="bg-card rounded-xl p-6 w-full max-w-2xl max-h-[90vh] overflow-y-auto"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-xl font-semibold">
                  {transactionType === 'income' ? 'Yeni Gelir' :
                   transactionType === 'expense' ? 'Yeni Gider' : 'Yeni Transfer'}
                </h2>
                <button
                  onClick={() => setShowNewTransaction(false)}
                  className="p-2 hover:bg-accent rounded-lg transition-colors"
                >
                  <X className="w-5 h-5" />
                </button>
              </div>

              <form onSubmit={handleCreateTransaction} className="space-y-4">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label className="text-sm font-medium mb-1 block">İşlem Türü *</label>
                    <select
                      value={newTransaction.type}
                      onChange={(e) => setNewTransaction({ ...newTransaction, type: e.target.value as TransactionType })}
                      className="w-full px-3 py-2 bg-background border rounded-lg"
                      required
                    >
                      <option value="income">Gelir</option>
                      <option value="expense">Gider</option>
                      <option value="transfer">Transfer</option>
                    </select>
                  </div>
                  <div>
                    <label className="text-sm font-medium mb-1 block">Kategori *</label>
                    <select
                      value={newTransaction.category}
                      onChange={(e) => setNewTransaction({ ...newTransaction, category: e.target.value })}
                      className="w-full px-3 py-2 bg-background border rounded-lg"
                      required
                    >
                      <option value="">Seçin...</option>
                      {newTransaction.type === 'income' ? (
                        categories.income.map(cat => (
                          <option key={cat.id} value={cat.name}>{cat.name}</option>
                        ))
                      ) : newTransaction.type === 'expense' ? (
                        categories.expense.map(cat => (
                          <option key={cat.id} value={cat.name}>{cat.name}</option>
                        ))
                      ) : (
                        <option value="Transfer">Transfer</option>
                      )}
                    </select>
                  </div>
                  <div>
                    <label className="text-sm font-medium mb-1 block">Tutar *</label>
                    <input
                      type="number"
                      placeholder="0.00"
                      value={newTransaction.amount}
                      onChange={(e) => setNewTransaction({ ...newTransaction, amount: e.target.value })}
                      className="w-full px-3 py-2 bg-background border rounded-lg"
                      required
                    />
                  </div>
                  <div>
                    <label className="text-sm font-medium mb-1 block">Para Birimi</label>
                    <select
                      value={newTransaction.currency}
                      onChange={(e) => setNewTransaction({ ...newTransaction, currency: e.target.value as Currency })}
                      className="w-full px-3 py-2 bg-background border rounded-lg"
                    >
                      <option value="TRY">TRY (₺)</option>
                      <option value="USD">USD ($)</option>
                      <option value="EUR">EUR (€)</option>
                      <option value="GBP">GBP (£)</option>
                    </select>
                  </div>
                  {newTransaction.type === 'transfer' ? (
                    <>
                      <div>
                        <label className="text-sm font-medium mb-1 block">Kaynak Kasa</label>
                        <select
                          value={newTransaction.fromAccount}
                          onChange={(e) => setNewTransaction({ ...newTransaction, fromAccount: e.target.value })}
                          className="w-full px-3 py-2 bg-background border rounded-lg"
                        >
                          <option value="">Seçin...</option>
                          {accounts.map(account => (
                            <option key={account.id} value={account.name}>
                              {account.name} ({account.currency} {account.balance.toLocaleString()})
                            </option>
                          ))}
                        </select>
                      </div>
                      <div>
                        <label className="text-sm font-medium mb-1 block">Hedef Kasa</label>
                        <select
                          value={newTransaction.toAccount}
                          onChange={(e) => setNewTransaction({ ...newTransaction, toAccount: e.target.value })}
                          className="w-full px-3 py-2 bg-background border rounded-lg"
                        >
                          <option value="">Seçin...</option>
                          {accounts.map(account => (
                            <option key={account.id} value={account.name}>
                              {account.name} ({account.currency} {account.balance.toLocaleString()})
                            </option>
                          ))}
                        </select>
                      </div>
                    </>
                  ) : (
                    <div>
                      <label className="text-sm font-medium mb-1 block">
                        {newTransaction.type === 'income' ? 'Hedef Kasa' : 'Kaynak Kasa'}
                      </label>
                      <select
                        value={newTransaction.type === 'income' ? newTransaction.toAccount : newTransaction.fromAccount}
                        onChange={(e) => {
                          if (newTransaction.type === 'income') {
                            setNewTransaction({ ...newTransaction, toAccount: e.target.value })
                          } else {
                            setNewTransaction({ ...newTransaction, fromAccount: e.target.value })
                          }
                        }}
                        className="w-full px-3 py-2 bg-background border rounded-lg"
                      >
                        <option value="">Seçin...</option>
                        {accounts.map(account => (
                          <option key={account.id} value={account.name}>
                            {account.name} ({account.currency} {account.balance.toLocaleString()})
                          </option>
                        ))}
                      </select>
                    </div>
                  )}
                  <div>
                    <label className="text-sm font-medium mb-1 block">İşlem Tarihi</label>
                    <input
                      type="date"
                      value={newTransaction.date}
                      onChange={(e) => setNewTransaction({ ...newTransaction, date: e.target.value })}
                      className="w-full px-3 py-2 bg-background border rounded-lg"
                    />
                  </div>
                  <div>
                    <label className="text-sm font-medium mb-1 block">Tesis</label>
                    <select
                      value={newTransaction.facility}
                      onChange={(e) => setNewTransaction({ ...newTransaction, facility: e.target.value })}
                      className="w-full px-3 py-2 bg-background border rounded-lg"
                    >
                      <option value="">Seçin...</option>
                      <option value="Merkez">Merkez</option>
                      <option value="Nijer">Nijer</option>
                      <option value="Senegal">Senegal</option>
                      <option value="Mali">Mali</option>
                    </select>
                  </div>
                  <div>
                    <label className="text-sm font-medium mb-1 block">Proje</label>
                    <select
                      value={newTransaction.project}
                      onChange={(e) => setNewTransaction({ ...newTransaction, project: e.target.value })}
                      className="w-full px-3 py-2 bg-background border rounded-lg"
                    >
                      <option value="">Seçin...</option>
                      <option value="Su Kuyusu">Su Kuyusu Projesi</option>
                      <option value="Eğitim">Eğitim Merkezi</option>
                      <option value="Sağlık">Sağlık Taraması</option>
                    </select>
                  </div>
                </div>

                <div>
                  <label className="text-sm font-medium mb-1 block">Açıklama</label>
                  <textarea
                    rows={3}
                    placeholder="İşlem açıklaması..."
                    value={newTransaction.description}
                    onChange={(e) => setNewTransaction({ ...newTransaction, description: e.target.value })}
                    className="w-full px-3 py-2 bg-background border rounded-lg resize-none"
                  />
                </div>

                <div className="flex items-center gap-4">
                  <label className="flex items-center gap-2 cursor-pointer">
                    <input
                      type="checkbox"
                      checked={newTransaction.recurring}
                      onChange={(e) => setNewTransaction({ ...newTransaction, recurring: e.target.checked })}
                      className="w-4 h-4 rounded"
                    />
                    <span className="text-sm">Tekrarlı İşlem</span>
                  </label>
                  {newTransaction.recurring && (
                    <select
                      value={newTransaction.recurringPeriod}
                      onChange={(e) => setNewTransaction({ ...newTransaction, recurringPeriod: e.target.value as any })}
                      className="px-3 py-1 bg-background border rounded text-sm"
                    >
                      <option value="daily">Günlük</option>
                      <option value="weekly">Haftalık</option>
                      <option value="monthly">Aylık</option>
                      <option value="yearly">Yıllık</option>
                    </select>
                  )}
                </div>

                <div>
                  <label className="text-sm font-medium mb-1 block">Belgeler</label>
                  <div className="border-2 border-dashed rounded-lg p-8 text-center">
                    <Upload className="w-12 h-12 mx-auto text-muted-foreground mb-3" />
                    <p className="text-sm text-muted-foreground mb-2">
                      Dosyaları sürükleyin veya tıklayın
                    </p>
                    <button
                      type="button"
                      className="px-4 py-2 bg-primary text-primary-foreground rounded-lg text-sm"
                    >
                      Dosya Seç
                    </button>
                  </div>
                </div>

                <div className="flex items-center justify-end gap-2 pt-4">
                  <button
                    type="button"
                    onClick={() => setShowNewTransaction(false)}
                    className="px-4 py-2 border rounded-lg hover:bg-accent transition-colors"
                  >
                    İptal
                  </button>
                  <button
                    type="submit"
                    className="px-4 py-2 bg-primary text-primary-foreground rounded-lg hover:bg-primary/90 transition-colors"
                  >
                    Kaydet
                  </button>
                </div>
              </form>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Transaction Details Modal */}
      <AnimatePresence>
        {selectedTransaction && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50"
            onClick={() => setSelectedTransaction(null)}
          >
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              className="bg-card rounded-xl p-6 w-full max-w-2xl"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-xl font-semibold">İşlem Detayları</h2>
                <button
                  onClick={() => setSelectedTransaction(null)}
                  className="p-2 hover:bg-accent rounded-lg"
                >
                  <X className="w-5 h-5" />
                </button>
              </div>

              <div className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <p className="text-sm text-muted-foreground">İşlem No</p>
                    <p className="font-medium">{selectedTransaction.transactionNo}</p>
                  </div>
                  <div>
                    <p className="text-sm text-muted-foreground">Durum</p>
                    <div>{getStatusBadge(selectedTransaction.status)}</div>
                  </div>
                  <div>
                    <p className="text-sm text-muted-foreground">Tür</p>
                    <p className="font-medium">
                      {selectedTransaction.type === 'income' ? 'Gelir' :
                       selectedTransaction.type === 'expense' ? 'Gider' : 'Transfer'}
                    </p>
                  </div>
                  <div>
                    <p className="text-sm text-muted-foreground">Kategori</p>
                    <p className="font-medium">{selectedTransaction.category}</p>
                  </div>
                  <div>
                    <p className="text-sm text-muted-foreground">Tutar</p>
                    <p className="font-medium text-lg">
                      {currencySymbols[selectedTransaction.currency]}
                      {selectedTransaction.amount.toLocaleString()}
                    </p>
                  </div>
                  <div>
                    <p className="text-sm text-muted-foreground">Tarih</p>
                    <p className="font-medium">{selectedTransaction.date}</p>
                  </div>
                </div>

                <div>
                  <p className="text-sm text-muted-foreground mb-1">Açıklama</p>
                  <p className="font-medium">{selectedTransaction.description}</p>
                </div>

                {selectedTransaction.documents.length > 0 && (
                  <div>
                    <p className="text-sm text-muted-foreground mb-2">Belgeler</p>
                    <div className="flex gap-2">
                      {selectedTransaction.documents.map(doc => (
                        <div key={doc} className="px-3 py-2 bg-accent rounded-lg text-sm flex items-center gap-2">
                          <FileText className="w-4 h-4" />
                          {doc}
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                <div className="pt-4 border-t">
                  <p className="text-xs text-muted-foreground">
                    Oluşturan: {selectedTransaction.createdBy} | {selectedTransaction.createdAt}
                  </p>
                </div>

                <div className="flex items-center justify-end gap-2">
                  <button className="px-4 py-2 border rounded-lg hover:bg-accent flex items-center gap-2">
                    <Printer className="w-4 h-4" />
                    Yazdır
                  </button>
                  <button className="px-4 py-2 border rounded-lg hover:bg-accent flex items-center gap-2">
                    <Share2 className="w-4 h-4" />
                    Paylaş
                  </button>
                  <button className="px-4 py-2 bg-primary text-primary-foreground rounded-lg flex items-center gap-2">
                    <Edit className="w-4 h-4" />
                    Düzenle
                  </button>
                </div>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}
ENDOFCASHMANAGEMENT

echo -e "${GREEN}✅ Cash Management component oluşturuldu${NC}"
echo ""

echo -e "${CYAN}════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}Bölüm 4 tamamlandı. Cash Management hazır!${NC}"
echo -e "${CYAN}════════════════════════════════════════════════${NC}"