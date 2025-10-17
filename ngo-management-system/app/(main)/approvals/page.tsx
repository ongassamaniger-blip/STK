export default function ApprovalsPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Onay Bekleyenler</h1>
      <div className="bg-white rounded-lg shadow">
        <div className="p-6 space-y-4">
          <div className="border rounded-lg p-4">
            <div className="flex justify-between items-start">
              <div>
                <h3 className="font-semibold">Transfer İşlemi</h3>
                <p className="text-sm text-gray-600 mt-1">Ana Kasa → Nijer Kasa</p>
                <p className="text-lg font-bold mt-2">₺25,000</p>
              </div>
              <div className="flex gap-2">
                <button className="px-3 py-1 bg-green-500 text-white rounded hover:bg-green-600">Onayla</button>
                <button className="px-3 py-1 bg-red-500 text-white rounded hover:bg-red-600">Reddet</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
