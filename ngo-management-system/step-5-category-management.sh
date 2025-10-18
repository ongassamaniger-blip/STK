#!/bin/bash
# step-5-category-management.sh
# Dynamic Category Management System
# Date: 2025-10-18 19:52:55
# User: ongassamaniger-blip

echo "📂 =========================================="
echo "   ADIM 5: DİNAMİK KATEGORİ YÖNETİMİ"
echo "   Facility-based categories, hierarchical structure..."
echo "📂 =========================================="

# 1. Category Types
cat > "types/categories.ts" << 'ENDMARKER'
export interface Category {
  id: string
  name: string
  nameTranslations?: {
    tr?: string
    en?: string
    ar?: string
    fr?: string
  }
  type: 'income' | 'expense' | 'project' | 'sacrifice' | 'custom'
  facilityId?: string // Tesis özel kategori
  projectId?: string  // Proje özel kategori
  isGlobal: boolean   // Tüm sistem için geçerli
  
  // Hiyerarşi
  parentId?: string
  children?: Category[]
  level: number
  path: string // /parent/child/subchild
  
  // Görünüm
  icon?: string
  color?: string
  emoji?: string
  
  // Muhasebe
  accountCode?: string
  taxRate?: number
  vatIncluded?: boolean
  
  // Kurallar
  rules?: {
    minAmount?: number
    maxAmount?: number
    requiresApproval?: boolean
    approvalThreshold?: number
    allowedUserRoles?: string[]
    allowedFacilities?: string[]
    validFrom?: string
    validTo?: string
  }
  
  // Meta
  isActive: boolean
  isSystem: boolean // Sistem kategorisi silinemez
  order: number
  createdBy: string
  createdAt: string
  updatedAt: string
}

export interface CategoryTemplate {
  id: string
  name: string
  description: string
  type: 'income' | 'expense' | 'project' | 'sacrifice'
  categories: Partial<Category>[]
}
ENDMARKER

# 2. Category Context
cat > "contexts/CategoryContext.tsx" << 'ENDMARKER'
'use client'

import React, { createContext, useContext, useState, useEffect } from 'react'
import { Category } from '@/types/categories'
import { useFacility } from '@/contexts/FacilityContext'

interface CategoryContextType {
  categories: Category[]
  incomeCategories: Category[]
  expenseCategories: Category[]
  projectCategories: Category[]
  
  getCategoryById: (id: string) => Category | undefined
  getCategoriesByType: (type: Category['type']) => Category[]
  getCategoriesForFacility: (facilityId?: string) => Category[]
  getCategoryPath: (categoryId: string) => string
  
  addCategory: (category: Partial<Category>) => Promise<void>
  updateCategory: (id: string, updates: Partial<Category>) => Promise<void>
  deleteCategory: (id: string) => Promise<void>
  
  loading: boolean
  refreshCategories: () => Promise<void>
}

const CategoryContext = createContext<CategoryContextType | undefined>(undefined)

