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
