<p align="center">
  <img src="icon-512.png" alt="Fayruza" width="120" height="120" style="border-radius:20px">
</p>

<h1 align="center">FAYRUZA RESTAURANT</h1>

<p align="center">
  <strong>Full-stack restaurant ordering & management system</strong><br>
  <em>Jabriya, Kuwait</em>
</p>

<p align="center">
  <a href="https://fayruza-website.vercel.app">🍔 Live Menu</a>&nbsp;&nbsp;·&nbsp;&nbsp;
  <a href="https://fayruza-website.vercel.app/login.html">🔐 Admin Panel</a>&nbsp;&nbsp;·&nbsp;&nbsp;
  <a href="https://fayruza-website.vercel.app/kds.html">🍳 Kitchen Display</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Frontend-Vanilla_JS-F7DF1E?style=flat-square&logo=javascript&logoColor=black" alt="JS">
  <img src="https://img.shields.io/badge/Backend-Supabase-3ECF8E?style=flat-square&logo=supabase&logoColor=white" alt="Supabase">
  <img src="https://img.shields.io/badge/Hosting-Vercel-000?style=flat-square&logo=vercel&logoColor=white" alt="Vercel">
  <img src="https://img.shields.io/badge/PWA-Installable-5A0FC8?style=flat-square&logo=pwa&logoColor=white" alt="PWA">
</p>

---

## About

A complete restaurant system built with **zero frameworks** — vanilla HTML/CSS/JS with Supabase as the backend. Covers the full workflow from customer browsing the menu to receipt printing in the kitchen.

Runs as a **Progressive Web App** — installable on any phone, works offline, sends push notifications.

```
Customer                    Backend                     Staff
┌──────────────┐      ┌──────────────┐      ┌──────────────────┐
│  Menu        │─────▶│              │◀─────│  Admin Panel     │
│  Order Track │      │   Supabase   │      │  Kitchen Display │
│  History     │      │  (Realtime)  │      │  Receipt Printer │
└──────────────┘      └──────────────┘      └──────────────────┘
```

---

## Pages

### Customer

| Page | File | What it does |
|:-----|:-----|:-------------|
| Menu | `index.html` | Animated category cards, item browser with photos + emoji, S/M/L size picker, meal upgrades, cart with per-item notes, checkout with loyalty points, English/Arabic toggle |
| Order Tracker | `status.html` | Real-time 4-step stepper (Received → Preparing → Ready → Done), auto-updates via Supabase Realtime |
| Order History | `history.html` | Phone lookup → profile card with loyalty tier, order history with one-tap reorder |

### Staff

| Page | File | What it does |
|:-----|:-----|:-------------|
| Admin Panel | `admin.html` | 13-page back-office ERP (see details below) |
| Kitchen Display | `kds.html` | Real-time order cards, elapsed timers, sound alerts, bump-to-next-status buttons |
| Login | `login.html` | SHA-256 auth with role-based access (Owner / Manager / Staff) |

---

## Admin Panel — 13 Sections

<details>
<summary><strong>📊 Dashboard</strong></summary>

- Today's KPIs: orders, revenue, pending, avg order value, low stock items
- Recent orders table
- Top selling items ranked
- Hourly order distribution chart
- 7-day and 30-day revenue trend charts
- Kitchen prep time analytics
</details>

<details>
<summary><strong>📋 Orders</strong></summary>

- All orders with search and status filters (New / Prep / Ready / Done)
- Order detail modal with status workflow buttons
- Cash change calculator
- Discount application
- Receipt printing (PDF + native printer)
- Cancel with reason tracking
- CSV export
</details>

<details>
<summary><strong>📈 Reports</strong></summary>

Five report types with period filter (Today / Week / Month / All Time):
- **Sales** — daily breakdown + full order log
- **Top Items** — quantity + revenue with bar charts
- **Stock on Hand** — inventory checklist
- **Payments** — Cash / KNET / Card breakdown with percentages
- **Prep Time** — kitchen performance analytics

Printable daily closing report with revenue summary, payment breakdown, top 10 items.
</details>

<details>
<summary><strong>💸 Expenses</strong></summary>

- Log expenses by category (ingredients, packaging, utilities, staff, rent, maintenance, marketing, other)
- Monthly P&L: revenue vs expenses vs net profit
- Period filter and delete
</details>