export function CategoryProvider({ children }: { children: React.ReactNode }) {
  const { currentFacility } = useFacility()
  const [categories, setCategories] = useState<Category[]>([])
  const [loading, setLoading] = useState(true)
  
  useEffect(() => {
    loadCategories()
  }, [currentFacility])
  
  const loadCategories = async () => {
    setLoading(true)
    
    // Mock data - gerçekte API'den gelecek
    const mockCategories: Category[] = [
      // Global Income Categories
      {
        id: 'inc_1',
        name: 'Bağışlar',
        type: 'income',
        isGlobal: true,
        level: 0,
        path: '/bagislar',
        icon: 'gift',
        color: '#10b981',
        accountCode: '100',
        isActive: true,
        isSystem: true,
        order: 1,
        createdBy: 'system',
        createdAt: '2025-01-01',
        updatedAt: '2025-01-01',
        children: [
          {
            id: 'inc_1_1',
            name: 'Nakit Bağışlar',
            type: 'income',
            parentId: 'inc_1',
            isGlobal: true,
            level: 1,
            path: '/bagislar/nakit',
            accountCode: '100.01',
            isActive: true,
            isSystem: false,
            order: 1,
            createdBy: 'admin',
            createdAt: '2025-01-01',
            updatedAt: '2025-01-01'
          },
          {
            id: 'inc_1_2',
            name: 'Ayni Bağışlar',
            type: 'income',
            parentId: 'inc_1',
            isGlobal: true,
            level: 1,
            path: '/bagislar/ayni',
            accountCode: '100.02',
            isActive: true,
            isSystem: false,
            order: 2,
            createdBy: 'admin',
            createdAt: '2025-01-01',
            updatedAt: '2025-01-01'
          }
        ]
      },
      // Nijer Facility Specific Categories
      {
        id: 'exp_nijer_1',
        name: 'Su Kuyusu Giderleri',
        nameTranslations: {
          fr: 'Dépenses de puits',
          ar: 'مصاريف بئر الماء'
        },
        type: 'expense',
        facilityId: 'nijer',
        isGlobal: false,
        level: 0,
        path: '/su-kuyusu',
        icon: 'droplet',
        color: '#3b82f6',
        accountCode: '500.10',
        isActive: true,
        isSystem: false,
        order: 1,
        createdBy: 'facility_manager',
        createdAt: '2025-02-01',
        updatedAt: '2025-02-01',
        rules: {
          minAmount: 1000,
          maxAmount: 100000,
          requiresApproval: true,
          approvalThreshold: 50000
        }
      }
    ]
    
    setCategories(mockCategories)
    setLoading(false)
  }
  
  const getCategoryById = (id: string): Category | undefined => {
    const findCategory = (cats: Category[]): Category | undefined => {
      for (const cat of cats) {
        if (cat.id === id) return cat
        if (cat.children) {
          const found = findCategory(cat.children)
          if (found) return found
        }
      }
      return undefined
    }
    return findCategory(categories)
  }
  
  const getCategoriesByType = (type: Category['type']): Category[] => {
    return categories.filter(cat => cat.type === type)
  }
  
  const getCategoriesForFacility = (facilityId?: string): Category[] => {
    const targetFacilityId = facilityId || currentFacility?.id
    
    return categories.filter(cat =>
      cat.isGlobal ||
      cat.facilityId === targetFacilityId ||
      cat.rules?.allowedFacilities?.includes(targetFacilityId || '')
    )
  }
  
  const getCategoryPath = (categoryId: string): string => {
    const category = getCategoryById(categoryId)
    if (!category) return ''
    
    const buildPath = (cat: Category): string => {
      if (cat.parentId) {
        const parent = getCategoryById(cat.parentId)
        if (parent) {
          return `${buildPath(parent)} / ${cat.name}`
        }
      }
      return cat.name
    }
    
    return buildPath(category)
  }
  
  const addCategory = async (category: Partial<Category>) => {
    const newCategory: Category = {
      id: `cat_${Date.now()}`,
      name: category.name || '',
      type: category.type || 'expense',
      isGlobal: category.isGlobal || false,
      level: category.level || 0,
      path: category.path || '',
      isActive: true,
      isSystem: false,
      order: categories.length + 1,
      createdBy: 'current_user',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      ...category
    }
    
    setCategories([...categories, newCategory])
  }
  
  const updateCategory = async (id: string, updates: Partial<Category>) => {
    const updateCategoryRecursive = (cats: Category[]): Category[] => {
      return cats.map(cat => {
        if (cat.id === id) {
          return { ...cat, ...updates, updatedAt: new Date().toISOString() }
        }
        if (cat.children) {
          return { ...cat, children: updateCategoryRecursive(cat.children) }
        }
        return cat
      })
    }
    
    setCategories(updateCategoryRecursive(categories))
  }
  
  const deleteCategory = async (id: string) => {
    const deleteCategoryRecursive = (cats: Category[]): Category[] => {
      return cats.filter(cat => {
        if (cat.id === id) return false
        if (cat.children) {
          cat.children = deleteCategoryRecursive(cat.children)
        }
        return true
      })
    }
    
    setCategories(deleteCategoryRecursive(categories))
  }
  
  const incomeCategories = categories.filter(c => c.type === 'income')
  const expenseCategories = categories.filter(c => c.type === 'expense')
  const projectCategories = categories.filter(c => c.type === 'project')
  
  return (
    <CategoryContext.Provider
      value={{
        categories,
        incomeCategories,
        expenseCategories,
        projectCategories,
        getCategoryById,
        getCategoriesByType,
        getCategoriesForFacility,
        getCategoryPath,
        addCategory,
        updateCategory,
        deleteCategory,
        loading,
        refreshCategories: loadCategories
      }}
    >
      {children}
    </CategoryContext.Provider>
  )
}

