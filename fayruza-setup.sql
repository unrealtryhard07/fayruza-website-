-- ╔══════════════════════════════════════════════════════════╗
-- ║  FAYRUZA RESTAURANT — FULL DATABASE SETUP              ║
-- ║  Run in Supabase → SQL Editor → New Query              ║
-- ║  Safe to re-run: uses IF NOT EXISTS / ON CONFLICT       ║
-- ╚══════════════════════════════════════════════════════════╝


-- ════════════════════════════════════════
-- 1. ORDERS
-- ════════════════════════════════════════
CREATE TABLE IF NOT EXISTS orders (
  id              BIGSERIAL PRIMARY KEY,
  order_id        TEXT,
  items           JSONB DEFAULT '[]'::jsonb,
  subtotal        NUMERIC(10,3) DEFAULT 0,
  discount_amt    NUMERIC(10,3) DEFAULT 0,
  discount_type   TEXT DEFAULT 'kd',
  tax             NUMERIC(10,3) DEFAULT 0,
  total           NUMERIC(10,3) DEFAULT 0,
  payment_method  TEXT DEFAULT 'cash',
  order_type      TEXT DEFAULT 'dinein',
  delivery_address TEXT DEFAULT '',
  delivery_area   TEXT DEFAULT '',
  table_number    TEXT DEFAULT '',
  customer_name   TEXT DEFAULT '',
  customer_phone  TEXT DEFAULT '',
  notes           TEXT DEFAULT '',
  points_redeemed INT DEFAULT 0,
  points_discount NUMERIC(10,3) DEFAULT 0,
  status          TEXT DEFAULT 'new',
  cancel_reason   TEXT DEFAULT '',
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_orders_status ON orders (status);
CREATE INDEX IF NOT EXISTS idx_orders_created ON orders (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_phone ON orders (customer_phone);
CREATE INDEX IF NOT EXISTS idx_orders_order_id ON orders (order_id);


-- ════════════════════════════════════════
-- 2. PRODUCTS
-- ════════════════════════════════════════
CREATE TABLE IF NOT EXISTS products (
  id                BIGSERIAL PRIMARY KEY,
  category_id       TEXT NOT NULL,
  category_name     TEXT DEFAULT '',
  category_name_ar  TEXT DEFAULT '',
  category_emoji    TEXT DEFAULT '🍽️',
  category_anim_class TEXT DEFAULT '',
  category_sort     INT DEFAULT 0,
  emoji             TEXT DEFAULT '🍽️',
  name              TEXT NOT NULL,
  name_ar           TEXT DEFAULT '',
  price             NUMERIC(10,3),
  meal_price        NUMERIC(10,3),
  fils              INT,
  sml_s             NUMERIC(10,3),
  sml_m             NUMERIC(10,3),
  sml_l             NUMERIC(10,3),
  badge             TEXT,
  image_url         TEXT,
  is_hidden         BOOLEAN DEFAULT FALSE,
  is_sold_out       BOOLEAN DEFAULT FALSE,
  sort_order        INT DEFAULT 0,
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_products_category ON products (category_id);
CREATE INDEX IF NOT EXISTS idx_products_sort ON products (category_sort, sort_order);


-- ════════════════════════════════════════
-- 3. CATEGORIES
-- ════════════════════════════════════════
CREATE TABLE IF NOT EXISTS categories (
  id              BIGSERIAL PRIMARY KEY,
  category_id     TEXT UNIQUE NOT NULL,
  name            TEXT NOT NULL,
  name_ar         TEXT DEFAULT '',
  emoji           TEXT DEFAULT '🍽️',
  anim_class      TEXT DEFAULT '',
  sort_order      INT DEFAULT 0,
  is_active       BOOLEAN DEFAULT TRUE,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);


-- ════════════════════════════════════════
-- 4. COMBOS
-- ════════════════════════════════════════
CREATE TABLE IF NOT EXISTS combos (
  id              BIGSERIAL PRIMARY KEY,
  emoji           TEXT DEFAULT '🎁',
  name            TEXT NOT NULL,
  name_ar         TEXT DEFAULT '',
  description     TEXT DEFAULT '',
  badge           TEXT,
  price           NUMERIC(10,3) NOT NULL,
  items           JSONB DEFAULT '[]'::jsonb,
  is_hidden       BOOLEAN DEFAULT FALSE,
  sort_order      INT DEFAULT 0,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);


-- ════════════════════════════════════════
-- 5. ADMIN USERS
-- ════════════════════════════════════════
CREATE TABLE IF NOT EXISTS admin_users (
  id              BIGSERIAL PRIMARY KEY,
  full_name       TEXT NOT NULL,
  username        TEXT UNIQUE NOT NULL,
  password_hash   TEXT NOT NULL,
  role            TEXT DEFAULT 'staff',
  permissions     JSONB,
  is_active       BOOLEAN DEFAULT TRUE,
  last_login      TIMESTAMPTZ,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);


-- ════════════════════════════════════════
-- 6. CUSTOMERS
-- ════════════════════════════════════════
CREATE TABLE IF NOT EXISTS customers (
  id              BIGSERIAL PRIMARY KEY,
  phone           TEXT UNIQUE NOT NULL,
  name            TEXT DEFAULT '',
  total_orders    INT DEFAULT 0,
  total_spent     NUMERIC(10,3) DEFAULT 0,
  last_order      JSONB,
  last_order_at   TIMESTAMPTZ,
  points_balance  INT DEFAULT 0,
  points_earned   INT DEFAULT 0,
  points_redeemed INT DEFAULT 0,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);


-- ════════════════════════════════════════
-- 7. RESTAURANT SETTINGS (key-value)
-- ════════════════════════════════════════
CREATE TABLE IF NOT EXISTS restaurant_settings (
  id              BIGSERIAL PRIMARY KEY,
  key             TEXT UNIQUE NOT NULL,
  value           TEXT DEFAULT '',
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);


-- ════════════════════════════════════════
-- 8. EXPENSES
-- ════════════════════════════════════════
CREATE TABLE IF NOT EXISTS expenses (
  id              BIGSERIAL PRIMARY KEY,
  category        TEXT DEFAULT 'other',
  description     TEXT DEFAULT '',
  amount          NUMERIC(10,3) DEFAULT 0,
  date            DATE DEFAULT CURRENT_DATE,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses (date DESC);


-- ════════════════════════════════════════
-- 9. SHIFTS
-- ════════════════════════════════════════
CREATE TABLE IF NOT EXISTS shifts (
  id                BIGSERIAL PRIMARY KEY,
  user_id           BIGINT REFERENCES admin_users(id),
  staff_name        TEXT DEFAULT '',
  opening_cash      NUMERIC(10,3) DEFAULT 0,
  closing_cash      NUMERIC(10,3),
  cash_orders_total NUMERIC(10,3),
  started_at        TIMESTAMPTZ DEFAULT NOW(),
  ended_at          TIMESTAMPTZ,
  status            TEXT DEFAULT 'active',
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_shifts_status ON shifts (status);


-- ════════════════════════════════════════
-- 10. SPECIAL OFFERS
-- ════════════════════════════════════════
CREATE TABLE IF NOT EXISTS special_offers (
  id              BIGSERIAL PRIMARY KEY,
  name            TEXT NOT NULL,
  discount_value  NUMERIC(10,3) DEFAULT 0,
  discount_type   TEXT DEFAULT 'percent',
  scope           TEXT DEFAULT 'all',
  scope_value     TEXT,
  time_start      TEXT DEFAULT '00:00',
  time_end        TEXT DEFAULT '23:59',
  active_days     JSONB DEFAULT '[0,1,2,3,4,5]'::jsonb,
  is_active       BOOLEAN DEFAULT TRUE,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);


-- ════════════════════════════════════════
-- 11. ROW-LEVEL SECURITY (RLS)
-- ════════════════════════════════════════
ALTER TABLE orders             ENABLE ROW LEVEL SECURITY;
ALTER TABLE products           ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories         ENABLE ROW LEVEL SECURITY;
ALTER TABLE combos             ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_users        ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers          ENABLE ROW LEVEL SECURITY;
ALTER TABLE restaurant_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses           ENABLE ROW LEVEL SECURITY;
ALTER TABLE shifts             ENABLE ROW LEVEL SECURITY;
ALTER TABLE special_offers     ENABLE ROW LEVEL SECURITY;

-- Full access for anon key (your app uses anon key directly)
-- Drop first to make re-run safe, then create
DO $$ 
DECLARE
  tbl TEXT;
  pol TEXT;
BEGIN
  FOR tbl, pol IN VALUES
    ('orders','orders_all'), ('products','products_all'), ('categories','categories_all'),
    ('combos','combos_all'), ('admin_users','admin_users_all'), ('customers','customers_all'),
    ('restaurant_settings','settings_all'), ('expenses','expenses_all'),
    ('shifts','shifts_all'), ('special_offers','offers_all')
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', pol || '_select', tbl);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', pol || '_insert', tbl);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', pol || '_update', tbl);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', pol || '_delete', tbl);
    EXECUTE format('CREATE POLICY %I ON %I FOR SELECT USING (true)', pol || '_select', tbl);
    EXECUTE format('CREATE POLICY %I ON %I FOR INSERT WITH CHECK (true)', pol || '_insert', tbl);
    EXECUTE format('CREATE POLICY %I ON %I FOR UPDATE USING (true)', pol || '_update', tbl);
    EXECUTE format('CREATE POLICY %I ON %I FOR DELETE USING (true)', pol || '_delete', tbl);
  END LOOP;
END $$;


-- ════════════════════════════════════════
-- 12. REALTIME — Enable on orders table
-- ════════════════════════════════════════
-- Needed for: KDS, admin live updates, status tracking
-- If this errors, enable manually: Dashboard → Database → Replication → orders
DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE orders;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'Realtime already enabled or not available — enable manually in Dashboard → Database → Replication';
END $$;


-- ════════════════════════════════════════
-- 13. STORAGE — Product Images
-- ════════════════════════════════════════
-- You MUST create the bucket manually in Dashboard → Storage:
--   1. Click "New Bucket"
--   2. Name: product-images
--   3. Toggle "Public bucket" ON
--   4. Save
--
-- Then these policies allow upload/read/delete:

DO $$
BEGIN
  DROP POLICY IF EXISTS "product_images_upload" ON storage.objects;
  DROP POLICY IF EXISTS "product_images_read"   ON storage.objects;
  DROP POLICY IF EXISTS "product_images_delete" ON storage.objects;
  
  CREATE POLICY "product_images_upload" ON storage.objects
    FOR INSERT WITH CHECK (bucket_id = 'product-images');
  CREATE POLICY "product_images_read" ON storage.objects
    FOR SELECT USING (bucket_id = 'product-images');
  CREATE POLICY "product_images_delete" ON storage.objects
    FOR DELETE USING (bucket_id = 'product-images');
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'Storage policies skipped — create the product-images bucket first, then re-run this block';
END $$;


-- ════════════════════════════════════════
-- 14. AUTO-UPDATE updated_at TRIGGER
-- ════════════════════════════════════════
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS orders_updated_at ON orders;
CREATE TRIGGER orders_updated_at
  BEFORE UPDATE ON orders
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();


-- ════════════════════════════════════════
-- 15. SEED — Default Settings
-- ════════════════════════════════════════
INSERT INTO restaurant_settings (key, value) VALUES
  ('restaurant_open',    'true'),
  ('closed_message',     'We are currently closed. See you soon!'),
  ('tax_rate',           '0'),
  ('delivery_fee',       '0.500'),
  ('min_order_delivery', '1.500'),
  ('loyalty_rate',       '10'),
  ('loyalty_redeem_rate','100'),
  ('restaurant_phone',   '')
ON CONFLICT (key) DO NOTHING;


-- ════════════════════════════════════════
-- 16. SEED — Default Admin User
-- ════════════════════════════════════════
-- Login:  admin / admin123
-- ⚠️  CHANGE THIS PASSWORD immediately after first login!
INSERT INTO admin_users (full_name, username, password_hash, role, is_active) VALUES
  ('Admin', 'admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'owner', true)
ON CONFLICT (username) DO NOTHING;


-- ════════════════════════════════════════
-- 17. SEED — Default Categories
-- ════════════════════════════════════════
INSERT INTO categories (category_id, name, name_ar, emoji, anim_class, sort_order) VALUES
  ('burgers',  'Burgers',          'برجر',           '🍔', 'burgers',  0),
  ('rolls',    'Rolls & Club',     'رولز وكلوب',     '🌯', 'rolls',    1),
  ('chapathi', 'Chapathi',         'شباتي',          '🫓', 'chapathi', 2),
  ('biryani',  'Biryani',          'برياني',          '🍛', 'biryani',  3),
  ('rice',     'Rice & Specials',  'أرز وأكلات',     '🍚', 'rice',     4),
  ('noodles',  'Noodles & Mains',  'نودلز ومقبلات',  '🍜', 'noodles',  5),
  ('soups',    'Soups',            'شوربات',          '🥣', 'soups',    6),
  ('juices',   'Juices & Drinks',  'عصائر ومشروبات', '🥤', 'juices',   7)
ON CONFLICT (category_id) DO NOTHING;


-- ════════════════════════════════════════
-- 18. MIGRATIONS — Add missing columns to existing tables
-- ════════════════════════════════════════
-- Safe to run even if columns already exist

DO $$
BEGIN
  -- orders: add columns that may be missing
  BEGIN ALTER TABLE orders ADD COLUMN cancel_reason TEXT DEFAULT ''; EXCEPTION WHEN duplicate_column THEN NULL; END;
  BEGIN ALTER TABLE orders ADD COLUMN points_redeemed INT DEFAULT 0; EXCEPTION WHEN duplicate_column THEN NULL; END;
  BEGIN ALTER TABLE orders ADD COLUMN points_discount NUMERIC(10,3) DEFAULT 0; EXCEPTION WHEN duplicate_column THEN NULL; END;
  BEGIN ALTER TABLE orders ADD COLUMN customer_phone TEXT DEFAULT ''; EXCEPTION WHEN duplicate_column THEN NULL; END;
  BEGIN ALTER TABLE orders ADD COLUMN delivery_address TEXT DEFAULT ''; EXCEPTION WHEN duplicate_column THEN NULL; END;
  BEGIN ALTER TABLE orders ADD COLUMN delivery_area TEXT DEFAULT ''; EXCEPTION WHEN duplicate_column THEN NULL; END;
  BEGIN ALTER TABLE orders ADD COLUMN tax NUMERIC(10,3) DEFAULT 0; EXCEPTION WHEN duplicate_column THEN NULL; END;
  BEGIN ALTER TABLE orders ADD COLUMN updated_at TIMESTAMPTZ DEFAULT NOW(); EXCEPTION WHEN duplicate_column THEN NULL; END;

  -- products: add columns that may be missing
  BEGIN ALTER TABLE products ADD COLUMN image_url TEXT; EXCEPTION WHEN duplicate_column THEN NULL; END;
  BEGIN ALTER TABLE products ADD COLUMN is_sold_out BOOLEAN DEFAULT FALSE; EXCEPTION WHEN duplicate_column THEN NULL; END;
  BEGIN ALTER TABLE products ADD COLUMN fils INT; EXCEPTION WHEN duplicate_column THEN NULL; END;
  BEGIN ALTER TABLE products ADD COLUMN meal_price NUMERIC(10,3); EXCEPTION WHEN duplicate_column THEN NULL; END;
  BEGIN ALTER TABLE products ADD COLUMN sml_s NUMERIC(10,3); EXCEPTION WHEN duplicate_column THEN NULL; END;
  BEGIN ALTER TABLE products ADD COLUMN sml_m NUMERIC(10,3); EXCEPTION WHEN duplicate_column THEN NULL; END;
  BEGIN ALTER TABLE products ADD COLUMN sml_l NUMERIC(10,3); EXCEPTION WHEN duplicate_column THEN NULL; END;

  -- categories: add is_active if missing
  BEGIN ALTER TABLE categories ADD COLUMN is_active BOOLEAN DEFAULT TRUE; EXCEPTION WHEN duplicate_column THEN NULL; END;

  -- combos: add is_hidden if missing
  BEGIN ALTER TABLE combos ADD COLUMN is_hidden BOOLEAN DEFAULT FALSE; EXCEPTION WHEN duplicate_column THEN NULL; END;

  -- customers: add loyalty columns if missing
  BEGIN ALTER TABLE customers ADD COLUMN points_balance INT DEFAULT 0; EXCEPTION WHEN duplicate_column THEN NULL; END;
  BEGIN ALTER TABLE customers ADD COLUMN points_earned INT DEFAULT 0; EXCEPTION WHEN duplicate_column THEN NULL; END;
  BEGIN ALTER TABLE customers ADD COLUMN points_redeemed INT DEFAULT 0; EXCEPTION WHEN duplicate_column THEN NULL; END;
  BEGIN ALTER TABLE customers ADD COLUMN last_order JSONB; EXCEPTION WHEN duplicate_column THEN NULL; END;
  BEGIN ALTER TABLE customers ADD COLUMN last_order_at TIMESTAMPTZ; EXCEPTION WHEN duplicate_column THEN NULL; END;

  -- admin_users: add permissions if missing
  BEGIN ALTER TABLE admin_users ADD COLUMN permissions JSONB; EXCEPTION WHEN duplicate_column THEN NULL; END;
  BEGIN ALTER TABLE admin_users ADD COLUMN last_login TIMESTAMPTZ; EXCEPTION WHEN duplicate_column THEN NULL; END;

  RAISE NOTICE '✅ All column migrations applied successfully';
END $$;


-- ════════════════════════════════════════
-- ✅ DONE!
-- ════════════════════════════════════════
-- 
-- AFTER running this SQL, do these manual steps:
--
-- 1. Dashboard → Storage → New Bucket → "product-images" → Public ON → Save
-- 2. Dashboard → Database → Replication → confirm "orders" table is enabled
-- 3. Login at yoursite.vercel.app/login.html
--       Username: admin
--       Password: admin123
-- 4. IMMEDIATELY change password: Admin → Users → Edit admin user
-- 5. Set your WhatsApp number: Admin → Settings → Restaurant WhatsApp No.
