# MongoDB Setup Script for Windows
# This script helps you set up MongoDB for the ERP Medical application

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "MongoDB Setup Helper" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if MongoDB is already running
Write-Host "Checking MongoDB status..." -ForegroundColor Yellow
$mongoService = Get-Service -Name "*mongo*" -ErrorAction SilentlyContinue
$portCheck = netstat -ano | findstr :27017

if ($mongoService) {
    Write-Host "MongoDB service found: $($mongoService.Name)" -ForegroundColor Green
    if ($mongoService.Status -eq "Running") {
        Write-Host "MongoDB is already running!" -ForegroundColor Green
        Write-Host "You can proceed with the application." -ForegroundColor Green
        exit 0
    } else {
        Write-Host "MongoDB service is stopped. Attempting to start..." -ForegroundColor Yellow
        try {
            Start-Service -Name $mongoService.Name
            Write-Host "MongoDB service started successfully!" -ForegroundColor Green
            exit 0
        } catch {
            Write-Host "Failed to start MongoDB service: $_" -ForegroundColor Red
        }
    }
}

if ($portCheck) {
    Write-Host "Port 27017 is already in use. MongoDB might be running." -ForegroundColor Yellow
    Write-Host "Checking connection..." -ForegroundColor Yellow
    try {
        $testConnection = Test-NetConnection -ComputerName localhost -Port 27017 -WarningAction SilentlyContinue
        if ($testConnection.TcpTestSucceeded) {
            Write-Host "MongoDB is accessible on port 27017!" -ForegroundColor Green
            exit 0
        }
    } catch {
        Write-Host "Could not verify MongoDB connection." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "MongoDB is not installed or not running." -ForegroundColor Red
Write-Host ""
Write-Host "Please choose an option:" -ForegroundColor Cyan
Write-Host "1. Install MongoDB locally (requires download)" -ForegroundColor White
Write-Host "2. Use MongoDB Atlas (cloud - recommended, free tier available)" -ForegroundColor White
Write-Host "3. Use Docker (if Docker Desktop is installed)" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Enter your choice (1, 2, or 3)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "To install MongoDB locally:" -ForegroundColor Yellow
        Write-Host "1. Download MongoDB Community Server from:" -ForegroundColor White
        Write-Host "   https://www.mongodb.com/try/download/community" -ForegroundColor Cyan
        Write-Host "2. Run the installer"
        Write-Host "3. Choose 'Complete' installation"
        Write-Host "4. Install as Windows Service (recommended)"
        Write-Host "5. After installation, run this script again to start MongoDB"
        Write-Host ""
        Write-Host "Opening download page..." -ForegroundColor Yellow
        Start-Process "https://www.mongodb.com/try/download/community"
    }
    "2" {
        Write-Host ""
        Write-Host "MongoDB Atlas Setup (Cloud):" -ForegroundColor Yellow
        Write-Host "1. Go to: https://www.mongodb.com/cloud/atlas/register" -ForegroundColor Cyan
        Write-Host "2. Sign up for free account"
        Write-Host "3. Create a free M0 cluster"
        Write-Host "4. Create database user"
        Write-Host "5. Whitelist your IP (or 0.0.0.0/0 for testing)"
        Write-Host "6. Get connection string and update .env file"
        Write-Host ""
        Write-Host "Your .env should have:" -ForegroundColor Yellow
        Write-Host "MONGODB_URI=mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/erp-medical?retryWrites=true&w=majority" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Opening MongoDB Atlas..." -ForegroundColor Yellow
        Start-Process "https://www.mongodb.com/cloud/atlas/register"
        
        Write-Host ""
        Write-Host "After setting up Atlas, update your .env file with the connection string." -ForegroundColor Yellow
        Write-Host "Then restart your dev server: npm run dev" -ForegroundColor Yellow
    }
    "3" {
        Write-Host ""
        Write-Host "Checking Docker..." -ForegroundColor Yellow
        $dockerInstalled = docker --version 2>$null
        if ($dockerInstalled) {
            Write-Host "Docker is installed!" -ForegroundColor Green
            Write-Host "Starting MongoDB container..." -ForegroundColor Yellow
            
            # Check if container already exists
            $existingContainer = docker ps -a --filter "name=mongodb" --format "{{.Names}}"
            
            if ($existingContainer -eq "mongodb") {
                Write-Host "MongoDB container exists. Starting it..." -ForegroundColor Yellow
                docker start mongodb
            } else {
                Write-Host "Creating new MongoDB container..." -ForegroundColor Yellow
                docker run -d -p 27017:27017 --name mongodb -e MONGO_INITDB_DATABASE=erp-medical mongo:latest
            }
            
            Start-Sleep -Seconds 3
            
            # Verify it's running
            $containerStatus = docker ps --filter "name=mongodb" --format "{{.Status}}"
            if ($containerStatus) {
                Write-Host "MongoDB container is running!" -ForegroundColor Green
                Write-Host "Status: $containerStatus" -ForegroundColor Green
                Write-Host ""
                Write-Host "Your .env should have:" -ForegroundColor Yellow
                Write-Host "MONGODB_URI=mongodb://localhost:27017/erp-medical" -ForegroundColor Cyan
                Write-Host ""
                Write-Host "You can now start your dev server: npm run dev" -ForegroundColor Green
            } else {
                Write-Host "Failed to start MongoDB container." -ForegroundColor Red
                Write-Host "Check Docker Desktop is running and try again." -ForegroundColor Yellow
            }
        } else {
            Write-Host "Docker is not installed." -ForegroundColor Red
            Write-Host "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
            Write-Host "Or choose option 1 or 2 instead." -ForegroundColor Yellow
        }
    }
    default {
        Write-Host "Invalid choice. Please run the script again." -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
