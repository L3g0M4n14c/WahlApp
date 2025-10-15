# Contributing to WahlApp

Thank you for your interest in contributing to WahlApp! This document provides guidelines for contributing to the project.

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Keep discussions relevant to the project

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue with:
- A clear, descriptive title
- Steps to reproduce the bug
- Expected behavior
- Actual behavior
- Screenshots (if applicable)
- Your environment (OS, Flutter version, etc.)

### Suggesting Features

Feature suggestions are welcome! Please open an issue with:
- A clear description of the feature
- The problem it solves
- How it would work from a user's perspective
- Any relevant mockups or examples

### Code Contributions

1. **Fork the repository**
   ```bash
   git clone https://github.com/L3g0M4n14c/WahlApp.git
   cd WahlApp
   ```

2. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bug-fix
   ```

3. **Make your changes**
   - Follow the existing code style
   - Add tests for new functionality
   - Update documentation if needed
   - Ensure all tests pass

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "Description of changes"
   ```
   
   Use clear commit messages:
   - `feat: Add QR code scanner`
   - `fix: Resolve search filter issue`
   - `docs: Update README with new features`
   - `test: Add tests for voter deletion`

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Open a Pull Request**
   - Describe what your PR does
   - Reference any related issues
   - Add screenshots for UI changes

## Development Setup

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Git
- A code editor (VS Code, Android Studio, IntelliJ IDEA)

### Getting Started
```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/WahlApp.git
cd WahlApp

# Install dependencies
flutter pub get

# Run tests
flutter test

# Run the app
flutter run
```

## Code Style

### Dart/Flutter Guidelines
- Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide
- Use `flutter analyze` to check for issues
- Format code with `dart format .`

### Project Structure
```
lib/
  ├── models/       # Data models
  ├── services/     # Business logic and data services
  ├── screens/      # UI screens
  └── main.dart     # App entry point
```

### Naming Conventions
- **Files**: lowercase_with_underscores.dart
- **Classes**: PascalCase
- **Variables**: camelCase
- **Constants**: SCREAMING_SNAKE_CASE
- **Private members**: _prefixWithUnderscore

## Testing

### Writing Tests
- Add unit tests for all models and services
- Add widget tests for UI components
- Ensure tests are meaningful and maintainable

### Running Tests
```bash
# All tests
flutter test

# Specific test file
flutter test test/voter_model_test.dart

# With coverage
flutter test --coverage
```

## Documentation

- Update README.md for user-facing changes
- Update ARCHITECTURE.md for architectural changes
- Add inline comments for complex logic
- Update CHANGELOG.md with your changes

## Pull Request Process

1. Ensure your code passes all tests
2. Update documentation as needed
3. Add a clear description to your PR
4. Link any related issues
5. Wait for review and address feedback
6. Once approved, your PR will be merged

## Questions?

If you have questions:
- Check existing issues and documentation
- Open a new issue with the "question" label
- Be specific about what you need help with

## License

By contributing to WahlApp, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to WahlApp! 🎉
