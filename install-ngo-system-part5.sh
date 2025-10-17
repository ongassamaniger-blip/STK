#!/bin/bash
# install-ngo-system-part5.sh - Projects & Facilities Management
# Date: 2025-10-17 11:23:51
# User: ongassamaniger-blip

echo -e "${CYAN}════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}[9/10] Projects ve Facilities Management oluşturuluyor...${NC}"
echo -e "${CYAN}════════════════════════════════════════════════${NC}"

# =====================================================
# PROJECTS MANAGEMENT PAGE
# =====================================================

echo -e "${BLUE}📂 Projects Management sayfası oluşturuluyor...${NC}"

cat > 'app/(main)/projects/page.tsx' << 'ENDOFPROJECTSPAGE'
import ProjectsManagement from '@/components/projects/ProjectsManagement'

export const metadata = {
  title: 'Proje Yönetimi - NGO Management System',
  description: 'Proje planlama ve takibi'
}

export default function ProjectsPage() {
  return <ProjectsManagement />
}
ENDOFPROJECTSPAGE

# Projects Management Component
cat > 'components/projects/ProjectsManagement.tsx' << 'ENDOFPROJECTS'
'use client'

import React, { useState, useEffect } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import {
  Plus, Search, Filter, Download, Upload, FolderOpen, Target, Users, Calendar,
  MapPin, DollarSign, Clock, CheckCircle, AlertCircle, XCircle, TrendingUp,
  BarChart3, PieChart, FileText, Edit, Trash2, Eye, MoreVertical, Share2,
  Play, Pause, Archive, ArrowRight, ChevronRight, ChevronDown, Activity,
  Briefcase, Award, Flag, Settings, Link2, Image, Video, File, MessageSquare,
  Star, Heart, ThumbsUp, AlertTriangle, Info, RefreshCw, Copy, Mail, Printer
} from 'lucide-react'
import { toast } from 'react-hot-toast'
import {
  LineChart, Line, AreaChart, Area, BarChart, Bar,
  PieChart as RePieChart, Pie, Cell, XAxis, YAxis,
  CartesianGrid, Tooltip, ResponsiveContainer, Legend,
  RadialBarChart, RadialBar
} from 'recharts'

// Types
interface ProjectMilestone {
  id: string
  title: string
  description: string
  dueDate: string
  status: 'pending' | 'in-progress' | 'completed' | 'delayed'
  completedDate?: string
  progress: number
  assignedTo?: string
  dependencies?: string[]
}

interface ProjectBudget {
  total: number
  spent: number
  allocated: {
    personnel: number
    materials: number
    operations: number
    other: number
  }
  currency: string
}

interface ProjectDocument {
  id: string
  name: string
  type: string
  size: string
  uploadedBy: string
  uploadedAt: string
  url: string
}

interface ProjectActivity {
  id: string
  type: 'comment' | 'update' | 'milestone' | 'document' | 'budget'
  description: string
  user: string
  timestamp: string
  details?: any
}

interface Project {
  id: string
  code: string
  name: string
  description: string
  category: string
  status: 'planning' | 'active' | 'completed' | 'paused' | 'cancelled'
  priority: 'low' | 'medium' | 'high' | 'critical'
  startDate: string
  endDate: string
  location: string
  facility?: string
  manager: string
  team: string[]
  beneficiaries: {
    target: number
    reached: number
    type: string
  }
  budget: ProjectBudget
  progress: number
  milestones: ProjectMilestone[]
  documents: ProjectDocument[]
  activities: ProjectActivity[]
  tags: string[]
  impact: {
    social: number
    economic: number
    environmental: number
  }
  risks: Array<{
    id: string
    title: string
    level: 'low' | 'medium' | 'high'
    mitigation: string
  }>
  createdAt: string
  updatedAt: string
}

