# WahlApp
App zum Abhaken von Wählern bei der Betriebsratswahl

## Beschreibung

WahlApp ist eine plattformübergreifende Flutter-Anwendung zur Verwaltung von Wählern bei einer Betriebsratswahl. Die App ermöglicht es, wahlberechtigte Personen zu verwalten und zu markieren, wenn sie gewählt haben.

## Funktionen

- ✅ Verwaltung von Wählern mit PK-Nummer, Nachname und Vorname
- ✅ Abhaken von Wählern, die bereits gewählt haben
- ✅ Suchfunktion nach PK-Nummer, Nachname oder Vorname
- ✅ Statistik-Übersicht (Gesamt, Gewählt, Ausstehend)
- ✅ **CSV-Import**: Massenimport von Wählerdaten aus CSV-Dateien
- ✅ Lokale Datenspeicherung mit SQLite
- ✅ Plattformübergreifend (Android, iOS, Web, Desktop)

## Voraussetzungen

- Flutter SDK (>=3.0.0)
- Dart SDK
- Ein Code-Editor (z.B. VS Code, Android Studio)

## Installation

1. Repository klonen:
```bash
git clone https://github.com/L3g0M4n14c/WahlApp.git
cd WahlApp
```

2. Dependencies installieren:
```bash
flutter pub get
```

3. App starten:
```bash
flutter run
```

## Verwendung

### Wähler hinzufügen
1. Klicken Sie auf das Plus-Symbol (➕) unten rechts
2. Geben Sie PK-Nummer, Nachname und Vorname ein
3. Klicken Sie auf "Hinzufügen"

### Wähler abhaken
- Aktivieren Sie die Checkbox neben einem Wähler, um zu markieren, dass dieser gewählt hat
- Der Wähler wird mit einem grünen Haken versehen und durchgestrichen

### Wähler suchen
- Verwenden Sie das Suchfeld oben, um nach PK-Nummer, Nachname oder Vorname zu suchen
- Die Liste wird automatisch gefiltert

### Wähler löschen
1. Klicken Sie auf das Menü-Symbol (⋮) neben einem Wähler
2. Wählen Sie "Löschen"
3. Bestätigen Sie die Löschung

### CSV-Import von Wählerdaten
1. Klicken Sie auf das Upload-Symbol (↑) in der App-Leiste
2. Wählen Sie Ihre CSV-Datei aus
3. Warten Sie auf die Importbestätigung

**CSV-Format:**
```csv
PK-Nummer,Nachname,Vorname
12345,Müller,Hans
23456,Schmidt,Anna
```

Weitere Details finden Sie in der [CSV-Import Anleitung](CSV_IMPORT_GUIDE.md).

## Datenspeicherung

Die App verwendet SQLite für die lokale Datenspeicherung. Die Datenbank wird automatisch beim ersten Start der App erstellt.

**Hinweis:** Für eine zentrale Datenspeicherung über mehrere Wahlbüros hinweg ist eine zusätzliche Backend-Integration erforderlich (z.B. mit Firebase, einer REST-API oder einem anderen Cloud-Dienst). Die aktuelle Version speichert Daten nur lokal auf dem Gerät.

## Projekt-Struktur

```
lib/
  ├── models/
  │   └── voter.dart             # Datenmodell für Wähler
  ├── services/
  │   ├── database_service.dart  # SQLite Datenbankdienst
  │   ├── voter_provider.dart    # State Management mit Provider
  │   └── csv_import_service.dart # CSV-Import-Funktionalität
  ├── screens/
  │   └── voter_list_screen.dart # Hauptbildschirm mit Wählerliste
  └── main.dart                  # App-Einstiegspunkt
```

## Technologien

- **Flutter**: UI-Framework
- **Provider**: State Management
- **SQLite**: Lokale Datenbank
- **CSV**: CSV-Datei-Import
- **File Picker**: Dateiauswahl-Dialog
- **Material Design 3**: UI-Komponenten

## Lizenz

Dieses Projekt steht unter der MIT-Lizenz.

## Beitragen

Beiträge sind willkommen! Bitte erstellen Sie einen Pull Request oder öffnen Sie ein Issue für Vorschläge und Fehlerberichte.
