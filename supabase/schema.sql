-- ============================================================
-- Seller Management System — Supabase Schema
-- Platform  : Eleven Commerce
-- Multi-tenant via companies.code (Company Code di halaman login)
-- ============================================================
-- Aman dijalankan berulang kali — semua DROP IF EXISTS CASCADE di atas
-- ============================================================

-- ============================================================
-- RESET (drop semua jika sudah ada)
-- ============================================================

DROP TABLE IF EXISTS daily_stats                  CASCADE;
DROP TABLE IF EXISTS notifications                CASCADE;
DROP TABLE IF EXISTS courier_services             CASCADE;
DROP TABLE IF EXISTS store_settings               CASCADE;
DROP TABLE IF EXISTS flash_sale_items             CASCADE;
DROP TABLE IF EXISTS flash_sales                  CASCADE;
DROP TABLE IF EXISTS vouchers                     CASCADE;
DROP TABLE IF EXISTS reseller_commission_payments CASCADE;
DROP TABLE IF EXISTS reseller_tier_configs        CASCADE;
DROP TABLE IF EXISTS resellers                    CASCADE;
DROP TABLE IF EXISTS inventory_logs               CASCADE;
DROP TABLE IF EXISTS financial_transactions       CASCADE;
DROP TABLE IF EXISTS payments                     CASCADE;
DROP TABLE IF EXISTS order_return_requests        CASCADE;
DROP TABLE IF EXISTS order_items                  CASCADE;
DROP TABLE IF EXISTS orders                       CASCADE;
DROP TABLE IF EXISTS customer_addresses           CASCADE;
DROP TABLE IF EXISTS customers                    CASCADE;
DROP TABLE IF EXISTS product_images               CASCADE;
DROP TABLE IF EXISTS products                     CASCADE;
DROP TABLE IF EXISTS categories                   CASCADE;
DROP TABLE IF EXISTS seller_profiles              CASCADE;
DROP TABLE IF EXISTS companies                    CASCADE;

DROP TYPE IF EXISTS notif_status          CASCADE;
DROP TYPE IF EXISTS notif_priority        CASCADE;
DROP TYPE IF EXISTS notif_type            CASCADE;
DROP TYPE IF EXISTS voucher_type          CASCADE;
DROP TYPE IF EXISTS reseller_status       CASCADE;
DROP TYPE IF EXISTS reseller_tier         CASCADE;
DROP TYPE IF EXISTS tx_status             CASCADE;
DROP TYPE IF EXISTS tx_type               CASCADE;
DROP TYPE IF EXISTS inventory_ref_type    CASCADE;
DROP TYPE IF EXISTS inventory_movement_type CASCADE;
DROP TYPE IF EXISTS address_type          CASCADE;
DROP TYPE IF EXISTS customer_status       CASCADE;
DROP TYPE IF EXISTS customer_segment      CASCADE;
DROP TYPE IF EXISTS return_status         CASCADE;
DROP TYPE IF EXISTS return_type           CASCADE;
DROP TYPE IF EXISTS payment_status        CASCADE;
DROP TYPE IF EXISTS order_status          CASCADE;
DROP TYPE IF EXISTS product_status        CASCADE;
DROP TYPE IF EXISTS seller_role           CASCADE;
DROP TYPE IF EXISTS company_status        CASCADE;

DROP FUNCTION IF EXISTS set_updated_at()  CASCADE;
DROP FUNCTION IF EXISTS my_company_id()   CASCADE;

-- ============================================================
-- ENUMS
-- ============================================================

