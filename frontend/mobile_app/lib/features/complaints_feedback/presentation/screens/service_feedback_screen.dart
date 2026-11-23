import 'package:flutter/material.dart';
import '../state/feedback_demo_store.dart';
import '../widgets/complaint_components.dart';

/// Service ratings are separate from complaint submission and tracking.
class ServiceFeedbackScreen extends StatefulWidget {
  const ServiceFeedbackScreen({super.key});
  @override
  State<ServiceFeedbackScreen> createState() => _ServiceFeedbackScreenState();
}

class _ServiceFeedbackScreenState extends State<ServiceFeedbackScreen> {
  final _notes = TextEditingController();
  String? _provider;
  int _rating = 0;
  static const _providers = <String>[
    'Al-Khidmat Foundation',
    'Chughtai Lab - Johar Town',
    'Shaukat Khanum Diagnostic Centre',
    'Sehat Welfare Pharmacy - Johar Town',
    'Other welfare service',
  ];
  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  void _submit() {
    if (_provider == null || _rating < 1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Choose a provider and a star rating first.'),
      ));
      return;
    }
    serviceFeedbackDemoStore.submit(
      provider: _provider!,
      stars: _rating,
      comment: _notes.text,
    );
    _notes.clear();
    setState(() { _provider = null; _rating = 0; });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Demo feedback added. Nothing was sent to an NGO.'),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Rate a welfare service')),
    body: SafeArea(child: ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('Share your experience', style: TextStyle(
          fontSize: 24, fontWeight: FontWeight.w800, color: CgColors.ink,
        )),
        const SizedBox(height: 8),
        const Text('Ratings are saved only for this app session.',
            style: TextStyle(color: CgColors.secondary, height: 1.5)),
        const SizedBox(height: 18),
        CgCard(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Service provider', style: TextStyle(
              fontWeight: FontWeight.w700, color: CgColors.ink,
            )),
            const SizedBox(height: 9),
            DropdownButtonFormField<String>(
              value: _provider,
              isExpanded: true,
              hint: const Text('Select a provider'),
              items: _providers.map((name) => DropdownMenuItem(
                value: name,
                child: Text(name, overflow: TextOverflow.ellipsis),
              )).toList(),
              onChanged: (value) => setState(() => _provider = value),
            ),
            const SizedBox(height: 18),
            const Text('How was the service?', style: TextStyle(
              fontWeight: FontWeight.w700, color: CgColors.ink,
            )),
            Row(children: List.generate(5, (index) => IconButton(
              tooltip: '${index + 1} stars',
              onPressed: () => setState(() => _rating = index + 1),
              icon: Icon(index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 30, color: const Color(0xFFD89622)),
            ))),
            const SizedBox(height: 12),
            TextField(
              controller: _notes,
              maxLength: 500,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Comments (optional)',
                hintText: 'What can improve?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            CgPrimaryButton(
              label: 'Submit demo feedback',
              icon: Icons.send_rounded,
              onPressed: _submit,
            ),
          ],
        )),
        const SizedBox(height: 20),
        const Text('My feedback', style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w800, color: CgColors.ink,
        )),
        const SizedBox(height: 10),
        AnimatedBuilder(
          animation: serviceFeedbackDemoStore,
          builder: (context, _) {
            final reviews = serviceFeedbackDemoStore.reviews;
            if (reviews.isEmpty) {
              return const CgCard(child: Text(
                'No feedback submitted in this session.',
                style: TextStyle(color: CgColors.secondary),
              ));
            }
            return Column(children: reviews.map((review) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CgCard(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review.provider, style: const TextStyle(
                    fontWeight: FontWeight.w700, color: CgColors.ink,
                  )),
                  const SizedBox(height: 6),
                  Text('${'★' * review.stars}${'☆' * (5 - review.stars)}',
                      style: const TextStyle(fontSize: 22, color: Color(0xFFD89622))),
                  if (review.comment.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(review.comment),
                  ],
                  const SizedBox(height: 5),
                  const Text('Demo only • Not sent to provider',
                      style: TextStyle(fontSize: 11, color: CgColors.secondary)),
                ],
              )),
            )).toList());
          },
        ),
      ],
    )),
  );
}
