# FocusFlow 🚀
**Master Your Productivity, Track Your Goals, and Find Your Flow.**

FocusFlow is a professional, mobile-first productivity application designed specifically for students. It combines task management, a Pomodoro-based focus timer, academic note-taking, and goal tracking into a single, unified experience.

## ✨ Key Features
- **Task Management:** Organize academic tasks with priority levels, categories, and deadline tracking.
- **Focus Timer:** High-fidelity Pomodoro timer to eliminate distractions and track study sessions.
- **Academic Notes:** Capture ideas and link them to specific subjects with image attachment support.
- **Goal Tracking:** Set daily, weekly, and monthly targets for study hours and task completions.
- **Real-time Analytics:** Data-driven insights into study trends, subject performance, and productivity scores.
- **Privacy First:** Optional biometric app lock (Fingerprint/FaceID) to keep your data secure.
- **Offline-First:** All data is persisted locally using Isar NoSQL, ensuring the app works anywhere.

## 🛠️ Tech Stack
- **Framework:** [Flutter](https://flutter.dev)
- **Language:** [Dart](https://dart.dev)
- **State Management:** [Riverpod](https://riverpod.dev)
- **Local Database:** [Isar](https://isar.dev)
- **Navigation:** [GoRouter](https://pub.dev/packages/go_router)
- **Analytics:** [fl_chart](https://pub.dev/packages/fl_chart)
- **Security:** [local_auth](https://pub.dev/packages/local_auth)

## 🏗️ Architecture
FocusFlow implements a **Layered Clean Architecture** to ensure scalability and maintainability:
- `core/`: Global themes, routing, utilities, and shared services.
- `data/`: Isar schemas, local storage implementations, and DTOs.
- `domain/`: Business entities and abstract repository interfaces.
- `presentation/`: Riverpod providers (state) and Material 3 UI screens.

## 📂 Folder Structure
```text
lib/
├── core/           # Theme, Router, Utilities
├── data/           # Isar Models, Storage Services
└── presentation/   # Riverpod State, UI Screens, Widgets
```

## 🚀 Installation & Setup
1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/focus_flow.git
   cd focus_flow
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Generate code:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. **Run the app:**
   ```bash
   flutter run
   ```

## 📱 Device Integrations
- **Biometrics:** Integration with `local_auth` for secure app access.
- **Notifications:** `flutter_local_notifications` for deadline and study reminders.
- **Media:** `image_picker` for capturing and attaching study materials to notes.

## ✅ Build Status
- **Android APK:** Successfully validated.
- **Build Command:** `flutter build apk --debug`
- **APK Path:** `build/app/outputs/flutter-apk/app-debug.apk`

## 🚧 Known Limitations
- **Cloud Sync:** Currently 100% offline. Future versions will include Firebase/Supabase sync.
- **Recurring Notifications:** Basic scheduling is implemented; complex recurrence is on the roadmap.

## 📋 Device Test Checklist
- [ ] **Biometric Lock:** Toggle in settings and verify app lock on app restart.
- [ ] **Local Notifications:** Schedule a reminder and verify notification delivery.
- [ ] **Image Attachments:** Pick images from gallery/camera and verify they display in notes.
- [ ] **Isar Persistence:** Add tasks/notes, restart app, and verify data persistence.
- [ ] **Study Timer:** Complete a session and verify it appears in Analytics.

## 🗺️ Roadmap
- [ ] Calendar Integration
- [ ] Cloud Sync & Backup
- [ ] Collaborative Study Groups
- [ ] AI-powered Task Prioritization
- [ ] Advanced Productivity Heatmaps

## 🤝 Contribution
Contributions are welcome! Please open an issue or submit a PR.
