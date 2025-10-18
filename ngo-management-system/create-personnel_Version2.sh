#!/bin/bash

# Personnel Management sayfası
cat > app/\(main\)/personnel/page.tsx << 'EOF'
'use client';

import { useState } from 'react';
import { Plus, Search, Filter, Users, Mail, Phone, Calendar, Award, Edit, Trash2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';

export default function PersonnelPage() {
  const [searchTerm, setSearchTerm] = useState('');
  const [filterDepartment, setFilterDepartment] = useState('all');

  const personnel = [
    {
      id: '1',
      name: 'Amadou Diallo',
      position: 'Proje Koordinatörü',
      department: 'operations',
      email: 'amadou@ngo.org',
      phone: '+227 90 11 22 33',
      startDate: '2020-03-15',
      status: 'active',
      avatar: null
    },
    {
      id: '2',
      name: 'Mariama Sow',
      position: 'Mali Müdür',
      department: 'finance',
      email: 'mariama@ngo.org',
      phone: '+227 90 44 55 66',
      startDate: '2019-06-20',
      status: 'active',
      avatar: null
    },
    {
      id: '3',
      name: 'Ibrahim Touré',
      position: 'Saha Koordinatörü',
      department: 'field',
      email: 'ibrahim@ngo.org',
      phone: '+227 90 77 88 99',
      startDate: '2021-01-10',
      status: 'active',
      avatar: null
    }
  ];

  const stats = [
    { label: 'Toplam Personel', value: '45', icon: Users, color: 'text-blue-500' },
    { label: 'Aktif', value: '42', icon: Award, color: 'text-green-500' },
    { label: 'İzinde', value: '3', icon: Calendar, color: 'text-yellow-500' },
    { label: 'Departman', value: '6', icon: Filter, color: 'text-purple-500' },
  ];

  const getDepartmentLabel = (dept: string) => {
    switch (dept) {
      case 'operations': return 'Operasyon';
      case 'finance': return 'Finans';
      case 'field': return 'Saha';
      case 'hr': return 'İnsan Kaynakları';
      case 'admin': return 'Yönetim';
      default: return dept;
    }
  };

  const getInitials = (name: string) => {
    return name.split(' ').map(n => n[0]).join('').toUpperCase();
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold">Personel Yönetimi</h1>
          <p className="text-gray-500">Çalışanları yönetin ve takip edin</p>
        </div>
        <Button className="gap-2">
          <Plus className="w-4 h-4" />
          Yeni Personel Ekle
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
            <CardTitle>Personel Listesi</CardTitle>
            <div className="flex gap-2">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
                <Input
                  placeholder="Personel ara..."
                  className="pl-10 w-64"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </div>
              <Select value={filterDepartment} onValueChange={setFilterDepartment}>
                <SelectTrigger className="w-40">
                  <SelectValue placeholder="Departman" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Tümü</SelectItem>
                  <SelectItem value="operations">Operasyon</SelectItem>
                  <SelectItem value="finance">Finans</SelectItem>
                  <SelectItem value="field">Saha</SelectItem>
                  <SelectItem value="hr">İK</SelectItem>
                  <SelectItem value="admin">Yönetim</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {personnel.map((person) => (
              <div key={person.id} className="border rounded-lg p-4 hover:bg-gray-50 transition-colors">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-4">
                    <Avatar>
                      <AvatarImage src={person.avatar || ''} />
                      <AvatarFallback>{getInitials(person.name)}</AvatarFallback>
                    </Avatar>
                    <div className="flex-1">
                      <div className="flex items-center gap-3">
                        <h3 className="font-semibold">{person.name}</h3>
                        <Badge variant="secondary">{getDepartmentLabel(person.department)}</Badge>
                        <Badge className="bg-green-100 text-green-800">Aktif</Badge>
                      </div>
                      <p className="text-sm text-gray-500">{person.position}</p>
                      <div className="mt-2 flex gap-4 text-sm text-gray-500">
                        <div className="flex items-center gap-1">
                          <Mail className="w-3 h-3" />
                          {person.email}
                        </div>
                        <div className="flex items-center gap-1">
                          <Phone className="w-3 h-3" />
                          {person.phone}
                        </div>
                        <div className="flex items-center gap-1">
                          <Calendar className="w-3 h-3" />
                          Başlangıç: {new Date(person.startDate).toLocaleDateString('tr-TR')}
                        </div>
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

echo "✅ Personnel sayfası oluşturuldu!"