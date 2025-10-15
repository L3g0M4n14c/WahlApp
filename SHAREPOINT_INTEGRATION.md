# SharePoint-Integration für WahlApp

## 🎯 Übersicht

SharePoint bietet mehrere Möglichkeiten, um Daten zu speichern und zwischen mehreren Rechnern zu synchronisieren.

## 📊 SharePoint-Optionen im Vergleich

| Option | Komplexität | Echtzeit | Empfehlung |
|--------|-------------|----------|------------|
| **1. SharePoint Lists (REST API)** | Mittel | ⚡ Ja | ⭐⭐⭐⭐⭐ |
| **2. OneDrive/SharePoint File Sync** | Niedrig | ❌ Nein | ⭐⭐⭐ |
| **3. Power Automate + SharePoint** | Mittel | ⚡ Ja | ⭐⭐⭐⭐ |
| **4. Microsoft Graph API** | Hoch | ⚡ Ja | ⭐⭐⭐⭐ |

---

## ⭐ Option 1: SharePoint Lists mit REST API (EMPFOHLEN)

### Vorteile
- ✅ **Native SharePoint-Integration**
- ✅ **Echtzeit-Updates** möglich
- ✅ **Versionierung** automatisch
- ✅ **Berechtigungen** über SharePoint
- ✅ **Backup** durch Microsoft
- ✅ **DSGVO-konform** (Daten in EU)
- ✅ **Audit-Trail** (wer hat wann was geändert)

### Nachteile
- ⚠️ **Authentifizierung** erforderlich (Azure AD)
- ⚠️ **Komplexer** als Firebase
- ⚠️ **Microsoft 365** Lizenz nötig

### Architektur

```
┌─────────────────────────────────────────────────────┐
│                   SharePoint Site                    │
│  https://ihrefirma.sharepoint.com/sites/wahlapp     │
├─────────────────────────────────────────────────────┤
│                                                      │
│  📋 SharePoint List: "Wähler"                       │
│  ┌────────────────────────────────────────────┐    │
│  │ Spalte          │ Typ        │ Index       │    │
│  ├────────────────────────────────────────────┤    │
│  │ PK-Nummer       │ Text       │ ✅ Unique   │    │
│  │ Nachname        │ Text       │ ✅ Index    │    │
│  │ Vorname         │ Text       │ ✅ Index    │    │
│  │ Hat gewählt     │ Ja/Nein    │ ❌          │    │
│  │ Gewählt am      │ Datum/Zeit │ ❌          │    │
│  │ Erstellt        │ Auto       │ ❌          │    │
│  │ Geändert von    │ Auto       │ ❌          │    │
│  └────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────┘
           │                          │
           │    REST API              │    
           │                          │
     ┌─────▼──────┐            ┌─────▼──────┐
     │ Rechner 1  │            │ Rechner 2  │
     │  WahlApp   │            │  WahlApp   │
     └────────────┘            └────────────┘
```

### Implementierung

#### 1. SharePoint List erstellen

**Manuell in SharePoint:**
1. Gehen Sie zu Ihrer SharePoint-Site
2. Erstellen Sie eine neue Liste: "Wähler"
3. Fügen Sie folgende Spalten hinzu:
   - `PKNummer` (Einzeilentext, eindeutig)
   - `Nachname` (Einzeilentext)
   - `Vorname` (Einzeilentext)
   - `HatGewaehlt` (Ja/Nein)
   - `GewaehltAm` (Datum und Uhrzeit)

#### 2. Flutter Dependencies

```yaml
# pubspec.yaml
dependencies:
  http: ^1.1.0
  oauth2: ^2.0.2
  shared_preferences: ^2.2.2
```

#### 3. SharePoint Service erstellen

