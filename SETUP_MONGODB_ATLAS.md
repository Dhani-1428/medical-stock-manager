# MongoDB Atlas Setup - Step by Step

## Why MongoDB Atlas?

- ✅ **Free tier available** (M0 - 512MB storage)
- ✅ **No installation needed** - runs in the cloud
- ✅ **Easy setup** - 5 minutes
- ✅ **Works everywhere** - no local MongoDB required
- ✅ **Production ready** - same service used by many companies

---

## Step-by-Step Setup

### Step 1: Create Account (2 minutes)

1. Go to: **https://www.mongodb.com/cloud/atlas/register**
2. Click **"Try Free"** button
3. Fill in:
   - Email address
   - Password (strong password)
   - First name, Last name
   - Company (optional)
4. Click **"Get started free"**
5. Verify your email if prompted

### Step 2: Create Free Cluster (1 minute)

1. After login, click **"Build a Database"**
2. Choose **"M0 FREE"** (Free Shared tier)
3. Select **Cloud Provider**: AWS (or any)
4. Select **Region**: Choose closest to you (e.g., `N. Virginia (us-east-1)`)
5. Click **"Create"**
6. Wait 1-2 minutes for cluster to be created

### Step 3: Create Database User (1 minute)

1. In the setup wizard, you'll see "Create Database User"
2. **Username**: `erpadmin` (or any name you prefer)
3. **Password**: Click "Autogenerate Secure Password" or create your own
   - **IMPORTANT**: Copy and save this password!
4. Click **"Create Database User"**

### Step 4: Whitelist IP Address (30 seconds)

1. In setup wizard, you'll see "Where would you like to connect from?"
2. Click **"Add My Current IP Address"** (for development)
3. OR click **"Allow Access from Anywhere"** (0.0.0.0/0) - less secure but easier for testing
4. Click **"Finish and Close"**

### Step 5: Get Connection String (1 minute)

1. Click **"Connect"** button on your cluster
2. Choose **"Connect your application"**
3. Select **Driver**: Node.js
4. Select **Version**: 5.5 or later
5. Copy the connection string (looks like):
   ```
   mongodb+srv://erpadmin:<password>@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
   ```

### Step 6: Update Your .env File

1. Open your `.env` file in the project root
2. Replace `<password>` in the connection string with your actual password
3. Add database name `/erp-medical` before the `?`:

**Example:**
```env
MONGODB_URI=mongodb+srv://erpadmin:YourActualPassword123@cluster0.xxxxx.mongodb.net/erp-medical?retryWrites=true&w=majority
JWT_ACCESS_SECRET=your-super-secret-jwt-key-change-this-in-production-min-32-chars
```

**Important:**
- Replace `YourActualPassword123` with your real password
- Replace `cluster0.xxxxx` with your actual cluster address
- Keep `/erp-medical` - this is your database name

### Step 7: Test Connection

1. Save your `.env` file
2. Restart your dev server:
   ```powershell
   # Stop current server (Ctrl+C)
   npm run dev
   ```
3. Try logging in - it should work now!

---

## Visual Guide

```
MongoDB Atlas Dashboard
├── Clusters
│   └── [Your Cluster] → Click "Connect"
│       ├── Connect your application
│       ├── Copy connection string
│       └── Replace <password> and add /erp-medical
│
├── Database Access
│   └── Users → Your database user
│
└── Network Access
    └── IP Access List → Your whitelisted IPs
```

---

## Common Issues

### "Authentication failed"
- Check password is correct (no extra spaces)
- Verify username matches what you created
- Try regenerating password in Database Access

### "IP not whitelisted"
- Go to Network Access → Add IP Address
- Add your current IP or 0.0.0.0/0

### "Connection timeout"
- Check internet connection
- Verify cluster is running (should show green status)
- Try different region if issues persist

### "Database name error"
- Make sure connection string includes `/erp-medical`
- Format: `mongodb+srv://.../erp-medical?retryWrites=true&w=majority`

---

## Security Best Practices

1. **Don't commit .env to git** (already in .gitignore ✅)
2. **Use strong passwords** for database user
3. **Limit IP access** - only whitelist IPs you need
4. **Rotate passwords** periodically
5. **Use environment variables** in production (Vercel, etc.)

---

## Next Steps

After MongoDB Atlas is set up:

1. ✅ Update `.env` with connection string
2. ✅ Run `npm run seed` to create demo users
3. ✅ Run `npm run dev` to start server
4. ✅ Login at http://localhost:3000

**Demo Credentials:**
- Admin: admin@demo.com / Admin@123
- Retailer: user@demo.com / User@123

---

## Need Help?

- MongoDB Atlas Docs: https://docs.atlas.mongodb.com/
- Support: Check `MONGODB_SETUP.md` for more options
- Quick Start: See `QUICK_START.md`
