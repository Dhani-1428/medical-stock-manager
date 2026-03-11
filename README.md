# medical-stock-manager

## 🚀 Quick Start

**Having MongoDB connection issues?** See [QUICK_START.md](./QUICK_START.md) for setup instructions.

### Prerequisites
- Node.js 18+ installed
- MongoDB (local, Atlas, or Docker)
- npm or pnpm

### Setup Steps

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Set up MongoDB:**
   - **Easiest:** Use MongoDB Atlas (cloud) - See [SETUP_MONGODB_ATLAS.md](./SETUP_MONGODB_ATLAS.md)
   - **Local:** Install MongoDB or use Docker - See [MONGODB_SETUP.md](./MONGODB_SETUP.md)
   - Run setup script: `.\setup-mongodb.ps1`

3. **Configure environment:**
   - Copy `.env.example` to `.env`
   - Set `MONGODB_URI` (see setup guides above)
   - Set `JWT_ACCESS_SECRET` (any long random string)

4. **Seed database:**
   ```bash
   npm run seed
   ```
   Creates demo users:
   - Admin: admin@demo.com / Admin@123
   - Retailer: user@demo.com / User@123
   - Distributor: distributor@demo.com / Distributor@123
   - Customer: customer@demo.com / Customer@123

5. **Start development server:**
   ```bash
   npm run dev
   ```

6. **Open application:**
   - Visit: http://localhost:3000
   - Login with demo credentials above

---

## 📚 Documentation

- **[QUICK_START.md](./QUICK_START.md)** - Get started in 5 minutes
- **[DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)** - Deploy to production (Vercel) ⭐
- **[SETUP_MONGODB_ATLAS.md](./SETUP_MONGODB_ATLAS.md)** - MongoDB Atlas cloud setup (recommended)
- **[MONGODB_SETUP.md](./MONGODB_SETUP.md)** - All MongoDB setup options
- **[MANUAL_DEMO_GUIDE.md](./MANUAL_DEMO_GUIDE.md)** - Feature walkthrough
- **[FEATURE_REPORT.md](./FEATURE_REPORT.md)** - Complete feature list

---

## 🆘 Troubleshooting

### MongoDB Connection Error
- **Error:** `ECONNREFUSED` or `MONGODB_URI is required`
- **Solution:** See [QUICK_START.md](./QUICK_START.md) or [SETUP_MONGODB_ATLAS.md](./SETUP_MONGODB_ATLAS.md)

### Login Fails
- Make sure you ran `npm run seed` first
- Check MongoDB is running and accessible
- Verify `.env` file has correct `MONGODB_URI`

### Build Errors
- Clear `.next` folder: `Remove-Item -Recurse -Force .next`
- Reinstall dependencies: `npm install`
- Check Node.js version: `node --version` (should be 18+)

---

## 🏗️ Project Structure

```
erp-medical-main/
├── app/                    # Next.js App Router pages
│   ├── api/               # API routes
│   ├── admin/             # Admin dashboard
│   ├── retailer/          # Retailer portal
│   ├── distributor/       # Distributor portal
│   └── customer/          # Customer portal
├── server/                 # Server-side logic
├── components/             # React components
├── .env                    # Environment variables (create from .env.example)
└── package.json           # Dependencies
```

---

## 📝 License

Private project - All rights reserved
