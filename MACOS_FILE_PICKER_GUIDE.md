# macOS Berechtigungen - Fehlerbehandlung

## Problem: "Keine Datei ausgewählt"

Wenn Sie beim CSV-Import die Fehlermeldung "Keine Datei ausgewählt" erhalten, liegt das wahrscheinlich an fehlenden macOS-Berechtigungen.

## Lösung

### ✅ Bereits implementiert

Die erforderlichen Berechtigungen wurden zu den Entitlements-Dateien hinzugefügt:
- `macos/Runner/DebugProfile.entitlements`
- `macos/Runner/Release.entitlements`

### 🔄 App neu starten

**WICHTIG**: Die App muss neu gestartet werden, damit die Berechtigungen wirksam werden:

1. Stoppen Sie die aktuell laufende App (Terminal: drücken Sie `q`)
2. Starten Sie die App neu:
   ```bash
   flutter run -d macos
   ```

### 📋 Schritt-für-Schritt Anleitung

#### 1. App stoppen
Im Terminal, wo die App läuft:
- Drücken Sie `q` oder `Ctrl+C`

#### 2. Cache löschen (optional, bei Problemen)
```bash
flutter clean
flutter pub get
```

#### 3. App neu starten
```bash
flutter run -d macos
```

### 🧪 CSV-Import testen

1. Öffnen Sie die App
2. Klicken Sie auf das Upload-Symbol (↑)
3. Im Datei-Dialog:
   - Navigieren Sie zum Projektordner
   - Wählen Sie `sample_voters.csv`
   - Klicken Sie "Öffnen"

### ⚙️ Was wurde geändert?

Die folgenden Berechtigungen wurden hinzugefügt:

```xml
<key>com.apple.security.files.user-selected.read-only</key>
<true/>
<key>com.apple.security.files.user-selected.read-write</key>
<true/>
```

Diese erlauben:
- ✅ Lesen von Dateien, die der Benutzer auswählt
- ✅ Schreiben von Dateien (für zukünftige Export-Funktionen)

### 🔍 Weitere Fehlerbehandlung

#### Dialog wird nicht angezeigt
**Ursache**: macOS blockiert den Dialog

**Lösung**:
1. Systemeinstellungen öffnen
2. "Sicherheit & Datenschutz"
3. "Dateien und Ordner"
4. Überprüfen Sie, ob WahlApp die Berechtigung hat

#### "Dateipfad konnte nicht ermittelt werden"
**Ursache**: App läuft im Web-Modus oder Sandbox-Problem

**Lösung**:
```bash
flutter run -d macos --release
```

#### FilePicker zeigt keine CSV-Dateien
**Ursache**: Dateifilter-Problem

**Lösung**: 
- Stellen Sie sicher, dass Ihre Datei die Endung `.csv` hat
- Im Datei-Dialog: Wählen Sie "Alle Dateien" aus dem Dropdown

### 🛠️ Debug-Informationen

Falls der Import immer noch nicht funktioniert, können Sie Debug-Ausgaben aktivieren:

```bash
flutter run -d macos -v
```

Achten Sie auf Fehlermeldungen bezüglich:
- File permissions
- Sandbox violations
- File picker errors

### 📱 Andere Plattformen

#### iOS
Ähnliche Berechtigungen sind erforderlich in `ios/Runner/Info.plist`:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Zum Import von CSV-Dateien</string>
```

#### Windows
Keine besonderen Berechtigungen erforderlich.

#### Android
Berechtigungen in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

### ✅ Erfolgreicher Import

Nach dem Neustart sollten Sie:
1. Den Datei-Dialog sehen
2. Dateien auswählen können
3. Eine Erfolgsmeldung erhalten

**Beispiel erfolgreicher Import:**
```
✓ 10 Wähler erfolgreich importiert
```

### 🆘 Support

Falls das Problem weiterhin besteht:

1. **Überprüfen Sie die Konsolenausgabe**:
   - Suchen Sie nach "permission denied"
   - Suchen Sie nach "sandbox violation"

2. **Testen Sie mit der Beispieldatei**:
   ```bash
   open sample_voters.csv
   ```
   
3. **Überprüfen Sie die Dateirechte**:
   ```bash
   ls -la sample_voters.csv
   ```

4. **Clean & Rebuild**:
   ```bash
   flutter clean
   flutter pub get
   flutter run -d macos
   ```

---

**Stand**: 15. Oktober 2025  
**Plattform**: macOS  
**Flutter SDK**: >=3.0.0
