@echo off
REM Setup script for ERP Multi-tenant Project (Windows)

echo.
echo ===================================
echo  ERP Multi-tenant - Setup Script
echo ===================================
echo.

REM Check if Node.js is installed
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Error: Node.js is not installed
    echo Please install Node.js from https://nodejs.org/
    exit /b 1
)
echo ✅ Node.js found: 
node --version
echo.

REM Check if Docker is installed and running
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Error: Docker is not installed
    echo Please install Docker from https://www.docker.com/
    exit /b 1
)
echo ✅ Docker found: 
docker --version
echo.

REM Create .env files from .env.example if they don't exist
echo Creating .env files...
if not exist ".env" (
    copy ".env.example" ".env"
    echo ✅ Created .env at root
)

if not exist "api-gateway\.env" (
    copy "api-gateway\.env.example" "api-gateway\.env"
    echo ✅ Created .env in api-gateway
)

if not exist "ms-empresas-catalogos\.env" (
    copy "ms-empresas-catalogos\.env.example" "ms-empresas-catalogos\.env"
    echo ✅ Created .env in ms-empresas-catalogos
)

if not exist "ms-inventarios\.env" (
    copy "ms-inventarios\.env.example" "ms-inventarios\.env"
    echo ✅ Created .env in ms-inventarios
)

if not exist "ms-ventas-facturacion\.env" (
    copy "ms-ventas-facturacion\.env.example" "ms-ventas-facturacion\.env"
    echo ✅ Created .env in ms-ventas-facturacion
)

if not exist "ms-finanzas\.env" (
    copy "ms-finanzas\.env.example" "ms-finanzas\.env"
    echo ✅ Created .env in ms-finanzas
)
echo.

REM Install dependencies for all microservices
echo Installing dependencies...
echo.

cd api-gateway
echo Installing api-gateway dependencies...
call npm install
cd ..

cd ms-empresas-catalogos
echo Installing ms-empresas-catalogos dependencies...
call npm install
cd ..

cd ms-inventarios
echo Installing ms-inventarios dependencies...
call npm install
cd ..

cd ms-ventas-facturacion
echo Installing ms-ventas-facturacion dependencies...
call npm install
cd ..

cd ms-finanzas
echo Installing ms-finanzas dependencies...
call npm install
cd ..

cd dashboard-web
echo Installing dashboard-web dependencies...
call npm install
cd ..

echo.
echo ===================================
echo  ✅ Setup Complete!
echo ===================================
echo.
echo Next steps:
echo 1. Start Docker Desktop
echo 2. Run: docker-compose up -d
echo 3. In separate terminals, run:
echo    - cd api-gateway && npm run start
echo    - cd ms-empresas-catalogos && npm run start
echo    - cd ms-inventarios && npm run start
echo    - cd ms-ventas-facturacion && npm run start
echo    - cd ms-finanzas && npm run start
echo    - cd dashboard-web && npm run dev
echo.
echo Dashboard URL: http://localhost:3005
echo API Gateway URL: http://localhost:3000
echo RabbitMQ Dashboard: http://localhost:15672 (guest/guest)
echo.
pause
