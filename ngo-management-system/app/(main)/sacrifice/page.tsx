export default function SacrificePage() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Kurban Yönetimi</h1>
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="bg-white p-4 rounded-lg shadow">
          <p className="text-gray-500 text-sm">Toplam Kurban</p>
          <p className="text-2xl font-bold">45</p>
        </div>
        <div className="bg-white p-4 rounded-lg shadow">
          <p className="text-gray-500 text-sm">Satılan Hisse</p>
          <p className="text-2xl font-bold">127/315</p>
        </div>
        <div className="bg-white p-4 rounded-lg shadow">
          <p className="text-gray-500 text-sm">Toplanan Tutar</p>
          <p className="text-2xl font-bold">₺892,500</p>
        </div>
        <div className="bg-white p-4 rounded-lg shadow">
          <p className="text-gray-500 text-sm">Faydalanıcı</p>
          <p className="text-2xl font-bold">2,250</p>
        </div>
      </div>
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="font-semibold mb-4">Kurban Listesi</h2>
        <div className="space-y-3">
          {[1, 2, 3, 4, 5].map(i => (
            <div key={i} className="flex justify-between items-center p-3 border rounded-lg">
              <div>
                <p className="font-medium">Kurban #{i.toString().padStart(3, '0')}</p>
                <p className="text-sm text-gray-600">Büyükbaş - Nijer</p>
              </div>
              <div className="text-right">
                <p className="font-medium">{i * 2}/{7} Hisse</p>
                <p className="text-sm text-green-600">₺{(12000 * i * 2).toLocaleString()}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
