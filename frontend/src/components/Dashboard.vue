<template>
  <div class="dashboard">
    <header class="header">
      <h1>🔒 Secure Docker Blueprint</h1>
      <p class="subtitle">DevSecOps Dashboard</p>
    </header>

    <div class="status-card">
      <h2>Backend Status</h2>
      <div class="status-indicator" :class="{ connected: isBackendConnected }">
        <div class="status-dot"></div>
        <span>{{ statusText }}</span>
      </div>
      <button @click="checkBackendHealth" :disabled="isLoading" class="check-button">
        {{ isLoading ? 'Checking...' : 'Check Health' }}
      </button>
    </div>

    <div class="info-cards">
      <div class="info-card">
        <h3>🏗️ Architecture</h3>
        <ul>
          <li>Nginx 1.27 (Reverse Proxy)</li>
          <li>Django 5.2 LTS (Backend)</li>
          <li>PostgreSQL 16 (Database)</li>
          <li>Vue 3 (Frontend)</li>
        </ul>
      </div>

      <div class="info-card">
        <h3>🛡️ Security Features</h3>
        <ul>
          <li>Non-root containers</li>
          <li>Read-only filesystems</li>
          <li>Network segmentation</li>
          <li>Automated scanning</li>
        </ul>
      </div>

      <div class="info-card">
        <h3>🔄 CI/CD Pipeline</h3>
        <ul>
          <li>GitHub Actions</li>
          <li>Gitleaks (secrets)</li>
          <li>Trivy (vulnerabilities)</li>
          <li>pytest + MyPy</li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const isBackendConnected = ref(false)
const isLoading = ref(false)
const statusText = ref('Checking...')

const checkBackendHealth = async () => {
  isLoading.value = true
  statusText.value = 'Checking...'

  try {
    const response = await fetch('/api/health/')
    if (response.ok) {
      isBackendConnected.value = true
      statusText.value = 'Backend Connected'
    } else {
      isBackendConnected.value = false
      statusText.value = 'Backend Error'
    }
  } catch (error) {
    isBackendConnected.value = false
    statusText.value = 'Backend Unreachable'
    console.error('Health check failed:', error)
  } finally {
    isLoading.value = false
  }
}

onMounted(() => {
  checkBackendHealth()
})
</script>

<style scoped>
.dashboard {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
}

.header {
  text-align: center;
  margin-bottom: 3rem;
}

.header h1 {
  font-size: 2.5rem;
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.subtitle {
  font-size: 1.2rem;
  color: #7f8c8d;
}

.status-card {
  background: white;
  border-radius: 12px;
  padding: 2rem;
  margin-bottom: 2rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.status-card h2 {
  margin-top: 0;
  color: #2c3e50;
}

.status-indicator {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-size: 1.1rem;
  margin: 1rem 0;
  padding: 1rem;
  border-radius: 8px;
  background: #fee;
  color: #c33;
}

.status-indicator.connected {
  background: #efe;
  color: #3c3;
}

.status-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: #c33;
  animation: pulse 2s infinite;
}

.status-indicator.connected .status-dot {
  background: #3c3;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

.check-button {
  background: #3498db;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.3s;
}

.check-button:hover:not(:disabled) {
  background: #2980b9;
}

.check-button:disabled {
  background: #95a5a6;
  cursor: not-allowed;
}

.info-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
}

.info-card {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.info-card h3 {
  margin-top: 0;
  color: #2c3e50;
  font-size: 1.3rem;
}

.info-card ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.info-card li {
  padding: 0.5rem 0;
  border-bottom: 1px solid #ecf0f1;
  color: #34495e;
}

.info-card li:last-child {
  border-bottom: none;
}
</style>
