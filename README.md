# Car Dealership Platform

A full-stack car dealership management system for tracking vehicle inventory, customers, and sales - built as an evolution of a basic CRUD API into a realistic business platform.

---

## Features

### 🚗 Vehicle Inventory
- Add, remove, and search vehicles across the dealer's stock
- Track make, model, year, price, and quantity in stock
- Live search-as-you-type, per-field clear controls for fast filtering
- Stock level badges - green (healthy), amber (low), red (out of stock)
- Update stock levels independently from other vehicle details

### 👥 Customer Management
- Create, edit, and remove customer records
- Store name, email, and phone number
- Track when each customer was added

### 💰 Sales Transactions
- Record a sale against a specific customer and vehicle
- Stock is automatically decremented on sale creation (atomic database transaction)
- Full sale status lifecycle: **Pending → Completed** or **Pending → Cancelled**
- Revert completed or cancelled sales back to pending

### 📊 Dashboard
- At-a-glance summary: total vehicles, units in stock, total revenue, low stock count
- Low stock alerts with configurable threshold (default: fewer than 3 units)
- Top brands by vehicle count
- Recent sales feed with customer name, vehicle, amount, and status

### 📈 Analytics
- Revenue metrics: total, current month, average sale value, total sale count
- Filterable by custom date range with From / To date pickers
- Quick presets: This month, This quarter, This year, All time
- Top brands ranked by revenue with visual bar chart
- Stock summary: total models, total units, out-of-stock count, inventory value

### 🔐 Authentication
- JWT-based login - each dealer's data is fully isolated
- All API endpoints are scoped to the authenticated dealer via JWT claims
- Logout confirmation to prevent accidental sign-out
- Token stored in localStorage, cleared on logout

---

## Tech Stack

### Backend
| | |
|---|---|
| Framework | ASP.NET Core (.NET 9) |
| Endpoints | FastEndpoints (vertical slice architecture) |
| Database | SQLite |
| Data access | Dapper (raw SQL, no ORM) |
| Auth | JWT Bearer tokens |

### Frontend
| | |
|---|---|
| Framework | React 18 |
| Build tool | Vite |
| Styling | Inline styles with CSS custom properties |
| HTTP | Native `fetch` API |
| State | React `useState` / `useContext` |

---

## Project Structure

```
CarDealershipPlatform/
├── carstockapi-backend/            # ASP.NET Core API
│   ├── Auth/                       # JWT login endpoint
│   ├── Database/                   # SQLite init and schema
│   ├── Features/                   # Vertical slice endpoints
│   │   ├── Cars/                   # Add, list, search, update stock, remove
│   │   ├── Customers/              # Add, list, edit, remove
│   │   ├── Sales/                  # Create sale, list, update status
│   │   ├── Dashboard/              # Summary endpoint
│   │   └── Analytics/              # Revenue, top brands, stock summary
│   ├── Models/                     # Car, Customer, Sale
│   ├── Repositories/               # Data access layer
│   │   ├── CarRepository.cs
│   │   ├── DealerRepository.cs
│   │   ├── CustomerRepository.cs
│   │   ├── SalesRepository.cs
│   │   ├── DashboardRepository.cs
│   │   └── AnalyticsRepository.cs
│   ├── Program.cs
│   ├── appsettings.json
│   └── CarStockAPI.csproj
│
├── react-frontend/                 # React SPA
│   ├── src/
│   │   ├── App.jsx                 # All pages and components (single file)
│   │   └── main.jsx                # Entry point
│   ├── index.html
│   ├── package.json
│   └── vite.config.js
│
└── README.md
```

---

## Getting Started

### Prerequisites

- [.NET 9 SDK](https://dotnet.microsoft.com/download)
- Git

### 1. Clone the repository

```bash
git clone https://github.com/sontrinh2003/CarDealershipPlatform.git
cd CarDealershipPlatform
```

### 2. Configure the backend

Edit `carstockapi-backend/appsettings.json` and set a JWT secret key:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Data Source=Database/cars.db"
  },
  "JwtSettings": {
    "SecretKey": "your-secret-key-min-32-characters-long"
  }
}
```

### 3. Run the backend

```bash
cd carstockapi-backend
dotnet restore
dotnet run
```

The API will be available at `http://localhost:8080`.  
Swagger UI is available at `http://localhost:8080/swagger`.

### 4. Run the frontend

Open a second terminal:

```bash
cd react-frontend
npm install
npm run dev
```

The app will be available at `http://localhost:5173`.

---

## API Endpoints

### Auth
| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/login` | Dealer login - returns JWT |

### Vehicles
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/cars` | List all vehicles for authenticated dealer |
| POST | `/api/cars` | Add a new vehicle |
| GET | `/api/cars/search?make=&model=` | Search vehicles by make and/or model |
| PUT | `/api/cars/{id}/stock` | Update stock level |
| DELETE | `/api/cars/{id}` | Remove a vehicle |

### Customers
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/customers` | List all customers |
| POST | `/api/customers` | Add a new customer |
| PUT | `/api/customers/{id}` | Update customer details |
| DELETE | `/api/customers/{id}` | Remove a customer |

### Sales
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/sales` | List all sales |
| POST | `/api/sales` | Record a new sale (decrements stock atomically) |
| PUT | `/api/sales/{id}/status` | Update sale status (Pending / Completed / Cancelled) |

### Dashboard
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/dashboard/summary?lowStockThreshold=3` | Inventory and sales summary |

### Analytics
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/analytics/revenue?from=&to=` | Revenue metrics for a date range |
| GET | `/api/analytics/topBrands` | Top brands by revenue |
| GET | `/api/analytics/stockSummary` | Stock totals and inventory value |

---

## Database Schema

```sql
Dealers    (Id, Username, PasswordHash)
Cars       (Id, DealerId, Make, Model, Year, Price, Stock)
Customers  (Id, DealerId, Name, Email, Phone, CreatedAt)
Sales      (Id, DealerId, CarId, CustomerId, SaleAmount, SaleDate, Status)
```

All tables are scoped by `DealerId` - each dealer only sees their own data.

---

## Architecture Notes

**Multi-tenant by design** - every query filters by `DealerId` extracted from the JWT claim. One database, fully isolated data per dealer.

**Vertical slice endpoints** - each feature lives in its own folder under `Features/`. No controllers. FastEndpoints routes are self-contained.

**Repository pattern** - all SQL lives in `Repositories/`. Endpoints receive repositories via constructor injection and contain no database code.

**Atomic sale creation** - recording a sale and decrementing stock happen inside a single SQLite transaction. If either step fails, both are rolled back.
