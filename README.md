<![CDATA[<div align="center">

# 🟩 FAYRUZA RESTAURANT

**Full-stack restaurant ordering & management system**

*Jabriya, Kuwait*

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/import/project)

**[Live Menu](https://fayruza-website.vercel.app)** · **[Admin Panel](https://fayruza-website.vercel.app/login.html)** · **[Kitchen Display](https://fayruza-website.vercel.app/kds.html)**

</div>

---

## What is this?

A complete restaurant system built with **zero frameworks** — just vanilla HTML, CSS, JavaScript, and Supabase as the backend. Covers the entire restaurant workflow from the moment a customer opens the menu to the receipt printing in the kitchen.

The system runs as a **Progressive Web App (PWA)** — installable on any phone, works offline, and sends push notifications.

---

## System Overview

```
┌─────────────┐     ┌──────────────┐     ┌──────────────┐
│  CUSTOMER    │────▶│   SUPABASE   │◀────│    ADMIN     │
│  index.html  │     │  (Realtime)  │     │  admin.html  │
│  status.html │     │              │     │  kds.html    │
│  history.html│     └──────┬───────┘     │  login.html  │
└─────────────┘            │              └──────────────┘
                           │
                    ┌──────▼───────┐
                    │   PRINTERS   │
                    │  BT / USB /  │
                    │  Network     │
                    └──────────────┘
```

---

## Pages

### Customer-Facing

| Page | File | Description |
|------|------|-------------|
| **Menu** | `index.html` | Animated category cards, item browser with emoji + photos, size picker (S/M/L), meal upgrades, search, cart with per-item notes, checkout with customer recognition, loyalty points redemption, and order placement. Supports dine-in (with table number), takeaway, and delivery. English/Arabic toggle. |
| **Order Tracker** | `status.html` | Real-time order status with a 4-step stepper (Received → Preparing → Ready → Done). Auto-updates via Supabase Realtime. Accessible by order ID or QR code on receipt. |
| **Order History** | `history.html` | Phone number lookup. Shows customer profile card with loyalty tier (New → Regular → Silver → Gold), total orders, total spent, average order value, points balance. Expandable order cards with one-tap reorder that pre-loads the cart on the menu page. |

### Staff / Admin

| Page | File | Description |
|------|------|-------------|
| **Admin Panel** | `admin.html` | Full back-office ERP with 13 pages (see below). Role-based access (Owner / Manager / Staff). Session-based auth with 12-hour expiry. |
| **Kitchen Display** | `kds.html` | Real-time KDS with order cards color-coded by status. Timer showing elapsed time per order with warning thresholds. Sound alerts on new orders. Filter by status (New / Preparing / Ready). Bump buttons to progress orders. |
| **Login** | `login.html` | SHA-256 hashed password authentication against `admin_users` table. Auto-redirect if already authenticated. |

---

## Admin Panel Pages

| Page | What it does |
|------|-------------|
| **Dashboard** | Today's KPIs (orders, revenue, pending, avg order, low stock), recent orders table, top selling items, hourly order chart, 7-day and 30-day revenue trend charts, kitchen prep time analytics |
| **Orders** | Full order management with search, status filters, order detail modal with status workflow buttons, cash change calculator, discount application, receipt printing, cancel with reason, CSV export |
| **Reports** | Five report types: Sales (by day, full log), Top Items (qty + revenue bars), Stock on Hand, Payments (cash/KNET/card breakdown), Prep Time analytics. Period filter (today/week/month/all). Printable daily closing report. |
| **Expenses** | Log expenses by category (ingredients, packaging, utilities, staff, rent, maintenance, marketing, other). Monthly P&L with revenue vs. expenses vs. net profit. |
| **Categories** | Add, edit, reorder, and hide/show menu categories. Hiding a category bulk-hides all its products from the customer menu. |
| **Products** | Full product CRUD with category grouping, price types (standard / with meal / fils / S-M-L sizes), image upload (drag-and-drop to Supabase Storage or URL paste), badges, sold-out toggle, hidden toggle, bulk operations (select-all, bulk hide/show/sold-out). |
| **Combos** | Bundle deals — combine multiple items at a set price. Shown as special cards on the customer menu. |
| **Special Offers** | Time-based discounts with day-of-week scheduling. Scope: all items, specific category, or specific item. Percentage or fixed-amount discount. Live/scheduled/paused status. |
| **Shifts** | Start/end shifts per staff member. Opening and closing cash amounts. Auto-calculates expected cash (opening + cash orders during shift) and variance. Full shift log with filters. |
| **Customers** | Customer database built from checkout phone numbers. Shows total orders, lifetime value, loyalty points balance, last order items. KPI cards (total, returning, avg LTV, total points outstanding). CSV export. |
| **Users** | Team management with three roles (Owner, Manager, Staff). Role-based page access. Password management. Active/inactive toggle. |
| **Settings** | Restaurant open/close toggle with custom closed message, tax rate, delivery fee, minimum delivery order, loyalty earn/redeem rates, restaurant WhatsApp number, opening hours editor. |
| **Printers** | Multi-printer management. Add unlimited printers (Bluetooth / Network / USB). Per-printer copies, auto-print on new order flag, default printer flag. Test print per printer. |
| **Table QR Codes** | Auto-generated QR codes per table number. Links to menu with pre-filled table number. Print all as a sheet. |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Vanilla HTML, CSS, JavaScript — no React, no build step |
| Backend | [Supabase](https://supabase.com) — PostgreSQL + Realtime + Storage + REST API |
| Auth | Custom SHA-256 session-based auth (stored in localStorage) |
| Hosting | [Vercel](https://vercel.com) — static file hosting with auto-deploy from GitHub |
| PWA | Service workers for offline caching, web manifest for installability |
| Fonts | Bebas Neue, Barlow Condensed, Barlow (Google Fonts) |
| Printing | ESC/POS binary protocol for BT/USB thermal printers + HTML receipt for browser print |
| Notifications | Web Push Notifications API + WhatsApp alerts via CallMeBot |

---

## Setup

### 1. Create a Supabase Project

Go to [supabase.com](https://supabase.com), create a new project. Grab your:
- **Project URL** (e.g. `https://xxxxx.supabase.co`)
- **Anon public key** (starts with `eyJ...`)

Update these in the `<script>` sections of `index.html`, `admin.html`, `kds.html`, `status.html`, `history.html`, and `login.html`.

### 2. Run the Database Setup

Open **Supabase Dashboard → SQL Editor → New Query**, paste the entire contents of `fayruza-setup.sql`, and click **Run**.

This creates all 11 tables, indexes, RLS policies, realtime subscriptions, triggers, and seed data. Safe to re-run — uses `IF NOT EXISTS` and `ON CONFLICT DO NOTHING`.

### 3. Create the Storage Bucket

Go to **Dashboard → Storage → New Bucket**:
- Name: `product-images`
- Toggle **Public bucket** ON
- Save

### 4. Enable Realtime

Go to **Dashboard → Database → Replication** and confirm the `orders` table is enabled. This powers live updates on the KDS, admin panel, and order status tracker.

### 5. Deploy to Vercel

```bash
# Option A: Connect GitHub repo
# Push all files to a GitHub repo, then import in Vercel

# Option B: Vercel CLI
npm i -g vercel
vercel --prod
```

### 6. First Login

Go to `yoursite.vercel.app/login.html`:
- **Username:** `admin`
- **Password:** `admin123`

**Change the password immediately** in Admin → Users → Edit the admin user.

---

## Database Schema

### Tables (11)

| Table | Purpose | Key Columns |
|-------|---------|-------------|
| `orders` | All orders | `order_id`, `items` (JSONB), `total`, `status`, `order_type`, `customer_phone`, `points_redeemed` |
| `products` | Menu items | `category_id`, `name`, `price`, `meal_price`, `fils`, `sml_s/m/l`, `image_url`, `is_sold_out`, `is_hidden` |
| `categories` | Menu categories | `category_id` (slug), `name`, `emoji`, `sort_order`, `is_active` |
| `combos` | Bundle deals | `name`, `price`, `items` (JSONB), `is_hidden` |
| `admin_users` | Staff auth | `username`, `password_hash` (SHA-256), `role`, `is_active` |
| `customers` | Customer profiles | `phone` (unique), `total_orders`, `total_spent`, `points_balance`, `last_order` (JSONB) |
| `restaurant_settings` | Key-value config | `key` (unique), `value` |
| `expenses` | Expense tracking | `category`, `amount`, `date` |
| `shifts` | Shift management | `staff_name`, `opening_cash`, `closing_cash`, `cash_orders_total`, `status` |
| `special_offers` | Time-based deals | `discount_value`, `discount_type`, `scope`, `time_start/end`, `active_days` (JSONB) |
| `printers` | Printer configs | `name`, `type` (bluetooth/network/usb), `ip`, `copies`, `auto_print_orders`, `is_default` |

### Settings Keys

| Key | Default | Description |
|-----|---------|-------------|
| `restaurant_open` | `true` | Toggle ordering on/off |
| `closed_message` | *We are currently closed...* | Shown on menu when closed |
| `tax_rate` | `0` | Tax percentage |
| `delivery_fee` | `0.500` | Delivery fee in KD |
| `min_order_delivery` | `1.500` | Minimum order for delivery |
| `loyalty_rate` | `10` | Points earned per 1 KD spent |
| `loyalty_redeem_rate` | `100` | Points needed for 1 KD discount |
| `restaurant_phone` | *(empty)* | WhatsApp number for customer contact button |

---

## Printing

### How it Works

When you tap **🖨 PRINT / PDF** on any order, you get two options:

| Button | What happens |
|--------|-------------|
| **📥 VIEW PDF** | Opens receipt in a new tab for viewing, downloading, or sharing |
| **🖨 PRINT** | Opens receipt → triggers your device's native print dialog → select your printer → prints instantly |

If you have **Bluetooth or USB thermal printers** paired in the current browser session, they appear as additional one-tap direct-print buttons below (ESC/POS protocol).

### Adding Thermal Printers

1. Admin → Sidebar → **🖨 Printer**
2. Pair your Bluetooth printer: tap **📶 PAIR BLUETOOTH** (Chrome/Edge required)
3. Fill in name, copies, and toggle **Auto-print orders** if you want every new order to auto-print
4. Save

Network printers work through your device's native print system — no IP configuration needed. Just tap **🖨 PRINT** and select the printer from your phone's picker.

---

## Loyalty System

Customers are identified by **phone number** at checkout. The system tracks:

- **Points earned** — configurable rate (default: 10 pts per 1 KD spent)
- **Points redeemed** — configurable rate (default: 100 pts = 1 KD discount)
- **Tier badges** — New (0-4 orders), Regular (5-19), Silver (20-49), Gold (50+)
- **Last order memory** — returning customers see a "Reorder" button with their previous items

Points are shown on receipts and can be redeemed during checkout.

---

## Notifications

### Push Notifications (Browser)
Admin → Sidebar → **🔔 Notifications** → grant permission. Staff gets browser notifications with order details on every new order. Works even when the admin tab is in the background.

### WhatsApp Alerts
Admin → Sidebar → **💬 WhatsApp Alerts** → configure your phone number and [CallMeBot](https://www.callmebot.com/blog/free-api-whatsapp-messages/) API key. Sends a formatted message to your WhatsApp on every new order.

### Customer WhatsApp Contact
Admin → Settings → **Restaurant WhatsApp No.** → enter your number with country code (e.g. `96599999999`). After placing an order, customers see a "💬 Contact on WhatsApp" button.

---

## PWA & Offline

Both the customer menu and admin panel are installable as PWAs:

- **Customer:** Add to Home Screen from browser → launches as standalone app with the Fayruza icon
- **Admin:** Same flow — gets its own icon and standalone window

Service workers cache the app shell for instant loading and basic offline support. API calls (Supabase) always go to network.

Cache versions are bumped on each deploy (`fayruza-v2`, `fayruza-admin-v2`) to force fresh updates.

---

## File Structure

```
├── index.html              # Customer menu + cart + checkout
├── status.html             # Order status tracker
├── history.html            # Customer order history (phone lookup)
├── admin.html              # Full admin panel (13 pages, single HTML file)
├── kds.html                # Kitchen display system
├── login.html              # Admin authentication
├── sw.js                   # Service worker (customer)
├── admin-sw.js             # Service worker (admin)
├── manifest.json           # PWA manifest (customer)
├── admin-manifest.json     # PWA manifest (admin)
├── icon-192.png            # App icon 192×192
├── icon-512.png            # App icon 512×512
├── vercel.json             # Vercel config (clean URLs, security headers)
├── fayruza-setup.sql       # Complete database setup script
└── README.md               # This file
```

---

## Currency

All prices are in **Kuwaiti Dinar (KD)** with 3 decimal places (fils). The `money()` formatter displays:
- Values under 1 KD as fils (e.g. "750 Fils")
- Values 1 KD and above as KD (e.g. "1.500 KD")

---

## Security Notes

- Passwords are SHA-256 hashed client-side before storage — never sent or stored in plain text
- Admin sessions expire after 12 hours
- RLS is enabled on all tables (currently permissive for anon key — tighten for production)
- `vercel.json` includes `X-Content-Type-Options: nosniff` and `X-Frame-Options: DENY` headers
- Service workers use `no-cache` headers to ensure updates propagate

For production hardening, consider:
- Moving to Supabase Auth instead of custom auth
- Adding RLS policies that check authenticated roles
- Rate limiting the order creation endpoint
- Moving the Supabase anon key to environment variables

---

## License

Private project — Fayruza Restaurant, Jabriya, Kuwait.

---

<div align="center">

**Built with ☕ and 🍔**

*Fayruza Restaurant · Jabriya · Block 12 · Jamia Branch*

</div>
]]>