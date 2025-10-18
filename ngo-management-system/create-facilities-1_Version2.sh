#!/bin/bash

# Facilities ana sayfa - Part 1
cat > app/\(main\)/facilities/page.tsx << 'EOF'
'use client';

import { useState } from 'react';
import { Plus, Search, Filter, Building2, MapPin, Users, Activity, Edit, Trash2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';

export default function FacilitiesPage() {
  const [searchTerm, setSearchTerm] = useState('');
  const [filterType, setFilterType] = useState('all');

  const facilities = [
    {
      id: '1',
      name: 'Umut Yetimhanesi',
      type: 'orphanage',
      status: 'active',
      address: 'Niamey, Niger',
      capacity: 150,
      occupancy: 127,
      manager: 'Fatima Amadou'
    },
    {
      id: '2',
      name: 'Bilgi Eğitim Merkezi',
      type: 'school',
      status: 'active',
      address: 'Zinder, Niger',
      capacity: 300,
      occupancy: 285,
      manager: 'Ibrahim Moussa'
    },
    {
      id: '3',
      name: 'Şifa Sağlık Kliniği',
      type: 'clinic',
      status: 'active',
      address: 'Maradi, Niger',
      capacity: 50,
      occupancy: 42,
      manager: 'Dr. Aisha Diallo'
    }
  ];

  const stats = [
    { label: 'Toplam Tesis', value: '12', icon: Building2, color: 'text-blue-500' },
    { label: 'Aktif Tesis', value: '10', icon: Activity, color: 'text-green-500' },
    { label: 'Toplam Kapasite', value: '850', icon: Users, color: 'text-purple-500' },
    { label: 'Doluluk Oranı', value: '%87', icon: MapPin, color: 'text-orange-500' },
  ];

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'active': return 'bg-green-100 text-green-800';
      case 'inactive': return 'bg-gray-100 text-gray-800';
      case 'maintenance': return 'bg-yellow-100 text-yellow-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  };

  const getTypeLabel = (type: string) => {
    switch (type) {
      case 'orphanage': return 'Yetimhane';
      case 'school': return 'Okul';
      case 'clinic': return 'Klinik';
      case 'community_center': return 'Toplum Merkezi';
      case 'shelter': return 'Barınma';
      default: return type;
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold">Tesis Yönetimi</h1>
          <p className="text-gray-500">Tüm tesisleri yönetin ve takip edin</p>
        </div>
        <Button className="gap-2">
          <Plus className="w-4 h-4" />
          Yeni Tesis Ekle
        </Button>
      </div>

      <div className="grid gap-4 md:grid-cols-4">
        {stats.map((stat, index) => (
          <Card key={index}>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-gray-500">{stat.label}</p>
                  <p className="text-2xl font-bold">{stat.value}</p>
                </div>
                <stat.icon className={`w-8 h-8 ${stat.color}`} />
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <CardTitle>Tesisler</CardTitle>
            <div className="flex gap-2">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
                <Input
                  placeholder="Tesis ara..."
                  className="pl-10 w-64"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </div>
              <Select value={filterType} onValueChange={setFilterType}>
                <SelectTrigger className="w-40">
                  <SelectValue placeholder="Tür" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Tümü</SelectItem>
                  <SelectItem value="orphanage">Yetimhane</SelectItem>
                  <SelectItem value="school">Okul</SelectItem>
                  <SelectItem value="clinic">Klinik</SelectItem>
                  <SelectItem value="community_center">Toplum Merkezi</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {facilities.map((facility) => (
              <div key={facility.id} className="border rounded-lg p-4 hover:bg-gray-50 transition-colors">
                <div className="flex items-center justify-between">
                  <div className="flex-1">
                    <div className="flex items-center gap-3">
                      <Building2 className="w-5 h-5 text-gray-400" />
                      <h3 className="font-semibold">{facility.name}</h3>
                      <Badge variant="secondary">{getTypeLabel(facility.type)}</Badge>
                      <Badge className={getStatusColor(facility.status)}>
                        {facility.status === 'active' ? 'Aktif' : 'Pasif'}
                      </Badge>
                    </div>
                    <div className="mt-2 grid grid-cols-3 gap-4 text-sm text-gray-500">
                      <div className="flex items-center gap-1">
                        <MapPin className="w-3 h-3" />
                        {facility.address}
                      </div>
                      <div className="flex items-center gap-1">
                        <Users className="w-3 h-3" />
                        {facility.occupancy}/{facility.capacity} Kapasite
                      </div>
                      <div>
                        Yönetici: {facility.manager}
                      </div>
                    </div>
                  </div>
                  <div className="flex gap-2">
                    <Button variant="outline" size="sm">
                      <Edit className="w-4 h-4" />
                    </Button>
                    <Button variant="outline" size="sm">
                      <Trash2 className="w-4 h-4" />
                    </Button>
                  </div>
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

echo "✅ Facilities sayfası oluşturuldu!"