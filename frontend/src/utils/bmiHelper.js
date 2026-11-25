export function hitungKategoriBmi(beratKg, tinggiCm) {
  if (!beratKg || !tinggiCm) return 'Tidak Valid'
  const tinggiMeter = tinggiCm / 100
  const nilai = beratKg / (tinggiMeter * tinggiMeter)
  if (nilai < 18.5) return 'Underweight'
  if (nilai < 25) return 'Normal'
  if (nilai < 30) return 'Overweight'
  return 'Obesitas'
}

export function buildApiUrl(baseUrl, path) {
  const cleanBase = (baseUrl || '').replace(/\/+$/, '')
  const cleanPath = path.startsWith('/') ? path : `/${path}`
  return `${cleanBase}${cleanPath}`
}