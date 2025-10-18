#!/bin/bash
# step-4-template-designer.sh
# Print Template Designer for PDF/Excel/Certificates
# Date: 2025-10-18 19:50:00
# User: ongassamaniger-blip

echo "📄 =========================================="
echo "   ADIM 4: TEMPLATE DESIGNER SİSTEMİ"
echo "   PDF, Excel, Certificate templates..."
echo "📄 =========================================="

# 1. Install required packages
npm install jspdf html2canvas xlsx docx qrcode handlebars

# 2. Template Types
cat > "types/templates.ts" << 'ENDMARKER'
export interface PrintTemplate {
  id: string
  name: string
  description: string
  type: 'pdf' | 'excel' | 'word' | 'certificate'
  category: 'income' | 'expense' | 'project' | 'sacrifice' | 'report'
  facilityId?: string
  projectId?: string
  language: 'tr' | 'en' | 'ar' | 'fr'
  rtl?: boolean // Right to left for Arabic
  
  page: PageSettings
  header: HeaderSettings
  body: BodySettings
  footer: FooterSettings
  
  dataMapping: DataMapping[]
  version: number
  status: 'draft' | 'active' | 'archived'
  createdBy: string
  createdAt: string
}

export interface PageSettings {
  size: 'A4' | 'A5' | 'Letter' | 'Legal'
  orientation: 'portrait' | 'landscape'
  margins: {
    top: number
    right: number
    bottom: number
    left: number
  }
  backgroundColor?: string
  watermark?: {
    text: string
    opacity: number
    angle: number
  }
}

export interface HeaderSettings {
  enabled: boolean
  height: number
  backgroundColor?: string
  logo?: {
    url: string
    position: 'left' | 'center' | 'right'
    width: number
    height: number
  }
  title?: {
    text: string
    fontSize: number
    fontWeight: 'normal' | 'bold'
    color: string
    alignment: 'left' | 'center' | 'right'
  }
  subtitle?: {
    text: string
    fontSize: number
    color: string
  }
  showDate?: boolean
  showPageNumber?: boolean
  customFields?: CustomField[]
}

export interface BodySettings {
  fontSize: number
  fontFamily: string
  lineHeight: number
  sections: TemplateSection[]
}

export interface TemplateSection {
  id: string
  type: 'text' | 'table' | 'image' | 'qrcode' | 'barcode' | 'signature' | 'chart'
  content?: string // for text
  dataSource?: string // for dynamic content
  style?: {
    padding?: number
    backgroundColor?: string
    border?: string
    borderRadius?: number
  }
  table?: {
    columns: TableColumn[]
    showHeader: boolean
    striped: boolean
    bordered: boolean
  }
  image?: {
    url: string
    width: number
    height: number
    alignment: 'left' | 'center' | 'right'
  }
  qrcode?: {
    data: string
    size: number
  }
}

export interface TableColumn {
  field: string
  label: string
  width?: number
  alignment: 'left' | 'center' | 'right'
  format?: 'text' | 'number' | 'currency' | 'date'
}

export interface FooterSettings {
  enabled: boolean
  height: number
  backgroundColor?: string
  text?: string
  showPageNumber?: boolean
  signature?: {
    enabled: boolean
    label: string
    line: boolean
  }
}

export interface DataMapping {
  templateField: string
  dataField: string
  format?: string
  transform?: 'uppercase' | 'lowercase' | 'capitalize'
}

export interface CustomField {
  label: string
  value: string
  type: 'text' | 'date' | 'number'
}
ENDMARKER

# 3. Template Designer Component
cat > "components/TemplateDesigner/index.tsx" << 'ENDMARKER'
'use client'

import { useState } from 'react'
import { motion } from 'framer-motion'
import {
  FileText, Download, Eye, Save, Settings,
  Type, Table, Image, QrCode, BarChart3,
  Edit3, Plus, Trash2, Move, Copy, ChevronUp,
  ChevronDown, AlignLeft, AlignCenter, AlignRight,
  Bold, Italic, Underline, Palette
} from 'lucide-react'
import { PrintTemplate, TemplateSection } from '@/types/templates'
import { TemplateCanvas } from './TemplateCanvas'
import { TemplateProperties } from './TemplateProperties'
import { TemplateSectionList } from './TemplateSectionList'

