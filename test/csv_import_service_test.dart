import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:wahlapp/services/csv_import_service.dart';

void main() {
  group('CSV Import Service Tests', () {
    late Directory tempDir;

    setUp(() async {
      // Temporäres Verzeichnis für Test-Dateien erstellen
      tempDir = await Directory.systemTemp.createTemp('csv_test_');
    });

    tearDown(() async {
      // Temporäres Verzeichnis aufräumen
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('generateSampleCsv sollte gültiges CSV zurückgeben', () {
      final csv = CsvImportService.generateSampleCsv();

      expect(csv, isNotEmpty);
      expect(csv, contains('PK-Nummer'));
      expect(csv, contains('Nachname'));
      expect(csv, contains('Vorname'));
      expect(csv, contains('Müller'));
    });

    test('CsvImportResult sollte korrekt initialisiert werden', () {
      final result = CsvImportResult(
        success: true,
        message: 'Test erfolgreich',
        importedCount: 5,
        skippedCount: 2,
        errorCount: 1,
        errors: ['Fehler 1'],
      );

      expect(result.success, isTrue);
      expect(result.message, equals('Test erfolgreich'));
      expect(result.importedCount, equals(5));
      expect(result.skippedCount, equals(2));
      expect(result.errorCount, equals(1));
      expect(result.errors.length, equals(1));
    });

    test('CsvImportResult mit Standardwerten', () {
      final result = CsvImportResult(
        success: false,
        message: 'Fehlgeschlagen',
      );

      expect(result.success, isFalse);
      expect(result.importedCount, equals(0));
      expect(result.skippedCount, equals(0));
      expect(result.errorCount, equals(0));
      expect(result.errors, isEmpty);
    });

    test('CSV-Format sollte korrekt generiert werden', () {
      final csv = CsvImportService.generateSampleCsv();
      final lines = csv.split('\n');

      // Header prüfen
      expect(lines[0], equals('PK-Nummer,Nachname,Vorname'));

      // Mindestens eine Datenzeile prüfen
      expect(lines.length, greaterThan(1));

      // Erste Datenzeile prüfen
      final firstDataLine = lines[1].split(',');
      expect(firstDataLine.length, equals(3));
    });

    test('CSV mit Umlauten sollte korrekt behandelt werden', () {
      final csv = CsvImportService.generateSampleCsv();

      expect(csv, contains('Müller'));
      // UTF-8 Zeichen sollten vorhanden sein
      expect(
          csv.contains('ü') || csv.contains('ä') || csv.contains('ö'), isTrue);
    });
  });

  group('CSV Import Result Formatting', () {
    test('Erfolgsmeldung sollte korrekt formatiert sein', () {
      final result = CsvImportResult(
        success: true,
        message: '✓ 10 Wähler erfolgreich importiert',
        importedCount: 10,
      );

      expect(result.message, contains('✓'));
      expect(result.message, contains('10'));
      expect(result.message, contains('erfolgreich'));
    });

    test('Fehlermeldung sollte korrekt formatiert sein', () {
      final result = CsvImportResult(
        success: false,
        message: '✗ 5 Fehler aufgetreten',
        errorCount: 5,
      );

      expect(result.message, contains('✗'));
      expect(result.message, contains('5'));
      expect(result.message, contains('Fehler'));
    });

    test('Gemischtes Ergebnis sollte alle Komponenten enthalten', () {
      final result = CsvImportResult(
        success: true,
        message:
            '✓ 8 Wähler erfolgreich importiert\n⊘ 2 Zeilen übersprungen (leer)\n✗ 1 Fehler aufgetreten',
        importedCount: 8,
        skippedCount: 2,
        errorCount: 1,
      );

      expect(result.message, contains('✓'));
      expect(result.message, contains('⊘'));
      expect(result.message, contains('✗'));
      expect(result.success, isTrue);
    });
  });

  group('Error Handling', () {
    test('Leere Fehlerliste sollte korrekt behandelt werden', () {
      final result = CsvImportResult(
        success: false,
        message: 'Fehler',
        errors: [],
      );

      expect(result.errors, isEmpty);
    });

    test('Mehrere Fehler sollten gespeichert werden', () {
      final errors = [
        'Zeile 1: Fehler',
        'Zeile 2: Fehler',
        'Zeile 3: Fehler',
      ];

      final result = CsvImportResult(
        success: false,
        message: 'Mehrere Fehler',
        errorCount: 3,
        errors: errors,
      );

      expect(result.errors.length, equals(3));
      expect(result.errorCount, equals(3));
    });
  });
}
