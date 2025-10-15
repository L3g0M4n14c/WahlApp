# Synchronisation über mehrere Rechner

## 🎯 Aktueller Status

**Momentan**: Die App speichert Daten nur lokal in einer SQLite-Datenbank auf jedem Gerät.
- ❌ Keine automatische Synchronisation
- ❌ Jeder Rechner hat eigene Datenbank
- ❌ Keine Echtzeit-Updates

## 🚀 Lösungsansätze für Synchronisation

### Option 1: Firebase (Empfohlen für schnellen Start) ⭐

**Vorteile:**
- ✅ Einfache Integration
- ✅ Echtzeit-Synchronisation
- ✅ Kostenlos für kleine Projekte
- ✅ Automatisches Offline-Handling
- ✅ Keine Server-Verwaltung nötig

**Nachteile:**
- ⚠️ Abhängigkeit von Google
- ⚠️ Bei vielen Nutzern kostenpflichtig
- ⚠️ Daten außerhalb Ihrer Kontrolle

**Implementierung:**
```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^3.0.0
  cloud_firestore: ^5.0.0
```

**Aufwand:** 2-4 Stunden
**Kosten:** Kostenlos bis ~50.000 Reads/Tag

---

### Option 2: Eigener REST-API Server (Mittlere Komplexität) 🔧

**Vorteile:**
- ✅ Volle Kontrolle über Daten
- ✅ DSGVO-konform möglich
- ✅ Keine externen Abhängigkeiten
- ✅ Eigene Business-Logik

**Nachteile:**
- ⚠️ Server-Hosting nötig
- ⚠️ Mehr Entwicklungsaufwand
- ⚠️ Server-Wartung erforderlich

**Tech-Stack Beispiel:**
- Backend: Node.js + Express + PostgreSQL
- oder: Python + Flask/FastAPI + PostgreSQL
- oder: Dart + shelf + PostgreSQL

**Aufwand:** 1-2 Wochen
**Kosten:** Ab 5€/Monat (Server-Hosting)

---

### Option 3: Supabase (Modern & Open Source) 🌟

**Vorteile:**
- ✅ Open Source Alternative zu Firebase
- ✅ PostgreSQL Datenbank
- ✅ Echtzeit-Subscriptions
- ✅ Row Level Security
- ✅ Kann selbst gehostet werden

**Nachteile:**
- ⚠️ Noch relativ neu
- ⚠️ Kleinere Community als Firebase

**Implementierung:**
```yaml
dependencies:
  supabase_flutter: ^2.0.0
```

**Aufwand:** 3-6 Stunden
**Kosten:** Kostenlos bis 500MB Datenbank

---

### Option 4: Shared Network Drive (Einfachste Lösung) 💾

**Vorteile:**
- ✅ Sehr einfach
- ✅ Keine Cloud nötig
- ✅ Lokales Netzwerk
- ✅ Volle Datenkontrolle

**Nachteile:**
- ⚠️ Keine Echtzeit-Updates
- ⚠️ Konflikt-Probleme möglich
- ⚠️ Nur im gleichen Netzwerk
- ⚠️ Keine mobile Nutzung

**Umsetzung:**
- SQLite-Datenbank auf Netzlaufwerk
- Datei-Locking implementieren
- Regelmäßige Synchronisation

**Aufwand:** 4-8 Stunden
**Kosten:** Kostenlos (eigener Server)

---

### Option 5: WebSocket Server (Für Echtzeit) ⚡

**Vorteile:**
- ✅ Echtzeitfähig
- ✅ Bidirektionale Kommunikation
- ✅ Alle Clients gleichzeitig aktualisiert

**Nachteile:**
- ⚠️ Komplexe Implementierung
- ⚠️ Server muss immer laufen
- ⚠️ Verbindungsmanagement

**Aufwand:** 2-3 Wochen
**Kosten:** Ab 5€/Monat

---

## 📊 Vergleichstabelle

| Lösung | Aufwand | Kosten | Echtzeit | Komplexität | Empfehlung |
|--------|---------|--------|----------|-------------|------------|
| Firebase | Niedrig | Kostenlos* | ✅ | Niedrig | ⭐⭐⭐⭐⭐ |
| Supabase | Niedrig | Kostenlos* | ✅ | Niedrig | ⭐⭐⭐⭐ |
| REST API | Mittel | Ab 5€ | ❌ | Mittel | ⭐⭐⭐ |
| Network Drive | Niedrig | Kostenlos | ❌ | Niedrig | ⭐⭐ |
| WebSocket | Hoch | Ab 5€ | ✅ | Hoch | ⭐⭐ |

*bis zu bestimmtem Limit

---

## 🎯 Empfehlung für Ihr Projekt

### Für Betriebsratswahl (schnelle Lösung):

**Firebase** ist die beste Wahl weil:
1. ✅ Schnell zu implementieren (1 Tag)
2. ✅ Echtzeit-Updates während der Wahl
3. ✅ Zuverlässig und getestet
4. ✅ Kostenlos für Wahlumfang
5. ✅ Mehrere Wahlbüros können gleichzeitig arbeiten

### Für langfristige Lösung mit voller Kontrolle:

**Supabase** oder **eigener REST-API Server**
- Daten bleiben im eigenen Unternehmen
- DSGVO-konform
- Unbegrenzte Anzahl Wahlen

