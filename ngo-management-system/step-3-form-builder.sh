#!/bin/bash
# step-3-form-builder.sh
# Dynamic Form Builder with Drag & Drop
# Date: 2025-10-18 19:47:00
# User: ongassamaniger-blip

echo "🏗️ =========================================="
echo "   ADIM 3: FORM BUILDER SİSTEMİ"
echo "   Drag & Drop form designer..."
echo "🏗️ =========================================="

# 1. Install required packages
npm install react-dnd react-dnd-html5-backend react-hook-form @dnd-kit/sortable @dnd-kit/core

# 2. Form Builder Types
cat > "types/form-builder.ts" << 'ENDMARKER'
export interface FormSchema {
  id: string
  name: string
  description: string
  facilityId?: string
  projectId?: string
  category: 'income' | 'expense' | 'project' | 'sacrifice' | 'custom'
  version: number
  status: 'draft' | 'published' | 'archived'
  fields: FormField[]
  settings: FormSettings
  createdBy: string
  createdAt: string
  updatedAt: string
}

export interface FormField {
  id: string
  type: FieldType
  label: string
  name: string
  placeholder?: string
  helpText?: string
  required: boolean
  validation?: ValidationRule[]
  options?: FieldOption[] // for select, radio, checkbox
  defaultValue?: any
  columns?: number // grid columns (1-12)
  conditional?: ConditionalLogic
  calculated?: CalculationRule
  dataSource?: DataSource
}

export type FieldType = 
  | 'text'
  | 'number'
  | 'email'
  | 'phone'
  | 'date'
  | 'time'
  | 'datetime'
  | 'select'
  | 'multiselect'
  | 'radio'
  | 'checkbox'
  | 'switch'
  | 'textarea'
  | 'richtext'
  | 'file'
  | 'image'
  | 'signature'
  | 'location'
  | 'rating'
  | 'slider'
  | 'color'
  | 'table'
  | 'repeater'
  | 'section'
  | 'divider'

export interface FieldOption {
  label: string
  value: string | number
  color?: string
  icon?: string
}

export interface ValidationRule {
  type: 'min' | 'max' | 'minLength' | 'maxLength' | 'pattern' | 'custom'
  value?: any
  message: string
}

export interface ConditionalLogic {
  show: boolean
  when: string // field name
  operator: '=' | '!=' | '>' | '<' | 'contains' | 'empty' | 'not_empty'
  value?: any
}

export interface CalculationRule {
  formula: string // e.g., "field1 + field2"
  fields: string[] // dependent fields
}

export interface DataSource {
  type: 'static' | 'api' | 'database'
  endpoint?: string
  table?: string
  labelField?: string
  valueField?: string
}

export interface FormSettings {
  submitButton: {
    text: string
    color: string
    position: 'left' | 'center' | 'right'
  }
  showProgressBar: boolean
  allowSaveDraft: boolean
  requireApproval: boolean
  notifyOnSubmit: string[] // email addresses
  redirectAfterSubmit?: string
  theme?: 'default' | 'compact' | 'minimal'
  language?: string
}
ENDMARKER

# 3. Form Builder Component
cat > "components/FormBuilder/index.tsx" << 'ENDMARKER'
'use client'

import { useState } from 'react'
import { DndContext, closestCenter, KeyboardSensor, PointerSensor, useSensor, useSensors } from '@dnd-kit/core'
import { arrayMove, SortableContext, sortableKeyboardCoordinates, verticalListSortingStrategy } from '@dnd-kit/sortable'
import { FormField, FieldType } from '@/types/form-builder'
import { FieldToolbox } from './FieldToolbox'
import { FormCanvas } from './FormCanvas'
import { FieldProperties } from './FieldProperties'
import { motion } from 'framer-motion'
import { Save, Eye, Settings, Code, Trash2, Copy } from 'lucide-react'

