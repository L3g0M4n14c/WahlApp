# Changelog

All notable changes to the WahlApp project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-10-15

### Added
- Initial release of WahlApp
- Voter management functionality
  - Add voters with PK-Number, Last Name, and First Name
  - View all voters in a sorted list
  - Delete voters with confirmation dialog
  - Unique constraint on PK-Number to prevent duplicates
- Voting status tracking
  - Mark voters as having voted via checkbox
  - Visual feedback with green checkmark and strikethrough text
  - Toggle voting status
- Search functionality
  - Real-time search as you type
  - Search by PK-Number, Last Name, or First Name
  - Clear button to reset search
- Statistics dashboard
  - Total voters count
  - Voted count
  - Pending (not voted) count
  - Color-coded cards (Blue, Green, Orange)
- SQLite database for local data persistence
- Provider-based state management
- Material Design 3 UI
  - Clean and modern interface
  - Responsive layout
  - Intuitive dialogs and snackbars
- Cross-platform support
  - Android
  - iOS
  - Web
  - Desktop (Windows, macOS, Linux)
- Testing infrastructure
  - Unit tests for Voter model
  - Widget tests for main app components
- Comprehensive documentation
  - README with installation instructions
  - ARCHITECTURE document with technical details
  - FEATURES document with checklist and roadmap
  - QUICKSTART guide for developers and users
  - SAMPLE_DATA with example voters
- MIT License

### Technical Details
- Flutter SDK >=3.0.0
- Dependencies:
  - sqflite: ^2.3.0 (SQLite database)
  - provider: ^6.0.5 (State management)
  - path: ^1.8.3 (Path utilities)
  - cupertino_icons: ^1.0.2 (iOS icons)
- Dev Dependencies:
  - flutter_lints: ^2.0.0 (Linting)

## [Unreleased]

### Planned Features
- Central data storage
  - Firebase Firestore integration
  - REST API backend option
  - Real-time synchronization across multiple devices
- Import/Export functionality
  - CSV import of voter lists
  - CSV/PDF export of results
- User authentication and role management
- QR code scanner for quick voter identification
- Audit logging
- Enhanced statistics and reporting
- Multi-language support
- Dark mode
- Accessibility improvements
- Offline mode with sync capabilities

---

## Version History

- **1.0.0** (2025-10-15): Initial release with core functionality
