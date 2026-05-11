-- ============================================================
-- SEED DATA — Company "ELEVEN"
-- Jalankan SETELAH schema.sql berhasil
-- ============================================================
-- SEBELUM JALANKAN:
--   1. Buka Supabase → Authentication → Users → Add user
--      Email: admin@eleven.id | Password: Admin1234!
--   2. Copy UUID user tersebut
--   3. Ganti '<UUID-DARI-SUPABASE-AUTH>' di bawah dengan UUID asli
-- ============================================================


-- ============================================================
-- COMPANY
-- ============================================================

INSERT INTO companies (id, code, name, email, status)
OVERRIDING SYSTEM VALUE VALUES
(1, 'ELEVEN', 'Eleven Commerce', 'admin@eleven.id', 'active');

SELECT setval(pg_get_serial_sequence('companies', 'id'), 1);


-- ============================================================
-- SELLER PROFILE (Admin / Owner)
-- ============================================================

INSERT INTO seller_profiles (id, company_id, role, full_name, phone, is_active) VALUES
('2dc6afff-74c3-44a6-8ce1-55fde288133a', 1, 'owner', 'Admin Eleven', '+62 812-0000-0001', TRUE);


-- ============================================================
-- CATEGORIES
-- ============================================================

INSERT INTO categories (id, company_id, name, description)
OVERRIDING SYSTEM VALUE VALUES
(1,  1, 'Elektronik',        'Perangkat elektronik dan gadget'),
(2,  1, 'Fashion',           'Pakaian, sepatu, dan aksesori'),
(3,  1, 'Rumah & Taman',     'Perabot rumah dan alat taman'),
(4,  1, 'Olahraga',          'Perlengkapan olahraga'),
(5,  1, 'Buku',              'Buku dan materi edukasi'),
(6,  1, 'Kesehatan',         'Produk kesehatan dan kecantikan'),
(7,  1, 'Otomotif',          'Suku cadang dan aksesori kendaraan'),
(8,  1, 'Makanan & Minuman', 'Produk makanan dan minuman');

SELECT setval(pg_get_serial_sequence('categories', 'id'), 8);


-- ============================================================
-- PRODUCTS
-- ============================================================

INSERT INTO products (id, company_id, category_id, name, description, sku, price, stock, weight, status, is_featured)
OVERRIDING SYSTEM VALUE VALUES
(1,  1, 1, 'iPhone 14 Pro Max',          'Apple iPhone 14 Pro Max 256GB Space Gray',            'IPH14PM-256-SG',   15999000, 25,  240,  'active',       TRUE),
(2,  1, 1, 'Samsung Galaxy S23 Ultra',   'Samsung Galaxy S23 Ultra 512GB Phantom Black',        'SGS23U-512-BK',    18999000, 15,  235,  'active',       TRUE),
(3,  1, 1, 'MacBook Air M2',             'Apple MacBook Air M2 13-inch 256GB Space Gray',       'MBA-M2-256-SG',    18999000, 8,   1240, 'active',       TRUE),
(4,  1, 1, 'Sony WH-1000XM5',            'Sony Wireless Noise Cancelling Headphone WH-1000XM5', 'SNY-WH1000XM5-BK', 5499000, 20,  250,  'active',       FALSE),
(5,  1, 1, 'Apple Watch Series 8',       'Apple Watch Series 8 GPS 45mm Midnight',              'AW-S8-45-MN',      8999000, 12,  38,   'active',       FALSE),
(6,  1, 2, 'Nike Air Jordan 1 Retro',    'Nike Air Jordan 1 Retro High OG Size 42 University Red','NAJ1-42-RED',     2499000, 3,   800,  'active',       FALSE),
(7,  1, 2, 'Adidas Ultraboost 22',       'Adidas Ultraboost 22 Running Shoes Size 43 White',    'AUB22-43-WHT',     2899000, 0,   350,  'out_of_stock', FALSE),
(8,  1, 2, 'Kemeja Batik Premium',       'Kemeja Batik Tulis Premium Lengan Panjang Motif Parang Size L','BTK-PRMM-L-PRG', 450000, 30, 300, 'active',  FALSE),
(9,  1, 4, 'Raket Yonex Astrox 99',     'Yonex Astrox 99 Game Badminton Racket White Tiger',   'YNX-AX99-WT',      1899000, 10,  85,   'active',       FALSE),
(10, 1, 6, 'Vitamin C 1000mg',           'Nature''s Plus Vitamin C 1000mg Effervescent 20 Tab', 'VTC-1000-EFV-20',  89000,   100, 150,  'active',       FALSE);

