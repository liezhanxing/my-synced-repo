import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tongxi_english/core/widgets/anime_button.dart';

void main() {
  group('AnimeButton', () {
    testWidgets('renders with label text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeButton(
              text: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('onPressed callback fires when tapped', (WidgetTester tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeButton(
              text: 'Click Me',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Click Me'));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('disabled state prevents onPressed', (WidgetTester tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeButton(
              text: 'Disabled Button',
              onPressed: () {
                pressed = true;
              },
              isDisabled: true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Disabled Button'));
      await tester.pump();

      expect(pressed, isFalse);
    });

    testWidgets('renders with icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeButton(
              text: 'With Icon',
              onPressed: () {},
              icon: Icons.add,
            ),
          ),
        ),
      );

      expect(find.text('With Icon'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeButton(
              text: 'Loading',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing); // Text hidden when loading
    });

    testWidgets('loading state prevents onPressed', (WidgetTester tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeButton(
              text: 'Loading',
              onPressed: () {
                pressed = true;
              },
              isLoading: true,
            ),
          ),
        ),
      );

      // Try to tap on the button area (not the text, which is hidden)
      await tester.tap(find.byType(AnimeButton));
      await tester.pump();

      expect(pressed, isFalse);
    });

    testWidgets('applies custom text color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeButton(
              text: 'Colored Text',
              onPressed: () {},
              textColor: Colors.red,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Colored Text'));
      expect(textWidget.style?.color, Colors.red);
    });

    testWidgets('applies custom height', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeButton(
              text: 'Tall Button',
              onPressed: () {},
              height: 80,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AnimeButton),
          matching: find.byType(Container),
        ).first,
      );

      expect(container.constraints?.minHeight, 80);
    });

    testWidgets('applies custom border radius', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeButton(
              text: 'Rounded Button',
              onPressed: () {},
              borderRadius: 20,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AnimeButton),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      final borderRadius = decoration.borderRadius as BorderRadius;
      expect(borderRadius.topLeft.x, 20);
    });

    testWidgets('applies custom padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeButton(
              text: 'Padded Button',
              onPressed: () {},
              padding: const EdgeInsets.all(30),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AnimeButton),
          matching: find.byType(Container),
        ).first,
      );

      expect(container.padding, const EdgeInsets.all(30));
    });

    testWidgets('disabled button has grey gradient', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeButton(
              text: 'Disabled',
              onPressed: () {},
              isDisabled: true,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AnimeButton),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      final gradient = decoration.gradient as LinearGradient;
      expect(gradient.colors[0], Colors.grey.shade400);
    });

    testWidgets('disabled button has no shadow', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeButton(
              text: 'Disabled',
              onPressed: () {},
              isDisabled: true,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AnimeButton),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isEmpty);
    });
  });

  group('AnimeOutlinedButton', () {
    testWidgets('renders with label text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeOutlinedButton(
              text: 'Outlined Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Outlined Button'), findsOneWidget);
    });

    testWidgets('onPressed callback fires when tapped', (WidgetTester tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeOutlinedButton(
              text: 'Click Me',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Click Me'));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('disabled state prevents onPressed', (WidgetTester tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeOutlinedButton(
              text: 'Disabled',
              onPressed: () {
                pressed = true;
              },
              isDisabled: true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Disabled'));
      await tester.pump();

      expect(pressed, isFalse);
    });

    testWidgets('renders with icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeOutlinedButton(
              text: 'With Icon',
              onPressed: () {},
              icon: Icons.settings,
            ),
          ),
        ),
      );

      expect(find.text('With Icon'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeOutlinedButton(
              text: 'Loading',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('applies custom border color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeOutlinedButton(
              text: 'Colored Border',
              onPressed: () {},
              borderColor: Colors.blue,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AnimeOutlinedButton),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      expect(border.top.color, Colors.blue);
    });

    testWidgets('applies custom text color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeOutlinedButton(
              text: 'Colored Text',
              onPressed: () {},
              textColor: Colors.green,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Colored Text'));
      expect(textWidget.style?.color, Colors.green);
    });

    testWidgets('disabled button has grey border', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeOutlinedButton(
              text: 'Disabled',
              onPressed: () {},
              isDisabled: true,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AnimeOutlinedButton),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      expect(border.top.color, Colors.grey.shade400);
    });

    testWidgets('disabled button has grey text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeOutlinedButton(
              text: 'Disabled',
              onPressed: () {},
              isDisabled: true,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Disabled'));
      expect(textWidget.style?.color, Colors.grey);
    });

    testWidgets('shows background color when pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimeOutlinedButton(
              text: 'Press Me',
              onPressed: () {},
              borderColor: Colors.purple,
            ),
          ),
        ),
      );

      // Initial state - transparent background
      var container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AnimeOutlinedButton),
          matching: find.byType(Container),
        ).first,
      );

      var decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.transparent);

      // Press the button
      final gesture = await tester.startGesture(tester.getCenter(find.text('Press Me')));
      await tester.pump();

      container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AnimeOutlinedButton),
          matching: find.byType(Container),
        ).first,
      );

      decoration = container.decoration as BoxDecoration;
      expect(decoration.color, isNot(Colors.transparent));

      await gesture.up();
    });
  });
}
