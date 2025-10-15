import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/voter_provider.dart';
import 'screens/voter_list_screen.dart';

void main() {
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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const VoterListScreen(),
      ),
    );
  }
}
