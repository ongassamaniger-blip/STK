export default function IncomePage() {
  return (
    <div className="max-w-2xl mx-auto">
      <h1 className="text-2xl font-bold mb-6">Gelir Ekle</h1>
      <form className="bg-white rounded-lg shadow p-6 space-y-4">
        <div>
          <label className="block text-sm font-medium mb-2">Kategori</label>
          <select className="w-full px-3 py-2 border rounded-lg">
            <option>Bağış</option>
            <option>Hibe</option>
            <option>Kurban</option>
            <option>Zakat</option>
          </select>
        </div>
        <div>
          <label className="block text-sm font-medium mb-2">Tutar</label>
          <input type="number" className="w-full px-3 py-2 border rounded-lg" placeholder="0.00" />
        </div>
        <div>
          <label className="block text-sm font-medium mb-2">Açıklama</label>
          <textarea className="w-full px-3 py-2 border rounded-lg" rows={3}></textarea>
        </div>
        <div className="flex gap-2">
          <button type="submit" className="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600">
            Kaydet
          </button>
          <a href="/cash" className="px-4 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600">
            İptal
          </a>
        </div>
      </form>
    </div>
  )
}
