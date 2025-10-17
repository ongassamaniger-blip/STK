#!/bin/bash
# install-ngo-system-part6.sh - Personnel & Sacrifice Management
# Date: 2025-10-17 11:26:39
# User: ongassamaniger-blip

echo -e "${CYAN}════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}[10/10] Personnel ve Sacrifice Management oluşturuluyor...${NC}"
echo -e "${CYAN}════════════════════════════════════════════════${NC}"

# =====================================================
# PERSONNEL MANAGEMENT PAGE
# =====================================================

echo -e "${BLUE}👥 Personnel Management sayfası oluşturuluyor...${NC}"

cat > 'app/(main)/personnel/page.tsx' << 'ENDOFPERSONNELPAGE'
import PersonnelManagement from '@/components/personnel/PersonnelManagement'

export const metadata = {
  title: 'Personel Yönetimi - NGO Management System',
  description: 'Personel ve insan kaynakları yönetimi'
}

export default function PersonnelPage() {
  return <PersonnelManagement />
}
ENDOFPERSONNELPAGE

# Personnel Management Component
cat > 'components/personnel/PersonnelManagement.tsx' << 'ENDOFPERSONNEL'
'use client'

import React, { useState, useEffect } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import {
  Plus, Search, Filter, Download, Upload, Users, UserPlus, User, Mail,
  Phone, MapPin, Calendar, DollarSign, Clock, CheckCircle, XCircle,
  AlertCircle, Edit, Trash2, Eye, MoreVertical, Award, Briefcase,
  Building2, Heart, Star, TrendingUp, TrendingDown, Activity, Shield,
  FileText, CreditCard, Gift, Settings, ChevronRight, RefreshCw,
  Printer, Share2, Copy, MessageSquare, Video, PhoneCall, Globe,
  Hash, Flag, Camera, Link2, Zap, Target, BarChart3
} from 'lucide-react'
import { toast } from 'react-hot-toast'

// Types
interface PersonnelDocument {
  id: string
  type: 'cv' | 'contract' | 'id' | 'diploma' | 'certificate' | 'other'
  name: string
  url: string
  uploadedAt: string
}

interface PersonnelLeave {
  id: string
  type: 'annual' | 'sick' | 'maternity' | 'unpaid' | 'other'
  startDate: string
  endDate: string
  days: number
  status: 'pending' | 'approved' | 'rejected'
  reason: string
  approvedBy?: string
}

interface PersonnelPayment {
  id: string
  month: string
  year: number
  baseSalary: number
  bonus: number
  deductions: number
  netSalary: number
  paidDate?: string
  status: 'pending' | 'paid'
}

interface PersonnelPerformance {
  month: string
  score: number
  tasks: number
  completed: number
  rating: 1 | 2 | 3 | 4 | 5
}

interface Personnel {
  id: string
  employeeNo: string
  firstName: string
  lastName: string
  email: string
  phone: string
  alternativePhone?: string
  position: string
  department: string
  facility: string
  manager?: string
  status: 'active' | 'inactive' | 'leave' | 'terminated'
  type: 'full-time' | 'part-time' | 'contract' | 'volunteer'
  startDate: string
  endDate?: string
  birthDate: string
  gender: 'male' | 'female'
  maritalStatus: 'single' | 'married' | 'divorced' | 'widowed'
  nationality: string
  idNumber: string
  address: {
    street: string
    city: string
    state: string
    country: string
    postalCode: string
  }
  emergencyContact: {
    name: string
    relation: string
    phone: string
  }
  education: {
    level: string
    field: string
    school: string
    graduationYear: number
  }
  salary: {
    base: number
    currency: string
    paymentMethod: 'bank' | 'cash'
    bankAccount?: string
  }
  skills: string[]
  languages: Array<{
    language: string
    level: 'native' | 'fluent' | 'intermediate' | 'basic'
  }>
  documents: PersonnelDocument[]
  leaves: PersonnelLeave[]
  payments: PersonnelPayment[]
  performance: PersonnelPerformance[]
  avatar?: string
  notes?: string
  createdAt: string
  updatedAt: string
}

