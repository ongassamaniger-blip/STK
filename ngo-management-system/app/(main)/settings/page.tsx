export default function SettingsPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Ayarlar</h1>
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="font-semibold mb-4">Genel Ayarlar</h2>
        <div className="space-y-4">
          <div>
            <label className="block text-sm font-medium mb-2">Kurum Adı</label>
            <input type="text" className="w-full px-3 py-2 border rounded-lg" defaultValue="NGO Management System" />
          </div>
          <div>
            <label className="block text-sm font-medium mb-2">Dil</label>
            <select className="w-full px-3 py-2 border rounded-lg">
              <option>Türkçe</option>
              <option>English</option>
            </select>
          </div>
          <button className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600">
            Kaydet
          </button>
        </div>
      </div>
    </div>
  )
}
