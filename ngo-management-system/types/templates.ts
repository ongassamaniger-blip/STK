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
