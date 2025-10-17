#!/bin/bash
# upgrade-3b-cash-modals.sh
# Modern Cash Management - Part 2 (Transaction List & Modals)
# Date: 2025-10-17 14:47:56
# User: ongassamaniger-blip

echo "💰 =========================================="
echo "   KASA YÖNETİMİ - PART 2"
echo "   İşlem listesi ve modal'lar ekleniyor..."
echo "💰 =========================================="

# Append to existing cash page
cat >> "app/(main)/cash/page.tsx" << 'EOF'

      {/* Filters and Search */}
      <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-4 border border-gray-200 dark:border-gray-700">
        <div className="flex flex-col lg:flex-row gap-4">
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              placeholder="İşlem ara..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-10 pr-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
          <div className="flex gap-2">
            <select 
              value={filterStatus}
              onChange={(e) => setFilterStatus(e.target.value)}
              className="px-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
            >
              <option value="all">Tüm Durumlar</option>
              <option value="pending">Bekliyor</option>
              <option value="approved">Onaylandı</option>
              <option value="completed">Tamamlandı</option>
              <option value="rejected">Reddedildi</option>
            </select>
            <select className="px-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg">
              <option>Son 30 Gün</option>
              <option>Son 7 Gün</option>
              <option>Bugün</option>
              <option>Bu Ay</option>
              <option>Bu Yıl</option>
            </select>
            <button 
              onClick={() => exportData('excel')}
              className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors flex items-center gap-2"
            >
              <FileSpreadsheet className="w-4 h-4" />
              Excel
            </button>
            <button 
              onClick={() => exportData('pdf')}
              className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors flex items-center gap-2"
            >
              <FileText className="w-4 h-4" />
              PDF
            </button>
            <button className="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-lg hover:bg-gray-300 dark:hover:bg-gray-600 transition-colors">
              <Printer className="w-4 h-4" />
            </button>
          </div>
        </div>
      </div>

      {/* Transaction List */}
      <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50 dark:bg-gray-700/50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  İşlem
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Kategori
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Tutar
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Tarih
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Durum
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Belgeler
                </th>
                <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  İşlemler
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200 dark:divide-gray-700">
              {transactions.map((transaction) => (
                <motion.tr
                  key={transaction.id}
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  className="hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-colors"
                >
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="flex items-center">
                      <div className={`p-2 rounded-lg ${
                        transaction.type === 'income' ? 'bg-green-100 text-green-600' :
                        transaction.type === 'expense' ? 'bg-red-100 text-red-600' :
                        'bg-blue-100 text-blue-600'
                      }`}>
                        {transaction.type === 'income' ? <Plus className="w-4 h-4" /> :
                         transaction.type === 'expense' ? <Minus className="w-4 h-4" /> :
                         <ArrowLeftRight className="w-4 h-4" />}
                      </div>
                      <div className="ml-3">
                        <p className="text-sm font-medium text-gray-900 dark:text-white">
                          {transaction.description}
                        </p>
                        <p className="text-xs text-gray-500 dark:text-gray-400">
                          {transaction.createdBy}
                        </p>
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div>
                      <p className="text-sm text-gray-900 dark:text-white">{transaction.category}</p>
                      {transaction.subcategory && (
                        <p className="text-xs text-gray-500">{transaction.subcategory}</p>
                      )}
                    </div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <span className={`text-sm font-medium ${
                      transaction.type === 'income' ? 'text-green-600' : 'text-red-600'
                    }`}>
                      {transaction.type === 'income' ? '+' : '-'}₺{transaction.amount.toLocaleString()}
                    </span>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="text-sm text-gray-900 dark:text-white">
                      {new Date(transaction.date).toLocaleDateString('tr-TR')}
                    </div>
                    <div className="text-xs text-gray-500">
                      {new Date(transaction.createdAt).toLocaleTimeString('tr-TR', { hour: '2-digit', minute: '2-digit' })}
                    </div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <span className={`px-2 py-1 text-xs font-medium rounded-full ${
                      transaction.status === 'completed' ? 'bg-green-100 text-green-800' :
                      transaction.status === 'pending' ? 'bg-yellow-100 text-yellow-800' :
                      transaction.status === 'approved' ? 'bg-blue-100 text-blue-800' :
                      'bg-red-100 text-red-800'
                    }`}>
                      {transaction.status === 'completed' ? 'Tamamlandı' :
                       transaction.status === 'pending' ? 'Bekliyor' :
                       transaction.status === 'approved' ? 'Onaylandı' :
                       'Reddedildi'}
                    </span>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    {transaction.attachments.length > 0 ? (
                      <div className="flex items-center gap-1">
                        <Paperclip className="w-4 h-4 text-gray-400" />
                        <span className="text-sm text-gray-600 dark:text-gray-400">
                          {transaction.attachments.length} belge
                        </span>
                      </div>
                    ) : (
                      <span className="text-sm text-gray-400">-</span>
                    )}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-right">
                    <div className="flex items-center justify-end gap-1">
                      {transaction.status === 'pending' && (
                        <>
                          <button
                            onClick={() => handleApprove(transaction.id)}
                            className="p-1 text-green-600 hover:bg-green-100 rounded"
                            title="Onayla"
                          >
                            <Check className="w-4 h-4" />
                          </button>
                          <button
                            onClick={() => handleReject(transaction.id)}
                            className="p-1 text-red-600 hover:bg-red-100 rounded"
                            title="Reddet"
                          >
                            <X className="w-4 h-4" />
                          </button>
                        </>
                      )}
                      <button
                        onClick={() => {
                          setSelectedTransaction(transaction)
                          setShowDetailModal(true)
                        }}
                        className="p-1 text-blue-600 hover:bg-blue-100 rounded"
                        title="Detay"
                      >
                        <Eye className="w-4 h-4" />
                      </button>
                      <button
                        className="p-1 text-gray-600 hover:bg-gray-100 rounded"
                        title="Düzenle"
                      >
                        <Edit className="w-4 h-4" />
                      </button>
                    </div>
                  </td>
                </motion.tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Add Transaction Modal */}
      <AnimatePresence>
        {showAddModal && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
            onClick={() => setShowAddModal(false)}
          >
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              className="bg-white dark:bg-gray-800 rounded-2xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-hidden"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="p-6 border-b border-gray-200 dark:border-gray-700">
                <h2 className="text-xl font-bold text-gray-900 dark:text-white">
                  {transactionType === 'income' ? 'Gelir Ekle' :
                   transactionType === 'expense' ? 'Gider Ekle' :
                   'Transfer Yap'}
                </h2>
              </div>

              <div className="p-6 overflow-y-auto max-h-[70vh]">
                <form className="space-y-4">
                  {/* Date */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                      Tarih
                    </label>
                    <input
                      type="date"
                      defaultValue={new Date().toISOString().split('T')[0]}
                      className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>

                  {/* Category */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                      Kategori
                    </label>
                    <select className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                      {transactionType === 'income' ? (
                        <>
                          <option>Bağış</option>
                          <option>Hibe</option>
                          <option>Kurban</option>
                          <option>Zakat</option>
                          <option>Proje Geliri</option>
                        </>
                      ) : transactionType === 'expense' ? (
                        <>
                          <option>Personel</option>
                          <option>Operasyon</option>
                          <option>Proje</option>
                          <option>Yardım</option>
                          <option>Kira</option>
                        </>
                      ) : (
                        <>
                          <option>Ana Kasa → Tesis</option>
                          <option>Tesis → Ana Kasa</option>
                          <option>Banka → Kasa</option>
                          <option>Kasa → Banka</option>
                        </>
                      )}
                    </select>
                  </div>

                  {/* Amount */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                      Tutar
                    </label>
                    <div className="relative">
                      <span className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-500">₺</span>
                      <input
                        type="number"
                        placeholder="0.00"
                        className="w-full pl-8 pr-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    </div>
                  </div>

                  {/* Description */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                      Açıklama
                    </label>
                    <textarea
                      rows={3}
                      placeholder="İşlem açıklaması..."
                      className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>

                  {/* File Upload */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                      Belgeler
                    </label>
                    <div className="border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-lg p-4">
                      <input
                        ref={fileInputRef}
                        type="file"
                        multiple
                        onChange={handleFileUpload}
                        className="hidden"
                        accept=".pdf,.jpg,.jpeg,.png,.xlsx,.xls,.doc,.docx"
                      />
                      <button
                        type="button"
                        onClick={() => fileInputRef.current?.click()}
                        className="w-full flex flex-col items-center justify-center py-4 hover:bg-gray-50 dark:hover:bg-gray-700/50 rounded-lg transition-colors"
                      >
                        <Upload className="w-8 h-8 text-gray-400 mb-2" />
                        <p className="text-sm text-gray-600 dark:text-gray-400">
                          Belge yüklemek için tıklayın veya sürükleyin
                        </p>
                        <p className="text-xs text-gray-400 mt-1">
                          PDF, JPG, PNG, Excel, Word (Max 10MB)
                        </p>
                      </button>

                      {/* Uploaded Files */}
                      {attachments.length > 0 && (
                        <div className="mt-4 space-y-2">
                          {attachments.map((file, index) => (
                            <div key={index} className="flex items-center justify-between p-2 bg-gray-100 dark:bg-gray-700 rounded">
                              <div className="flex items-center gap-2">
                                <FileText className="w-4 h-4 text-gray-400" />
                                <span className="text-sm">{file.name}</span>
                                <span className="text-xs text-gray-400">
                                  ({(file.size / 1024).toFixed(1)} KB)
                                </span>
                              </div>
                              <button
                                type="button"
                                onClick={() => removeAttachment(index)}
                                className="p-1 hover:bg-red-100 dark:hover:bg-red-900/20 rounded text-red-600"
                              >
                                <X className="w-4 h-4" />
                              </button>
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  </div>
                </form>
              </div>

              <div className="p-6 border-t border-gray-200 dark:border-gray-700 flex justify-end gap-2">
                <button
                  onClick={() => setShowAddModal(false)}
                  className="px-4 py-2 bg-gray-200 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-lg hover:bg-gray-300 dark:hover:bg-gray-600"
                >
                  İptal
                </button>
                <button
                  className={`px-4 py-2 text-white rounded-lg ${
                    transactionType === 'income' ? 'bg-green-600 hover:bg-green-700' :
                    transactionType === 'expense' ? 'bg-red-600 hover:bg-red-700' :
                    'bg-blue-600 hover:bg-blue-700'
                  }`}
                >
                  Kaydet
                </button>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Detail Modal */}
      <AnimatePresence>
        {showDetailModal && selectedTransaction && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
            onClick={() => setShowDetailModal(false)}
          >
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              className="bg-white dark:bg-gray-800 rounded-2xl shadow-2xl max-w-3xl w-full max-h-[90vh] overflow-hidden"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="p-6 border-b border-gray-200 dark:border-gray-700">
                <div className="flex items-center justify-between">
                  <h2 className="text-xl font-bold text-gray-900 dark:text-white">İşlem Detayı</h2>
                  <button
                    onClick={() => setShowDetailModal(false)}
                    className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg"
                  >
                    <X className="w-5 h-5" />
                  </button>
                </div>
              </div>

              <div className="p-6 overflow-y-auto max-h-[70vh]">
                <div className="space-y-6">
                  {/* Transaction Info */}
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <p className="text-sm text-gray-500 dark:text-gray-400">İşlem Tipi</p>
                      <p className="font-medium text-gray-900 dark:text-white">
                        {selectedTransaction.type === 'income' ? 'Gelir' :
                         selectedTransaction.type === 'expense' ? 'Gider' : 'Transfer'}
                      </p>
                    </div>
                    <div>
                      <p className="text-sm text-gray-500 dark:text-gray-400">Durum</p>
                      <span className={`px-2 py-1 text-xs font-medium rounded-full ${
                        selectedTransaction.status === 'completed' ? 'bg-green-100 text-green-800' :
                        selectedTransaction.status === 'pending' ? 'bg-yellow-100 text-yellow-800' :
                        selectedTransaction.status === 'approved' ? 'bg-blue-100 text-blue-800' :
                        'bg-red-100 text-red-800'
                      }`}>
                        {selectedTransaction.status === 'completed' ? 'Tamamlandı' :
                         selectedTransaction.status === 'pending' ? 'Bekliyor' :
                         selectedTransaction.status === 'approved' ? 'Onaylandı' :
                         'Reddedildi'}
                      </span>
                    </div>
                    <div>
                      <p className="text-sm text-gray-500 dark:text-gray-400">Tutar</p>
                      <p className="font-medium text-2xl text-gray-900 dark:text-white">
                        ₺{selectedTransaction.amount.toLocaleString()}
                      </p>
                    </div>
                    <div>
                      <p className="text-sm text-gray-500 dark:text-gray-400">Tarih</p>
                      <p className="font-medium text-gray-900 dark:text-white">
                        {new Date(selectedTransaction.date).toLocaleDateString('tr-TR')}
                      </p>
                    </div>
                    <div className="col-span-2">
                      <p className="text-sm text-gray-500 dark:text-gray-400">Açıklama</p>
                      <p className="font-medium text-gray-900 dark:text-white">
                        {selectedTransaction.description}
                      </p>
                    </div>
                  </div>

                  {/* Attachments */}
                  {selectedTransaction.attachments.length > 0 && (
                    <div>
                      <h3 className="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Belgeler</h3>
                      <div className="space-y-2">
                        {selectedTransaction.attachments.map((attachment) => (
                          <div key={attachment.id} className="flex items-center justify-between p-3 bg-gray-100 dark:bg-gray-700 rounded-lg">
                            <div className="flex items-center gap-3">
                              <FileText className="w-5 h-5 text-gray-400" />
                              <div>
                                <p className="text-sm font-medium">{attachment.name}</p>
                                <p className="text-xs text-gray-500">
                                  {(attachment.size / 1024).toFixed(1)} KB
                                </p>
                              </div>
                            </div>
                            <div className="flex gap-2">
                              <button className="p-1 text-blue-600 hover:bg-blue-100 rounded">
                                <Eye className="w-4 h-4" />
                              </button>
                              <button className="p-1 text-gray-600 hover:bg-gray-200 rounded">
                                <Download className="w-4 h-4" />
                              </button>
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>
                  )}

                  {/* Approval Info */}
                  {selectedTransaction.approver && (
                    <div className="p-4 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
                      <p className="text-sm text-blue-600 dark:text-blue-400">
                        {selectedTransaction.approver} tarafından {' '}
                        {selectedTransaction.approvedAt && 
                          new Date(selectedTransaction.approvedAt).toLocaleDateString('tr-TR')} {' '}
                        tarihinde onaylandı
                      </p>
                    </div>
                  )}
                </div>
              </div>

              <div className="p-6 border-t border-gray-200 dark:border-gray-700 flex justify-end gap-2">
                <button className="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-lg hover:bg-gray-300 dark:hover:bg-gray-600">
                  <Printer className="w-4 h-4 inline mr-1" />
                  Yazdır
                </button>
                <button className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                  <Edit className="w-4 h-4 inline mr-1" />
                  Düzenle
                </button>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}
EOF

echo ""
echo "✅ Modern Kasa Yönetimi tamamlandı!"
echo ""
echo "🎯 Eklenen özellikler:"
echo "  ✓ Gelir/Gider/Transfer formları"
echo "  ✓ Çoklu belge yükleme"
echo "  ✓ İşlem detay modalı"
echo "  ✓ Onay/Red sistemi"
echo "  ✓ Excel/PDF export"
echo "  ✓ Gelişmiş filtreleme"
echo "  ✓ Nakit akış grafikleri"
echo "  ✓ Kategori dağılımı"
echo "  ✓ Responsive tasarım"
echo ""
echo "🚀 Test için: npm run dev"
echo "📌 Sonraki adım: Proje Yönetimi modernizasyonu"