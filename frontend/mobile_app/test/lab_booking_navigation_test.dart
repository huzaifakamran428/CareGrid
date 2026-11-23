import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caregrid_mobile/app/app.dart';

void main() {
  testWidgets('lab search connects to selected test details and booking', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const CareGridApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Labs').last);
    await tester.pumpAndSettle();
    expect(find.text('Complete Blood Count (CBC)'), findsWidgets);

    final bookAction = find.text('View & Book').first;
    await tester.ensureVisible(bookAction);
    await tester.tap(bookAction);
    await tester.pumpAndSettle();
    expect(find.text('Select Time Slot & Book Appointment'), findsOneWidget);

    final next = find.text('Select Time Slot & Book Appointment');
    await tester.ensureVisible(next);
    await tester.tap(next);
    await tester.pumpAndSettle();
    expect(find.text('Save Demo Appointment'), findsOneWidget);
  });

  testWidgets('support routes feedback to one separate rating form', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const CareGridApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Support').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rate a service & share feedback'));
    await tester.pumpAndSettle();
    expect(find.text('Rate a welfare service'), findsOneWidget);
    expect(find.text('Service provider'), findsOneWidget);
  });
}
