# WahlApp - Visual Guide

## App Flow Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    WahlApp Start                        │
└───────────────────────┬─────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│              Wählerverzeichnis Screen                   │
│  ┌───────────────────────────────────────────────────┐  │
│  │ Suchen: [________________________] 🔍 [x]        │  │
│  └───────────────────────────────────────────────────┘  │
│  ┌─────────────┐ ┌─────────────┐ ┌──────────────┐     │
│  │  Gesamt     │ │   Gewählt   │ │  Ausstehend  │     │
│  │     20      │ │      8      │ │      12      │     │
│  │   (blau)    │ │   (grün)    │ │   (orange)   │     │
│  └─────────────┘ └─────────────┘ └──────────────┘     │
│  ────────────────────────────────────────────────────  │
│  ┌───────────────────────────────────────────────────┐  │
│  │ ✓ Müller, Hans                         [✓] ⋮     │  │
│  │   PK: 10001                                       │  │
│  ├───────────────────────────────────────────────────┤  │
│  │ ○ Schmidt, Anna                        [ ] ⋮     │  │
│  │   PK: 10002                                       │  │
│  ├───────────────────────────────────────────────────┤  │
│  │ ○ Weber, Thomas                        [ ] ⋮     │  │
│  │   PK: 10003                                       │  │
│  └───────────────────────────────────────────────────┘  │
│                                              [➕]        │
└─────────────────────────────────────────────────────────┘
```

## User Actions

### 1. Add Voter
```
Click [➕] Button
    ↓
┌─────────────────────────────┐
│   Wähler hinzufügen         │
├─────────────────────────────┤
│ PK-Nummer: [__________]     │
│ Nachname:  [__________]     │
│ Vorname:   [__________]     │
├─────────────────────────────┤
│ [Abbrechen] [Hinzufügen]    │
└─────────────────────────────┘
    ↓
Voter added to list
```

### 2. Mark as Voted
```
Click Checkbox [ ]
    ↓
Status Changes:
- [ ] → [✓]
- ○ → ✓ (Avatar)
- Normal → Strikethrough (Name)
- Grey → Green (Avatar color)
    ↓
Statistics Updated:
- Gewählt: +1
- Ausstehend: -1
```

### 3. Search Voter
```
Type in Search Field
    ↓
┌──────────────────────────┐
│ Suchen: [Müller___] 🔍   │
└──────────────────────────┘
    ↓
List Filtered in Real-time:
- Shows only matching voters
- Search in: PK, LastName, FirstName
```

### 4. Delete Voter
```
Click [⋮] Menu → Löschen
    ↓
┌─────────────────────────────┐
│   Wähler löschen            │
├─────────────────────────────┤
│ Möchten Sie Hans Müller     │
│ wirklich löschen?           │
├─────────────────────────────┤
│ [Abbrechen] [Löschen]       │
└─────────────────────────────┘
    ↓
Voter removed from list
```

## Data Flow

```
┌──────────────┐
│   UI Layer   │
│ (Screens)    │
└──────┬───────┘
       │
       │ User Actions
       ▼
┌──────────────┐
│  Provider    │
│ (State Mgmt) │
└──────┬───────┘
       │
       │ Business Logic
       ▼
┌──────────────┐
│  Database    │
│  Service     │
└──────┬───────┘
       │
       │ SQL Queries
       ▼
┌──────────────┐
│   SQLite     │
│  Database    │
└──────────────┘
```

## State Management Flow

```
User Action → Provider.method()
                  ↓
            Update Database
                  ↓
            Update State (_voters)
                  ↓
            notifyListeners()
                  ↓
            UI Rebuilds
                  ↓
            User Sees Update
```

## Color Coding

| Element | Color | Meaning |
|---------|-------|---------|
| Avatar (✓) | Green | Has voted |
| Avatar (○) | Grey | Not voted yet |
| Gesamt Card | Blue | Total count |
| Gewählt Card | Green | Voted count |
| Ausstehend Card | Orange | Pending count |

## Icons Guide

| Icon | Meaning |
|------|---------|
| ➕ | Add new voter |
| 🔍 | Search |
| ✕ | Clear search |
| ✓ | Has voted |
| ○ | Not voted |
| ⋮ | More options menu |
| ❌ | Delete (in menu) |
| ✓ (checkbox) | Mark/Unmark as voted |

## Screen States

### Empty State
```
┌─────────────────────────────┐
│                             │
│       👥 (grey icon)        │
│                             │
│   Keine Wähler vorhanden    │
│                             │
│        [➕ to add]          │
└─────────────────────────────┘
```

### No Search Results
```
┌─────────────────────────────┐
│ Suchen: [xyz___] 🔍 [x]     │
├─────────────────────────────┤
│       👥 (grey icon)        │
│                             │
│   Keine Wähler gefunden     │
│                             │
└─────────────────────────────┘
```

### Loading State
```
┌─────────────────────────────┐
│                             │
│         ⏳ Loading...        │
│    (CircularProgress)       │
│                             │
└─────────────────────────────┘
```

## Database Schema

```sql
Table: voters
┌────────────┬──────────┬───────────┬─────────┐
│   Field    │   Type   │ Nullable  │  Key    │
├────────────┼──────────┼───────────┼─────────┤
│ id         │ INTEGER  │ NO        │ PRIMARY │
│ pkNumber   │ TEXT     │ NO        │ UNIQUE  │
│ lastName   │ TEXT     │ NO        │         │
│ firstName  │ TEXT     │ NO        │         │
│ hasVoted   │ INTEGER  │ NO        │         │
└────────────┴──────────┴───────────┴─────────┘

Indexes:
- PRIMARY KEY: id (auto-increment)
- UNIQUE: pkNumber (prevents duplicates)

Default Values:
- hasVoted: 0 (false)
```

## Example Data

```
id │ pkNumber │ lastName │ firstName │ hasVoted
───┼──────────┼──────────┼───────────┼─────────
 1 │ 10001    │ Müller   │ Hans      │ 1
 2 │ 10002    │ Schmidt  │ Anna      │ 0
 3 │ 10003    │ Weber    │ Thomas    │ 0
 4 │ 10004    │ Fischer  │ Maria     │ 1
```

## Responsive Design

The app is responsive and works on:
- 📱 Small screens (phones): Single column list
- 📱 Medium screens (tablets): Wider cards
- 💻 Large screens (desktop): Full width with margins

## Keyboard Shortcuts (Desktop)

While not implemented yet, potential shortcuts:
- Ctrl+F: Focus search
- Ctrl+N: New voter
- Enter: Confirm dialog
- Esc: Close dialog

## Platform-Specific Features

| Platform | Storage Location | Database Path |
|----------|------------------|---------------|
| Android | /data/data/com.example.wahlapp/databases/ | voters.db |
| iOS | Application Documents Directory | voters.db |
| Web | IndexedDB (via sqflite_web) | voters.db |
| Windows | %APPDATA%/wahlapp/databases/ | voters.db |
| macOS | ~/Library/Application Support/wahlapp/ | voters.db |
| Linux | ~/.local/share/wahlapp/ | voters.db |
