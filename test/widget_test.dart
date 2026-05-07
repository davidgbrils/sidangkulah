import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidangkufix/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App Smoke Test - Splash Screen loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SidangKuApp());

    // Verify that the Splash Screen is shown
    expect(find.text('SidangKu'), findsOneWidget);
    expect(find.text('Sistem Manajemen Sidang Skripsi'), findsOneWidget);
    
    // Check for the school icon
    expect(find.byIcon(Icons.school_rounded), findsOneWidget);

    // Wait for the splash screen duration and navigation
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
