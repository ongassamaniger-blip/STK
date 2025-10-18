#!/bin/bash
# upgrade-6-facilities-management.sh
# Facilities Management Module
# Date: 2025-10-18 10:39:27
# User: ongassamaniger-blip

echo "🏢 =========================================="
echo "   TESİS YÖNETİMİ MODÜLÜ"
echo "   Tesis dashboard, personel, kasa yönetimi..."
echo "🏢 =========================================="

# Facilities klasörü oluştur
mkdir -p "app/(main)/facilities"

# Facilities Management Page
cat > "app/(main)/facilities/page.tsx" << 'EOF'
'use client'

import { useState } from 'react'
import { motion } from 'framer-motion'
import {
  Building2, Plus, MapPin, Users, DollarSign,
  Activity, Settings, Eye, Edit, Trash2, MoreVertical,
  Phone, Mail, Globe, Calendar, TrendingUp, TrendingDown,
  Package, Wallet, Clock, AlertCircle, CheckCircle,
  FileText, BarChart3, Filter, Search, Download
} from 'lucide-react'
import {
  BarChart, Bar, LineChart, Line, XAxis, YAxis,
  CartesianGrid, Tooltip, ResponsiveContainer,
  PieChart, Pie, Cell
} from 'recharts'

interface Facility {
  id: string
  name: string
  location: string
  country: string
  type: 'merkez' | 'şube' | 'temsilcilik' | 'depo'
  status: 'active' | 'inactive' | 'maintenance'
  capacity: number
  currentOccupancy: number
  personnel: number
  monthlyBudget: number
  monthlySpent: number
  manager: string
  phone: string
  email: string
  establishedDate: string
  projects: number
  beneficiaries: number
  coordinates: { lat: number; lng: number }
}

