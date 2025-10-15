# WahlApp - Architektur und Implementation

## Übersicht

WahlApp ist eine Flutter-Anwendung zur Verwaltung von Wählern bei einer Betriebsratswahl. Die App ermöglicht das Erfassen, Suchen und Abhaken von Wählern.

## Architektur

### Schichtenmodell

```
┌─────────────────────────────────────┐
│   Presentation Layer (UI)           │
│   - VoterListScreen                 │
│   - Dialoge (Add, Delete)           │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│   Business Logic Layer              │
│   - VoterProvider (State Management)│
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│   Data Layer                        │
│   - DatabaseService (SQLite)        │
│   - Voter Model                     │
└─────────────────────────────────────┘
```

## Komponenten

### 1. Datenmodell (`lib/models/voter.dart`)

**Voter-Klasse:**
- `id`: Eindeutige Datenbank-ID (optional, wird bei Erstellung gesetzt)
- `pkNumber`: Personalkennzahl (PK-Nummer) - eindeutig
- `lastName`: Nachname des Wählers
- `firstName`: Vorname des Wählers
- `hasVoted`: Boolean-Flag, ob der Wähler bereits gewählt hat

**Methoden:**
- `toMap()`: Konvertiert Voter-Objekt in Map für Datenbank
- `fromMap()`: Erstellt Voter-Objekt aus Datenbank-Map
- `copyWith()`: Erstellt Kopie mit geänderten Feldern

### 2. Datenbankservice (`lib/services/database_service.dart`)

**DatabaseService:**
Singleton-Klasse für SQLite-Datenbankoperationen

**Funktionen:**
- `createVoter()`: Fügt neuen Wähler hinzu
- `getAllVoters()`: Lädt alle Wähler (sortiert nach Nachname, Vorname)
- `searchVoters()`: Sucht Wähler nach PK-Nummer, Name oder Vorname
- `updateVoter()`: Aktualisiert Wähler-Daten
- `deleteVoter()`: Löscht Wähler

**Datenbankschema:**
```sql
CREATE TABLE voters (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  pkNumber TEXT NOT NULL UNIQUE,
  lastName TEXT NOT NULL,
  firstName TEXT NOT NULL,
  hasVoted INTEGER NOT NULL DEFAULT 0
)
```

### 3. State Management (`lib/services/voter_provider.dart`)

**VoterProvider:**
ChangeNotifier für Zustandsverwaltung mit Provider-Pattern

**Zustandsvariablen:**
- `_voters`: Komplette Wählerliste
- `_filteredVoters`: Gefilterte Wählerliste (nach Suche)
- `_isLoading`: Ladezustand
- `_searchQuery`: Aktueller Suchtext

**Getter:**
- `totalVoters`: Gesamtzahl der Wähler
- `votedCount`: Anzahl der Wähler, die gewählt haben
- `notVotedCount`: Anzahl der ausstehenden Wähler

**Methoden:**
- `loadVoters()`: Lädt Wähler aus Datenbank
- `searchVoters()`: Filtert Wählerliste
- `toggleVoted()`: Ändert Wahlstatus
- `addVoter()`: Fügt neuen Wähler hinzu
- `deleteVoter()`: Entfernt Wähler

### 4. Benutzeroberfläche (`lib/screens/voter_list_screen.dart`)

**VoterListScreen:**
Hauptbildschirm der Anwendung

**UI-Komponenten:**

1. **AppBar**: Zeigt Titel "Wählerverzeichnis"

2. **Suchfeld**: 
   - Echtzeit-Filterung
   - Suche nach PK-Nummer, Nachname, Vorname
   - Clear-Button zum Zurücksetzen

3. **Statistik-Karten**:
   - Gesamt (blau)
   - Gewählt (grün)
   - Ausstehend (orange)

4. **Wählerliste**:
   - Avatar mit Status-Icon (✓ = gewählt)
   - Name (durchgestrichen wenn gewählt)
   - PK-Nummer
   - Checkbox zum Abhaken
   - Menü zum Löschen

5. **FloatingActionButton**:
   - Plus-Symbol zum Hinzufügen von Wählern
   - Öffnet Dialog mit Formular

**Dialoge:**
- Add Voter Dialog: Formular für PK-Nummer, Nachname, Vorname
- Delete Confirmation: Bestätigung vor dem Löschen

### 5. App-Einstiegspunkt (`lib/main.dart`)

**MyApp:**
- Initialisiert Provider
- Konfiguriert MaterialApp
- Setzt Theme (Material Design 3)
- Lädt VoterListScreen als Startbildschirm

## Datenfluss

### Wähler laden:
```
VoterListScreen (initState)
    ↓
VoterProvider.loadVoters()
    ↓
DatabaseService.getAllVoters()
    ↓
SQLite Datenbank
    ↓
VoterProvider._voters aktualisiert
    ↓
UI wird neu gerendert (notifyListeners)
```

### Wähler abhaken:
```
User klickt Checkbox
    ↓
VoterProvider.toggleVoted(voter)
    ↓
DatabaseService.updateVoter(updatedVoter)
    ↓
VoterProvider._voters aktualisiert
    ↓
UI wird neu gerendert
```

### Suche:
```
User gibt Text ein
    ↓
VoterProvider.searchVoters(query)
    ↓
Filter auf _voters anwenden
    ↓
_filteredVoters aktualisiert
    ↓
UI zeigt gefilterte Liste
```

## Technologie-Stack

- **Flutter SDK**: Cross-Platform UI Framework
- **Dart**: Programmiersprache
- **SQLite (sqflite)**: Lokale Datenbank
- **Provider**: State Management
- **Material Design 3**: UI-Design-System

## Sicherheitsaspekte

1. **Eindeutige PK-Nummern**: UNIQUE Constraint verhindert Duplikate
2. **Transaktionssicherheit**: SQLite garantiert ACID-Eigenschaften
3. **Input-Validierung**: Prüfung auf leere Felder beim Hinzufügen

## Einschränkungen der aktuellen Version

1. **Nur lokale Speicherung**: Daten werden nur auf dem Gerät gespeichert
2. **Keine zentrale Synchronisation**: Mehrere Geräte können nicht synchronisiert werden
3. **Keine Authentifizierung**: Jeder mit Zugriff auf das Gerät kann Daten ändern
4. **Keine Audit-Logs**: Keine Protokollierung von Änderungen

## Erweiterungsmöglichkeiten

### Für zentrale Datenspeicherung:

1. **Firebase Firestore**:
   - Echtzeit-Synchronisation
   - Offline-Support
   - Automatische Konfliktlösung

2. **REST API + Backend**:
   - Eigener Server
   - Volle Kontrolle über Daten
   - Custom Business Logic

3. **Cloud SQL**:
   - Zentrale PostgreSQL/MySQL Datenbank
   - HTTP-Sync-Mechanismus

### Weitere Features:

- Benutzer-Authentifizierung
- Rollenverwaltung (Admin, Wahlhelfer)
- Export-Funktionen (CSV, PDF)
- Statistiken und Berichte
- Offline-Modus mit Sync
- QR-Code-Scanner für schnelle Identifikation
- Mehrsprachigkeit
- Barrierefreiheit

## Testing

### Unit Tests (`test/voter_model_test.dart`)
- Voter-Objekterstellung
- Map-Konvertierung
- copyWith-Funktion

### Widget Tests (`test/widget_test.dart`)
- UI-Komponenten vorhanden
- Basis-Funktionalität

## Installation und Ausführung

Siehe [README.md](README.md) für detaillierte Anweisungen.
