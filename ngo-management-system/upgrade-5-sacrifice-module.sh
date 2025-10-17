#!/bin/bash
# upgrade-5-sacrifice-module.sh
# Modern Sacrifice Management Module
# Date: 2025-10-17 14:55:44
# User: ongassamaniger-blip

echo "🐑 =========================================="
echo "   KURBAN YÖNETİMİ MODÜLÜ"
echo "   Hisse takibi, QR kod, toplu işlemler..."
echo "🐑 =========================================="

# Sacrifice Management Page
cat > "app/(main)/sacrifice/page.tsx" << 'EOF'
'use client'

import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import {
  Plus, Search, Filter, Download, Upload, QrCode,
  Users, Heart, DollarSign, Calendar, MapPin,
  CheckCircle, Clock, AlertCircle, Printer, Share2,
  Edit, Eye, Trash2, ChevronRight, FileText,
  Camera, MessageSquare, Bell, MoreVertical,
  Package, Truck, ChefHat, UserCheck
} from 'lucide-react'
import {
  PieChart, Pie, Cell, BarChart, Bar, XAxis, YAxis,
  CartesianGrid, Tooltip, ResponsiveContainer
} from 'recharts'

interface Sacrifice {
  id: string
  code: string
  type: 'büyükbaş' | 'küçükbaş'
  totalShares: number
  soldShares: number
  pricePerShare: number
  location: string
  deliveryDate: string
  status: 'bekliyor' | 'kesildi' | 'dağıtıldı'
  donors: {
    id: string
    name: string
    phone: string
    shares: number
    paid: boolean
    notified: boolean
  }[]
  images: string[]
  notes: string
}

