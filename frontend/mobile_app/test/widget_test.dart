import 'package:flutter_test/flutter_test.dart';
import 'package:caregrid_mobile/app/app.dart';

void main() {
  testWidgets('CareGrid mobile starts on auth screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CareGridApp());
    await tester.pumpAndSettle();
    expect(find.text('CareGrid'), findsWidgets);
  });
}
