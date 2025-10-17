#!/bin/bash
# install-ngo-system.sh - NGO Management System Tam Kurulum
# Author: ongassamaniger-blip
# Date: 2025-10-17
# Version: 1.0.0

set -e  # Hata durumunda dur

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
clear
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                                                            ║${NC}"
echo -e "${CYAN}║${GREEN}     NGO MANAGEMENT SYSTEM - KOMPLE KURULUM v1.0.0        ${CYAN}║${NC}"
echo -e "${CYAN}║${YELLOW}           STK Yönetim Sistemi Otomatik Kurulum           ${CYAN}║${NC}"
echo -e "${CYAN}║                                                            ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${MAGENTA}Geliştirici: ongassamaniger-blip${NC}"
echo -e "${MAGENTA}Tarih: 2025-10-17${NC}"
echo ""

# Sistem kontrolü
echo -e "${YELLOW}[1/10]${NC} Sistem kontrolleri yapılıyor..."

# Node.js kontrolü
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js kurulu değil!${NC}"
    echo -e "${YELLOW}Node.js kuruluyor...${NC}"
    
    # İşletim sistemine göre Node.js kurulumu
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt-get install -y nodejs
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install node
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        echo -e "${YELLOW}Windows için Node.js'i https://nodejs.org adresinden indirin${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✅ Node.js kurulu ($(node -v))${NC}"
fi

# npm kontrolü
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm kurulu değil!${NC}"
    exit 1
else
    echo -e "${GREEN}✅ npm kurulu ($(npm -v))${NC}"
fi

# Git kontrolü
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}⚠️  Git kurulu değil, kuruluyor...${NC}"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get install -y git
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install git
    fi
else
    echo -e "${GREEN}✅ Git kurulu ($(git --version))${NC}"
fi

echo ""
echo -e "${YELLOW}[2/10]${NC} Proje klasörü oluşturuluyor..."

# Proje adı
PROJECT_NAME="ngo-management-system"
echo -e "${CYAN}Proje adı: ${PROJECT_NAME}${NC}"

# Eğer klasör varsa sil
if [ -d "$PROJECT_NAME" ]; then
    echo -e "${YELLOW}⚠️  Mevcut klasör bulundu. Siliniyor...${NC}"
    rm -rf "$PROJECT_NAME"
fi

# Ana klasör oluştur
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

echo -e "${GREEN}✅ Proje klasörü oluşturuldu${NC}"
echo ""

# =====================================================
# BÖLÜM 2: package.json ve config dosyaları
# =====================================================

echo -e "${YELLOW}[3/10]${NC} package.json oluşturuluyor..."

cat > package.json << 'ENDOFPACKAGE'
{
  "name": "ngo-management-system",
  "version": "1.0.0",
  "description": "Modern NGO Management System - STK Yönetim Sistemi",
  "author": "ongassamaniger-blip",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "format": "prettier --write .",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "next": "14.2.0",
    "react": "^18.3.0",
    "react-dom": "^18.3.0",
    "framer-motion": "^11.0.0",
    "lucide-react": "^0.400.0",
    "recharts": "^2.12.0",
    "zustand": "^4.5.0",
    "@prisma/client": "^5.20.0",
    "bcryptjs": "^2.4.3",
    "clsx": "^2.1.0",
    "tailwind-merge": "^2.3.0",
    "date-fns": "^3.0.0",
    "react-hook-form": "^7.50.0",
    "zod": "^3.22.0",
    "@hookform/resolvers": "^3.3.0",
    "axios": "^1.6.0",
    "react-hot-toast": "^2.4.0",
    "react-query": "^3.39.0",
    "@tanstack/react-table": "^8.11.0",
    "react-dropzone": "^14.2.0",
    "jspdf": "^2.5.0",
    "xlsx": "^0.18.0",
    "chart.js": "^4.4.0",
    "react-chartjs-2": "^5.2.0"
  },
  "devDependencies": {
    "@types/node": "^20.14.0",
    "@types/react": "^18.3.0",
    "@types/react-dom": "^18.3.0",
    "@types/bcryptjs": "^2.4.6",
    "autoprefixer": "^10.4.19",
    "eslint": "^8.57.0",
    "eslint-config-next": "14.2.0",
    "postcss": "^8.4.38",
    "prisma": "^5.20.0",
    "tailwindcss": "^3.4.0",
    "typescript": "^5.5.0",
    "prettier": "^3.2.0",
    "@typescript-eslint/eslint-plugin": "^7.0.0",
    "@typescript-eslint/parser": "^7.0.0"
  }
}
ENDOFPACKAGE

echo -e "${GREEN}✅ package.json oluşturuldu${NC}"

# tsconfig.json
echo -e "${YELLOW}[4/10]${NC} TypeScript config oluşturuluyor..."

