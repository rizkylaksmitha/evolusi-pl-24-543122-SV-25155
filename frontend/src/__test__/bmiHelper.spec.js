import { describe, it, expect } from 'vitest'
import { hitungKategoriBmi, buildApiUrl } from '../utils/bmiHelper'

describe('Logika Kalkulasi & API BMI', () => {
  it('menentukan kategori BMI Normal dengan benar', () => {
    expect(hitungKategoriBmi(65, 170)).toBe('Normal')
  })

  it('menggabungkan VITE_API_URL dan endpoint /bmi dengan benar', () => {
    expect(buildApiUrl('http://127.0.0.1:8000/api/', '/bmi')).toBe(
      'http://127.0.0.1:8000/api/bmi'
    )
  })
})