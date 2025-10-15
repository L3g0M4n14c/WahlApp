import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/voter_provider.dart';
import '../services/csv_import_service.dart';
import '../models/voter.dart';

class VoterListScreen extends StatefulWidget {
  const VoterListScreen({super.key});

  @override
  State<VoterListScreen> createState() => _VoterListScreenState();
}

class _VoterListScreenState extends State<VoterListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VoterProvider>().loadVoters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddVoterDialog() {
    final pkController = TextEditingController();
    final lastNameController = TextEditingController();
    final firstNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wähler hinzufügen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: pkController,
              decoration: const InputDecoration(
                labelText: 'PK-Nummer',
                hintText: 'z.B. 12345',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Nachname',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'Vorname',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (pkController.text.isEmpty ||
                  lastNameController.text.isEmpty ||
                  firstNameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bitte alle Felder ausfüllen'),
                  ),
                );
                return;
              }

              final voter = Voter(
                pkNumber: pkController.text.trim(),
                lastName: lastNameController.text.trim(),
                firstName: firstNameController.text.trim(),
              );

              try {
                await context.read<VoterProvider>().addVoter(voter);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Wähler erfolgreich hinzugefügt'),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Fehler: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }

  Future<void> _importCsvFile() async {
    // Ladedialog anzeigen
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('CSV-Datei wird importiert...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final result = await CsvImportService.importVotersFromCsv();

      if (mounted) {
        // Ladedialog schließen
        Navigator.pop(context);

        // Ergebnis anzeigen
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  result.success ? Icons.check_circle : Icons.error,
                  color: result.success ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(result.success
                    ? 'Import abgeschlossen'
                    : 'Import fehlgeschlagen'),
              ],
            ),
            content: SingleChildScrollView(
              child: Text(result.message),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );

        // Wählerliste neu laden
        if (result.success) {
          context.read<VoterProvider>().loadVoters();
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Ladedialog schließen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wählerverzeichnis'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            tooltip: 'CSV importieren',
            onPressed: _importCsvFile,
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'import_info',
                child: Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: 8),
                    Text('CSV-Format Info'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'import_info') {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('CSV-Datei Format'),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Die CSV-Datei sollte folgendes Format haben:\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text('PK-Nummer,Nachname,Vorname\n'),
                          const Text('Beispiel:'),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              CsvImportService.generateSampleCsv(),
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Hinweise:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text('• Die erste Zeile (Header) ist optional'),
                          const Text('• Kommas als Trennzeichen verwenden'),
                          const Text('• UTF-8 Kodierung empfohlen'),
                          const Text('• Duplikate werden übersprungen'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Schließen'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Suchen',
                    hintText: 'PK-Nummer, Name oder Vorname',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              context.read<VoterProvider>().searchVoters('');
                              setState(() {});
                            },
                          )
                        : null,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    context.read<VoterProvider>().searchVoters(value);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),
                Consumer<VoterProvider>(
                  builder: (context, provider, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatCard(
                          label: 'Gesamt',
                          value: provider.totalVoters.toString(),
                          color: Colors.blue,
                        ),
                        _StatCard(
                          label: 'Gewählt',
                          value: provider.votedCount.toString(),
                          color: Colors.green,
                        ),
                        _StatCard(
                          label: 'Ausstehend',
                          value: provider.notVotedCount.toString(),
                          color: Colors.orange,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Consumer<VoterProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (provider.voters.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          provider.searchQuery.isEmpty
                              ? 'Keine Wähler vorhanden'
                              : 'Keine Wähler gefunden',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: provider.voters.length,
                  itemBuilder: (context, index) {
                    final voter = provider.voters[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              voter.hasVoted ? Colors.green : Colors.grey[300],
                          child: Icon(
                            voter.hasVoted ? Icons.check : Icons.person,
                            color: voter.hasVoted ? Colors.white : Colors.grey,
                          ),
                        ),
                        title: Text(
                          '${voter.lastName}, ${voter.firstName}',
                          style: TextStyle(
                            decoration: voter.hasVoted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Text('PK: ${voter.pkNumber}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: voter.hasVoted,
                              onChanged: (value) {
                                provider.toggleVoted(voter);
                              },
                            ),
                            PopupMenuButton(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Löschen'),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'delete') {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Wähler löschen'),
                                      content: Text(
                                        'Möchten Sie ${voter.firstName} ${voter.lastName} wirklich löschen?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Abbrechen'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            provider.deleteVoter(voter);
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text('Löschen'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddVoterDialog,
        tooltip: 'Wähler hinzufügen',
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