export default function SacrificePage() {
  const [sacrifices, setSacrifices] = useState<Sacrifice[]>([
    {
      id: '1',
      code: 'KRB2025001',
      type: 'büyükbaş',
      totalShares: 7,
      soldShares: 5,
      pricePerShare: 7000,
      location: 'Nijer - Niamey',
      deliveryDate: '2025-06-28',
      status: 'bekliyor',
      donors: [
        { id: '1', name: 'Ahmet Yılmaz', phone: '5551234567', shares: 2, paid: true, notified: false },
        { id: '2', name: 'Mehmet Öz', phone: '5559876543', shares: 3, paid: true, notified: false }
      ],
      images: [],
      notes: 'Bayram 1. gün kesilecek'
    },
    {
      id: '2',
      code: 'KRB2025002',
      type: 'küçükbaş',
      totalShares: 1,
      soldShares: 1,
      pricePerShare: 12000,
      location: 'Senegal - Dakar',
      deliveryDate: '2025-06-29',
      status: 'bekliyor',
      donors: [
        { id: '3', name: 'Fatma Kaya', phone: '5552223344', shares: 1, paid: true, notified: true }
      ],
      images: [],
      notes: ''
    }
  ])

  const [showAddModal, setShowAddModal] = useState(false)
  const [showDetailModal, setShowDetailModal] = useState(false)
  const [selectedSacrifice, setSelectedSacrifice] = useState<Sacrifice | null>(null)
  const [sacrificeType, setSacrificeType] = useState<'büyükbaş' | 'küçükbaş'>('büyükbaş')
  const [shareCount, setShareCount] = useState(1)
  const [bulkAction, setBulkAction] = useState('')
  const [selectedItems, setSelectedItems] = useState<string[]>([])

  // Statistics
  const totalSacrifices = sacrifices.length
  const totalShares = sacrifices.reduce((sum, s) => sum + s.totalShares, 0)
  const soldShares = sacrifices.reduce((sum, s) => sum + s.soldShares, 0)
  const totalRevenue = sacrifices.reduce((sum, s) => sum + (s.soldShares * s.pricePerShare), 0)
  const completedCount = sacrifices.filter(s => s.status === 'dağıtıldı').length

  const stats = [
    { 
      label: 'Toplam Kurban', 
      value: totalSacrifices, 
      icon: Heart, 
      color: 'red',
      change: '+5'
    },
    { 
      label: 'Satılan Hisse', 
      value: `${soldShares}/${totalShares}`, 
      icon: Users, 
      color: 'blue',
      change: `%${Math.round(soldShares/totalShares*100)}`
    },
    { 
      label: 'Toplam Gelir', 
      value: `₺${totalRevenue.toLocaleString()}`, 
      icon: DollarSign, 
      color: 'green',
      change: '+12%'
    },
    { 
      label: 'Tamamlanan', 
      value: completedCount, 
      icon: CheckCircle, 
      color: 'purple',
      change: `${completedCount} kurban`
    }
  ]

  // Chart data
  const locationData = [
    { name: 'Nijer', value: 12, color: '#3b82f6' },
    { name: 'Senegal', value: 8, color: '#10b981' },
    { name: 'Mali', value: 5, color: '#f59e0b' },
    { name: 'Burkina', value: 3, color: '#8b5cf6' }
  ]

  const typeData = [
    { type: 'Büyükbaş', count: sacrifices.filter(s => s.type === 'büyükbaş').length },
    { type: 'Küçükbaş', count: sacrifices.filter(s => s.type === 'küçükbaş').length }
  ]

  const handleBulkAction = () => {
    if (bulkAction === 'kesildi') {
      setSacrifices(prev => prev.map(s => 
        selectedItems.includes(s.id) ? { ...s, status: 'kesildi' } : s
      ))
    } else if (bulkAction === 'dağıtıldı') {
      setSacrifices(prev => prev.map(s => 
        selectedItems.includes(s.id) ? { ...s, status: 'dağıtıldı' } : s
      ))
    }
    setSelectedItems([])
    setBulkAction('')
  }

  const generateQRCode = (sacrifice: Sacrifice) => {
    // QR kod oluşturma
    console.log('QR Code for:', sacrifice.code)
  }

  const printCertificate = (sacrifice: Sacrifice) => {
    // Sertifika yazdırma
    console.log('Printing certificate for:', sacrifice.code)
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">Kurban Yönetimi</h1>
          <p className="text-gray-500 dark:text-gray-400 mt-1">
            {totalSacrifices} kurban, {soldShares} hisse satıldı
          </p>
        </div>
        <div className="flex items-center gap-2">
          <button className="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-lg hover:bg-gray-300 dark:hover:bg-gray-600 flex items-center gap-2">
            <Upload className="w-4 h-4" />
            İçe Aktar
          </button>
          <button
            onClick={() => setShowAddModal(true)}
            className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 flex items-center gap-2"
          >
            <Plus className="w-4 h-4" />
            Kurban Ekle
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
        <div className="lg:col-span-2 bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold mb-4">Kurban Türü Dağılımı</h3>
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={typeData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="type" />
              <YAxis />
              <Tooltip />
              <Bar dataKey="count" fill="#ef4444" />
            </BarChart>
          </ResponsiveContainer>
        </div>

        <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold mb-4">Lokasyon Dağılımı</h3>
          <ResponsiveContainer width="100%" height={200}>
            <PieChart>
              <Pie
                data={locationData}
                cx="50%"
                cy="50%"
                innerRadius={50}
                outerRadius={70}
                paddingAngle={5}
                dataKey="value"
              >
                {locationData.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Bulk Actions Bar */}
      {selectedItems.length > 0 && (
        <div className="bg-blue-50 dark:bg-blue-900/20 rounded-lg p-4 flex items-center justify-between">
          <span className="text-sm text-blue-600 dark:text-blue-400">
            {selectedItems.length} kurban seçildi
          </span>
          <div className="flex items-center gap-2">
            <select 
              value={bulkAction}
              onChange={(e) => setBulkAction(e.target.value)}
              className="px-3 py-1 text-sm bg-white dark:bg-gray-800 rounded"
            >
              <option value="">İşlem Seçin</option>
              <option value="kesildi">Kesildi Olarak İşaretle</option>
              <option value="dağıtıldı">Dağıtıldı Olarak İşaretle</option>
              <option value="notify">Toplu Bildirim Gönder</option>
            </select>
            <button
              onClick={handleBulkAction}
              className="px-3 py-1 text-sm bg-blue-600 text-white rounded hover:bg-blue-700"
            >
              Uygula
            </button>
          </div>
        </div>
      )}

      {/* Sacrifice List */}
      <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden">
        <div className="p-4 border-b border-gray-200 dark:border-gray-700">
          <div className="flex items-center gap-4">
            <div className="flex-1 relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="text"
                placeholder="Kurban kodu veya bağışçı ara..."
                className="w-full pl-10 pr-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
              />
            </div>
            <select className="px-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg">
              <option>Tüm Durumlar</option>
              <option>Bekliyor</option>
              <option>Kesildi</option>
              <option>Dağıtıldı</option>
            </select>
            <button className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg">
              <Filter className="w-5 h-5" />
            </button>
          </div>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50 dark:bg-gray-700/50">
              <tr>
                <th className="w-12 px-6 py-3">
                  <input
                    type="checkbox"
                    onChange={(e) => {
                      if (e.target.checked) {
                        setSelectedItems(sacrifices.map(s => s.id))
                      } else {
                        setSelectedItems([])
                      }
                    }}
                    className="rounded"
                  />
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  Kod / Tür
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  Hisse Durumu
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  Lokasyon
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  Tarih
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
              {sacrifices.map((sacrifice) => (
                <tr key={sacrifice.id} className="hover:bg-gray-50 dark:hover:bg-gray-700/50">
                  <td className="px-6 py-4">
                    <input
                      type="checkbox"
                      checked={selectedItems.includes(sacrifice.id)}
                      onChange={(e) => {
                        if (e.target.checked) {
                          setSelectedItems([...selectedItems, sacrifice.id])
                        } else {
                          setSelectedItems(selectedItems.filter(id => id !== sacrifice.id))
                        }
                      }}
                      className="rounded"
                    />
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className={`p-2 rounded-lg ${
                        sacrifice.type === 'büyükbaş' ? 'bg-orange-100 text-orange-600' : 'bg-green-100 text-green-600'
                      }`}>
                        <Package className="w-4 h-4" />
                      </div>
                      <div>
                        <p className="font-medium text-gray-900 dark:text-white">{sacrifice.code}</p>
                        <p className="text-sm text-gray-500 capitalize">{sacrifice.type}</p>
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div>
                      <p className="text-sm font-medium">
                        {sacrifice.soldShares}/{sacrifice.totalShares} Hisse
                      </p>
                      <div className="w-24 bg-gray-200 rounded-full h-1.5 mt-1">
                        <div 
                          className="bg-red-600 h-1.5 rounded-full"
                          style={{ width: `${(sacrifice.soldShares/sacrifice.totalShares)*100}%` }}
                        />
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-1">
                      <MapPin className="w-4 h-4 text-gray-400" />
                      <span className="text-sm">{sacrifice.location}</span>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div>
                      <p className="text-sm">{new Date(sacrifice.deliveryDate).toLocaleDateString('tr-TR')}</p>
                      <p className="text-xs text-gray-500">Bayram {sacrifice.notes.includes('1.') ? '1.' : '2.'} gün</p>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <span className={`px-2 py-1 text-xs rounded-full ${
                      sacrifice.status === 'dağıtıldı' ? 'bg-green-100 text-green-700' :
                      sacrifice.status === 'kesildi' ? 'bg-blue-100 text-blue-700' :
                      'bg-yellow-100 text-yellow-700'
                    }`}>
                      {sacrifice.status === 'dağıtıldı' ? 'Dağıtıldı' :
                       sacrifice.status === 'kesildi' ? 'Kesildi' : 'Bekliyor'}
                    </span>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center justify-end gap-1">
                      <button
                        onClick={() => generateQRCode(sacrifice)}
                        className="p-1 hover:bg-gray-100 dark:hover:bg-gray-700 rounded"
                        title="QR Kod"
                      >
                        <QrCode className="w-4 h-4 text-gray-600" />
                      </button>
                      <button
                        onClick={() => printCertificate(sacrifice)}
                        className="p-1 hover:bg-gray-100 dark:hover:bg-gray-700 rounded"
                        title="Sertifika"
                      >
                        <FileText className="w-4 h-4 text-gray-600" />
                      </button>
                      <button
                        onClick={() => {
                          setSelectedSacrifice(sacrifice)
                          setShowDetailModal(true)
                        }}
                        className="p-1 hover:bg-gray-100 dark:hover:bg-gray-700 rounded"
                        title="Detay"
                      >
                        <Eye className="w-4 h-4 text-blue-600" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Add Sacrifice Modal */}
      <AnimatePresence>
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
                <h2 className="text-xl font-bold">Kurban Ekle</h2>
              </div>

              <div className="p-6 overflow-y-auto max-h-[70vh] space-y-4">
                {/* Kurban Type */}
                <div>
                  <label className="block text-sm font-medium mb-2">Kurban Cinsi</label>
                  <div className="grid grid-cols-2 gap-4">
                    <button
                      type="button"
                      onClick={() => {
                        setSacrificeType('büyükbaş')
                        setShareCount(1)
                      }}
                      className={`p-4 rounded-lg border-2 ${
                        sacrificeType === 'büyükbaş' 
                          ? 'border-red-500 bg-red-50' 
                          : 'border-gray-200 hover:border-gray-300'
                      }`}
                    >
                      <Package className="w-8 h-8 mx-auto mb-2 text-red-600" />
                      <p className="font-medium">Büyükbaş</p>
                      <p className="text-sm text-gray-500">Max 7 hisse</p>
                    </button>
                    <button
                      type="button"
                      onClick={() => {
                        setSacrificeType('küçükbaş')
                        setShareCount(1)
                      }}
                      className={`p-4 rounded-lg border-2 ${
                        sacrificeType === 'küçükbaş' 
                          ? 'border-green-500 bg-green-50' 
                          : 'border-gray-200 hover:border-gray-300'
                      }`}
                    >
                      <Heart className="w-8 h-8 mx-auto mb-2 text-green-600" />
                      <p className="font-medium">Küçükbaş</p>
                      <p className="text-sm text-gray-500">Tek hisse</p>
                    </button>
                  </div>
                </div>

                {/* Share Count */}
                {sacrificeType === 'büyükbaş' && (
                  <div>
                    <label className="block text-sm font-medium mb-2">Hisse Sayısı</label>
                    <select 
                      value={shareCount}
                      onChange={(e) => setShareCount(Number(e.target.value))}
                      className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                    >
                      {[1, 2, 3, 4, 5, 6, 7].map(n => (
                        <option key={n} value={n}>{n} Hisse</option>
                      ))}
                    </select>
                  </div>
                )}

                {/* Location */}
                <div>
                  <label className="block text-sm font-medium mb-2">Kesim Yeri</label>
                  <select className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg">
                    <option>Nijer - Niamey</option>
                    <option>Senegal - Dakar</option>
                    <option>Mali - Bamako</option>
                    <option>Burkina Faso - Ouagadougou</option>
                  </select>
                </div>

                {/* Price per Share */}
                <div>
                  <label className="block text-sm font-medium mb-2">Hisse Fiyatı</label>
                  <div className="relative">
                    <span className="absolute left-3 top-1/2 -translate-y-1/2">₺</span>
                    <input
                      type="number"
                      placeholder="0"
                      className="w-full pl-8 pr-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                    />
                  </div>
                  {sacrificeType === 'büyükbaş' && shareCount > 1 && (
                    <p className="text-sm text-gray-500 mt-1">
                      Toplam: ₺{(7000 * shareCount).toLocaleString()} ({shareCount} hisse)
                    </p>
                  )}
                </div>

                {/* Delivery Date */}
                <div>
                  <label className="block text-sm font-medium mb-2">Kesim Tarihi</label>
                  <input
                    type="date"
                    className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                  />
                </div>

                {/* Donors */}
                <div>
                  <label className="block text-sm font-medium mb-2">Bağışçılar</label>
                  <div className="space-y-2">
                    {Array.from({ length: shareCount }).map((_, index) => (
                      <div key={index} className="flex gap-2">
                        <input
                          type="text"
                          placeholder={`${index + 1}. Bağışçı adı`}
                          className="flex-1 px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                        />
                        <input
                          type="tel"
                          placeholder="Telefon"
                          className="w-32 px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                        />
                      </div>
                    ))}
                  </div>
                  <button 
                    type="button"
                    className="mt-2 text-sm text-blue-600 hover:underline"
                  >
                    + Toplu bağışçı ekle (Excel)
                  </button>
                </div>
              </div>

              <div className="p-6 border-t border-gray-200 dark:border-gray-700 flex justify-end gap-2">
                <button
                  onClick={() => setShowAddModal(false)}
                  className="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-lg hover:bg-gray-300"
                >
                  İptal
                </button>
                <button className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700">
                  Kaydet
                </button>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}
EOF

echo "✅ Kurban Yönetimi modülü tamamlandı!"
echo "📌 Base Components paketi oluşturuluyor..."