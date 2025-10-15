# Windows Installation

## Download und Installation

### Option 1: Release herunterladen (Empfohlen)

1. Gehe zu den [Releases](https://github.com/L3g0M4n14c/WahlApp/releases)
2. Lade die neueste Version von `WahlApp-Windows.zip` herunter
3. Entpacke die ZIP-Datei in einen Ordner deiner Wahl (z.B. `C:\Programme\WahlApp`)
4. Führe `wahlapp.exe` aus dem entpackten Ordner aus

### Option 2: Manuell bauen

Wenn du die App selbst kompilieren möchtest:

#### Voraussetzungen
- Flutter SDK (3.0.0 oder höher)
- Visual Studio 2022 mit "Desktop development with C++" Workload

#### Build-Schritte

1. Repository klonen:
```bash
git clone https://github.com/L3g0M4n14c/WahlApp.git
cd WahlApp
```

2. Windows-Desktop aktivieren:
```bash
flutter config --enable-windows-desktop
```

3. Dependencies installieren:
```bash
flutter pub get
```

4. Windows-App bauen:
```bash
flutter build windows --release
```

5. Die fertige App findest du in:
```
build\windows\x64\runner\Release\
```

6. Starte die App:
```bash
cd build\windows\x64\runner\Release
wahlapp.exe
```

## Systemanforderungen

- **Betriebssystem:** Windows 10 (64-bit) oder höher
- **RAM:** Mindestens 4 GB
- **Festplattenspeicher:** Ca. 150 MB

## Erste Schritte

Nach dem ersten Start der App:

1. Die App erstellt automatisch eine lokale Datenbank
2. Du kannst über den Import-Button CSV-Dateien mit Wählerdaten importieren
3. Die Daten werden lokal auf deinem Computer gespeichert

## Datenspeicherung

Die App speichert alle Daten lokal in einer SQLite-Datenbank unter:
```
%APPDATA%\wahlapp\
```

## Fehlerbehebung

### Die App startet nicht
- Stelle sicher, dass du Windows 10 (64-bit) oder höher verwendest
- Überprüfe, ob alle Dateien aus der ZIP extrahiert wurden
- Führe die App als Administrator aus

### CSV-Import funktioniert nicht
- Überprüfe das Format deiner CSV-Datei (siehe [CSV_IMPORT_GUIDE.md](CSV_IMPORT_GUIDE.md))
- Stelle sicher, dass die CSV-Datei UTF-8 kodiert ist

## Support

Bei Problemen oder Fragen öffne bitte ein Issue auf GitHub:
https://github.com/L3g0M4n14c/WahlApp/issues