<details>
<summary><strong>📂 Categories</strong></summary>

- Add, edit, reorder, hide/show menu categories
- Hiding a category bulk-hides all its products from the customer menu
- Dynamic — syncs to product dropdown automatically
</details>

<details>
<summary><strong>🍽️ Products</strong></summary>

- Full CRUD with category grouping
- Four price types: Standard KD / With Meal / Fils / S-M-L Sizes
- Image upload: drag-and-drop to Supabase Storage or paste URL
- Badges, sold-out toggle, hidden toggle
- Bulk operations: select all, bulk hide/show/sold-out, restock all
</details>

<details>
<summary><strong>🎁 Combos</strong></summary>

- Bundle deals combining multiple items at a set price
- Shown as special cards on the customer menu
- Custom emoji, Arabic name, description, badge
</details>

<details>
<summary><strong>🏷️ Special Offers</strong></summary>

- Time-based discounts with day-of-week scheduling
- Scope: all items, specific category, or specific item
- Percentage or fixed-amount discount
- Live / Scheduled / Paused status indicator
</details>

<details>
<summary><strong>🕐 Shifts</strong></summary>

- Start/end shifts per staff member
- Opening and closing cash amounts
- Auto-calculates expected cash and variance
- Full shift log with active/closed filter
</details>

<details>
<summary><strong>👤 Customers</strong></summary>

- Database built from checkout phone numbers
- KPIs: total customers, returning (2+ orders), avg lifetime value, total points outstanding
- Search by name or phone
- CSV export
</details>

<details>
<summary><strong>👥 Users</strong></summary>

- Three roles: Owner (full access), Manager (dashboard + orders + reports), Staff (orders only)
- Password management with SHA-256 hashing
- Active/inactive toggle
</details>

<details>
<summary><strong>⚙️ Settings</strong></summary>

- Restaurant open/close toggle with custom message
- Tax rate, delivery fee, minimum delivery order
- Loyalty earn and redeem rates
- Restaurant WhatsApp number (shown to customers after ordering)
- Opening hours editor
</details>

<details>
<summary><strong>🖨 Printers</strong></summary>

- Multi-printer management — add unlimited printers
- Types: Bluetooth (ESC/POS), Network, USB
- Per-printer: copies, auto-print on new order, default flag
- Test print per printer
- Pair Bluetooth / Connect USB devices per browser session
</details>

Additional: **📲 Table QR Codes** — auto-generated per table, links to menu with pre-filled table number.

---

## Printing

When you tap **🖨 PRINT / PDF** on any order:

| Button | What happens |
|:-------|:-------------|
| 📥 **VIEW PDF** | Opens receipt in new tab — view, download, share. No print dialog. |
| 🖨 **PRINT** | Opens receipt → device's native print dialog → pick your printer → instant print |
| 📶 **Kitchen** | *(Only if BT paired)* Sends ESC/POS directly to thermal printer — no dialog |

Network printers work through your phone's native print system. Bluetooth/USB thermal printers use ESC/POS binary protocol for instant silent printing.

---

## Loyalty System

Customers identified by phone number at checkout.

| Feature | Default |
|:--------|:--------|
| Earn rate | 10 pts per 1 KD spent |
| Redeem rate | 100 pts = 1 KD discount |
| Tiers | 🌱 New (0-4) · ⭐ Regular (5-19) · 🥈 Silver (20-49) · 🥇 Gold (50+) |

Points displayed on receipts. Returning customers see their balance and a reorder button at checkout.

---

## Tech Stack

