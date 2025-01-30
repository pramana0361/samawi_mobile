# simawi_mobile

SIMAWI Mobile adalah aplikasi manajemen rumah sakit sederhana berbasis mobile yang
memungkinkan pengguna (admin dan dokter) untuk:
- Mengelola data pasien, termasuk pendaftaran, pembaruan, dan pencatatan rekam
medis.
- Mencari dan mencatat kode diagnosis pasien menggunakan ICD API WHO.
- Menyediakan data statistik dan daftar penyakit berdasarkan kode ICD-10.

## Instalasi

Unduh dan buka/jalankan file (.apk) dari aplikasi ini di perangkat Android anda.

## Pengembangan

Aplikasi ini masih dalam tahap pengembangan.

Jika anda adalah seorang pengembang yang ingin berkontribusi atau mengembangkan project ini lebih lanjut secara mandiri, berikut adalah beberapa hal yang perlu anda perhatikan:
- Aplikasi ini masih menggunakan database lokal di perangkat seluler dimana aplikasi ini dipasangkan.
- Untuk mendapatkan akses dari ICD API WHO, anda perlu mendaftarkan diri secara gratis di [ICD API WHO](https://icd.who.int/icdapi) untuk mendapatkan CLIENT ID dan CLIENT SECRET yang nantinya akan digunakan untuk mengisi variable clientId dan clientSecret pada file [icd_api_service.dart](https://github.com/pramana0361/samawi_mobile/blob/main/lib/services/icd_api_service.dart).

