import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caregrid_mobile/app/app.dart';
import 'package:caregrid_mobile/app/theme/brand_tokens.dart';
import 'package:caregrid_mobile/core/widgets/caregrid_brand.dart';

void main() {
  testWidgets('all five beneficiary tabs use logo and shared design tokens', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const CareGridApp());
    await tester.pumpAndSettle();
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.theme!.colorScheme.primary, CareGridPalette.primary);
    expect(app.theme!.colorScheme.secondary, CareGridPalette.gold);
    expect(find.byType(NavigationBar), findsOneWidget);

    for (final tab in ['Home', 'Labs', 'Bookings', 'Support', 'Profile']) {
      await tester.tap(find.text(tab).last);
      await tester.pumpAndSettle();
      expect(find.byType(CareGridBrandStrip), findsWidgets,
          reason: '$tab must display the real CareGrid brand');
      expect(find.byType(NavigationBar), findsOneWidget);
    }

    await tester.tap(find.byTooltip('Submit a complaint'));
    await tester.pumpAndSettle();
    expect(find.byType(CareGridPageTitle), findsOneWidget);
  });

  testWidgets('compact phone keeps the unified logo and five destinations', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const CareGridApp());
    await tester.pumpAndSettle();
    expect(find.byType(CareGridBrandStrip), findsWidgets);
    for (final tab in ['Labs', 'Bookings', 'Support', 'Profile']) {
      await tester.tap(find.text(tab).last);
      await tester.pumpAndSettle();
      expect(find.byType(CareGridBrandStrip), findsWidgets);
    }
  });
}
