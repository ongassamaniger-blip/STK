#!/bin/bash
# step-2-permission-system.sh
# Esnek yetkilendirme ve rol yönetimi
# Date: 2025-10-18 19:45:00
# User: ongassamaniger-blip

echo "🔐 =========================================="
echo "   ADIM 2: ESNEK YETKİLENDİRME SİSTEMİ"
echo "   Dynamic permissions & role management..."
echo "🔐 =========================================="

# 1. Permission Types & Interfaces
cat > "types/permissions.ts" << 'ENDMARKER'
export interface Permission {
  id: string
  userId: string
  
  // Tesis bazlı yetkiler
  facilities: {
    facilityId: string
    permissions: PermissionType[]
    modules: ModulePermission[]
  }[]
  
  // Proje bazlı yetkiler
  projects: {
    projectId: string
    permissions: PermissionType[]
  }[]
  
  // Global yetkiler
  global: {
    isAdmin: boolean
    canSwitchFacility: boolean
    canViewAllReports: boolean
    canManageUsers: boolean
  }
  
  // Geçici yetkiler
  temporaryPermissions?: {
    facilityId: string
    permissions: PermissionType[]
    startDate: string
    endDate: string
    reason: string
  }[]
  
  // Kısıtlamalar
  restrictions?: {
    maxApprovalAmount?: number
    requiresDualApproval?: boolean
    blockedModules?: string[]
    workingHours?: { start: string; end: string }
  }
}

export type PermissionType = 
  | 'view'
  | 'create' 
  | 'edit'
  | 'delete'
  | 'approve'
  | 'export'
  | 'import'

export interface ModulePermission {
  module: ModuleType
  actions: PermissionType[]
}

export type ModuleType =
  | 'dashboard'
  | 'cash'
  | 'projects'
  | 'personnel'
  | 'facilities'
  | 'sacrifice'
  | 'approvals'
  | 'reports'
  | 'settings'

export interface Role {
  id: string
  name: string
  description: string
  isSystem: boolean // Sistem rolü silinemez
  permissions: {
    modules: ModulePermission[]
    defaultFacilityPermissions: PermissionType[]
  }
}
ENDMARKER

# 2. Permission Context
cat > "contexts/PermissionContext.tsx" << 'ENDMARKER'
'use client'

import React, { createContext, useContext, useState, useEffect } from 'react'
import { Permission, PermissionType, ModuleType } from '@/types/permissions'
import { useStore } from '@/lib/store'
import { useFacility } from '@/contexts/FacilityContext'

interface PermissionContextType {
  permissions: Permission | null
  hasPermission: (module: ModuleType, action: PermissionType, facilityId?: string) => boolean
  hasAnyPermission: (module: ModuleType, facilityId?: string) => boolean
  hasFacilityAccess: (facilityId: string) => boolean
  hasProjectAccess: (projectId: string) => boolean
  canApprove: (amount?: number) => boolean
  isGlobalAdmin: () => boolean
  refreshPermissions: () => Promise<void>
}

const PermissionContext = createContext<PermissionContextType | undefined>(undefined)

