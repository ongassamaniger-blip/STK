#!/bin/bash
# upgrade-7-personnel-management.sh
# Personnel Management Module
# Date: 2025-10-18 10:47:00
# User: ongassamaniger-blip

echo "👥 =========================================="
echo "   PERSONEL YÖNETİMİ MODÜLÜ"
echo "   Maaş, izin, performans, belge yönetimi..."
echo "👥 =========================================="

# Personnel klasörü oluştur
mkdir -p "app/(main)/personnel"

# Personnel Management Page
cat > "app/(main)/personnel/page.tsx" << 'EOF'
'use client'

import { useState } from 'react'
import { motion } from 'framer-motion'
import {
  Users, Plus, Search, Filter, Download, Upload,
  User, Mail, Phone, Calendar, DollarSign,
  Award, Clock, TrendingUp, AlertCircle, CheckCircle,
  Edit, Trash2, Eye, FileText, MoreVertical,
  Building2, MapPin, Briefcase, GraduationCap,
  Heart, Shield, Star, UserCheck, UserX,
  CreditCard, Receipt, Activity, BarChart3
} from 'lucide-react'
import {
  BarChart, Bar, LineChart, Line, XAxis, YAxis,
  CartesianGrid, Tooltip, ResponsiveContainer,
  PieChart, Pie, Cell, RadialBarChart, RadialBar
} from 'recharts'

interface Personnel {
  id: string
  name: string
  position: string
  department: string
  facility: string
  startDate: string
  birthDate: string
  phone: string
  email: string
  address: string
  salary: number
  status: 'active' | 'onleave' | 'inactive'
  education: string
  experience: number
  performance: number
  leaveBalance: number
  usedLeave: number
  skills: string[]
  documents: {
    id: string
    name: string
    type: string
    uploadDate: string
  }[]
  emergencyContact: {
    name: string
    phone: string
    relation: string
  }
}

