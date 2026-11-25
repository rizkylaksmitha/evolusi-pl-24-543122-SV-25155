<script setup>
import { ref, onMounted } from 'vue'
import { buildApiUrl } from '../utils/bmiHelper'

const dataBmi = ref([])
const loading = ref(true)
const errorMsg = ref('')

const apiUrl = buildApiUrl(import.meta.env.VITE_API_URL, '/bmi')

onMounted(async () => {
  try {
    const res = await fetch(apiUrl)
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    dataBmi.value = await res.json()
  } catch (err) {
    errorMsg.value = `Gagal terhubung ke Laravel (${apiUrl}): ${err.message}`
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <main style="padding: 1.5rem; font-family: sans-serif;">
    <h1>Data Riwayat BMI (Laravel API)</h1>
    <p>Endpoint: <code>{{ apiUrl }}</code></p>

    <p v-if="loading">Memuat data...</p>
    <p v-else-if="errorMsg" style="color: red;">{{ errorMsg }}</p>

    <table v-else border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
      <thead>
        <tr>
          <th>ID</th>
          <th>Nama</th>
          <th>Tinggi (cm)</th>
          <th>Berat (kg)</th>
          <th>BMI</th>
          <th>Kategori</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in dataBmi" :key="item.id">
          <td>{{ item.id }}</td>
          <td>{{ item.nama }}</td>
          <td>{{ item.tinggi }}</td>
          <td>{{ item.berat }}</td>
          <td>{{ item.bmi }}</td>
          <td>{{ item.kategori }}</td>
        </tr>
      </tbody>
    </table>
  </main>
</template>