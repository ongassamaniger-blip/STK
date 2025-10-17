'use client'

import { useState } from 'react'
import Link from 'next/link'

export default function CashPage() {
  const [transactions] = useState([
    { id: 1, type: 'income', category: 'Bağış', description: 'Kurumsal bağış', amount: 50000, date: '2025-10-17', status: 'completed' },
    { id: 2, type: 'expense', category: 'Personel', description: 'Maaş ödemesi', amount: 35000, date: '2025-10-15', status: 'completed' },
    { id: 3, type: 'transfer', category: 'Transfer', description: 'Nijer kasası transferi', amount: 25000, date: '2025-10-14', status: 'pending' },
    { id: 4, type: 'income', category: 'Kurban', description: 'Kurban bağışı', amount: 8500, date: '2025-10-13', status: 'completed' },
    { id: 5, type: 'expense', category: 'Proje', description: 'Su kuyusu projesi', amount: 12000, date: '2025-10-12', status: 'completed' },
  ])

  const totalIncome = transactions.filter(t => t.type === 'income').reduce((sum, t) => sum + t.amount, 0)
  const totalExpense = transactions.filter(t => t.type === 'expense').reduce((sum, t) => sum + t.amount, 0)
  const balance = totalIncome - totalExpense

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-800">Kasa Yönetimi</h1>
          <p className="text-gray-600">Gelir, gider ve transfer işlemleri</p>
        </div>
        <div className="flex gap-2">
          <Link href="/cash/income" className="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600">
            + Gelir Ekle
          </Link>
          <Link href="/cash/expense" className="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600">
            - Gider Ekle
          </Link>
          <Link href="/cash/transfer" className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600">
            ↔ Transfer
          </Link>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white rounded-lg shadow p-6">
          <p className="text-gray-500 text-sm">Toplam Gelir</p>
          <p className="text-2xl font-bold text-green-600">₺{totalIncome.toLocaleString()}</p>
        </div>
        <div className="bg-white rounded-lg shadow p-6">
          <p className="text-gray-500 text-sm">Toplam Gider</p>
          <p className="text-2xl font-bold text-red-600">₺{totalExpense.toLocaleString()}</p>
        </div>
        <div className="bg-white rounded-lg shadow p-6">
          <p className="text-gray-500 text-sm">Bakiye</p>
          <p className="text-2xl font-bold text-blue-600">₺{balance.toLocaleString()}</p>
        </div>
      </div>

      {/* Transactions Table */}
      <div className="bg-white rounded-lg shadow">
        <div className="p-6 border-b">
          <h2 className="text-lg font-semibold">İşlem Listesi</h2>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tür</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Kategori</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Açıklama</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tutar</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tarih</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Durum</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {transactions.map(transaction => (
                <tr key={transaction.id} className="hover:bg-gray-50">
                  <td className="px-6 py-4">
                    <span className={`px-2 py-1 text-xs rounded-full ${
                      transaction.type === 'income' ? 'bg-green-100 text-green-700' :
                      transaction.type === 'expense' ? 'bg-red-100 text-red-700' :
                      'bg-blue-100 text-blue-700'
                    }`}>
                      {transaction.type === 'income' ? 'Gelir' :
                       transaction.type === 'expense' ? 'Gider' : 'Transfer'}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-sm">{transaction.category}</td>
                  <td className="px-6 py-4 text-sm">{transaction.description}</td>
                  <td className="px-6 py-4 text-sm font-medium">
                    <span className={transaction.type === 'income' ? 'text-green-600' : 'text-red-600'}>
                      {transaction.type === 'income' ? '+' : '-'}₺{transaction.amount.toLocaleString()}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-sm">{transaction.date}</td>
                  <td className="px-6 py-4">
                    <span className={`px-2 py-1 text-xs rounded-full ${
                      transaction.status === 'completed' ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'
                    }`}>
                      {transaction.status === 'completed' ? 'Tamamlandı' : 'Bekliyor'}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  )
}
