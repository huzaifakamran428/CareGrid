import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caregrid_mobile/core/widgets/caregrid_identity_card.dart';
import 'package:caregrid_mobile/features/beneficiary/presentation/screens/beneficiary_home_screen.dart';

void main() {
  testWidgets('beneficiary card follows NGO identity layout on a compact iPhone',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: CareGridIdentityCard(
              name: 'Sample Beneficiary',
              digitalId: 'CG-BEN-DEMO-001',
              issuedAt: '14 Nov 2026',
              cnic: 'Not recorded',
              address: 'Lahore',
            ),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('NGO BENEFICIARY CARD'), findsOneWidget);
    expect(find.text('BENEFICIARY NAME'), findsOneWidget);
    expect(find.text('Sample Beneficiary'), findsOneWidget);
    expect(find.text('CG-BEN-DEMO-001'), findsOneWidget);
    expect(find.textContaining('NOT VALID FOR VERIFICATION'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('beneficiary Home uses the reusable screenshot-matched card',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(MaterialApp(
      home: BeneficiaryHomeScreen(onOpen: (_) {}),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(CareGridIdentityCard), findsOneWidget);
    expect(find.text('Welfare overview'), findsOneWidget);
  });
}