export function PermissionProvider({ children }: { children: React.ReactNode }) {
  const user = useStore((state) => state.user)
  const { currentFacility } = useFacility()
  const [permissions, setPermissions] = useState<Permission | null>(null)
  
  useEffect(() => {
    if (user) {
      loadUserPermissions(user.id)
    }
  }, [user])
  
  const loadUserPermissions = async (userId: string) => {
    // Normalde API'den gelecek
    // const response = await fetch(`/api/permissions/${userId}`)
    
    // Mock permissions for testing
    const mockPermissions: Permission = {
      id: '1',
      userId: userId,
      facilities: [
        {
          facilityId: 'nijer',
          permissions: ['view', 'create', 'edit', 'approve'],
          modules: [
            { module: 'cash', actions: ['view', 'create', 'approve'] },
            { module: 'projects', actions: ['view', 'create', 'edit'] }
          ]
        },
        {
          facilityId: 'senegal',
          permissions: ['view'],
          modules: [
            { module: 'cash', actions: ['view'] },
            { module: 'reports', actions: ['view', 'export'] }
          ]
        }
      ],
      projects: [
        { projectId: 'water-well-1', permissions: ['view', 'edit', 'approve'] },
        { projectId: 'school-1', permissions: ['view'] }
      ],
      global: {
        isAdmin: user?.role === 'admin',
        canSwitchFacility: true,
        canViewAllReports: user?.role === 'admin',
        canManageUsers: user?.role === 'admin'
      },
      restrictions: {
        maxApprovalAmount: 50000,
        requiresDualApproval: true
      }
    }
    
    setPermissions(mockPermissions)
  }
  
  const hasPermission = (
    module: ModuleType, 
    action: PermissionType, 
    facilityId?: string
  ): boolean => {
    if (!permissions) return false
    
    // Global admin her şeye erişebilir
    if (permissions.global.isAdmin) return true
    
    const targetFacilityId = facilityId || currentFacility?.id
    if (!targetFacilityId) return false
    
    // Geçici yetkiler kontrol et
    const now = new Date()
    const tempPerm = permissions.temporaryPermissions?.find(
      tp => tp.facilityId === targetFacilityId &&
            new Date(tp.startDate) <= now &&
            new Date(tp.endDate) >= now
    )
    
    if (tempPerm && tempPerm.permissions.includes(action)) {
      return true
    }
    
    // Normal yetkiler kontrol et
    const facilityPerm = permissions.facilities.find(
      f => f.facilityId === targetFacilityId
    )
    
    if (!facilityPerm) return false
    
    const modulePerm = facilityPerm.modules.find(m => m.module === module)
    return modulePerm?.actions.includes(action) || false
  }
  
  const hasAnyPermission = (module: ModuleType, facilityId?: string): boolean => {
    const actions: PermissionType[] = ['view', 'create', 'edit', 'delete', 'approve']
    return actions.some(action => hasPermission(module, action, facilityId))
  }
  
  const hasFacilityAccess = (facilityId: string): boolean => {
    if (!permissions) return false
    if (permissions.global.isAdmin) return true
    
    return permissions.facilities.some(f => f.facilityId === facilityId)
  }
  
  const hasProjectAccess = (projectId: string): boolean => {
    if (!permissions) return false
    if (permissions.global.isAdmin) return true
    
    return permissions.projects.some(p => p.projectId === projectId)
  }
  
  const canApprove = (amount?: number): boolean => {
    if (!permissions) return false
    
    if (amount && permissions.restrictions?.maxApprovalAmount) {
      return amount <= permissions.restrictions.maxApprovalAmount
    }
    
    return true
  }
  
  const isGlobalAdmin = (): boolean => {
    return permissions?.global.isAdmin || false
  }
  
  const refreshPermissions = async () => {
    if (user) {
      await loadUserPermissions(user.id)
    }
  }
  
  return (
    <PermissionContext.Provider
      value={{
        permissions,
        hasPermission,
        hasAnyPermission,
        hasFacilityAccess,
        hasProjectAccess,
        canApprove,
        isGlobalAdmin,
        refreshPermissions
      }}
    >
      {children}
    </PermissionContext.Provider>
  )
}

export function usePermissions() {
  const context = useContext(PermissionContext)
  if (context === undefined) {
    throw new Error('usePermissions must be used within a PermissionProvider')
  }
  return context
}
ENDMARKER

# 3. Permission Guard Component
cat > "components/PermissionGuard.tsx" << 'ENDMARKER'
'use client'

import { ReactNode } from 'react'
import { usePermissions } from '@/contexts/PermissionContext'
import { ModuleType, PermissionType } from '@/types/permissions'
import { AlertCircle, Lock } from 'lucide-react'

interface PermissionGuardProps {
  module: ModuleType
  action?: PermissionType
  facilityId?: string
  fallback?: ReactNode
  children: ReactNode
}

export function PermissionGuard({
  module,
  action = 'view',
  facilityId,
  fallback,
  children
}: PermissionGuardProps) {
  const { hasPermission } = usePermissions()
  
  if (!hasPermission(module, action, facilityId)) {
    return fallback ? (
      <>{fallback}</>
    ) : (
      <div className="flex flex-col items-center justify-center p-8 bg-red-50 dark:bg-red-900/20 rounded-lg">
        <Lock className="w-12 h-12 text-red-500 mb-4" />
        <h3 className="text-lg font-semibold text-red-700 dark:text-red-400">
          Yetkisiz Erişim
        </h3>
        <p className="text-sm text-red-600 dark:text-red-300 mt-2">
          Bu işlem için yetkiniz bulunmamaktadır.
        </p>
      </div>
    )
  }
  
  return <>{children}</>
}

