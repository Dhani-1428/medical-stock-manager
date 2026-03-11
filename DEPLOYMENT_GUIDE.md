# Deployment Guide - Where to Host Your Application

## 🌐 Where Your Application Needs to Be Live

Your application has **two main components** that need to be hosted:

1. **Next.js Frontend + API** → Deploy to **Vercel** (recommended) or other hosting
2. **MongoDB Database** → Use **MongoDB Atlas** (cloud - already configured)

---

## 🚀 Option 1: Vercel Deployment (Recommended)

### Why Vercel?
- ✅ **Free tier** available
- ✅ **Perfect for Next.js** (made by Next.js creators)
- ✅ **Automatic deployments** from GitHub
- ✅ **Built-in environment variables**
- ✅ **Free SSL certificates**
- ✅ **Global CDN**

### Step 1: Connect GitHub to Vercel

1. Go to: **https://vercel.com**
2. Sign up/Login with GitHub
3. Click **"Add New Project"**
4. Import your repository: `Dhani-1428/medical-stock-manager`
5. Vercel will auto-detect Next.js

### Step 2: Configure Environment Variables

In Vercel project settings, add these environment variables:

**Required:**
```
MONGODB_URI=mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/erp-medical?retryWrites=true&w=majority
JWT_ACCESS_SECRET=your-super-secret-jwt-key-min-32-chars-change-in-production
CLIENT_ORIGIN=https://your-app-name.vercel.app
PUBLIC_APP_URL=https://your-app-name.vercel.app
```

**Optional (for features):**
```
RAZORPAY_KEY_ID=your-razorpay-key-id
RAZORPAY_KEY_SECRET=your-razorpay-secret
RAZORPAY_WEBHOOK_SECRET=your-webhook-secret
SHIPROCKET_EMAIL=your-shiprocket-email
SHIPROCKET_PASSWORD=your-shiprocket-password
RAPIDSHYP_API_KEY=your-rapidshyp-key
DEFAULT_SHIPPING_PROVIDER=SHIPROCKET
```

### Step 3: Deploy

1. Click **"Deploy"**
2. Wait for build to complete (~2-3 minutes)
3. Your app will be live at: `https://your-app-name.vercel.app`

### Step 4: Update MongoDB Atlas IP Whitelist

1. Go to MongoDB Atlas → Network Access
2. Add IP: `0.0.0.0/0` (allows Vercel servers)
   - Or add specific Vercel IPs if you prefer
3. Save

### Step 5: Update Webhook URLs

**Razorpay:**
1. Go to Razorpay Dashboard → Webhooks
2. Update webhook URL to: `https://your-app-name.vercel.app/api/webhooks/razorpay`
3. Copy webhook secret to Vercel environment variables

**Shiprocket/RapidShyp:**
- Update webhook URLs in their dashboards to point to your Vercel URL

### Step 6: Seed Production Database

After first deployment, seed your database:

**Option A: Via API (if you add a seed endpoint)**
```bash
curl -X POST https://your-app-name.vercel.app/api/seed
```

**Option B: Run seed script locally pointing to production DB**
```bash
# Temporarily update .env with production MONGODB_URI
MONGODB_URI=mongodb+srv://...your-production-uri...
npm run seed
```

---

## 🗄️ MongoDB Atlas Configuration

### Where MongoDB Lives:
- **MongoDB Atlas** (cloud) - Already set up
- **Location:** Your Atlas cluster region (e.g., AWS us-east-1)
- **Accessible from:** Anywhere (with proper IP whitelist)

### Production MongoDB Setup:

1. **Use Production Cluster:**
   - Create a new cluster (or use existing)
   - Use M0 Free tier for testing, M10+ for production

2. **Database User:**
   - Create dedicated user for production
   - Strong password
   - Limited permissions (read/write to `erp-medical` DB only)

3. **IP Whitelist:**
   - Add Vercel IPs: `0.0.0.0/0` (for all Vercel servers)
   - Or specific IPs for better security

4. **Connection String:**
   ```
   mongodb+srv://prod-user:password@cluster0.xxxxx.mongodb.net/erp-medical?retryWrites=true&w=majority
   ```

---

## 🔗 Where Each Component Lives

