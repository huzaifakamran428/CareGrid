import 'package:flutter_test/flutter_test.dart';
import 'package:caregrid_mobile/features/beneficiary/presentation/state/booking_demo_store.dart';

void main() {
  test('BookingDemoStore initializes with empty bookings list', () {
    final store = BookingDemoStore();
    expect(store.bookings, isEmpty);
  });
}