SELECT setval(pg_get_serial_sequence('products', 'id'), 10);


-- ============================================================
-- CUSTOMERS
-- ============================================================

INSERT INTO customers (id, company_id, name, email, phone, segment, status, total_orders, total_spend, last_order_at, join_date)
OVERRIDING SYSTEM VALUE VALUES
(1, 1, 'Ahmad Rizki',    'ahmad.rizki@gmail.com',    '+62 812-3456-7890', 'VIP',     'active', 12, 48750000,  NOW() - INTERVAL '3 days',  '2023-01-15'),
(2, 1, 'Siti Nurhaliza', 'siti.nurhaliza@gmail.com', '+62 813-2345-6789', 'VIP',     'active',  8, 32400000,  NOW() - INTERVAL '7 days',  '2023-03-22'),
(3, 1, 'Budi Santoso',   'budi.santoso@gmail.com',   '+62 814-3456-7891', 'Regular', 'active',  5, 15200000,  NOW() - INTERVAL '14 days', '2023-06-10'),
(4, 1, 'Dewi Kusuma',    'dewi.kusuma@gmail.com',    '+62 815-4567-8901', 'Regular', 'active',  4, 11600000,  NOW() - INTERVAL '10 days', '2023-08-05'),
(5, 1, 'Eko Prasetyo',   'eko.prasetyo@gmail.com',   '+62 816-5678-9012', 'Regular', 'active',  3, 8700000,   NOW() - INTERVAL '20 days', '2023-09-18'),
(6, 1, 'Rina Marlina',   'rina.marlina@gmail.com',   '+62 817-6789-0123', 'New',     'active',  1, 2499000,   NOW() - INTERVAL '5 days',  '2024-01-02'),
(7, 1, 'Farhan Hadi',    'farhan.hadi@gmail.com',    '+62 818-7890-1234', 'New',     'active',  1, 5499000,   NOW() - INTERVAL '2 days',  '2024-01-08'),
(8, 1, 'Lestari Indah',  'lestari.indah@gmail.com',  '+62 819-8901-2345', 'New',     'active',  1, 15999000,  NOW() - INTERVAL '1 day',   '2024-01-10');

SELECT setval(pg_get_serial_sequence('customers', 'id'), 8);

INSERT INTO customer_addresses (customer_id, type, recipient_name, phone, address_line1, city, province, postal_code, is_default) VALUES
(1, 'home', 'Ahmad Rizki',    '+62 812-3456-7890', 'Jl. Sudirman No. 45',       'Jakarta Pusat',  'DKI Jakarta',      '10220', TRUE),
(2, 'home', 'Siti Nurhaliza', '+62 813-2345-6789', 'Jl. Ahmad Yani No. 120',    'Surabaya',       'Jawa Timur',       '60234', TRUE),
(3, 'home', 'Budi Santoso',   '+62 814-3456-7891', 'Jl. Gatot Subroto No. 77',  'Jakarta Selatan','DKI Jakarta',      '12950', TRUE),
(4, 'home', 'Dewi Kusuma',    '+62 815-4567-8901', 'Jl. Diponegoro No. 33',     'Bandung',        'Jawa Barat',       '40115', TRUE),
(5, 'home', 'Eko Prasetyo',   '+62 816-5678-9012', 'Jl. Imam Bonjol No. 88',    'Medan',          'Sumatera Utara',   '20152', TRUE),
(6, 'home', 'Rina Marlina',   '+62 817-6789-0123', 'Jl. Sam Ratulangi No. 55',  'Makassar',       'Sulawesi Selatan', '90111', TRUE),
(7, 'home', 'Farhan Hadi',    '+62 818-7890-1234', 'Jl. Malioboro No. 12',      'Yogyakarta',     'DI Yogyakarta',    '55271', TRUE),
(8, 'home', 'Lestari Indah',  '+62 819-8901-2345', 'Jl. Raya Kuta No. 88',      'Badung',         'Bali',             '80361', TRUE);