// Sample data
const initialProjects: Project[] = [
  {
    id: '1',
    code: 'PRJ-2025-001',
    name: 'Su Kuyusu Projesi - Nijer',
    description: '10 köyde temiz su erişimi sağlama projesi. Her köyde 1 adet derin su kuyusu açılacak ve su pompa sistemleri kurulacak.',
    category: 'Su ve Sanitasyon',
    status: 'active',
    priority: 'high',
    startDate: '2025-01-15',
    endDate: '2025-12-31',
    location: 'Nijer - Niamey Bölgesi',
    facility: 'Nijer Tesisi',
    manager: 'Ahmet Yılmaz',
    team: ['Mehmet Öz', 'Fatma Kaya', 'Ali Demir'],
    beneficiaries: {
      target: 5000,
      reached: 3250,
      type: 'Köy Sakinleri'
    },
    budget: {
      total: 150000,
      spent: 97500,
      allocated: {
        personnel: 30000,
        materials: 80000,
        operations: 30000,
        other: 10000
      },
      currency: 'TRY'
    },
    progress: 65,
    milestones: [
      {
        id: 'm1',
        title: 'Saha Araştırması',
        description: 'Köylerin belirlenmesi ve zemin etüdü',
        dueDate: '2025-02-28',
        status: 'completed',
        completedDate: '2025-02-25',
        progress: 100,
        assignedTo: 'Mehmet Öz'
      },
      {
        id: 'm2',
        title: 'Kuyu Kazma İşlemleri',
        description: '10 kuyunun kazılması',
        dueDate: '2025-06-30',
        status: 'in-progress',
        progress: 70,
        assignedTo: 'Ali Demir'
      },
      {
        id: 'm3',
        title: 'Pompa Sistemleri Kurulumu',
        description: 'Su pompa sistemlerinin montajı',
        dueDate: '2025-09-30',
        status: 'pending',
        progress: 0,
        dependencies: ['m2']
      },
      {
        id: 'm4',
        title: 'Test ve Devir Teslim',
        description: 'Sistemlerin testi ve köy yönetimine devri',
        dueDate: '2025-12-15',
        status: 'pending',
        progress: 0,
        dependencies: ['m3']
      }
    ],
    documents: [
      {
        id: 'd1',
        name: 'Proje Planı.pdf',
        type: 'pdf',
        size: '2.4 MB',
        uploadedBy: 'Ahmet Yılmaz',
        uploadedAt: '2025-01-10',
        url: '/documents/project-plan.pdf'
      },
      {
        id: 'd2',
        name: 'Bütçe Detayları.xlsx',
        type: 'excel',
        size: '458 KB',
        uploadedBy: 'Fatma Kaya',
        uploadedAt: '2025-01-12',
        url: '/documents/budget.xlsx'
      }
    ],
    activities: [
      {
        id: 'a1',
        type: 'milestone',
        description: 'Saha Araştırması tamamlandı',
        user: 'Mehmet Öz',
        timestamp: '2025-02-25 14:30'
      },
      {
        id: 'a2',
        type: 'budget',
        description: '25,000 TRY malzeme alımı yapıldı',
        user: 'Fatma Kaya',
        timestamp: '2025-03-10 10:15'
      },
      {
        id: 'a3',
        type: 'update',
        description: 'Proje %65 tamamlandı',
        user: 'Ahmet Yılmaz',
        timestamp: '2025-10-15 16:45'
      }
    ],
    tags: ['su', 'kırsal-kalkınma', 'altyapı'],
    impact: {
      social: 85,
      economic: 60,
      environmental: 75
    },
    risks: [
      {
        id: 'r1',
        title: 'Mevsimsel yağışlar',
        level: 'medium',
        mitigation: 'Yedek çalışma planı hazırlandı'
      },
      {
        id: 'r2',
        title: 'Malzeme temini gecikmesi',
        level: 'low',
        mitigation: 'Alternatif tedarikçiler belirlendi'
      }
    ],
    createdAt: '2025-01-05 09:00',
    updatedAt: '2025-10-17 11:00'
  },
  {
    id: '2',
    code: 'PRJ-2025-002',
    name: 'Eğitim Merkezi İnşaatı',
    description: '3 katlı eğitim merkezi ve kütüphane inşaatı. 500 öğrenci kapasiteli, modern donanımlı eğitim tesisi.',
    category: 'Eğitim',
    status: 'active',
    priority: 'medium',
    startDate: '2025-03-01',
    endDate: '2026-02-28',
    location: 'Senegal - Dakar',
    facility: 'Senegal Tesisi',
    manager: 'Fatma Kaya',
    team: ['Ayşe Yılmaz', 'Mustafa Ak'],
    beneficiaries: {
      target: 1200,
      reached: 0,
      type: 'Öğrenciler'
    },
    budget: {
      total: 250000,
      spent: 112500,
      allocated: {
        personnel: 50000,
        materials: 150000,
        operations: 40000,
        other: 10000
      },
      currency: 'TRY'
    },
    progress: 45,
    milestones: [
      {
        id: 'm1',
        title: 'Arazi Temini',
        description: 'Eğitim merkezi için arazi alımı',
        dueDate: '2025-03-31',
        status: 'completed',
        completedDate: '2025-03-28',
        progress: 100
      },
      {
        id: 'm2',
        title: 'İnşaat Ruhsatları',
        description: 'Gerekli izinlerin alınması',
        dueDate: '2025-04-30',
        status: 'completed',
        completedDate: '2025-04-25',
        progress: 100
      },
      {
        id: 'm3',
        title: 'İnşaat Aşaması',
        description: 'Bina inşaatının tamamlanması',
        dueDate: '2025-12-31',
        status: 'in-progress',
        progress: 40
      }
    ],
    documents: [],
    activities: [],
    tags: ['eğitim', 'altyapı', 'kalkınma'],
    impact: {
      social: 90,
      economic: 70,
      environmental: 50
    },
    risks: [],
    createdAt: '2025-02-20 10:30',
    updatedAt: '2025-10-16 15:20'
  }
]

