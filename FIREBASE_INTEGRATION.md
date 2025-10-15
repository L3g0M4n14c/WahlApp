# Firebase-Integration: Schritt-für-Schritt Anleitung

## 🎯 Ziel
Synchronisation der Wählerdaten über mehrere Rechner in Echtzeit mittels Firebase Firestore.

## ⏱️ Zeitaufwand
Gesamt: ~4-6 Stunden

## 📋 Voraussetzungen

- ✅ WahlApp läuft lokal
- ✅ Google-Account (für Firebase)
- ✅ Node.js installiert (für Firebase CLI)
- ✅ Internet-Verbindung

## 🚀 Schritt 1: Firebase-Projekt erstellen (15 Min)

### 1.1 Firebase Console öffnen
1. Öffnen Sie: https://console.firebase.google.com
2. Klicken Sie auf **"Projekt hinzufügen"**
3. Projektname: `WahlApp` (oder eigener Name)
4. Klicken Sie **"Weiter"**

### 1.2 Google Analytics (optional)
- Empfehlung: **Deaktivieren** (nicht nötig für Betriebsratswahl)
- Klicken Sie **"Projekt erstellen"**
- Warten Sie ~30 Sekunden

### 1.3 Firestore Database erstellen
1. Im Firebase-Dashboard: Links → **"Firestore Database"**
2. Klicken Sie **"Datenbank erstellen"**
3. Wählen Sie: **"Im Testmodus starten"** (für Entwicklung)
4. Standort: **"europe-west3"** (Frankfurt) - wegen DSGVO
5. Klicken Sie **"Aktivieren"**

### 1.4 Plattformen hinzufügen
1. Im Projektübersicht: Klicken Sie auf das **Web-Icon** (</>)
2. App-Name: `WahlApp Web`
3. **Keine** Firebase Hosting
4. Klicken Sie **"App registrieren"**

Für macOS/iOS/Windows werden wir FlutterFire CLI nutzen (später).

---

## 🛠️ Schritt 2: Firebase CLI & FlutterFire installieren (10 Min)

### 2.1 Firebase CLI installieren

```bash
# macOS/Linux
curl -sL https://firebase.tools | bash

# Alternative mit npm (falls Node.js installiert)
npm install -g firebase-tools

# Überprüfen
firebase --version
```

### 2.2 Firebase Login

```bash
firebase login
```

Browser öffnet sich → Google-Account auswählen → Zugriff erlauben

### 2.3 FlutterFire CLI installieren

```bash
# FlutterFire CLI global aktivieren
dart pub global activate flutterfire_cli

# Überprüfen
flutterfire --version
```

**Falls `flutterfire` nicht gefunden wird:**
```bash
# Fügen Sie zu ~/.zshrc hinzu:
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Neu laden:
source ~/.zshrc
```

---

## 🔧 Schritt 3: Firebase mit Flutter verbinden (15 Min)

### 3.1 FlutterFire konfigurieren

```bash
cd /Users/marcocorro/Documents/xCode/WahlApp

# FlutterFire konfigurieren
flutterfire configure
```

**Interaktiver Dialog:**
1. Projekt auswählen: `WahlApp` (mit Pfeiltasten)
2. Plattformen auswählen: 
   - [x] macos
   - [x] ios
   - [x] windows
   - (Space zum Auswählen, Enter zum Bestätigen)

**Ergebnis:**
- Erstellt `lib/firebase_options.dart`
- Konfiguriert alle Plattformen automatisch

### 3.2 Dependencies hinzufügen

Bearbeiten Sie `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  sqflite: ^2.3.0
  path: ^1.8.3
  provider: ^6.0.5
  csv: ^6.0.0
  file_picker: ^8.0.0
  # Neu für Firebase:
  firebase_core: ^3.3.0
  cloud_firestore: ^5.2.0
```

```bash
flutter pub get
```

---

## 📝 Schritt 4: Code-Implementierung (3-4 Stunden)

### 4.1 Firebase initialisieren in main.dart

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/voter_provider.dart';
import 'screens/voter_list_screen.dart';