-- ============================================================
-- ORDERS
-- ============================================================

INSERT INTO orders (id, company_id, order_number, customer_id, customer_name, shipping_address, status, payment_status, payment_method, subtotal, shipping_cost, discount_amount, total_amount, courier, tracking_number, order_date, shipped_at, delivered_at)
OVERRIDING SYSTEM VALUE VALUES
-- delivered
( 1, 1, 'ORD-20240101-001', 1, 'Ahmad Rizki',    'Jl. Sudirman No. 45, Jakarta Pusat 10220',   'delivered',  'paid',    'Transfer Bank', 15999000, 25000, 0,       16024000, 'JNE',     'JNE001234567890', NOW()-'30 days'::interval, NOW()-'28 days'::interval, NOW()-'25 days'::interval),
( 2, 1, 'ORD-20240105-002', 2, 'Siti Nurhaliza', 'Jl. Ahmad Yani No. 120, Surabaya 60234',     'delivered',  'paid',    'QRIS',          18999000, 35000, 500000,  18534000, 'J&T',     'JT002345678901',  NOW()-'25 days'::interval, NOW()-'23 days'::interval, NOW()-'20 days'::interval),
( 3, 1, 'ORD-20240110-003', 3, 'Budi Santoso',   'Jl. Gatot Subroto No. 77, Jakarta Selatan',  'delivered',  'paid',    'Kartu Kredit',   5499000, 15000, 0,        5514000, 'SiCepat', 'SC003456789012',  NOW()-'20 days'::interval, NOW()-'19 days'::interval, NOW()-'17 days'::interval),
( 4, 1, 'ORD-20240106-004', 4, 'Dewi Kusuma',    'Jl. Diponegoro No. 33, Bandung 40115',       'delivered',  'paid',    'QRIS',            450000, 15000, 0,         465000, 'JNE',     'JNE012345678901', NOW()-'12 days'::interval, NOW()-'11 days'::interval, NOW()-'9 days'::interval),
-- shipped
( 5, 1, 'ORD-20240108-005', 4, 'Dewi Kusuma',    'Jl. Diponegoro No. 33, Bandung 40115',       'shipped',    'paid',    'Transfer Bank',  8999000, 20000, 0,        9019000, 'JNE',     'JNE004567890123', NOW()-'5 days'::interval,  NOW()-'4 days'::interval,  NULL),
( 6, 1, 'ORD-20240109-006', 1, 'Ahmad Rizki',    'Jl. Sudirman No. 45, Jakarta Pusat 10220',   'shipped',    'paid',    'QRIS',          18999000, 35000, 1000000, 18034000, 'SiCepat', 'SC005678901234',  NOW()-'4 days'::interval,  NOW()-'3 days'::interval,  NULL),
-- processing
( 7, 1, 'ORD-20240110-007', 5, 'Eko Prasetyo',   'Jl. Imam Bonjol No. 88, Medan 20152',        'processing', 'paid',    'Transfer Bank',  1899000, 40000, 0,        1939000, 'J&T',     NULL,              NOW()-'2 days'::interval,  NULL, NULL),
( 8, 1, 'ORD-20240110-008', 2, 'Siti Nurhaliza', 'Jl. Ahmad Yani No. 120, Surabaya 60234',     'processing', 'paid',    'Kartu Kredit',   2499000, 25000, 0,        2524000, 'JNE',     NULL,              NOW()-'1 day'::interval,   NULL, NULL),
-- pending
( 9, 1, 'ORD-20240111-009', 6, 'Rina Marlina',   'Jl. Sam Ratulangi No. 55, Makassar 90111',   'pending',    'waiting', 'Transfer Bank',  2499000, 45000, 0,        2544000, NULL,      NULL,              NOW()-'3 hours'::interval, NULL, NULL),
(10, 1, 'ORD-20240111-010', 7, 'Farhan Hadi',    'Jl. Malioboro No. 12, Yogyakarta 55271',     'pending',    'waiting', 'QRIS',           5499000, 20000, 0,        5519000, NULL,      NULL,              NOW()-'1 hour'::interval,  NULL, NULL),
(11, 1, 'ORD-20240111-011', 8, 'Lestari Indah',  'Jl. Raya Kuta No. 88, Badung, Bali 80361',  'pending',    'waiting', 'Transfer Bank', 15999000, 30000, 0,       16029000, NULL,      NULL,              NOW()-'30 minutes'::interval, NULL, NULL),
-- cancelled
(12, 1, 'ORD-20240103-012', 3, 'Budi Santoso',   'Jl. Gatot Subroto No. 77, Jakarta Selatan',  'cancelled',  'refunded','Transfer Bank', 18999000, 35000, 0,       19034000, NULL,      NULL,              NOW()-'15 days'::interval, NULL, NULL);

