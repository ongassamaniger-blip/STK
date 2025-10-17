'use client'

import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import {
  X, Maximize2, Minimize2, Settings, Move, Plus,
  BarChart3, PieChart, Activity, Users, DollarSign,
  TrendingUp, Target, Calendar, Clock, Bell, FileText
} from 'lucide-react'

export interface Widget {
  id: string
  type: string
  title: string
  icon: any
  color: string
  size: 'small' | 'medium' | 'large' | 'full'
  data?: any
  config?: any
}

interface WidgetManagerProps {
  onAddWidget: (widget: Widget) => void
  onClose: () => void
}

const availableWidgets = [
  {
    id: 'revenue-chart',
    type: 'chart',
    title: 'Gelir Analizi',
    icon: BarChart3,
    color: 'blue',
    size: 'large',
    description: 'Aylık gelir grafiği'
  },
  {
    id: 'expense-chart',
    type: 'chart',
    title: 'Gider Analizi',
    icon: TrendingUp,
    color: 'red',
    size: 'large',
    description: 'Gider trendleri'
  },
  {
    id: 'project-distribution',
    type: 'pie',
    title: 'Proje Dağılımı',
    icon: PieChart,
    color: 'purple',
    size: 'medium',
    description: 'Kategorilere göre projeler'
  },
  {
    id: 'personnel-stats',
    type: 'stats',
    title: 'Personel İstatistikleri',
    icon: Users,
    color: 'green',
    size: 'medium',
    description: 'Personel özet bilgileri'
  },
  {
    id: 'cash-flow',
    type: 'chart',
    title: 'Nakit Akış',
    icon: DollarSign,
    color: 'emerald',
    size: 'large',
    description: 'Nakit akış analizi'
  },
  {
    id: 'targets',
    type: 'progress',
    title: 'Hedefler',
    icon: Target,
    color: 'orange',
    size: 'medium',
    description: 'Hedef takip sistemi'
  },
  {
    id: 'calendar',
    type: 'calendar',
    title: 'Takvim',
    icon: Calendar,
    color: 'indigo',
    size: 'large',
    description: 'Etkinlik takvimi'
  },
  {
    id: 'activities',
    type: 'list',
    title: 'Aktiviteler',
    icon: Activity,
    color: 'pink',
    size: 'medium',
    description: 'Son aktiviteler'
  },
  {
    id: 'notifications',
    type: 'list',
    title: 'Bildirimler',
    icon: Bell,
    color: 'yellow',
    size: 'small',
    description: 'Sistem bildirimleri'
  },
  {
    id: 'quick-stats',
    type: 'stats',
    title: 'Hızlı İstatistikler',
    icon: FileText,
    color: 'cyan',
    size: 'large',
    description: 'Özet istatistikler'
  }
]

export default function WidgetManager({ onAddWidget, onClose }: WidgetManagerProps) {
  const [selectedCategory, setSelectedCategory] = useState('all')
  const [searchQuery, setSearchQuery] = useState('')

  const filteredWidgets = availableWidgets.filter(widget => {
    const matchesCategory = selectedCategory === 'all' || widget.type === selectedCategory
    const matchesSearch = widget.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          widget.description.toLowerCase().includes(searchQuery.toLowerCase())
    return matchesCategory && matchesSearch
  })

  const categories = [
    { id: 'all', label: 'Tümü' },
    { id: 'chart', label: 'Grafikler' },
    { id: 'stats', label: 'İstatistikler' },
    { id: 'list', label: 'Listeler' },
    { id: 'progress', label: 'İlerleme' }
  ]

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
      onClick={onClose}
    >
      <motion.div
        initial={{ scale: 0.9, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        exit={{ scale: 0.9, opacity: 0 }}
        className="bg-white dark:bg-gray-800 rounded-2xl shadow-2xl max-w-4xl w-full max-h-[85vh] overflow-hidden"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div className="p-6 border-b border-gray-200 dark:border-gray-700">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h2 className="text-2xl font-bold text-gray-900 dark:text-white">Widget Kütüphanesi</h2>
              <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
                Dashboard'a widget ekleyin
              </p>
            </div>
            <button
              onClick={onClose}
              className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors"
            >
              <X className="w-5 h-5" />
            </button>
          </div>

          {/* Search and Filter */}
          <div className="flex flex-col sm:flex-row gap-3">
            <input
              type="text"
              placeholder="Widget ara..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="flex-1 px-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
            <div className="flex gap-2">
              {categories.map(cat => (
                <button
                  key={cat.id}
                  onClick={() => setSelectedCategory(cat.id)}
                  className={`px-4 py-2 rounded-lg transition-colors ${
                    selectedCategory === cat.id
                      ? 'bg-blue-500 text-white'
                      : 'bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600'
                  }`}
                >
                  {cat.label}
                </button>
              ))}
            </div>
          </div>
        </div>

        {/* Widget Grid */}
        <div className="p-6 overflow-y-auto max-h-[60vh]">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {filteredWidgets.map((widget, index) => (
              <motion.div
                key={widget.id}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.05 }}
                className="p-4 border-2 border-gray-200 dark:border-gray-700 rounded-xl hover:border-blue-500 dark:hover:border-blue-400 cursor-pointer transition-all hover:shadow-lg group"
                onClick={() => onAddWidget(widget as Widget)}
              >
                <div className="flex items-start gap-3">
                  <div className={`p-3 bg-${widget.color}-100 dark:bg-${widget.color}-900/20 rounded-lg`}>
                    <widget.icon className={`w-6 h-6 text-${widget.color}-600`} />
                  </div>
                  <div className="flex-1">
                    <h3 className="font-semibold text-gray-900 dark:text-white">
                      {widget.title}
                    </h3>
                    <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
                      {widget.description}
                    </p>
                    <div className="mt-2 flex items-center gap-2">
                      <span className="text-xs px-2 py-1 bg-gray-100 dark:bg-gray-700 rounded">
                        {widget.size}
                      </span>
                      <span className="text-xs text-gray-500">
                        {widget.type}
                      </span>
                    </div>
                  </div>
                  <Plus className="w-5 h-5 opacity-0 group-hover:opacity-100 transition-opacity text-blue-500" />
                </div>
              </motion.div>
            ))}
          </div>

          {filteredWidgets.length === 0 && (
            <div className="text-center py-12">
              <p className="text-gray-500 dark:text-gray-400">
                Aradığınız kriterlere uygun widget bulunamadı
              </p>
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="p-4 border-t border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-900/50">
          <div className="flex items-center justify-between">
            <p className="text-sm text-gray-500 dark:text-gray-400">
              {availableWidgets.length} widget mevcut
            </p>
            <button
              onClick={onClose}
              className="px-4 py-2 bg-gray-200 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-lg hover:bg-gray-300 dark:hover:bg-gray-600 transition-colors"
            >
              Kapat
            </button>
          </div>
        </div>
      </motion.div>
    </motion.div>
  )
}
