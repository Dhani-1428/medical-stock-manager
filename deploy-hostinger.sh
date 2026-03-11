#!/bin/bash
# Deployment script for Hostinger VPS
# Hostname: srv1266361.hstgr.cloud

set -e

HOSTNAME="srv1266361.hstgr.cloud"
USER="root"
APP_DIR="/var/www/erp-medical"
DOMAIN="srv1266361.hstgr.cloud"

echo "=========================================="
echo "Deploying to Hostinger VPS"
echo "Hostname: $HOSTNAME"
echo "=========================================="
echo ""

# Step 1: Build the application locally
echo "Step 1: Building application..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed. Please fix errors and try again."
    exit 1
fi

echo "✅ Build successful"
echo ""

# Step 2: Create deployment package
echo "Step 2: Creating deployment package..."
tar -czf deploy.tar.gz \
    --exclude='.git' \
    --exclude='node_modules' \
    --exclude='.next' \
    --exclude='.env' \
    --exclude='*.log' \
    --exclude='test-results' \
    --exclude='playwright-report' \
    .

echo "✅ Deployment package created"
echo ""

# Step 3: Upload to server
echo "Step 3: Uploading to server..."
scp deploy.tar.gz $USER@$HOSTNAME:/tmp/

if [ $? -ne 0 ]; then
    echo "❌ Upload failed. Check SSH connection."
    exit 1
fi

echo "✅ Upload successful"
echo ""

# Step 4: Deploy on server
echo "Step 4: Deploying on server..."
ssh $USER@$HOSTNAME << 'ENDSSH'
    set -e
    
    APP_DIR="/var/www/erp-medical"
    BACKUP_DIR="/var/www/backups/erp-medical-$(date +%Y%m%d-%H%M%S)"
    
    echo "Creating backup..."
    if [ -d "$APP_DIR" ]; then
        mkdir -p /var/www/backups
        cp -r $APP_DIR $BACKUP_DIR
        echo "✅ Backup created at $BACKUP_DIR"
    fi
    
    echo "Creating app directory..."
    mkdir -p $APP_DIR
    
    echo "Extracting files..."
    cd $APP_DIR
    tar -xzf /tmp/deploy.tar.gz
    
    echo "Installing dependencies..."
    npm install --production
    
    echo "Building application..."
    npm run build
    
    echo "Setting permissions..."
    chown -R www-data:www-data $APP_DIR
    chmod -R 755 $APP_DIR
    
    echo "Restarting application..."
    if command -v pm2 &> /dev/null; then
        pm2 restart erp-medical || pm2 start npm --name "erp-medical" -- start
        pm2 save
    else
        echo "PM2 not found. Please start manually: cd $APP_DIR && npm run start"
    fi
    
    echo "Cleaning up..."
    rm /tmp/deploy.tar.gz
    
    echo "✅ Deployment complete!"
ENDSSH

if [ $? -ne 0 ]; then
    echo "❌ Deployment failed on server."
    exit 1
fi

# Step 5: Cleanup local files
echo ""
echo "Step 5: Cleaning up..."
rm deploy.tar.gz

echo ""
echo "=========================================="
echo "✅ Deployment Complete!"
echo "=========================================="
echo ""
echo "Your application should be accessible at:"
echo "http://$DOMAIN:3000"
echo "or"
echo "https://$DOMAIN (if SSL configured)"
echo ""
echo "Next steps:"
echo "1. SSH into server: ssh $USER@$HOSTNAME"
echo "2. Check application: cd $APP_DIR && pm2 logs"
echo "3. Configure Nginx/Apache for domain"
echo "4. Set up SSL certificate"
echo ""
