import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import '../models/voter.dart';
import 'database_service.dart';

class CsvImportService {
  /// Öffnet einen Datei-Picker und importiert Wähler aus einer CSV-Datei
  ///
  /// Erwartet CSV-Format mit Spalten:
  /// PK-Nummer, Nachname, Vorname
  ///
  /// Gibt die Anzahl der erfolgreich importierten Wähler zurück
  static Future<CsvImportResult> importVotersFromCsv() async {
    try {
      // Datei auswählen
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
        dialogTitle: 'CSV-Datei auswählen',
        withData: false,
        withReadStream: false,
      );

      if (result == null) {
        return CsvImportResult(
          success: false,
          message: 'Keine Datei ausgewählt - Dialog wurde abgebrochen',
        );
      }

      if (result.files.isEmpty) {
        return CsvImportResult(
          success: false,
          message: 'Keine Datei in der Auswahl gefunden',
        );
      }

      final file = result.files.single;
      final filePath = file.path;

      if (filePath == null || filePath.isEmpty) {
        // Alternative: Versuche bytes zu verwenden (für Web)
        if (file.bytes != null) {
          return CsvImportResult(
            success: false,
            message:
                'Web-basierter Import wird noch nicht unterstützt. Bitte Desktop-Version verwenden.',
          );
        }

        return CsvImportResult(
          success: false,
          message:
              'Dateipfad konnte nicht ermittelt werden. Bitte überprüfen Sie die App-Berechtigungen.',
        );
      }

      // CSV-Datei lesen und parsen
      return await _parseCsvFile(filePath);
    } catch (e) {
      return CsvImportResult(
        success: false,
        message: 'Fehler beim Importieren: ${e.toString()}',
      );
    }
  }

  static Future<CsvImportResult> _parseCsvFile(String filePath) async {
    try {
      final file = File(filePath);
      final input = await file.readAsString();

      // CSV parsen
      final List<List<dynamic>> rows = const CsvToListConverter(
        fieldDelimiter: ',',
        textDelimiter: '"',
        eol: '\n',
      ).convert(input);

      if (rows.isEmpty) {
        return CsvImportResult(
          success: false,
          message: 'CSV-Datei ist leer',
        );
      }

      // Erste Zeile könnte Header sein - prüfen
      int startRow = 0;
      if (_isHeaderRow(rows[0])) {
        startRow = 1;
      }

      if (rows.length <= startRow) {
        return CsvImportResult(
          success: false,
          message: 'Keine Daten zum Importieren gefunden',
        );
      }

      // Wähler importieren
      int successCount = 0;
      int skipCount = 0;
      int errorCount = 0;
      List<String> errors = [];

      for (int i = startRow; i < rows.length; i++) {
        final row = rows[i];

        // Leere Zeilen überspringen
        if (row.isEmpty ||
            (row.length == 1 && row[0].toString().trim().isEmpty)) {
          skipCount++;
          continue;
        }

        try {
          // Mindestens 3 Spalten erforderlich: PK-Nummer, Nachname, Vorname
          if (row.length < 3) {
            errors
                .add('Zeile ${i + 1}: Nicht genügend Spalten (${row.length})');
            errorCount++;
            continue;
          }

          final pkNumber = row[0].toString().trim();
          final lastName = row[1].toString().trim();
          final firstName = row[2].toString().trim();

          if (pkNumber.isEmpty || lastName.isEmpty || firstName.isEmpty) {
            errors.add('Zeile ${i + 1}: Leere Felder gefunden');
            errorCount++;
            continue;
          }

          // Wähler erstellen
          final voter = Voter(
            pkNumber: pkNumber,
            lastName: lastName,
            firstName: firstName,
            hasVoted: false,
          );

          await DatabaseService.instance.createVoter(voter);
          successCount++;
        } catch (e) {
          // Wahrscheinlich Duplikat (UNIQUE constraint)
          if (e.toString().contains('UNIQUE')) {
            errors.add('Zeile ${i + 1}: PK-Nummer bereits vorhanden');
          } else {
            errors.add('Zeile ${i + 1}: ${e.toString()}');
          }
          errorCount++;
        }
      }

      // Ergebnis zusammenstellen
      final message = _buildResultMessage(
        successCount,
        skipCount,
        errorCount,
        errors,
      );

      return CsvImportResult(
        success: successCount > 0,
        message: message,
        importedCount: successCount,
        skippedCount: skipCount,
        errorCount: errorCount,
        errors: errors,
      );
    } catch (e) {
      return CsvImportResult(
        success: false,
        message: 'Fehler beim Parsen der CSV-Datei: ${e.toString()}',
      );
    }
  }

  static bool _isHeaderRow(List<dynamic> row) {
    if (row.isEmpty) return false;

    final firstCell = row[0].toString().toLowerCase();
    return firstCell.contains('pk') ||
        firstCell.contains('nummer') ||
        firstCell.contains('number');
  }

  static String _buildResultMessage(
    int successCount,
    int skipCount,
    int errorCount,
    List<String> errors,
  ) {
    final buffer = StringBuffer();

    if (successCount > 0) {
      buffer.write('✓ $successCount Wähler erfolgreich importiert\n');
    }

    if (skipCount > 0) {
      buffer.write('⊘ $skipCount Zeilen übersprungen (leer)\n');
    }

    if (errorCount > 0) {
      buffer.write('✗ $errorCount Fehler aufgetreten\n');

      if (errors.isNotEmpty) {
        buffer.write('\nDetails:\n');
        // Nur die ersten 10 Fehler anzeigen
        final displayErrors = errors.take(10).toList();
        for (final error in displayErrors) {
          buffer.write('• $error\n');
        }
        if (errors.length > 10) {
          buffer.write('... und ${errors.length - 10} weitere Fehler\n');
        }
      }
    }

    return buffer.toString().trim();
  }

  /// Erstellt eine Beispiel-CSV-Datei zum Testen
  static String generateSampleCsv() {
    return '''PK-Nummer,Nachname,Vorname
12345,Müller,Hans
23456,Schmidt,Anna
34567,Wagner,Peter
45678,Fischer,Maria
56789,Weber,Thomas''';
  }
}

class CsvImportResult {
  final bool success;
  final String message;
  final int importedCount;
  final int skippedCount;
  final int errorCount;
  final List<String> errors;

  CsvImportResult({
    required this.success,
    required this.message,
    this.importedCount = 0,
    this.skippedCount = 0,
    this.errorCount = 0,
    this.errors = const [],
  });
}
