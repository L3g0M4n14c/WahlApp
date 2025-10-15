import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wahlapp/main.dart';

void main() {
  testWidgets('App should display WahlApp title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app bar contains the title
    expect(find.text('Wählerverzeichnis'), findsOneWidget);
  });

  testWidgets('App should show add voter button', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the floating action button is present
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.person_add), findsOneWidget);
  });

  testWidgets('App should show search field', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the search field is present
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
