import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  server: {
    host: '0.0.0.0', // Позволяет обращаться к серверу из Docker-сети
    port: 3000,      // Стандартный порт для удобства
    proxy: {
      '/api': {
        target: 'http://localhost:8000', // Адрес Django backend
        changeOrigin: true,
        secure: false,
      }
    }
  }
})
