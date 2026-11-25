<script setup>
import { RouterLink, RouterView } from 'vue-router'
</script>

<template>
  <header style="padding: 1rem 1.5rem; border-bottom: 1px solid #444;">
    <nav style="display: flex; gap: 1.5rem;">
      <RouterLink to="/">Beranda (Data BMI)</RouterLink>
      <RouterLink to="/about">Tentang</RouterLink>
    </nav>
  </header>

  <RouterView />
</template>