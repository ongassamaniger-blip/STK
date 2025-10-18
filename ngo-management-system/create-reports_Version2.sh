#!/bin/bash

# Reports sayfası
cat > app/\(main\)/reports/page.tsx << 'EOF'
'use client';

import { useState } from 'react';
import { Download, FileText, TrendingUp, Calendar, Filter, Printer, Share2, BarChart3, PieChart, Activity, DollarSign } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { DatePickerWithRange } from '@/components/ui/date-range-picker';

export default function ReportsPage() {
  const [reportType, setReportType] = useState('financial');
  const [period, setPeriod] = useState('monthly');

  const quickReports = [
    {
      title: 'Aylık Mali Rapor',
      description: 'Detaylı gelir-gider analizi',
      icon: DollarSign,
      color: 'bg-blue-500',
      lastGenerated: '2024-01-15'
    },
    {
      title: 'Proje Performans Raporu',
      description: 'Tüm projelerin durumu',
      icon: BarChart3,
      color: 'bg-green-500',
      lastGenerated: '2024-01-14'
    },
    {
      title: 'Kurban Raporu',
      description: 'Kurban bağışları ve dağıtımları',
      icon: PieChart,
      color: 'bg-purple-500',
      lastGenerated: '2024-01-13'
    },
    {
      title: 'Tesis Durum Raporu',
      description: 'Tesis kapasiteleri ve durumları',
      icon: Activity,
      color: 'bg-orange-500',
      lastGenerated: '2024-01-12'
    }
  ];

  const recentReports = [
    {
      id: '1',
      name: 'Q4 2023 Mali Rapor',
      type: 'Mali',
      createdDate: '2024-01-10',
      createdBy: 'Mariama Sow',
      size: '2.4 MB',
      status: 'completed'
    },
    {
      id: '2',
      name: 'Yıllık Faaliyet Raporu 2023',
      type: 'Faaliyet',
      createdDate: '2024-01-05',
      createdBy: 'Amadou Diallo',
      size: '5.8 MB',
      status: 'completed'
    },
    {
      id: '3',
      name: 'Aralık Kurban Dağıtım Raporu',
      type: 'Kurban',
      createdDate: '2023-12-30',
      createdBy: 'Ibrahim Touré',
      size: '1.2 MB',
      status: 'completed'
    }
  ];

  const stats = [
    { label: 'Bu Ay Üretilen', value: '12', change: '+3', trend: 'up' },
    { label: 'Toplam Rapor', value: '145', change: '+12', trend: 'up' },
    { label: 'Ortalama Boyut', value: '2.1 MB', change: '-0.3', trend: 'down' },
    { label: 'Otomatik Rapor', value: '8', change: '+2', trend: 'up' }
  ];

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold">Raporlar</h1>
          <p className="text-gray-500">Detaylı raporlar oluşturun ve yönetin</p>
        </div>
        <Button className="gap-2">
          <FileText className="w-4 h-4" />
          Yeni Rapor Oluştur
        </Button>
      </div>

      <div className="grid gap-4 md:grid-cols-4">
        {stats.map((stat, index) => (
          <Card key={index}>
            <CardContent className="p-6">
              <div className="space-y-2">
                <p className="text-sm font-medium text-gray-500">{stat.label}</p>
                <div className="flex items-baseline gap-2">
                  <p className="text-2xl font-bold">{stat.value}</p>
                  <span className={`text-xs ${stat.trend === 'up' ? 'text-green-500' : 'text-red-500'}`}>
                    {stat.change}
                  </span>
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      <div className="grid gap-6 md:grid-cols-2">
        {quickReports.map((report, index) => (
          <Card key={index} className="hover:shadow-lg transition-shadow cursor-pointer">
            <CardContent className="p-6">
              <div className="flex items-start justify-between">
                <div className="flex gap-4">
                  <div className={`p-3 rounded-lg ${report.color}`}>
                    <report.icon className="w-6 h-6 text-white" />
                  </div>
                  <div>
                    <h3 className="font-semibold">{report.title}</h3>
                    <p className="text-sm text-gray-500 mt-1">{report.description}</p>
                    <p className="text-xs text-gray-400 mt-2">
                      Son: {new Date(report.lastGenerated).toLocaleDateString('tr-TR')}
                    </p>
                  </div>
                </div>
                <Button variant="ghost" size="sm">
                  <Download className="w-4 h-4" />
                </Button>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Son Üretilen Raporlar</CardTitle>
          <CardDescription>Yakın zamanda oluşturulan raporlar</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {recentReports.map((report) => (
              <div key={report.id} className="flex items-center justify-between p-4 border rounded-lg hover:bg-gray-50">
                <div className="flex items-center gap-4">
                  <FileText className="w-8 h-8 text-gray-400" />
                  <div>
                    <h4 className="font-medium">{report.name}</h4>
                    <div className="flex gap-4 text-sm text-gray-500 mt-1">
                      <span>{report.type}</span>
                      <span>{report.size}</span>
                      <span>{new Date(report.createdDate).toLocaleDateString('tr-TR')}</span>
                      <span>Oluşturan: {report.createdBy}</span>
                    </div>
                  </div>
                </div>
                <div className="flex gap-2">
                  <Button variant="ghost" size="sm">
                    <Printer className="w-4 h-4" />
                  </Button>
                  <Button variant="ghost" size="sm">
                    <Share2 className="w-4 h-4" />
                  </Button>
                  <Button variant="ghost" size="sm">
                    <Download className="w-4 h-4" />
                  </Button>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
EOF

echo "✅ Reports sayfası oluşturuldu!"