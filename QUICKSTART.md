# WahlApp - Schnellstart-Anleitung

## Für Entwickler

### 1. Voraussetzungen installieren

```bash
# Flutter SDK installieren (Version >=3.0.0)
# Siehe: https://flutter.dev/docs/get-started/install

# Überprüfen Sie die Installation
flutter doctor
```

### 2. Projekt einrichten

```bash
# Repository klonen
git clone https://github.com/L3g0M4n14c/WahlApp.git
cd WahlApp

# Dependencies installieren
flutter pub get
```

### 3. App starten

```bash
# Auf einem verbundenen Gerät oder Emulator
flutter run

# Oder für Web
flutter run -d chrome

# Oder für Desktop (Windows)
flutter run -d windows

# Oder für Desktop (macOS)
flutter run -d macos

# Oder für Desktop (Linux)
flutter run -d linux
```

### 4. Tests ausführen

```bash
# Unit Tests
flutter test

# Widget Tests
flutter test test/widget_test.dart

# Spezifische Tests
flutter test test/voter_model_test.dart
```

### 5. App bauen

```bash
# Android APK
flutter build apk

# iOS App
flutter build ios

# Web App
flutter build web

# Windows Desktop
flutter build windows

# macOS Desktop
flutter build macos

# Linux Desktop
flutter build linux
```

## Für Wahlhelfer (Benutzer)

### App-Start

1. Öffnen Sie die WahlApp auf Ihrem Gerät
2. Die App zeigt eine leere Wählerliste (beim ersten Start)

### Wähler hinzufügen

1. Tippen Sie auf das **Plus-Symbol** (➕) unten rechts
2. Geben Sie ein:
   - **PK-Nummer**: z.B. "10001"
   - **Nachname**: z.B. "Müller"
   - **Vorname**: z.B. "Hans"
3. Tippen Sie auf **"Hinzufügen"**
4. Der Wähler erscheint in der Liste

### Wähler als "gewählt" markieren

1. Suchen Sie den Wähler in der Liste
2. Tippen Sie auf die **Checkbox** rechts neben dem Namen
3. Der Wähler wird mit einem **grünen Haken** versehen
4. Der Name wird **durchgestrichen**

### Wähler suchen

1. Tippen Sie in das **Suchfeld** oben
2. Geben Sie ein:
   - PK-Nummer (z.B. "10001")
   - Nachname (z.B. "Müller")
   - Vorname (z.B. "Hans")
3. Die Liste filtert automatisch
4. Tippen Sie auf das **X** im Suchfeld zum Zurücksetzen

### Statistiken ansehen

Oben im Bildschirm sehen Sie drei Karten:
- **Gesamt** (blau): Anzahl aller registrierten Wähler
- **Gewählt** (grün): Anzahl der Wähler, die bereits gewählt haben
- **Ausstehend** (orange): Anzahl der Wähler, die noch nicht gewählt haben

### Wähler löschen

1. Tippen Sie auf das **Drei-Punkte-Menü** (⋮) rechts neben einem Wähler
2. Wählen Sie **"Löschen"**
3. Bestätigen Sie die Löschung

## Tipps für die Wahl

### Vorbereitung

1. **Testen Sie die App** mit Beispieldaten vor dem Wahltag
2. **Laden Sie alle Wähler** rechtzeitig in die App
3. **Stellen Sie sicher**, dass alle Geräte geladen sind
4. **Machen Sie Backups** der Datenbank (falls möglich)

### Am Wahltag

1. **Wähler identifizieren**:
   - Nutzen Sie die Suchfunktion
   - Suchen Sie nach PK-Nummer oder Namen

2. **Schnelles Abhaken**:
   - Suchen → Checkbox aktivieren → Fertig
   - Achten Sie auf den grünen Haken zur Bestätigung

3. **Bei Problemen**:
   - Wähler nicht gefunden? → Überprüfen Sie die Schreibweise
   - Wähler bereits abgehakt? → Grüner Haken ist sichtbar
   - Doppelte PK-Nummer? → System verhindert automatisch Duplikate

4. **Statistiken nutzen**:
   - Behalten Sie die Wahlbeteiligung im Blick
   - "Ausstehend" zeigt, wie viele noch nicht gewählt haben

## Häufige Fragen (FAQ)

### Kann ich einen Wähler "zurücksetzen" (als nicht gewählt markieren)?

Ja! Tippen Sie einfach erneut auf die Checkbox. Der Haken wird entfernt.

### Was passiert, wenn ich versehentlich einen Wähler lösche?

Sie müssen den Wähler erneut hinzufügen. Es gibt derzeit keine Undo-Funktion.

### Kann ich die Daten exportieren?

Aktuell nicht direkt in der App. Entwickler können die SQLite-Datenbank exportieren.

### Funktioniert die App ohne Internet?

Ja! Die App speichert alle Daten lokal und benötigt keine Internetverbindung.

### Wie synchronisiere ich Daten zwischen mehreren Geräten?

In der aktuellen Version ist dies nicht möglich. Jedes Gerät hat seine eigene Datenbank. Für eine zentrale Lösung über mehrere Wahlbüros wird ein Backend benötigt (siehe FEATURES.md für geplante Erweiterungen).

### Sind die Daten sicher?

Die Daten werden lokal auf dem Gerät gespeichert. Schützen Sie das Gerät mit einem Passwort/PIN.

## Support

Bei Fragen oder Problemen:
1. Konsultieren Sie die [README.md](README.md)
2. Lesen Sie die [ARCHITECTURE.md](ARCHITECTURE.md) für technische Details
3. Öffnen Sie ein Issue auf GitHub

## Schnellreferenz

| Aktion | Wie |
|--------|-----|
| Wähler hinzufügen | ➕ Button |
| Wähler abhaken | ✓ Checkbox |
| Wähler suchen | 🔍 Suchfeld |
| Wähler löschen | ⋮ Menü → Löschen |
| Suche löschen | ✕ im Suchfeld |
| Statistik sehen | Karten oben |