SELECT setval(pg_get_serial_sequence('orders', 'id'), 12);

INSERT INTO order_items (order_id, product_id, product_name, product_sku, quantity, unit_price, total_price) VALUES
( 1,  1, 'iPhone 14 Pro Max',        'IPH14PM-256-SG',   1, 15999000, 15999000),
( 2,  2, 'Samsung Galaxy S23 Ultra', 'SGS23U-512-BK',    1, 18999000, 18999000),
( 3,  4, 'Sony WH-1000XM5',          'SNY-WH1000XM5-BK', 1,  5499000,  5499000),
( 4,  8, 'Kemeja Batik Premium',     'BTK-PRMM-L-PRG',   1,   450000,   450000),
( 5,  5, 'Apple Watch Series 8',     'AW-S8-45-MN',      1,  8999000,  8999000),
( 6,  2, 'Samsung Galaxy S23 Ultra', 'SGS23U-512-BK',    1, 18999000, 18999000),
( 7,  9, 'Raket Yonex Astrox 99',   'YNX-AX99-WT',      1,  1899000,  1899000),
( 8,  6, 'Nike Air Jordan 1 Retro',  'NAJ1-42-RED',      1,  2499000,  2499000),
( 9,  6, 'Nike Air Jordan 1 Retro',  'NAJ1-42-RED',      1,  2499000,  2499000),
(10,  4, 'Sony WH-1000XM5',          'SNY-WH1000XM5-BK', 1,  5499000,  5499000),
(11,  1, 'iPhone 14 Pro Max',        'IPH14PM-256-SG',   1, 15999000, 15999000),
(12,  2, 'Samsung Galaxy S23 Ultra', 'SGS23U-512-BK',    1, 18999000, 18999000);

INSERT INTO order_return_requests (order_id, type, reason, notes, status) VALUES
(4, 'return_item', 'Ukuran tidak sesuai', 'Produk diterima size M, bukan L. Mohon tukar atau refund.', 'requested');


-- ============================================================
-- PAYMENTS
-- ============================================================

