import 'package:confidex/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('Confidex app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const ConfidexApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}