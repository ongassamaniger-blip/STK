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
