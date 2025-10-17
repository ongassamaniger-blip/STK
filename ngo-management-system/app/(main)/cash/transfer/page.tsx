export default function TransferPage() {
  return (
    <div className="max-w-2xl mx-auto">
      <h1 className="text-2xl font-bold mb-6">Transfer Yap</h1>
      <form className="bg-white rounded-lg shadow p-6 space-y-4">
        <div>
          <label className="block text-sm font-medium mb-2">Kaynak Kasa</label>
          <select className="w-full px-3 py-2 border rounded-lg">
            <option>Ana Kasa</option>
            <option>Banka Hesabı</option>
          </select>
        </div>
        <div>
          <label className="block text-sm font-medium mb-2">Hedef Kasa</label>
          <select className="w-full px-3 py-2 border rounded-lg">
            <option>Nijer Kasa</option>
            <option>Senegal Kasa</option>
            <option>Mali Kasa</option>
          </select>
        </div>
        <div>
          <label className="block text-sm font-medium mb-2">Tutar</label>
          <input type="number" className="w-full px-3 py-2 border rounded-lg" placeholder="0.00" />
        </div>
        <div className="flex gap-2">
          <button type="submit" className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600">
            Transfer Yap
          </button>
          <a href="/cash" className="px-4 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600">
            İptal
          </a>
        </div>
      </form>
    </div>
  )
}
