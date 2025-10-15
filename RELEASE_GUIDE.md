# Release-Anleitung für WahlApp

## Voraussetzungen

Diese Anleitung erklärt, wie du einen neuen Release mit der Windows-App erstellst.

## Automatischer Build-Prozess

Die Windows-App wird automatisch über GitHub Actions gebaut, sobald du einen neuen Tag/Release erstellst.

## Schritt-für-Schritt Anleitung

### 1. Änderungen committen und pushen

Stelle sicher, dass alle Änderungen committed und gepusht sind:

```bash
git add .
git commit -m "Deine Commit-Nachricht"
git push origin main
```

### 2. Version in pubspec.yaml aktualisieren (optional)

Öffne `pubspec.yaml` und aktualisiere die Versionsnummer:

```yaml
version: 1.0.1+2  # Format: X.Y.Z+Build-Nummer
```

Committe die Änderung:

```bash
git add pubspec.yaml
git commit -m "Version bump to 1.0.1"
git push origin main
```

### 3. Tag erstellen und pushen

Erstelle einen Git-Tag für die neue Version:

```bash
# Tag erstellen
git tag -a v1.0.0 -m "Release Version 1.0.0 - Erste Windows-Version"

# Tag zu GitHub pushen
git push origin v1.0.0
```

### 4. Warte auf den automatischen Build

1. Gehe zu deinem GitHub-Repository
2. Klicke auf den Tab "Actions"
3. Du solltest den Workflow "Windows Release" sehen, der gerade läuft
4. Warte, bis der Build abgeschlossen ist (ca. 5-10 Minuten)

### 5. Release überprüfen

1. Gehe zu: https://github.com/L3g0M4n14c/WahlApp/releases
2. Der neue Release sollte automatisch erstellt worden sein
3. Die Datei `WahlApp-Windows.zip` sollte als Download verfügbar sein

## Manueller Release (falls automatisch fehlschlägt)

### 1. Windows-App lokal bauen

Auf einem Windows-Computer:

```bash
# Flutter für Windows aktivieren
flutter config --enable-windows-desktop

# Dependencies installieren
flutter pub get

# Release-Build erstellen
flutter build windows --release
```

### 2. ZIP-Archiv erstellen

Die fertigen Dateien befinden sich in:
```
build\windows\x64\runner\Release\
```

Erstelle ein ZIP-Archiv mit allen Dateien aus diesem Ordner und nenne es `WahlApp-Windows.zip`.

### 3. Manuellen Release auf GitHub erstellen

1. Gehe zu: https://github.com/L3g0M4n14c/WahlApp/releases/new
2. Wähle den Tag (z.B. `v1.0.0`) oder erstelle einen neuen
3. Gib einen Release-Titel ein (z.B. "WahlApp v1.0.0")
4. Füge Release-Notes hinzu:

```markdown
## Was ist neu

- Erste Windows-Version
- CSV-Import Funktionalität
- Lokale SQLite-Datenbank
- Wählerverwaltung mit Suchfunktion

## Download

- Lade `WahlApp-Windows.zip` herunter
- Entpacke die Datei
- Führe `wahlapp.exe` aus

Siehe [WINDOWS_INSTALLATION.md](WINDOWS_INSTALLATION.md) für Details.
```

5. Lade `WahlApp-Windows.zip` hoch (Drag & Drop in den Asset-Bereich)
6. Klicke auf "Publish release"

## Workflow manuell auslösen

Du kannst den Build-Workflow auch ohne Tag manuell starten:

1. Gehe zu: https://github.com/L3g0M4n14c/WahlApp/actions
2. Wähle "Windows Release" in der linken Seitenleiste
3. Klicke auf "Run workflow" (rechts)
4. Wähle den Branch (normalerweise `main`)
5. Klicke auf den grünen "Run workflow" Button

Der Build wird erstellt, aber es wird KEIN automatischer Release erstellt. Du findest die `WahlApp-Windows.zip` unter den Workflow-Artefakten (90 Tage Aufbewahrung).

## Versionierungs-Schema

Wir verwenden [Semantic Versioning](https://semver.org/):

- **MAJOR** (1.x.x): Inkompatible API-Änderungen
- **MINOR** (x.1.x): Neue Funktionen, abwärtskompatibel
- **PATCH** (x.x.1): Bugfixes, abwärtskompatibel

Beispiele:
- `v1.0.0` - Erste stabile Version
- `v1.1.0` - Neue Features hinzugefügt
- `v1.1.1` - Bugfix
- `v2.0.0` - Breaking Changes

## Troubleshooting

### Build schlägt fehl

1. Überprüfe die Logs in GitHub Actions
2. Stelle sicher, dass die App lokal mit `flutter build windows` funktioniert
3. Überprüfe, ob alle Dependencies in `pubspec.yaml` korrekt sind

### Release wird nicht erstellt

1. Stelle sicher, dass der Tag mit `v` beginnt (z.B. `v1.0.0`)
2. Überprüfe, ob `GITHUB_TOKEN` Permissions hat (sollte automatisch der Fall sein)
3. Überprüfe die Workflow-Datei `.github/workflows/windows-release.yml`

## Nächste Schritte

Nach dem ersten Release kannst du:

1. Den Release-Link in der README.md verbreiten
2. macOS und iOS Builds hinzufügen (ähnlicher Workflow)
3. Automatische Updates implementieren
4. Code-Signing für Windows einrichten (für weniger Sicherheitswarnungen)