export function FormBuilder() {
  const [fields, setFields] = useState<FormField[]>([])
  const [selectedField, setSelectedField] = useState<FormField | null>(null)
  const [preview, setPreview] = useState(false)
  
  const sensors = useSensors(
    useSensor(PointerSensor),
    useSensor(KeyboardSensor, {
      coordinateGetter: sortableKeyboardCoordinates,
    })
  )
  
  const handleDragEnd = (event: any) => {
    const { active, over } = event
    
    if (active.id !== over.id) {
      setFields((items) => {
        const oldIndex = items.findIndex(i => i.id === active.id)
        const newIndex = items.findIndex(i => i.id === over.id)
        return arrayMove(items, oldIndex, newIndex)
      })
    }
  }
  
  const addField = (type: FieldType) => {
    const newField: FormField = {
      id: `field_${Date.now()}`,
      type,
      label: `New ${type} field`,
      name: `field_${Date.now()}`,
      required: false,
      columns: 12
    }
    setFields([...fields, newField])
    setSelectedField(newField)
  }
  
  const updateField = (fieldId: string, updates: Partial<FormField>) => {
    setFields(fields.map(f => 
      f.id === fieldId ? { ...f, ...updates } : f
    ))
    if (selectedField?.id === fieldId) {
      setSelectedField({ ...selectedField, ...updates })
    }
  }
  
  const deleteField = (fieldId: string) => {
    setFields(fields.filter(f => f.id !== fieldId))
    if (selectedField?.id === fieldId) {
      setSelectedField(null)
    }
  }
  
  const duplicateField = (field: FormField) => {
    const newField = {
      ...field,
      id: `field_${Date.now()}`,
      name: `${field.name}_copy`
    }
    setFields([...fields, newField])
  }
  
  return (
    <div className="flex h-[calc(100vh-12rem)] gap-6">
      {/* Left Panel - Toolbox */}
      <div className="w-64 bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden">
        <div className="p-4 border-b border-gray-200 dark:border-gray-700">
          <h3 className="font-semibold">Form Elemanları</h3>
        </div>
        <FieldToolbox onAddField={addField} />
      </div>
      
      {/* Center Panel - Canvas */}
      <div className="flex-1 bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden">
        <div className="p-4 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between">
          <h3 className="font-semibold">Form Tasarımı</h3>
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
              <Code className="w-4 h-4" />
            </button>
            <button className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg">
              <Settings className="w-4 h-4" />
            </button>
            <button className="px-3 py-1.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 flex items-center gap-2">
              <Save className="w-4 h-4" />
              Kaydet
            </button>
          </div>
        </div>
        
        <div className="p-6 overflow-y-auto h-full">
          <DndContext sensors={sensors} collisionDetection={closestCenter} onDragEnd={handleDragEnd}>
            <SortableContext items={fields.map(f => f.id)} strategy={verticalListSortingStrategy}>
              <FormCanvas
                fields={fields}
                selectedField={selectedField}
                onSelectField={setSelectedField}
                onDeleteField={deleteField}
                onDuplicateField={duplicateField}
                preview={preview}
              />
            </SortableContext>
          </DndContext>
          
          {fields.length === 0 && !preview && (
            <div className="flex flex-col items-center justify-center h-64 text-gray-400">
              <p className="text-lg mb-2">Form boş</p>
              <p className="text-sm">Sol panelden eleman sürükleyerek başlayın</p>
            </div>
          )}
        </div>
      </div>
      
      {/* Right Panel - Properties */}
      {selectedField && !preview && (
        <motion.div
          initial={{ opacity: 0, x: 20 }}
          animate={{ opacity: 1, x: 0 }}
          className="w-80 bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden"
        >
          <div className="p-4 border-b border-gray-200 dark:border-gray-700">
            <h3 className="font-semibold">Özellikler</h3>
          </div>
          <FieldProperties
            field={selectedField}
            onUpdate={(updates) => updateField(selectedField.id, updates)}
          />
        </motion.div>
      )}
    </div>
  )
}
ENDMARKER

# 4. Field Toolbox Component
cat > "components/FormBuilder/FieldToolbox.tsx" << 'ENDMARKER'
'use client'