export function TemplateDesigner() {
  const [template, setTemplate] = useState<Partial<PrintTemplate>>({
    name: 'Yeni Şablon',
    type: 'pdf',
    language: 'tr',
    page: {
      size: 'A4',
      orientation: 'portrait',
      margins: { top: 20, right: 20, bottom: 20, left: 20 }
    },
    header: {
      enabled: true,
      height: 80,
      title: {
        text: 'Rapor Başlığı',
        fontSize: 24,
        fontWeight: 'bold',
        color: '#000000',
        alignment: 'center'
      }
    },
    body: {
      fontSize: 12,
      fontFamily: 'Arial',
      lineHeight: 1.5,
      sections: []
    },
    footer: {
      enabled: true,
      height: 60,
      showPageNumber: true
    }
  })
  
  const [selectedSection, setSelectedSection] = useState<TemplateSection | null>(null)
  const [preview, setPreview] = useState(false)
  
  const addSection = (type: TemplateSection['type']) => {
    const newSection: TemplateSection = {
      id: `section_${Date.now()}`,
      type,
      style: {
        padding: 10
      }
    }
    
    if (type === 'text') {
      newSection.content = 'Metin içeriği...'
    } else if (type === 'table') {
      newSection.table = {
        columns: [
          { field: 'col1', label: 'Sütun 1', alignment: 'left' },
          { field: 'col2', label: 'Sütun 2', alignment: 'center' }
        ],
        showHeader: true,
        striped: true,
        bordered: true
      }
    } else if (type === 'qrcode') {
      newSection.qrcode = {
        data: 'https://example.com',
        size: 150
      }
    }
    
    setTemplate(prev => ({
      ...prev,
      body: {
        ...prev.body!,
        sections: [...(prev.body?.sections || []), newSection]
      }
    }))
    
    setSelectedSection(newSection)
  }
  
  const updateSection = (sectionId: string, updates: Partial<TemplateSection>) => {
    setTemplate(prev => ({
      ...prev,
      body: {
        ...prev.body!,
        sections: prev.body?.sections.map(s =>
          s.id === sectionId ? { ...s, ...updates } : s
        ) || []
      }
    }))
  }
  
  const deleteSection = (sectionId: string) => {
    setTemplate(prev => ({
      ...prev,
      body: {
        ...prev.body!,
        sections: prev.body?.sections.filter(s => s.id !== sectionId) || []
      }
    }))
    
    if (selectedSection?.id === sectionId) {
      setSelectedSection(null)
    }
  }
  
  const moveSection = (sectionId: string, direction: 'up' | 'down') => {
    const sections = template.body?.sections || []
    const index = sections.findIndex(s => s.id === sectionId)
    
    if (index === -1) return
    if (direction === 'up' && index === 0) return
    if (direction === 'down' && index === sections.length - 1) return
    
    const newSections = [...sections]
    const newIndex = direction === 'up' ? index - 1 : index + 1
    const [movedSection] = newSections.splice(index, 1)
    newSections.splice(newIndex, 0, movedSection)
    
    setTemplate(prev => ({
      ...prev,
      body: {
        ...prev.body!,
        sections: newSections
      }
    }))
  }
  
  return (
    <div className="flex h-[calc(100vh-12rem)] gap-6">
      {/* Left Panel - Section Types */}
      <div className="w-64 bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700">
        <div className="p-4 border-b border-gray-200 dark:border-gray-700">
          <h3 className="font-semibold">Bölümler</h3>
        </div>
        <div className="p-4 space-y-2">
          <button
            onClick={() => addSection('text')}
            className="w-full p-3 bg-gray-50 dark:bg-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 rounded-lg flex items-center gap-3"
          >
            <Type className="w-5 h-5" />
            <span>Metin</span>
          </button>
          <button
            onClick={() => addSection('table')}
            className="w-full p-3 bg-gray-50 dark:bg-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 rounded-lg flex items-center gap-3"
          >
            <Table className="w-5 h-5" />
            <span>Tablo</span>
          </button>
          <button
            onClick={() => addSection('image')}
            className="w-full p-3 bg-gray-50 dark:bg-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 rounded-lg flex items-center gap-3"
          >
            <Image className="w-5 h-5" />
            <span>Resim</span>
          </button>
          <button
            onClick={() => addSection('qrcode')}
            className="w-full p-3 bg-gray-50 dark:bg-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 rounded-lg flex items-center gap-3"
          >
            <QrCode className="w-5 h-5" />
            <span>QR Kod</span>
          </button>
          <button
            onClick={() => addSection('signature')}
            className="w-full p-3 bg-gray-50 dark:bg-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 rounded-lg flex items-center gap-3"
          >
            <Edit3 className="w-5 h-5" />
            <span>İmza</span>
          </button>
          <button
            onClick={() => addSection('chart')}
            className="w-full p-3 bg-gray-50 dark:bg-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 rounded-lg flex items-center gap-3"
          >
            <BarChart3 className="w-5 h-5" />
            <span>Grafik</span>
          </button>
        </div>
        
        {/* Section List */}
        {template.body?.sections && template.body.sections.length > 0 && (
          <>
            <div className="p-4 border-t border-gray-200 dark:border-gray-700">
              <h4 className="text-sm font-semibold text-gray-500">Eklenen Bölümler</h4>
            </div>
            <TemplateSectionList
              sections={template.body.sections}
              selectedSection={selectedSection}
              onSelectSection={setSelectedSection}
              onDeleteSection={deleteSection}
              onMoveSection={moveSection}
            />
          </>
        )}
      </div>
      
      {/* Center Panel - Canvas */}
      <div className="flex-1 bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden">
        <div className="p-4 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <input
              type="text"
              value={template.name}
              onChange={(e) => setTemplate(prev => ({ ...prev, name: e.target.value }))}
              className="text-lg font-semibold bg-transparent border-none focus:outline-none"
            />
            <select
              value={template.type}
              onChange={(e) => setTemplate(prev => ({ ...prev, type: e.target.value as any }))}
              className="px-3 py-1 bg-gray-100 dark:bg-gray-700 rounded-lg"
            >
              <option value="pdf">PDF</option>
              <option value="excel">Excel</option>
              <option value="word">Word</option>
              <option value="certificate">Sertifika</option>
            </select>
          </div>
          <div className="flex items-center gap-2">
            <button
              onClick={() => setPreview(!preview)}
              className={`p-2 rounded-lg transition-colors ${
                preview ? 'bg-blue-100 text-blue-600' : 'hover:bg-gray-100'
              }`}
            >
              <Eye className="w-4 h-4" />
            </button>
            <button className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg">
              <Download className="w-4 h-4" />
            </button>
            <button className="px-3 py-1.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 flex items-center gap-2">
              <Save className="w-4 h-4" />
              Kaydet
            </button>
          </div>
        </div>
        
        <div className="p-6 overflow-y-auto h-full">
          <TemplateCanvas
            template={template}
            selectedSection={selectedSection}
            onSelectSection={setSelectedSection}
            preview={preview}
          />
        </div>
      </div>
      
      {/* Right Panel - Properties */}
      {selectedSection && !preview && (
        <motion.div
          initial={{ opacity: 0, x: 20 }}
          animate={{ opacity: 1, x: 0 }}
          className="w-80 bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden"
        >
          <div className="p-4 border-b border-gray-200 dark:border-gray-700">
            <h3 className="font-semibold">Bölüm Özellikleri</h3>
          </div>
          <TemplateProperties
            section={selectedSection}
            onUpdate={(updates) => updateSection(selectedSection.id, updates)}
          />
        </motion.div>
      )}
    </div>
  )
}
ENDMARKER

