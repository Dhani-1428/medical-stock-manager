# Deploy to Hostinger VPS - srv1266361.hstgr.cloud

## 🚀 Quick Deployment Guide

### Prerequisites
- SSH access to Hostinger VPS
- Git installed on server
- Node.js 18+ installed on server
- MongoDB running (local or Atlas)

---

## Method 1: Deploy via Git (Recommended)

### Step 1: SSH into Hostinger VPS

```bash
ssh root@srv1266361.hstgr.cloud
# Enter your password
```

### Step 2: Navigate to Web Directory

```bash
cd /var/www/html
# or create dedicated directory
mkdir -p /var/www/erp-medical
cd /var/www/erp-medical
```

### Step 3: Clone Repository (First Time)

```bash
# Clone your repository
git clone https://github.com/Dhani-1428/medical-stock-manager.git .

# Or if already cloned, pull latest
git pull origin main
```

### Step 4: Install Dependencies

```bash
# Install dependencies
npm install
# or
pnpm install
```

### Step 5: Create .env File

```bash
# Create .env file
nano .env
```

Add these variables:
```env
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/erp-medical?retryWrites=true&w=majority
JWT_ACCESS_SECRET=your-super-secret-jwt-key-min-32-chars-change-in-production
CLIENT_ORIGIN=http://srv1266361.hstgr.cloud:3000
PUBLIC_APP_URL=http://srv1266361.hstgr.cloud:3000
NODE_ENV=production
```

Save: `Ctrl+O`, `Enter`, `Ctrl+X`

### Step 6: Build Application

```bash
# Build for production
npm run build
```

### Step 7: Start Application

#### Option A: Using PM2 (Recommended)

```bash
# Install PM2 globally
npm install -g pm2

# Start application
pm2 start npm --name "erp-medical" -- start

# Save PM2 configuration
pm2 save

# Setup PM2 to start on boot
pm2 startup
# Follow the instructions it shows
```

#### Option B: Using systemd

```bash
# Create service file
sudo nano /etc/systemd/system/erp-medical.service
```

Add this content:
```ini
[Unit]
Description=ERP Medical Next.js App
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/var/www/erp-medical
Environment=NODE_ENV=production
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Then:
```bash
# Enable and start service
systemctl daemon-reload
systemctl enable erp-medical
systemctl start erp-medical

