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
