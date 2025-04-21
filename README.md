# 🏏 Cricket Event App

This project is a complete cricket event management system built with:

- 📱 **Flutter** (frontend)
- 🌐 **Node.js + Express** (backend)
- 🗄️ **MySQL** (database)
- ☁️ **Railway** (backend + database hosting)

---

## 📂 Project Structure

```
CRICS-cricket-event-app/
├── cricket_event_app/       # Flutter frontend app
└── cricket-event-backend/   # Node.js backend API
```

---

## 🚀 Getting Started

### 🔧 Prerequisites

- Flutter SDK
- Node.js & npm
- MySQL (only for local development)

---

### 📱 Flutter App Setup (`flutter_app/`)

```bash
cd flutter_app
flutter pub get
flutter run
```

> Make sure to set up the correct API URL in your Flutter code to connect to the hosted backend.

---

### 🌐 Backend Setup (`cricket-event-backend/`)

If you want to run the backend locally:

```bash
cd cricket-event-backend
npm install
npm run dev
```

Create a `.env` file with:

```env
PORT=5000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=cricket_event_db
```

---

## ☁️ Hosted Backend

The backend is hosted on **Railway**:

🔗 [https://cricsbackend-production.up.railway.app](https://cricsbackend-production.up.railway.app)

> Replace with your actual Railway backend URL

Use this base URL in your Flutter app to access the API.

---

## 🛠 Features

- Player registration
- Team creation & event management
- Match scheduling and statistics tracking
- Backend REST API with MySQL integration

---

## 🧑‍💻 Contributors

- 👤 Your Name ([kunalmchandak](https://github.com/kunalmchandak))

---

## 📜 License

This project is licensed under the MIT License.
```