export function useCategories() {
  const context = useContext(CategoryContext)
  if (context === undefined) {
    throw new Error('useCategories must be used within a CategoryProvider')
  }
  return context
}
ENDMARKER

# 3. Category Manager Component
cat > "components/CategoryManager/index.tsx" << 'ENDMARKER'
'use client'

import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import {
  Folder, FolderOpen, Plus, Edit, Trash2, ChevronRight,
  ChevronDown, Tag, DollarSign, TrendingUp, TrendingDown,
  Globe, Building2, Lock, Settings, Search, Filter,
  FileText, Download, Upload, Copy
} from 'lucide-react'
import { Category } from '@/types/categories'
import { useCategories } from '@/contexts/CategoryContext'
import { useFacility } from '@/contexts/FacilityContext'
import { CategoryTree } from './CategoryTree'
import { CategoryForm } from './CategoryForm'

export function CategoryManager() {
  const { categories, addCategory, updateCategory, deleteCategory } = useCategories()
  const { currentFacility } = useFacility()
  const [selectedCategory, setSelectedCategory] = useState<Category | null>(null)
  const [showForm, setShowForm] = useState(false)
  const [editMode, setEditMode] = useState(false)
  const [activeTab, setActiveTab] = useState<'income' | 'expense' | 'project' | 'all'>('all')
  const [searchQuery, setSearchQuery] = useState('')
  
  const filteredCategories = categories.filter(cat => {
    // Filter by tab
    if (activeTab !== 'all' && cat.type !== activeTab) return false
    
    // Filter by search
    if (searchQuery && !cat.name.toLowerCase().includes(searchQuery.toLowerCase())) return false
    
    // Filter by facility
    if (!cat.isGlobal && cat.facilityId !== currentFacility?.id) return false
    
    return true
  })
  
  const handleEdit = (category: Category) => {
    setSelectedCategory(category)
    setEditMode(true)
    setShowForm(true)
  }
  
  const handleDelete = async (category: Category) => {
    if (category.isSystem) {
      alert('Sistem kategorileri silinemez!')
      return
    }
    
    if (confirm(`"${category.name}" kategorisini silmek istediğinizden emin misiniz?`)) {
      await deleteCategory(category.id)
    }
  }
  
  const handleSubmit = async (data: Partial<Category>) => {
    if (editMode && selectedCategory) {
      await updateCategory(selectedCategory.id, data)
    } else {
      await addCategory({
        ...data,
        facilityId: currentFacility?.id
      })
    }
    
    setShowForm(false)
    setSelectedCategory(null)
    setEditMode(false)
  }
  
  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold">Kategori Yönetimi</h2>
          <p className="text-gray-500">
            {currentFacility?.name || 'Global'} kategorileri
          </p>
        </div>
        <div className="flex items-center gap-2">
          <button className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg">
            <Upload className="w-5 h-5" />
          </button>
          <button className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg">
            <Download className="w-5 h-5" />
          </button>
          <button
            onClick={() => {
              setSelectedCategory(null)
              setEditMode(false)
              setShowForm(true)
            }}
            className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 flex items-center gap-2"
          >
            <Plus className="w-4 h-4" />
            Yeni Kategori
          </button>
        </div>
      </div>
      
      {/* Tabs */}
      <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700">
        <div className="border-b border-gray-200 dark:border-gray-700">
          <div className="flex gap-1 p-1">
            {[
              { value: 'all', label: 'Tümü', icon: Folder },
              { value: 'income', label: 'Gelir', icon: TrendingUp, color: 'green' },
              { value: 'expense', label: 'Gider', icon: TrendingDown, color: 'red' },
              { value: 'project', label: 'Proje', icon: FileText, color: 'blue' }
            ].map((tab) => (
              <button
                key={tab.value}
                onClick={() => setActiveTab(tab.value as any)}
                className={`flex-1 px-4 py-2 rounded-lg flex items-center justify-center gap-2 transition-colors ${
                  activeTab === tab.value
                    ? 'bg-blue-100 dark:bg-blue-900/20 text-blue-600'
                    : 'hover:bg-gray-100 dark:hover:bg-gray-700'
                }`}
              >
                <tab.icon className={`w-4 h-4 ${tab.color ? `text-${tab.color}-500` : ''}`} />
                <span>{tab.label}</span>
              </button>
            ))}
          </div>
        </div>
        
        {/* Search & Filters */}
        <div className="p-4 border-b border-gray-200 dark:border-gray-700">
          <div className="flex gap-4">
            <div className="flex-1 relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Kategori ara..."
                className="w-full pl-10 pr-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
              />
            </div>
            <button className="px-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg hover:bg-gray-200 flex items-center gap-2">
              <Filter className="w-4 h-4" />
              Filtreler
            </button>
          </div>
        </div>
        
        {/* Category Tree */}
        <div className="p-6">
          <CategoryTree
            categories={filteredCategories}
            onEdit={handleEdit}
            onDelete={handleDelete}
            onSelect={setSelectedCategory}
            selectedCategory={selectedCategory}
          />
          
          {filteredCategories.length === 0 && (
            <div className="text-center py-8 text-gray-500">
              <Folder className="w-12 h-12 mx-auto mb-3 text-gray-300" />
              <p>Kategori bulunamadı</p>
            </div>
          )}
        </div>
      </div>
      
      {/* Category Form Modal */}
      <AnimatePresence>
        {showForm && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
            onClick={() => setShowForm(false)}
          >
            <motion.div
              initial={{ scale: 0.9 }}
              animate={{ scale: 1 }}
              exit={{ scale: 0.9 }}
              className="bg-white dark:bg-gray-800 rounded-2xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-hidden"
              onClick={(e) => e.stopPropagation()}
            >
              <CategoryForm
                category={selectedCategory}
                editMode={editMode}
                onSubmit={handleSubmit}
                onCancel={() => setShowForm(false)}
              />
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}
ENDMARKER

# 4. Category Tree Component
cat > "components/CategoryManager/CategoryTree.tsx" << 'ENDMARKER'
'use client'

import { useState } from 'react'
import { Category } from '@/types/categories'
import {
  ChevronRight, ChevronDown, Folder, FolderOpen,
  Globe, Building2, Lock, Edit, Trash2, Plus,
  Tag, Hash
} from 'lucide-react'
import { motion, AnimatePresence } from 'framer-motion'

interface CategoryTreeProps {
  categories: Category[]
  onEdit: (category: Category) => void
  onDelete: (category: Category) => void
  onSelect: (category: Category | null) => void
  selectedCategory: Category | null
  level?: number
}

export function CategoryTree({
  categories,
  onEdit,
  onDelete,
  onSelect,
  selectedCategory,
  level = 0
}: CategoryTreeProps) {
  const [expandedIds, setExpandedIds] = useState<Set<string>>(new Set())
  
  const toggleExpand = (id: string) => {
    const newExpanded = new Set(expandedIds)
    if (newExpanded.has(id)) {
      newExpanded.delete(id)
    } else {
      newExpanded.add(id)
    }
    setExpandedIds(newExpanded)
  }
  
  const getIcon = (category: Category) => {
    if (category.emoji) return <span>{category.emoji}</span>
    if (category.icon === 'folder') return <Folder className="w-4 h-4" />
    if (category.icon === 'tag') return <Tag className="w-4 h-4" />
    return <Hash className="w-4 h-4" />
  }
  
  return (
    <div className="space-y-1">
      {categories.map((category) => {
        const isExpanded = expandedIds.has(category.id)
        const hasChildren = category.children && category.children.length > 0
        const isSelected = selectedCategory?.id === category.id
        
        return (
          <div key={category.id}>
            <motion.div
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              className={`flex items-center gap-2 p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 cursor-pointer ${
                isSelected ? 'bg-blue-100 dark:bg-blue-900/20' : ''
              }`}
              style={{ paddingLeft: `${level * 24 + 8}px` }}
              onClick={() => onSelect(category)}
            >
              {/* Expand/Collapse Button */}
              {hasChildren ? (
                <button
                  onClick={(e) => {
                    e.stopPropagation()
                    toggleExpand(category.id)
                  }}
                  className="p-0.5 hover:bg-gray-200 dark:hover:bg-gray-600 rounded"
                >
                  {isExpanded ? (
                    <ChevronDown className="w-4 h-4" />
                  ) : (
                    <ChevronRight className="w-4 h-4" />
                  )}
                </button>
              ) : (
                <div className="w-5" />
              )}
              
              {/* Icon */}
              <div
                className="p-1.5 rounded-lg"
                style={{ backgroundColor: `${category.color}20` }}
              >
                {getIcon(category)}
              </div>
              
              {/* Name */}
              <div className="flex-1">
                <span className="font-medium">{category.name}</span>
                {category.accountCode && (
                  <span className="ml-2 text-xs text-gray-500">
                    ({category.accountCode})
                  </span>
                )}
              </div>
              
              {/* Badges */}
              <div className="flex items-center gap-2">
                {category.isGlobal && (
                  <Globe className="w-4 h-4 text-blue-500" title="Global" />
                )}
                {category.facilityId && (
                  <Building2 className="w-4 h-4 text-green-500" title="Tesis Özel" />
                )}
                {category.isSystem && (
                  <Lock className="w-4 h-4 text-gray-400" title="Sistem" />
                )}
              </div>
              
              {/* Actions */}
              <div className="flex items-center gap-1 opacity-0 hover:opacity-100 transition-opacity">
                <button
                  onClick={(e) => {
                    e.stopPropagation()
                    onEdit(category)
                  }}
                  className="p-1 hover:bg-gray-200 dark:hover:bg-gray-600 rounded"
                >
                  <Edit className="w-3 h-3" />
                </button>
                {!category.isSystem && (
                  <button
                    onClick={(e) => {
                      e.stopPropagation()
                      onDelete(category)
                    }}
                    className="p-1 hover:bg-red-100 dark:hover:bg-red-900/20 rounded text-red-600"
                  >
                    <Trash2 className="w-3 h-3" />
                  </button>
                )}
              </div>
            </motion.div>
            
            {/* Children */}
            <AnimatePresence>
              {isExpanded && hasChildren && (
                <motion.div
                  initial={{ height: 0, opacity: 0 }}
                  animate={{ height: 'auto', opacity: 1 }}
                  exit={{ height: 0, opacity: 0 }}
                  transition={{ duration: 0.2 }}
                >
                  <CategoryTree
                    categories={category.children!}
                    onEdit={onEdit}
                    onDelete={onDelete}
                    onSelect={onSelect}
                    selectedCategory={selectedCategory}
                    level={level + 1}
                  />
                </motion.div>
              )}
            </AnimatePresence>
          </div>
        )
      })}
    </div>
  )
}
ENDMARKER

# 5. Category Form Component
cat > "components/CategoryManager/CategoryForm.tsx" << 'ENDMARKER'
'use client'

import { useState } from 'react'
import { Category } from '@/types/categories'
import { X, Globe, Building2 } from 'lucide-react'
import { useFacility } from '@/contexts/FacilityContext'

interface CategoryFormProps {
  category: Category | null
  editMode: boolean
  onSubmit: (data: Partial<Category>) => void
  onCancel: () => void
}

export function CategoryForm({
  category,
  editMode,
  onSubmit,
  onCancel
}: CategoryFormProps) {
  const { currentFacility, facilities } = useFacility()
  const [formData, setFormData] = useState<Partial<Category>>({
    name: category?.name || '',
    type: category?.type || 'expense',
    isGlobal: category?.isGlobal || false,
    facilityId: category?.facilityId || currentFacility?.id,
    icon: category?.icon || 'folder',
    color: category?.color || '#3b82f6',
    accountCode: category?.accountCode || '',
    taxRate: category?.taxRate || 0,
    rules: category?.rules || {}
  })
  
  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    onSubmit(formData)
  }
  
  return (
    <form onSubmit={handleSubmit}>
      <div className="p-6 border-b border-gray-200 dark:border-gray-700">
        <div className="flex items-center justify-between">
          <h2 className="text-xl font-bold">
            {editMode ? 'Kategori Düzenle' : 'Yeni Kategori'}
          </h2>
          <button
            type="button"
            onClick={onCancel}
            className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg"
          >
            <X className="w-5 h-5" />
          </button>
        </div>
      </div>
      
      <div className="p-6 space-y-4 max-h-[70vh] overflow-y-auto">
        {/* Basic Info */}
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium mb-1">Kategori Adı *</label>
            <input
              type="text"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
              required
            />
          </div>
          
          <div>
            <label className="block text-sm font-medium mb-1">Tür *</label>
            <select
              value={formData.type}
              onChange={(e) => setFormData({ ...formData, type: e.target.value as any })}
              className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
            >
              <option value="income">Gelir</option>
              <option value="expense">Gider</option>
              <option value="project">Proje</option>
              <option value="sacrifice">Kurban</option>
              <option value="custom">Özel</option>
            </select>
          </div>
        </div>
        
        {/* Scope */}
        <div>
          <label className="block text-sm font-medium mb-2">Kapsam</label>
          <div className="flex gap-4">
            <label className="flex items-center gap-2 cursor-pointer">
              <input
                type="radio"
                checked={formData.isGlobal}
                onChange={() => setFormData({ ...formData, isGlobal: true, facilityId: undefined })}
              />
              <Globe className="w-4 h-4 text-blue-500" />
              <span>Global (Tüm Tesisler)</span>
            </label>
            <label className="flex items-center gap-2 cursor-pointer">
              <input
                type="radio"
                checked={!formData.isGlobal}
                onChange={() => setFormData({ ...formData, isGlobal: false })}
              />
              <Building2 className="w-4 h-4 text-green-500" />
              <span>Tesis Özel</span>
            </label>
          </div>
        </div>
        
        {!formData.isGlobal && (
          <div>
            <label className="block text-sm font-medium mb-1">Tesis</label>
            <select
              value={formData.facilityId}
              onChange={(e) => setFormData({ ...formData, facilityId: e.target.value })}
              className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
            >
              {facilities.map(f => (
                <option key={f.id} value={f.id}>{f.name}</option>
              ))}
            </select>
          </div>
        )}
        
        {/* Appearance */}
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium mb-1">İkon</label>
            <select
              value={formData.icon}
              onChange={(e) => setFormData({ ...formData, icon: e.target.value })}
              className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
            >
              <option value="folder">📁 Klasör</option>
              <option value="tag">🏷️ Etiket</option>
              <option value="gift">🎁 Hediye</option>
              <option value="heart">❤️ Kalp</option>
              <option value="star">⭐ Yıldız</option>
              <option value="dollar">💵 Para</option>
            </select>
          </div>
          
          <div>
            <label className="block text-sm font-medium mb-1">Renk</label>
            <input
              type="color"
              value={formData.color}
              onChange={(e) => setFormData({ ...formData, color: e.target.value })}
              className="w-full h-10"
            />
          </div>
        </div>
        
        {/* Accounting */}
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium mb-1">Muhasebe Kodu</label>
            <input
              type="text"
              value={formData.accountCode}
              onChange={(e) => setFormData({ ...formData, accountCode: e.target.value })}
              className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
              placeholder="100.01"
            />
          </div>
          
          <div>
            <label className="block text-sm font-medium mb-1">KDV Oranı (%)</label>
            <input
              type="number"
              value={formData.taxRate}
              onChange={(e) => setFormData({ ...formData, taxRate: parseFloat(e.target.value) })}
              className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
              min="0"
              max="100"
            />
          </div>
        </div>
        
        {/* Rules */}
        <div>
          <h3 className="font-medium mb-2">Kurallar</h3>
          <div className="space-y-3 p-4 bg-gray-50 dark:bg-gray-700/50 rounded-lg">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm mb-1">Min. Tutar</label>
                <input
                  type="number"
                  value={formData.rules?.minAmount || ''}
                  onChange={(e) => setFormData({
                    ...formData,
                    rules: { ...formData.rules, minAmount: parseInt(e.target.value) }
                  })}
                  className="w-full px-3 py-2 bg-white dark:bg-gray-800 rounded-lg"
                  placeholder="0"
                />
              </div>
              
              <div>
                <label className="block text-sm mb-1">Max. Tutar</label>
                <input
                  type="number"
                  value={formData.rules?.maxAmount || ''}
                  onChange={(e) => setFormData({
                    ...formData,
                    rules: { ...formData.rules, maxAmount: parseInt(e.target.value) }
                  })}
                  className="w-full px-3 py-2 bg-white dark:bg-gray-800 rounded-lg"
                  placeholder="Sınırsız"
                />
              </div>
            </div>
            
            <label className="flex items-center gap-2">
              <input
                type="checkbox"
                checked={formData.rules?.requiresApproval || false}
                onChange={(e) => setFormData({
                  ...formData,
                  rules: { ...formData.rules, requiresApproval: e.target.checked }
                })}
                className="rounded"
              />
              <span className="text-sm">Onay gerektirir</span>
            </label>
            
            {formData.rules?.requiresApproval && (
              <div>
                <label className="block text-sm mb-1">Onay Limiti</label>
                <input
                  type="number"
                  value={formData.rules?.approvalThreshold || ''}
                  onChange={(e) => setFormData({
                    ...formData,
                    rules: { ...formData.rules, approvalThreshold: parseInt(e.target.value) }
                  })}
                  className="w-full px-3 py-2 bg-white dark:bg-gray-800 rounded-lg"
                  placeholder="Limit tutarı"
                />
              </div>
            )}
          </div>
        </div>
      </div>
      
      <div className="p-6 border-t border-gray-200 dark:border-gray-700 flex justify-end gap-2">
        <button
          type="button"
          onClick={onCancel}
          className="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-lg hover:bg-gray-300"
        >
          İptal
        </button>
        <button
          type="submit"
          className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
        >
          {editMode ? 'Güncelle' : 'Oluştur'}
        </button>
      </div>
    </form>
  )
}
ENDMARKER

echo "✅ Adım 5 tamamlandı: Dinamik Kategori Yönetimi"
echo ""
echo "📌 Eklenen özellikler:"
echo "  • Hiyerarşik kategori yapısı"
echo "  • Tesis bazlı kategoriler"
echo "  • Global ve lokal kategoriler"
echo "  • Muhasebe kodları"
echo "  • KDV ve vergi ayarları"
echo "  • Min/Max tutar limitleri"
echo "  • Onay kuralları"
echo "  • Çoklu dil desteği"
echo ""
echo "🚀 Son Adım: Multi-language Support"