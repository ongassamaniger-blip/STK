import { create } from 'zustand'
import { persist } from 'zustand/middleware'

interface Transaction {
  id: string
  type: 'income' | 'expense' | 'transfer'
  amount: number
  description: string
  date: string
  status: string
}

interface AppState {
  user: any | null
  setUser: (user: any) => void
  
  transactions: Transaction[]
  addTransaction: (transaction: Transaction) => void
  updateTransaction: (id: string, data: Partial<Transaction>) => void
  deleteTransaction: (id: string) => void
  
  projects: any[]
  addProject: (project: any) => void
  
  darkMode: boolean
  toggleDarkMode: () => void
  
  clearStore: () => void
}

export const useStore = create<AppState>()(
  persist(
    (set) => ({
      user: null,
      transactions: [],
      projects: [],
      darkMode: false,
      
      setUser: (user) => set({ user }),
      
      addTransaction: (transaction) =>
        set((state) => ({
          transactions: [...state.transactions, transaction]
        })),
        
      updateTransaction: (id, data) =>
        set((state) => ({
          transactions: state.transactions.map((t) =>
            t.id === id ? { ...t, ...data } : t
          )
        })),
        
      deleteTransaction: (id) =>
        set((state) => ({
          transactions: state.transactions.filter((t) => t.id !== id)
        })),
        
      addProject: (project) =>
        set((state) => ({
          projects: [...state.projects, project]
        })),
        
      toggleDarkMode: () =>
        set((state) => ({ darkMode: !state.darkMode })),
        
      clearStore: () =>
        set({
          user: null,
          transactions: [],
          projects: [],
        })
    }),
    {
      name: 'ngo-storage',
    }
  )
)
