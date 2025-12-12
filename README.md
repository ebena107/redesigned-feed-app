# Feed Estimator

A professional Flutter application for livestock feed formulation and nutritional analysis. Calculate optimal feed compositions, manage custom ingredients, and analyze nutritional content for your livestock.

## Features

### 🌾 Feed Management
- Create and update custom feed formulations
- Add multiple ingredients with precise quantities
- Real-time nutritional analysis
- Save and manage feed recipes

### 📊 Nutritional Analysis
- Comprehensive nutrient breakdown
- Energy (ME), protein, fiber analysis
- Mineral and vitamin content tracking
- Instant calculation results

### 🧪 Custom Ingredients
- Create custom ingredient profiles
- Import/export ingredients (JSON & CSV)
- Search and filter ingredients
- Manage ingredient database

### 📁 Data Management
- Export/import application data
- CSV and JSON format support
- Backup and restore functionality
- Privacy-focused data handling

### 🎨 Modern UI/UX
- Material Design 3
- Consistent SnackBar notifications
- Smooth animations and transitions
- Responsive layouts

## Getting Started

### Prerequisites
- Flutter SDK (>=3.5.0 <4.0.0)
- Dart SDK
- Android Studio / VS Code
- Android SDK (for Android builds)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd redesigned-feed-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android APK**
```bash
flutter build apk --release
```

**Android App Bundle**
```bash
flutter build appbundle --release
```

## Project Structure

```
lib/
├── src/
│   ├── core/           # Core utilities, constants, services
│   ├── features/       # Feature modules
│   │   ├── add_ingredients/
│   │   ├── add_update_feed/
│   │   ├── main/
│   │   ├── privacy/
│   │   ├── reports/
│   │   ├── settings/
│   │   └── splash/
│   └── utils/          # Shared widgets and utilities
└── main.dart
```

## Key Technologies

- **State Management**: Riverpod 2.5+
- **Navigation**: GoRouter 14.6+
- **Database**: SQLite (sqflite)
- **UI Framework**: Flutter Material Design 3
- **Code Generation**: build_runner, json_serializable

## Development

### Code Quality
```bash
# Run static analysis
flutter analyze

# Run tests
flutter test

# Format code
flutter format lib/
```

### Pre-Launch Checklist
- ✅ All lint issues resolved
- ✅ Modern dialog system implemented
- ✅ SnackBar standardization complete
- ✅ Export/import functionality tested
- ✅ Data persistence verified
- ✅ Privacy policy included

## Privacy & Data

This app prioritizes user privacy:
- All data stored locally on device
- No external data transmission
- Export/import for data portability
- User consent for data collection
- See [PRIVACY_POLICY.md](PRIVACY_POLICY.md) for details

## Version History

### v0.1.1+10 (Current)
- Modern dialog system with consistent design
- SnackBar standardization across app
- Fixed export/import functionality
- Improved UI/UX with Material Design 3
- Performance optimizations
- Bug fixes and stability improvements

## Contributing

Contributions are welcome! Please follow these guidelines:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and linting
5. Submit a pull request

## License

[Add your license here]

## Support

For issues, questions, or suggestions:
- Create an issue on GitHub
- Contact: [Your contact information]

## Acknowledgments

- Flutter team for the amazing framework
- Riverpod for state management
- All contributors and testers

---

**Built with ❤️ using Flutter**
