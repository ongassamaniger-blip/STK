'use client'

import { useState } from 'react'
import { motion } from 'framer-motion'
import {
  X, Maximize2, Minimize2, Settings, Move, RefreshCw,
  MoreVertical, Download, Share2, Eye
} from 'lucide-react'
import {
  LineChart, Line, AreaChart, Area, BarChart, Bar,
  XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
  PieChart, Pie, Cell, RadialBarChart, RadialBar
} from 'recharts'

interface DashboardWidgetProps {
  widget: any
  onRemove: (id: string) => void
  onMaximize: (id: string) => void
  isEditMode: boolean
}

export default function DashboardWidget({ 
  widget, 
  onRemove, 
  onMaximize, 
  isEditMode 
}: DashboardWidgetProps) {
  const [showMenu, setShowMenu] = useState(false)
  const [isRefreshing, setIsRefreshing] = useState(false)

  const handleRefresh = () => {
    setIsRefreshing(true)
    setTimeout(() => setIsRefreshing(false), 1000)
  }

  const getSizeClasses = () => {
    switch (widget.size) {
      case 'small': return 'col-span-1'
      case 'medium': return 'col-span-1 lg:col-span-2'
      case 'large': return 'col-span-1 lg:col-span-3'
      case 'full': return 'col-span-1 lg:col-span-4'
      default: return 'col-span-1'
    }
  }

  return (
    <motion.div
      layout
      initial={{ opacity: 0, scale: 0.9 }}
      animate={{ opacity: 1, scale: 1 }}
      exit={{ opacity: 0, scale: 0.9 }}
      whileDrag={isEditMode ? { scale: 0.95 } : false}
      drag={isEditMode}
      dragConstraints={{ left: 0, right: 0, top: 0, bottom: 0 }}
      dragElastic={0.1}
      className={`${getSizeClasses()} bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden group relative ${
        isEditMode ? 'cursor-move' : ''
      }`}
    >
      {/* Widget Header */}
      <div className="p-4 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className={`p-2 bg-${widget.color}-100 dark:bg-${widget.color}-900/20 rounded-lg`}>
            <widget.icon className={`w-4 h-4 text-${widget.color}-600`} />
          </div>
          <h3 className="text-sm font-semibold text-gray-900 dark:text-white">
            {widget.title}
          </h3>
        </div>

        <div className="flex items-center gap-1">
          {isEditMode && (
            <button className="p-1 hover:bg-gray-100 dark:hover:bg-gray-700 rounded opacity-0 group-hover:opacity-100 transition-opacity">
              <Move className="w-4 h-4 text-gray-500" />
            </button>
          )}
          
          <button
            onClick={handleRefresh}
            className="p-1 hover:bg-gray-100 dark:hover:bg-gray-700 rounded"
          >
            <RefreshCw className={`w-4 h-4 text-gray-500 ${isRefreshing ? 'animate-spin' : ''}`} />
          </button>

          <button
            onClick={() => onMaximize(widget.id)}
            className="p-1 hover:bg-gray-100 dark:hover:bg-gray-700 rounded"
          >
            <Maximize2 className="w-4 h-4 text-gray-500" />
          </button>

          <div className="relative">
            <button
              onClick={() => setShowMenu(!showMenu)}
              className="p-1 hover:bg-gray-100 dark:hover:bg-gray-700 rounded"
            >
              <MoreVertical className="w-4 h-4 text-gray-500" />
            </button>

            {showMenu && (
              <div className="absolute right-0 mt-1 w-48 bg-white dark:bg-gray-800 rounded-lg shadow-xl border border-gray-200 dark:border-gray-700 z-10">
                <button className="w-full px-3 py-2 text-left text-sm hover:bg-gray-100 dark:hover:bg-gray-700 flex items-center gap-2">
                  <Settings className="w-4 h-4" /> Ayarlar
                </button>
                <button className="w-full px-3 py-2 text-left text-sm hover:bg-gray-100 dark:hover:bg-gray-700 flex items-center gap-2">
                  <Download className="w-4 h-4" /> İndir
                </button>
                <button className="w-full px-3 py-2 text-left text-sm hover:bg-gray-100 dark:hover:bg-gray-700 flex items-center gap-2">
                  <Share2 className="w-4 h-4" /> Paylaş
                </button>
                <button 
                  onClick={() => onRemove(widget.id)}
                  className="w-full px-3 py-2 text-left text-sm hover:bg-red-50 dark:hover:bg-red-900/20 text-red-600 flex items-center gap-2"
                >
                  <X className="w-4 h-4" /> Kaldır
                </button>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Widget Content */}
      <div className="p-4">
        <div className={`${widget.size === 'small' ? 'h-32' : widget.size === 'medium' ? 'h-48' : 'h-64'}`}>
          {/* Chart or content rendering based on widget type */}
          {widget.type === 'chart' && (
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={widget.data || []}>
                <defs>
                  <linearGradient id={`gradient-${widget.id}`} x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#3b82f6" stopOpacity={0.3}/>
                    <stop offset="95%" stopColor="#3b82f6" stopOpacity={0}/>
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
                <XAxis dataKey="name" stroke="#6b7280" />
                <YAxis stroke="#6b7280" />
                <Tooltip />
                <Area 
                  type="monotone" 
                  dataKey="value" 
                  stroke="#3b82f6" 
                  fillOpacity={1} 
                  fill={`url(#gradient-${widget.id})`} 
                />
              </AreaChart>
            </ResponsiveContainer>
          )}

          {widget.type === 'stats' && (
            <div className="flex items-center justify-center h-full">
              <div className="text-center">
                <p className="text-3xl font-bold text-gray-900 dark:text-white">
                  {widget.data?.value || '0'}
                </p>
                <p className="text-sm text-gray-500 dark:text-gray-400 mt-2">
                  {widget.data?.label || 'Veri yok'}
                </p>
              </div>
            </div>
          )}

          {widget.type === 'pie' && widget.data && (
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie
                  data={widget.data}
                  cx="50%"
                  cy="50%"
                  innerRadius={40}
                  outerRadius={60}
                  paddingAngle={5}
                  dataKey="value"
                >
                  {widget.data.map((entry: any, index: number) => (
                    <Cell key={`cell-${index}`} fill={entry.color || '#8884d8'} />
                  ))}
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          )}
        </div>
      </div>
    </motion.div>
  )
}