| Layer | Technology |
|:------|:-----------|
| Frontend | Vanilla HTML / CSS / JavaScript — no React, no build step |
| Backend | [Supabase](https://supabase.com) — PostgreSQL + Realtime + Storage + REST API |
| Auth | Custom SHA-256 session-based (12h expiry) |
| Hosting | [Vercel](https://vercel.com) — static hosting, auto-deploy from GitHub |
| PWA | Service workers + web manifest |
| Fonts | Bebas Neue · Barlow Condensed · Barlow |
| Printing | ESC/POS for thermal printers + HTML receipts for browser print |
| Alerts | Web Push Notifications + WhatsApp via CallMeBot |

---

## Setup

### 1. Supabase Project

Create a project at [supabase.com](https://supabase.com). Copy your **Project URL** and **Anon Key**.

Update `SB_URL` and `SB_KEY` in: `index.html`, `admin.html`, `kds.html`, `status.html`, `history.html`, `login.html`.

### 2. Run Database Setup

**SQL Editor → New Query** → paste `fayruza-setup.sql` → **Run**.

Creates 11 tables, indexes, RLS policies, realtime, triggers, and seed data. Safe to re-run.

### 3. Storage Bucket

**Dashboard → Storage → New Bucket** → name: `product-images` → Public ON → Save.

### 4. Enable Realtime

**Dashboard → Database → Replication** → confirm `orders` table is toggled on.

### 5. Deploy

```bash
# Connect GitHub repo to Vercel for auto-deploy
# Or use CLI:
npm i -g vercel && vercel --prod
```

### 6. First Login

```
URL:      yoursite.vercel.app/login.html
Username: admin
Password: admin123
```

> ⚠️ Change the password immediately in Admin → Users.

---

## Database

### 11 Tables

| Table | Purpose |
|:------|:--------|
| `orders` | Order data — items (JSONB), totals, status, customer info, points |
| `products` | Menu items — prices, sizes, images, sold-out/hidden flags |
| `categories` | Menu category definitions with active/hidden toggle |
| `combos` | Bundle deals with included items |
| `admin_users` | Staff authentication and roles |
| `customers` | Phone-based profiles, loyalty points, order history |
| `restaurant_settings` | Key-value configuration store |
| `expenses` | Expense tracking with categories |
| `shifts` | Shift management with cash reconciliation |
| `special_offers` | Time-based discount rules |
| `printers` | Printer configurations (multi-printer) |

### Settings Keys

| Key | Default | Description |
|:----|:--------|:------------|
| `restaurant_open` | `true` | Toggle ordering on/off |
| `closed_message` | `We are currently closed...` | Shown on menu when closed |
| `tax_rate` | `0` | Tax percentage |
| `delivery_fee` | `0.500` | Delivery fee in KD |
| `min_order_delivery` | `1.500` | Minimum order for delivery |
| `loyalty_rate` | `10` | Points earned per 1 KD spent |
| `loyalty_redeem_rate` | `100` | Points needed for 1 KD discount |
| `restaurant_phone` | *(empty)* | WhatsApp number with country code |

---

## File Structure

```
fayruza/
├── index.html              Customer menu + cart + checkout
├── status.html             Order status tracker
├── history.html            Customer order history
├── admin.html              Admin panel (13 sections)
├── kds.html                Kitchen display system
├── login.html              Admin authentication
├── sw.js                   Service worker (customer)
├── admin-sw.js             Service worker (admin)
├── manifest.json           PWA manifest (customer)
├── admin-manifest.json     PWA manifest (admin)
├── icon-192.png            App icon 192×192
├── icon-512.png            App icon 512×512
├── vercel.json             Vercel config + security headers
├── fayruza-setup.sql       Database setup script
└── README.md
```

---

## Currency

All prices in **Kuwaiti Dinar (KD)** with 3 decimal places.

- Under 1 KD → displayed as fils (e.g. `750 Fils`)
- 1 KD and above → displayed as KD (e.g. `1.500 KD`)

---

## Notifications

| Channel | Setup |
|:--------|:------|
| **Browser Push** | Admin → 🔔 Notifications → grant permission. Fires on every new order. |
| **WhatsApp** | Admin → 💬 WhatsApp Alerts → enter phone + [CallMeBot](https://www.callmebot.com/blog/free-api-whatsapp-messages/) API key. |
| **Customer WhatsApp** | Admin → Settings → Restaurant WhatsApp No. Shows "Contact on WhatsApp" after ordering. |

---

## Security

- Passwords SHA-256 hashed client-side, never stored in plain text
- Admin sessions expire after 12 hours
- RLS enabled on all tables
- `X-Content-Type-Options: nosniff` and `X-Frame-Options: DENY` headers
- Service workers use `no-cache` for fresh updates

---

<p align="center">
  <strong>Built with ☕ and 🍔</strong><br>
  <em>Fayruza Restaurant · Jabriya · Block 12 · Jamia Branch</em>
</p>
