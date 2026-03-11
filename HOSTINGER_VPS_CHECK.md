# Hostinger VPS Deployment Check Guide

## 🔍 How to Check Your Application on Hostinger VPS

### Step 1: SSH into Your VPS Server

```bash
# Connect to your Hostinger VPS
ssh root@your-server-ip
# or
ssh username@your-server-ip

# Enter your password when prompted
```

### Step 2: Check if Application is Running

#### Check Node.js Process
```bash
# Check if Node.js/Next.js process is running
ps aux | grep node
# or
ps aux | grep next

# Check specific port (usually 3000 for Next.js)
netstat -tulpn | grep :3000
# or
ss -tulpn | grep :3000
```

#### Check PM2 (if using process manager)
```bash
# Check PM2 status
pm2 list

# Check PM2 logs
pm2 logs

# Check specific app logs
pm2 logs your-app-name
```

#### Check Systemd Service (if running as service)
```bash
# Check service status
systemctl status your-app-name
# or
systemctl status nodejs-app

# View service logs
journalctl -u your-app-name -f
```

### Step 3: Check Application Directory

```bash
# Navigate to your application directory
cd /var/www/your-app-name
# or
cd /home/username/your-app-name
# or wherever you deployed it

# Check if files exist
ls -la

# Check package.json
cat package.json

# Check .env file (if accessible)
cat .env | grep MONGODB_URI
```

### Step 4: Check MongoDB Connection

```bash
# Test MongoDB connection
mongosh "mongodb://localhost:27017/erp-medical"
# or if using MongoDB Atlas
mongosh "mongodb+srv://username:password@cluster.mongodb.net/erp-medical"

# Check MongoDB service status
systemctl status mongod
# or
systemctl status mongodb

# Check MongoDB port
netstat -tulpn | grep :27017
```

### Step 5: Check Nginx/Apache Configuration

#### If using Nginx:
```bash
# Check Nginx status
systemctl status nginx

# Check Nginx config
cat /etc/nginx/sites-available/your-app-name
# or
cat /etc/nginx/conf.d/your-app-name.conf

# Test Nginx config
nginx -t

# Check Nginx error logs
tail -f /var/log/nginx/error.log
```

#### If using Apache:
```bash
# Check Apache status
systemctl status apache2
# or
systemctl status httpd

# Check Apache config
cat /etc/apache2/sites-available/your-app-name.conf

# Check Apache error logs
tail -f /var/log/apache2/error.log
```

### Step 6: Check Application Logs

```bash
# Check Next.js build logs
cat .next/build.log

# Check application logs (if using custom logging)
tail -f logs/app.log

# Check PM2 logs
pm2 logs --lines 100

# Check system logs
journalctl -xe | grep -i error
```

### Step 7: Test Application Endpoints

#### From Server (Local Test)
```bash
# Test health endpoint
curl http://localhost:3000/api/health

# Test if app responds
curl http://localhost:3000

# Check response headers
curl -I http://localhost:3000
```

#### From Your Computer (External Test)
```bash
# Replace with your actual domain/IP
curl https://your-domain.com/api/health
curl https://your-domain.com

# Test with verbose output
curl -v https://your-domain.com
```

### Step 8: Check Firewall and Ports

```bash
# Check firewall status (UFW)
ufw status

# Check firewall status (firewalld)
firewall-cmd --list-all

# Check open ports
netstat -tulpn
# or
ss -tulpn

# Check if port 3000 is open
lsof -i :3000
```

### Step 9: Check Domain/DNS Configuration

```bash
# Check DNS records (from your computer)
nslookup your-domain.com
# or
dig your-domain.com

# Check if domain points to your server IP
host your-domain.com
```

### Step 10: Verify Environment Variables

```bash
# Check environment variables (if using systemd)
systemctl show-environment

# Check .env file
cat .env

# Check if environment variables are loaded
printenv | grep MONGODB_URI
printenv | grep JWT_ACCESS_SECRET
```

---

## 🛠️ Common Commands for Hostinger VPS

### Restart Application

```bash
# If using PM2
pm2 restart all
# or
pm2 restart your-app-name

# If using systemd
systemctl restart your-app-name

# If running manually
# Kill process and restart
pkill -f "next dev"
# or
pkill -f "node"
# Then start again
npm run start
# or
npm run dev
```

