import 'package:flutter_test/flutter_test.dart';
import 'package:caregrid_mobile/features/beneficiary/presentation/state/booking_demo_store.dart';
import 'package:caregrid_mobile/features/complaints_feedback/presentation/state/complaint_demo_store.dart';
import 'package:caregrid_mobile/features/complaints_feedback/presentation/state/feedback_demo_store.dart';

void main() {
  test('booking is shared across create, reschedule and cancel', () {
    final store = BookingDemoStore();
    final record = store.add(
      test: {
        'testName': 'CBC',
        'labName': 'Test Lab',
        'originalPrice': 1500,
        'payableAmount': 300,
        'subsidyPercent': 80,
      },
      date: DateTime(2026, 12, 1),
      timeSlot: '10:15 AM',
      attachPrescription: false,
    );
    final id = record['bookingRef'] as String;
    expect(store.bookings.single['testName'], 'CBC');
    expect(store.bookings.single['payableAmount'], 300);
    expect(store.reschedule(id,
        date: DateTime(2026, 12, 2), timeSlot: '11:00 AM'), isTrue);
    expect(store.bookings.single['date'], '2 Dec 2026');
    expect(store.cancel(id), isTrue);
    expect(store.bookings.single['status'], 'Cancelled');
    expect(store.cancel(id), isFalse);
    store.dispose();
  });

  test('complaint store generates unique in-session IDs', () {
    final store = ComplaintDemoStore();
    final a = store.submit(
      category: 'Healthcare',
      subject: 'First issue',
      description: 'First description long enough',
    );
    final b = store.submit(
      category: 'Laboratory',
      subject: 'Second issue',
      description: 'Second description long enough',
    );
    expect(a.reference, isNot(b.reference));
    expect(store.findByReference(b.reference)?.subject, 'Second issue');
    store.dispose();
  });

  test('feedback holds only session ratings and validates score', () {
    final store = ServiceFeedbackDemoStore();
    store.submit(provider: 'Test Lab', stars: 4, comment: 'Good');
    expect(store.reviews.single.stars, 4);
    expect(() => store.submit(provider: 'Test Lab', stars: 0, comment: ''),
        throwsArgumentError);
    store.dispose();
  });

  test('chat history contains messages actually sent to the demo bot', () {
    final id = store.startSession();
    store.addMessage(id, sender: 'user', text: 'How do I book a test?');
    store.addMessage(id, sender: 'ai', text: 'Browse the labs tab.');
    expect(store.sessions.single.title, 'How do I book a test?');
    expect(store.sessions.single.messages.length, 2);
    expect(store.deleteSession(id), isTrue);
    expect(store.sessions, isEmpty);
    store.dispose();
  });
}
