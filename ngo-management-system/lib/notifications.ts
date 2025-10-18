import toast from 'react-hot-toast'

export const notify = {
  success: (message: string) => {
    toast.success(message, {
      duration: 4000,
      position: 'top-right',
      style: {
        background: '#10b981',
        color: '#fff',
      },
    })
  },
  
  error: (message: string) => {
    toast.error(message, {
      duration: 4000,
      position: 'top-right',
      style: {
        background: '#ef4444',
        color: '#fff',
      },
    })
  },
  
  loading: (message: string) => {
    return toast.loading(message, {
      position: 'top-right',
    })
  },
  
  dismiss: (id: string) => {
    toast.dismiss(id)
  }
}