INSERT INTO payments (company_id, order_id, payment_method, amount, status, transaction_id, paid_at) VALUES
(1,  1, 'Transfer Bank', 16024000, 'paid',    'TXN-BNK-001', NOW()-'29 days'::interval),
(1,  2, 'QRIS',          18534000, 'paid',    'TXN-QRS-002', NOW()-'24 days'::interval),
(1,  3, 'Kartu Kredit',   5514000, 'paid',    'TXN-CC-003',  NOW()-'19 days'::interval),
(1,  4, 'QRIS',            465000, 'paid',    'TXN-QRS-004', NOW()-'11 days'::interval),
(1,  5, 'Transfer Bank',  9019000, 'paid',    'TXN-BNK-005', NOW()-'5 days'::interval),
(1,  6, 'QRIS',          18034000, 'paid',    'TXN-QRS-006', NOW()-'4 days'::interval),
(1,  7, 'Transfer Bank',  1939000, 'paid',    'TXN-BNK-007', NOW()-'2 days'::interval),
(1,  8, 'Kartu Kredit',   2524000, 'paid',    'TXN-CC-008',  NOW()-'1 day'::interval),
(1,  9, 'Transfer Bank',  2544000, 'waiting', NULL, NULL),
(1, 10, 'QRIS',           5519000, 'waiting', NULL, NULL),
(1, 11, 'Transfer Bank', 16029000, 'waiting', NULL, NULL),
(1, 12, 'Transfer Bank', 19034000, 'refunded','TXN-BNK-012', NOW()-'14 days'::interval);


-- ============================================================
-- FINANCIAL TRANSACTIONS
-- ============================================================

INSERT INTO financial_transactions (company_id, date, description, type, amount, status) VALUES
(1, CURRENT_DATE-29, 'Penjualan ORD-20240101-001 — iPhone 14 Pro Max',        'Penjualan',   16024000, 'Sukses'),
(1, CURRENT_DATE-29, 'Biaya admin ORD-20240101-001',                          'Biaya Admin',   320480, 'Sukses'),
(1, CURRENT_DATE-24, 'Penjualan ORD-20240105-002 — Samsung Galaxy S23 Ultra', 'Penjualan',   18534000, 'Sukses'),
(1, CURRENT_DATE-24, 'Biaya admin ORD-20240105-002',                          'Biaya Admin',   370680, 'Sukses'),
(1, CURRENT_DATE-19, 'Penjualan ORD-20240110-003 — Sony WH-1000XM5',          'Penjualan',    5514000, 'Sukses'),
(1, CURRENT_DATE-19, 'Biaya admin ORD-20240110-003',                          'Biaya Admin',   110280, 'Sukses'),
(1, CURRENT_DATE-15, 'Refund ORD-20240103-012 — Pembatalan pesanan',          'Refund',      19034000, 'Sukses'),
(1, CURRENT_DATE-11, 'Penjualan ORD-20240106-004 — Kemeja Batik Premium',     'Penjualan',     465000, 'Sukses'),
(1, CURRENT_DATE-10, 'Penarikan saldo ke BCA ****5678',                       'Penarikan',   15000000, 'Sukses'),
(1, CURRENT_DATE-5,  'Penjualan ORD-20240108-005 — Apple Watch Series 8',     'Penjualan',    9019000, 'Sukses'),
(1, CURRENT_DATE-5,  'Biaya admin ORD-20240108-005',                          'Biaya Admin',   180380, 'Sukses'),
(1, CURRENT_DATE-4,  'Penjualan ORD-20240109-006 — Samsung Galaxy S23 Ultra', 'Penjualan',   18034000, 'Sukses'),
(1, CURRENT_DATE-4,  'Biaya admin ORD-20240109-006',                          'Biaya Admin',   360680, 'Sukses'),
(1, CURRENT_DATE-2,  'Penjualan ORD-20240110-007 — Raket Yonex Astrox 99',   'Penjualan',    1939000, 'Sukses'),
(1, CURRENT_DATE-1,  'Penjualan ORD-20240110-008 — Nike Air Jordan 1',        'Penjualan',    2524000, 'Sukses'),
(1, CURRENT_DATE,    'Transfer ORD-20240111-009 — menunggu konfirmasi',        'Penjualan',    2544000, 'Pending'),
(1, CURRENT_DATE,    'Transfer ORD-20240111-010 — menunggu konfirmasi',        'Penjualan',    5519000, 'Pending');


-- ============================================================
-- RESELLERS
-- ============================================================

