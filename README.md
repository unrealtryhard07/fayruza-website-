# Fayruza Restaurant

Official menu & ordering system for Fayruza Restaurant, Jabriya, Kuwait.

## Pages

| Page | URL | Description |
|------|-----|-------------|
| **Menu** | `/index.html` | Customer-facing menu with cart, checkout, and ordering |
| **Order Status** | `/status.html` | Live order tracking by order ID |
| **Order History** | `/history.html` | Customer order history lookup by phone number |
| **Admin Panel** | `/admin.html` | Full back-office: orders, products, reports, settings |
| **Kitchen Display** | `/kds.html` | KDS screen for kitchen staff |
| **Login** | `/login.html` | Admin authentication |

## Features

- Real-time orders via Supabase Realtime
- PWA — installable on mobile with offline support
- Multi-language — English / Arabic toggle
- Loyalty points — earn & redeem at checkout
- Combos & Special Offers — time-based, scoped discounts
- Receipt Printing — thermal printer support (Network/Bluetooth/USB) + PDF with QR code
- Product Image Upload — drag & drop to Supabase Storage
- Expense Tracking — monthly P&L with category breakdowns
- Shift Management — open/close shifts with cash reconciliation
- Table QR Codes — auto-generated per table
- WhatsApp Alerts — new order notifications
- Push Notifications — browser notifications for staff

## Deploy

Deployed via Vercel. Push to main branch to auto-deploy.

## Supabase Storage Setup (for product image upload)

Create a bucket called `product-images` in Supabase Dashboard → Storage:
1. Click "New Bucket"
2. Name: `product-images`
3. Toggle **Public bucket** ON
4. Save

Then add RLS policies to allow uploads and reads.
