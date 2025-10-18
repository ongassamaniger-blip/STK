#!/bin/bash

# Approvals sayfası
cat > app/\(main\)/approvals/page.tsx << 'EOF'
'use client';

import { useState } from 'react';
import { Clock, CheckCircle, XCircle, AlertCircle, FileText, DollarSign, Users, Building2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';

export default function ApprovalsPage() {
  const [filterStatus, setFilterStatus] = useState('all');

  const approvals = [
    {
      id: '1',
      type: 'expense',
      title: 'Yetimhane Gıda Alımı',
      description: 'Umut Yetimhanesi için aylık gıda alımı',
      amount: 5000,
      requestedBy: 'Fatima Amadou',
      date: '2024-01-15',
      status: 'pending',
      priority: 'high'
    },
    {
      id: '2',
      type: 'project',
      title: 'Su Kuyusu Projesi',
      description: 'Zinder bölgesinde yeni su kuyusu açılması',
      amount: 15000,
      requestedBy: 'Ibrahim Moussa',
      date: '2024-01-14',
      status: 'pending',
      priority: 'medium'
    },
    {
      id: '3',
      type: 'personnel',
      title: 'Yeni Personel İşe Alım',
      description: 'Saha koordinatörü pozisyonu için işe alım',
      amount: null,
      requestedBy: 'HR Departmanı',
      date: '2024-01-13',
      status: 'approved',
      priority: 'low'
    },
    {
      id: '4',
      type: 'facility',
      title: 'Klinik Tadilat',
      description: 'Şifa Kliniği acil tadilat çalışması',
      amount: 8000,
      requestedBy: 'Dr. Aisha Diallo',
      date: '2024-01-12',
      status: 'rejected',
      priority: 'high'
    }
  ];

  const stats = [
    { label: 'Bekleyen', value: '12', icon: Clock, color: 'text-yellow-500' },
    { label: 'Onaylanan', value: '45', icon: CheckCircle, color: 'text-green-500' },
    { label: 'Reddedilen', value: '8', icon: XCircle, color: 'text-red-500' },
    { label: 'Toplam', value: '65', icon: FileText, color: 'text-blue-500' },
  ];

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'pending': return 'bg-yellow-100 text-yellow-800';
      case 'approved': return 'bg-green-100 text-green-800';
      case 'rejected': return 'bg-red-100 text-red-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  };

  const getStatusLabel = (status: string) => {
    switch (status) {
      case 'pending': return 'Bekliyor';
      case 'approved': return 'Onaylandı';
      case 'rejected': return 'Reddedildi';
      default: return status;
    }
  };

  const getPriorityColor = (priority: string) => {
    switch (priority) {
      case 'high': return 'text-red-500';
      case 'medium': return 'text-yellow-500';
      case 'low': return 'text-green-500';
      default: return 'text-gray-500';
    }
  };

  const getTypeIcon = (type: string) => {
    switch (type) {
      case 'expense': return DollarSign;
      case 'project': return FileText;
      case 'personnel': return Users;
      case 'facility': return Building2;
      default: return FileText;
    }
  };

  const getTypeLabel = (type: string) => {
    switch (type) {
      case 'expense': return 'Harcama';
      case 'project': return 'Proje';
      case 'personnel': return 'Personel';
      case 'facility': return 'Tesis';
      default: return type;
    }
  };

  const pendingApprovals = approvals.filter(a => a.status === 'pending');
  const filteredApprovals = filterStatus === 'all' ? approvals : approvals.filter(a => a.status === filterStatus);

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold">Onay Yönetimi</h1>
          <p className="text-gray-500">Bekleyen onayları yönetin</p>
        </div>
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

      <Tabs defaultValue="pending" className="space-y-4">
        <TabsList>
          <TabsTrigger value="pending">Bekleyenler ({pendingApprovals.length})</TabsTrigger>
          <TabsTrigger value="all">Tümü</TabsTrigger>
        </TabsList>

        <TabsContent value="pending" className="space-y-4">
          {pendingApprovals.length > 0 ? (
            pendingApprovals.map((approval) => {
              const TypeIcon = getTypeIcon(approval.type);
              return (
                <Card key={approval.id}>
                  <CardContent className="p-6">
                    <div className="flex items-start justify-between">
                      <div className="flex gap-4">
                        <div className="p-2 bg-gray-100 rounded-lg">
                          <TypeIcon className="w-6 h-6 text-gray-600" />
                        </div>
                        <div className="space-y-2">
                          <div className="flex items-center gap-2">
                            <h3 className="font-semibold">{approval.title}</h3>
                            <Badge variant="outline">{getTypeLabel(approval.type)}</Badge>
                            <AlertCircle className={`w-4 h-4 ${getPriorityColor(approval.priority)}`} />
                          </div>
                          <p className="text-sm text-gray-500">{approval.description}</p>
                          <div className="flex gap-4 text-sm text-gray-500">
                            <span>Talep Eden: {approval.requestedBy}</span>
                            {approval.amount && <span>Tutar: ${approval.amount.toLocaleString()}</span>}
                            <span>{new Date(approval.date).toLocaleDateString('tr-TR')}</span>
                          </div>
                        </div>
                      </div>
                      <div className="flex gap-2">
                        <Button variant="outline" className="gap-1">
                          <XCircle className="w-4 h-4" />
                          Reddet
                        </Button>
                        <Button className="gap-1">
                          <CheckCircle className="w-4 h-4" />
                          Onayla
                        </Button>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              );
            })
          ) : (
            <Card>
              <CardContent className="p-12 text-center">
                <CheckCircle className="w-12 h-12 text-green-500 mx-auto mb-4" />
                <p className="text-gray-500">Bekleyen onay bulunmuyor</p>
              </CardContent>
            </Card>
          )}
        </TabsContent>

        <TabsContent value="all" className="space-y-4">
          <div className="flex justify-end mb-4">
            <Select value={filterStatus} onValueChange={setFilterStatus}>
              <SelectTrigger className="w-40">
                <SelectValue placeholder="Durum" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">Tümü</SelectItem>
                <SelectItem value="pending">Bekliyor</SelectItem>
                <SelectItem value="approved">Onaylandı</SelectItem>
                <SelectItem value="rejected">Reddedildi</SelectItem>
              </SelectContent>
            </Select>
          </div>

          {filteredApprovals.map((approval) => {
            const TypeIcon = getTypeIcon(approval.type);
            return (
              <Card key={approval.id}>
                <CardContent className="p-6">
                  <div className="flex items-start justify-between">
                    <div className="flex gap-4">
                      <div className="p-2 bg-gray-100 rounded-lg">
                        <TypeIcon className="w-6 h-6 text-gray-600" />
                      </div>
                      <div className="space-y-2">
                        <div className="flex items-center gap-2">
                          <h3 className="font-semibold">{approval.title}</h3>
                          <Badge variant="outline">{getTypeLabel(approval.type)}</Badge>
                          <Badge className={getStatusColor(approval.status)}>
                            {getStatusLabel(approval.status)}
                          </Badge>
                        </div>
                        <p className="text-sm text-gray-500">{approval.description}</p>
                        <div className="flex gap-4 text-sm text-gray-500">
                          <span>Talep Eden: {approval.requestedBy}</span>
                          {approval.amount && <span>Tutar: ${approval.amount.toLocaleString()}</span>}
                          <span>{new Date(approval.date).toLocaleDateString('tr-TR')}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>
            );
          })}
        </TabsContent>
      </Tabs>
    </div>
  );
}
EOF

echo "✅ Approvals sayfası oluşturuldu!"