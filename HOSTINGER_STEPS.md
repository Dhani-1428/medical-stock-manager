# Step-by-Step Guide: What to Do on Hostinger VPS

## 🎯 Quick Action Plan for Hostinger VPS

Follow these steps in order to check and manage your application on Hostinger VPS.

---

## Step 1: Access Your Hostinger VPS

### Option A: Via SSH (Command Line)

1. **Open Terminal/PowerShell on your computer**

2. **Connect to your VPS:**
   ```bash
   ssh root@your-server-ip
   ```
   Replace `your-server-ip` with your actual Hostinger VPS IP address.

3. **Enter your password** when prompted

### Option B: Via Hostinger Control Panel

1. Log in to **Hostinger hPanel**
2. Go to **VPS** section
3. Click **"SSH Access"** or **"Terminal"**
4. You'll get a web-based terminal

---

## Step 2: Find Your Application Location

```bash
# Common locations where apps are deployed:
cd /var/www/html
# or
cd /var/www/your-app-name
# or
cd /home/username/your-app-name
# or
cd /root/your-app-name

# Search for your app
find / -name "package.json" -type f 2>/dev/null | grep -i medical
```

**Once you find it, navigate there:**
```bash
cd /path/to/your/app
```

---

## Step 3: Check if Application is Running

### Check Node.js Process
```bash
# See if Node.js is running
ps aux | grep node

# If you see output like:
# root 12345 ... node ... next start
# Then your app IS running ✅
```

### Check Port 3000
```bash
# Check if port 3000 is listening
netstat -tulpn | grep :3000
# or
ss -tulpn | grep :3000

# If you see output, port is in use ✅
```

### Check PM2 (Process Manager)
```bash
# Check PM2 status
pm2 list

# If PM2 is installed and app is running, you'll see:
# ┌─────┬─────────────┬─────────┬─────────┬──────────┐
# │ id  │ name        │ status  │ restart │ uptime   │
# ├─────┼─────────────┼─────────┼─────────┼──────────┤
# │ 0   │ your-app    │ online  │ 0       │ 2h       │
# └─────┴─────────────┴─────────┴─────────┴──────────┘
```

---

## Step 4: Test Application Locally

```bash
# Test health endpoint
curl http://localhost:3000/api/health

# Expected response:
# {"success":true,"data":{"status":"ok","db":"connected"},"message":"Healthy"}

# Test main page
curl http://localhost:3000

# Should return HTML content
```

---

## Step 5: Check MongoDB Connection

```bash
# Check if MongoDB is installed and running
systemctl status mongod
# or
systemctl status mongodb

# If not running, start it:
systemctl start mongod

# Test MongoDB connection
mongosh "mongodb://localhost:27017/erp-medical"
# or if using MongoDB Atlas:
mongosh "mongodb+srv://username:password@cluster.mongodb.net/erp-medical"

# If connection works, type: exit
```

---

## Step 6: Check Environment Variables

```bash
# Navigate to your app directory first
cd /path/to/your/app

# Check .env file exists
ls -la .env

# View MongoDB URI (be careful, don't expose password)
cat .env | grep MONGODB_URI

# Check if environment variables are loaded
printenv | grep MONGODB_URI
printenv | grep JWT_ACCESS_SECRET
```

---

## Step 7: Check Web Server (Nginx/Apache)

### If Using Nginx:
```bash
# Check Nginx status
systemctl status nginx

# View Nginx configuration
cat /etc/nginx/sites-available/default
# or
cat /etc/nginx/conf.d/your-app.conf

# Check Nginx error logs
tail -f /var/log/nginx/error.log
```

### If Using Apache:
```bash
# Check Apache status
systemctl status apache2
# or
systemctl status httpd

# View Apache configuration
cat /etc/apache2/sites-available/your-app.conf

# Check Apache error logs
tail -f /var/log/apache2/error.log
```

---

## Step 8: Check Application Logs

```bash
# If using PM2
pm2 logs
# Press Ctrl+C to exit

# Check specific app logs
pm2 logs your-app-name --lines 50

# If using systemd
journalctl -u your-app-name -f

# Check Next.js logs
tail -f .next/server.log
# or
tail -f logs/app.log
```

---

## Step 9: Restart Application (If Needed)

### If Using PM2:
```bash
# Restart all apps
pm2 restart all

# Restart specific app
pm2 restart your-app-name

# Restart and watch logs
pm2 restart your-app-name && pm2 logs
```

### If Using systemd:
```bash
# Restart service
systemctl restart your-app-name

# Check status
systemctl status your-app-name
```

### If Running Manually:
```bash
# Stop the app (find process ID first)
ps aux | grep node
kill -9 <PID>

# Start the app
cd /path/to/your/app
npm run start
# or for production
npm run build
npm run start
```

---

## Step 10: Verify External Access

### From Your Computer:

1. **Open browser**
2. **Go to:** `http://your-server-ip:3000` or `https://your-domain.com`
3. **Test login:**
   - Email: `admin@demo.com`
   - Password: `Admin@123`

### Test API Endpoint:
```bash
# From your computer (not VPS)
curl http://your-server-ip:3000/api/health
# or
curl https://your-domain.com/api/health
```

---

