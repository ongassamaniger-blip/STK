import { z } from 'zod'

export const loginSchema = z.object({
  email: z.string().email('Geçerli email giriniz'),
  password: z.string().min(6, 'Şifre en az 6 karakter olmalı')
})

export const transactionSchema = z.object({
  type: z.enum(['income', 'expense', 'transfer']),
  amount: z.number().positive('Tutar pozitif olmalı'),
  description: z.string().min(3, 'Açıklama en az 3 karakter olmalı'),
  category: z.string(),
  date: z.date()
})

export const projectSchema = z.object({
  name: z.string().min(3, 'Proje adı en az 3 karakter olmalı'),
  description: z.string().optional(),
  budget: z.number().positive(),
  startDate: z.date(),
  endDate: z.date()
})
