export default function PersonnelPage() {
  const personnel = [
    { id: 1, name: 'Ahmet Yılmaz', position: 'Proje Yöneticisi', department: 'Operasyon', status: 'active' },
    { id: 2, name: 'Fatma Kaya', position: 'Muhasebe Uzmanı', department: 'Finans', status: 'active' },
    { id: 3, name: 'Mehmet Öz', position: 'Saha Koordinatörü', department: 'Operasyon', status: 'active' },
    { id: 4, name: 'Ayşe Demir', position: 'İK Uzmanı', department: 'İnsan Kaynakları', status: 'active' },
  ]

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-2xl font-bold">Personel Yönetimi</h1>
        <button className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600">
          + Yeni Personel
        </button>
      </div>
      <div className="bg-white rounded-lg shadow">
        <table className="w-full">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Ad Soyad</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Pozisyon</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Departman</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Durum</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-200">
            {personnel.map(person => (
              <tr key={person.id} className="hover:bg-gray-50">
                <td className="px-6 py-4">{person.name}</td>
                <td className="px-6 py-4">{person.position}</td>
                <td className="px-6 py-4">{person.department}</td>
                <td className="px-6 py-4">
                  <span className="px-2 py-1 text-xs bg-green-100 text-green-700 rounded-full">Aktif</span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}
