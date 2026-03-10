# Quick Start Guide - ERP Medical

## 🚀 Get Started in 5 Minutes

### Step 1: Install Dependencies

```powershell
npm install
# or
pnpm install
```

### Step 2: Set Up MongoDB

**You have 3 options. Choose the easiest for you:**

#### Option A: MongoDB Atlas (Cloud - Easiest, Recommended) ⭐

1. **Sign up for free MongoDB Atlas account:**
   - Go to: https://www.mongodb.com/cloud/atlas/register
   - Click "Try Free" and create account

2. **Create a free cluster:**
   - Click "Build a Database"
   - Choose **M0 FREE** tier
   - Select a region close to you
   - Click "Create"

3. **Create database user:**
   - Go to "Database Access" → "Add New Database User"
   - Username: `erpadmin` (or any you prefer)
   - Password: Create a strong password (save it!)
   - Privileges: "Atlas admin"
   - Click "Add User"

4. **Whitelist IP:**
   - Go to "Network Access" → "Add IP Address"
   - Click "Add Current IP Address" (for development)
   - Or click "Allow Access from Anywhere" (0.0.0.0/0) for testing
   - Click "Confirm"

5. **Get connection string:**
   - Go to "Database" → Click "Connect" on your cluster
   - Choose "Connect your application"
   - Copy the connection string
   - Replace `<password>` with your actual password
   - Add database name: Replace `/?retryWrites=true&w=majority` with `/erp-medical?retryWrites=true&w=majority`
   
   Example:
   ```
   mongodb+srv://erpadmin:YourPassword123@cluster0.xxxxx.mongodb.net/erp-medical?retryWrites=true&w=majority
   ```

6. **Update .env file:**
   ```env
   MONGODB_URI=mongodb+srv://erpadmin:YourPassword123@cluster0.xxxxx.mongodb.net/erp-medical?retryWrites=true&w=majority
   JWT_ACCESS_SECRET=your-super-secret-jwt-key-change-this-in-production-min-32-chars
   ```

#### Option B: Install MongoDB Locally

Run the setup script:
```powershell
.\setup-mongodb.ps1
```

Or manually:
1. Download from: https://www.mongodb.com/try/download/community
2. Install MongoDB Community Server
3. Install as Windows Service
4. Start service: `net start MongoDB`

Your `.env` should have:
```env
MONGODB_URI=mongodb://localhost:27017/erp-medical
```

#### Option C: Use Docker

If you have Docker Desktop:
```powershell
docker run -d -p 27017:27017 --name mongodb mongo:latest
```

### Step 3: Seed Database

```powershell
npm run seed
```

This creates demo users:
- **Admin:** admin@demo.com / Admin@123
- **Retailer:** user@demo.com / User@123
- **Distributor:** distributor@demo.com / Distributor@123
- **Customer:** customer@demo.com / Customer@123

### Step 4: Start Development Server

```powershell
npm run dev
```

### Step 5: Login

1. Open: http://localhost:3000
2. Click "Admin login"
3. Use: admin@demo.com / Admin@123

---

## ✅ Verification Checklist

- [ ] Dependencies installed (`npm install`)
- [ ] MongoDB running (Atlas, local, or Docker)
- [ ] `.env` file has `MONGODB_URI` and `JWT_ACCESS_SECRET`
- [ ] Database seeded (`npm run seed`)
- [ ] Dev server running (`npm run dev`)
- [ ] Can login at http://localhost:3000

---

## 🆘 Troubleshooting

### "MONGODB_URI is required" error
- Check `.env` file exists in project root
- Verify `MONGODB_URI` is set correctly
- Restart dev server after changing `.env`

### "ECONNREFUSED" error
- MongoDB is not running
- Check MongoDB service: `Get-Service MongoDB`
- Start MongoDB: `net start MongoDB`
- Or use MongoDB Atlas (cloud)

### "Cannot connect to MongoDB" error
- Verify connection string is correct
- Check MongoDB is accessible
- For Atlas: Verify IP is whitelisted
- Restart dev server

### Login fails
- Make sure you ran `npm run seed` first
- Check credentials match demo users
- Verify MongoDB connection is working

---

## 📚 Next Steps

- Read `MANUAL_DEMO_GUIDE.md` for feature walkthrough
- Check `MANUAL_TEST_CASES.md` for testing scenarios
- Review `FEATURE_REPORT.md` for complete feature list
