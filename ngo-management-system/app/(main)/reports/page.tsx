export default function ReportsPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Raporlar</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="font-semibold mb-2">Finansal Rapor</h3>
          <p className="text-gray-600 text-sm mb-4">Gelir-Gider analizi</p>
          <button className="text-blue-500 hover:underline">Oluştur →</button>
        </div>
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="font-semibold mb-2">Proje Raporu</h3>
          <p className="text-gray-600 text-sm mb-4">Proje durumları</p>
          <button className="text-blue-500 hover:underline">Oluştur →</button>
        </div>
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="font-semibold mb-2">Personel Raporu</h3>
          <p className="text-gray-600 text-sm mb-4">Personel performansı</p>
          <button className="text-blue-500 hover:underline">Oluştur →</button>
        </div>
      </div>
    </div>
  )
}