# Check status
systemctl status erp-medical
```

### Step 8: Configure Nginx Reverse Proxy

```bash
# Create Nginx config
sudo nano /etc/nginx/sites-available/erp-medical
```

Add this configuration:
```nginx
server {
    listen 80;
    server_name srv1266361.hstgr.cloud;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Enable the site:
```bash
# Create symlink
sudo ln -s /etc/nginx/sites-available/erp-medical /etc/nginx/sites-enabled/

# Test Nginx config
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
```

### Step 9: Seed Database (First Time)

```bash
# Seed demo data
npm run seed
```

### Step 10: Verify Deployment

```bash
# Check application is running
curl http://localhost:3000/api/health

# Check PM2 status
pm2 list
pm2 logs erp-medical
```

---

## Method 2: Deploy Using Script

### From Your Local Computer:

```bash
# Make script executable
chmod +x deploy-hostinger.sh

# Run deployment script
./deploy-hostinger.sh
```

The script will:
1. Build the application locally
2. Create deployment package
3. Upload to server
4. Extract and install on server
5. Restart application

---

## Method 3: Manual File Upload

### Step 1: Build Locally

```bash
npm run build
```

### Step 2: Upload Files via SFTP

Use FileZilla, WinSCP, or similar:
- Host: `srv1266361.hstgr.cloud`
- Username: `root`
- Port: `22`
- Upload all files except:
  - `node_modules/`
  - `.git/`
  - `.next/` (will be rebuilt)
  - `.env` (create on server)

### Step 3: On Server

```bash
cd /var/www/erp-medical
npm install --production
npm run build
pm2 start npm --name "erp-medical" -- start
```

---

## 🔧 Post-Deployment Configuration

### 1. Set Up MongoDB

#### If Using MongoDB Atlas:
- Already configured in `.env`
- Make sure IP whitelist includes your server IP

#### If Installing MongoDB Locally:
```bash
# Install MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org

# Start MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod
```

### 2. Configure Firewall

```bash
# Allow ports
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw allow 3000/tcp  # Next.js (if direct access needed)

# Enable firewall
sudo ufw enable
```

### 3. Set Up SSL Certificate (Let's Encrypt)

```bash
# Install Certbot
sudo apt-get update
sudo apt-get install certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d srv1266361.hstgr.cloud

# Auto-renewal is set up automatically
```

### 4. Configure Domain (If Using Custom Domain)

1. Go to your domain registrar
2. Add A record pointing to your server IP
3. Wait for DNS propagation (5-30 minutes)

---

## 📋 Quick Commands Reference

### Check Application Status
```bash
# PM2
pm2 list
pm2 logs erp-medical
pm2 restart erp-medical

# systemd
systemctl status erp-medical
journalctl -u erp-medical -f
```

### Update Application
```bash
cd /var/www/erp-medical
git pull origin main
npm install
npm run build
pm2 restart erp-medical
```

### View Logs
```bash
# Application logs
pm2 logs erp-medical

# Nginx logs
tail -f /var/log/nginx/error.log
tail -f /var/log/nginx/access.log

# System logs
journalctl -xe
```

### Restart Services
```bash
# Restart application
pm2 restart erp-medical

# Restart Nginx
systemctl restart nginx

# Restart MongoDB
systemctl restart mongod
```

---

## ✅ Verification Checklist

After deployment, verify:

- [ ] Application builds successfully
- [ ] PM2/systemd service is running
- [ ] Port 3000 is listening
- [ ] MongoDB connection works
- [ ] Health endpoint responds: `curl http://localhost:3000/api/health`
- [ ] Can access via browser: `http://srv1266361.hstgr.cloud`
- [ ] Can login with admin@demo.com / Admin@123
- [ ] Nginx reverse proxy configured (if using)
- [ ] SSL certificate installed (if using HTTPS)
- [ ] Firewall configured correctly

---

## 🆘 Troubleshooting

### Application Not Starting
```bash
# Check logs
pm2 logs erp-medical --lines 100

# Check if port is in use
netstat -tulpn | grep :3000

# Check environment variables
cat .env
```

### MongoDB Connection Error
```bash
# Check MongoDB status
systemctl status mongod

# Test connection
mongosh "mongodb://localhost:27017/erp-medical"
```

### Can't Access from Browser
```bash
# Check firewall
ufw status

# Check Nginx
systemctl status nginx
nginx -t

# Check application is running
pm2 list
```

### Build Errors
```bash
# Clear cache and rebuild
rm -rf .next node_modules
npm install
npm run build
```

---

## 🌐 Access Your Application

After deployment, your application will be accessible at:

- **Direct:** http://srv1266361.hstgr.cloud:3000
- **Via Nginx:** http://srv1266361.hstgr.cloud (port 80)
- **Via HTTPS:** https://srv1266361.hstgr.cloud (after SSL setup)

**Demo Login:**
- Email: admin@demo.com
- Password: Admin@123

---

## 📝 Environment Variables for Production

Make sure your `.env` file on the server has:

```env
# Database
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/erp-medical?retryWrites=true&w=majority

# JWT
JWT_ACCESS_SECRET=your-super-secret-jwt-key-min-32-chars-change-in-production

# URLs
CLIENT_ORIGIN=http://srv1266361.hstgr.cloud:3000
PUBLIC_APP_URL=http://srv1266361.hstgr.cloud:3000

# Environment
NODE_ENV=production

# Optional: Payment & Shipping
RAZORPAY_KEY_ID=your-razorpay-key
RAZORPAY_KEY_SECRET=your-razorpay-secret
SHIPROCKET_EMAIL=your-email
SHIPROCKET_PASSWORD=your-password
```

---

## 🎯 Next Steps

1. **Deploy using Method 1 (Git)** - Easiest and recommended
2. **Configure Nginx** - For better performance and security
3. **Set up SSL** - For HTTPS access
4. **Monitor logs** - Use `pm2 logs` to watch for errors
5. **Set up backups** - Regular MongoDB backups

Your application will be live at: **http://srv1266361.hstgr.cloud** 🚀
