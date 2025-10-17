#!/bin/bash
# upgrade-4-projects-optimized.sh
# Projects Management - Optimized Version
# Date: 2025-10-17 14:52:04
# User: ongassamaniger-blip

echo "📂 =========================================="
echo "   PROJE YÖNETİMİ - OPTIMIZED"
echo "   Kanban, Gantt, Dashboard..."
echo "📂 =========================================="

# Projects page
cat > "app/(main)/projects/page.tsx" << 'EOF'
'use client'

import { useState } from 'react'
import { motion } from 'framer-motion'
import {
  Plus, Filter, Search, Grid3x3, List, Calendar,
  Users, DollarSign, Clock, Target, MoreVertical,
  Edit, Trash2, Eye, FileText, Download, ChevronRight,
  AlertCircle, CheckCircle, Activity, TrendingUp
} from 'lucide-react'
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip,
  ResponsiveContainer, PieChart, Pie, Cell
} from 'recharts'

interface Project {
  id: string
  name: string
  description: string
  status: 'planning' | 'active' | 'completed' | 'paused'
  progress: number
  budget: number
  spent: number
  startDate: string
  endDate: string
  manager: string
  team: string[]
  category: string
  priority: 'low' | 'medium' | 'high'
  beneficiaries: number
}

export default function ProjectsPage() {
  const [viewMode, setViewMode] = useState<'grid' | 'list' | 'kanban'>('grid')
  const [showNewProject, setShowNewProject] = useState(false)
  const [projects] = useState<Project[]>([
    {
      id: '1',
      name: 'Su Kuyusu Projesi',
      description: 'Nijer\'de 10 köye temiz su erişimi',
      status: 'active',
      progress: 65,
      budget: 250000,
      spent: 162500,
      startDate: '2025-01-15',
      endDate: '2025-12-31',
      manager: 'Ahmet Yılmaz',
      team: ['Ali Veli', 'Ayşe Kaya'],
      category: 'Altyapı',
      priority: 'high',
      beneficiaries: 5000
    },
    {
      id: '2',
      name: 'Eğitim Merkezi',
      description: 'Senegal\'de eğitim tesisi kurulumu',
      status: 'planning',
      progress: 25,
      budget: 500000,
      spent: 125000,
      startDate: '2025-03-01',
      endDate: '2026-03-01',
      manager: 'Mehmet Öz',
      team: ['Fatma Demir', 'Hasan Çelik'],
      category: 'Eğitim',
      priority: 'medium',
      beneficiaries: 1200
    }
  ])

  const stats = [
    { label: 'Toplam Proje', value: projects.length, icon: FileText, color: 'blue' },
    { label: 'Aktif Proje', value: projects.filter(p => p.status === 'active').length, icon: Activity, color: 'green' },
    { label: 'Toplam Bütçe', value: `₺${projects.reduce((sum, p) => sum + p.budget, 0).toLocaleString()}`, icon: DollarSign, color: 'purple' },
    { label: 'Faydalanıcı', value: projects.reduce((sum, p) => sum + p.beneficiaries, 0).toLocaleString(), icon: Users, color: 'orange' }
  ]

  const chartData = [
    { name: 'Planlama', value: projects.filter(p => p.status === 'planning').length, color: '#3b82f6' },
    { name: 'Aktif', value: projects.filter(p => p.status === 'active').length, color: '#10b981' },
    { name: 'Tamamlandı', value: projects.filter(p => p.status === 'completed').length, color: '#8b5cf6' },
    { name: 'Durduruldu', value: projects.filter(p => p.status === 'paused').length, color: '#f59e0b' }
  ]

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">Proje Yönetimi</h1>
          <p className="text-gray-500 dark:text-gray-400 mt-1">
            {projects.length} proje yönetiliyor
          </p>
        </div>
        <button
          onClick={() => setShowNewProject(true)}
          className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 flex items-center gap-2"
        >
          <Plus className="w-4 h-4" />
          Yeni Proje
        </button>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat, index) => (
          <motion.div
            key={index}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: index * 0.1 }}
            className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700"
          >
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-500 dark:text-gray-400">{stat.label}</p>
                <p className="text-2xl font-bold text-gray-900 dark:text-white mt-1">{stat.value}</p>
              </div>
              <div className={`p-3 bg-${stat.color}-100 dark:bg-${stat.color}-900/20 rounded-lg`}>
                <stat.icon className={`w-6 h-6 text-${stat.color}-600`} />
              </div>
            </div>
          </motion.div>
        ))}
      </div>

      {/* View Controls */}
      <div className="flex items-center justify-between bg-white dark:bg-gray-800 rounded-lg p-4 shadow border border-gray-200 dark:border-gray-700">
        <div className="flex gap-2">
          <button
            onClick={() => setViewMode('grid')}
            className={`p-2 rounded ${viewMode === 'grid' ? 'bg-blue-100 text-blue-600' : 'hover:bg-gray-100'}`}
          >
            <Grid3x3 className="w-4 h-4" />
          </button>
          <button
            onClick={() => setViewMode('list')}
            className={`p-2 rounded ${viewMode === 'list' ? 'bg-blue-100 text-blue-600' : 'hover:bg-gray-100'}`}
          >
            <List className="w-4 h-4" />
          </button>
          <button
            onClick={() => setViewMode('kanban')}
            className={`p-2 rounded ${viewMode === 'kanban' ? 'bg-blue-100 text-blue-600' : 'hover:bg-gray-100'}`}
          >
            <Calendar className="w-4 h-4" />
          </button>
        </div>
        <div className="flex gap-2">
          <input
            type="text"
            placeholder="Proje ara..."
            className="px-3 py-1.5 bg-gray-100 dark:bg-gray-700 rounded-lg"
          />
          <button className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded">
            <Filter className="w-4 h-4" />
          </button>
        </div>
      </div>

      {/* Projects Grid */}
      {viewMode === 'grid' && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {projects.map((project) => (
            <motion.div
              key={project.id}
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              className="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden hover:shadow-xl transition-shadow"
            >
              <div className="p-6">
                <div className="flex items-start justify-between mb-4">
                  <div>
                    <h3 className="font-semibold text-lg text-gray-900 dark:text-white">{project.name}</h3>
                    <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">{project.description}</p>
                  </div>
                  <button className="p-1 hover:bg-gray-100 dark:hover:bg-gray-700 rounded">
                    <MoreVertical className="w-4 h-4" />
                  </button>
                </div>

                <div className="space-y-4">
                  <div>
                    <div className="flex justify-between text-sm mb-1">
                      <span className="text-gray-600 dark:text-gray-400">İlerleme</span>
                      <span className="font-medium">{project.progress}%</span>
                    </div>
                    <div className="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2">
                      <div 
                        className="bg-blue-600 h-2 rounded-full transition-all"
                        style={{ width: `${project.progress}%` }}
                      />
                    </div>
                  </div>

                  <div className="flex items-center justify-between text-sm">
                    <div>
                      <p className="text-gray-500 dark:text-gray-400">Bütçe</p>
                      <p className="font-medium">₺{project.budget.toLocaleString()}</p>
                    </div>
                    <div>
                      <p className="text-gray-500 dark:text-gray-400">Harcanan</p>
                      <p className="font-medium">₺{project.spent.toLocaleString()}</p>
                    </div>
                  </div>

                  <div className="flex items-center justify-between">
                    <span className={`px-2 py-1 text-xs rounded-full ${
                      project.status === 'active' ? 'bg-green-100 text-green-700' :
                      project.status === 'planning' ? 'bg-blue-100 text-blue-700' :
                      project.status === 'completed' ? 'bg-purple-100 text-purple-700' :
                      'bg-yellow-100 text-yellow-700'
                    }`}>
                      {project.status === 'active' ? 'Aktif' :
                       project.status === 'planning' ? 'Planlama' :
                       project.status === 'completed' ? 'Tamamlandı' : 'Durduruldu'}
                    </span>
                    <div className="flex items-center gap-1">
                      <Users className="w-4 h-4 text-gray-400" />
                      <span className="text-sm text-gray-600 dark:text-gray-400">
                        {project.team.length + 1}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
              <div className="px-6 py-3 bg-gray-50 dark:bg-gray-700/50 flex items-center justify-between">
                <span className="text-xs text-gray-500">
                  {new Date(project.endDate).toLocaleDateString('tr-TR')}
                </span>
                <button className="text-blue-600 hover:text-blue-700 text-sm font-medium flex items-center gap-1">
                  Detaylar <ChevronRight className="w-4 h-4" />
                </button>
              </div>
            </motion.div>
          ))}
        </div>
      )}

      {/* Kanban View */}
      {viewMode === 'kanban' && (
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          {['planning', 'active', 'completed', 'paused'].map((status) => (
            <div key={status} className="bg-gray-100 dark:bg-gray-800 rounded-xl p-4">
              <h3 className="font-semibold mb-4 capitalize">
                {status === 'planning' ? 'Planlama' :
                 status === 'active' ? 'Aktif' :
                 status === 'completed' ? 'Tamamlandı' : 'Durduruldu'}
              </h3>
              <div className="space-y-3">
                {projects.filter(p => p.status === status).map(project => (
                  <div key={project.id} className="bg-white dark:bg-gray-700 rounded-lg p-3 shadow">
                    <h4 className="font-medium text-sm">{project.name}</h4>
                    <div className="mt-2 flex items-center justify-between">
                      <div className="w-20 bg-gray-200 rounded-full h-1.5">
                        <div className="bg-blue-600 h-1.5 rounded-full" style={{ width: `${project.progress}%` }} />
                      </div>
                      <span className="text-xs text-gray-500">{project.progress}%</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Charts Section */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold mb-4">Proje Durumları</h3>
          <ResponsiveContainer width="100%" height={200}>
            <PieChart>
              <Pie
                data={chartData}
                cx="50%"
                cy="50%"
                innerRadius={60}
                outerRadius={80}
                paddingAngle={5}
                dataKey="value"
              >
                {chartData.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
        </div>

        <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold mb-4">Bütçe Kullanımı</h3>
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={projects.map(p => ({ name: p.name.split(' ')[0], budget: p.budget, spent: p.spent }))}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="name" />
              <YAxis />
              <Tooltip />
              <Bar dataKey="budget" fill="#3b82f6" />
              <Bar dataKey="spent" fill="#10b981" />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>
    </div>
  )
}
EOF

echo "✅ Proje Yönetimi tamamlandı!"
echo "📌 Kurban modülüne geçiliyor..."