## 🔧 Common Fixes on Hostinger VPS

### Issue 1: Application Not Running

**Solution:**
```bash
# Navigate to app directory
cd /path/to/your/app

# Start with PM2
pm2 start npm --name "erp-medical" -- start
# or
pm2 start ecosystem.config.js

# Start manually
npm run start
```

### Issue 2: MongoDB Connection Error

**Solution:**
```bash
# Start MongoDB
systemctl start mongod

# Enable MongoDB to start on boot
systemctl enable mongod

# Check MongoDB is running
systemctl status mongod
```

### Issue 3: Port 3000 Not Accessible

**Solution:**
```bash
# Check firewall
ufw status

# Allow port 3000
ufw allow 3000/tcp

# Or configure Nginx reverse proxy (recommended)
```

### Issue 4: Environment Variables Not Set

**Solution:**
```bash
# Check .env file exists
ls -la .env

# If missing, create it
cp .env.example .env
nano .env

# Add your MongoDB URI and JWT secret
# Save: Ctrl+O, Enter, Ctrl+X
```

---

## 📋 Complete Health Check Script

Create this script on your VPS:

```bash
# Create check script
nano check-app.sh
```

Paste this content:
```bash
#!/bin/bash
echo "=========================================="
echo "ERP Medical - Application Health Check"
echo "=========================================="
echo ""

echo "1. Node.js Process:"
if ps aux | grep -q "[n]ode"; then
    echo "   ✅ Node.js is running"
    ps aux | grep "[n]ode" | grep -v grep | head -2
else
    echo "   ❌ Node.js is NOT running"
fi
echo ""

echo "2. Port 3000:"
if netstat -tulpn 2>/dev/null | grep -q ":3000"; then
    echo "   ✅ Port 3000 is listening"
    netstat -tulpn | grep ":3000"
else
    echo "   ❌ Port 3000 is NOT listening"
fi
echo ""

echo "3. MongoDB:"
if systemctl is-active --quiet mongod; then
    echo "   ✅ MongoDB is running"
else
    echo "   ❌ MongoDB is NOT running"
    echo "   Try: systemctl start mongod"
fi
echo ""

echo "4. Application Health:"
HEALTH=$(curl -s http://localhost:3000/api/health 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "   ✅ Application responds"
    echo "   Response: $HEALTH"
else
    echo "   ❌ Application does NOT respond"
fi
echo ""

echo "5. Environment Variables:"
if [ -f .env ]; then
    echo "   ✅ .env file exists"
    if grep -q "MONGODB_URI" .env; then
        echo "   ✅ MONGODB_URI is set"
    else
        echo "   ❌ MONGODB_URI is NOT set"
    fi
else
    echo "   ❌ .env file does NOT exist"
fi
echo ""

echo "6. Disk Space:"
df -h | grep -E "Filesystem|/dev/"
echo ""

echo "7. Memory:"
free -h
echo ""

echo "=========================================="
```

Make it executable and run:
```bash
chmod +x check-app.sh
./check-app.sh
```

---

## 🚀 Quick Start Commands (Copy & Paste)

Run these commands one by one on your Hostinger VPS:

```bash
# 1. Find your application
find / -name "package.json" -type f 2>/dev/null | head -5

# 2. Navigate to app (replace with actual path)
cd /var/www/html  # or wherever your app is

# 3. Check if running
ps aux | grep node

# 4. Check MongoDB
systemctl status mongod

# 5. Test application
curl http://localhost:3000/api/health

# 6. Check logs
pm2 logs  # if using PM2
# or
tail -f logs/app.log  # if using file logs
```

---

## ✅ Verification Checklist

Run through this checklist:

- [ ] Can SSH into VPS
- [ ] Found application directory
- [ ] Node.js process is running
- [ ] Port 3000 is listening
- [ ] MongoDB is running
- [ ] .env file exists with MONGODB_URI
- [ ] Application responds to health check
- [ ] Can access from browser
- [ ] Can login successfully

---

## 🆘 If Something Doesn't Work

### Application Not Found?
```bash
# Search for it
find / -name "package.json" 2>/dev/null
find / -name "next.config.mjs" 2>/dev/null
```

### Can't Access from Browser?
```bash
# Check firewall
ufw status
ufw allow 3000/tcp

# Check Nginx/Apache config
cat /etc/nginx/sites-available/default
```

### Need to Restart Everything?
```bash
# Restart MongoDB
systemctl restart mongod

# Restart application
pm2 restart all
# or
systemctl restart your-app-name

# Restart web server
systemctl restart nginx
# or
systemctl restart apache2
```

---

## 📞 Next Steps After Verification

1. **If everything works:** ✅ Your app is live!
2. **If app not running:** Start it with PM2 or systemd
3. **If MongoDB error:** Check connection string in .env
4. **If can't access:** Check firewall and web server config

---

## 💡 Pro Tips

- **Use PM2** for process management: `npm install -g pm2`
- **Set up Nginx reverse proxy** for better security
- **Enable auto-start:** `pm2 startup` and `pm2 save`
- **Monitor logs:** `pm2 logs --lines 100`
- **Set up SSL:** Use Let's Encrypt for HTTPS

Your application should be accessible once you verify these steps! 🎉