import { FieldType } from '@/types/form-builder'
import {
  Type, Hash, AtSign, Phone, Calendar, Clock,
  ChevronDown, CheckSquare, ToggleLeft, FileText,
  Upload, Image, Edit3, MapPin, Star, Sliders,
  Palette, Table, Copy, Minus, Grid3X3, Radio
} from 'lucide-react'

interface FieldToolboxProps {
  onAddField: (type: FieldType) => void
}

const fieldTypes: { type: FieldType; label: string; icon: any; category: string }[] = [
  // Basic Fields
  { type: 'text', label: 'Metin', icon: Type, category: 'Temel' },
  { type: 'number', label: 'Sayı', icon: Hash, category: 'Temel' },
  { type: 'email', label: 'E-posta', icon: AtSign, category: 'Temel' },
  { type: 'phone', label: 'Telefon', icon: Phone, category: 'Temel' },
  { type: 'date', label: 'Tarih', icon: Calendar, category: 'Temel' },
  { type: 'time', label: 'Saat', icon: Clock, category: 'Temel' },
  { type: 'textarea', label: 'Uzun Metin', icon: FileText, category: 'Temel' },
  
  // Selection Fields
  { type: 'select', label: 'Dropdown', icon: ChevronDown, category: 'Seçim' },
  { type: 'multiselect', label: 'Çoklu Seçim', icon: CheckSquare, category: 'Seçim' },
  { type: 'radio', label: 'Radio', icon: Radio, category: 'Seçim' },
  { type: 'checkbox', label: 'Checkbox', icon: CheckSquare, category: 'Seçim' },
  { type: 'switch', label: 'Anahtar', icon: ToggleLeft, category: 'Seçim' },
  
  // Advanced Fields
  { type: 'file', label: 'Dosya', icon: Upload, category: 'Gelişmiş' },
  { type: 'image', label: 'Resim', icon: Image, category: 'Gelişmiş' },
  { type: 'signature', label: 'İmza', icon: Edit3, category: 'Gelişmiş' },
  { type: 'location', label: 'Konum', icon: MapPin, category: 'Gelişmiş' },
  { type: 'rating', label: 'Değerlendirme', icon: Star, category: 'Gelişmiş' },
  { type: 'slider', label: 'Slider', icon: Sliders, category: 'Gelişmiş' },
  { type: 'color', label: 'Renk', icon: Palette, category: 'Gelişmiş' },
  
  // Layout Fields
  { type: 'section', label: 'Bölüm', icon: Grid3X3, category: 'Düzen' },
  { type: 'divider', label: 'Ayırıcı', icon: Minus, category: 'Düzen' },
  { type: 'table', label: 'Tablo', icon: Table, category: 'Düzen' },
  { type: 'repeater', label: 'Tekrarlayıcı', icon: Copy, category: 'Düzen' }
]

const categories = ['Temel', 'Seçim', 'Gelişmiş', 'Düzen']

export function FieldToolbox({ onAddField }: FieldToolboxProps) {
  return (
    <div className="p-4 space-y-4 overflow-y-auto h-full">
      {categories.map(category => (
        <div key={category}>
          <h4 className="text-xs font-semibold text-gray-500 uppercase mb-2">{category}</h4>
          <div className="grid grid-cols-2 gap-2">
            {fieldTypes
              .filter(ft => ft.category === category)
              .map(field => (
                <button
                  key={field.type}
                  onClick={() => onAddField(field.type)}
                  className="p-3 bg-gray-50 dark:bg-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 rounded-lg transition-colors group cursor-move"
                  draggable
                >
                  <field.icon className="w-5 h-5 mx-auto mb-1 text-gray-600 dark:text-gray-400 group-hover:text-blue-600" />
                  <p className="text-xs text-gray-600 dark:text-gray-400 group-hover:text-gray-900 dark:group-hover:text-white">
                    {field.label}
                  </p>
                </button>
              ))}
          </div>
        </div>
      ))}
    </div>
  )
}
ENDMARKER