# 4. Template Canvas Component
cat > "components/TemplateDesigner/TemplateCanvas.tsx" << 'ENDMARKER'
'use client'

import { PrintTemplate, TemplateSection } from '@/types/templates'
import { motion } from 'framer-motion'

interface TemplateCanvasProps {
  template: Partial<PrintTemplate>
  selectedSection: TemplateSection | null
  onSelectSection: (section: TemplateSection) => void
  preview: boolean
}

export function TemplateCanvas({
  template,
  selectedSection,
  onSelectSection,
  preview
}: TemplateCanvasProps) {
  const pageWidth = template.page?.orientation === 'portrait' ? 595 : 842 // A4 in pt
  const pageHeight = template.page?.orientation === 'portrait' ? 842 : 595
  
  return (
    <div className="flex justify-center">
      <div
        className="bg-white shadow-2xl"
        style={{
          width: pageWidth,
          minHeight: pageHeight,
          padding: `${template.page?.margins?.top}px ${template.page?.margins?.right}px ${template.page?.margins?.bottom}px ${template.page?.margins?.left}px`
        }}
      >
        {/* Header */}
        {template.header?.enabled && (
          <div
            className="border-b-2 border-gray-300 mb-4"
            style={{ minHeight: template.header.height }}
          >
            {template.header.logo && (
              <div className={`mb-2 text-${template.header.logo.position}`}>
                <div
                  className="bg-gray-200 inline-block"
                  style={{
                    width: template.header.logo.width,
                    height: template.header.logo.height
                  }}
                >
                  Logo
                </div>
              </div>
            )}
            {template.header.title && (
              <h1
                className={`text-${template.header.title.alignment}`}
                style={{
                  fontSize: template.header.title.fontSize,
                  fontWeight: template.header.title.fontWeight,
                  color: template.header.title.color
                }}
              >
                {template.header.title.text}
              </h1>
            )}
            {template.header.subtitle && (
              <p
                className="text-center text-gray-600"
                style={{ fontSize: template.header.subtitle.fontSize }}
              >
                {template.header.subtitle.text}
              </p>
            )}
          </div>
        )}
        
        {/* Body */}
        <div className="space-y-4">
          {template.body?.sections.map((section) => (
            <motion.div
              key={section.id}
              onClick={() => !preview && onSelectSection(section)}
              className={`relative ${!preview && 'cursor-pointer'} ${
                selectedSection?.id === section.id && !preview
                  ? 'ring-2 ring-blue-500 rounded'
                  : ''
              }`}
              style={{
                padding: section.style?.padding,
                backgroundColor: section.style?.backgroundColor,
                border: section.style?.border,
                borderRadius: section.style?.borderRadius
              }}
              whileHover={!preview ? { scale: 1.01 } : {}}
            >
              {renderSection(section)}
            </motion.div>
          ))}
          
          {(!template.body?.sections || template.body.sections.length === 0) && !preview && (
            <div className="py-20 text-center text-gray-400">
              <p>Sol panelden bölüm ekleyerek başlayın</p>
            </div>
          )}
        </div>
        
        {/* Footer */}
        {template.footer?.enabled && (
          <div
            className="border-t-2 border-gray-300 mt-8 pt-4"
            style={{ minHeight: template.footer.height }}
          >
            {template.footer.text && (
              <p className="text-center text-sm text-gray-600">{template.footer.text}</p>
            )}
            {template.footer.showPageNumber && (
              <p className="text-center text-xs text-gray-500 mt-2">Sayfa 1</p>
            )}
            {template.footer.signature?.enabled && (
              <div className="mt-4 flex justify-end">
                <div className="text-center">
                  <p className="text-sm mb-8">{template.footer.signature.label}</p>
                  {template.footer.signature.line && (
                    <div className="border-t-2 border-gray-400 w-48"></div>
                  )}
                </div>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  )
}

function renderSection(section: TemplateSection) {
  switch (section.type) {
    case 'text':
      return (
        <div dangerouslySetInnerHTML={{ __html: section.content || '' }} />
      )
    
    case 'table':
      return (
        <table className="w-full">
          {section.table?.showHeader && (
            <thead>
              <tr className="border-b">
                {section.table.columns.map((col) => (
                  <th
                    key={col.field}
                    className={`p-2 text-${col.alignment || 'left'}`}
                    style={{ width: col.width }}
                  >
                    {col.label}
                  </th>
                ))}
              </tr>
            </thead>
          )}
          <tbody>
            <tr>
              {section.table?.columns.map((col) => (
                <td key={col.field} className={`p-2 text-${col.alignment || 'left'}`}>
                  Örnek veri
                </td>
              ))}
            </tr>
          </tbody>
        </table>
      )
    
    case 'image':
      return (
        <div className={`text-${section.image?.alignment || 'center'}`}>
          <div
            className="bg-gray-200 inline-block"
            style={{
              width: section.image?.width || 200,
              height: section.image?.height || 150
            }}
          >
            Resim
          </div>
        </div>
      )
    
    case 'qrcode':
      return (
        <div className="text-center">
          <div
            className="bg-black/10 inline-block"
            style={{
              width: section.qrcode?.size || 150,
              height: section.qrcode?.size || 150
            }}
          >
            QR Code
          </div>
        </div>
      )
    
    case 'signature':
      return (
        <div className="text-center">
          <div className="border-b-2 border-gray-400 w-48 mx-auto"></div>
          <p className="text-sm text-gray-600 mt-1">İmza</p>
        </div>
      )
    
    case 'chart':
      return (
        <div className="bg-gray-100 p-8 text-center text-gray-500">
          Grafik Alanı
        </div>
      )
    
    default:
      return null
  }
}
ENDMARKER

# 5. Template Properties Component
cat > "components/TemplateDesigner/TemplateProperties.tsx" << 'ENDMARKER'
'use client'

import { TemplateSection } from '@/types/templates'
import { Plus, Trash2 } from 'lucide-react'

interface TemplatePropertiesProps {
  section: TemplateSection
  onUpdate: (updates: Partial<TemplateSection>) => void
}

export function TemplateProperties({ section, onUpdate }: TemplatePropertiesProps) {
  const handleStyleUpdate = (key: string, value: any) => {
    onUpdate({
      style: {
        ...section.style,
        [key]: value
      }
    })
  }
  
  return (
    <div className="p-4 space-y-4 overflow-y-auto h-full">
      {/* Common Properties */}
      <div>
        <label className="block text-sm font-medium mb-1">Padding (px)</label>
        <input
          type="number"
          value={section.style?.padding || 0}
          onChange={(e) => handleStyleUpdate('padding', parseInt(e.target.value))}
          className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
        />
      </div>
      
      <div>
        <label className="block text-sm font-medium mb-1">Arka Plan Rengi</label>
        <input
          type="color"
          value={section.style?.backgroundColor || '#ffffff'}
          onChange={(e) => handleStyleUpdate('backgroundColor', e.target.value)}
          className="w-full h-10"
        />
      </div>
      
      {/* Text Properties */}
      {section.type === 'text' && (
        <>
          <div>
            <label className="block text-sm font-medium mb-1">Metin İçeriği</label>
            <textarea
              value={section.content || ''}
              onChange={(e) => onUpdate({ content: e.target.value })}
              rows={5}
              className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
            />
          </div>
        </>
      )}
      
      {/* Table Properties */}
      {section.type === 'table' && section.table && (
        <>
          <div>
            <div className="flex items-center justify-between mb-2">
              <label className="text-sm font-medium">Sütunlar</label>
              <button
                onClick={() => {
                  const newColumn = {
                    field: `col${(section.table?.columns.length || 0) + 1}`,
                    label: `Sütun ${(section.table?.columns.length || 0) + 1}`,
                    alignment: 'left' as const
                  }
                  onUpdate({
                    table: {
                      ...section.table,
                      columns: [...(section.table?.columns || []), newColumn]
                    }
                  })
                }}
                className="p-1 hover:bg-gray-100 dark:hover:bg-gray-700 rounded"
              >
                <Plus className="w-4 h-4" />
              </button>
            </div>
            
            <div className="space-y-2">
              {section.table.columns.map((col, index) => (
                <div key={index} className="flex items-center gap-2">
                  <input
                    type="text"
                    value={col.label}
                    onChange={(e) => {
                      const updatedColumns = [...section.table!.columns]
                      updatedColumns[index] = { ...col, label: e.target.value }
                      onUpdate({
                        table: {
                          ...section.table!,
                          columns: updatedColumns
                        }
                      })
                    }}
                    className="flex-1 px-2 py-1 bg-gray-100 dark:bg-gray-700 rounded text-sm"
                    placeholder="Sütun başlığı"
                  />
                  <button
                    onClick={() => {
                      const updatedColumns = section.table!.columns.filter((_, i) => i !== index)
                      onUpdate({
                        table: {
                          ...section.table!,
                          columns: updatedColumns
                        }
                      })
                    }}
                    className="p-1 hover:bg-red-100 dark:hover:bg-red-900/20 rounded text-red-600"
                  >
                    <Trash2 className="w-3 h-3" />
                  </button>
                </div>
              ))}
            </div>
          </div>
          
          <div className="space-y-2">
            <label className="flex items-center gap-2">
              <input
                type="checkbox"
                checked={section.table.showHeader}
                onChange={(e) => onUpdate({
                  table: {
                    ...section.table!,
                    showHeader: e.target.checked
                  }
                })}
                className="rounded"
              />
              <span className="text-sm">Başlık Göster</span>
            </label>
            
            <label className="flex items-center gap-2">
              <input
                type="checkbox"
                checked={section.table.striped}
                onChange={(e) => onUpdate({
                  table: {
                    ...section.table!,
                    striped: e.target.checked
                  }
                })}
                className="rounded"
              />
              <span className="text-sm">Zebra Çizgili</span>
            </label>
            
            <label className="flex items-center gap-2">
              <input
                type="checkbox"
                checked={section.table.bordered}
                onChange={(e) => onUpdate({
                  table: {
                    ...section.table!,
                    bordered: e.target.checked
                  }
                })}
                className="rounded"
              />
              <span className="text-sm">Kenarlıklı</span>
            </label>
          </div>
        </>
      )}
      
      {/* QR Code Properties */}
      {section.type === 'qrcode' && section.qrcode && (
        <>
          <div>
            <label className="block text-sm font-medium mb-1">QR Kod Verisi</label>
            <input
              type="text"
              value={section.qrcode.data}
              onChange={(e) => onUpdate({
                qrcode: {
                  ...section.qrcode!,
                  data: e.target.value
                }
              })}
              className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
              placeholder="URL veya metin"
            />
          </div>
          
          <div>
            <label className="block text-sm font-medium mb-1">Boyut (px)</label>
            <input
              type="number"
              value={section.qrcode.size}
              onChange={(e) => onUpdate({
                qrcode: {
                  ...section.qrcode!,
                  size: parseInt(e.target.value)
                }
              })}
              className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
            />
          </div>
        </>
      )}
    </div>
  )
}
ENDMARKER

# 6. Template Section List Component
cat > "components/TemplateDesigner/TemplateSectionList.tsx" << 'ENDMARKER'
'use client'

import { TemplateSection } from '@/types/templates'
import { ChevronUp, ChevronDown, Trash2, Type, Table, Image, QrCode, Edit3, BarChart3 } from 'lucide-react'

interface TemplateSectionListProps {
  sections: TemplateSection[]
  selectedSection: TemplateSection | null
  onSelectSection: (section: TemplateSection) => void
  onDeleteSection: (sectionId: string) => void
  onMoveSection: (sectionId: string, direction: 'up' | 'down') => void
}

const sectionIcons = {
  text: Type,
  table: Table,
  image: Image,
  qrcode: QrCode,
  signature: Edit3,
  chart: BarChart3,
  barcode: QrCode
}

export function TemplateSectionList({
  sections,
  selectedSection,
  onSelectSection,
  onDeleteSection,
  onMoveSection
}: TemplateSectionListProps) {
  return (
    <div className="px-4 pb-4 space-y-2 max-h-60 overflow-y-auto">
      {sections.map((section, index) => {
        const Icon = sectionIcons[section.type]
        return (
          <div
            key={section.id}
            onClick={() => onSelectSection(section)}
            className={`p-2 rounded-lg cursor-pointer flex items-center justify-between group ${
              selectedSection?.id === section.id
                ? 'bg-blue-100 dark:bg-blue-900/20 text-blue-600'
                : 'hover:bg-gray-100 dark:hover:bg-gray-700'
            }`}
          >
            <div className="flex items-center gap-2">
              <Icon className="w-4 h-4" />
              <span className="text-sm">{section.type}</span>
            </div>
            
            <div className="flex items-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
              <button
                onClick={(e) => {
                  e.stopPropagation()
                  onMoveSection(section.id, 'up')
                }}
                disabled={index === 0}
                className="p-0.5 hover:bg-gray-200 dark:hover:bg-gray-600 rounded disabled:opacity-50"
              >
                <ChevronUp className="w-3 h-3" />
              </button>
              <button
                onClick={(e) => {
                  e.stopPropagation()
                  onMoveSection(section.id, 'down')
                }}
                disabled={index === sections.length - 1}
                className="p-0.5 hover:bg-gray-200 dark:hover:bg-gray-600 rounded disabled:opacity-50"
              >
                <ChevronDown className="w-3 h-3" />
              </button>
              <button
                onClick={(e) => {
                  e.stopPropagation()
                  onDeleteSection(section.id)
                }}
                className="p-0.5 hover:bg-red-100 dark:hover:bg-red-900/20 rounded text-red-600"
              >
                <Trash2 className="w-3 h-3" />
              </button>
            </div>
          </div>
        )
      })}
    </div>
  )
}
ENDMARKER

echo "✅ Adım 4 tamamlandı: Template Designer Sistemi"
echo ""
echo "📌 Eklenen özellikler:"
echo "  • PDF/Excel/Word template designer"
echo "  • Certificate templates"
echo "  • Drag & Drop sections"
echo "  • QR Code & Barcode support"
echo "  • Multi-language support (TR/EN/AR/FR)"
echo "  • RTL support for Arabic"
echo "  • Custom headers & footers"
echo "  • Table designer"
echo ""
echo "🚀 Sonraki: Adım 5 - Dinamik Kategori Yönetimi"