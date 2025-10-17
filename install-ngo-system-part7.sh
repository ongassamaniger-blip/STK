# Sacrifice Management Component devamı
cat >> 'components/sacrifice/SacrificeManagement.tsx' << 'ENDOFSACRIFICE_CONT'
                    {new Date(sacrifice.slaughterDate).toLocaleDateString('tr-TR')}
                  </span>
                )}
              </div>

              {/* Actions */}
              <div className="flex gap-2">
                {sacrifice.soldShares < sacrifice.totalShares && (
                  <button
                    onClick={(e) => {
                      e.stopPropagation()
                      setSelectedForShare(sacrifice)
                      setShowShareModal(true)
                    }}
                    className="flex-1 px-3 py-2 bg-primary text-primary-foreground rounded-lg text-sm"
                  >
                    Hisse Al
                  </button>
                )}
                <button
                  onClick={(e) => {
                    e.stopPropagation()
                    setSelectedSacrifice(sacrifice)
                  }}
                  className="px-3 py-2 border rounded-lg hover:bg-accent"
                >
                  <Eye className="w-4 h-4" />
                </button>
              </div>
            </motion.div>
          )
        })}
      </div>

      {/* Empty State */}
      {filteredSacrifices.length === 0 && (
        <div className="text-center py-12 bg-card rounded-xl border">
          <Heart className="w-12 h-12 mx-auto text-muted-foreground mb-4" />
          <h3 className="text-lg font-semibold mb-2">Kurban bulunamadı</h3>
          <p className="text-muted-foreground mb-4">
            Arama kriterlerinize uygun kurban bulunmamaktadır
          </p>
          <button
            onClick={() => setShowNewSacrifice(true)}
            className="px-4 py-2 bg-primary text-primary-foreground rounded-lg text-sm"
          >
            Yeni Kurban Ekle
          </button>
        </div>
      )}

      {/* Sacrifice Detail Modal */}
      <AnimatePresence>
        {selectedSacrifice && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50"
            onClick={() => setSelectedSacrifice(null)}
          >
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              className="bg-card rounded-xl p-6 w-full max-w-4xl max-h-[90vh] overflow-y-auto"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-xl font-semibold">Kurban Detayları</h2>
                <button
                  onClick={() => setSelectedSacrifice(null)}
                  className="p-2 hover:bg-accent rounded-lg"
                >
                  <XCircle className="w-5 h-5" />
                </button>
              </div>

              {/* Content */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <h3 className="font-medium mb-4">Genel Bilgiler</h3>
                  <div className="space-y-3">
                    <div>
                      <p className="text-sm text-muted-foreground">Kurban Kodu</p>
                      <p className="font-medium">{selectedSacrifice.code}</p>
                    </div>
                    <div>
                      <p className="text-sm text-muted-foreground">Tür</p>
                      <p className="font-medium">{getTypeInfo(selectedSacrifice.type).label}</p>
                    </div>
                    <div>
                      <p className="text-sm text-muted-foreground">Konum</p>
                      <p className="font-medium">{selectedSacrifice.location}</p>
                    </div>
                    <div>
                      <p className="text-sm text-muted-foreground">Kesim Tarihi</p>
                      <p className="font-medium">
                        {selectedSacrifice.slaughterDate ? 
                          new Date(selectedSacrifice.slaughterDate).toLocaleDateString('tr-TR') : 
                          'Belirtilmemiş'}
                      </p>
                    </div>
                    <div>
                      <p className="text-sm text-muted-foreground">Sağlık Durumu</p>
                      {getHealthStatusBadge(selectedSacrifice.healthStatus)}
                    </div>
                  </div>
                </div>

                <div>
                  <h3 className="font-medium mb-4">Hisse Bilgileri</h3>
                  <div className="space-y-3">
                    <div>
                      <p className="text-sm text-muted-foreground">Toplam Hisse</p>
                      <p className="font-medium">{selectedSacrifice.totalShares}</p>
                    </div>
                    <div>
                      <p className="text-sm text-muted-foreground">Satılan Hisse</p>
                      <p className="font-medium">{selectedSacrifice.soldShares}</p>
                    </div>
                    <div>
                      <p className="text-sm text-muted-foreground">Hisse Fiyatı</p>
                      <p className="font-medium">₺{selectedSacrifice.pricePerShare.toLocaleString()}</p>
                    </div>
                    <div>
                      <p className="text-sm text-muted-foreground">Toplanan Tutar</p>
                      <p className="font-medium">₺{selectedSacrifice.collectedAmount.toLocaleString()}</p>
                    </div>
                  </div>
                </div>
              </div>

              {/* Shareholders */}
              {selectedSacrifice.shares.length > 0 && (
                <div className="mt-6">
                  <h3 className="font-medium mb-4">Hissedarlar</h3>
                  <div className="overflow-x-auto">
                    <table className="w-full">
                      <thead className="bg-muted/50">
                        <tr>
                          <th className="text-left p-3 text-sm">İsim</th>
                          <th className="text-left p-3 text-sm">Telefon</th>
                          <th className="text-left p-3 text-sm">Hisse</th>
                          <th className="text-left p-3 text-sm">Tutar</th>
                          <th className="text-left p-3 text-sm">Ödeme</th>
                        </tr>
                      </thead>
                      <tbody>
                        {selectedSacrifice.shares.map(share => (
                          <tr key={share.id} className="border-b">
                            <td className="p-3 text-sm">{share.shareholderName}</td>
                            <td className="p-3 text-sm">{share.shareholderPhone}</td>
                            <td className="p-3 text-sm">{share.shareCount}</td>
                            <td className="p-3 text-sm">₺{share.amount.toLocaleString()}</td>
                            <td className="p-3">
                              {share.isPaid ? (
                                <span className="px-2 py-1 bg-green-500/10 text-green-600 rounded-full text-xs">
                                  Ödendi
                                </span>
                              ) : (
                                <span className="px-2 py-1 bg-yellow-500/10 text-yellow-600 rounded-full text-xs">
                                  Bekliyor
                                </span>
                              )}
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              )}

              {/* Actions */}
              <div className="flex gap-2 mt-6">
                <button className="px-4 py-2 bg-primary text-primary-foreground rounded-lg text-sm">
                  <Edit className="w-4 h-4 inline mr-1" />
                  Düzenle
                </button>
                <button className="px-4 py-2 border rounded-lg text-sm hover:bg-accent">
                  <Printer className="w-4 h-4 inline mr-1" />
                  Yazdır
                </button>
                <button className="px-4 py-2 border rounded-lg text-sm hover:bg-accent">
                  <Share2 className="w-4 h-4 inline mr-1" />
                  Paylaş
                </button>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}
ENDOFSACRIFICE_CONT

echo -e "${GREEN}✅ Sacrifice Management component tamamlandı${NC}"

# =====================================================
# REPORTS & APPROVALS PAGES
# =====================================================

echo -e "${BLUE}📊 Reports ve Approvals sayfaları oluşturuluyor...${NC}"

# Reports Page
cat > 'app/(main)/reports/page.tsx' << 'ENDOFREPORTSPAGE'
import ReportsManagement from '@/components/reports/ReportsManagement'

export const metadata = {
  title: 'Raporlar - NGO Management System',
  description: 'Analiz ve raporlama merkezi'
}

export default function ReportsPage() {
  return <ReportsManagement />
}
ENDOFREPORTSPAGE

# Approvals Page
cat > 'app/(main)/approvals/page.tsx' << 'ENDOFAPPROVALSPAGE'
import ApprovalsManagement from '@/components/approvals/ApprovalsManagement'

export const metadata = {
  title: 'Onaylar - NGO Management System',
  description: 'Onay bekleyen işlemler'
}

export default function ApprovalsPage() {
  return <ApprovalsManagement />
}
ENDOFAPPROVALSPAGE

# Settings Page
cat > 'app/(main)/settings/page.tsx' << 'ENDOFSETTINGSPAGE'
import SettingsPage from '@/components/settings/SettingsPage'

export const metadata = {
  title: 'Ayarlar - NGO Management System',
  description: 'Sistem ayarları ve yapılandırma'
}

export default function Settings() {
  return <SettingsPage />
}
ENDOFSETTINGSPAGE

# =====================================================
# UTILITY FILES
# =====================================================

echo -e "${BLUE}🛠️ Utility dosyaları oluşturuluyor...${NC}"

# Utils
cat > 'lib/utils.ts' << 'ENDOFUTILS'
import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function formatCurrency(amount: number, currency: string = 'TRY'): string {
  const formatter = new Intl.NumberFormat('tr-TR', {
    style: 'currency',
    currency: currency,
  })
  return formatter.format(amount)
}

export function formatDate(date: string | Date): string {
  return new Intl.DateTimeFormat('tr-TR').format(new Date(date))
}

export function formatDateTime(date: string | Date): string {
  return new Intl.DateTimeFormat('tr-TR', {
    dateStyle: 'short',
    timeStyle: 'short',
  }).format(new Date(date))
}

export function generateId(): string {
  return Math.random().toString(36).substr(2, 9)
}

export function debounce<T extends (...args: any[]) => any>(
  func: T,
  wait: number
): (...args: Parameters<T>) => void {
  let timeout: NodeJS.Timeout | null = null
  
  return (...args: Parameters<T>) => {
    if (timeout) clearTimeout(timeout)
    timeout = setTimeout(() => func(...args), wait)
  }
}

export function downloadFile(data: any, filename: string) {
  const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' })
  const url = window.URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = filename
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
  window.URL.revokeObjectURL(url)
}

export function getInitials(name: string): string {
  return name
    .split(' ')
    .map(part => part[0])
    .join('')
    .toUpperCase()
    .slice(0, 2)
}

export function calculatePercentage(value: number, total: number): number {
  if (total === 0) return 0
  return Math.round((value / total) * 100)
}

export function groupBy<T>(array: T[], key: keyof T): Record<string, T[]> {
  return array.reduce((groups, item) => {
    const value = String(item[key])
    if (!groups[value]) groups[value] = []
    groups[value].push(item)
    return groups
  }, {} as Record<string, T[]>)
}

export function sortByKey<T>(array: T[], key: keyof T, order: 'asc' | 'desc' = 'asc'): T[] {
  return [...array].sort((a, b) => {
    if (a[key] < b[key]) return order === 'asc' ? -1 : 1
    if (a[key] > b[key]) return order === 'asc' ? 1 : -1
    return 0
  })
}

export function truncate(str: string, length: number): string {
  if (str.length <= length) return str
  return str.slice(0, length) + '...'
}

export function isValidEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return emailRegex.test(email)
}

export function isValidPhone(phone: string): boolean {
  const phoneRegex = /^[\d\s\-\+\(\)]+$/
  return phoneRegex.test(phone) && phone.replace(/\D/g, '').length >= 10
}

export function getDaysUntil(date: string | Date): number {
  const targetDate = new Date(date)
  const today = new Date()
  const diffTime = targetDate.getTime() - today.getTime()
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24))
}

export function getTimeAgo(date: string | Date): string {
  const now = new Date()
  const past = new Date(date)
  const diffMs = now.getTime() - past.getTime()
  
  const seconds = Math.floor(diffMs / 1000)
  const minutes = Math.floor(seconds / 60)
  const hours = Math.floor(minutes / 60)
  const days = Math.floor(hours / 24)
  
  if (days > 0) return `${days} gün önce`
  if (hours > 0) return `${hours} saat önce`
  if (minutes > 0) return `${minutes} dakika önce`
  return 'Şimdi'
}
ENDOFUTILS

# Types
cat > 'types/index.ts' << 'ENDOFTYPES'
export interface User {
  id: string
  email: string
  name: string
  role: 'admin' | 'manager' | 'user'
  avatar?: string
  createdAt: string
  updatedAt: string
}

export interface ApiResponse<T = any> {
  success: boolean
  data?: T
  error?: string
  message?: string
}

export interface PaginatedResponse<T> {
  data: T[]
  total: number
  page: number
  pageSize: number
  totalPages: number
}

export interface FilterOptions {
  search?: string
  status?: string
  category?: string
  dateFrom?: string
  dateTo?: string
  sortBy?: string
  sortOrder?: 'asc' | 'desc'
}
ENDOFTYPES

echo -e "${GREEN}✅ Utility dosyaları oluşturuldu${NC}"

# =====================================================
# FINAL SETUP
# =====================================================

echo -e "${CYAN}════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}[11/11] Son ayarlamalar yapılıyor...${NC}"
echo -e "${CYAN}════════════════════════════════════════════════${NC}"

# README.md
cat > 'README.md' << 'ENDOFREADME'
# 🏢 NGO Management System

Modern ve kapsamlı bir Sivil Toplum Kuruluşları (STK) yönetim platformu.

## 🚀 Özellikler

- ✅ **Dashboard** - Gerçek zamanlı istatistikler ve özetler
- ✅ **Kasa Yönetimi** - Gelir, gider ve transfer işlemleri
- ✅ **Proje Yönetimi** - Proje planlama ve takibi
- ✅ **Tesis Yönetimi** - Çoklu tesis desteği
- ✅ **Personel Yönetimi** - İK süreçleri ve bordro
- ✅ **Kurban Modülü** - Kurban organizasyonu ve takibi
- ✅ **Onay Sistemi** - Hiyerarşik onay mekanizması
- ✅ **Raporlar** - Detaylı analiz ve raporlar

## 💻 Teknolojiler

- **Frontend:** Next.js 14, React 18, TypeScript
- **Styling:** Tailwind CSS, Framer Motion
- **Charts:** Recharts
- **Icons:** Lucide React
- **State:** Zustand
- **Forms:** React Hook Form + Zod
- **Notifications:** React Hot Toast

## 📋 Gereksinimler

- Node.js 18+
- npm veya yarn

## 🛠️ Kurulum

1. **Projeyi klonlayın**
```bash
git clone https://github.com/ongassamaniger-blip/ngo-management-system.git
cd ngo-management-system