---

## 🚀 Schnellstart: Firebase-Integration

### Schritt 1: Firebase-Projekt erstellen

1. Gehen Sie zu: https://console.firebase.google.com
2. Klicken Sie auf "Projekt hinzufügen"
3. Wählen Sie einen Namen (z.B. "WahlApp")
4. Google Analytics optional
5. Projekt erstellen

### Schritt 2: Flutter-App konfigurieren

```bash
# Firebase CLI installieren
npm install -g firebase-tools

# Login
firebase login

# FlutterFire CLI installieren
dart pub global activate flutterfire_cli

# Firebase zu Flutter-Projekt hinzufügen
flutterfire configure
```

### Schritt 3: Dependencies hinzufügen

```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^3.0.0
  cloud_firestore: ^5.0.0
```

### Schritt 4: Code-Änderungen

**main.dart:**
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```

**Neuer Service (firestore_service.dart):**
```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/voter.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionName = 'voters';

  // Wähler hinzufügen
  Future<void> addVoter(Voter voter) async {
    await _db.collection(collectionName).add(voter.toMap());
  }

  // Alle Wähler abrufen (Echtzeit-Stream)
  Stream<List<Voter>> getVoters() {
    return _db
        .collection(collectionName)
        .orderBy('lastName')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Voter.fromMap({...doc.data(), 'id': doc.id}))
            .toList());
  }

  // Wähler-Status aktualisieren
  Future<void> updateVoterStatus(String id, bool hasVoted) async {
    await _db.collection(collectionName).doc(id).update({
      'hasVoted': hasVoted ? 1 : 0,
    });
  }
}
```

### Schritt 5: Security Rules (Firestore)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /voters/{voterId} {
      // Nur authentifizierte Benutzer
      allow read, write: if request.auth != null;
      
      // Oder für Test: Jeder darf lesen/schreiben
      // allow read, write: if true;
    }
  }
}
```

**Aufwand:** ~4-6 Stunden für vollständige Integration
**Ergebnis:** Echtzeit-Synchronisation über alle Geräte

---

## 🔒 Sicherheitsüberlegungen

### Bei Cloud-Lösungen (Firebase/Supabase):

1. **Authentifizierung** implementieren
   - Email/Passwort
   - Nur autorisierte Wahlhelfer

2. **Firestore Rules** definieren
   - Wer darf lesen?
   - Wer darf schreiben?
   - Wer darf löschen?

3. **Datenschutz** beachten
   - DSGVO-Konformität
   - Einwilligung der Wähler
   - Datenminimierung

### Bei eigenem Server:

1. **HTTPS** verwenden
2. **JWT-Token** für Authentifizierung
3. **Rate Limiting**
4. **Input Validation**
5. **SQL Injection** Schutz

---

## 💰 Kostenabschätzung

### Firebase (bei 100 Wählern, 5 Wahlbüros):

- Reads: ~500/Tag (kostenlos bis 50.000)
- Writes: ~100/Tag (kostenlos bis 20.000)
- Storage: ~1MB (kostenlos bis 1GB)

**Kosten: 0€** ✅

### Eigener Server (Digital Ocean/Hetzner):

- Server: 5-10€/Monat
- Domain: 1€/Monat (optional)
- SSL-Zertifikat: Kostenlos (Let's Encrypt)

**Kosten: 6-11€/Monat**

---

## 📝 Nächste Schritte

### Wenn Sie Firebase wählen:

1. ✅ Firebase-Projekt erstellen (10 Min)
2. ✅ FlutterFire konfigurieren (15 Min)
3. ✅ Code anpassen (3-4 Stunden)
4. ✅ Testen mit mehreren Geräten (30 Min)
5. ✅ Security Rules setzen (30 Min)

**Gesamtzeit: 1 Tag**

### Wenn Sie eigenen Server wählen:

1. ✅ Server-Stack wählen
2. ✅ Backend entwickeln (1 Woche)
3. ✅ API-Endpoints testen
4. ✅ Flutter-App anpassen (2-3 Tage)
5. ✅ Deployment & Testing (1 Tag)

**Gesamtzeit: 1-2 Wochen**

---

## 🆘 Benötigen Sie Hilfe?

Ich kann Ihnen helfen mit:

1. **Firebase-Integration** - Schritt-für-Schritt-Code
2. **Supabase-Setup** - Alternative zu Firebase
3. **REST-API Design** - Eigener Server
4. **Code-Implementierung** - Jede der Lösungen

Sagen Sie mir einfach, welche Lösung Sie bevorzugen, und ich erstelle den entsprechenden Code für Sie!

---

## 📚 Weiterführende Ressourcen

- [Firebase Flutter Docs](https://firebase.google.com/docs/flutter/setup)
- [Supabase Flutter Docs](https://supabase.com/docs/guides/getting-started/quickstarts/flutter)
- [Flutter HTTP Package](https://pub.dev/packages/http) (für REST APIs)
- [Flutter WebSocket](https://pub.dev/packages/web_socket_channel)

---

**Fazit:** Für eine Betriebsratswahl empfehle ich **Firebase** als schnellste und zuverlässigste Lösung. Die Implementierung dauert nur einen Tag und ist für Ihren Anwendungsfall kostenlos.
