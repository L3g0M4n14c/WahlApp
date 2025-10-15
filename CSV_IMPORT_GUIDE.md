# CSV-Import Funktion

## Übersicht
Die WahlApp unterstützt jetzt den Import von Wählerdaten aus CSV-Dateien.

## Verwendung

### 1. CSV-Datei vorbereiten
Erstellen Sie eine CSV-Datei mit folgendem Format:

```csv
PK-Nummer,Nachname,Vorname
12345,Müller,Hans
23456,Schmidt,Anna
34567,Wagner,Peter
```

### 2. Anforderungen
- **Spalten**: Die Datei muss mindestens 3 Spalten enthalten:
  1. PK-Nummer
  2. Nachname
  3. Vorname
- **Trennzeichen**: Komma (`,`)
- **Kodierung**: UTF-8 (empfohlen)
- **Header**: Optional - die erste Zeile kann ein Header sein oder direkt Daten enthalten

### 3. Import durchführen
1. Öffnen Sie die WahlApp
2. Klicken Sie auf das Upload-Symbol (↑) in der oberen rechten Ecke
3. Wählen Sie Ihre CSV-Datei aus
4. Warten Sie auf die Importbestätigung

### 4. Import-Ergebnis
Nach dem Import erhalten Sie eine Zusammenfassung:
- ✓ Anzahl erfolgreich importierter Wähler
- ⊘ Anzahl übersprungener Zeilen (leere Zeilen)
- ✗ Anzahl der Fehler mit Details

## Beispieldatei
Eine Beispiel-CSV-Datei finden Sie unter `sample_voters.csv` im Projektverzeichnis.

## Hinweise

### Duplikate
- Wenn eine PK-Nummer bereits existiert, wird der Datensatz übersprungen
- Sie erhalten eine Fehlermeldung für jeden Duplikat-Versuch

### Leere Zeilen
- Leere Zeilen werden automatisch übersprungen
- Diese werden in der Zusammenfassung gezählt

### Fehlerbehandlung
- Bei Fehlern werden die ersten 10 Fehler im Detail angezeigt
- Der Import wird fortgesetzt, auch wenn einzelne Zeilen Fehler enthalten
- Erfolgreich importierte Datensätze bleiben erhalten

### Datenvalidierung
- Alle drei Felder (PK-Nummer, Nachname, Vorname) müssen ausgefüllt sein
- Leere Felder führen zu einer Fehlermeldung für diese Zeile

## Technische Details

### Unterstützte Formate
- `.csv` Dateien
- Komma-separierte Werte
- Text in Anführungszeichen erlaubt (z.B. `"Müller, GmbH",Hans,Peter`)

### Verwendete Packages
- `csv: ^6.0.0` - CSV-Parser
- `file_picker: ^8.0.0` - Dateiauswahl-Dialog

### Dateispeicherort
Die importierten Daten werden in der SQLite-Datenbank gespeichert:
- Datei: `voters.db`
- Speicherort: App-spezifisches Datenverzeichnis

## Tipps für Excel-Nutzer

### CSV aus Excel exportieren
1. Öffnen Sie Ihre Excel-Datei
2. Gehen Sie zu "Datei" → "Speichern unter"
3. Wählen Sie als Dateityp "CSV (Komma getrennt) (*.csv)"
4. Speichern Sie die Datei

### Spalten richtig anlegen
| A: PK-Nummer | B: Nachname | C: Vorname |
|--------------|-------------|------------|
| 12345        | Müller      | Hans       |
| 23456        | Schmidt     | Anna       |

## Fehlerbehebung

### Problem: "Keine Datei ausgewählt"
- **Lösung**: Stellen Sie sicher, dass Sie eine Datei ausgewählt haben

### Problem: "CSV-Datei ist leer"
- **Lösung**: Überprüfen Sie, ob die Datei Daten enthält

### Problem: "Nicht genügend Spalten"
- **Lösung**: Stellen Sie sicher, dass jede Zeile mindestens 3 Spalten hat

### Problem: "PK-Nummer bereits vorhanden"
- **Lösung**: Diese PK-Nummer existiert bereits in der Datenbank
- Sie können den vorhandenen Eintrag löschen oder eine andere PK-Nummer verwenden

## Sicherheit

### Datenüberprüfung
- Alle Daten werden vor dem Import validiert
- Ungültige Zeilen werden übersprungen
- Die Datenbank-Integrität bleibt erhalten

### Backup-Empfehlung
Es wird empfohlen, vor großen Importen ein Backup der Datenbank zu erstellen.