```
┌─────────────────────────────────────────────────┐
│  PRODUCTION ARCHITECTURE                        │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌──────────────┐      ┌──────────────┐        │
│  │   Vercel     │      │ MongoDB      │        │
│  │   (Frontend) │◄────►│   Atlas      │        │
│  │              │      │   (Database) │        │
│  │ https://     │      │   Cloud      │        │
│  │ your-app.    │      │              │        │
│  │ vercel.app   │      │              │        │
│  └──────────────┘      └──────────────┘        │
│         │                                       │
│         │ Webhooks                              │
│         ▼                                       │
│  ┌──────────────┐                              │
│  │  Razorpay    │                              │
│  │  Shiprocket  │                              │
│  │  RapidShyp   │                              │
│  └──────────────┘                              │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## 📍 Environment Variables by Location

### Local Development (.env)
```env
MONGODB_URI=mongodb://localhost:27017/erp-medical
CLIENT_ORIGIN=http://localhost:3000
PUBLIC_APP_URL=http://localhost:3000
```

### Vercel Production (Environment Variables)
```env
MONGODB_URI=mongodb+srv://user:pass@cluster.mongodb.net/erp-medical?retryWrites=true&w=majority
CLIENT_ORIGIN=https://your-app-name.vercel.app
PUBLIC_APP_URL=https://your-app-name.vercel.app
```

---

## 🔐 Security Checklist for Production

- [ ] Use strong `JWT_ACCESS_SECRET` (32+ characters, random)
- [ ] MongoDB Atlas user has limited permissions
- [ ] IP whitelist configured (not `0.0.0.0/0` for production)
- [ ] Environment variables set in Vercel (not in code)
- [ ] Webhook secrets configured
- [ ] HTTPS enabled (automatic with Vercel)
- [ ] Database backups enabled (MongoDB Atlas)

---

## 🌍 Alternative Hosting Options

### Option 2: Netlify
- Similar to Vercel
- Good Next.js support
- Free tier available
- Set environment variables in Netlify dashboard

### Option 3: Railway
- Full-stack hosting
- Can host both Next.js and MongoDB
- Simple deployment
- Paid plans available

### Option 4: AWS/Google Cloud/Azure
- More control
- Requires more setup
- Better for enterprise
- Higher cost

### Option 5: Self-Hosted
- Your own server
- Full control
- Requires maintenance
- Need to manage MongoDB yourself

---

## 📝 Quick Deployment Checklist

**Before Deploying:**
- [ ] Code pushed to GitHub
- [ ] MongoDB Atlas cluster created
- [ ] Database user created
- [ ] IP whitelist configured
- [ ] Connection string ready

**During Deployment:**
- [ ] Connect GitHub to Vercel
- [ ] Set all environment variables
- [ ] Deploy project
- [ ] Wait for build to complete

**After Deployment:**
- [ ] Test login at production URL
- [ ] Seed database with initial data
- [ ] Update webhook URLs in Razorpay/Shiprocket
- [ ] Test key features
- [ ] Monitor for errors

---

## 🆘 Troubleshooting Production Issues

### "MONGODB_URI is required" in production
- Check environment variables in Vercel dashboard
- Ensure variable name matches exactly
- Redeploy after adding variables

### "Cannot connect to MongoDB"
- Check MongoDB Atlas IP whitelist includes Vercel IPs
- Verify connection string is correct
- Check database user permissions

### Webhooks not working
- Verify webhook URL is correct (https://your-app.vercel.app/api/webhooks/...)
- Check webhook secret matches in Vercel env vars
- Test webhook endpoint manually

### Build fails on Vercel
- Check build logs in Vercel dashboard
- Ensure all dependencies are in package.json
- Verify Node.js version compatibility

---

## 📞 Next Steps

1. **Deploy to Vercel** → Follow Step 1-3 above
2. **Configure MongoDB Atlas** → Update IP whitelist
3. **Set Environment Variables** → Add all required vars
4. **Seed Database** → Run seed script
5. **Test Production** → Login and test features
6. **Update Webhooks** → Configure Razorpay/Shiprocket

Your app will be live at: `https://your-app-name.vercel.app` 🎉
