import Dexie, { Table } from 'dexie'

export interface Transaction {
  id?: number
  type: string
  amount: number
  description: string
  date: Date
  category: string
  attachments?: any[]
  createdAt: Date
  updatedAt: Date
}

export interface Project {
  id?: number
  name: string
  description: string
  status: string
  budget: number
  startDate: Date
  endDate: Date
  createdAt: Date
}

class NGODatabase extends Dexie {
  transactions!: Table<Transaction>
  projects!: Table<Project>
  
  constructor() {
    super('NGODatabase')
    this.version(1).stores({
      transactions: '++id, type, date, category',
      projects: '++id, name, status, startDate'
    })
  }
}

export const db = new NGODatabase()
