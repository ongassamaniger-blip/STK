// Tüm modüller için ortak type tanımlamaları
export interface BaseEntity {
  id: string
  createdAt: string
  updatedAt: string
  createdBy: string
}

export interface Transaction extends BaseEntity {
  type: 'income' | 'expense' | 'transfer'
  amount: number
  category: string
  description: string
  status: 'pending' | 'approved' | 'rejected' | 'completed'
}

export interface Project extends BaseEntity {
  name: string
  status: 'planning' | 'active' | 'completed' | 'paused'
  progress: number
  budget: number
  spent: number
}
