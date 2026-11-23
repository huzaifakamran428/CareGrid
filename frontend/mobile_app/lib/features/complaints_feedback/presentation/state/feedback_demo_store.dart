import 'package:flutter/foundation.dart';

/// Session-only UI demonstration; does not call a backend.
class ServiceFeedbackRecord {
  final String reference;
  final String provider;
  final int stars;
  final String comment;
  final DateTime createdAt;
  const ServiceFeedbackRecord({
    required this.reference,
    required this.provider,
    required this.stars,
    required this.comment,
    required this.createdAt,
  });
}

class ServiceFeedbackDemoStore extends ChangeNotifier {
  final List<ServiceFeedbackRecord> _reviews = [];
  List<ServiceFeedbackRecord> get reviews => List.unmodifiable(_reviews);

  void submit({required String provider, required int stars, required String comment}) {
    if (stars < 1 || stars > 5 || provider.trim().isEmpty) {
      throw ArgumentError('Provider and 1-5 star rating required.');
    }
    final now = DateTime.now();
    _reviews.insert(0, ServiceFeedbackRecord(
      reference: 'FB-DEMO-${now.microsecondsSinceEpoch}',
      provider: provider,
      stars: stars,
      comment: comment.trim(),
      createdAt: now,
    ));
    notifyListeners();
  }
}
final serviceFeedbackDemoStore = ServiceFeedbackDemoStore();
