import { useEffect, useState } from 'react'
import { useFacility } from '@/contexts/FacilityContext'

export function useFacilityData<T>(
  dataType: 'cash' | 'projects' | 'personnel' | 'sacrifice'
) {
  const { currentFacility } = useFacility()
  const [data, setData] = useState<T[]>([])
  const [loading, setLoading] = useState(true)
  
  useEffect(() => {
    if (!currentFacility) return
    
    setLoading(true)
    
    // Simulate API call with facility filter
    const fetchData = async () => {
      // In real app: const response = await fetch(`/api/${dataType}?facilityId=${currentFacility.id}`)
      
      // For now, return filtered mock data
      const mockData = localStorage.getItem(`${dataType}_${currentFacility.id}`)
      if (mockData) {
        setData(JSON.parse(mockData))
      } else {
        setData([])
      }
      
      setLoading(false)
    }
    
    fetchData()
  }, [currentFacility, dataType])
  
  return { data, loading, facilityId: currentFacility?.id }
}