```dart
// lib/services/sharepoint_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/voter.dart';

class SharePointService {
  // SharePoint-Konfiguration
  static const String siteUrl = 'https://ihrefirma.sharepoint.com/sites/wahlapp';
  static const String listName = 'Wähler';
  
  // Azure AD App-Registrierung (später konfigurieren)
  String? _accessToken;
  
  // REST API Endpoint
  String get _apiUrl => '$siteUrl/_api/web/lists/getbytitle(\'$listName\')/items';

  /// SharePoint-Authentifizierung
  /// Verwendet OAuth 2.0 / Azure AD
  Future<void> authenticate(String username, String password) async {
    // Vereinfachte Version - in Produktion Azure AD OAuth verwenden
    // Siehe: https://docs.microsoft.com/graph/auth-v2-user
    
    // Für SharePoint Online benötigen Sie:
    // 1. Azure AD App-Registrierung
    // 2. Client ID & Client Secret
    // 3. OAuth Flow implementieren
    
    throw UnimplementedError('Azure AD OAuth muss konfiguriert werden');
  }

  /// Alle Wähler abrufen
  Future<List<Voter>> getVoters() async {
    if (_accessToken == null) {
      throw Exception('Nicht authentifiziert');
    }

    final response = await http.get(
      Uri.parse('$_apiUrl?\$orderby=Nachname'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'Accept': 'application/json;odata=verbose',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['d']['results'] as List;
      
      return items.map((item) => Voter(
        id: item['Id'],
        pkNumber: item['PKNummer'],
        lastName: item['Nachname'],
        firstName: item['Vorname'],
        hasVoted: item['HatGewaehlt'] ?? false,
      )).toList();
    } else {
      throw Exception('Fehler beim Laden: ${response.statusCode}');
    }
  }

  /// Wähler hinzufügen
  Future<void> addVoter(Voter voter) async {
    if (_accessToken == null) {
      throw Exception('Nicht authentifiziert');
    }

    // Form Digest Token abrufen (für POST/UPDATE/DELETE)
    final digestToken = await _getFormDigestToken();

    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'Accept': 'application/json;odata=verbose',
        'Content-Type': 'application/json;odata=verbose',
        'X-RequestDigest': digestToken,
      },
      body: json.encode({
        '__metadata': {'type': 'SP.Data.WählerListItem'},
        'PKNummer': voter.pkNumber,
        'Nachname': voter.lastName,
        'Vorname': voter.firstName,
        'HatGewaehlt': voter.hasVoted,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Fehler beim Hinzufügen: ${response.statusCode}');
    }
  }

  /// Wähler-Status aktualisieren
  Future<void> updateVoterStatus(int id, bool hasVoted) async {
    if (_accessToken == null) {
      throw Exception('Nicht authentifiziert');
    }

    final digestToken = await _getFormDigestToken();

    final response = await http.post(
      Uri.parse('$_apiUrl($id)'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'Accept': 'application/json;odata=verbose',
        'Content-Type': 'application/json;odata=verbose',
        'X-RequestDigest': digestToken,
        'X-HTTP-Method': 'MERGE',
        'IF-MATCH': '*',
      },
      body: json.encode({
        '__metadata': {'type': 'SP.Data.WählerListItem'},
        'HatGewaehlt': hasVoted,
        'GewaehltAm': hasVoted ? DateTime.now().toIso8601String() : null,
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Fehler beim Update: ${response.statusCode}');
    }
  }

  /// Form Digest Token abrufen (für Schreiboperationen)
  Future<String> _getFormDigestToken() async {
    final response = await http.post(
      Uri.parse('$siteUrl/_api/contextinfo'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'Accept': 'application/json;odata=verbose',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['d']['GetContextWebInformation']['FormDigestValue'];
    } else {
      throw Exception('Fehler beim Abrufen des Digest Tokens');
    }
  }

  /// Wähler löschen
  Future<void> deleteVoter(int id) async {
    if (_accessToken == null) {
      throw Exception('Nicht authentifiziert');
    }

    final digestToken = await _getFormDigestToken();

    final response = await http.post(
      Uri.parse('$_apiUrl($id)'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'X-RequestDigest': digestToken,
        'X-HTTP-Method': 'DELETE',
        'IF-MATCH': '*',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Fehler beim Löschen: ${response.statusCode}');
    }
  }
}
```

#### 4. Azure AD App-Registrierung

**Erforderlich für Authentifizierung:**

