// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:belajar_flutter/main.dart';

void main() {
  testWidgets('Tests', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const TaskBuddyApp());

    // Check title
    expect(find.text('MyTask'), findsOneWidget);
    expect(find.text('3 tasks to finish'), findsOneWidget);

    // New task
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Form
    await tester.enterText(find.widgetWithText(TextFormField, 'e.g. Algebra Worksheet 5'), 'Physics Homework');
    await tester.enterText(find.widgetWithText(TextFormField, 'e.g. Math'), 'Physics');
    
    // Date
    await tester.tap(find.widgetWithText(TextFormField, 'Select due date'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK')); 
    await tester.pumpAndSettle();

    // Save Task
    await tester.tap(find.text('Save Task'));
    await tester.pumpAndSettle();

    // Check new task
    expect(find.text('Physics Homework'), findsOneWidget);
    expect(find.text('4 tasks to finish'), findsOneWidget);

    // Empty form
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Save Task without filling the form
    await tester.tap(find.text('Save Task'));
    await tester.pump();

    // Error messages
    expect(find.text('Please enter a task title'), findsOneWidget);
    expect(find.text('Please enter a subject'), findsOneWidget);

    // Back icon
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Edit Task
    await tester.tap(find.byIcon(Icons.edit_outlined).first);
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Algebra Worksheet 5'), 'Algebra Quiz 1');
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    expect(find.text('Algebra Quiz 1'), findsOneWidget);
    expect(find.text('Algebra Worksheet 5'), findsNothing);

    // Delete Task
    await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
    await tester.pumpAndSettle();

    // Cancel
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Algebra Quiz 1'), findsOneWidget);

    // Confirmation
    await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Algebra Quiz 1'), findsNothing);
  });
}