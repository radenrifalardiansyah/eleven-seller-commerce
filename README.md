# Seller Management Dashboard — Eleven Platform

Dashboard manajemen penjual berbasis web yang dibangun dengan React + TypeScript. Menyediakan fitur lengkap untuk mengelola toko online mulai dari produk, pesanan, pelanggan, reseller, keuangan, hingga analitik.

> Desain awal tersedia di [Figma](https://www.figma.com/design/qWYceGw3TOQSR4xYZdMfJZ/Seller-Management-Dashboard).

---

## Tech Stack

| Layer | Teknologi |
|---|---|
| Framework | React 18 + TypeScript |
| Build Tool | Vite 6 |
| Styling | Tailwind CSS v4 |
| UI Components | shadcn/ui (Radix UI) |
| Charts | Recharts |
| Icons | Lucide React |
| Forms | React Hook Form |
| Notifications | Sonner |
| Export | XLSX |

---

## Fitur

### Autentikasi
- Login, Register, dan Forgot Password
- State autentikasi berbasis React (tidak ada backend — siap diintegrasikan)

### Dashboard Overview
- Statistik penjualan real-time
- Grafik penjualan bulanan dengan Recharts
- Analisis kategori produk
- Daftar pesanan terbaru

### Manajemen Produk
- CRUD produk lengkap (tambah, edit, hapus)
- Manajemen stok dengan alert stok rendah
- SKU, kategori, harga, dan status produk (aktif / nonaktif / habis stok)
- Badge jumlah produk stok rendah di sidebar

### Manajemen Pesanan
- Daftar pesanan dengan filter status
- Update status pesanan (pending → processing → shipped → delivered)
- Badge jumlah pesanan pending di sidebar

### Analytics & Reporting
- Laporan penjualan harian dan bulanan
- Analisis performa produk
- Customer behavior dan conversion rate
- Export data ke Excel (XLSX)

### Manajemen Pelanggan
- Database pelanggan
- Segmentasi dan riwayat pembelian
- Customer lifetime value

### Reseller
- Manajemen jaringan reseller
- Approval / penolakan reseller baru
- Badge jumlah pengajuan reseller pending

### Marketing & Voucher
- Buat dan kelola voucher diskon
- Konfigurasi kuota, periode, dan nilai diskon
- Badge jumlah voucher aktif di sidebar

### Keuangan & Pembayaran
- Tracking pendapatan dan saldo
- Laporan transaksi

### Notifikasi
- Notifikasi pesanan baru
- Alert stok rendah
- Update status pembayaran

### Fitur Tambahan
- Live Chat widget
- Halaman Pengaturan (profil toko, preferensi)
- Halaman Bantuan / Help Center
- Sidebar responsif (collapse di mobile)
- Dark/light mode ready (next-themes)

---

## Struktur Folder

```
eleven-seller-commerce/
├── src/
│   ├── components/
│   │   ├── ui/                  # Komponen shadcn/ui (button, card, table, dll)
│   │   ├── seller-sidebar.tsx   # Navigasi sidebar utama
│   │   ├── dashboard-overview.tsx
│   │   ├── product-management.tsx
│   │   ├── order-management.tsx
│   │   ├── analytics-dashboard.tsx
│   │   ├── customers-page.tsx
│   │   ├── reseller-page.tsx
│   │   ├── marketing-page.tsx
│   │   ├── payments-page.tsx
│   │   ├── settings-page.tsx
│   │   ├── help-page.tsx
│   │   ├── live-chat.tsx
│   │   ├── login-page.tsx
│   │   ├── register-page.tsx
│   │   └── forgot-password-page.tsx
│   ├── App.tsx                  # Root component + routing antar halaman
│   ├── main.tsx
│   └── index.css
├── index.html
├── vite.config.ts
└── package.json
```

---

## Cara Menjalankan

### Prasyarat
- Node.js 18+
- npm atau pnpm

### Development

```bash
# Install dependensi
npm install

# Jalankan development server
npm run dev
```

Buka `http://localhost:5173` di browser.

### Build Production

```bash
npm run build
```

Output tersedia di folder `dist/`.

---

## Navigasi Halaman

Aplikasi menggunakan routing berbasis state (`activeTab`) tanpa library router eksternal. Setiap halaman dirender di `App.tsx` berdasarkan tab aktif yang dipilih dari sidebar.

| Tab | Komponen |
|---|---|
| `dashboard` | `DashboardOverview` |
| `products` | `ProductManagement` |
| `orders` | `OrderManagement` |
| `analytics` | `AnalyticsDashboard` |
| `customers` | `CustomersPage` |
| `resellers` | `ResellerPage` |
| `marketing` | `MarketingPage` |
| `payments` | `PaymentsPage` |
| `notifications` | `NotificationsPage` |
| `settings` | `SettingsPage` |
| `help` | `HelpPage` |
