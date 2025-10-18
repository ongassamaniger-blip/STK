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
