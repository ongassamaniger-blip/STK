export default function ProjectsPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Proje Yönetimi</h1>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="font-semibold mb-2">Su Kuyusu Projesi</h3>
          <p className="text-gray-600 text-sm mb-4">Nijer'de 10 köye temiz su</p>
          <div className="w-full bg-gray-200 rounded-full h-2">
            <div className="bg-blue-500 h-2 rounded-full" style={{width: '65%'}}></div>
          </div>
          <p className="text-sm mt-2">%65 Tamamlandı</p>
        </div>
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="font-semibold mb-2">Eğitim Merkezi</h3>
          <p className="text-gray-600 text-sm mb-4">Senegal'de eğitim tesisi</p>
          <div className="w-full bg-gray-200 rounded-full h-2">
            <div className="bg-green-500 h-2 rounded-full" style={{width: '45%'}}></div>
          </div>
          <p className="text-sm mt-2">%45 Tamamlandı</p>
        </div>
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="font-semibold mb-2">Sağlık Taraması</h3>
          <p className="text-gray-600 text-sm mb-4">Mali'de sağlık hizmetleri</p>
          <div className="w-full bg-gray-200 rounded-full h-2">
            <div className="bg-purple-500 h-2 rounded-full" style={{width: '80%'}}></div>
          </div>
          <p className="text-sm mt-2">%80 Tamamlandı</p>
        </div>
      </div>
    </div>
  )
}