### Check Disk Space

```bash
# Check disk usage
df -h

# Check directory sizes
du -sh /var/www/*
```

### Check Memory Usage

```bash
# Check memory
free -h

# Check top processes
top
# or
htop
```

### Check Application Status Script

Create a check script:

```bash
#!/bin/bash
# save as check-app.sh

echo "=== Application Status Check ==="
echo ""

echo "1. Node.js Process:"
ps aux | grep node | grep -v grep
echo ""

echo "2. Port 3000:"
netstat -tulpn | grep :3000
echo ""

echo "3. MongoDB:"
systemctl status mongod --no-pager | head -5
echo ""

echo "4. Nginx:"
systemctl status nginx --no-pager | head -5
echo ""

echo "5. Application Health:"
curl -s http://localhost:3000/api/health || echo "Health check failed"
echo ""

echo "6. Disk Space:"
df -h | grep -E "Filesystem|/dev/"
echo ""

echo "7. Memory:"
free -h
```

Make it executable:
```bash
chmod +x check-app.sh
./check-app.sh
```

---

## 🔧 Troubleshooting Common Issues

### Application Not Running

```bash
# Check what's listening on port 3000
lsof -i :3000

# Kill process on port 3000
kill -9 $(lsof -t -i:3000)

# Restart application
cd /path/to/your/app
npm run start
```

### MongoDB Connection Failed

```bash
# Check MongoDB is running
systemctl status mongod

# Start MongoDB
systemctl start mongod

# Check MongoDB logs
tail -f /var/log/mongodb/mongod.log

# Test MongoDB connection
mongosh "mongodb://localhost:27017/erp-medical"
```

### Port Already in Use

```bash
# Find process using port
lsof -i :3000
# or
netstat -tulpn | grep :3000

# Kill the process
kill -9 <PID>
```

### Permission Issues

```bash
# Check file permissions
ls -la

# Fix ownership
chown -R username:username /path/to/your/app

# Fix permissions
chmod -R 755 /path/to/your/app
```

### Application Crashes

```bash
# Check PM2 logs
pm2 logs --err

# Check system logs
journalctl -xe

# Check application logs
tail -f logs/error.log
```

---

## 📋 Quick Health Check Checklist

Run these commands to verify everything:

```bash
# 1. Application running?
ps aux | grep node | grep -v grep

# 2. Port accessible?
curl http://localhost:3000/api/health

# 3. MongoDB running?
systemctl status mongod

# 4. Nginx/Apache running?
systemctl status nginx  # or apache2

# 5. Domain accessible?
curl https://your-domain.com

# 6. Environment variables set?
printenv | grep MONGODB_URI

# 7. Disk space OK?
df -h

# 8. Memory OK?
free -h
```

---

## 🌐 Access Your Application

### Local Access (from server)
- http://localhost:3000
- http://127.0.0.1:3000

### External Access
- https://your-domain.com (if domain configured)
- http://your-server-ip:3000 (if port is open)

### Check from Browser
1. Open browser
2. Go to: `https://your-domain.com` or `http://your-server-ip:3000`
3. Try login: admin@demo.com / Admin@123

---

## 📞 Need Help?

If something isn't working:

1. **Check logs first:**
   ```bash
   pm2 logs
   # or
   journalctl -xe
   ```

2. **Verify environment:**
   ```bash
   cat .env
   printenv
   ```

3. **Test connectivity:**
   ```bash
   curl http://localhost:3000/api/health
   ```

4. **Check services:**
   ```bash
   systemctl status mongod
   systemctl status nginx
   ```

---

## 🔐 Security Checklist

- [ ] Firewall configured (only necessary ports open)
- [ ] SSH key authentication enabled
- [ ] Environment variables not exposed
- [ ] MongoDB not exposed to public IP
- [ ] SSL certificate installed (HTTPS)
- [ ] Regular backups configured
- [ ] Strong passwords set

---

## 📝 Next Steps

1. **SSH into your VPS**
2. **Run health check commands above**
3. **Verify application is accessible**
4. **Check logs if issues found**
5. **Test login functionality**

Your application should be accessible at your Hostinger VPS domain or IP address!
