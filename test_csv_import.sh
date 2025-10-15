#!/bin/bash

# CSV Import Test Script für WahlApp
# Dieses Script hilft beim Debuggen von CSV-Import-Problemen

echo "🔍 WahlApp - CSV Import Diagnose"
echo "================================="
echo ""

# 1. Überprüfe Flutter Installation
echo "1️⃣ Flutter Version:"
flutter --version | head -n 1
echo ""

# 2. Überprüfe ob sample_voters.csv existiert
echo "2️⃣ Überprüfe Beispiel-CSV-Datei:"
if [ -f "sample_voters.csv" ]; then
    echo "✅ sample_voters.csv gefunden"
    echo "📊 Anzahl Zeilen: $(wc -l < sample_voters.csv)"
    echo "📄 Erste Zeilen:"
    head -n 3 sample_voters.csv
else
    echo "❌ sample_voters.csv nicht gefunden!"
    echo "💡 Erstelle Beispieldatei..."
    cat > sample_voters.csv << 'EOF'
PK-Nummer,Nachname,Vorname
12345,Müller,Hans
23456,Schmidt,Anna
34567,Wagner,Peter
45678,Fischer,Maria
56789,Weber,Thomas
EOF
    echo "✅ Beispieldatei erstellt"
fi
echo ""

# 3. Überprüfe macOS Entitlements
echo "3️⃣ Überprüfe macOS Berechtigungen:"
if grep -q "com.apple.security.files.user-selected.read-only" macos/Runner/DebugProfile.entitlements; then
    echo "✅ Debug-Berechtigungen vorhanden"
else
    echo "❌ Debug-Berechtigungen fehlen!"
fi

if grep -q "com.apple.security.files.user-selected.read-only" macos/Runner/Release.entitlements; then
    echo "✅ Release-Berechtigungen vorhanden"
else
    echo "❌ Release-Berechtigungen fehlen!"
fi
echo ""

# 4. Überprüfe Dependencies
echo "4️⃣ Überprüfe Flutter Dependencies:"
if grep -q "file_picker:" pubspec.yaml; then
    echo "✅ file_picker Package vorhanden"
    grep "file_picker:" pubspec.yaml
else
    echo "❌ file_picker Package fehlt!"
fi

if grep -q "csv:" pubspec.yaml; then
    echo "✅ csv Package vorhanden"
    grep "csv:" pubspec.yaml
else
    echo "❌ csv Package fehlt!"
fi
echo ""

# 5. App-Status
echo "5️⃣ App-Status:"
if pgrep -f "wahlapp" > /dev/null; then
    echo "⚠️  App läuft bereits!"
    echo "💡 Bitte stoppen Sie die App mit 'q' im Terminal und starten Sie neu"
else
    echo "✅ App läuft nicht (bereit für Neustart)"
fi
echo ""

# 6. Empfohlene Aktionen
echo "📋 Empfohlene Aktionen:"
echo "================================="
echo ""
echo "1️⃣ App stoppen (falls sie läuft):"
echo "   - Im Flutter-Terminal: Drücken Sie 'q'"
echo ""
echo "2️⃣ Dependencies aktualisieren:"
echo "   flutter pub get"
echo ""
echo "3️⃣ App neu starten:"
echo "   flutter run -d macos"
echo ""
echo "4️⃣ CSV-Import testen:"
echo "   - Klicken Sie auf Upload-Symbol (↑)"
echo "   - Wählen Sie 'sample_voters.csv' aus"
echo "   - Erwartetes Ergebnis: '10 Wähler erfolgreich importiert'"
echo ""
echo "5️⃣ Bei Problemen - Clean Build:"
echo "   flutter clean && flutter pub get && flutter run -d macos"
echo ""

# 7. Dateipfad anzeigen
echo "📂 Vollständiger Pfad zur Beispiel-CSV:"
echo "$(pwd)/sample_voters.csv"
echo ""

echo "✅ Diagnose abgeschlossen!"
