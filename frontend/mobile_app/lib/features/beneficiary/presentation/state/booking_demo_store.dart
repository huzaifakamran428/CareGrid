import 'package:flutter/foundation.dart';

/// One source of truth for in-session demo appointments.
/// The entries are NOT sent to laboratories and are lost when the app restarts.
class BookingDemoStore extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> get bookings => List.unmodifiable(_items);

  static String formatDate(DateTime date) {
    const months = <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Map<String, dynamic> add({
    required Map<String, dynamic> test,
    required DateTime date,
    required String timeSlot,
    required bool attachPrescription,
  }) {
    if (timeSlot.isEmpty) throw ArgumentError('A time slot is required');
    final ref = 'BKG-DEMO-${DateTime.now().microsecondsSinceEpoch}';
    final entry = <String, dynamic>{
      ...test,
      'bookingRef': ref,
      'testName': test['testName'] ?? 'Lab test',
      'labName': test['labName'] ?? 'Partner lab',
      'date': formatDate(date),
      'scheduledDate': date,
      'timeSlot': timeSlot,
      'status': 'Upcoming',
      'payableAmount': test['payableAmount'] ?? test['subsidizedPrice'] ?? 0,
      'originalPrice': test['originalPrice'] ?? 0,
      'subsidyPercent': test['subsidyPercent'] ?? 0,
      'prescriptionAttached': attachPrescription,
      'reportReady': false,
    };
    _items.insert(0, entry);
    notifyListeners();
    return Map<String, dynamic>.unmodifiable(entry);
  }

  bool cancel(String reference) {
    final index = _items.indexWhere((item) => item['bookingRef'] == reference);
    if (index < 0 || _items[index]['status'] != 'Upcoming') return false;
    _items[index]['status'] = 'Cancelled';
    notifyListeners();
    return true;
  }

  bool reschedule(String reference, {required DateTime date, required String timeSlot}) {
    final index = _items.indexWhere((item) => item['bookingRef'] == reference);
    if (index < 0 || _items[index]['status'] != 'Upcoming') return false;
    if (timeSlot.isEmpty) return false;
    _items[index]['scheduledDate'] = date;
    _items[index]['date'] = formatDate(date);
    _items[index]['timeSlot'] = timeSlot;
    notifyListeners();
    return true;
  }
}

final bookingDemoStore = BookingDemoStore();