INSERT INTO resellers (id, company_id, name, email, phone, city, address, tier, status, join_date, total_sales, total_orders, pending_commission, paid_commission, referral_code, notes)
OVERRIDING SYSTEM VALUE VALUES
(1, 1, 'Ahmad Fauzi',    'ahmad.fauzi@gmail.com',      '+62 812-3456-7890', 'Jakarta',  'Jl. Sudirman No. 45, Jakarta Pusat', 'Platinum', 'active',    '2022-11-01', 158000000, 78, 5280000, 18420000, 'AHMAD22', 'Top performer.'),
(2, 1, 'Dewi Kusuma',    'dewi.reseller@gmail.com',    '+62 813-2345-6789', 'Surabaya', 'Jl. Ahmad Yani No. 120, Surabaya',  'Gold',     'active',    '2023-02-10',  92000000, 51, 3840000,  7200000, 'DEWI23',  NULL),
(3, 1, 'Budi Reseller',  'budi.reseller@gmail.com',    '+62 814-3456-7891', 'Jakarta',  'Jl. Gatot Subroto No. 77, Jakarta', 'Gold',     'active',    '2023-03-15',  78000000, 42, 2400000,  6960000, 'BUDI23',  NULL),
(4, 1, 'Siti Rahayu',    'siti.rahayu.rs@gmail.com',   '+62 815-4567-8901', 'Bandung',  'Jl. Diponegoro No. 33, Bandung',    'Silver',   'active',    '2023-06-20',  38000000, 22, 1120000,  1920000, 'SITI23',  NULL),
(5, 1, 'Eko Nugroho',    'eko.nugroho.rs@gmail.com',   '+62 816-5678-9012', 'Medan',    'Jl. Imam Bonjol No. 88, Medan',     'Silver',   'active',    '2023-08-05',  25000000, 15,  800000,  1200000, 'EKO23',   NULL),
(6, 1, 'Rina Setiawan',  'rina.setiawan.rs@gmail.com', '+62 817-6789-0123', 'Makassar', 'Jl. Sam Ratulangi No. 55, Makassar','Bronze',   'pending',   '2024-01-05',         0,  0,       0,        0, 'RINA24',  'Menunggu verifikasi KTP');

SELECT setval(pg_get_serial_sequence('resellers', 'id'), 6);

INSERT INTO reseller_tier_configs (company_id, tier, commission, min_sales, max_sales) VALUES
(1, 'Bronze',   5,  0,           10000000),
(1, 'Silver',   8,  10000000,    50000000),
(1, 'Gold',     12, 50000000,    150000000),
(1, 'Platinum', 15, 150000000,   NULL);


-- ============================================================
-- VOUCHERS
-- ============================================================

INSERT INTO vouchers (company_id, code, name, description, type, value, min_purchase, max_discount, quota, used, start_date, end_date, is_disabled) VALUES
(1, 'ELEVEN10',    'Diskon 10% Semua Produk', 'Diskon 10% untuk semua produk',      'percentage', 10,  100000, 500000, 100, 37, CURRENT_DATE-10, CURRENT_DATE+20, FALSE),
(1, 'GRATIS-ONGKIR','Gratis Ongkir Nasional', 'Bebas ongkir ke seluruh Indonesia',  'fixed',   50000,  200000,   NULL, 200, 88, CURRENT_DATE-5,  CURRENT_DATE+25, FALSE),
(1, 'NEWUSER50',   'Selamat Datang Rp50.000', 'Khusus pengguna baru',               'fixed',   50000,  150000,   NULL, 500, 12, CURRENT_DATE,    CURRENT_DATE+60, FALSE),
(1, 'FLASH20',     'Flash Sale 20%',          'Diskon 20% khusus flash sale',       'percentage', 20,  500000, 1000000, 50, 50, CURRENT_DATE-30, CURRENT_DATE-1,  FALSE);


-- ============================================================
-- FLASH SALES
-- ============================================================