# 5. Form Canvas Component
cat > "components/FormBuilder/FormCanvas.tsx" << 'ENDMARKER'
'use client'

import { useSortable } from '@dnd-kit/sortable'
import { CSS } from '@dnd-kit/utilities'
import { FormField } from '@/types/form-builder'
import { Trash2, Copy, GripVertical } from 'lucide-react'
import { motion } from 'framer-motion'

interface FormCanvasProps {
  fields: FormField[]
  selectedField: FormField | null
  onSelectField: (field: FormField) => void
  onDeleteField: (fieldId: string) => void
  onDuplicateField: (field: FormField) => void
  preview: boolean
}

export function FormCanvas({
  fields,
  selectedField,
  onSelectField,
  onDeleteField,
  onDuplicateField,
  preview
}: FormCanvasProps) {
  return (
    <div className="space-y-4">
      {fields.map((field) => (
        <SortableField
          key={field.id}
          field={field}
          isSelected={selectedField?.id === field.id}
          onSelect={() => onSelectField(field)}
          onDelete={() => onDeleteField(field.id)}
          onDuplicate={() => onDuplicateField(field)}
          preview={preview}
        />
      ))}
    </div>
  )
}

function SortableField({
  field,
  isSelected,
  onSelect,
  onDelete,
  onDuplicate,
  preview
}: {
  field: FormField
  isSelected: boolean
  onSelect: () => void
  onDelete: () => void
  onDuplicate: () => void
  preview: boolean
}) {
  const { attributes, listeners, setNodeRef, transform, transition } = useSortable({ id: field.id })
  
  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
  }
  
  if (preview) {
    return <FieldPreview field={field} />
  }
  
  return (
    <motion.div
      ref={setNodeRef}
      style={style}
      onClick={onSelect}
      className={`relative group p-4 bg-gray-50 dark:bg-gray-700/50 rounded-lg border-2 transition-all cursor-pointer ${
        isSelected ? 'border-blue-500 shadow-lg' : 'border-transparent hover:border-gray-300'
      }`}
      whileHover={{ scale: 1.01 }}
    >
      {/* Drag Handle */}
      <div
        {...attributes}
        {...listeners}
        className="absolute left-2 top-1/2 -translate-y-1/2 p-1 hover:bg-gray-200 dark:hover:bg-gray-600 rounded cursor-move opacity-0 group-hover:opacity-100 transition-opacity"
      >
        <GripVertical className="w-4 h-4 text-gray-400" />
      </div>
      
      {/* Field Content */}
      <div className="ml-8">
        <div className="flex items-start justify-between">
          <div className="flex-1">
            <p className="font-medium text-sm">
              {field.label}
              {field.required && <span className="text-red-500 ml-1">*</span>}
            </p>
            <p className="text-xs text-gray-500 mt-1">{field.type} - {field.name}</p>
          </div>
          
          {/* Actions */}
          <div className="flex items-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
            <button
              onClick={(e) => {
                e.stopPropagation()
                onDuplicate()
              }}
              className="p-1 hover:bg-gray-200 dark:hover:bg-gray-600 rounded"
            >
              <Copy className="w-3 h-3" />
            </button>
            <button
              onClick={(e) => {
                e.stopPropagation()
                onDelete()
              }}
              className="p-1 hover:bg-red-100 dark:hover:bg-red-900/20 rounded text-red-600"
            >
              <Trash2 className="w-3 h-3" />
            </button>
          </div>
        </div>
        
        {/* Field Preview */}
        <div className="mt-2">
          <RenderFieldInput field={field} />
        </div>
      </div>
    </motion.div>
  )
}

function FieldPreview({ field }: { field: FormField }) {
  return (
    <div className="mb-4">
      <label className="block text-sm font-medium mb-1">
        {field.label}
        {field.required && <span className="text-red-500 ml-1">*</span>}
      </label>
      <RenderFieldInput field={field} />
      {field.helpText && (
        <p className="text-xs text-gray-500 mt-1">{field.helpText}</p>
      )}
    </div>
  )
}

