import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happytails554/main.dart';

void main() {
  testWidgets('App starts successfully', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(MyApp());

    // Verify that the app starts with Happy Tails text
    expect(find.textContaining('Happy Tails'), findsOneWidget);
  });
}