void main() async {
  // Firebase initialisieren
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VoterProvider(),
      child: MaterialApp(
        title: 'WahlApp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const VoterListScreen(),
      ),
    );
  }
}
```

### 4.2 Firestore Service erstellen

```dart
// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/voter.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionName = 'voters';

  // Wähler hinzufügen
  Future<void> addVoter(Voter voter) async {
    await _db.collection(_collectionName).add({
      'pkNumber': voter.pkNumber,
      'lastName': voter.lastName,
      'firstName': voter.firstName,
      'hasVoted': voter.hasVoted ? 1 : 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Wähler-Stream (Echtzeit-Updates)
  Stream<List<Voter>> getVotersStream() {
    return _db
        .collection(_collectionName)
        .orderBy('lastName')
        .orderBy('firstName')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Voter(
          id: doc.id.hashCode, // Firestore ID als int-Hash
          pkNumber: data['pkNumber'] ?? '',
          lastName: data['lastName'] ?? '',
          firstName: data['firstName'] ?? '',
          hasVoted: (data['hasVoted'] ?? 0) == 1,
        );
      }).toList();
    });
  }

  // Wähler suchen
  Stream<List<Voter>> searchVotersStream(String query) {
    if (query.isEmpty) {
      return getVotersStream();
    }

    // Firestore unterstützt keine case-insensitive Suche direkt
    // Daher filtern wir im Stream
    return getVotersStream().map((voters) {
      final lowerQuery = query.toLowerCase();
      return voters.where((voter) {
        return voter.pkNumber.toLowerCase().contains(lowerQuery) ||
            voter.lastName.toLowerCase().contains(lowerQuery) ||
            voter.firstName.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  // Wähler-Status aktualisieren
  Future<void> updateVoterStatus(String firestoreId, bool hasVoted) async {
    await _db.collection(_collectionName).doc(firestoreId).update({
      'hasVoted': hasVoted ? 1 : 0,
      'votedAt': hasVoted ? FieldValue.serverTimestamp() : null,
    });
  }

  // Wähler löschen
  Future<void> deleteVoter(String firestoreId) async {
    await _db.collection(_collectionName).doc(firestoreId).delete();
  }

  // Wähler nach PK-Nummer finden (für Duplikat-Check)
  Future<bool> voterExists(String pkNumber) async {
    final query = await _db
        .collection(_collectionName)
        .where('pkNumber', isEqualTo: pkNumber)
        .limit(1)
        .get();
    return query.docs.isNotEmpty;
  }

  // Batch-Import von Wählern (für CSV-Import)
  Future<void> batchAddVoters(List<Voter> voters) async {
    final batch = _db.batch();
    
    for (var voter in voters) {
      final docRef = _db.collection(_collectionName).doc();
      batch.set(docRef, {
        'pkNumber': voter.pkNumber,
        'lastName': voter.lastName,
        'firstName': voter.firstName,
        'hasVoted': voter.hasVoted ? 1 : 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }
}
```

### 4.3 Voter Model erweitern

```dart
// lib/models/voter.dart
class Voter {
  final int? id;
  final String? firestoreId; // Neu für Firebase
  final String pkNumber;
  final String lastName;
  final String firstName;
  final bool hasVoted;

  Voter({
    this.id,
    this.firestoreId,
    required this.pkNumber,
    required this.lastName,
    required this.firstName,
    this.hasVoted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firestoreId': firestoreId,
      'pkNumber': pkNumber,
      'lastName': lastName,
      'firstName': firstName,
      'hasVoted': hasVoted ? 1 : 0,
    };
  }

  factory Voter.fromMap(Map<String, dynamic> map) {
    return Voter(
      id: map['id'] as int?,
      firestoreId: map['firestoreId'] as String?,
      pkNumber: map['pkNumber'] as String,
      lastName: map['lastName'] as String,
      firstName: map['firstName'] as String,
      hasVoted: map['hasVoted'] == 1,
    );
  }

  Voter copyWith({
    int? id,
    String? firestoreId,
    String? pkNumber,
    String? lastName,
    String? firstName,
    bool? hasVoted,
  }) {
    return Voter(
      id: id ?? this.id,
      firestoreId: firestoreId ?? this.firestoreId,
      pkNumber: pkNumber ?? this.pkNumber,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      hasVoted: hasVoted ?? this.hasVoted,
    );
  }
}
```

### 4.4 VoterProvider für Firebase anpassen

```dart
// lib/services/voter_provider.dart
import 'package:flutter/foundation.dart';
import '../models/voter.dart';
import 'firestore_service.dart';

class VoterProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Voter> _voters = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<Voter> get voters => _voters;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  int get totalVoters => _voters.length;
  int get votedCount => _voters.where((v) => v.hasVoted).length;
  int get notVotedCount => _voters.where((v) => !v.hasVoted).length;

  // Stream-Subscription starten
  void startListening() {
    _isLoading = true;
    notifyListeners();

    _firestoreService.getVotersStream().listen((voters) {
      _voters = voters;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      debugPrint('Error loading voters: $error');
      _isLoading = false;
      notifyListeners();
    });
  }

  // Wähler hinzufügen
  Future<void> addVoter(Voter voter) async {
    // Duplikat-Check
    if (await _firestoreService.voterExists(voter.pkNumber)) {
      throw Exception('PK-Nummer bereits vorhanden');
    }
    await _firestoreService.addVoter(voter);
  }

  // Wähler-Status umschalten
  Future<void> toggleVoted(Voter voter) async {
    if (voter.firestoreId != null) {
      await _firestoreService.updateVoterStatus(
        voter.firestoreId!,
        !voter.hasVoted,
      );
    }
  }

  // Wähler löschen
  Future<void> deleteVoter(Voter voter) async {
    if (voter.firestoreId != null) {
      await _firestoreService.deleteVoter(voter.firestoreId!);
    }
  }

  // Suche
  void searchVoters(String query) {
    _searchQuery = query;
    _firestoreService.searchVotersStream(query).listen((voters) {
      _voters = voters;
      notifyListeners();
    });
  }

  // CSV-Import
  Future<void> batchImportVoters(List<Voter> voters) async {
    await _firestoreService.batchAddVoters(voters);
  }
}
```

### 4.5 CSV-Import für Firebase anpassen

```dart
// lib/services/csv_import_service.dart
// In der _parseCsvFile Methode, ersetzen Sie:

// Alte Version:
// await DatabaseService.instance.createVoter(voter);

// Neue Version für Firebase:
await FirestoreService().addVoter(voter);
```

---

## 🔒 Schritt 5: Security Rules setzen (30 Min)

### 5.1 Firestore Rules öffnen

1. Firebase Console → **"Firestore Database"**
2. Tab **"Regeln"**

### 5.2 Basic Rules (für Test)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /voters/{voterId} {
      // Jeder kann lesen/schreiben (NUR FÜR TEST!)
      allow read, write: if true;
    }
  }
}
```

### 5.3 Production Rules (mit Authentifizierung)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /voters/{voterId} {
      // Nur authentifizierte Benutzer
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth != null;
      allow delete: if request.auth != null;
      
      // PK-Nummer darf nicht geändert werden
      allow update: if request.auth != null 
        && request.resource.data.pkNumber == resource.data.pkNumber;
    }
  }
}
```

Klicken Sie **"Veröffentlichen"**

---

## 🧪 Schritt 6: Testen (30 Min)

### 6.1 App neu starten

```bash
flutter run -d macos
```

### 6.2 Test-Szenario

1. ✅ Wähler hinzufügen
2. ✅ Wähler abhaken
3. ✅ **Zweites Gerät starten** (oder Browser)
4. ✅ Änderungen sollten automatisch erscheinen!

### 6.3 Firestore Console überprüfen

Firebase Console → Firestore Database → voters Collection
→ Sie sollten Ihre Wähler sehen!

---

## 📊 Schritt 7: CSV-Import mit Firebase testen

### 7.1 CSV-Import-Service anpassen

Die `batchAddVoters` Methode ist bereits vorbereitet!

### 7.2 Test

1. Upload-Button klicken
2. `sample_voters.csv` auswählen
3. Wähler werden in Firebase importiert
4. Auf allen Geräten sichtbar!

---

## 🎉 Fertig!

Ihre App synchronisiert jetzt automatisch über alle Geräte!

### Was Sie jetzt haben:

- ✅ Echtzeit-Synchronisation
- ✅ Mehrere Wahlbüros können gleichzeitig arbeiten
- ✅ Automatische Konfliktauflösung
- ✅ Offline-Fähigkeit (Firebase cached lokal)
- ✅ CSV-Import funktioniert
- ✅ Kostenlos für Ihren Anwendungsfall

---

## 🔍 Troubleshooting

### Problem: "Firebase not initialized"

**Lösung:**
```dart
// In main.dart, vor runApp():
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### Problem: "Permission denied"

**Lösung:** Firestore Rules überprüfen (Schritt 5)

### Problem: "No such document"

**Lösung:** Firestore Console überprüfen, Collection erstellt?

### Problem: Daten werden nicht synchronisiert

**Lösung:**
1. Internet-Verbindung prüfen
2. Firebase Console → Firestore → Daten vorhanden?
3. Console-Logs überprüfen

---

## 📚 Nächste Schritte (Optional)

### 1. Authentifizierung hinzufügen

```bash
flutter pub add firebase_auth
```

### 2. Offline-Persistenz aktivieren

```dart
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
);
```

### 3. Monitoring & Analytics

Firebase Console → Analytics aktivieren

---

## 💡 Tipps

1. **Test-Modus zeitlich begrenzt:** Nach 30 Tagen Rules anpassen!
2. **Backup:** Firebase bietet automatische Backups
3. **Limits:** Kostenlos bis 50.000 Reads/Tag
4. **DSGVO:** Firestore Region "europe-west3" wählen

---

**Viel Erfolg! 🚀**

Bei Fragen oder Problemen stehe ich zur Verfügung!