CREATE TYPE company_status          AS ENUM ('active', 'inactive', 'suspended');
CREATE TYPE seller_role             AS ENUM ('owner', 'admin', 'staff');
CREATE TYPE product_status          AS ENUM ('active', 'inactive', 'out_of_stock');
CREATE TYPE order_status            AS ENUM ('pending', 'processing', 'shipped', 'delivered', 'cancelled');
CREATE TYPE payment_status          AS ENUM ('waiting', 'paid', 'failed', 'refunded');
CREATE TYPE return_type             AS ENUM ('return_item', 'refund_only');
CREATE TYPE return_status           AS ENUM ('requested', 'approved', 'rejected', 'completed');
CREATE TYPE customer_segment        AS ENUM ('New', 'Regular', 'VIP');
CREATE TYPE customer_status         AS ENUM ('active', 'inactive', 'blocked');
CREATE TYPE address_type            AS ENUM ('home', 'office', 'other');
CREATE TYPE inventory_movement_type AS ENUM ('in', 'out', 'adjustment');
CREATE TYPE inventory_ref_type      AS ENUM ('order', 'restock', 'adjustment', 'return');
CREATE TYPE tx_type                 AS ENUM ('Penjualan', 'Penarikan', 'Refund', 'Biaya Admin');
CREATE TYPE tx_status               AS ENUM ('Sukses', 'Pending', 'Gagal');
CREATE TYPE reseller_tier           AS ENUM ('Bronze', 'Silver', 'Gold', 'Platinum');
CREATE TYPE reseller_status         AS ENUM ('active', 'pending', 'suspended');
CREATE TYPE voucher_type            AS ENUM ('percentage', 'fixed');
CREATE TYPE notif_type              AS ENUM ('order', 'payment', 'stock', 'system', 'marketing');
CREATE TYPE notif_priority          AS ENUM ('low', 'medium', 'high');
CREATE TYPE notif_status            AS ENUM ('unread', 'read');

-- ============================================================
-- HELPER — auto-update updated_at
-- ============================================================

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 1. COMPANIES
-- ============================================================

