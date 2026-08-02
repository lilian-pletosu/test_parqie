# Parqie - Flutter Location-Based Application

A modern, responsive Flutter location-based application built with **Riverpod**, **GoRouter**, and **OpenStreetMap (flutter_map)**.

---

## 🌟 Features

- 🚀 **Native Splash Screen**: Configured natively using `flutter_native_splash` with smooth transition delay.
- 🗺️ **Interactive Map**: Panning, zooming, and interactive location markers showing parking availability status.
- 🔍 **Real-Time Search Bar**: Auto-completing location search bar with keyboard-aware animations.
- 📌 **Dynamic Bottom Sheet**: Draggable scrollable bottom sheet with sticky pinned header and scrollable body.
- 👤 **Mock Profile Screen**: Comprehensive profile view with user stats, saved vehicle details, and account settings.
- ⚡ **Clean Architecture**: Decoupled feature-first project structure (`features/map`, `features/profile`, `core`, `app`).
- 🤖 **CI/CD Pipeline**: Automated GitHub Actions pipeline for linting, testing, and building Android APK artifacts.

---

## 🛠️ Tech Stack & Architecture

- **Framework**: Flutter (Dart)
- **State Management**: Riverpod (`flutter_riverpod`, `riverpod_annotation`)
- **Navigation**: `go_router`
- **Map & Geolocation**: `flutter_map`, `latlong2`, `geolocator`
- **Data Models**: `freezed` & `json_annotation`
- **CI/CD**: GitHub Actions (`.github/workflows/ci.yml`)

---

## ⚙️ Setup & Installation

1. **Clone the repository**:
   ```bash
   git clone <repo-url>
   cd test_parqie
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run build runner (if modifying models)**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

---

## 🧪 Testing & Code Quality

Run static code analysis:
```bash
flutter analyze
```

Run unit & widget tests:
```bash
flutter test
```

---

## 🔄 CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/ci.yml`) automatically performs:
- **`analyze_and_test`**: Runs `flutter analyze` & `flutter test` on every push/PR.
- **`build_android`**: Compiles the Android production release APK (`flutter build apk --release`) and uploads it as a workflow artifact (`app-release-apk`).
