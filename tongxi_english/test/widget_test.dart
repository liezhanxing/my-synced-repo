import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tongxi_english/app/app.dart';

void main() {
  testWidgets('App renders without error', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TongxiEnglishApp());

    // Verify that the app title is present
    expect(find.text('童希英语'), findsOneWidget);
  });
}
