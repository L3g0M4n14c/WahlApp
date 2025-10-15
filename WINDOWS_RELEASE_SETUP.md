# 🚀 Windows Release Setup - Fertig!

## ✅ Was wurde eingerichtet:

### 1. GitHub Actions Workflow
- **Datei:** `.github/workflows/windows-release.yml`
- **Funktion:** Baut automatisch eine Windows-App bei jedem neuen Tag/Release
- **Output:** `WahlApp-Windows.zip` - Fertige, ausführbare App

### 2. Dokumentation
- **WINDOWS_INSTALLATION.md** - Installationsanleitung für Endbenutzer
- **RELEASE_GUIDE.md** - Anleitung für dich, um neue Releases zu erstellen
- **README.md** - Aktualisiert mit Windows-Download-Link

## 🎯 Nächste Schritte

### Ersten Release erstellen:

```bash
# 1. Alle Änderungen committen
git add .
git commit -m "Setup Windows release workflow"
git push origin main

# 2. Tag erstellen und pushen
git tag -a v1.0.0 -m "Erste Windows-Version"
git push origin v1.0.0
```

### Dann:
1. Gehe zu GitHub → Actions Tab
2. Warte ~5-10 Minuten bis der Build fertig ist
3. Gehe zu GitHub → Releases
4. Der Release mit `WahlApp-Windows.zip` ist automatisch erstellt! 🎉

## 📥 Download-Link

Nach dem ersten Release können Nutzer die App herunterladen von:
```
https://github.com/L3g0M4n14c/WahlApp/releases
```

## 📝 Wichtige Hinweise

- **Automatisch:** Bei jedem Tag `v*` wird automatisch gebaut
- **Manuell:** Der Workflow kann auch manuell gestartet werden (GitHub Actions → Run workflow)
- **Artefakte:** Builds ohne Tag werden 90 Tage als Artefakte gespeichert
- **Größe:** Die ZIP-Datei ist ca. 15-20 MB groß

## 🔄 Zukünftige Releases

Für jedes Update:
```bash
# Version in pubspec.yaml ändern (optional)
# Dann:
git tag -a v1.0.1 -m "Beschreibung der Änderungen"
git push origin v1.0.1
```

Fertig! 🚀