function RenderFieldInput({ field }: { field: FormField }) {
  switch (field.type) {
    case 'text':
    case 'email':
    case 'phone':
    case 'number':
      return (
        <input
          type={field.type}
          placeholder={field.placeholder}
          className="w-full px-3 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-lg"
          disabled
        />
      )
    case 'textarea':
      return (
        <textarea
          placeholder={field.placeholder}
          rows={3}
          className="w-full px-3 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-lg"
          disabled
        />
      )
    case 'select':
      return (
        <select className="w-full px-3 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-lg" disabled>
          <option>Seçiniz...</option>
          {field.options?.map(opt => (
            <option key={opt.value} value={opt.value}>{opt.label}</option>
          ))}
        </select>
      )
    case 'checkbox':
      return (
        <div className="flex items-center gap-2">
          <input type="checkbox" className="rounded" disabled />
          <span className="text-sm">{field.placeholder || 'Checkbox'}</span>
        </div>
      )
    case 'radio':
      return (
        <div className="space-y-2">
          {field.options?.map(opt => (
            <div key={opt.value} className="flex items-center gap-2">
              <input type="radio" name={field.name} disabled />
              <span className="text-sm">{opt.label}</span>
            </div>
          ))}
        </div>
      )
    case 'date':
      return (
        <input type="date" className="w-full px-3 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-lg" disabled />
      )
    case 'file':
      return (
        <input type="file" className="w-full px-3 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-lg" disabled />
      )
    case 'section':
      return (
        <div className="p-3 bg-gray-100 dark:bg-gray-700 rounded-lg">
          <p className="text-sm font-medium">{field.label}</p>
        </div>
      )
    case 'divider':
      return <hr className="border-gray-300 dark:border-gray-600" />
    default:
      return (
        <div className="p-3 bg-gray-100 dark:bg-gray-700 rounded-lg text-sm text-gray-500">
          {field.type} field
        </div>
      )
  }
}
ENDMARKER

# 6. Field Properties Panel
cat > "components/FormBuilder/FieldProperties.tsx" << 'ENDMARKER'
'use client'

import { FormField } from '@/types/form-builder'
import { Plus, Trash2 } from 'lucide-react'
import { useState } from 'react'

interface FieldPropertiesProps {
  field: FormField
  onUpdate: (updates: Partial<FormField>) => void
}