const projectCategories = [
  { name: 'Su ve Sanitasyon', color: '#3b82f6', icon: '💧' },
  { name: 'Eğitim', color: '#10b981', icon: '📚' },
  { name: 'Sağlık', color: '#ef4444', icon: '🏥' },
  { name: 'İnsani Yardım', color: '#f59e0b', icon: '🤝' },
  { name: 'Kalkınma', color: '#8b5cf6', icon: '🏗️' },
  { name: 'Tarım', color: '#84cc16', icon: '🌾' }
]

export default function ProjectsManagement() {
  const [projects, setProjects] = useState<Project[]>(initialProjects)
  const [selectedProject, setSelectedProject] = useState<Project | null>(null)
  const [activeTab, setActiveTab] = useState<'all' | 'active' | 'completed' | 'planning'>('all')
  const [viewMode, setViewMode] = useState<'grid' | 'list' | 'kanban'>('grid')
  const [showNewProject, setShowNewProject] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedCategory, setSelectedCategory] = useState('')
  const [sortBy, setSortBy] = useState<'name' | 'date' | 'progress' | 'priority'>('date')
  const [showFilters, setShowFilters] = useState(false)
  const [loading, setLoading] = useState(false)

  // Filter projects
  const filteredProjects = projects.filter(project => {
    const matchesTab = activeTab === 'all' || 
      (activeTab === 'active' && project.status === 'active') ||
      (activeTab === 'completed' && project.status === 'completed') ||
      (activeTab === 'planning' && project.status === 'planning')
    
    const matchesSearch = searchTerm === '' ||
      project.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      project.code.toLowerCase().includes(searchTerm.toLowerCase()) ||
      project.description.toLowerCase().includes(searchTerm.toLowerCase())
    
    const matchesCategory = selectedCategory === '' || project.category === selectedCategory

    return matchesTab && matchesSearch && matchesCategory
  })

  // Sort projects
  const sortedProjects = [...filteredProjects].sort((a, b) => {
    switch (sortBy) {
      case 'name':
        return a.name.localeCompare(b.name)
      case 'date':
        return new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime()
      case 'progress':
        return b.progress - a.progress
      case 'priority':
        const priorityOrder = { critical: 0, high: 1, medium: 2, low: 3 }
        return priorityOrder[a.priority] - priorityOrder[b.priority]
      default:
        return 0
    }
  })

  // Calculate statistics
  const stats = {
    total: projects.length,
    active: projects.filter(p => p.status === 'active').length,
    completed: projects.filter(p => p.status === 'completed').length,
    totalBudget: projects.reduce((sum, p) => sum + p.budget.total, 0),
    totalSpent: projects.reduce((sum, p) => sum + p.budget.spent, 0),
    totalBeneficiaries: projects.reduce((sum, p) => sum + p.beneficiaries.target, 0),
    reachedBeneficiaries: projects.reduce((sum, p) => sum + p.beneficiaries.reached, 0)
  }

  const getPriorityBadge = (priority: Project['priority']) => {
    const badges = {
      low: { bg: 'bg-gray-500/10', text: 'text-gray-600', label: 'Düşük' },
      medium: { bg: 'bg-yellow-500/10', text: 'text-yellow-600', label: 'Orta' },
      high: { bg: 'bg-orange-500/10', text: 'text-orange-600', label: 'Yüksek' },
      critical: { bg: 'bg-red-500/10', text: 'text-red-600', label: 'Kritik' }
    }
    const badge = badges[priority]
    return (
      <span className={`px-2 py-1 text-xs rounded-full ${badge.bg} ${badge.text} font-medium`}>
        {badge.label}
      </span>
    )
  }

  const getStatusBadge = (status: Project['status']) => {
    const badges = {
      planning: { bg: 'bg-blue-500/10', text: 'text-blue-600', label: 'Planlama', icon: Clock },
      active: { bg: 'bg-green-500/10', text: 'text-green-600', label: 'Aktif', icon: Play },
      completed: { bg: 'bg-purple-500/10', text: 'text-purple-600', label: 'Tamamlandı', icon: CheckCircle },
      paused: { bg: 'bg-yellow-500/10', text: 'text-yellow-600', label: 'Durduruldu', icon: Pause },
      cancelled: { bg: 'bg-red-500/10', text: 'text-red-600', label: 'İptal', icon: XCircle }
    }
    const badge = badges[status]
    const Icon = badge.icon
    return (
      <span className={`inline-flex items-center gap-1 px-2 py-1 text-xs rounded-full ${badge.bg} ${badge.text} font-medium`}>
        <Icon className="w-3 h-3" />
        {badge.label}
      </span>
    )
  }

  const handleDeleteProject = (id: string) => {
    if (confirm('Bu projeyi silmek istediğinizden emin misiniz?')) {
      setProjects(prev => prev.filter(p => p.id !== id))
      toast.success('Proje silindi')
    }
  }

  const handleExport = (format: 'csv' | 'excel' | 'pdf') => {
    toast.success(`Projeler ${format.toUpperCase()} olarak dışa aktarıldı`)
  }

  // Project Card Component
  const ProjectCard = ({ project }: { project: Project }) => {
    const categoryInfo = projectCategories.find(c => c.name === project.category)
    const progressColor = project.progress >= 75 ? 'bg-green-500' : 
                         project.progress >= 50 ? 'bg-yellow-500' : 
                         project.progress >= 25 ? 'bg-orange-500' : 'bg-red-500'

    return (
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        whileHover={{ y: -4 }}
        className="bg-card rounded-xl border p-6 hover:shadow-lg transition-all cursor-pointer"
        onClick={() => setSelectedProject(project)}
      >
        {/* Header */}
        <div className="flex items-start justify-between mb-4">
          <div className="flex items-center gap-3">
            <div 
              className="w-10 h-10 rounded-lg flex items-center justify-center text-xl"
              style={{ backgroundColor: `${categoryInfo?.color}20` }}
            >
              {categoryInfo?.icon}
            </div>
            <div>
              <p className="text-xs text-muted-foreground font-mono">{project.code}</p>
              <h3 className="font-semibold">{project.name}</h3>
            </div>
          </div>
          <button
            onClick={(e) => {
              e.stopPropagation()
              // Show project menu
            }}
            className="p-1 hover:bg-accent rounded-lg transition-colors"
          >
            <MoreVertical className="w-4 h-4" />
          </button>
        </div>

        {/* Description */}
        <p className="text-sm text-muted-foreground line-clamp-2 mb-4">
          {project.description}
        </p>

        {/* Location & Manager */}
        <div className="flex items-center gap-4 mb-4 text-sm">
          <div className="flex items-center gap-1 text-muted-foreground">
            <MapPin className="w-4 h-4" />
            {project.location}
          </div>
          <div className="flex items-center gap-1 text-muted-foreground">
            <Users className="w-4 h-4" />
            {project.manager}
          </div>
        </div>

        {/* Progress */}
        <div className="mb-4">
          <div className="flex items-center justify-between text-sm mb-2">
            <span className="text-muted-foreground">İlerleme</span>
            <span className="font-medium">{project.progress}%</span>
          </div>
          <div className="w-full bg-accent rounded-full h-2 overflow-hidden">
            <div
              className={`h-full transition-all duration-500 ${progressColor}`}
              style={{ width: `${project.progress}%` }}
            />
          </div>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-2 gap-4 mb-4">
          <div>
            <p className="text-xs text-muted-foreground">Bütçe Kullanımı</p>
            <p className="text-sm font-medium">
              ₺{project.budget.spent.toLocaleString()} / ₺{project.budget.total.toLocaleString()}
            </p>
          </div>
          <div>
            <p className="text-xs text-muted-foreground">Faydalanıcı</p>
            <p className="text-sm font-medium">
              {project.beneficiaries.reached.toLocaleString()} / {project.beneficiaries.target.toLocaleString()}
            </p>
          </div>
          <div>
            <p className="text-xs text-muted-foreground">Başlangıç</p>
            <p className="text-sm font-medium">
              {new Date(project.startDate).toLocaleDateString('tr-TR')}
            </p>
          </div>
          <div>
            <p className="text-xs text-muted-foreground">Bitiş</p>
            <p className="text-sm font-medium">
              {new Date(project.endDate).toLocaleDateString('tr-TR')}
            </p>
          </div>
        </div>

        {/* Milestones Progress */}
        <div className="mb-4">
          <div className="flex items-center justify-between text-sm mb-2">
            <span className="text-muted-foreground">Kilometre Taşları</span>
            <span className="font-medium">
              {project.milestones.filter(m => m.status === 'completed').length}/{project.milestones.length}
            </span>
          </div>
          <div className="flex gap-1">
            {project.milestones.map(milestone => (
              <div
                key={milestone.id}
                className={`flex-1 h-1 rounded-full ${
                  milestone.status === 'completed' ? 'bg-green-500' :
                  milestone.status === 'in-progress' ? 'bg-yellow-500' :
                  'bg-gray-300'
                }`}
              />
            ))}
          </div>
        </div>

        {/* Footer */}
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            {getStatusBadge(project.status)}
            {getPriorityBadge(project.priority)}
          </div>
          <div className="flex items-center gap-1">
            <button
              onClick={(e) => {
                e.stopPropagation()
                // Edit project
              }}
              className="p-1.5 hover:bg-accent rounded-lg transition-colors"
            >
              <Edit className="w-4 h-4" />
            </button>
            <button
              onClick={(e) => {
                e.stopPropagation()
                handleDeleteProject(project.id)
              }}
              className="p-1.5 hover:bg-red-500/10 text-red-600 rounded-lg transition-colors"
            >
              <Trash2 className="w-4 h-4" />
            </button>
          </div>
        </div>
      </motion.div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold">Proje Yönetimi</h1>
          <p className="text-muted-foreground mt-1">
            Tüm projeleri planlayın, takip edin ve yönetin
          </p>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={() => setShowNewProject(true)}
            className="px-4 py-2 bg-primary text-primary-foreground rounded-lg text-sm flex items-center gap-2 hover:bg-primary/90 transition-colors"
          >
            <Plus className="w-4 h-4" />
            Yeni Proje
          </button>
          <button
            onClick={() => setLoading(true)}
            className="px-3 py-2 border rounded-lg hover:bg-accent transition-colors"
          >
            <RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />
          </button>
        </div>
      </div>

      {/* Statistics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-card p-4 rounded-xl border"
        >
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-muted-foreground">Toplam Proje</p>
              <p className="text-2xl font-bold mt-1">{stats.total}</p>
              <p className="text-xs text-green-600 mt-1">
                {stats.active} aktif
              </p>
            </div>
            <div className="p-3 bg-primary/10 rounded-lg">
              <FolderOpen className="w-6 h-6 text-primary" />
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
              <p className="text-sm text-muted-foreground">Toplam Bütçe</p>
              <p className="text-2xl font-bold mt-1">₺{stats.totalBudget.toLocaleString()}</p>
              <p className="text-xs text-muted-foreground mt-1">
                ₺{stats.totalSpent.toLocaleString()} harcanmış
              </p>
            </div>
            <div className="p-3 bg-green-500/10 rounded-lg">
              <DollarSign className="w-6 h-6 text-green-500" />
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
              <p className="text-sm text-muted-foreground">Faydalanıcılar</p>
              <p className="text-2xl font-bold mt-1">{stats.totalBeneficiaries.toLocaleString()}</p>
              <p className="text-xs text-muted-foreground mt-1">
                {stats.reachedBeneficiaries.toLocaleString()} ulaşılan
              </p>
            </div>
            <div className="p-3 bg-blue-500/10 rounded-lg">
              <Users className="w-6 h-6 text-blue-500" />
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
              <p className="text-sm text-muted-foreground">Tamamlanma</p>
              <p className="text-2xl font-bold mt-1">{stats.completed}</p>
              <p className="text-xs text-purple-600 mt-1">
                %{Math.round((stats.completed / stats.total) * 100)} başarı
              </p>
            </div>
            <div className="p-3 bg-purple-500/10 rounded-lg">
              <Award className="w-6 h-6 text-purple-500" />
            </div>
          </div>
        </motion.div>
      </div>

      {/* Filters and Tabs */}
      <div className="bg-card rounded-xl border p-4">
        <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
          {/* Tabs */}
          <div className="flex items-center gap-2 overflow-x-auto">
            <button
              onClick={() => setActiveTab('all')}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors whitespace-nowrap ${
                activeTab === 'all' ? 'bg-primary text-primary-foreground' : 'hover:bg-accent'
              }`}
            >
              Tümü ({projects.length})
            </button>
            <button
              onClick={() => setActiveTab('active')}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors whitespace-nowrap ${
                activeTab === 'active' ? 'bg-primary text-primary-foreground' : 'hover:bg-accent'
              }`}
            >
              Aktif ({projects.filter(p => p.status === 'active').length})
            </button>
            <button
              onClick={() => setActiveTab('completed')}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors whitespace-nowrap ${
                activeTab === 'completed' ? 'bg-primary text-primary-foreground' : 'hover:bg-accent'
              }`}
            >
              Tamamlanan ({projects.filter(p => p.status === 'completed').length})
            </button>
            <button
              onClick={() => setActiveTab('planning')}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors whitespace-nowrap ${
                activeTab === 'planning' ? 'bg-primary text-primary-foreground' : 'hover:bg-accent'
              }`}
            >
              Planlama ({projects.filter(p => p.status === 'planning').length})
            </button>
          </div>

          {/* Controls */}
          <div className="flex items-center gap-2">
            {/* Search */}
            <div className="relative">
              <Search className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
              <input
                type="text"
                placeholder="Proje ara..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="pl-9 pr-4 py-2 bg-background border rounded-lg text-sm w-64"
              />
            </div>

            {/* Category Filter */}
            <select
              value={selectedCategory}
              onChange={(e) => setSelectedCategory(e.target.value)}
              className="px-3 py-2 bg-background border rounded-lg text-sm"
            >
              <option value="">Tüm Kategoriler</option>
              {projectCategories.map(cat => (
                <option key={cat.name} value={cat.name}>{cat.name}</option>
              ))}
            </select>

            {/* Sort */}
            <select
              value={sortBy}
              onChange={(e) => setSortBy(e.target.value as any)}
              className="px-3 py-2 bg-background border rounded-lg text-sm"
            >
              <option value="date">Tarihe Göre</option>
              <option value="name">İsme Göre</option>
              <option value="progress">İlerlemeye Göre</option>
              <option value="priority">Önceliğe Göre</option>
            </select>

            {/* View Mode */}
            <div className="flex items-center bg-accent rounded-lg p-1">
              <button
                onClick={() => setViewMode('grid')}
                className={`p-1.5 rounded ${viewMode === 'grid' ? 'bg-background shadow-sm' : ''}`}
              >
                <BarChart3 className="w-4 h-4" />
              </button>
              <button
                onClick={() => setViewMode('list')}
                className={`p-1.5 rounded ${viewMode === 'list' ? 'bg-background shadow-sm' : ''}`}
              >
                <FileText className="w-4 h-4" />
              </button>
              <button
                onClick={() => setViewMode('kanban')}
                className={`p-1.5 rounded ${viewMode === 'kanban' ? 'bg-background shadow-sm' : ''}`}
              >
                <PieChart className="w-4 h-4" />
              </button>
            </div>

            {/* Export */}
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
      </div>

      {/* Projects Grid */}
      {viewMode === 'grid' && (
        <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
          {sortedProjects.map(project => (
            <ProjectCard key={project.id} project={project} />
          ))}
        </div>
      )}

      {/* Empty State */}
      {sortedProjects.length === 0 && (
        <div className="text-center py-12 bg-card rounded-xl border">
          <FolderOpen className="w-12 h-12 mx-auto text-muted-foreground mb-4" />
          <h3 className="text-lg font-semibold mb-2">Proje bulunamadı</h3>
          <p className="text-muted-foreground mb-4">
            Arama kriterlerinize uygun proje bulunmamaktadır
          </p>
          <button
            onClick={() => setShowNewProject(true)}
            className="px-4 py-2 bg-primary text-primary-foreground rounded-lg text-sm"
          >
            Yeni Proje Oluştur
          </button>
        </div>
      )}
    </div>
  )
}
ENDOFPROJECTS

echo -e "${GREEN}✅ Projects Management component oluşturuldu${NC}"

# =====================================================
# FACILITIES MANAGEMENT
# =====================================================

echo -e "${BLUE}🏢 Facilities Management sayfası oluşturuluyor...${NC}"

cat > 'app/(main)/facilities/page.tsx' << 'ENDOFFACILITIESPAGE'
import FacilitiesManagement from '@/components/facilities/FacilitiesManagement'

export const metadata = {
  title: 'Tesis Yönetimi - NGO Management System',
  description: 'Tesis ve şube yönetimi'
}

export default function FacilitiesPage() {
  return <FacilitiesManagement />
}
ENDOFFACILITIESPAGE

echo -e "${GREEN}✅ Facilities sayfası oluşturuldu${NC}"

echo -e "${CYAN}════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}Bölüm 5 tamamlandı. Projects ve Facilities hazır!${NC}"
echo -e "${CYAN}════════════════════════════════════════════════${NC}"