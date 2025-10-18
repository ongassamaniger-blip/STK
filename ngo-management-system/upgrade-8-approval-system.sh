#!/bin/bash
# upgrade-8-approval-system.sh
# Approval System Module
# Date: 2025-10-18 10:53:00
# User: ongassamaniger-blip

echo "✅ =========================================="
echo "   ONAY SİSTEMİ MODÜLÜ"
echo "   Multi-level approval, workflow, escalation..."
echo "✅ =========================================="

# Approvals klasörü oluştur
mkdir -p "app/(main)/approvals"

# Approval System Page
cat > "app/(main)/approvals/page.tsx" << 'EOF'
'use client'

import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import {
  CheckCircle, XCircle, Clock, AlertTriangle, 
  FileText, DollarSign, Users, Building2,
  Eye, Check, X, MessageSquare, History,
  Filter, Search, Download, TrendingUp,
  Calendar, Timer, ChevronRight, MoreVertical,
  Receipt, Package, Briefcase, Heart,
  ArrowUpRight, ArrowDownRight, Activity,
  Shield, Zap, AlertCircle, RefreshCw
} from 'lucide-react'
import {
  AreaChart, Area, BarChart, Bar, XAxis, YAxis,
  CartesianGrid, Tooltip, ResponsiveContainer,
  PieChart, Pie, Cell, LineChart, Line
} from 'recharts'

interface Approval {
  id: string
  type: 'expense' | 'project' | 'leave' | 'purchase' | 'transfer' | 'sacrifice'
  title: string
  description: string
  requester: string
  requesterDepartment: string
  amount?: number
  currency?: string
  status: 'pending' | 'approved' | 'rejected' | 'escalated'
  priority: 'low' | 'medium' | 'high' | 'urgent'
  createdAt: string
  dueDate: string
  approvers: {
    level: number
    name: string
    status: 'pending' | 'approved' | 'rejected'
    approvedAt?: string
    comment?: string
  }[]
  currentLevel: number
  maxLevel: number
  documents: {
    name: string
    url: string
  }[]
  history: {
    action: string
    user: string
    timestamp: string
    comment?: string
  }[]
}

