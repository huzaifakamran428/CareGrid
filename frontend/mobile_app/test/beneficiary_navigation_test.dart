import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caregrid_mobile/app/app.dart';

void main() {
  testWidgets('CareGrid mobile renders 5-tab shell when authenticated', (WidgetTester tester) async {
    await tester.pumpWidget(const CareGridApp(startAuthenticated: true));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