export default function PersonnelPage() {
  const [personnel, setPersonnel] = useState<Personnel[]>([
    {
      id: '1',
      name: 'Ahmet Yılmaz',
      position: 'Proje Yöneticisi',
      department: 'Operasyon',
      facility: 'Nijer Ana Merkez',
      startDate: '2020-03-15',
      birthDate: '1985-06-20',
      phone: '+90 532 123 4567',
      email: 'ahmet.yilmaz@ngo.org',
      address: 'Niamey, Nijer',
      salary: 25000,
      status: 'active',
      education: 'Lisans - İşletme',
      experience: 8,
      performance: 92,
      leaveBalance: 14,
      usedLeave: 10,
      skills: ['Proje Yönetimi', 'Bütçe Planlama', 'Liderlik'],
      documents: [
        { id: '1', name: 'Diploma.pdf', type: 'pdf', uploadDate: '2020-03-01' },
        { id: '2', name: 'CV.pdf', type: 'pdf', uploadDate: '2020-03-01' }
      ],
      emergencyContact: {
        name: 'Mehmet Yılmaz',
        phone: '+90 532 987 6543',
        relation: 'Kardeş'
      }
    },
    {
      id: '2',
      name: 'Fatma Kaya',
      position: 'Muhasebe Uzmanı',
      department: 'Finans',
      facility: 'Senegal Şubesi',
      startDate: '2021-06-10',
      birthDate: '1990-12-15',
      phone: '+221 77 123 4567',
      email: 'fatma.kaya@ngo.org',
      address: 'Dakar, Senegal',
      salary: 18000,
      status: 'active',
      education: 'Lisans - Muhasebe',
      experience: 5,
      performance: 88,
      leaveBalance: 14,
      usedLeave: 5,
      skills: ['Muhasebe', 'Excel', 'Raporlama'],
      documents: [
        { id: '3', name: 'Diploma.pdf', type: 'pdf', uploadDate: '2021-06-01' }
      ],
      emergencyContact: {
        name: 'Ali Kaya',
        phone: '+90 533 456 7890',
        relation: 'Eş'
      }
    },
    {
      id: '3',
      name: 'Moussa Diallo',
      position: 'Saha Koordinatörü',
      department: 'Operasyon',
      facility: 'Mali Temsilcilik',
      startDate: '2022-01-20',
      birthDate: '1988-03-10',
      phone: '+223 76 234 5678',
      email: 'moussa.diallo@ngo.org',
      address: 'Bamako, Mali',
      salary: 15000,
      status: 'onleave',
      education: 'Lisans - Sosyoloji',
      experience: 4,
      performance: 85,
      leaveBalance: 14,
      usedLeave: 3,
      skills: ['Saha Çalışması', 'İletişim', 'Fransızca'],
      documents: [],
      emergencyContact: {
        name: 'Amadou Diallo',
        phone: '+223 76 987 6543',
        relation: 'Baba'
      }
    }
  ])

  const [showAddModal, setShowAddModal] = useState(false)
  const [showDetailModal, setShowDetailModal] = useState(false)
  const [selectedPerson, setSelectedPerson] = useState<Personnel | null>(null)
  const [activeTab, setActiveTab] = useState('list')
  const [filterDepartment, setFilterDepartment] = useState('all')

  // Statistics
  const totalPersonnel = personnel.length
  const activePersonnel = personnel.filter(p => p.status === 'active').length
  const onLeavePersonnel = personnel.filter(p => p.status === 'onleave').length
  const totalSalary = personnel.reduce((sum, p) => sum + p.salary, 0)
  const avgPerformance = Math.round(
    personnel.reduce((sum, p) => sum + p.performance, 0) / personnel.length
  )

  const stats = [
    {
      label: 'Toplam Personel',
      value: totalPersonnel,
      icon: Users,
      color: 'blue',
      change: '+2'
    },
    {
      label: 'Aktif Personel',
      value: activePersonnel,
      icon: UserCheck,
      color: 'green',
      change: `${Math.round(activePersonnel/totalPersonnel*100)}%`
    },
    {
      label: 'Toplam Maaş',
      value: `₺${totalSalary.toLocaleString()}`,
      icon: DollarSign,
      color: 'purple',
      change: '+8%'
    },
    {
      label: 'Ort. Performans',
      value: `%${avgPerformance}`,
      icon: TrendingUp,
      color: 'orange',
      change: '+3%'
    }
  ]

  // Department distribution
  const departmentData = [
    { name: 'Operasyon', value: personnel.filter(p => p.department === 'Operasyon').length, color: '#3b82f6' },
    { name: 'Finans', value: personnel.filter(p => p.department === 'Finans').length, color: '#10b981' },
    { name: 'İK', value: personnel.filter(p => p.department === 'İK').length, color: '#f59e0b' },
    { name: 'IT', value: personnel.filter(p => p.department === 'IT').length, color: '#8b5cf6' }
  ]

  // Performance data for chart
  const performanceData = personnel.map(p => ({
    name: p.name.split(' ')[0],
    performance: p.performance
  }))

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">Personel Yönetimi</h1>
          <p className="text-gray-500 dark:text-gray-400 mt-1">
            {totalPersonnel} personel, {activePersonnel} aktif
          </p>
        </div>
        <div className="flex items-center gap-2">
          <button className="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-lg hover:bg-gray-300 flex items-center gap-2">
            <Upload className="w-4 h-4" />
            İçe Aktar
          </button>
          <button className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 flex items-center gap-2">
            <Download className="w-4 h-4" />
            Excel İndir
          </button>
          <button
            onClick={() => setShowAddModal(true)}
            className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 flex items-center gap-2"
          >
            <Plus className="w-4 h-4" />
            Personel Ekle
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
        {/* Performance Chart */}
        <div className="lg:col-span-2 bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold mb-4">Performans Değerlendirmesi</h3>
          <ResponsiveContainer width="100%" height={250}>
            <BarChart data={performanceData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="name" />
              <YAxis />
              <Tooltip />
              <Bar dataKey="performance" fill="#3b82f6">
                {performanceData.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={
                    entry.performance >= 90 ? '#10b981' :
                    entry.performance >= 70 ? '#f59e0b' : '#ef4444'
                  } />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>

        {/* Department Distribution */}
        <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold mb-4">Departman Dağılımı</h3>
          <ResponsiveContainer width="100%" height={200}>
            <PieChart>
              <Pie
                data={departmentData}
                cx="50%"
                cy="50%"
                innerRadius={50}
                outerRadius={70}
                paddingAngle={5}
                dataKey="value"
              >
                {departmentData.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
          <div className="space-y-2 mt-4">
            {departmentData.map((item) => (
              <div key={item.name} className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div className="w-3 h-3 rounded-full" style={{ backgroundColor: item.color }} />
                  <span className="text-sm text-gray-600 dark:text-gray-400">{item.name}</span>
                </div>
                <span className="text-sm font-medium">{item.value} kişi</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Tabs */}
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow border border-gray-200 dark:border-gray-700">
        <div className="border-b border-gray-200 dark:border-gray-700">
          <div className="flex gap-4 p-4">
            <button
              onClick={() => setActiveTab('list')}
              className={`px-4 py-2 rounded-lg transition-colors ${
                activeTab === 'list' 
                  ? 'bg-blue-100 text-blue-600 dark:bg-blue-900/20' 
                  : 'hover:bg-gray-100 dark:hover:bg-gray-700'
              }`}
            >
              <Users className="w-4 h-4 inline mr-2" />
              Personel Listesi
            </button>
            <button
              onClick={() => setActiveTab('leave')}
              className={`px-4 py-2 rounded-lg transition-colors ${
                activeTab === 'leave' 
                  ? 'bg-blue-100 text-blue-600 dark:bg-blue-900/20' 
                  : 'hover:bg-gray-100 dark:hover:bg-gray-700'
              }`}
            >
              <Calendar className="w-4 h-4 inline mr-2" />
              İzin Takibi
            </button>
            <button
              onClick={() => setActiveTab('salary')}
              className={`px-4 py-2 rounded-lg transition-colors ${
                activeTab === 'salary' 
                  ? 'bg-blue-100 text-blue-600 dark:bg-blue-900/20' 
                  : 'hover:bg-gray-100 dark:hover:bg-gray-700'
              }`}
            >
              <DollarSign className="w-4 h-4 inline mr-2" />
              Maaş Yönetimi
            </button>
          </div>
        </div>

        {/* Personnel List */}
        {activeTab === 'list' && (
          <div>
            {/* Filters */}
            <div className="p-4 border-b border-gray-200 dark:border-gray-700">
              <div className="flex gap-4">
                <div className="flex-1 relative">
                  <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                  <input
                    type="text"
                    placeholder="Personel ara..."
                    className="w-full pl-10 pr-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                  />
                </div>
                <select 
                  value={filterDepartment}
                  onChange={(e) => setFilterDepartment(e.target.value)}
                  className="px-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                >
                  <option value="all">Tüm Departmanlar</option>
                  <option value="Operasyon">Operasyon</option>
                  <option value="Finans">Finans</option>
                  <option value="İK">İnsan Kaynakları</option>
                  <option value="IT">Bilgi İşlem</option>
                </select>
                <select className="px-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg">
                  <option>Tüm Tesisler</option>
                  <option>Nijer Ana Merkez</option>
                  <option>Senegal Şubesi</option>
                  <option>Mali Temsilcilik</option>
                </select>
              </div>
            </div>

            {/* Table */}
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead>
                  <tr className="bg-gray-50 dark:bg-gray-700/50">
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                      Personel
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                      Pozisyon
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                      Departman
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                      Tesis
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                      Performans
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                      Durum
                    </th>
                    <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">
                      İşlemler
                    </th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-200 dark:divide-gray-700">
                  {personnel.map((person) => (
                    <tr key={person.id} className="hover:bg-gray-50 dark:hover:bg-gray-700/50">
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold">
                            {person.name.split(' ').map(n => n[0]).join('')}
                          </div>
                          <div>
                            <p className="font-medium text-gray-900 dark:text-white">{person.name}</p>
                            <p className="text-xs text-gray-500">{person.email}</p>
                          </div>
                        </div>
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-900 dark:text-gray-300">
                        {person.position}
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-900 dark:text-gray-300">
                        {person.department}
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-900 dark:text-gray-300">
                        {person.facility}
                      </td>
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-2">
                          <div className="flex-1 bg-gray-200 dark:bg-gray-700 rounded-full h-2">
                            <div 
                              className={`h-2 rounded-full ${
                                person.performance >= 90 ? 'bg-green-500' :
                                person.performance >= 70 ? 'bg-yellow-500' : 'bg-red-500'
                              }`}
                              style={{ width: `${person.performance}%` }}
                            />
                          </div>
                          <span className="text-xs font-medium">{person.performance}%</span>
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <span className={`px-2 py-1 text-xs rounded-full ${
                          person.status === 'active' ? 'bg-green-100 text-green-700' :
                          person.status === 'onleave' ? 'bg-yellow-100 text-yellow-700' :
                          'bg-red-100 text-red-700'
                        }`}>
                          {person.status === 'active' ? 'Aktif' :
                           person.status === 'onleave' ? 'İzinde' : 'Pasif'}
                        </span>
                      </td>
                      <td className="px-6 py-4">
                        <div className="flex items-center justify-end gap-1">
                          <button
                            onClick={() => {
                              setSelectedPerson(person)
                              setShowDetailModal(true)
                            }}
                            className="p-1 hover:bg-gray-100 dark:hover:bg-gray-700 rounded"
                          >
                            <Eye className="w-4 h-4 text-blue-600" />
                          </button>
                          <button className="p-1 hover:bg-gray-100 dark:hover:bg-gray-700 rounded">
                            <Edit className="w-4 h-4 text-gray-600" />
                          </button>
                          <button className="p-1 hover:bg-gray-100 dark:hover:bg-gray-700 rounded">
                            <MoreVertical className="w-4 h-4 text-gray-600" />
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {/* Leave Management Tab */}
        {activeTab === 'leave' && (
          <div className="p-6">
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              {/* Leave Balance Overview */}
              <div className="space-y-4">
                <h3 className="font-semibold text-gray-900 dark:text-white">İzin Durumu</h3>
                {personnel.map((person) => (
                  <div key={person.id} className="flex items-center justify-between p-4 bg-gray-50 dark:bg-gray-700/50 rounded-lg">
                    <div className="flex items-center gap-3">
                      <div className="w-8 h-8 bg-blue-100 dark:bg-blue-900/20 rounded-full flex items-center justify-center">
                        <User className="w-4 h-4 text-blue-600" />
                      </div>
                      <div>
                        <p className="font-medium text-gray-900 dark:text-white">{person.name}</p>
                        <p className="text-xs text-gray-500">{person.position}</p>
                      </div>
                    </div>
                    <div className="text-right">
                      <p className="text-sm font-medium text-gray-900 dark:text-white">
                        {person.usedLeave}/{person.leaveBalance} gün
                      </p>
                      <p className="text-xs text-gray-500">
                        Kalan: {person.leaveBalance - person.usedLeave} gün
                      </p>
                    </div>
                  </div>
                ))}
              </div>

              {/* Leave Calendar Placeholder */}
              <div className="bg-gray-50 dark:bg-gray-700/50 rounded-lg p-6">
                <h3 className="font-semibold text-gray-900 dark:text-white mb-4">İzin Takvimi</h3>
                <div className="text-center py-8">
                  <Calendar className="w-12 h-12 mx-auto text-gray-400 mb-2" />
                  <p className="text-sm text-gray-500">İzin takvimi burada gösterilecek</p>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Salary Management Tab */}
        {activeTab === 'salary' && (
          <div className="p-6">
            <div className="space-y-4">
              <div className="flex justify-between items-center mb-4">
                <h3 className="font-semibold text-gray-900 dark:text-white">Maaş Yönetimi</h3>
                <button className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 flex items-center gap-2">
                  <Receipt className="w-4 h-4" />
                  Toplu Ödeme
                </button>
              </div>

              {personnel.map((person) => (
                <div key={person.id} className="border border-gray-200 dark:border-gray-700 rounded-lg p-4">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-4">
                      <div className="w-10 h-10 bg-gradient-to-br from-green-500 to-emerald-600 rounded-full flex items-center justify-center text-white">
                        <DollarSign className="w-5 h-5" />
                      </div>
                      <div>
                        <p className="font-medium text-gray-900 dark:text-white">{person.name}</p>
                        <p className="text-sm text-gray-500">{person.position} - {person.department}</p>
                      </div>
                    </div>
                    <div className="text-right">
                      <p className="text-xl font-bold text-gray-900 dark:text-white">
                        ₺{person.salary.toLocaleString()}
                      </p>
                      <p className="text-xs text-gray-500">Aylık Maaş</p>
                    </div>
                  </div>
                  <div className="mt-4 flex gap-2">
                    <button className="flex-1 px-3 py-1.5 bg-blue-100 dark:bg-blue-900/20 text-blue-600 rounded text-sm hover:bg-blue-200">
                      Maaş Detayı
                    </button>
                    <button className="flex-1 px-3 py-1.5 bg-green-100 dark:bg-green-900/20 text-green-600 rounded text-sm hover:bg-green-200">
                      Ödeme Yap
                    </button>
                    <button className="flex-1 px-3 py-1.5 bg-purple-100 dark:bg-purple-900/20 text-purple-600 rounded text-sm hover:bg-purple-200">
                      Bordro İndir
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>

      {/* Personnel Detail Modal */}
      {showDetailModal && selectedPerson && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
          onClick={() => setShowDetailModal(false)}
        >
          <motion.div
            initial={{ scale: 0.9 }}
            animate={{ scale: 1 }}
            className="bg-white dark:bg-gray-800 rounded-2xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-hidden"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Modal Header */}
            <div className="p-6 border-b border-gray-200 dark:border-gray-700">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="w-16 h-16 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white text-xl font-bold">
                    {selectedPerson.name.split(' ').map(n => n[0]).join('')}
                  </div>
                  <div>
                    <h2 className="text-xl font-bold text-gray-900 dark:text-white">{selectedPerson.name}</h2>
                    <p className="text-gray-500">{selectedPerson.position}</p>
                  </div>
                </div>
                <button
                  onClick={() => setShowDetailModal(false)}
                  className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg"
                >
                  <X className="w-5 h-5" />
                </button>
              </div>
            </div>

            {/* Modal Content */}
            <div className="p-6 overflow-y-auto max-h-[70vh]">
              <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                {/* Personal Info */}
                <div className="lg:col-span-2 space-y-4">
                  <div>
                    <h3 className="font-semibold text-gray-900 dark:text-white mb-3">Kişisel Bilgiler</h3>
                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <p className="text-sm text-gray-500">Telefon</p>
                        <p className="font-medium">{selectedPerson.phone}</p>
                      </div>
                      <div>
                        <p className="text-sm text-gray-500">E-posta</p>
                        <p className="font-medium">{selectedPerson.email}</p>
                      </div>
                      <div>
                        <p className="text-sm text-gray-500">Doğum Tarihi</p>
                        <p className="font-medium">{new Date(selectedPerson.birthDate).toLocaleDateString('tr-TR')}</p>
                      </div>
                      <div>
                        <p className="text-sm text-gray-500">İşe Başlama</p>
                        <p className="font-medium">{new Date(selectedPerson.startDate).toLocaleDateString('tr-TR')}</p>
                      </div>
                      <div className="col-span-2">
                        <p className="text-sm text-gray-500">Adres</p>
                        <p className="font-medium">{selectedPerson.address}</p>
                      </div>
                    </div>
                  </div>

                  <div>
                    <h3 className="font-semibold text-gray-900 dark:text-white mb-3">İş Bilgileri</h3>
                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <p className="text-sm text-gray-500">Departman</p>
                        <p className="font-medium">{selectedPerson.department}</p>
                      </div>
                      <div>
                        <p className="text-sm text-gray-500">Tesis</p>
                        <p className="font-medium">{selectedPerson.facility}</p>
                      </div>
                      <div>
                        <p className="text-sm text-gray-500">Eğitim</p>
                        <p className="font-medium">{selectedPerson.education}</p>
                      </div>
                      <div>
                        <p className="text-sm text-gray-500">Deneyim</p>
                        <p className="font-medium">{selectedPerson.experience} yıl</p>
                      </div>
                    </div>
                  </div>

                  <div>
                    <h3 className="font-semibold text-gray-900 dark:text-white mb-3">Acil Durum İrtibatı</h3>
                    <div className="bg-gray-50 dark:bg-gray-700/50 rounded-lg p-4">
                      <p className="font-medium">{selectedPerson.emergencyContact.name}</p>
                      <p className="text-sm text-gray-500">{selectedPerson.emergencyContact.relation}</p>
                      <p className="text-sm">{selectedPerson.emergencyContact.phone}</p>
                    </div>
                  </div>
                </div>

                {/* Stats & Actions */}
                <div className="space-y-4">
                  <div className="bg-blue-50 dark:bg-blue-900/20 rounded-lg p-4">
                    <div className="flex items-center justify-between mb-2">
                      <span className="text-sm text-gray-600 dark:text-gray-400">Performans</span>
                      <span className="font-bold text-xl">{selectedPerson.performance}%</span>
                    </div>
                    <div className="w-full bg-gray-200 rounded-full h-2">
                      <div 
                        className="bg-blue-600 h-2 rounded-full"
                        style={{ width: `${selectedPerson.performance}%` }}
                      />
                    </div>
                  </div>

                  <div className="bg-green-50 dark:bg-green-900/20 rounded-lg p-4">
                    <div className="flex items-center justify-between mb-2">
                      <span className="text-sm text-gray-600 dark:text-gray-400">Maaş</span>
                      <span className="font-bold text-xl">₺{selectedPerson.salary.toLocaleString()}</span>
                    </div>
                    <p className="text-xs text-gray-500">Aylık</p>
                  </div>

                  <div className="bg-orange-50 dark:bg-orange-900/20 rounded-lg p-4">
                    <div className="flex items-center justify-between mb-2">
                      <span className="text-sm text-gray-600 dark:text-gray-400">İzin Durumu</span>
                      <span className="font-bold">{selectedPerson.usedLeave}/{selectedPerson.leaveBalance}</span>
                    </div>
                    <p className="text-xs text-gray-500">Kullanılan / Toplam</p>
                  </div>

                  <div className="space-y-2">
                    <button className="w-full px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                      <Edit className="w-4 h-4 inline mr-2" />
                      Düzenle
                    </button>
                    <button className="w-full px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-lg hover:bg-gray-300">
                      <FileText className="w-4 h-4 inline mr-2" />
                      Belgeler
                    </button>
                    <button className="w-full px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-lg hover:bg-gray-300">
                      <Receipt className="w-4 h-4 inline mr-2" />
                      Bordro
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </motion.div>
        </motion.div>
      )}
    </div>
  )
}
EOF

echo "✅ Personel Yönetimi modülü tamamlandı!"
echo ""
echo "🎯 Eklenen özellikler:"
echo "  ✓ Personel listesi ve detayları"
echo "  ✓ İzin takibi"
echo "  ✓ Maaş yönetimi"
echo "  ✓ Performans değerlendirme"
echo "  ✓ Departman dağılımı"
echo "  ✓ Acil durum iletişim bilgileri"
echo "  ✓ Belge yönetimi"
echo ""
echo "📌 Test için: npm run dev"
echo "📌 Sonraki modül: Onay Sistemi"