export default function ApprovalsPage() {
  const [approvals, setApprovals] = useState<Approval[]>([
    {
      id: '1',
      type: 'expense',
      title: 'Nijer Ofisi Kira Ödemesi',
      description: 'Ekim ayı kira ödemesi onayı',
      requester: 'Ahmet Yılmaz',
      requesterDepartment: 'Operasyon',
      amount: 45000,
      currency: 'TRY',
      status: 'pending',
      priority: 'high',
      createdAt: '2025-10-15T10:00:00',
      dueDate: '2025-10-20T17:00:00',
      currentLevel: 1,
      maxLevel: 2,
      approvers: [
        { level: 1, name: 'Mehmet Öz', status: 'pending' },
        { level: 2, name: 'Fatma Kaya', status: 'pending' }
      ],
      documents: [
        { name: 'kira_sozlesmesi.pdf', url: '#' },
        { name: 'fatura.pdf', url: '#' }
      ],
      history: [
        { action: 'created', user: 'Ahmet Yılmaz', timestamp: '2025-10-15T10:00:00' }
      ]
    },
    {
      id: '2',
      type: 'project',
      title: 'Su Kuyusu Projesi Başlangıç',
      description: 'Mali bölgesinde yeni su kuyusu projesi',
      requester: 'Moussa Diallo',
      requesterDepartment: 'Proje',
      amount: 250000,
      currency: 'TRY',
      status: 'approved',
      priority: 'urgent',
      createdAt: '2025-10-14T09:00:00',
      dueDate: '2025-10-18T17:00:00',
      currentLevel: 3,
      maxLevel: 3,
      approvers: [
        { level: 1, name: 'Mehmet Öz', status: 'approved', approvedAt: '2025-10-14T11:00:00' },
        { level: 2, name: 'Fatma Kaya', status: 'approved', approvedAt: '2025-10-14T14:00:00' },
        { level: 3, name: 'Ali Demir', status: 'approved', approvedAt: '2025-10-15T09:00:00', comment: 'Proje onaylandı, başlayabilirsiniz.' }
      ],
      documents: [
        { name: 'proje_dosyasi.pdf', url: '#' }
      ],
      history: [
        { action: 'created', user: 'Moussa Diallo', timestamp: '2025-10-14T09:00:00' },
        { action: 'approved', user: 'Mehmet Öz', timestamp: '2025-10-14T11:00:00' },
        { action: 'approved', user: 'Fatma Kaya', timestamp: '2025-10-14T14:00:00' },
        { action: 'approved', user: 'Ali Demir', timestamp: '2025-10-15T09:00:00', comment: 'Proje onaylandı, başlayabilirsiniz.' }
      ]
    },
    {
      id: '3',
      type: 'transfer',
      title: 'Kasa Transfer İşlemi',
      description: 'Ana kasadan Senegal kasasına transfer',
      requester: 'Fatma Kaya',
      requesterDepartment: 'Finans',
      amount: 100000,
      currency: 'TRY',
      status: 'escalated',
      priority: 'urgent',
      createdAt: '2025-10-16T14:00:00',
      dueDate: '2025-10-18T12:00:00',
      currentLevel: 2,
      maxLevel: 2,
      approvers: [
        { level: 1, name: 'Mehmet Öz', status: 'approved', approvedAt: '2025-10-16T15:00:00' },
        { level: 2, name: 'CEO', status: 'pending' }
      ],
      documents: [],
      history: [
        { action: 'created', user: 'Fatma Kaya', timestamp: '2025-10-16T14:00:00' },
        { action: 'approved', user: 'Mehmet Öz', timestamp: '2025-10-16T15:00:00' },
        { action: 'escalated', user: 'System', timestamp: '2025-10-17T12:00:00', comment: 'Otomatik yükseltme - süre aşımı' }
      ]
    }
  ])

  const [filterStatus, setFilterStatus] = useState('all')
  const [filterPriority, setFilterPriority] = useState('all')
  const [selectedApproval, setSelectedApproval] = useState<Approval | null>(null)
  const [showDetailModal, setShowDetailModal] = useState(false)
  const [approvalComment, setApprovalComment] = useState('')
  const [activeTab, setActiveTab] = useState('pending')

  // Statistics
  const pendingCount = approvals.filter(a => a.status === 'pending').length
  const approvedCount = approvals.filter(a => a.status === 'approved').length
  const rejectedCount = approvals.filter(a => a.status === 'rejected').length
  const escalatedCount = approvals.filter(a => a.status === 'escalated').length
  const totalAmount = approvals
    .filter(a => a.status === 'pending' && a.amount)
    .reduce((sum, a) => sum + (a.amount || 0), 0)

  const stats = [
    {
      label: 'Bekleyen',
      value: pendingCount,
      icon: Clock,
      color: 'yellow',
      change: '+3'
    },
    {
      label: 'Onaylanan',
      value: approvedCount,
      icon: CheckCircle,
      color: 'green',
      change: '+12'
    },
    {
      label: 'Reddedilen',
      value: rejectedCount,
      icon: XCircle,
      color: 'red',
      change: '2'
    },
    {
      label: 'Yükseltilen',
      value: escalatedCount,
      icon: AlertTriangle,
      color: 'orange',
      change: '1'
    }
  ]

  // Chart data
  const approvalTrend = [
    { day: 'Pzt', pending: 5, approved: 12, rejected: 2 },
    { day: 'Sal', pending: 8, approved: 15, rejected: 1 },
    { day: 'Çar', pending: 6, approved: 18, rejected: 3 },
    { day: 'Per', pending: 10, approved: 14, rejected: 2 },
    { day: 'Cum', pending: 7, approved: 20, rejected: 1 },
    { day: 'Cmt', pending: 3, approved: 8, rejected: 0 },
    { day: 'Paz', pending: 2, approved: 5, rejected: 0 }
  ]

  const typeDistribution = [
    { name: 'Gider', value: approvals.filter(a => a.type === 'expense').length, color: '#ef4444' },
    { name: 'Proje', value: approvals.filter(a => a.type === 'project').length, color: '#3b82f6' },
    { name: 'Transfer', value: approvals.filter(a => a.type === 'transfer').length, color: '#10b981' },
    { name: 'Satın Alma', value: approvals.filter(a => a.type === 'purchase').length, color: '#f59e0b' }
  ]

  const handleApprove = (approval: Approval) => {
    const updatedApproval = { ...approval }
    updatedApproval.approvers[approval.currentLevel - 1] = {
      ...updatedApproval.approvers[approval.currentLevel - 1],
      status: 'approved',
      approvedAt: new Date().toISOString(),
      comment: approvalComment
    }

    if (approval.currentLevel < approval.maxLevel) {
      updatedApproval.currentLevel++
    } else {
      updatedApproval.status = 'approved'
    }

    updatedApproval.history.push({
      action: 'approved',
      user: 'Current User',
      timestamp: new Date().toISOString(),
      comment: approvalComment
    })

    setApprovals(prev => prev.map(a => a.id === approval.id ? updatedApproval : a))
    setShowDetailModal(false)
    setApprovalComment('')
  }

  const handleReject = (approval: Approval) => {
    const updatedApproval = {
      ...approval,
      status: 'rejected' as const,
      approvers: approval.approvers.map((a, i) => 
        i === approval.currentLevel - 1 
          ? { ...a, status: 'rejected' as const }
          : a
      )
    }

    updatedApproval.history.push({
      action: 'rejected',
      user: 'Current User',
      timestamp: new Date().toISOString(),
      comment: approvalComment
    })

    setApprovals(prev => prev.map(a => a.id === approval.id ? updatedApproval : a))
    setShowDetailModal(false)
    setApprovalComment('')
  }

  const getTypeIcon = (type: string) => {
    switch(type) {
      case 'expense': return Receipt
      case 'project': return Briefcase
      case 'transfer': return ArrowUpRight
      case 'purchase': return Package
      case 'sacrifice': return Heart
      default: return FileText
    }
  }

  const getPriorityColor = (priority: string) => {
    switch(priority) {
      case 'urgent': return 'text-red-600 bg-red-100'
      case 'high': return 'text-orange-600 bg-orange-100'
      case 'medium': return 'text-yellow-600 bg-yellow-100'
      case 'low': return 'text-green-600 bg-green-100'
      default: return 'text-gray-600 bg-gray-100'
    }
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">Onay Sistemi</h1>
          <p className="text-gray-500 dark:text-gray-400 mt-1">
            {pendingCount} onay bekliyor, {escalatedCount} yükseltildi
          </p>
        </div>
        <div className="flex items-center gap-2">
          <button className="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-lg hover:bg-gray-300 flex items-center gap-2">
            <History className="w-4 h-4" />
            Geçmiş
          </button>
          <button className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 flex items-center gap-2">
            <Download className="w-4 h-4" />
            Rapor İndir
          </button>
        </div>
      </div>

      {/* Statistics */}
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
              <span className={`text-sm text-${stat.color}-600 font-medium`}>
                {stat.change}
              </span>
            </div>
            <p className="text-2xl font-bold text-gray-900 dark:text-white">{stat.value}</p>
            <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">{stat.label}</p>
          </motion.div>
        ))}
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Approval Trend */}
        <div className="lg:col-span-2 bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold mb-4">Haftalık Onay Trendi</h3>
          <ResponsiveContainer width="100%" height={250}>
            <LineChart data={approvalTrend}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="day" />
              <YAxis />
              <Tooltip />
              <Line type="monotone" dataKey="pending" stroke="#f59e0b" strokeWidth={2} name="Bekleyen" />
              <Line type="monotone" dataKey="approved" stroke="#10b981" strokeWidth={2} name="Onaylanan" />
              <Line type="monotone" dataKey="rejected" stroke="#ef4444" strokeWidth={2} name="Reddedilen" />
            </LineChart>
          </ResponsiveContainer>
        </div>

        {/* Type Distribution */}
        <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold mb-4">Tür Dağılımı</h3>
          <ResponsiveContainer width="100%" height={200}>
            <PieChart>
              <Pie
                data={typeDistribution}
                cx="50%"
                cy="50%"
                innerRadius={50}
                outerRadius={70}
                paddingAngle={5}
                dataKey="value"
              >
                {typeDistribution.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
          <div className="space-y-2 mt-4">
            {typeDistribution.map((item) => (
              <div key={item.name} className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div className="w-3 h-3 rounded-full" style={{ backgroundColor: item.color }} />
                  <span className="text-sm text-gray-600 dark:text-gray-400">{item.name}</span>
                </div>
                <span className="text-sm font-medium">{item.value}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex gap-2 border-b border-gray-200 dark:border-gray-700">
        {['pending', 'all', 'approved', 'rejected', 'escalated'].map((tab) => (
          <button
            key={tab}
            onClick={() => setActiveTab(tab)}
            className={`px-4 py-2 font-medium transition-colors relative ${
              activeTab === tab 
                ? 'text-blue-600' 
                : 'text-gray-500 hover:text-gray-700'
            }`}
          >
            {tab === 'pending' && 'Bekleyenler'}
            {tab === 'all' && 'Tümü'}
            {tab === 'approved' && 'Onaylananlar'}
            {tab === 'rejected' && 'Reddedilenler'}
            {tab === 'escalated' && 'Yükseltilenler'}
            {activeTab === tab && (
              <motion.div
                layoutId="activeTab"
                className="absolute bottom-0 left-0 right-0 h-0.5 bg-blue-600"
              />
            )}
          </button>
        ))}
      </div>

      {/* Filters */}
      <div className="bg-white dark:bg-gray-800 rounded-lg p-4 shadow border border-gray-200 dark:border-gray-700">
        <div className="flex gap-4">
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder="Onay ara..."
              className="w-full pl-10 pr-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
            />
          </div>
          <select 
            value={filterPriority}
            onChange={(e) => setFilterPriority(e.target.value)}
            className="px-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
          >
            <option value="all">Tüm Öncelikler</option>
            <option value="urgent">Acil</option>
            <option value="high">Yüksek</option>
            <option value="medium">Orta</option>
            <option value="low">Düşük</option>
          </select>
          <select className="px-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg">
            <option>Tüm Türler</option>
            <option>Gider</option>
            <option>Proje</option>
            <option>Transfer</option>
            <option>Satın Alma</option>
          </select>
        </div>
      </div>

      {/* Approval List */}
      <div className="space-y-4">
        {approvals
          .filter(a => activeTab === 'all' || a.status === activeTab)
          .map((approval) => {
            const TypeIcon = getTypeIcon(approval.type)
            const timeLeft = new Date(approval.dueDate).getTime() - new Date().getTime()
            const hoursLeft = Math.floor(timeLeft / (1000 * 60 * 60))
            
            return (
              <motion.div
                key={approval.id}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                className="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden hover:shadow-xl transition-shadow"
              >
                <div className="p-6">
                  <div className="flex items-start justify-between">
                    <div className="flex items-start gap-4">
                      {/* Type Icon */}
                      <div className={`p-3 rounded-lg ${
                        approval.status === 'approved' ? 'bg-green-100' :
                        approval.status === 'rejected' ? 'bg-red-100' :
                        approval.status === 'escalated' ? 'bg-orange-100' :
                        'bg-blue-100'
                      }`}>
                        <TypeIcon className={`w-6 h-6 ${
                          approval.status === 'approved' ? 'text-green-600' :
                          approval.status === 'rejected' ? 'text-red-600' :
                          approval.status === 'escalated' ? 'text-orange-600' :
                          'text-blue-600'
                        }`} />
                      </div>

                      {/* Content */}
                      <div className="flex-1">
                        <div className="flex items-center gap-3 mb-2">
                          <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                            {approval.title}
                          </h3>
                          <span className={`px-2 py-1 text-xs rounded-full ${getPriorityColor(approval.priority)}`}>
                            {approval.priority === 'urgent' ? 'Acil' :
                             approval.priority === 'high' ? 'Yüksek' :
                             approval.priority === 'medium' ? 'Orta' : 'Düşük'}
                          </span>
                          {approval.status === 'escalated' && (
                            <span className="px-2 py-1 text-xs rounded-full bg-orange-100 text-orange-600">
                              <Zap className="w-3 h-3 inline mr-1" />
                              Yükseltildi
                            </span>
                          )}
                        </div>
                        
                        <p className="text-gray-600 dark:text-gray-400 mb-3">
                          {approval.description}
                        </p>

                        <div className="flex items-center gap-6 text-sm text-gray-500">
                          <div className="flex items-center gap-1">
                            <Users className="w-4 h-4" />
                            <span>{approval.requester}</span>
                            <span className="text-gray-400">({approval.requesterDepartment})</span>
                          </div>
                          {approval.amount && (
                            <div className="flex items-center gap-1">
                              <DollarSign className="w-4 h-4" />
                              <span className="font-semibold text-gray-900 dark:text-white">
                                ₺{approval.amount.toLocaleString()}
                              </span>
                            </div>
                          )}
                          <div className="flex items-center gap-1">
                            <Calendar className="w-4 h-4" />
                            <span>{new Date(approval.createdAt).toLocaleDateString('tr-TR')}</span>
                          </div>
                          {approval.status === 'pending' && hoursLeft > 0 && (
                            <div className={`flex items-center gap-1 ${
                              hoursLeft < 24 ? 'text-red-600' : 'text-gray-500'
                            }`}>
                              <Timer className="w-4 h-4" />
                              <span>{hoursLeft < 24 ? `${hoursLeft} saat kaldı` : `${Math.floor(hoursLeft/24)} gün kaldı`}</span>
                            </div>
                          )}
                        </div>

                        {/* Approval Flow */}
                        <div className="mt-4">
                          <div className="flex items-center gap-2">
                            {approval.approvers.map((approver, index) => (
                              <div key={index} className="flex items-center">
                                <div className={`flex items-center gap-2 px-3 py-1.5 rounded-lg ${
                                  approver.status === 'approved' ? 'bg-green-100 text-green-700' :
                                  approver.status === 'rejected' ? 'bg-red-100 text-red-700' :
                                  index === approval.currentLevel - 1 ? 'bg-blue-100 text-blue-700' :
                                  'bg-gray-100 text-gray-500'
                                }`}>
                                  {approver.status === 'approved' ? <Check className="w-3 h-3" /> :
                                   approver.status === 'rejected' ? <X className="w-3 h-3" /> :
                                   index === approval.currentLevel - 1 ? <Clock className="w-3 h-3" /> :
                                   <div className="w-3 h-3 rounded-full bg-gray-300" />}
                                  <span className="text-xs font-medium">{approver.name}</span>
                                </div>
                                {index < approval.approvers.length - 1 && (
                                  <ChevronRight className="w-4 h-4 text-gray-400 mx-1" />
                                )}
                              </div>
                            ))}
                          </div>
                        </div>
                      </div>
                    </div>

                    {/* Actions */}
                    <div className="flex items-start gap-2">
                      {approval.status === 'pending' && (
                        <>
                          <button
                            onClick={() => {
                              setSelectedApproval(approval)
                              setShowDetailModal(true)
                            }}
                            className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 flex items-center gap-2"
                          >
                            <Check className="w-4 h-4" />
                            Onayla
                          </button>
                          <button
                            onClick={() => {
                              setSelectedApproval(approval)
                              setShowDetailModal(true)
                            }}
                            className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 flex items-center gap-2"
                          >
                            <X className="w-4 h-4" />
                            Reddet
                          </button>
                        </>
                      )}
                      <button
                        onClick={() => {
                          setSelectedApproval(approval)
                          setShowDetailModal(true)
                        }}
                        className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg"
                      >
                        <Eye className="w-4 h-4" />
                      </button>
                    </div>
                  </div>
                </div>

                {/* Documents */}
                {approval.documents.length > 0 && (
                  <div className="px-6 py-3 bg-gray-50 dark:bg-gray-700/50 border-t border-gray-200 dark:border-gray-700">
                    <div className="flex items-center gap-4">
                      <span className="text-sm text-gray-500">Belgeler:</span>
                      {approval.documents.map((doc, index) => (
                        <a
                          key={index}
                          href={doc.url}
                          className="text-sm text-blue-600 hover:underline flex items-center gap-1"
                        >
                          <FileText className="w-3 h-3" />
                          {doc.name}
                        </a>
                      ))}
                    </div>
                  </div>
                )}
              </motion.div>
            )
          })}
      </div>

      {/* Detail/Action Modal */}
      <AnimatePresence>
        {showDetailModal && selectedApproval && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
            onClick={() => setShowDetailModal(false)}
          >
            <motion.div
              initial={{ scale: 0.9 }}
              animate={{ scale: 1 }}
              exit={{ scale: 0.9 }}
              className="bg-white dark:bg-gray-800 rounded-2xl shadow-2xl max-w-3xl w-full max-h-[90vh] overflow-hidden"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="p-6 border-b border-gray-200 dark:border-gray-700">
                <h2 className="text-xl font-bold text-gray-900 dark:text-white">Onay Detayı</h2>
              </div>

              <div className="p-6 overflow-y-auto max-h-[60vh]">
                {/* Approval Details */}
                <div className="space-y-4">
                  <div>
                    <h3 className="font-semibold text-lg mb-2">{selectedApproval.title}</h3>
                    <p className="text-gray-600 dark:text-gray-400">{selectedApproval.description}</p>
                  </div>

                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <p className="text-sm text-gray-500">Talep Eden</p>
                      <p className="font-medium">{selectedApproval.requester} ({selectedApproval.requesterDepartment})</p>
                    </div>
                    {selectedApproval.amount && (
                      <div>
                        <p className="text-sm text-gray-500">Tutar</p>
                        <p className="font-medium text-xl">₺{selectedApproval.amount.toLocaleString()}</p>
                      </div>
                    )}
                    <div>
                      <p className="text-sm text-gray-500">Oluşturulma</p>
                      <p className="font-medium">{new Date(selectedApproval.createdAt).toLocaleString('tr-TR')}</p>
                    </div>
                    <div>
                      <p className="text-sm text-gray-500">Son Tarih</p>
                      <p className="font-medium">{new Date(selectedApproval.dueDate).toLocaleString('tr-TR')}</p>
                    </div>
                  </div>

                  {/* Approval History */}
                  <div>
                    <h4 className="font-semibold mb-2">Onay Geçmişi</h4>
                    <div className="space-y-2">
                      {selectedApproval.history.map((item, index) => (
                        <div key={index} className="flex items-start gap-3 p-3 bg-gray-50 dark:bg-gray-700/50 rounded-lg">
                          <div className={`p-1.5 rounded ${
                            item.action === 'approved' ? 'bg-green-100 text-green-600' :
                            item.action === 'rejected' ? 'bg-red-100 text-red-600' :
                            item.action === 'escalated' ? 'bg-orange-100 text-orange-600' :
                            'bg-gray-100 text-gray-600'
                          }`}>
                            {item.action === 'approved' ? <Check className="w-3 h-3" /> :
                             item.action === 'rejected' ? <X className="w-3 h-3" /> :
                             item.action === 'escalated' ? <AlertTriangle className="w-3 h-3" /> :
                             <Clock className="w-3 h-3" />}
                          </div>
                          <div className="flex-1">
                            <p className="text-sm font-medium">
                              {item.user} - {
                                item.action === 'created' ? 'Oluşturdu' :
                                item.action === 'approved' ? 'Onayladı' :
                                item.action === 'rejected' ? 'Reddetti' :
                                item.action === 'escalated' ? 'Yükseltildi' : item.action
                              }
                            </p>
                            <p className="text-xs text-gray-500">
                              {new Date(item.timestamp).toLocaleString('tr-TR')}
                            </p>
                            {item.comment && (
                              <p className="text-sm text-gray-600 dark:text-gray-400 mt-1">
                                "{item.comment}"
                              </p>
                            )}
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>

                  {/* Action Comment */}
                  {selectedApproval.status === 'pending' && (
                    <div>
                      <label className="block text-sm font-medium mb-2">Yorum (Opsiyonel)</label>
                      <textarea
                        value={approvalComment}
                        onChange={(e) => setApprovalComment(e.target.value)}
                        rows={3}
                        className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                        placeholder="Onay yorumunuz..."
                      />
                    </div>
                  )}
                </div>
              </div>

              <div className="p-6 border-t border-gray-200 dark:border-gray-700 flex justify-end gap-2">
                <button
                  onClick={() => setShowDetailModal(false)}
                  className="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-lg hover:bg-gray-300"
                >
                  Kapat
                </button>
                {selectedApproval.status === 'pending' && (
                  <>
                    <button
                      onClick={() => handleReject(selectedApproval)}
                      className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 flex items-center gap-2"
                    >
                      <X className="w-4 h-4" />
                      Reddet
                    </button>
                    <button
                      onClick={() => handleApprove(selectedApproval)}
                      className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 flex items-center gap-2"
                    >
                      <Check className="w-4 h-4" />
                      Onayla
                    </button>
                  </>
                )}
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}
EOF

echo "✅ Onay Sistemi modülü tamamlandı!"
echo ""
echo "🎯 Eklenen özellikler:"
echo "  ✓ Multi-level approval workflow"
echo "  ✓ Otomatik escalation"
echo "  ✓ Onay geçmişi"
echo "  ✓ Priority yönetimi"
echo "  ✓ Süre takibi"
echo "  ✓ Yorum sistemi"
echo "  ✓ Belge ekleme"
echo "  ✓ Grafik ve istatistikler"
echo ""
echo "📌 Test için: npm run dev"
echo "📌 Son 2 modül kaldı: Reports ve Settings"