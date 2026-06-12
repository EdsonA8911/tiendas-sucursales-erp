#!/bin/bash

# Setup script for ERP Multi-tenant Project (Linux/Mac)

echo ""
echo "===================================="
echo " ERP Multi-tenant - Setup Script"
echo "===================================="
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Error: Node.js is not installed"
    echo "Please install Node.js from https://nodejs.org/"
    exit 1
fi
echo "✅ Node.js found: $(node --version)"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Error: Docker is not installed"
    echo "Please install Docker from https://www.docker.com/"
    exit 1
fi
echo "✅ Docker found: $(docker --version)"
echo ""

# Create .env files from .env.example if they don't exist
echo "Creating .env files..."
[ ! -f ".env" ] && cp ".env.example" ".env" && echo "✅ Created .env at root"
[ ! -f "api-gateway/.env" ] && cp "api-gateway/.env.example" "api-gateway/.env" && echo "✅ Created .env in api-gateway"
[ ! -f "ms-empresas-catalogos/.env" ] && cp "ms-empresas-catalogos/.env.example" "ms-empresas-catalogos/.env" && echo "✅ Created .env in ms-empresas-catalogos"
[ ! -f "ms-inventarios/.env" ] && cp "ms-inventarios/.env.example" "ms-inventarios/.env" && echo "✅ Created .env in ms-inventarios"
[ ! -f "ms-ventas-facturacion/.env" ] && cp "ms-ventas-facturacion/.env.example" "ms-ventas-facturacion/.env" && echo "✅ Created .env in ms-ventas-facturacion"
[ ! -f "ms-finanzas/.env" ] && cp "ms-finanzas/.env.example" "ms-finanzas/.env" && echo "✅ Created .env in ms-finanzas"
echo ""

# Install dependencies for all microservices
echo "Installing dependencies..."
echo ""

for service in api-gateway ms-empresas-catalogos ms-inventarios ms-ventas-facturacion ms-finanzas dashboard-web; do
    echo "Installing $service dependencies..."
    cd "$service"
    npm install
    cd ..
done

echo ""
echo "===================================="
echo " ✅ Setup Complete!"
echo "===================================="
echo ""
echo "Next steps:"
echo "1. Start Docker Desktop"
echo "2. Run: docker-compose up -d"
echo "3. In separate terminals, run:"
echo "   - cd api-gateway && npm run start"
echo "   - cd ms-empresas-catalogos && npm run start"
echo "   - cd ms-inventarios && npm run start"
echo "   - cd ms-ventas-facturacion && npm run start"
echo "   - cd ms-finanzas && npm run start"
echo "   - cd dashboard-web && npm run dev"
echo ""
echo "Dashboard URL: http://localhost:3005"
echo "API Gateway URL: http://localhost:3000"
echo "RabbitMQ Dashboard: http://localhost:15672 (guest/guest)"
echo ""