// Sample data
const initialPersonnel: Personnel[] = [
  {
    id: '1',
    employeeNo: 'EMP-001',
    firstName: 'Ahmet',
    lastName: 'Yılmaz',
    email: 'ahmet.yilmaz@ngo.org',
    phone: '+90 555 123 4567',
    position: 'Proje Yöneticisi',
    department: 'Operasyon',
    facility: 'Merkez Ofis',
    status: 'active',
    type: 'full-time',
    startDate: '2020-03-15',
    birthDate: '1985-06-20',
    gender: 'male',
    maritalStatus: 'married',
    nationality: 'TC',
    idNumber: '12345678901',
    address: {
      street: 'Atatürk Cad. No:123',
      city: 'İstanbul',
      state: 'İstanbul',
      country: 'Türkiye',
      postalCode: '34000'
    },
    emergencyContact: {
      name: 'Ayşe Yılmaz',
      relation: 'Eş',
      phone: '+90 555 987 6543'
    },
    education: {
      level: 'Lisans',
      field: 'İşletme',
      school: 'İstanbul Üniversitesi',
      graduationYear: 2007
    },
    salary: {
      base: 25000,
      currency: 'TRY',
      paymentMethod: 'bank',
      bankAccount: 'TR12 0001 0001 1234 5678 9012 34'
    },
    skills: ['Proje Yönetimi', 'Bütçe Planlama', 'Takım Liderliği'],
    languages: [
      { language: 'Türkçe', level: 'native' },
      { language: 'İngilizce', level: 'fluent' },
      { language: 'Arapça', level: 'intermediate' }
    ],
    documents: [],
    leaves: [
      {
        id: 'l1',
        type: 'annual',
        startDate: '2025-08-01',
        endDate: '2025-08-15',
        days: 14,
        status: 'approved',
        reason: 'Yıllık izin',
        approvedBy: 'Admin'
      }
    ],
    payments: [
      {
        id: 'p1',
        month: 'Ekim',
        year: 2025,
        baseSalary: 25000,
        bonus: 2000,
        deductions: 3500,
        netSalary: 23500,
        paidDate: '2025-10-25',
        status: 'paid'
      }
    ],
    performance: [
      { month: 'Ocak', score: 85, tasks: 20, completed: 17, rating: 4 },
      { month: 'Şubat', score: 90, tasks: 18, completed: 17, rating: 5 },
      { month: 'Mart', score: 88, tasks: 22, completed: 19, rating: 4 }
    ],
    createdAt: '2020-03-01',
    updatedAt: '2025-10-17'
  },
  {
    id: '2',
    employeeNo: 'EMP-002',
    firstName: 'Fatma',
    lastName: 'Kaya',
    email: 'fatma.kaya@ngo.org',
    phone: '+90 555 234 5678',
    position: 'Muhasebe Uzmanı',
    department: 'Finans',
    facility: 'Merkez Ofis',
    status: 'active',
    type: 'full-time',
    startDate: '2021-06-01',
    birthDate: '1990-03-15',
    gender: 'female',
    maritalStatus: 'single',
    nationality: 'TC',
    idNumber: '98765432109',
    address: {
      street: 'Cumhuriyet Mah. No:45',
      city: 'İstanbul',
      state: 'İstanbul',
      country: 'Türkiye',
      postalCode: '34100'
    },
    emergencyContact: {
      name: 'Mehmet Kaya',
      relation: 'Baba',
      phone: '+90 555 111 2222'
    },
    education: {
      level: 'Yüksek Lisans',
      field: 'Muhasebe ve Finansman',
      school: 'Marmara Üniversitesi',
      graduationYear: 2014
    },
    salary: {
      base: 20000,
      currency: 'TRY',
      paymentMethod: 'bank'
    },
    skills: ['Muhasebe', 'Finansal Raporlama', 'Bütçe Analizi'],
    languages: [
      { language: 'Türkçe', level: 'native' },
      { language: 'İngilizce', level: 'intermediate' }
    ],
    documents: [],
    leaves: [],
    payments: [],
    performance: [],
    createdAt: '2021-05-20',
    updatedAt: '2025-10-16'
  }
]

const departments = [
  'Yönetim', 'Operasyon', 'Finans', 'İnsan Kaynakları', 
  'Proje', 'Lojistik', 'IT', 'Halkla İlişkiler'
]

const positions = [
  'Genel Müdür', 'Müdür', 'Proje Yöneticisi', 'Uzman',
  'Asistan', 'Koordinatör', 'Muhasebe Uzmanı', 'İK Uzmanı'
]

