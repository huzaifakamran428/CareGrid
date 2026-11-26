import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caregrid_mobile/app/app.dart';

void main() {
  testWidgets('CareGrid mobile starts on Beneficiary Auth and enters 5-tab shell', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const CareGridApp());
    await tester.pumpAndSettle();

    expect(find.text('Create Beneficiary Account'), findsOneWidget);

    await tester.pumpWidget(const CareGridApp(startAuthenticated: true));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
