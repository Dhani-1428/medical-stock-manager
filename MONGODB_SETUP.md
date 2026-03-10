# MongoDB Setup Guide

## Error: `connect ECONNREFUSED ::1:27017, connect ECONNREFUSED 127.0.0.1:27017`

This error means MongoDB is not running or not accessible. Here are solutions:

## Option 1: Install and Run MongoDB Locally (Windows)

### Step 1: Install MongoDB

1. Download MongoDB Community Server from: https://www.mongodb.com/try/download/community
2. Run the installer and follow the setup wizard
3. Choose "Complete" installation
4. Install MongoDB as a Windows Service (recommended)

### Step 2: Start MongoDB Service

**Option A: Using Windows Services**
1. Press `Win + R`, type `services.msc`, press Enter
2. Find "MongoDB" service
3. Right-click → Start (if not running)

**Option B: Using Command Line**
```powershell
# Start MongoDB service
net start MongoDB

# Check if MongoDB is running
Get-Service MongoDB
```

**Option C: Manual Start**
```powershell
# Navigate to MongoDB bin directory (usually C:\Program Files\MongoDB\Server\7.0\bin)
cd "C:\Program Files\MongoDB\Server\7.0\bin"

# Start MongoDB
.\mongod.exe --dbpath="C:\data\db"
```

### Step 3: Verify MongoDB is Running

```powershell
# Test connection
mongosh
# or
mongo
```

If you see MongoDB shell, it's working!

### Step 4: Update .env File

Your `.env` file should have:
```
MONGODB_URI=mongodb://localhost:27017/erp-medical
```

---

## Option 2: Use MongoDB Atlas (Cloud - Recommended for Production)

### Step 1: Create MongoDB Atlas Account

1. Go to https://www.mongodb.com/cloud/atlas/register
2. Sign up for a free account (M0 Free Tier available)

### Step 2: Create a Cluster

1. Click "Build a Database"
2. Choose "M0 FREE" tier
3. Select a cloud provider and region (choose closest to you)
4. Click "Create"

### Step 3: Create Database User

1. Go to "Database Access" → "Add New Database User"
2. Choose "Password" authentication
3. Create username and password (save these!)
4. Set privileges to "Atlas admin" or "Read and write to any database"
5. Click "Add User"

### Step 4: Whitelist Your IP

1. Go to "Network Access" → "Add IP Address"
2. Click "Add Current IP Address" (for development)
3. Or add `0.0.0.0/0` to allow all IPs (less secure, but easier for testing)
4. Click "Confirm"

### Step 5: Get Connection String

1. Go to "Database" → Click "Connect" on your cluster
2. Choose "Connect your application"
3. Copy the connection string (looks like: `mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority`)
4. Replace `<password>` with your actual password
5. Add database name: `mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/erp-medical?retryWrites=true&w=majority`

### Step 6: Update .env File

Replace `MONGODB_URI` in your `.env` file:
```
MONGODB_URI=mongodb+srv://your-username:your-password@cluster0.xxxxx.mongodb.net/erp-medical?retryWrites=true&w=majority
```

---

## Option 3: Use Docker (Alternative)

If you have Docker installed:

```powershell
# Run MongoDB in Docker
docker run -d -p 27017:27017 --name mongodb mongo:latest

# Verify it's running
docker ps
```

Then use in `.env`:
```
MONGODB_URI=mongodb://localhost:27017/erp-medical
```

---

## Verify Setup

After setting up MongoDB, restart your Next.js dev server:

```powershell
# Stop current server (Ctrl+C)
# Then restart
npm run dev
```

Try logging in again. The error should be resolved!

---

## Troubleshooting

### MongoDB Service Won't Start

1. Check if port 27017 is already in use:
   ```powershell
   netstat -ano | findstr :27017
   ```

2. Check MongoDB logs:
   - Windows: `C:\Program Files\MongoDB\Server\7.0\log\mongod.log`
   - Or check Event Viewer → Windows Logs → Application

### Connection String Issues

- Make sure there are no spaces in the connection string
- Escape special characters in password (use `%` encoding)
- For Atlas: Ensure IP is whitelisted

### Still Having Issues?

1. Check MongoDB is listening:
   ```powershell
   netstat -an | findstr 27017
   ```

2. Test connection manually:
   ```powershell
   mongosh "mongodb://localhost:27017/erp-medical"
   ```

3. Check your `.env` file is in the correct location (root of project)

4. Restart your dev server after changing `.env`
