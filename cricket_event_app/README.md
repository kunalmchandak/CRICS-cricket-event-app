# 🏏 Cricket Event App – Flutter Frontend

This is the mobile frontend for the **Cricket Event Management System**, built using **Flutter**. It allows users to register, view upcoming events, join teams, and track match details in real time.

---

## 📱 Features

- 🔐 User Authentication (Email/Password or Phone Login via Firebase)
- 🧑‍🤝‍🧑 Player Registration
- 🏏 Team Management
- 📆 Match Scheduling & Event Management
- 📊 Match Statistics Display
- 🔗 Connected to a live Node.js backend hosted on Railway
- 🌐 Data stored and retrieved from MySQL

---

## 🚀 Getting Started

### ✅ Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Studio / VS Code with Flutter plugin
- Emulator or a physical Android device

---

### ⚙️ Setup

1. **Clone the Repository**

```bash
git clone https://github.com/your-username/cricket_event.git
cd cricket_event/flutter_app
```

2. **Get Packages**

```bash
flutter pub get
```

3. **Configure API URL**

Make sure the base URL of your API (hosted on Railway) is correctly set in your HTTP service file:

```dart
const String baseUrl = "https://your-railway-app-url.up.railway.app/api";
```

4. **Run the App**

```bash
flutter run
```

---

## 🗂 Project Structure

```
flutter_app/
├── lib/
│   ├── screens/          # All UI Screens
│   ├── services/         # API calls and backend integration
│   └── main.dart
├── android/
├── ios/
└── pubspec.yaml
```

---

## 🔗 Backend

The app connects to a backend REST API hosted on **Railway**, with the backend code located at:

📁 `../cricket-event-backend/`  
🌐 Hosted URL: [https://cricsbackend-production.up.railway.app](https://cricsbackend-production.up.railway.app)

---

## 🤝 Contributors

- 👤 Your Name ([kunalmchandak](https://github.com/kunalmchandak))

---

## 📃 License

MIT License – see the [LICENSE](../LICENSE) file for details.
```