1. **Azure Portal öffnen:** https://portal.azure.com
2. **Azure Active Directory** → **App-Registrierungen**
3. **Neue Registrierung:**
   - Name: `WahlApp`
   - Unterstützte Kontotypen: Nur diese Organisation
   - Umleitungs-URI: `http://localhost` (für Desktop)
4. **Notieren:**
   - Application (client) ID
   - Directory (tenant) ID
5. **Zertifikate & Geheimnisse:**
   - Neuer geheimer Clientschlüssel
   - Notieren Sie den Wert
6. **API-Berechtigungen:**
   - Microsoft Graph → `Sites.ReadWrite.All`
   - SharePoint → `AllSites.Write`
   - Admin-Zustimmung erteilen

#### 5. OAuth-Authentifizierung implementieren

```dart
// lib/services/sharepoint_auth.dart
import 'package:oauth2/oauth2.dart' as oauth2;

class SharePointAuth {
  static const String clientId = 'IHRE_CLIENT_ID';
  static const String clientSecret = 'IHR_CLIENT_SECRET';
  static const String tenantId = 'IHRE_TENANT_ID';
  
  static const String authorityUrl = 
      'https://login.microsoftonline.com/$tenantId/oauth2/v2.0';
  static const String scope = 
      'https://graph.microsoft.com/.default';

  Future<oauth2.Client> authenticate() async {
    final authorizationEndpoint = 
        Uri.parse('$authorityUrl/authorize');
    final tokenEndpoint = 
        Uri.parse('$authorityUrl/token');

    // Client Credentials Flow (für Server-to-Server)
    final client = await oauth2.clientCredentialsGrant(
      authorizationEndpoint,
      clientId,
      clientSecret,
      scopes: [scope],
    );

    return client;
  }
}
```

---

## 💾 Option 2: OneDrive/SharePoint File Sync (EINFACHER)

### Konzept
SQLite-Datenbank auf SharePoint/OneDrive speichern und lokal synchronisieren.

### Vorteile
- ✅ **Sehr einfach** zu implementieren
- ✅ **Keine API** erforderlich
- ✅ **Funktioniert offline**
- ✅ **OneDrive-Sync** übernimmt Synchronisation

### Nachteile
- ⚠️ **Keine Echtzeit-Updates**
- ⚠️ **Konflikt-Probleme** möglich
- ⚠️ **File Locking** nötig

### Implementierung

```dart
// lib/services/onedrive_sync_service.dart
import 'dart:io';
import 'package:path/path.dart';

class OneDriveSyncService {
  // Pfad zum OneDrive/SharePoint-Ordner
  static String get oneDrivePath {
    if (Platform.isMacOS) {
      return '/Users/${Platform.environment['USER']}/OneDrive - IhreFirma/WahlApp';
    } else if (Platform.isWindows) {
      return r'C:\Users\%USERNAME%\OneDrive - IhreFirma\WahlApp';
    }
    throw UnsupportedError('Platform not supported');
  }

  static String get databasePath => join(oneDrivePath, 'voters.db');

  /// Datenbank mit OneDrive synchronisieren
  Future<void> syncDatabase() async {
    final localDb = await getDatabasesPath();
    final localPath = join(localDb, 'voters.db');
    
    final oneDriveDb = File(databasePath);
    final localDbFile = File(localPath);

    // Prüfen, welche Version neuer ist
    if (await oneDriveDb.exists() && await localDbFile.exists()) {
      final oneDriveModified = await oneDriveDb.lastModified();
      final localModified = await localDbFile.lastModified();

      if (oneDriveModified.isAfter(localModified)) {
        // OneDrive-Version ist neuer → Herunterladen
        await oneDriveDb.copy(localPath);
        print('Datenbank von OneDrive aktualisiert');
      } else {
        // Lokale Version ist neuer → Hochladen
        await localDbFile.copy(databasePath);
        print('Datenbank zu OneDrive hochgeladen');
      }
    } else if (await oneDriveDb.exists()) {
      // Nur OneDrive-Version existiert
      await oneDriveDb.copy(localPath);
    } else if (await localDbFile.exists()) {
      // Nur lokale Version existiert
      await localDbFile.copy(databasePath);
    }
  }

  /// Automatische Synchronisation starten
  Future<void> startAutoSync() async {
    // Alle 30 Sekunden synchronisieren
    Timer.periodic(Duration(seconds: 30), (timer) async {
      try {
        await syncDatabase();
      } catch (e) {
        print('Sync-Fehler: $e');
      }
    });
  }
}
```

