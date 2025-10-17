export default function FacilitiesPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Tesis Yönetimi</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {['Merkez Ofis', 'Nijer Tesisi', 'Senegal Tesisi', 'Mali Tesisi', 'Burkina Faso Tesisi'].map((facility, index) => (
          <div key={index} className="bg-white p-6 rounded-lg shadow">
            <h3 className="font-semibold mb-2">{facility}</h3>
            <p className="text-sm text-gray-600 mb-4">Aktif - {5 + index} Personel</p>
            <button className="text-blue-500 hover:underline text-sm">Detaylar →</button>
          </div>
        ))}
      </div>
    </div>
  )
}