// Hook version for conditional rendering
export function usePermissionCheck(
  module: ModuleType,
  action: PermissionType = 'view',
  facilityId?: string
): boolean {
  const { hasPermission } = usePermissions()
  return hasPermission(module, action, facilityId)
}
ENDMARKER

# 4. Role Management Page
cat > "app/(main)/settings/roles/page.tsx" << 'ENDMARKER'
'use client'

import { useState } from 'react'
import { motion } from 'framer-motion'
import {
  Shield, Plus, Edit, Trash2, Users, Check, X,
  Eye, Lock, Unlock, ChevronRight, Settings
} from 'lucide-react'
import { Role, ModuleType, PermissionType } from '@/types/permissions'

export default function RolesPage() {
  const [roles, setRoles] = useState<Role[]>([
    {
      id: '1',
      name: 'Admin',
      description: 'Tam yetki',
      isSystem: true,
      permissions: {
        modules: [
          { module: 'dashboard', actions: ['view', 'create', 'edit', 'delete', 'approve'] },
          { module: 'cash', actions: ['view', 'create', 'edit', 'delete', 'approve'] },
          { module: 'projects', actions: ['view', 'create', 'edit', 'delete', 'approve'] }
        ],
        defaultFacilityPermissions: ['view', 'create', 'edit', 'delete', 'approve']
      }
    },
    {
      id: '2',
      name: 'Tesis Müdürü',
      description: 'Tesis yönetimi',
      isSystem: false,
      permissions: {
        modules: [
          { module: 'dashboard', actions: ['view'] },
          { module: 'cash', actions: ['view', 'create', 'approve'] },
          { module: 'projects', actions: ['view', 'create', 'edit'] }
        ],
        defaultFacilityPermissions: ['view', 'create', 'edit']
      }
    }
  ])
  
  const [showCreateModal, setShowCreateModal] = useState(false)
  const [selectedRole, setSelectedRole] = useState<Role | null>(null)
  
  const modules: ModuleType[] = [
    'dashboard', 'cash', 'projects', 'personnel', 
    'facilities', 'sacrifice', 'approvals', 'reports', 'settings'
  ]
  
  const actions: PermissionType[] = [
    'view', 'create', 'edit', 'delete', 'approve', 'export'
  ]
  
  const moduleLabels: Record<ModuleType, string> = {
    dashboard: 'Dashboard',
    cash: 'Kasa Yönetimi',
    projects: 'Projeler',
    personnel: 'Personel',
    facilities: 'Tesisler',
    sacrifice: 'Kurban',
    approvals: 'Onaylar',
    reports: 'Raporlar',
    settings: 'Ayarlar'
  }
  
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">Rol Yönetimi</h1>
          <p className="text-gray-500">Sistem rolleri ve yetkileri</p>
        </div>
        <button
          onClick={() => setShowCreateModal(true)}
          className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 flex items-center gap-2"
        >
          <Plus className="w-4 h-4" />
          Yeni Rol
        </button>
      </div>
      
      {/* Roles Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {roles.map((role) => (
          <motion.div
            key={role.id}
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 border border-gray-200 dark:border-gray-700"
          >
            <div className="flex items-start justify-between mb-4">
              <div className="flex items-center gap-3">
                <div className="p-3 bg-blue-100 dark:bg-blue-900/20 rounded-lg">
                  <Shield className="w-6 h-6 text-blue-600" />
                </div>
                <div>
                  <h3 className="font-semibold">{role.name}</h3>
                  <p className="text-sm text-gray-500">{role.description}</p>
                </div>
              </div>
              {role.isSystem && (
                <Lock className="w-4 h-4 text-gray-400" />
              )}
            </div>
            
            {/* Module Permissions Summary */}
            <div className="space-y-2 mb-4">
              {role.permissions.modules.slice(0, 3).map((mp) => (
                <div key={mp.module} className="flex items-center justify-between text-sm">
                  <span className="text-gray-600 dark:text-gray-400">
                    {moduleLabels[mp.module]}
                  </span>
                  <div className="flex gap-1">
                    {mp.actions.map((action) => (
                      <span
                        key={action}
                        className="px-1.5 py-0.5 bg-green-100 dark:bg-green-900/20 text-green-600 text-xs rounded"
                      >
                        {action[0].toUpperCase()}
                      </span>
                    ))}
                  </div>
                </div>
              ))}
              {role.permissions.modules.length > 3 && (
                <p className="text-xs text-gray-500">
                  +{role.permissions.modules.length - 3} modül daha
                </p>
              )}
            </div>
            
            <div className="flex gap-2">
              <button
                onClick={() => setSelectedRole(role)}
                className="flex-1 px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-600 flex items-center justify-center gap-1"
              >
                <Edit className="w-3 h-3" />
                <span className="text-sm">Düzenle</span>
              </button>
              {!role.isSystem && (
                <button className="p-2 bg-red-100 dark:bg-red-900/20 rounded-lg hover:bg-red-200 dark:hover:bg-red-900/40 text-red-600">
                  <Trash2 className="w-4 h-4" />
                </button>
              )}
            </div>
          </motion.div>
        ))}
      </div>
      
      {/* Permission Matrix Modal */}
      {(showCreateModal || selectedRole) && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
          onClick={() => {
            setShowCreateModal(false)
            setSelectedRole(null)
          }}
        >
          <motion.div
            initial={{ scale: 0.9 }}
            animate={{ scale: 1 }}
            className="bg-white dark:bg-gray-800 rounded-2xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-hidden"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="p-6 border-b border-gray-200 dark:border-gray-700">
              <h2 className="text-xl font-bold">
                {selectedRole ? 'Rol Düzenle' : 'Yeni Rol Oluştur'}
              </h2>
            </div>
            
            <div className="p-6 overflow-y-auto max-h-[70vh]">
              <div className="space-y-4 mb-6">
                <div>
                  <label className="block text-sm font-medium mb-1">Rol Adı</label>
                  <input
                    type="text"
                    defaultValue={selectedRole?.name}
                    className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                    placeholder="Örn: Proje Yöneticisi"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1">Açıklama</label>
                  <textarea
                    defaultValue={selectedRole?.description}
                    className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
                    rows={2}
                    placeholder="Rol açıklaması"
                  />
                </div>
              </div>
              
              {/* Permission Matrix */}
              <div>
                <h3 className="font-semibold mb-3">Yetki Matrisi</h3>
                <div className="overflow-x-auto">
                  <table className="w-full border border-gray-200 dark:border-gray-700">
                    <thead>
                      <tr className="bg-gray-50 dark:bg-gray-700/50">
                        <th className="p-2 text-left text-sm font-medium">Modül</th>
                        {actions.map(action => (
                          <th key={action} className="p-2 text-center text-xs font-medium">
                            {action}
                          </th>
                        ))}
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-200 dark:divide-gray-700">
                      {modules.map(module => (
                        <tr key={module}>
                          <td className="p-2 text-sm font-medium">
                            {moduleLabels[module]}
                          </td>
                          {actions.map(action => (
                            <td key={action} className="p-2 text-center">
                              <input
                                type="checkbox"
                                className="rounded"
                                defaultChecked={
                                  selectedRole?.permissions.modules
                                    .find(m => m.module === module)
                                    ?.actions.includes(action)
                                }
                              />
                            </td>
                          ))}
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
            
            <div className="p-6 border-t border-gray-200 dark:border-gray-700 flex justify-end gap-2">
              <button
                onClick={() => {
                  setShowCreateModal(false)
                  setSelectedRole(null)
                }}
                className="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-lg hover:bg-gray-300"
              >
                İptal
              </button>
              <button className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                {selectedRole ? 'Güncelle' : 'Oluştur'}
              </button>
            </div>
          </motion.div>
        </motion.div>
      )}
    </div>
  )
}
ENDMARKER

echo "✅ Adım 2 tamamlandı: Esnek Yetkilendirme Sistemi"
echo ""
echo "📌 Eklenen özellikler:"
echo "  • Permission types & interfaces"
echo "  • PermissionContext & Provider"
echo "  • PermissionGuard component"
echo "  • Role Management sayfası"
echo "  • Tesis & Proje bazlı yetkiler"
echo "  • Geçici yetki desteği"
echo ""
echo "🚀 Sonraki: Adım 3 - Form Builder Sistemi"