### Setup
1. OneDrive installieren und anmelden
2. Ordner "WahlApp" in OneDrive erstellen
3. OneDrive-Pfad in App konfigurieren
4. Auto-Sync aktivieren

**Aufwand:** 2-3 Stunden  
**Kosten:** OneDrive-Lizenz (meist vorhanden)

---

## ⚡ Option 3: Microsoft Power Automate + SharePoint

### Konzept
Power Automate als Middleware zwischen App und SharePoint.

### Workflow
```
Flutter App
    │
    ├─> HTTP POST → Power Automate Flow
    │                   │
    │                   └─> SharePoint List Update
    │
    └─> HTTP GET ← Power Automate Flow
                        │
                        └─> SharePoint List Read
```

### Vorteile
- ✅ **No-Code** für SharePoint-Teil
- ✅ **Einfache** Berechtigungen
- ✅ **Integrierte** Fehlerbehandlung
- ✅ **Email-Benachrichtigungen** möglich

### Nachteile
- ⚠️ **Power Automate** Lizenz nötig
- ⚠️ **Langsamer** als direkte API
- ⚠️ **Request-Limits**

---

## 📊 Empfehlung für Ihr Projekt

### Für schnelle Lösung (1-2 Tage):
**OneDrive File Sync** ⭐⭐⭐
- Einfach zu implementieren
- Nutzt vorhandene OneDrive-Sync
- Gut für 2-5 Rechner im gleichen Büro

### Für professionelle Lösung (1 Woche):
**SharePoint Lists + REST API** ⭐⭐⭐⭐⭐
- Echtzeit-Synchronisation
- Zentrale Verwaltung
- Audit-Trail
- Skalierbar

### Für Budget-Lösung:
**Firebase** (siehe vorherige Dokumentation)
- Kostenlos
- Einfacher als SharePoint
- Schnell implementiert

---

## 🔒 Sicherheit & Compliance

### SharePoint-Vorteile:
- ✅ **Daten in EU** (DSGVO-konform)
- ✅ **Firmen-Kontrolle** über Daten
- ✅ **Bestehende Berechtigungen** nutzbar
- ✅ **Audit-Logs** automatisch
- ✅ **Backup** durch IT-Abteilung

### Erforderlich:
- 🔐 Azure AD Authentifizierung
- 📋 Datenschutz-Folgenabschätzung
- 👥 Berechtigungskonzept
- 📝 Betriebsvereinbarung (evtl.)

---

## 💰 Kosten

| Komponente | Kosten |
|-----------|--------|
| **SharePoint Online** | Teil von Microsoft 365 (meist vorhanden) |
| **OneDrive** | Teil von Microsoft 365 (meist vorhanden) |
| **Azure AD** | Kostenlos (Basic in M365 enthalten) |
| **Power Automate** | Ab 13€/User/Monat (optional) |

**Für vorhandene M365-Umgebung: 0€ zusätzlich!** ✅

---

## 🚀 Nächste Schritte

### Wenn SharePoint gewünscht:

1. **IT-Abteilung kontaktieren:**
   - SharePoint-Site einrichten
   - Azure AD App registrieren
   - Berechtigungen klären

2. **Einfacher Start mit OneDrive-Sync:**
   - Sofort umsetzbar
   - Keine Admin-Rechte nötig
   - Später auf SharePoint Lists upgraden

3. **Oder doch Firebase:**
   - Schneller implementiert
   - Keine IT-Abteilung nötig
   - Siehe `FIREBASE_INTEGRATION.md`

---

## 📞 Support

Benötigen Sie Hilfe bei der Entscheidung oder Implementierung?

**Ich kann unterstützen bei:**
- ✅ SharePoint REST API Integration
- ✅ OneDrive File Sync Implementierung
- ✅ Azure AD OAuth Setup
- ✅ Code-Beispiele & Testing

Sagen Sie mir einfach Bescheid! 🚀
