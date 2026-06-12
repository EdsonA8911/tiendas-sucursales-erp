# ERP Multi-tenant - Arquitectura de Microservicios

Este proyecto es la base de un sistema ERP Multi-tenant diseñado bajo una arquitectura de microservicios, utilizando NestJS y principios de Arquitectura Limpia (N-Capas).

## 🚀 Topología de Infraestructura

El sistema utiliza Docker para gestionar los servicios de infraestructura base:

- **Red**: `erp-network` (Bridge) aislada para comunicación interna.
- **Base de Datos**: PostgreSQL 15 (Persistente vía volúmenes).
- **Broker de Mensajería**: RabbitMQ (Management UI incluida).

### Puertos de Infraestructura
- **PostgreSQL**: `5432`
- **RabbitMQ (Broker)**: `5672`
- **RabbitMQ (Dashboard)**: `15672`

---

## 🛠 Asignación de Puertos - Microservicios

| Servicio | Puerto Propuesto | Descripción |
| :--- | :---: | :--- |
| `api-gateway` | `3000` | Punto de entrada único y validación de JWT. |
| `ms-empresas-catalogos` | `3001` | Gestión de tenants (empresas) y catálogos base. |
| `ms-inventarios` | `3002` | Control de stock, almacenes y movimientos. |
| `ms-ventas-facturacion` | `3003` | Procesamiento de ventas, pedidos y facturas. |
| `ms-finanzas` | `3004` | Contabilidad, cuentas por cobrar/pagar. |
| `dashboard-web` | `3005` | Dashboard Administrativo (React + Vite + Tailwind). |

---

## 🏗 Arquitectura de N-Capas (Clean Architecture)

Cada microservicio debe seguir esta estructura interna dentro de su carpeta `src/`:

1.  **Domain (Core)**: Entidades de negocio, interfaces de repositorios y lógica pura (sin dependencias externas).
2.  **Application**: Casos de uso, servicios de aplicación y DTOs. Coordina la lógica del dominio.
3.  **Infrastructure**: Implementaciones de base de datos (TypeORM/Prisma), adaptadores de RabbitMQ y clientes externos.
4.  **Presentation**: Controladores de NestJS, Gateways de Websockets o resolvers de GraphQL.

---

## ⚡ Configuración Rápida - Para el Equipo

### Requisitos Previos
- **Node.js** 18+ ([Descargar](https://nodejs.org/))
- **Docker Desktop** ([Descargar](https://www.docker.com/products/docker-desktop))
- **Git** configurado

### 1️⃣ Clonar y Configurar Automáticamente

**Windows:**
```bash
git clone <repo-url>
cd Tiendas-Sucursales
setup.bat
```

**Linux/Mac:**
```bash
git clone <repo-url>
cd Tiendas-Sucursales
chmod +x setup.sh
./setup.sh
```

Este script automáticamente:
- ✅ Verifica Node.js y Docker
- ✅ Crea `.env` en cada carpeta desde `.env.example`
- ✅ Instala todas las dependencias

### 2️⃣ Levantar la Infraestructura

```bash
# Asegúrate que Docker Desktop está corriendo, luego:
docker-compose up -d
```

Verifica que todo esté funcionando:
```bash
docker-compose ps
```

### 3️⃣ Levantar los Microservicios

**En terminales separadas:**

```bash
# Terminal 1 - API Gateway
cd api-gateway
npm run start

# Terminal 2 - Empresas y Catálogos
cd ms-empresas-catalogos
npm run start

# Terminal 3 - Inventarios
cd ms-inventarios
npm run start

# Terminal 4 - Ventas y Facturación
cd ms-ventas-facturacion
npm run start

# Terminal 5 - Finanzas
cd ms-finanzas
npm run start

# Terminal 6 - Dashboard Web
cd dashboard-web
npm run dev
```

### ✅ Verificar que Todo Funciona

| Servicio | URL |
|----------|-----|
| **Dashboard** | http://localhost:3005 |
| **API Gateway** | http://localhost:3000 |
| **RabbitMQ Dashboard** | http://localhost:15672 (guest/guest) |
| **PostgreSQL** | localhost:5432 |

---

## 🚦 Pasos Iniciales para Desarrollo

Para comenzar con **cambios** en el código:

1.  **Estructura de Capas**:
    Cada microservicio sigue N-Capas dentro de `src/`:
    - `domain/` - Entidades de negocio
    - `application/` - Casos de uso y DTOs
    - `infrastructure/` - Base de datos y adaptadores
    - `presentation/` - Controladores NestJS

2.  **Variables de Entorno**:
    Cada microservicio tiene `.env.example`. Cópialas a `.env` para desarrollo local.

3.  **Desarrollo en Caliente**:
    NestJS viene con watch mode. Los cambios se aplican automáticamente:
    ```bash
    npm run start:dev
    ```

---

## 📎 Notas de Diseño Senior
- **Multi-tenancy**: Se recomienda el enfoque de "Schema per Tenant" o "Discriminator Column" dependiendo del volumen de datos.
- **Comunicación**: Usar RabbitMQ para procesos asíncronos (eventos de dominio) y REST/gRPC para consultas síncronas entre servicios.
- **Shared Library**: Utiliza la carpeta `/ms-shared` para lógica común que no amerita un microservicio propio.
