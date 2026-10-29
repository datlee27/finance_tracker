# 💰 Personal Finance Tracker

A cross-platform personal finance tracking application built with **Flutter** and **Firebase**.

## 📱 Features

- **Authentication**: Email/Password registration & login with Firebase Auth, guest mode, and persistent sessions.
- **Transaction Management**: Add, edit, delete, and view income and expense transactions with date, category, and notes.
- **Budget & Category Tracking**: Manage transaction categories with color tags and icons.
- **Dashboard & Insights**: Monthly overview with interactive charts, balance calculation, and expense breakdowns.
- **Multi-Platform Support**: Responsive design tested on Web and Mobile (Android & iOS).

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **State Management**: Provider
- **Backend / Database**: Firebase Authentication, Cloud Firestore
- **Charts**: fl_chart
- **Formatting**: intl

## 🚀 Getting Started

### 1. Prerequisites
- Flutter SDK (>= 3.0.0)
- Dart SDK

### 2. Setup Firebase Credentials
For security reasons, Firebase API keys are not committed to this repository.
To configure Firebase:
1. Copy the example configuration:
   ```bash
   cp personal_finance_tracker/lib/firebase_options.dart.example personal_finance_tracker/lib/firebase_options.dart
   ```
2. Put your Firebase credentials into `personal_finance_tracker/lib/firebase_options.dart`.
3. (Optional for Android) Add your `google-services.json` inside `personal_finance_tracker/android/app/`.

### 3. Run the App
```bash
cd personal_finance_tracker
flutter pub get
flutter run
```