CREATE TABLE companies (
  id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  code       TEXT           NOT NULL UNIQUE,   -- Company Code di login, e.g. "ELEVEN"
  name       TEXT           NOT NULL,
  email      TEXT,
  phone      TEXT,
  logo_url   TEXT,
  status     company_status NOT NULL DEFAULT 'active',
  created_at TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ    NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_companies_updated_at
  BEFORE UPDATE ON companies FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- 2. SELLER PROFILES  (auth.users → companies)
--    id tetap UUID karena harus match dengan auth.users Supabase
-- ============================================================

CREATE TABLE seller_profiles (
  id          UUID           PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  company_id  BIGINT         NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  role        seller_role    NOT NULL DEFAULT 'staff',
  full_name   TEXT           NOT NULL,
  phone       TEXT,
  avatar_url  TEXT,
  is_active   BOOLEAN        NOT NULL DEFAULT TRUE,
  created_at  TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ    NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_seller_profiles_updated_at
  BEFORE UPDATE ON seller_profiles FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- 3. CATEGORIES
-- ============================================================

CREATE TABLE categories (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_id  BIGINT  NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  name        TEXT    NOT NULL,
  description TEXT,
  image_url   TEXT,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_categories_updated_at
  BEFORE UPDATE ON categories FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- 4. PRODUCTS & PRODUCT IMAGES
-- ============================================================

CREATE TABLE products (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_id  BIGINT         NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  category_id BIGINT         REFERENCES categories(id) ON DELETE SET NULL,
  name        TEXT           NOT NULL,
  description TEXT,
  sku         TEXT           NOT NULL,
  price       NUMERIC(15,2)  NOT NULL CHECK (price >= 0),
  stock       INTEGER        NOT NULL DEFAULT 0 CHECK (stock >= 0),
  weight      NUMERIC(8,2)   DEFAULT 0,
  status      product_status NOT NULL DEFAULT 'active',
  is_featured BOOLEAN        NOT NULL DEFAULT FALSE,
  created_at  TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
  UNIQUE (company_id, sku)
);

CREATE TRIGGER trg_products_updated_at
  BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE product_images (
  id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  product_id BIGINT  NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  image_url  TEXT    NOT NULL,
  alt_text   TEXT,
  is_primary BOOLEAN NOT NULL DEFAULT FALSE,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 5. CUSTOMERS & ALAMAT
-- ============================================================

CREATE TABLE customers (
  id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_id    BIGINT           NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  name          TEXT             NOT NULL,
  email         TEXT             NOT NULL,
  phone         TEXT,
  segment       customer_segment NOT NULL DEFAULT 'New',
  status        customer_status  NOT NULL DEFAULT 'active',
  total_orders  INTEGER          NOT NULL DEFAULT 0,
  total_spend   NUMERIC(15,2)    NOT NULL DEFAULT 0,
  last_order_at TIMESTAMPTZ,
  join_date     DATE             NOT NULL DEFAULT CURRENT_DATE,
  created_at    TIMESTAMPTZ      NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ      NOT NULL DEFAULT NOW(),
  UNIQUE (company_id, email)
);

CREATE TRIGGER trg_customers_updated_at
  BEFORE UPDATE ON customers FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE customer_addresses (
  id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customer_id    BIGINT       NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  type           address_type NOT NULL DEFAULT 'home',
  recipient_name TEXT,
  phone          TEXT,
  address_line1  TEXT         NOT NULL,
  address_line2  TEXT,
  city           TEXT,
  province       TEXT,
  postal_code    TEXT,
  country        TEXT         NOT NULL DEFAULT 'Indonesia',
  is_default     BOOLEAN      NOT NULL DEFAULT FALSE,
  created_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_customer_addresses_updated_at
  BEFORE UPDATE ON customer_addresses FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- 6. ORDERS, ORDER ITEMS, RETURN REQUESTS
-- ============================================================

CREATE TABLE orders (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_id          BIGINT         NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  order_number        TEXT           NOT NULL,
  customer_id         BIGINT         REFERENCES customers(id) ON DELETE SET NULL,
  customer_name       TEXT           NOT NULL,
  customer_address_id BIGINT         REFERENCES customer_addresses(id) ON DELETE SET NULL,
  shipping_address    TEXT,
  status              order_status   NOT NULL DEFAULT 'pending',
  payment_status      payment_status NOT NULL DEFAULT 'waiting',
  payment_method      TEXT,
  subtotal            NUMERIC(15,2)  NOT NULL DEFAULT 0,
  shipping_cost       NUMERIC(15,2)  NOT NULL DEFAULT 0,
  discount_amount     NUMERIC(15,2)  NOT NULL DEFAULT 0,
  total_amount        NUMERIC(15,2)  NOT NULL DEFAULT 0,
  courier             TEXT,
  tracking_number     TEXT,
  notes               TEXT,
  voucher_code        TEXT,
  estimated_delivery  DATE,
  order_date          TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
  shipped_at          TIMESTAMPTZ,
  delivered_at        TIMESTAMPTZ,
  cancelled_at        TIMESTAMPTZ,
  cancel_reason       TEXT,
  created_at          TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
  UNIQUE (company_id, order_number)
);

CREATE TRIGGER trg_orders_updated_at
  BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE order_items (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  order_id     BIGINT        NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id   BIGINT        REFERENCES products(id) ON DELETE SET NULL,
  product_name TEXT          NOT NULL,
  product_sku  TEXT          NOT NULL,
  quantity     INTEGER       NOT NULL CHECK (quantity > 0),
  unit_price   NUMERIC(15,2) NOT NULL CHECK (unit_price >= 0),
  total_price  NUMERIC(15,2) NOT NULL CHECK (total_price >= 0),
  created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE TABLE order_return_requests (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  order_id     BIGINT        NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  type         return_type   NOT NULL,
  reason       TEXT          NOT NULL,
  notes        TEXT,
  status       return_status NOT NULL DEFAULT 'requested',
  request_date TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  resolved_at  TIMESTAMPTZ,
  created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_order_return_requests_updated_at
  BEFORE UPDATE ON order_return_requests FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- 7. PAYMENTS & FINANCIAL TRANSACTIONS
-- ============================================================

CREATE TABLE payments (
  id               BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_id       BIGINT         NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  order_id         BIGINT         NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  payment_method   TEXT           NOT NULL,
  amount           NUMERIC(15,2)  NOT NULL,
  status           payment_status NOT NULL DEFAULT 'waiting',
  transaction_id   TEXT,
  gateway_response JSONB,
  paid_at          TIMESTAMPTZ,
  created_at       TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ    NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_payments_updated_at
  BEFORE UPDATE ON payments FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE financial_transactions (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_id   BIGINT        NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  date         DATE          NOT NULL DEFAULT CURRENT_DATE,
  description  TEXT          NOT NULL,
  type         tx_type       NOT NULL,
  amount       NUMERIC(15,2) NOT NULL,
  status       tx_status     NOT NULL DEFAULT 'Pending',
  reference_id BIGINT,
  created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_financial_transactions_updated_at
  BEFORE UPDATE ON financial_transactions FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- 8. INVENTORY LOGS
-- ============================================================

CREATE TABLE inventory_logs (
  id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_id     BIGINT                  NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  product_id     BIGINT                  NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  movement_type  inventory_movement_type NOT NULL,
  quantity       INTEGER                 NOT NULL,
  previous_stock INTEGER                 NOT NULL,
  new_stock      INTEGER                 NOT NULL,
  reference_type inventory_ref_type      NOT NULL,
  reference_id   BIGINT,
  notes          TEXT,
  created_by     UUID REFERENCES seller_profiles(id) ON DELETE SET NULL,
  created_at     TIMESTAMPTZ             NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 9. RESELLERS, TIER CONFIG, KOMISI
-- ============================================================

CREATE TABLE resellers (
  id                 BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_id         BIGINT          NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  name               TEXT            NOT NULL,
  email              TEXT            NOT NULL,
  phone              TEXT,
  city               TEXT,
  address            TEXT,
  tier               reseller_tier   NOT NULL DEFAULT 'Bronze',
  status             reseller_status NOT NULL DEFAULT 'pending',
  join_date          DATE            NOT NULL DEFAULT CURRENT_DATE,
  total_sales        NUMERIC(15,2)   NOT NULL DEFAULT 0,
  total_orders       INTEGER         NOT NULL DEFAULT 0,
  pending_commission NUMERIC(15,2)   NOT NULL DEFAULT 0,
  paid_commission    NUMERIC(15,2)   NOT NULL DEFAULT 0,
  referral_code      TEXT            NOT NULL,
  notes              TEXT,
  created_at         TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
  updated_at         TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
  UNIQUE (company_id, email),
  UNIQUE (company_id, referral_code)
);

CREATE TRIGGER trg_resellers_updated_at
  BEFORE UPDATE ON resellers FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE reseller_tier_configs (
  id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_id BIGINT        NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  tier       reseller_tier NOT NULL,
  commission NUMERIC(5,2)  NOT NULL DEFAULT 0,
  min_sales  NUMERIC(15,2) NOT NULL DEFAULT 0,
  max_sales  NUMERIC(15,2),
  created_at TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  UNIQUE (company_id, tier)
);

CREATE TRIGGER trg_reseller_tier_configs_updated_at
  BEFORE UPDATE ON reseller_tier_configs FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE reseller_commission_payments (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_id   BIGINT        NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  reseller_id  BIGINT        NOT NULL REFERENCES resellers(id) ON DELETE CASCADE,
  amount       NUMERIC(15,2) NOT NULL,
  period_start DATE          NOT NULL,
  period_end   DATE          NOT NULL,
  notes        TEXT,
  paid_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  created_by   UUID REFERENCES seller_profiles(id) ON DELETE SET NULL,
  created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 10. VOUCHERS
-- ============================================================

CREATE TABLE vouchers (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_id   BIGINT        NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  code         TEXT          NOT NULL,
  name         TEXT          NOT NULL,
  description  TEXT,
  type         voucher_type  NOT NULL DEFAULT 'percentage',
  value        NUMERIC(15,2) NOT NULL CHECK (value > 0),
  min_purchase NUMERIC(15,2) NOT NULL DEFAULT 0,
  max_discount NUMERIC(15,2),
  quota        INTEGER       NOT NULL DEFAULT 1,
  used         INTEGER       NOT NULL DEFAULT 0,
  start_date   DATE          NOT NULL,
  end_date     DATE          NOT NULL,
  is_disabled  BOOLEAN       NOT NULL DEFAULT FALSE,
  created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  UNIQUE (company_id, code),
  CHECK (end_date >= start_date),
  CHECK (used <= quota)
);

CREATE TRIGGER trg_vouchers_updated_at
  BEFORE UPDATE ON vouchers FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- 11. FLASH SALES
-- ============================================================

CREATE TABLE flash_sales (
  id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_id      BIGINT      NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  name            TEXT        NOT NULL,
  start_date_time TIMESTAMPTZ NOT NULL,
  end_date_time   TIMESTAMPTZ NOT NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CHECK (end_date_time > start_date_time)
);

CREATE TRIGGER trg_flash_sales_updated_at
  BEFORE UPDATE ON flash_sales FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE flash_sale_items (
  id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  flash_sale_id  BIGINT        NOT NULL REFERENCES flash_sales(id) ON DELETE CASCADE,
  product_id     BIGINT        REFERENCES products(id) ON DELETE SET NULL,
  product_name   TEXT          NOT NULL,
  original_price NUMERIC(15,2) NOT NULL,
  sale_price     NUMERIC(15,2) NOT NULL CHECK (sale_price > 0),
  quota          INTEGER       NOT NULL DEFAULT 1,
  sold           INTEGER       NOT NULL DEFAULT 0,
  created_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  CHECK (sale_price <= original_price),
  CHECK (sold <= quota)
);

-- ============================================================
-- 12. STORE SETTINGS (1 baris per company)
-- ============================================================

CREATE TABLE store_settings (
  id                    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_id            BIGINT NOT NULL UNIQUE REFERENCES companies(id) ON DELETE CASCADE,
  store_name            TEXT,
  description           TEXT,
  address               TEXT,
  city                  TEXT,
  province              TEXT,
  postal_code           TEXT,
  phone                 TEXT,
  email                 TEXT,
  website               TEXT,
  operational_hours     TEXT,
  logo_url              TEXT,
  notif_email_new_order BOOLEAN       NOT NULL DEFAULT TRUE,
  notif_sms_payment     BOOLEAN       NOT NULL DEFAULT FALSE,
  notif_push            BOOLEAN       NOT NULL DEFAULT TRUE,
  notif_email_low_stock BOOLEAN       NOT NULL DEFAULT TRUE,
  notif_email_promotion BOOLEAN       NOT NULL DEFAULT FALSE,
  theme_color           TEXT          NOT NULL DEFAULT '#6366f1',
  tagline               TEXT,
  banner_image_url      TEXT,
  show_reviews          BOOLEAN       NOT NULL DEFAULT TRUE,
  show_best_sellers     BOOLEAN       NOT NULL DEFAULT TRUE,
  free_shipping_min     NUMERIC(15,2) NOT NULL DEFAULT 0,
  packaging_fee         NUMERIC(15,2) NOT NULL DEFAULT 0,
  processing_days       INTEGER       NOT NULL DEFAULT 1,
  created_at            TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_store_settings_updated_at
  BEFORE UPDATE ON store_settings FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- 13. COURIER SERVICES
-- ============================================================

CREATE TABLE courier_services (
  id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_id     BIGINT      NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  name           TEXT        NOT NULL,
  is_enabled     BOOLEAN     NOT NULL DEFAULT TRUE,
  estimated_days TEXT,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (company_id, name)
);

CREATE TRIGGER trg_courier_services_updated_at
  BEFORE UPDATE ON courier_services FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- 14. NOTIFICATIONS
-- ============================================================

CREATE TABLE notifications (
  id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_id BIGINT         NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  type       notif_type     NOT NULL,
  title      TEXT           NOT NULL,
  message    TEXT           NOT NULL,
  status     notif_status   NOT NULL DEFAULT 'unread',
  priority   notif_priority NOT NULL DEFAULT 'medium',
  action_url TEXT,
  read_at    TIMESTAMPTZ,
  created_at TIMESTAMPTZ    NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 15. DAILY STATS
-- ============================================================

CREATE TABLE daily_stats (
  id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  company_id      BIGINT        NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  date            DATE          NOT NULL,
  total_sales     NUMERIC(15,2) NOT NULL DEFAULT 0,
  total_orders    INTEGER       NOT NULL DEFAULT 0,
  total_visitors  INTEGER       NOT NULL DEFAULT 0,
  conversion_rate NUMERIC(5,2)  NOT NULL DEFAULT 0,
  avg_order_value NUMERIC(15,2) NOT NULL DEFAULT 0,
  total_refund    NUMERIC(15,2) NOT NULL DEFAULT 0,
  admin_fee       NUMERIC(15,2) NOT NULL DEFAULT 0,
  net_income      NUMERIC(15,2) NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  UNIQUE (company_id, date)
);

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_seller_profiles_company     ON seller_profiles(company_id);
CREATE INDEX idx_categories_company          ON categories(company_id);
CREATE INDEX idx_products_company            ON products(company_id);
CREATE INDEX idx_products_category           ON products(category_id);
CREATE INDEX idx_products_status             ON products(company_id, status);
CREATE INDEX idx_product_images_product      ON product_images(product_id);
CREATE INDEX idx_customers_company           ON customers(company_id);
CREATE INDEX idx_customers_segment           ON customers(company_id, segment);
CREATE INDEX idx_customer_addresses_customer ON customer_addresses(customer_id);
CREATE INDEX idx_orders_company              ON orders(company_id);
CREATE INDEX idx_orders_customer             ON orders(customer_id);
CREATE INDEX idx_orders_status               ON orders(company_id, status);
CREATE INDEX idx_orders_date                 ON orders(company_id, order_date DESC);
CREATE INDEX idx_order_items_order           ON order_items(order_id);
CREATE INDEX idx_order_items_product         ON order_items(product_id);
CREATE INDEX idx_return_requests_order       ON order_return_requests(order_id);
CREATE INDEX idx_payments_order              ON payments(order_id);
CREATE INDEX idx_payments_company            ON payments(company_id);
CREATE INDEX idx_financial_tx_company        ON financial_transactions(company_id);
CREATE INDEX idx_financial_tx_date           ON financial_transactions(company_id, date DESC);
CREATE INDEX idx_inventory_logs_product      ON inventory_logs(product_id);
CREATE INDEX idx_inventory_logs_company      ON inventory_logs(company_id);
CREATE INDEX idx_resellers_company           ON resellers(company_id);
CREATE INDEX idx_resellers_status            ON resellers(company_id, status);
CREATE INDEX idx_vouchers_company            ON vouchers(company_id);
CREATE INDEX idx_flash_sales_company         ON flash_sales(company_id);
CREATE INDEX idx_flash_sale_items_sale       ON flash_sale_items(flash_sale_id);
CREATE INDEX idx_notifications_company       ON notifications(company_id);
CREATE INDEX idx_notifications_status        ON notifications(company_id, status);
CREATE INDEX idx_daily_stats_date            ON daily_stats(company_id, date DESC);

-- ============================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================

ALTER TABLE companies                    ENABLE ROW LEVEL SECURITY;
ALTER TABLE seller_profiles              ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories                   ENABLE ROW LEVEL SECURITY;
ALTER TABLE products                     ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_images               ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers                    ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_addresses           ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders                       ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items                  ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_return_requests        ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments                     ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_transactions       ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_logs               ENABLE ROW LEVEL SECURITY;
ALTER TABLE resellers                    ENABLE ROW LEVEL SECURITY;
ALTER TABLE reseller_tier_configs        ENABLE ROW LEVEL SECURITY;
ALTER TABLE reseller_commission_payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE vouchers                     ENABLE ROW LEVEL SECURITY;
ALTER TABLE flash_sales                  ENABLE ROW LEVEL SECURITY;
ALTER TABLE flash_sale_items             ENABLE ROW LEVEL SECURITY;
ALTER TABLE store_settings               ENABLE ROW LEVEL SECURITY;
ALTER TABLE courier_services             ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications                ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_stats                  ENABLE ROW LEVEL SECURITY;

-- Helper: ambil company_id user yang sedang login
CREATE OR REPLACE FUNCTION my_company_id()
RETURNS BIGINT AS $$
  SELECT company_id FROM seller_profiles WHERE id = auth.uid() LIMIT 1;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- Policies

CREATE POLICY "seller: own profile"   ON seller_profiles FOR ALL USING (id = auth.uid());
CREATE POLICY "company: read own"     ON companies       FOR SELECT USING (id = my_company_id());

CREATE POLICY "company: categories"            ON categories            FOR ALL USING (company_id = my_company_id());
CREATE POLICY "company: products"              ON products              FOR ALL USING (company_id = my_company_id());
CREATE POLICY "company: customers"             ON customers             FOR ALL USING (company_id = my_company_id());
CREATE POLICY "company: orders"                ON orders                FOR ALL USING (company_id = my_company_id());
CREATE POLICY "company: payments"              ON payments              FOR ALL USING (company_id = my_company_id());
CREATE POLICY "company: financial_transactions"ON financial_transactions FOR ALL USING (company_id = my_company_id());
CREATE POLICY "company: inventory_logs"        ON inventory_logs        FOR ALL USING (company_id = my_company_id());
CREATE POLICY "company: resellers"             ON resellers             FOR ALL USING (company_id = my_company_id());
CREATE POLICY "company: reseller_tier_configs" ON reseller_tier_configs FOR ALL USING (company_id = my_company_id());
CREATE POLICY "company: reseller_commission_payments" ON reseller_commission_payments FOR ALL USING (company_id = my_company_id());
CREATE POLICY "company: vouchers"              ON vouchers              FOR ALL USING (company_id = my_company_id());
CREATE POLICY "company: flash_sales"           ON flash_sales           FOR ALL USING (company_id = my_company_id());
CREATE POLICY "company: store_settings"        ON store_settings        FOR ALL USING (company_id = my_company_id());
CREATE POLICY "company: courier_services"      ON courier_services      FOR ALL USING (company_id = my_company_id());
CREATE POLICY "company: notifications"         ON notifications         FOR ALL USING (company_id = my_company_id());
CREATE POLICY "company: daily_stats"           ON daily_stats           FOR ALL USING (company_id = my_company_id());

CREATE POLICY "company: product_images" ON product_images FOR ALL
  USING (product_id IN (SELECT id FROM products WHERE company_id = my_company_id()));

CREATE POLICY "company: customer_addresses" ON customer_addresses FOR ALL
  USING (customer_id IN (SELECT id FROM customers WHERE company_id = my_company_id()));

CREATE POLICY "company: order_items" ON order_items FOR ALL
  USING (order_id IN (SELECT id FROM orders WHERE company_id = my_company_id()));

CREATE POLICY "company: order_return_requests" ON order_return_requests FOR ALL
  USING (order_id IN (SELECT id FROM orders WHERE company_id = my_company_id()));

CREATE POLICY "company: flash_sale_items" ON flash_sale_items FOR ALL
  USING (flash_sale_id IN (SELECT id FROM flash_sales WHERE company_id = my_company_id()));
