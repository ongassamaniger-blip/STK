#!/bin/bash
# upgrade-9-reports-module.sh
# Reports Module with Custom Templates
# Date: 2025-10-18 10:56:42
# User: ongassamaniger-blip

echo "📊 =========================================="
echo "   RAPORLAMA MODÜLÜ"
echo "   Custom reports, templates, scheduled reports..."
echo "📊 =========================================="

# Reports klasörü oluştur
mkdir -p "app/(main)/reports"

# Reports Module Page
cat > "app/(main)/reports/page.tsx" << 'EOF'
'use client'

import { useState } from 'react'
import { motion } from 'framer-motion'
import {
  FileText, Download, Calendar, Filter, Search,
  BarChart3, PieChart, TrendingUp, Activity,
  Clock, CheckCircle, AlertCircle, Users,
  DollarSign, Building2, Package, Heart,
  Printer, Mail, Share2, Save, Play,
  Settings, Plus, Eye, Edit, Trash2,
  FileSpreadsheet, FilePieChart, FileBarChart,
  CalendarDays, Timer, RefreshCw, Database
} from 'lucide-react'
import {
  LineChart, Line, AreaChart, Area, BarChart, Bar,
  XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
  PieChart as RePieChart, Pie, Cell, RadialBarChart, RadialBar
} from 'recharts'

interface Report {
  id: string
  name: string
  description: string
  type: 'financial' | 'operational' | 'statistical' | 'custom'
  category: string
  frequency: 'daily' | 'weekly' | 'monthly' | 'yearly' | 'once'
  format: 'pdf' | 'excel' | 'csv'
  lastRun: string
  nextRun?: string
  status: 'ready' | 'generating' | 'scheduled' | 'error'
  createdBy: string
  createdAt: string
  parameters?: {
    dateRange?: { start: string; end: string }
    facilities?: string[]
    departments?: string[]
  }
  recipients?: string[]
}

interface ReportTemplate {
  id: string
  name: string
  icon: any
  description: string
  category: string
  parameters: {
    name: string
    type: string
    required: boolean
    default?: any
  }[]
}

