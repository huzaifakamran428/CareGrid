import 'package:flutter/foundation.dart';

/// Local-only presentation data. This is NOT an API repository or persistent store.
enum ComplaintStatus { submitted, inProgress, resolved }

class ComplaintRecord {
  final String reference;
  final String subject;
  final String category;
  final String description;
  final String serviceReference;
  final DateTime createdAt;
  final ComplaintStatus status;
  final String? adminResponse;

  const ComplaintRecord({
    required this.reference,
    required this.subject,
    required this.category,
    required this.description,
    required this.createdAt,
    required this.status,
    this.serviceReference = '',
    this.adminResponse,
  });
}

class ComplaintDemoStore extends ChangeNotifier {
  final List<ComplaintRecord> _items = [
    ComplaintRecord(
      reference: 'CG-CMP-10240',
      subject: 'Beneficiary registration delay',
      category: 'Registration',
      description: 'My application still shows under review. Please tell me if I need to provide any more documents.',
      createdAt: DateTime(2026, 11, 20),
      status: ComplaintStatus.inProgress,
      adminResponse: 'We are reviewing your application. Please check your registration status for updates.',
    ),
    ComplaintRecord(
      reference: 'CG-CMP-10238',
      subject: 'Food support request clarification',
      category: 'Food assistance',
      description: 'I need help understanding how to track the progress of my food support request.',
      createdAt: DateTime(2026, 11, 18),
      status: ComplaintStatus.resolved,
      adminResponse: 'You can check the updated request status in the welfare support area. Your query is now resolved.',
    ),
  ];

  // Uniqueness is local to this demonstration; production IDs must be server-issued.
  int _localSequence = 0;

  List<ComplaintRecord> get complaints => List.unmodifiable(_items);

  ComplaintRecord? findByReference(String reference) {
    for (final item in _items) {
      if (item.reference == reference) return item;
    }
    return null;
  }

  ComplaintRecord submit({
    required String category,
    required String subject,
    required String description,
    String serviceReference = '',
  }) {
    _localSequence++;
    final now = DateTime.now();
    final reference = 'CG-DEMO-${now.microsecondsSinceEpoch}-$_localSequence';
    final record = ComplaintRecord(
      reference: reference,
      subject: subject.trim(),
      category: category,
      description: description.trim(),
      serviceReference: serviceReference.trim(),
      createdAt: now,
      status: ComplaintStatus.submitted,
    );
    _items.insert(0, record);
    notifyListeners();
    return record;
  }
}

final complaintDemoStore = ComplaintDemoStore();