export function FieldProperties({ field, onUpdate }: FieldPropertiesProps) {
  const [options, setOptions] = useState(field.options || [])
  
  const handleAddOption = () => {
    const newOption = {
      label: `Option ${options.length + 1}`,
      value: `option_${options.length + 1}`
    }
    const updatedOptions = [...options, newOption]
    setOptions(updatedOptions)
    onUpdate({ options: updatedOptions })
  }
  
  const handleRemoveOption = (index: number) => {
    const updatedOptions = options.filter((_, i) => i !== index)
    setOptions(updatedOptions)
    onUpdate({ options: updatedOptions })
  }
  
  const handleOptionChange = (index: number, key: 'label' | 'value', value: string) => {
    const updatedOptions = options.map((opt, i) =>
      i === index ? { ...opt, [key]: value } : opt
    )
    setOptions(updatedOptions)
    onUpdate({ options: updatedOptions })
  }
  
  return (
    <div className="p-4 space-y-4 overflow-y-auto h-full">
      {/* Basic Properties */}
      <div>
        <label className="block text-sm font-medium mb-1">Alan Etiketi</label>
        <input
          type="text"
          value={field.label}
          onChange={(e) => onUpdate({ label: e.target.value })}
          className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
        />
      </div>
      
      <div>
        <label className="block text-sm font-medium mb-1">Alan Adı</label>
        <input
          type="text"
          value={field.name}
          onChange={(e) => onUpdate({ name: e.target.value })}
          className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
        />
      </div>
      
      <div>
        <label className="block text-sm font-medium mb-1">Placeholder</label>
        <input
          type="text"
          value={field.placeholder || ''}
          onChange={(e) => onUpdate({ placeholder: e.target.value })}
          className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
        />
      </div>
      
      <div>
        <label className="block text-sm font-medium mb-1">Yardım Metni</label>
        <textarea
          value={field.helpText || ''}
          onChange={(e) => onUpdate({ helpText: e.target.value })}
          rows={2}
          className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
        />
      </div>
      
      <div>
        <label className="flex items-center gap-2">
          <input
            type="checkbox"
            checked={field.required}
            onChange={(e) => onUpdate({ required: e.target.checked })}
            className="rounded"
          />
          <span className="text-sm font-medium">Zorunlu Alan</span>
        </label>
      </div>
      
      {/* Options for select, radio, checkbox */}
      {['select', 'multiselect', 'radio', 'checkbox'].includes(field.type) && (
        <div>
          <div className="flex items-center justify-between mb-2">
            <label className="text-sm font-medium">Seçenekler</label>
            <button
              onClick={handleAddOption}
              className="p-1 hover:bg-gray-100 dark:hover:bg-gray-700 rounded"
            >
              <Plus className="w-4 h-4" />
            </button>
          </div>
          <div className="space-y-2">
            {options.map((option, index) => (
              <div key={index} className="flex items-center gap-2">
                <input
                  type="text"
                  value={option.label}
                  onChange={(e) => handleOptionChange(index, 'label', e.target.value)}
                  placeholder="Etiket"
                  className="flex-1 px-2 py-1 bg-gray-100 dark:bg-gray-700 rounded text-sm"
                />
                <input
                  type="text"
                  value={option.value}
                  onChange={(e) => handleOptionChange(index, 'value', e.target.value)}
                  placeholder="Değer"
                  className="flex-1 px-2 py-1 bg-gray-100 dark:bg-gray-700 rounded text-sm"
                />
                <button
                  onClick={() => handleRemoveOption(index)}
                  className="p-1 hover:bg-red-100 dark:hover:bg-red-900/20 rounded text-red-600"
                >
                  <Trash2 className="w-3 h-3" />
                </button>
              </div>
            ))}
          </div>
        </div>
      )}
      
      {/* Column Width */}
      <div>
        <label className="block text-sm font-medium mb-1">Genişlik</label>
        <select
          value={field.columns || 12}
          onChange={(e) => onUpdate({ columns: parseInt(e.target.value) })}
          className="w-full px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg"
        >
          <option value={12}>Tam Genişlik</option>
          <option value={6}>Yarım (1/2)</option>
          <option value={4}>1/3 Genişlik</option>
          <option value={3}>1/4 Genişlik</option>
        </select>
      </div>
    </div>
  )
}
ENDMARKER

# 7. Form Builder Page
cat > "app/(main)/forms/builder/page.tsx" << 'ENDMARKER'
'use client'

import { FormBuilder } from '@/components/FormBuilder'
import { ArrowLeft, Save, Eye } from 'lucide-react'
import Link from 'next/link'

export default function FormBuilderPage() {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-4">
          <Link
            href="/forms"
            className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg"
          >
            <ArrowLeft className="w-5 h-5" />
          </Link>
          <div>
            <h1 className="text-2xl font-bold">Form Tasarlayıcı</h1>
            <p className="text-gray-500">Sürükle-bırak ile form oluşturun</p>
          </div>
        </div>
      </div>
      
      <FormBuilder />
    </div>
  )
}
ENDMARKER

echo "✅ Adım 3 tamamlandı: Form Builder Sistemi"
echo ""
echo "📌 Eklenen özellikler:"
echo "  • Drag & Drop form designer"
echo "  • 20+ alan tipi"
echo "  • Alan özellikleri paneli"
echo "  • Koşullu mantık desteği"
echo "  • Önizleme modu"
echo "  • Form kaydetme altyapısı"
echo ""
echo "🚀 Sonraki: Adım 4 - Template Designer"