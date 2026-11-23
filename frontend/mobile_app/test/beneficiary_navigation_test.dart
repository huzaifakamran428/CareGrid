import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caregrid_mobile/app/app.dart';

void main() {
  testWidgets('CareGrid opens one shell with five tabs', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const CareGridApp());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    for (final title in ['Home', 'Labs', 'Bookings', 'Support', 'Profile']) {
      expect(find.text(title), findsWidgets);
    }

    await tester.tap(find.text('Support').last);
    await tester.pumpAndSettle();
    expect(find.text('My complaints'), findsWidgets);

    await tester.tap(find.byTooltip('Submit a complaint').first);
    await tester.pumpAndSettle();
    expect(find.text('Tell us about your concern'), findsOneWidget);
  });
}