cat > tsconfig.json << 'ENDOFTS'
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./*"],
      "@/components/*": ["./components/*"],
      "@/lib/*": ["./lib/*"],
      "@/styles/*": ["./styles/*"],
      "@/hooks/*": ["./hooks/*"],
      "@/types/*": ["./types/*"],
      "@/utils/*": ["./utils/*"]
    },
    "baseUrl": "."
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
ENDOFTS

echo -e "${GREEN}✅ tsconfig.json oluşturuldu${NC}"

# tailwind.config.js
echo -e "${YELLOW}Tailwind CSS config oluşturuluyor...${NC}"

cat > tailwind.config.js << 'ENDOFTAILWIND'
/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: ["class"],
  content: [
    './pages/**/*.{ts,tsx}',
    './components/**/*.{ts,tsx}',
    './app/**/*.{ts,tsx}',
    './src/**/*.{ts,tsx}',
  ],
  theme: {
    container: {
      center: true,
      padding: "2rem",
      screens: {
        "2xl": "1400px",
      },
    },
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      keyframes: {
        "accordion-down": {
          from: { height: 0 },
          to: { height: "var(--radix-accordion-content-height)" },
        },
        "accordion-up": {
          from: { height: "var(--radix-accordion-content-height)" },
          to: { height: 0 },
        },
      },
      animation: {
        "accordion-down": "accordion-down 0.2s ease-out",
        "accordion-up": "accordion-up 0.2s ease-out",
      },
    },
  },
  plugins: [require("tailwindcss-animate")],
}
ENDOFTAILWIND

# postcss.config.js
cat > postcss.config.js << 'ENDOFPOSTCSS'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
ENDOFPOSTCSS

# next.config.js
cat > next.config.js << 'ENDOFNEXT'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  images: {
    domains: ['localhost', 'res.cloudinary.com'],
  },
  env: {
    NEXT_PUBLIC_API_URL: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000',
  },
}

module.exports = nextConfig
ENDOFNEXT

# .env.local
cat > .env.local << 'ENDOFENV'
# Database
DATABASE_URL="postgresql://postgres:password@localhost:5432/ngo_db?schema=public"

# NextAuth
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=your-super-secret-key-here-change-this-in-production

# JWT
JWT_SECRET=your-jwt-secret-key-here

# API
NEXT_PUBLIC_API_URL=http://localhost:3000

# Email (optional)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password

# Cloudinary (optional for image uploads)
CLOUDINARY_CLOUD_NAME=your-cloud-name
CLOUDINARY_API_KEY=your-api-key
CLOUDINARY_API_SECRET=your-api-secret
ENDOFENV

# .gitignore
cat > .gitignore << 'ENDOFGITIGNORE'
# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.

# dependencies
/node_modules
/.pnp
.pnp.js
.yarn/install-state.gz

# testing
/coverage

# next.js
/.next/
/out/

# production
/build

# misc
.DS_Store
*.pem

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# local env files
.env*.local
.env

# vercel
.vercel

# typescript
*.tsbuildinfo
next-env.d.ts

# prisma
prisma/migrations/dev/
ENDOFGITIGNORE

echo -e "${GREEN}✅ Config dosyaları oluşturuldu${NC}"
echo ""

# =====================================================
# BÖLÜM 3: Klasör yapısını oluştur
# =====================================================

echo -e "${YELLOW}[5/10]${NC} Klasör yapısı oluşturuluyor..."

# Ana klasörler
directories=(
    "app"
    "app/(auth)"
    "app/(auth)/login"
    "app/(auth)/register"
    "app/(auth)/forgot-password"
    "app/(main)"
    "app/(main)/dashboard"
    "app/(main)/cash"
    "app/(main)/cash/income"
    "app/(main)/cash/expense"
    "app/(main)/cash/transfer"
    "app/(main)/facilities"
    "app/(main)/facilities/[id]"
    "app/(main)/projects"
    "app/(main)/projects/[id]"
    "app/(main)/personnel"
    "app/(main)/personnel/[id]"
    "app/(main)/sacrifice"
    "app/(main)/sacrifice/[id]"
    "app/(main)/approvals"
    "app/(main)/reports"
    "app/(main)/settings"
    "app/api"
    "app/api/auth"
    "app/api/cash"
    "app/api/facilities"
    "app/api/projects"
    "app/api/personnel"
    "app/api/sacrifice"
    "app/api/approvals"
    "app/api/reports"
    "components"
    "components/layout"
    "components/dashboard"
    "components/cash"
    "components/facilities"
    "components/projects"
    "components/personnel"
    "components/sacrifice"
    "components/approvals"
    "components/reports"
    "components/settings"
    "components/ui"
    "components/charts"
    "components/forms"
    "components/tables"
    "lib"
    "lib/api"
    "lib/utils"
    "hooks"
    "styles"
    "types"
    "public"
    "public/images"
    "public/icons"
    "prisma"
)

for dir in "${directories[@]}"; do
    mkdir -p "$dir"
    echo -e "  📁 $dir"
done

echo -e "${GREEN}✅ Klasör yapısı oluşturuldu${NC}"
echo ""

# =====================================================
# DEVAM EDECEK...
# =====================================================

echo -e "${CYAN}════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}Kurulum devam ediyor...${NC}"
echo -e "${CYAN}════════════════════════════════════════════════${NC}"

# Bir sonraki bölüme geç
echo -e "${YELLOW}Component dosyaları oluşturuluyor...${NC}"