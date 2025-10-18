'use client'

import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { Building2, ChevronDown, Check, Globe } from 'lucide-react'
import { useFacility } from '@/contexts/FacilityContext'

export function FacilitySelector() {
  const [isOpen, setIsOpen] = useState(false)
  const { currentFacility, userFacilities, switchFacility } = useFacility()
  
  if (userFacilities.length <= 1) return null
  
  return (
    <div className="relative">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 px-3 py-2 bg-white dark:bg-gray-800 rounded-lg border border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
      >
        <Building2 className="w-4 h-4 text-gray-500" />
        <span className="text-sm font-medium">
          {currentFacility?.name || 'Tesis Seç'}
        </span>
        <ChevronDown className={`w-4 h-4 text-gray-500 transition-transform ${
          isOpen ? 'rotate-180' : ''
        }`} />
      </button>
      
      <AnimatePresence>
        {isOpen && (
          <>
            <div
              className="fixed inset-0 z-40"
              onClick={() => setIsOpen(false)}
            />
            <motion.div
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -10 }}
              className="absolute top-12 right-0 z-50 w-64 bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden"
            >
              <div className="p-2">
                {userFacilities.map((facility) => (
                  <button
                    key={facility.id}
                    onClick={() => {
                      switchFacility(facility.id)
                      setIsOpen(false)
                    }}
                    className={`w-full px-3 py-2 flex items-center justify-between rounded-lg transition-colors ${
                      currentFacility?.id === facility.id
                        ? 'bg-blue-50 dark:bg-blue-900/20 text-blue-600'
                        : 'hover:bg-gray-50 dark:hover:bg-gray-700'
                    }`}
                  >
                    <div className="flex items-center gap-3">
                      {facility.id === 'global' ? (
                        <Globe className="w-4 h-4" />
                      ) : (
                        <Building2 className="w-4 h-4" />
                      )}
                      <div className="text-left">
                        <p className="text-sm font-medium">{facility.name}</p>
                        <p className="text-xs text-gray-500">
                          {facility.location}, {facility.country}
                        </p>
                      </div>
                    </div>
                    {currentFacility?.id === facility.id && (
                      <Check className="w-4 h-4 text-blue-600" />
                    )}
                  </button>
                ))}
              </div>
              
              {userFacilities.some(f => f.id === 'global') && (
                <div className="border-t border-gray-200 dark:border-gray-700 p-3">
                  <p className="text-xs text-gray-500 text-center">
                    Global yetkiye sahipsiniz
                  </p>
                </div>
              )}
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </div>
  )
}