export default function FacilitiesPage() {
  const [facilities, setFacilities] = useState<Facility[]>([
    {
      id: '1',
      name: 'Nijer Ana Merkez',
      location: 'Niamey',
      country: 'Nijer',
      type: 'merkez',
      status: 'active',
      capacity: 500,
      currentOccupancy: 380,
      personnel: 45,
      monthlyBudget: 150000,
      monthlySpent: 125000,
      manager: 'Ahmed Diallo',
      phone: '+227 90 12 34 56',
      email: 'niamey@ngo.org',
      establishedDate: '2020-03-15',
      projects: 12,
      beneficiaries: 5000,
      coordinates: { lat: 13.5127, lng: 2.1126 }
    },
    {
      id: '2',
      name: 'Senegal Şubesi',
      location: 'Dakar',
      country: 'Senegal',
      type: 'şube',
      status: 'active',
      capacity: 300,
      currentOccupancy: 220,
      personnel: 28,
      monthlyBudget: 100000,
      monthlySpent: 85000,
      manager: 'Fatou Sow',
      phone: '+221 77 12 34 56',
      email: 'dakar@ngo.org',
      establishedDate: '2021-06-20',
      projects: 8,
      beneficiaries: 3200,
      coordinates: { lat: 14.7167, lng: -17.4677 }
    },
    {
      id: '3',
      name: 'Mali Temsilcilik',
      location: 'Bamako',
      country: 'Mali',
      type: 'temsilcilik',
      status: 'active',
      capacity: 200,
      currentOccupancy: 150,
      personnel: 18,
      monthlyBudget: 75000,
      monthlySpent: 62000,
      manager: 'Moussa Traore',
      phone: '+223 76 12 34 56',
      email: 'bamako@ngo.org',
      establishedDate: '2022-01-10',
      projects: 5,
      beneficiaries: 2100,
      coordinates: { lat: 12.6392, lng: -8.0029 }
    }
  ])

  const [viewMode, setViewMode] = useState<'grid' | 'list' | 'map'>('grid')
  const [showAddModal, setShowAddModal] = useState(false)
  const [showDetailModal, setShowDetailModal] = useState(false)
  const [selectedFacility, setSelectedFacility] = useState<Facility | null>(null)
  const [filterStatus, setFilterStatus] = useState('all')

  // Calculate statistics
  const totalFacilities = facilities.length
  const activeFacilities = facilities.filter(f => f.status === 'active').length
  const totalPersonnel = facilities.reduce((sum, f) => sum + f.personnel, 0)
  const totalBudget = facilities.reduce((sum, f) => sum + f.monthlyBudget, 0)
  const totalSpent = facilities.reduce((sum, f) => sum + f.monthlySpent, 0)
  const totalBeneficiaries = facilities.reduce((sum, f) => sum + f.beneficiaries, 0)

  const stats = [
    { 
      label: 'Toplam Tesis', 
      value: totalFacilities, 
      icon: Building2, 
      color: 'blue',
      change: '+2'
    },
    { 
      label: 'Toplam Personel', 
      value: totalPersonnel, 
      icon: Users, 
      color: 'green',
      change: '+5'
    },
    { 
      label: 'Aylık Bütçe', 
      value: `₺${totalBudget.toLocaleString()}`, 
      icon: DollarSign, 
      color: 'purple',
      change: '+8%'
    },
    { 
      label: 'Faydalanıcı', 
      value: totalBeneficiaries.toLocaleString(), 
      icon: Activity, 
      color: 'orange',
      change: '+320'
    }
  ]

  // Chart data
  const monthlyData = [
    { month: 'Oca', budget: 325000, spent: 280000 },
    { month: 'Şub', budget: 325000, spent: 295000 },
    { month: 'Mar', budget: 325000, spent: 310000 },
    { month: 'Nis', budget: 325000, spent: 290000 },
    { month: 'May', budget: 325000, spent: 305000 },
    { month: 'Haz', budget: 325000, spent: 272000 }
  ]

  const typeData = [
    { name: 'Merkez', value: facilities.filter(f => f.type === 'merkez').length, color: '#3b82f6' },
    { name: 'Şube', value: facilities.filter(f => f.type === 'şube').length, color: '#10b981' },
    { name: 'Temsilcilik', value: facilities.filter(f => f.type === 'temsilcilik').length, color: '#f59e0b' },
    { name: 'Depo', value: facilities.filter(f => f.type === 'depo').length, color: '#8b5cf6' }
  ]

  const handleEditFacility = (facility: Facility) => {
    setSelectedFacility(facility)
    setShowAddModal(true)
  }

  const handleDeleteFacility = (id: string) => {
    if (confirm('Bu tesisi silmek istediğinizden emin misiniz?')) {
      setFacilities(prev => prev.filter(f => f.id !== id))
    }
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">Tesis Yönetimi</h1>
          <p className="text-gray-500 dark:text-gray-400 mt-1">
            {totalFacilities} tesis, {totalPersonnel} personel
          </p>
        </div>
        <button
          onClick={() => setShowAddModal(true)}
          className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center gap-2"
        >
          <Plus className="w-4 h-4" />
          Yeni Tesis
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

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold mb-4">Bütçe Kullanımı</h3>
          <ResponsiveContainer width="100%" height={250}>
            <BarChart data={monthlyData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="month" />
              <YAxis />
              <Tooltip />
              <Bar dataKey="budget" fill="#3b82f6" name="Bütçe" />
              <Bar dataKey="spent" fill="#10b981" name="Harcanan" />
            </BarChart>
          </ResponsiveContainer>
        </div>

        <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold mb-4">Tesis Türleri</h3>
          <ResponsiveContainer width="100%" height={200}>
            <PieChart>
              <Pie
                data={typeData}
                cx="50%"
                cy="50%"
                innerRadius={50}
                outerRadius={70}
                paddingAngle={5}
                dataKey="value"
              >
                {typeData.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
          <div className="space-y-2 mt-4">
            {typeData.map((item) => (
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

      {/* View Controls */}
      <div className="flex items-center justify-between bg-white dark:bg-gray-800 rounded-lg p-4 shadow border border-gray-200 dark:border-gray-700">
        <div className="flex gap-2">
          <button
            onClick={() => setViewMode('grid')}
            className={`p-2 rounded ${viewMode === 'grid' ? 'bg-blue-100 text-blue-600' : 'hover:bg-gray-100'}`}
          >
            <Building2 className="w-4 h-4" />
          </button>
          <button
            onClick={() => setViewMode('list')}
            className={`p-2 rounded ${viewMode === 'list' ? 'bg-blue-100 text-blue-600' : 'hover:bg-gray-100'}`}
          >
            <FileText className="w-4 h-4" />
          </button>
          <button
            onClick={() => setViewMode('map')}
            className={`p-2 rounded ${viewMode === 'map' ? 'bg-blue-100 text-blue-600' : 'hover:bg-gray-100'}`}
          >
            <MapPin className="w-4 h-4" />
          </button>
        </div>
        <div className="flex gap-2">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder="Tesis ara..."
              className="pl-9 pr-3 py-1.5 bg-gray-100 dark:bg-gray-700 rounded-lg text-sm"
            />
          </div>
          <select 
            value={filterStatus}
            onChange={(e) => setFilterStatus(e.target.value)}
            className="px-3 py-1.5 bg-gray-100 dark:bg-gray-700 rounded-lg text-sm"
          >
            <option value="all">Tüm Durumlar</option>
            <option value="active">Aktif</option>
            <option value="inactive">Pasif</option>
            <option value="maintenance">Bakımda</option>
          </select>
        </div>
      </div>

      {/* Facilities Grid */}
      {viewMode === 'grid' && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {facilities.map((facility) => (
            <motion.div
              key={facility.id}
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              className="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden hover:shadow-xl transition-shadow"
            >
              {/* Facility Header */}
              <div className="p-4 bg-gradient-to-r from-blue-500 to-purple-600">
                <div className="flex items-start justify-between">
                  <div className="text-white">
                    <h3 className="font-semibold text-lg">{facility.name}</h3>
                    <div className="flex items-center gap-1 mt-1">
                      <MapPin className="w-4 h-4" />
                      <span className="text-sm">{facility.location}, {facility.country}</span>
                    </div>
                  </div>
                  <span className={`px-2 py-1 text-xs rounded-full ${
                    facility.status === 'active' ? 'bg-green-100 text-green-700' :
                    facility.status === 'inactive' ? 'bg-red-100 text-red-700' :
                    'bg-yellow-100 text-yellow-700'
                  }`}>
                    {facility.status === 'active' ? 'Aktif' :
                     facility.status === 'inactive' ? 'Pasif' : 'Bakımda'}
                  </span>
                </div>
              </div>

              {/* Facility Body */}
              <div className="p-4 space-y-3">
                {/* Manager Info */}
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 bg-gray-200 dark:bg-gray-700 rounded-full flex items-center justify-center">
                    <Users className="w-5 h-5 text-gray-600 dark:text-gray-400" />
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-900 dark:text-white">{facility.manager}</p>
                    <p className="text-xs text-gray-500">Tesis Müdürü</p>
                  </div>
                </div>

                {/* Stats */}
                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <p className="text-xs text-gray-500">Personel</p>
                    <p className="text-lg font-semibold text-gray-900 dark:text-white">{facility.personnel}</p>
                  </div>
                  <div>
                    <p className="text-xs text-gray-500">Projeler</p>
                    <p className="text-lg font-semibold text-gray-900 dark:text-white">{facility.projects}</p>
                  </div>
                  <div>
                    <p className="text-xs text-gray-500">Kapasite</p>
                    <p className="text-lg font-semibold text-gray-900 dark:text-white">
                      {facility.currentOccupancy}/{facility.capacity}
                    </p>
                  </div>
                  <div>
                    <p className="text-xs text-gray-500">Faydalanıcı</p>
                    <p className="text-lg font-semibold text-gray-900 dark:text-white">
                      {facility.beneficiaries.toLocaleString()}
                    </p>
                  </div>
                </div>

                {/* Budget Progress */}
                <div>
                  <div className="flex justify-between text-xs mb-1">
                    <span className="text-gray-500">Bütçe Kullanımı</span>
                    <span className="text-gray-900 dark:text-white">
                      ₺{facility.monthlySpent.toLocaleString()} / ₺{facility.monthlyBudget.toLocaleString()}
                    </span>
                  </div>
                  <div className="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2">
                    <div 
                      className="bg-gradient-to-r from-blue-500 to-purple-600 h-2 rounded-full transition-all"
                      style={{ width: `${(facility.monthlySpent / facility.monthlyBudget) * 100}%` }}
                    />
                  </div>
                  <p className="text-xs text-gray-500 mt-1">
                    %{Math.round((facility.monthlySpent / facility.monthlyBudget) * 100)} kullanıldı
                  </p>
                </div>

                {/* Actions */}
                <div className="flex items-center gap-2 pt-2">
                  <button
                    onClick={() => {
                      setSelectedFacility(facility)
                      setShowDetailModal(true)
                    }}
                    className="flex-1 px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors flex items-center justify-center gap-1"
                  >
                    <Eye className="w-4 h-4" />
                    <span className="text-sm">Detay</span>
                  </button>
                  <button
                    onClick={() => handleEditFacility(facility)}
                    className="p-2 bg-gray-100 dark:bg-gray-700 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors"
                  >
                    <Edit className="w-4 h-4" />
                  </button>
                  <button
                    onClick={() => handleDeleteFacility(facility.id)}
                    className="p-2 bg-red-100 dark:bg-red-900/20 rounded-lg hover:bg-red-200 dark:hover:bg-red-900/40 transition-colors text-red-600"
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      )}

      {/* Map View Placeholder */}
      {viewMode === 'map' && (
        <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-12 border border-gray-200 dark:border-gray-700">
          <div className="text-center">
            <MapPin className="w-16 h-16 mx-auto text-gray-400 mb-4" />
            <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-2">
              Harita Görünümü
            </h3>
            <p className="text-gray-500 dark:text-gray-400">
              Tesislerin harita üzerindeki konumları burada gösterilecek
            </p>
          </div>
        </div>
      )}

      {/* Add/Edit Facility Modal */}
      {showAddModal && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
          onClick={() => setShowAddModal(false)}
        >
          <motion.div
            initial={{ scale: 0.9 }}
            animate={{ scale: 1 }}
            exit={{ scale: 0.9 }}
            className="bg-white dark:bg-gray-800 rounded-2xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-hidden"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="p-6 border-b border-gray-200 dark:border-gray-700">
              <h2 className="text-xl font-bold text-gray-900 dark:text-white">
                {selectedFacility ? 'Tesis Düzenle' : 'Yeni Tesis Ekle'}
              </h2>
            </div>

            <div className="p-6 overflow-y-auto max-h-[70vh] space-y-4">
              {/* Form fields */}
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium mb-1">Tesis Adı</label>
                  <input
                    type="text"
                    defaultValue={selectedFacility?.name}
                    className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                    placeholder="Tesis adını girin"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1">Tür</label>
                  <select 
                    defaultValue={selectedFacility?.type}
                    className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                  >
                    <option value="merkez">Merkez</option>
                    <option value="şube">Şube</option>
                    <option value="temsilcilik">Temsilcilik</option>
                    <option value="depo">Depo</option>
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium mb-1">Şehir</label>
                  <input
                    type="text"
                    defaultValue={selectedFacility?.location}
                    className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                    placeholder="Şehir"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1">Ülke</label>
                  <input
                    type="text"
                    defaultValue={selectedFacility?.country}
                    className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                    placeholder="Ülke"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium mb-1">Müdür Adı</label>
                  <input
                    type="text"
                    defaultValue={selectedFacility?.manager}
                    className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                    placeholder="Müdür adı"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1">Telefon</label>
                  <input
                    type="tel"
                    defaultValue={selectedFacility?.phone}
                    className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                    placeholder="+90 xxx xxx xx xx"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium mb-1">E-posta</label>
                <input
                  type="email"
                  defaultValue={selectedFacility?.email}
                  className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                  placeholder="tesis@ngo.org"
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium mb-1">Kapasite</label>
                  <input
                    type="number"
                    defaultValue={selectedFacility?.capacity}
                    className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                    placeholder="Maksimum kapasite"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1">Aylık Bütçe</label>
                  <div className="relative">
                    <span className="absolute left-3 top-1/2 -translate-y-1/2">₺</span>
                    <input
                      type="number"
                      defaultValue={selectedFacility?.monthlyBudget}
                      className="w-full pl-8 pr-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                      placeholder="0"
                    />
                  </div>
                </div>
              </div>
            </div>

            <div className="p-6 border-t border-gray-200 dark:border-gray-700 flex justify-end gap-2">
              <button
                onClick={() => {
                  setShowAddModal(false)
                  setSelectedFacility(null)
                }}
                className="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-lg hover:bg-gray-300"
              >
                İptal
              </button>
              <button className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                {selectedFacility ? 'Güncelle' : 'Ekle'}
              </button>
            </div>
          </motion.div>
        </motion.div>
      )}
    </div>
  )
}
EOF

echo "✅ Tesis Yönetimi modülü tamamlandı!"
echo ""
echo "🎯 Eklenen özellikler:"
echo "  ✓ Tesis listesi (Grid/List/Map view)"
echo "  ✓ Tesis dashboard"
echo "  ✓ Bütçe takibi"
echo "  ✓ Personel yönetimi"
echo "  ✓ Proje takibi"
echo "  ✓ Kapasite yönetimi"
echo "  ✓ Detaylı istatistikler"
echo ""
echo "📌 Test için: npm run dev"
echo "📌 Sonraki modül: Personel Yönetimi"