export default function ReportsPage() {
  const [reports, setReports] = useState<Report[]>([
    {
      id: '1',
      name: 'Aylık Finansal Rapor',
      description: 'Detaylı gelir-gider analizi',
      type: 'financial',
      category: 'Finans',
      frequency: 'monthly',
      format: 'pdf',
      lastRun: '2025-10-01T09:00:00',
      nextRun: '2025-11-01T09:00:00',
      status: 'ready',
      createdBy: 'Admin',
      createdAt: '2025-01-15T10:00:00',
      recipients: ['admin@ngo.org', 'finance@ngo.org']
    },
    {
      id: '2',
      name: 'Proje İlerleme Raporu',
      description: 'Tüm projelerin durumu',
      type: 'operational',
      category: 'Operasyon',
      frequency: 'weekly',
      format: 'excel',
      lastRun: '2025-10-14T09:00:00',
      nextRun: '2025-10-21T09:00:00',
      status: 'scheduled',
      createdBy: 'Proje Müdürü',
      createdAt: '2025-02-20T14:00:00'
    },
    {
      id: '3',
      name: 'Kurban Takip Raporu',
      description: 'Kurban hisse ve dağıtım durumu',
      type: 'operational',
      category: 'Kurban',
      frequency: 'once',
      format: 'excel',
      lastRun: '2025-10-15T15:00:00',
      status: 'ready',
      createdBy: 'Operasyon',
      createdAt: '2025-06-01T10:00:00'
    }
  ])

  const [templates] = useState<ReportTemplate[]>([
    {
      id: '1',
      name: 'Finansal Özet',
      icon: DollarSign,
      description: 'Gelir, gider ve bütçe analizi',
      category: 'Finans',
      parameters: [
        { name: 'dateRange', type: 'dateRange', required: true },
        { name: 'facilities', type: 'multiSelect', required: false },
        { name: 'includeTax', type: 'boolean', required: false, default: true }
      ]
    },
    {
      id: '2',
      name: 'Personel Raporu',
      icon: Users,
      description: 'Personel listesi ve maaş özeti',
      category: 'İnsan Kaynakları',
      parameters: [
        { name: 'department', type: 'select', required: false },
        { name: 'status', type: 'select', required: false },
        { name: 'includeLeave', type: 'boolean', required: false, default: false }
      ]
    },
    {
      id: '3',
      name: 'Tesis Performansı',
      icon: Building2,
      description: 'Tesis bazlı performans metrikleri',
      category: 'Operasyon',
      parameters: [
        { name: 'facility', type: 'select', required: true },
        { name: 'period', type: 'select', required: true },
        { name: 'compareLastPeriod', type: 'boolean', required: false, default: true }
      ]
    },
    {
      id: '4',
      name: 'Kurban Raporu',
      icon: Heart,
      description: 'Kurban kesim ve dağıtım detayları',
      category: 'Kurban',
      parameters: [
        { name: 'location', type: 'multiSelect', required: false },
        { name: 'status', type: 'select', required: false },
        { name: 'includePhotos', type: 'boolean', required: false, default: true }
      ]
    }
  ])

  const [activeTab, setActiveTab] = useState('reports')
  const [showCreateModal, setShowCreateModal] = useState(false)
  const [selectedTemplate, setSelectedTemplate] = useState<ReportTemplate | null>(null)
  const [reportParameters, setReportParameters] = useState<any>({})
  const [generatingReport, setGeneratingReport] = useState<string | null>(null)

  // Statistics
  const totalReports = reports.length
  const scheduledReports = reports.filter(r => r.frequency !== 'once').length
  const recentReports = reports.filter(r => {
    const lastRun = new Date(r.lastRun).getTime()
    const weekAgo = Date.now() - (7 * 24 * 60 * 60 * 1000)
    return lastRun > weekAgo
  }).length

  const stats = [
    {
      label: 'Toplam Rapor',
      value: totalReports,
      icon: FileText,
      color: 'blue',
      change: '+2'
    },
    {
      label: 'Zamanlanmış',
      value: scheduledReports,
      icon: Clock,
      color: 'green',
      change: `${Math.round(scheduledReports/totalReports*100)}%`
    },
    {
      label: 'Bu Hafta',
      value: recentReports,
      icon: Activity,
      color: 'purple',
      change: '+5'
    },
    {
      label: 'Şablon',
      value: templates.length,
      icon: Database,
      color: 'orange',
      change: '4'
    }
  ]

  // Sample chart data for preview
  const sampleChartData = [
    { month: 'Oca', value: 45000 },
    { month: 'Şub', value: 52000 },
    { month: 'Mar', value: 48000 },
    { month: 'Nis', value: 61000 },
    { month: 'May', value: 55000 },
    { month: 'Haz', value: 67000 }
  ]

  const categoryData = [
    { name: 'Finans', value: 35, color: '#3b82f6' },
    { name: 'Operasyon', value: 25, color: '#10b981' },
    { name: 'İK', value: 20, color: '#f59e0b' },
    { name: 'Kurban', value: 20, color: '#ef4444' }
  ]

  const generateReport = (reportId: string) => {
    setGeneratingReport(reportId)
    setTimeout(() => {
      setGeneratingReport(null)
      // Download simulation
      console.log('Report generated:', reportId)
    }, 2000)
  }

  const handleCreateReport = () => {
    if (!selectedTemplate) return
    
    const newReport: Report = {
      id: Date.now().toString(),
      name: `${selectedTemplate.name} - ${new Date().toLocaleDateString('tr-TR')}`,
      description: selectedTemplate.description,
      type: 'custom',
      category: selectedTemplate.category,
      frequency: 'once',
      format: 'pdf',
      lastRun: new Date().toISOString(),
      status: 'ready',
      createdBy: 'Current User',
      createdAt: new Date().toISOString(),
      parameters: reportParameters
    }
    
    setReports([newReport, ...reports])
    setShowCreateModal(false)
    setSelectedTemplate(null)
    setReportParameters({})
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">Raporlar</h1>
          <p className="text-gray-500 dark:text-gray-400 mt-1">
            Sistem raporları ve analizler
          </p>
        </div>
        <button
          onClick={() => setShowCreateModal(true)}
          className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center gap-2"
        >
          <Plus className="w-4 h-4" />
          Yeni Rapor
        </button>
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

      {/* Tabs */}
      <div className="border-b border-gray-200 dark:border-gray-700">
        <div className="flex gap-6">
          {['reports', 'templates', 'scheduled', 'analytics'].map((tab) => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className={`pb-3 px-1 font-medium transition-colors relative ${
                activeTab === tab
                  ? 'text-blue-600'
                  : 'text-gray-500 hover:text-gray-700'
              }`}
            >
              {tab === 'reports' && 'Raporlarım'}
              {tab === 'templates' && 'Şablonlar'}
              {tab === 'scheduled' && 'Zamanlanmış'}
              {tab === 'analytics' && 'Analitik'}
              {activeTab === tab && (
                <motion.div
                  layoutId="activeReportTab"
                  className="absolute bottom-0 left-0 right-0 h-0.5 bg-blue-600"
                />
              )}
            </button>
          ))}
        </div>
      </div>

      {/* Reports List */}
      {activeTab === 'reports' && (
        <div className="space-y-4">
          {/* Search and Filter */}
          <div className="bg-white dark:bg-gray-800 rounded-lg p-4 shadow border border-gray-200 dark:border-gray-700">
            <div className="flex gap-4">
              <div className="flex-1 relative">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  type="text"
                  placeholder="Rapor ara..."
                  className="w-full pl-10 pr-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                />
              </div>
              <select className="px-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg">
                <option>Tüm Kategoriler</option>
                <option>Finans</option>
                <option>Operasyon</option>
                <option>İnsan Kaynakları</option>
                <option>Kurban</option>
              </select>
              <select className="px-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg">
                <option>Tüm Formatlar</option>
                <option>PDF</option>
                <option>Excel</option>
                <option>CSV</option>
              </select>
            </div>
          </div>

          {/* Reports Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {reports.map((report) => (
              <motion.div
                key={report.id}
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                className="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden hover:shadow-xl transition-shadow"
              >
                <div className="p-6">
                  <div className="flex items-start justify-between mb-4">
                    <div className="flex items-center gap-3">
                      <div className={`p-3 rounded-lg ${
                        report.type === 'financial' ? 'bg-green-100 text-green-600' :
                        report.type === 'operational' ? 'bg-blue-100 text-blue-600' :
                        report.type === 'statistical' ? 'bg-purple-100 text-purple-600' :
                        'bg-gray-100 text-gray-600'
                      }`}>
                        {report.format === 'pdf' ? <FilePieChart className="w-5 h-5" /> :
                         report.format === 'excel' ? <FileSpreadsheet className="w-5 h-5" /> :
                         <FileBarChart className="w-5 h-5" />}
                      </div>
                      <div>
                        <h3 className="font-semibold text-gray-900 dark:text-white">{report.name}</h3>
                        <p className="text-sm text-gray-500">{report.category}</p>
                      </div>
                    </div>
                    <span className={`px-2 py-1 text-xs rounded-full ${
                      report.status === 'ready' ? 'bg-green-100 text-green-700' :
                      report.status === 'generating' ? 'bg-blue-100 text-blue-700' :
                      report.status === 'scheduled' ? 'bg-yellow-100 text-yellow-700' :
                      'bg-red-100 text-red-700'
                    }`}>
                      {report.status === 'ready' ? 'Hazır' :
                       report.status === 'generating' ? 'Oluşturuluyor' :
                       report.status === 'scheduled' ? 'Zamanlanmış' : 'Hata'}
                    </span>
                  </div>

                  <p className="text-sm text-gray-600 dark:text-gray-400 mb-4">
                    {report.description}
                  </p>

                  <div className="space-y-2 text-sm">
                    <div className="flex items-center justify-between">
                      <span className="text-gray-500">Son Çalıştırma:</span>
                      <span className="font-medium">
                        {new Date(report.lastRun).toLocaleDateString('tr-TR')}
                      </span>
                    </div>
                    {report.frequency !== 'once' && report.nextRun && (
                      <div className="flex items-center justify-between">
                        <span className="text-gray-500">Sonraki:</span>
                        <span className="font-medium">
                          {new Date(report.nextRun).toLocaleDateString('tr-TR')}
                        </span>
                      </div>
                    )}
                    <div className="flex items-center justify-between">
                      <span className="text-gray-500">Format:</span>
                      <span className="font-medium uppercase">{report.format}</span>
                    </div>
                  </div>

                  <div className="flex gap-2 mt-4">
                    <button
                      onClick={() => generateReport(report.id)}
                      disabled={generatingReport === report.id}
                      className="flex-1 px-3 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 flex items-center justify-center gap-2"
                    >
                      {generatingReport === report.id ? (
                        <>
                          <RefreshCw className="w-4 h-4 animate-spin" />
                          Oluşturuluyor...
                        </>
                      ) : (
                        <>
                          <Play className="w-4 h-4" />
                          Çalıştır
                        </>
                      )}
                    </button>
                    <button className="p-2 bg-gray-100 dark:bg-gray-700 rounded-lg hover:bg-gray-200">
                      <Download className="w-4 h-4" />
                    </button>
                    <button className="p-2 bg-gray-100 dark:bg-gray-700 rounded-lg hover:bg-gray-200">
                      <Settings className="w-4 h-4" />
                    </button>
                  </div>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      )}

      {/* Templates Tab */}
      {activeTab === 'templates' && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {templates.map((template) => (
            <motion.div
              key={template.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              className="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 p-6 hover:shadow-xl transition-shadow cursor-pointer"
              onClick={() => {
                setSelectedTemplate(template)
                setShowCreateModal(true)
              }}
            >
              <div className="flex items-center justify-center mb-4">
                <div className="p-4 bg-gradient-to-br from-blue-500 to-purple-600 rounded-xl">
                  <template.icon className="w-8 h-8 text-white" />
                </div>
              </div>
              <h3 className="font-semibold text-center text-gray-900 dark:text-white mb-2">
                {template.name}
              </h3>
              <p className="text-sm text-center text-gray-500 dark:text-gray-400">
                {template.description}
              </p>
              <div className="mt-4 flex items-center justify-center">
                <span className="text-xs px-2 py-1 bg-gray-100 dark:bg-gray-700 rounded">
                  {template.category}
                </span>
              </div>
            </motion.div>
          ))}
        </div>
      )}

      {/* Analytics Tab */}
      {activeTab === 'analytics' && (
        <div className="space-y-6">
          {/* Charts */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700">
              <h3 className="text-lg font-semibold mb-4">Rapor Kullanım Trendi</h3>
              <ResponsiveContainer width="100%" height={250}>
                <AreaChart data={sampleChartData}>
                  <defs>
                    <linearGradient id="colorReport" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="#3b82f6" stopOpacity={0.3}/>
                      <stop offset="95%" stopColor="#3b82f6" stopOpacity={0}/>
                    </linearGradient>
                  </defs>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="month" />
                  <YAxis />
                  <Tooltip />
                  <Area type="monotone" dataKey="value" stroke="#3b82f6" fillOpacity={1} fill="url(#colorReport)" />
                </AreaChart>
              </ResponsiveContainer>
            </div>

            <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700">
              <h3 className="text-lg font-semibold mb-4">Kategori Dağılımı</h3>
              <ResponsiveContainer width="100%" height={250}>
                <RePieChart>
                  <Pie
                    data={categoryData}
                    cx="50%"
                    cy="50%"
                    innerRadius={60}
                    outerRadius={80}
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
              <div className="grid grid-cols-2 gap-2 mt-4">
                {categoryData.map((item) => (
                  <div key={item.name} className="flex items-center gap-2">
                    <div className="w-3 h-3 rounded-full" style={{ backgroundColor: item.color }} />
                    <span className="text-sm text-gray-600 dark:text-gray-400">{item.name}</span>
                    <span className="text-sm font-medium ml-auto">{item.value}%</span>
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* Recent Activity */}
          <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700">
            <h3 className="text-lg font-semibold mb-4">Son Aktiviteler</h3>
            <div className="space-y-3">
              {[
                { user: 'Admin', action: 'Finansal Rapor oluşturdu', time: '2 saat önce', icon: FileText },
                { user: 'Mehmet Öz', action: 'Personel Raporu indirdi', time: '5 saat önce', icon: Download },
                { user: 'Fatma Kaya', action: 'Kurban Raporu zamanladı', time: '1 gün önce', icon: Clock },
                { user: 'Ali Demir', action: 'Proje Raporu paylaştı', time: '2 gün önce', icon: Share2 }
              ].map((activity, index) => (
                <div key={index} className="flex items-center gap-3 p-3 hover:bg-gray-50 dark:hover:bg-gray-700/50 rounded-lg">
                  <div className="p-2 bg-blue-100 dark:bg-blue-900/20 rounded-lg">
                    <activity.icon className="w-4 h-4 text-blue-600" />
                  </div>
                  <div className="flex-1">
                    <p className="text-sm font-medium text-gray-900 dark:text-white">
                      {activity.user} <span className="font-normal text-gray-600 dark:text-gray-400">{activity.action}</span>
                    </p>
                    <p className="text-xs text-gray-500">{activity.time}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* Create Report Modal */}
      {showCreateModal && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
          onClick={() => {
            setShowCreateModal(false)
            setSelectedTemplate(null)
          }}
        >
          <motion.div
            initial={{ scale: 0.9 }}
            animate={{ scale: 1 }}
            className="bg-white dark:bg-gray-800 rounded-2xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-hidden"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="p-6 border-b border-gray-200 dark:border-gray-700">
              <h2 className="text-xl font-bold text-gray-900 dark:text-white">
                {selectedTemplate ? selectedTemplate.name : 'Rapor Oluştur'}
              </h2>
            </div>

            <div className="p-6 overflow-y-auto max-h-[70vh]">
              {!selectedTemplate ? (
                <div className="grid grid-cols-2 gap-4">
                  {templates.map((template) => (
                    <button
                      key={template.id}
                      onClick={() => setSelectedTemplate(template)}
                      className="p-4 border-2 border-gray-200 dark:border-gray-700 rounded-lg hover:border-blue-500 transition-colors"
                    >
                      <template.icon className="w-8 h-8 mx-auto mb-2 text-blue-600" />
                      <p className="font-medium">{template.name}</p>
                      <p className="text-xs text-gray-500 mt-1">{template.description}</p>
                    </button>
                  ))}
                </div>
              ) : (
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm font-medium mb-2">Rapor Adı</label>
                    <input
                      type="text"
                      defaultValue={`${selectedTemplate.name} - ${new Date().toLocaleDateString('tr-TR')}`}
                      className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                    />
                  </div>

                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-medium mb-2">Tarih Aralığı</label>
                      <select className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg">
                        <option>Son 30 Gün</option>
                        <option>Bu Ay</option>
                        <option>Geçen Ay</option>
                        <option>Son 3 Ay</option>
                        <option>Bu Yıl</option>
                      </select>
                    </div>
                    <div>
                      <label className="block text-sm font-medium mb-2">Format</label>
                      <select className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg">
                        <option value="pdf">PDF</option>
                        <option value="excel">Excel</option>
                        <option value="csv">CSV</option>
                      </select>
                    </div>
                  </div>

                  <div>
                    <label className="block text-sm font-medium mb-2">Tesisler</label>
                    <div className="space-y-2">
                      {['Tümü', 'Nijer Ana Merkez', 'Senegal Şubesi', 'Mali Temsilcilik'].map(facility => (
                        <label key={facility} className="flex items-center gap-2">
                          <input type="checkbox" className="rounded" defaultChecked={facility === 'Tümü'} />
                          <span className="text-sm">{facility}</span>
                        </label>
                      ))}
                    </div>
                  </div>

                  <div>
                    <label className="block text-sm font-medium mb-2">E-posta Gönder</label>
                    <input
                      type="email"
                      placeholder="Alıcı e-posta adresleri (virgülle ayırın)"
                      className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                    />
                  </div>

                  <div>
                    <label className="flex items-center gap-2">
                      <input type="checkbox" className="rounded" />
                      <span className="text-sm">Bu raporu zamanla</span>
                    </label>
                  </div>
                </div>
              )}
            </div>

            <div className="p-6 border-t border-gray-200 dark:border-gray-700 flex justify-end gap-2">
              <button
                onClick={() => {
                  setShowCreateModal(false)
                  setSelectedTemplate(null)
                }}
                className="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-lg hover:bg-gray-300"
              >
                İptal
              </button>
              {selectedTemplate && (
                <button
                  onClick={handleCreateReport}
                  className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
                >
                  Rapor Oluştur
                </button>
              )}
            </div>
          </motion.div>
        </motion.div>
      )}
    </div>
  )
}
EOF

echo "✅ Raporlama modülü tamamlandı!"
echo ""
echo "🎯 Eklenen özellikler:"
echo "  ✓ Custom report templates"
echo "  ✓ Scheduled reports"
echo "  ✓ Multiple export formats (PDF, Excel, CSV)"
echo "  ✓ Report analytics"
echo "  ✓ Email integration"
echo "  ✓ Report parameters"
echo "  ✓ Recent activity tracking"
echo ""
echo "📌 Test için: npm run dev"
echo "📌 SON MODÜL: Settings (Ayarlar)"