export default function PersonnelManagement() {
  const [personnel, setPersonnel] = useState<Personnel[]>(initialPersonnel)
  const [selectedPerson, setSelectedPerson] = useState<Personnel | null>(null)
  const [activeTab, setActiveTab] = useState<'all' | 'active' | 'leave' | 'inactive'>('all')
  const [viewMode, setViewMode] = useState<'grid' | 'list'>('list')
  const [showNewPersonnel, setShowNewPersonnel] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedDepartment, setSelectedDepartment] = useState('')
  const [selectedFacility, setSelectedFacility] = useState('')
  const [sortBy, setSortBy] = useState<'name' | 'date' | 'position'>('name')
  const [showFilters, setShowFilters] = useState(false)
  const [loading, setLoading] = useState(false)
  const [showPayrollModal, setShowPayrollModal] = useState(false)
  const [showLeaveModal, setShowLeaveModal] = useState(false)
  const [selectedPersonForAction, setSelectedPersonForAction] = useState<Personnel | null>(null)

  // Filter personnel
  const filteredPersonnel = personnel.filter(person => {
    const matchesTab = activeTab === 'all' || 
      (activeTab === 'active' && person.status === 'active') ||
      (activeTab === 'leave' && person.status === 'leave') ||
      (activeTab === 'inactive' && person.status === 'inactive')
    
    const matchesSearch = searchTerm === '' ||
      person.firstName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      person.lastName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      person.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
      person.employeeNo.toLowerCase().includes(searchTerm.toLowerCase())
    
    const matchesDepartment = selectedDepartment === '' || person.department === selectedDepartment
    const matchesFacility = selectedFacility === '' || person.facility === selectedFacility

    return matchesTab && matchesSearch && matchesDepartment && matchesFacility
  })

  // Sort personnel
  const sortedPersonnel = [...filteredPersonnel].sort((a, b) => {
    switch (sortBy) {
      case 'name':
        return `${a.firstName} ${a.lastName}`.localeCompare(`${b.firstName} ${b.lastName}`)
      case 'date':
        return new Date(b.startDate).getTime() - new Date(a.startDate).getTime()
      case 'position':
        return a.position.localeCompare(b.position)
      default:
        return 0
    }
  })

  // Calculate statistics
  const stats = {
    total: personnel.length,
    active: personnel.filter(p => p.status === 'active').length,
    leave: personnel.filter(p => p.status === 'leave').length,
    totalSalary: personnel.filter(p => p.status === 'active').reduce((sum, p) => sum + p.salary.base, 0),
    avgPerformance: 88,
    departments: [...new Set(personnel.map(p => p.department))].length,
    newThisMonth: 2
  }

  const getStatusBadge = (status: Personnel['status']) => {
    const badges = {
      active: { bg: 'bg-green-500/10', text: 'text-green-600', label: 'Aktif' },
      inactive: { bg: 'bg-gray-500/10', text: 'text-gray-600', label: 'Pasif' },
      leave: { bg: 'bg-yellow-500/10', text: 'text-yellow-600', label: 'İzinde' },
      terminated: { bg: 'bg-red-500/10', text: 'text-red-600', label: 'Ayrıldı' }
    }
    const badge = badges[status]
    return (
      <span className={`px-2 py-1 text-xs rounded-full ${badge.bg} ${badge.text} font-medium`}>
        {badge.label}
      </span>
    )
  }

  const getTypeBadge = (type: Personnel['type']) => {
    const badges = {
      'full-time': { bg: 'bg-blue-500/10', text: 'text-blue-600', label: 'Tam Zamanlı' },
      'part-time': { bg: 'bg-purple-500/10', text: 'text-purple-600', label: 'Yarı Zamanlı' },
      'contract': { bg: 'bg-orange-500/10', text: 'text-orange-600', label: 'Sözleşmeli' },
      'volunteer': { bg: 'bg-pink-500/10', text: 'text-pink-600', label: 'Gönüllü' }
    }
    const badge = badges[type]
    return (
      <span className={`px-2 py-1 text-xs rounded-full ${badge.bg} ${badge.text} font-medium`}>
        {badge.label}
      </span>
    )
  }

  const handleDeletePersonnel = (id: string) => {
    if (confirm('Bu personeli silmek istediğinizden emin misiniz?')) {
      setPersonnel(prev => prev.filter(p => p.id !== id))
      toast.success('Personel silindi')
    }
  }

  const handleExport = (format: 'csv' | 'excel' | 'pdf') => {
    toast.success(`Personel listesi ${format.toUpperCase()} olarak dışa aktarıldı`)
  }

  const calculateAge = (birthDate: string) => {
    const diff = Date.now() - new Date(birthDate).getTime()
    return Math.floor(diff / (1000 * 60 * 60 * 24 * 365.25))
  }

  const calculateWorkYears = (startDate: string) => {
    const diff = Date.now() - new Date(startDate).getTime()
    const years = Math.floor(diff / (1000 * 60 * 60 * 24 * 365.25))
    const months = Math.floor((diff % (1000 * 60 * 60 * 24 * 365.25)) / (1000 * 60 * 60 * 24 * 30.44))
    return `${years} yıl ${months} ay`
  }

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold">Personel Yönetimi</h1>
          <p className="text-muted-foreground mt-1">
            Tüm personel bilgilerini yönetin ve takip edin
          </p>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={() => setShowPayrollModal(true)}
            className="px-4 py-2 bg-green-500 text-white rounded-lg text-sm flex items-center gap-2 hover:bg-green-600"
          >
            <DollarSign className="w-4 h-4" />
            Maaş Ödemeleri
          </button>
          <button
            onClick={() => setShowNewPersonnel(true)}
            className="px-4 py-2 bg-primary text-primary-foreground rounded-lg text-sm flex items-center gap-2 hover:bg-primary/90"
          >
            <UserPlus className="w-4 h-4" />
            Yeni Personel
          </button>
          <button
            onClick={() => setLoading(true)}
            className="px-3 py-2 border rounded-lg hover:bg-accent"
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
              <p className="text-sm text-muted-foreground">Toplam Personel</p>
              <p className="text-2xl font-bold mt-1">{stats.total}</p>
              <p className="text-xs text-green-600 mt-1">
                +{stats.newThisMonth} bu ay
              </p>
            </div>
            <div className="p-3 bg-primary/10 rounded-lg">
              <Users className="w-6 h-6 text-primary" />
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
              <p className="text-sm text-muted-foreground">Aktif Personel</p>
              <p className="text-2xl font-bold mt-1">{stats.active}</p>
              <p className="text-xs text-muted-foreground mt-1">
                {stats.leave} izinde
              </p>
            </div>
            <div className="p-3 bg-green-500/10 rounded-lg">
              <CheckCircle className="w-6 h-6 text-green-500" />
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
              <p className="text-sm text-muted-foreground">Aylık Maaş</p>
              <p className="text-2xl font-bold mt-1">₺{stats.totalSalary.toLocaleString()}</p>
              <p className="text-xs text-muted-foreground mt-1">
                Toplam bordro
              </p>
            </div>
            <div className="p-3 bg-blue-500/10 rounded-lg">
              <DollarSign className="w-6 h-6 text-blue-500" />
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
              <p className="text-sm text-muted-foreground">Ortalama Performans</p>
              <p className="text-2xl font-bold mt-1">%{stats.avgPerformance}</p>
              <p className="text-xs text-green-600 mt-1">
                <TrendingUp className="w-3 h-3 inline" /> +5% artış
              </p>
            </div>
            <div className="p-3 bg-purple-500/10 rounded-lg">
              <Award className="w-6 h-6 text-purple-500" />
            </div>
          </div>
        </motion.div>
      </div>

      {/* Filters and Controls */}
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
              Tümü ({personnel.length})
            </button>
            <button
              onClick={() => setActiveTab('active')}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors whitespace-nowrap ${
                activeTab === 'active' ? 'bg-primary text-primary-foreground' : 'hover:bg-accent'
              }`}
            >
              Aktif ({personnel.filter(p => p.status === 'active').length})
            </button>
            <button
              onClick={() => setActiveTab('leave')}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors whitespace-nowrap ${
                activeTab === 'leave' ? 'bg-primary text-primary-foreground' : 'hover:bg-accent'
              }`}
            >
              İzinde ({personnel.filter(p => p.status === 'leave').length})
            </button>
            <button
              onClick={() => setActiveTab('inactive')}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors whitespace-nowrap ${
                activeTab === 'inactive' ? 'bg-primary text-primary-foreground' : 'hover:bg-accent'
              }`}
            >
              Pasif ({personnel.filter(p => p.status === 'inactive').length})
            </button>
          </div>

          {/* Controls */}
          <div className="flex items-center gap-2">
            <div className="relative">
              <Search className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
              <input
                type="text"
                placeholder="Personel ara..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="pl-9 pr-4 py-2 bg-background border rounded-lg text-sm w-64"
              />
            </div>
            <select
              value={selectedDepartment}
              onChange={(e) => setSelectedDepartment(e.target.value)}
              className="px-3 py-2 bg-background border rounded-lg text-sm"
            >
              <option value="">Tüm Departmanlar</option>
              {departments.map(dept => (
                <option key={dept} value={dept}>{dept}</option>
              ))}
            </select>
            <button
              onClick={() => setShowFilters(!showFilters)}
              className="px-3 py-2 border rounded-lg hover:bg-accent"
            >
              <Filter className="w-4 h-4" />
            </button>
            <div className="relative group">
              <button className="px-3 py-2 border rounded-lg hover:bg-accent">
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

      {/* Personnel Table */}
      <div className="bg-card rounded-xl border overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-muted/50">
              <tr>
                <th className="text-left p-4 text-sm font-medium">Personel</th>
                <th className="text-left p-4 text-sm font-medium">Pozisyon</th>
                <th className="text-left p-4 text-sm font-medium">Departman</th>
                <th className="text-left p-4 text-sm font-medium">Tesis</th>
                <th className="text-left p-4 text-sm font-medium">Başlangıç</th>
                <th className="text-left p-4 text-sm font-medium">Maaş</th>
                <th className="text-left p-4 text-sm font-medium">Durum</th>
                <th className="text-left p-4 text-sm font-medium">İşlemler</th>
              </tr>
            </thead>
            <tbody>
              {sortedPersonnel.map((person, index) => (
                <motion.tr
                  key={person.id}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: index * 0.05 }}
                  className="border-b hover:bg-muted/30 transition-colors"
                >
                  <td className="p-4">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 bg-primary/10 rounded-full flex items-center justify-center">
                        <span className="text-sm font-medium">
                          {person.firstName[0]}{person.lastName[0]}
                        </span>
                      </div>
                      <div>
                        <p className="font-medium">{person.firstName} {person.lastName}</p>
                        <p className="text-xs text-muted-foreground">{person.employeeNo}</p>
                      </div>
                    </div>
                  </td>
                  <td className="p-4">
                    <div>
                      <p className="text-sm">{person.position}</p>
                      {getTypeBadge(person.type)}
                    </div>
                  </td>
                  <td className="p-4 text-sm">{person.department}</td>
                  <td className="p-4 text-sm">{person.facility}</td>
                  <td className="p-4">
                    <p className="text-sm">{new Date(person.startDate).toLocaleDateString('tr-TR')}</p>
                    <p className="text-xs text-muted-foreground">{calculateWorkYears(person.startDate)}</p>
                  </td>
                  <td className="p-4">
                    <p className="text-sm font-medium">₺{person.salary.base.toLocaleString()}</p>
                    <p className="text-xs text-muted-foreground">{person.salary.paymentMethod === 'bank' ? 'Banka' : 'Nakit'}</p>
                  </td>
                  <td className="p-4">
                    {getStatusBadge(person.status)}
                  </td>
                  <td className="p-4">
                    <div className="flex items-center gap-1">
                      <button
                        onClick={() => setSelectedPerson(person)}
                        className="p-1 hover:bg-accent rounded-lg"
                      >
                        <Eye className="w-4 h-4" />
                      </button>
                      <button className="p-1 hover:bg-accent rounded-lg">
                        <Edit className="w-4 h-4" />
                      </button>
                      <button
                        onClick={() => handleDeletePersonnel(person.id)}
                        className="p-1 hover:bg-red-500/10 text-red-600 rounded-lg"
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
      </div>

      {/* Personnel Detail Modal */}
      <AnimatePresence>
        {selectedPerson && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50"
            onClick={() => setSelectedPerson(null)}
          >
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              className="bg-card rounded-xl p-6 w-full max-w-4xl max-h-[90vh] overflow-y-auto"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-xl font-semibold">Personel Detayları</h2>
                <button
                  onClick={() => setSelectedPerson(null)}
                  className="p-2 hover:bg-accent rounded-lg"
                >
                  <XCircle className="w-5 h-5" />
                </button>
              </div>

              {/* Personal Info */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div className="md:col-span-1">
                  <div className="flex flex-col items-center">
                    <div className="w-32 h-32 bg-primary/10 rounded-full flex items-center justify-center text-4xl font-bold">
                      {selectedPerson.firstName[0]}{selectedPerson.lastName[0]}
                    </div>
                    <h3 className="text-lg font-semibold mt-4">
                      {selectedPerson.firstName} {selectedPerson.lastName}
                    </h3>
                    <p className="text-sm text-muted-foreground">{selectedPerson.position}</p>
                    <div className="mt-2">
                      {getStatusBadge(selectedPerson.status)}
                    </div>
                  </div>
                </div>

                <div className="md:col-span-2 space-y-4">
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <p className="text-sm text-muted-foreground">Personel No</p>
                      <p className="font-medium">{selectedPerson.employeeNo}</p>
                    </div>
                    <div>
                      <p className="text-sm text-muted-foreground">Departman</p>
                      <p className="font-medium">{selectedPerson.department}</p>
                    </div>
                    <div>
                      <p className="text-sm text-muted-foreground">Email</p>
                      <p className="font-medium">{selectedPerson.email}</p>
                    </div>
                    <div>
                      <p className="text-sm text-muted-foreground">Telefon</p>
                      <p className="font-medium">{selectedPerson.phone}</p>
                    </div>
                    <div>
                      <p className="text-sm text-muted-foreground">Doğum Tarihi</p>
                      <p className="font-medium">
                        {new Date(selectedPerson.birthDate).toLocaleDateString('tr-TR')} 
                        ({calculateAge(selectedPerson.birthDate)} yaş)
                      </p>
                    </div>
                    <div>
                      <p className="text-sm text-muted-foreground">İşe Başlama</p>
                      <p className="font-medium">
                        {new Date(selectedPerson.startDate).toLocaleDateString('tr-TR')}
                      </p>
                    </div>
                  </div>

                  {/* Performance Chart */}
                  {selectedPerson.performance.length > 0 && (
                    <div className="mt-6">
                      <h4 className="text-sm font-medium mb-3">Performans Grafiği</h4>
                      <div className="flex items-end gap-2 h-32">
                        {selectedPerson.performance.map((perf, index) => (
                          <div key={index} className="flex-1 flex flex-col items-center">
                            <div className="w-full bg-accent rounded-t" style={{
                              height: `${perf.score}%`,
                              backgroundColor: perf.score >= 85 ? '#10b981' : perf.score >= 70 ? '#f59e0b' : '#ef4444'
                            }} />
                            <p className="text-xs mt-1">{perf.month.slice(0, 3)}</p>
                          </div>
                        ))}
                      </div>
                    </div>
                  )}

                  {/* Action Buttons */}
                  <div className="flex gap-2 pt-4">
                    <button className="px-4 py-2 bg-primary text-primary-foreground rounded-lg text-sm">
                      <Edit className="w-4 h-4 inline mr-1" />
                      Düzenle
                    </button>
                    <button className="px-4 py-2 border rounded-lg text-sm hover:bg-accent">
                      <FileText className="w-4 h-4 inline mr-1" />
                      Belgeler
                    </button>
                    <button className="px-4 py-2 border rounded-lg text-sm hover:bg-accent">
                      <Calendar className="w-4 h-4 inline mr-1" />
                      İzinler
                    </button>
                    <button className="px-4 py-2 border rounded-lg text-sm hover:bg-accent">
                      <DollarSign className="w-4 h-4 inline mr-1" />
                      Ödemeler
                    </button>
                  </div>
                </div>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}
ENDOFPERSONNEL

echo -e "${GREEN}✅ Personnel Management component oluşturuldu${NC}"

# =====================================================
# SACRIFICE MANAGEMENT PAGE
# =====================================================

echo -e "${BLUE}🐑 Sacrifice Management sayfası oluşturuluyor...${NC}"

cat > 'app/(main)/sacrifice/page.tsx' << 'ENDOFSACRIFICEPAGE'
import SacrificeManagement from '@/components/sacrifice/SacrificeManagement'

export const metadata = {
  title: 'Kurban Yönetimi - NGO Management System',
  description: 'Kurban organizasyonu ve takibi'
}

export default function SacrificePage() {
  return <SacrificeManagement />
}
ENDOFSACRIFICEPAGE

# Sacrifice Management Component
cat > 'components/sacrifice/SacrificeManagement.tsx' << 'ENDOFSACRIFICE'
'use client'

import React, { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import {
  Plus, Search, Filter, Download, Heart, Users, Calendar, MapPin,
  DollarSign, CheckCircle, Clock, Package, QrCode, Printer, Share2,
  Eye, Edit, Trash2, MoreVertical, AlertCircle, TrendingUp, BarChart3,
  FileText, Phone, Mail, MessageSquare, User, Building2, Flag,
  Truck, ChefHat, Gift, Star, Award, Target, Activity, RefreshCw
} from 'lucide-react'
import { toast } from 'react-hot-toast'

// Types
interface SacrificeShare {
  id: string
  shareholderName: string
  shareholderPhone: string
  shareholderEmail?: string
  shareCount: number
  amount: number
  isPaid: boolean
  paymentDate?: string
  paymentMethod?: 'cash' | 'bank' | 'online'
}

interface Sacrifice {
  id: string
  code: string
  type: 'cow' | 'camel' | 'sheep'
  name: string
  weight?: number
  age?: number
  color?: string
  healthStatus: 'healthy' | 'treatment' | 'quarantine'
  shares: SacrificeShare[]
  totalShares: number
  soldShares: number
  pricePerShare: number
  totalAmount: number
  collectedAmount: number
  location: string
  facility: string
  purchaseDate: string
  purchaseFrom: string
  slaughterDate?: string
  slaughterStatus: 'waiting' | 'scheduled' | 'completed'
  distributionStatus: 'pending' | 'in-progress' | 'completed'
  beneficiaries: number
  photos: string[]
  documents: Array<{
    id: string
    name: string
    type: string
    url: string
  }>
  notes?: string
  createdAt: string
  updatedAt: string
}

// Sample data
const initialSacrifices: Sacrifice[] = [
  {
    id: '1',
    code: 'QRB-2025-001',
    type: 'cow',
    name: 'Kurban #001',
    weight: 450,
    age: 3,
    color: 'Kahverengi',
    healthStatus: 'healthy',
    shares: [
      {
        id: 's1',
        shareholderName: 'Ahmet Yılmaz',
        shareholderPhone: '+90 555 111 2222',
        shareholderEmail: 'ahmet@email.com',
        shareCount: 1,
        amount: 12000,
        isPaid: true,
        paymentDate: '2025-10-10',
        paymentMethod: 'bank'
      },
      {
        id: 's2',
        shareholderName: 'Mehmet Öz',
        shareholderPhone: '+90 555 333 4444',
        shareCount: 2,
        amount: 24000,
        isPaid: true,
        paymentDate: '2025-10-12',
        paymentMethod: 'cash'
      }
    ],
    totalShares: 7,
    soldShares: 3,
    pricePerShare: 12000,
    totalAmount: 84000,
    collectedAmount: 36000,
    location: 'Nijer - Niamey',
    facility: 'Nijer Tesisi',
    purchaseDate: '2025-10-01',
    purchaseFrom: 'Yerel Çiftlik',
    slaughterDate: '2025-11-15',
    slaughterStatus: 'scheduled',
    distributionStatus: 'pending',
    beneficiaries: 350,
    photos: [],
    documents: [],
    createdAt: '2025-10-01',
    updatedAt: '2025-10-17'
  },
  {
    id: '2',
    code: 'QRB-2025-002',
    type: 'sheep',
    name: 'Kurban #002',
    weight: 65,
    age: 2,
    color: 'Beyaz',
    healthStatus: 'healthy',
    shares: [
      {
        id: 's3',
        shareholderName: 'Fatma Kaya',
        shareholderPhone: '+90 555 555 6666',
        shareCount: 1,
        amount: 8500,
        isPaid: true,
        paymentDate: '2025-10-14',
        paymentMethod: 'online'
      }
    ],
    totalShares: 1,
    soldShares: 1,
    pricePerShare: 8500,
    totalAmount: 8500,
    collectedAmount: 8500,
    location: 'Senegal - Dakar',
    facility: 'Senegal Tesisi',
    purchaseDate: '2025-10-05',
    purchaseFrom: 'Yerel Çiftlik',
    slaughterDate: '2025-11-15',
    slaughterStatus: 'scheduled',
    distributionStatus: 'pending',
    beneficiaries: 50,
    photos: [],
    documents: [],
    createdAt: '2025-10-05',
    updatedAt: '2025-10-17'
  }
]

const sacrificeTypes = [
  { type: 'cow', label: 'Büyükbaş', icon: '🐄', shares: 7, minPrice: 70000, maxPrice: 100000 },
  { type: 'camel', label: 'Deve', icon: '🐪', shares: 7, minPrice: 90000, maxPrice: 120000 },
  { type: 'sheep', label: 'Küçükbaş', icon: '🐑', shares: 1, minPrice: 7000, maxPrice: 10000 }
]

export default function SacrificeManagement() {
  const [sacrifices, setSacrifices] = useState<Sacrifice[]>(initialSacrifices)
  const [selectedSacrifice, setSelectedSacrifice] = useState<Sacrifice | null>(null)
  const [activeTab, setActiveTab] = useState<'all' | 'available' | 'sold' | 'completed'>('all')
  const [showNewSacrifice, setShowNewSacrifice] = useState(false)
  const [showShareModal, setShowShareModal] = useState(false)
  const [selectedForShare, setSelectedForShare] = useState<Sacrifice | null>(null)
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedType, setSelectedType] = useState('')
  const [selectedLocation, setSelectedLocation] = useState('')
  const [loading, setLoading] = useState(false)

  // Filter sacrifices
  const filteredSacrifices = sacrifices.filter(sacrifice => {
    const matchesTab = activeTab === 'all' ||
      (activeTab === 'available' && sacrifice.soldShares < sacrifice.totalShares) ||
      (activeTab === 'sold' && sacrifice.soldShares === sacrifice.totalShares) ||
      (activeTab === 'completed' && sacrifice.slaughterStatus === 'completed')
    
    const matchesSearch = searchTerm === '' ||
      sacrifice.code.toLowerCase().includes(searchTerm.toLowerCase()) ||
      sacrifice.name.toLowerCase().includes(searchTerm.toLowerCase())
    
    const matchesType = selectedType === '' || sacrifice.type === selectedType
    const matchesLocation = selectedLocation === '' || sacrifice.location.includes(selectedLocation)

    return matchesTab && matchesSearch && matchesType && matchesLocation
  })

  // Calculate statistics
  const stats = {
    total: sacrifices.length,
    totalShares: sacrifices.reduce((sum, s) => sum + s.totalShares, 0),
    soldShares: sacrifices.reduce((sum, s) => sum + s.soldShares, 0),
    totalAmount: sacrifices.reduce((sum, s) => sum + s.totalAmount, 0),
    collectedAmount: sacrifices.reduce((sum, s) => sum + s.collectedAmount, 0),
    totalBeneficiaries: sacrifices.reduce((sum, s) => sum + s.beneficiaries, 0),
    completed: sacrifices.filter(s => s.slaughterStatus === 'completed').length
  }

  const getTypeInfo = (type: string) => {
    return sacrificeTypes.find(t => t.type === type) || sacrificeTypes[0]
  }

  const getHealthStatusBadge = (status: Sacrifice['healthStatus']) => {
    const badges = {
      healthy: { bg: 'bg-green-500/10', text: 'text-green-600', label: 'Sağlıklı' },
      treatment: { bg: 'bg-yellow-500/10', text: 'text-yellow-600', label: 'Tedavide' },
      quarantine: { bg: 'bg-red-500/10', text: 'text-red-600', label: 'Karantina' }
    }
    const badge = badges[status]
    return (
      <span className={`px-2 py-1 text-xs rounded-full ${badge.bg} ${badge.text}`}>
        {badge.label}
      </span>
    )
  }

  const handleDeleteSacrifice = (id: string) => {
    if (confirm('Bu kurbanı silmek istediğinizden emin misiniz?')) {
      setSacrifices(prev => prev.filter(s => s.id !== id))
      toast.success('Kurban silindi')
    }
  }

  const handleAddShare = (sacrificeId: string, share: SacrificeShare) => {
    setSacrifices(prev => prev.map(s => 
      s.id === sacrificeId 
        ? { 
            ...s, 
            shares: [...s.shares, share],
            soldShares: s.soldShares + share.shareCount,
            collectedAmount: s.collectedAmount + (share.isPaid ? share.amount : 0)
          }
        : s
    ))
    toast.success('Hisse eklendi')
  }

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold">Kurban Yönetimi</h1>
          <p className="text-muted-foreground mt-1">
            Kurban organizasyonu ve takibi
          </p>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={() => setShowNewSacrifice(true)}
            className="px-4 py-2 bg-primary text-primary-foreground rounded-lg text-sm flex items-center gap-2"
          >
            <Plus className="w-4 h-4" />
            Yeni Kurban
          </button>
          <button className="px-3 py-2 border rounded-lg hover:bg-accent">
            <QrCode className="w-4 h-4" />
          </button>
          <button
            onClick={() => setLoading(true)}
            className="px-3 py-2 border rounded-lg hover:bg-accent"
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
              <p className="text-sm text-muted-foreground">Toplam Kurban</p>
              <p className="text-2xl font-bold mt-1">{stats.total}</p>
              <p className="text-xs text-green-600 mt-1">
                {stats.completed} tamamlandı
              </p>
            </div>
            <div className="p-3 bg-red-500/10 rounded-lg">
              <Heart className="w-6 h-6 text-red-500" />
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
              <p className="text-sm text-muted-foreground">Hisse Durumu</p>
              <p className="text-2xl font-bold mt-1">
                {stats.soldShares}/{stats.totalShares}
              </p>
              <p className="text-xs text-muted-foreground mt-1">
                %{Math.round((stats.soldShares / stats.totalShares) * 100)} satıldı
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
          transition={{ delay: 0.2 }}
          className="bg-card p-4 rounded-xl border"
        >
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-muted-foreground">Toplanan Tutar</p>
              <p className="text-2xl font-bold mt-1">₺{stats.collectedAmount.toLocaleString()}</p>
              <p className="text-xs text-muted-foreground mt-1">
                ₺{stats.totalAmount.toLocaleString()} hedef
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
          transition={{ delay: 0.3 }}
          className="bg-card p-4 rounded-xl border"
        >
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-muted-foreground">Faydalanıcı</p>
              <p className="text-2xl font-bold mt-1">{stats.totalBeneficiaries.toLocaleString()}</p>
              <p className="text-xs text-purple-600 mt-1">
                Aileye ulaşılacak
              </p>
            </div>
            <div className="p-3 bg-purple-500/10 rounded-lg">
              <Gift className="w-6 h-6 text-purple-500" />
            </div>
          </div>
        </motion.div>
      </div>

      {/* Filters */}
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
              Tümü ({sacrifices.length})
            </button>
            <button
              onClick={() => setActiveTab('available')}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors whitespace-nowrap ${
                activeTab === 'available' ? 'bg-primary text-primary-foreground' : 'hover:bg-accent'
              }`}
            >
              Hisse Alınabilir
            </button>
            <button
              onClick={() => setActiveTab('sold')}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors whitespace-nowrap ${
                activeTab === 'sold' ? 'bg-primary text-primary-foreground' : 'hover:bg-accent'
              }`}
            >
              Satıldı
            </button>
            <button
              onClick={() => setActiveTab('completed')}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors whitespace-nowrap ${
                activeTab === 'completed' ? 'bg-primary text-primary-foreground' : 'hover:bg-accent'
              }`}
            >
              Tamamlandı
            </button>
          </div>

          {/* Controls */}
          <div className="flex items-center gap-2">
            <div className="relative">
              <Search className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
              <input
                type="text"
                placeholder="Kurban ara..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="pl-9 pr-4 py-2 bg-background border rounded-lg text-sm w-64"
              />
            </div>
            <select
              value={selectedType}
              onChange={(e) => setSelectedType(e.target.value)}
              className="px-3 py-2 bg-background border rounded-lg text-sm"
            >
              <option value="">Tüm Türler</option>
              {sacrificeTypes.map(type => (
                <option key={type.type} value={type.type}>
                  {type.icon} {type.label}
                </option>
              ))}
            </select>
            <button className="px-3 py-2 border rounded-lg hover:bg-accent">
              <Filter className="w-4 h-4" />
            </button>
            <button className="px-3 py-2 border rounded-lg hover:bg-accent">
              <Download className="w-4 h-4" />
            </button>
          </div>
        </div>
      </div>

      {/* Sacrifices Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        {filteredSacrifices.map((sacrifice, index) => {
          const typeInfo = getTypeInfo(sacrifice.type)
          const sharePercentage = (sacrifice.soldShares / sacrifice.totalShares) * 100

          return (
            <motion.div
              key={sacrifice.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.05 }}
              className="bg-card rounded-xl border p-6 hover:shadow-lg transition-all cursor-pointer"
              onClick={() => setSelectedSacrifice(sacrifice)}
            >
              {/* Header */}
              <div className="flex items-start justify-between mb-4">
                <div className="text-3xl">{typeInfo.icon}</div>
                <button
                  onClick={(e) => {
                    e.stopPropagation()
                    // More actions
                  }}
                  className="p-1 hover:bg-accent rounded-lg"
                >
                  <MoreVertical className="w-4 h-4" />
                </button>
              </div>

              {/* Info */}
              <div className="space-y-2 mb-4">
                <div>
                  <p className="text-xs text-muted-foreground font-mono">{sacrifice.code}</p>
                  <h3 className="font-semibold">{sacrifice.name}</h3>
                </div>
                <p className="text-sm text-muted-foreground flex items-center gap-1">
                  <MapPin className="w-3 h-3" />
                  {sacrifice.location}
                </p>
                {sacrifice.weight && (
                  <p className="text-sm text-muted-foreground">
                    {sacrifice.weight} kg • {sacrifice.age} yaş
                  </p>
                )}
              </div>

              {/* Share Progress */}
              <div className="mb-4">
                <div className="flex items-center justify-between text-sm mb-2">
                  <span className="text-muted-foreground">Hisse</span>
                  <span className="font-medium">
                    {sacrifice.soldShares}/{sacrifice.totalShares}
                  </span>
                </div>
                <div className="w-full bg-accent rounded-full h-2 overflow-hidden">
                  <div
                    className={`h-full transition-all ${
                      sharePercentage === 100 ? 'bg-green-500' :
                      sharePercentage >= 50 ? 'bg-yellow-500' : 'bg-blue-500'
                    }`}
                    style={{ width: `${sharePercentage}%` }}
                  />
                </div>
              </div>

              {/* Price */}
              <div className="mb-4">
                <p className="text-sm text-muted-foreground">Hisse Fiyatı</p>
                <p className="text-lg font-bold">₺{sacrifice.pricePerShare.toLocaleString()}</p>
              </div>

              {/* Status */}
              <div className="flex items-center justify-between mb-4">
                {getHealthStatusBadge(sacrifice.healthStatus)}
                {sacrifice.slaughterDate && (
                  <span className="text-xs text-muted-foreground">
                    <Calendar className="w-3 h-3 inline mr-1" />
                    {new Date(sacrifice.slaughterDate).toLocal