INSERT INTO flash_sales (id, company_id, name, start_date_time, end_date_time)
OVERRIDING SYSTEM VALUE VALUES
(1, 1, 'Flash Sale Gadget Akhir Pekan', NOW()+'1 day'::interval,  NOW()+'2 days'::interval),
(2, 1, 'Flash Sale Fashion Week',        NOW()-'2 days'::interval, NOW()-'1 day'::interval);

SELECT setval(pg_get_serial_sequence('flash_sales', 'id'), 2);

INSERT INTO flash_sale_items (flash_sale_id, product_id, product_name, original_price, sale_price, quota, sold) VALUES
(1, 1, 'iPhone 14 Pro Max',     15999000, 13999000, 10, 0),
(1, 4, 'Sony WH-1000XM5',        5499000,  4499000, 20, 0),
(2, 6, 'Nike Air Jordan 1 Retro',2499000,  1999000,  5, 5),
(2, 8, 'Kemeja Batik Premium',    450000,   350000, 20, 14);


-- ============================================================
-- STORE SETTINGS
-- ============================================================

INSERT INTO store_settings (company_id, store_name, theme_color, processing_days) VALUES
(1, 'Eleven Store', '#6366f1', 1);

INSERT INTO courier_services (company_id, name, is_enabled, estimated_days) VALUES
(1, 'JNE',      TRUE,  '2-3 hari'),
(1, 'J&T',      TRUE,  '2-3 hari'),
(1, 'SiCepat',  TRUE,  '1-2 hari'),
(1, 'Anteraja', FALSE, '2-4 hari'),
(1, 'Gojek',    FALSE, '1 hari'),
(1, 'Grab',     FALSE, '1 hari');


-- ============================================================
-- NOTIFICATIONS
-- ============================================================

INSERT INTO notifications (company_id, type, title, message, status, priority) VALUES
(1, 'order',   'Pesanan baru masuk',              'Pesanan ORD-20240111-011 dari Lestari Indah (Rp16.029.000) menunggu konfirmasi.', 'unread', 'high'),
(1, 'order',   'Pesanan baru masuk',              'Pesanan ORD-20240111-010 dari Farhan Hadi (Rp5.519.000) menunggu konfirmasi.',   'unread', 'high'),
(1, 'stock',   'Stok hampir habis',               'Produk "Nike Air Jordan 1 Retro" tersisa 3 unit.',                               'unread', 'medium'),
(1, 'stock',   'Stok habis',                      'Produk "Adidas Ultraboost 22" stok 0. Segera restock.',                         'unread', 'high'),
(1, 'payment', 'Pembayaran berhasil dikonfirmasi', 'Pembayaran ORD-20240110-008 dari Siti Nurhaliza (Rp2.524.000) berhasil.',       'read',   'medium'),
(1, 'system',  'Reseller baru menunggu persetujuan','Rina Setiawan (RINA24) mendaftar sebagai reseller baru.',                     'unread', 'medium');


-- ============================================================
-- DAILY STATS — 30 hari terakhir
-- ============================================================

INSERT INTO daily_stats (company_id, date, total_sales, total_orders, total_visitors, conversion_rate, avg_order_value, total_refund, admin_fee, net_income)
SELECT
  1,
  CURRENT_DATE - s.day,
  ROUND((8000000  + random() * 12000000)::numeric, -3),
  FLOOR(3  + random() * 8)::int,
  FLOOR(120 + random() * 280)::int,
  ROUND((2.5 + random() * 4.5)::numeric, 2),
  ROUND((2500000 + random() * 3500000)::numeric, -3),
  ROUND((random() * 500000)::numeric, -3),
  ROUND(((8000000 + random() * 12000000) * 0.02)::numeric, -3),
  ROUND(((8000000 + random() * 12000000) * 0.98)::numeric, -3)
FROM generate_series(0, 29) AS s(day);


-- ============================================================
-- SELESAI
-- Akun demo:
--   Company Code : ELEVEN
--   Email        : admin@eleven.id
--   Password     : Admin1234!
-- ============================================================
