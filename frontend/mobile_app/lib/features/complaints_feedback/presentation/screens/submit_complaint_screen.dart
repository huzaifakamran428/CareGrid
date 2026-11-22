import 'package:flutter/material.dart';
import '../state/complaint_demo_store.dart';
import '../widgets/complaint_components.dart';
import 'complaint_submitted_screen.dart';

/// Accessible beneficiary complaint form. Validates fields locally only.
class SubmitComplaintScreen extends StatefulWidget {
  const SubmitComplaintScreen({super.key});

  @override
  State<SubmitComplaintScreen> createState() => _SubmitComplaintScreenState();
}

class _SubmitComplaintScreenState extends State<SubmitComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subject = TextEditingController();
  final _details = TextEditingController();
  final _serviceReference = TextEditingController();
  String? _category;
  bool _submitting = false;
  static const categories = ['Registration', 'Food assistance', 'Healthcare', 'Laboratory', 'Account access', 'Other'];

  @override
  void dispose() {
    _subject.dispose();
    _details.dispose();
    _serviceReference.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate() || _submitting) return;
    setState(() => _submitting = true);
    final record = complaintDemoStore.submit(
      category: _category!,
      subject: _subject.text,
      description: _details.text,
      serviceReference: _serviceReference.text,
    );
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (_) => ComplaintSubmittedScreen(reference: record.reference),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Submit a complaint')),
    body: SafeArea(child: Form(
      key: _formKey,
      child: Column(children: [
        Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(19, 7, 19, 25), children: [
          const Text('GET SUPPORT', style: TextStyle(color: CgColors.primary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.1)),
          const SizedBox(height: 9),
          const Text('Tell us about your concern', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -.45, color: CgColors.ink)),
          const SizedBox(height: 8),
          const Text('Please provide enough information so our support team can understand your issue.', style: TextStyle(fontSize: 13, height: 1.6, color: CgColors.secondary)),
          const SizedBox(height: 21),
          CgCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 37, height: 37, decoration: BoxDecoration(color: CgColors.paleMint, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.edit_document, color: CgColors.primary, size: 20)),
              const SizedBox(width: 11),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Complaint information', style: TextStyle(fontWeight: FontWeight.w800, color: CgColors.ink, fontSize: 15)),
                SizedBox(height: 3),
                Text('Fields marked * are required', style: TextStyle(color: CgColors.secondary, fontSize: 11)),
              ])),
            ]),
            const SizedBox(height: 23),
            _label('Complaint category *'),
            DropdownButtonFormField<String>(
              value: _category,
              isExpanded: true,
              hint: const Text('Select an issue type', style: TextStyle(color: CgColors.secondary, fontSize: 13)),
              items: categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
              onChanged: (value) => setState(() => _category = value),
              validator: (value) => value == null ? 'Please select a category.' : null,
            ),
            const SizedBox(height: 19),
            _label('Subject *'),
            TextFormField(
              controller: _subject,
              maxLength: 100,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(hintText: 'Briefly describe your issue', hintStyle: TextStyle(color: CgColors.secondary, fontSize: 13)),
              validator: (text) => (text ?? '').trim().length < 5 ? 'Please enter at least 5 characters.' : null,
            ),
            const SizedBox(height: 10),
            _label('Description *'),
            TextFormField(
              controller: _details,
              minLines: 5,
              maxLines: 8,
              maxLength: 1200,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(hintText: 'What happened? When did the issue occur? What help do you need?', hintStyle: TextStyle(color: CgColors.secondary, fontSize: 13)),
              validator: (text) => (text ?? '').trim().length < 15 ? 'Please enter at least 15 characters.' : null,
            ),
            const SizedBox(height: 8),
            _label('Related service / application reference (optional)'),
            TextFormField(
              controller: _serviceReference,
              maxLength: 70,
              decoration: const InputDecoration(hintText: 'e.g. CG-BEN-1001', hintStyle: TextStyle(color: CgColors.secondary, fontSize: 13)),
            ),
          ])),
          const SizedBox(height: 17),
          const DemoNotice(),
          const SizedBox(height: 7),
        ])),
        Container(
          padding: const EdgeInsets.fromLTRB(19, 13, 19, 16),
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: CgColors.line))),
          child: CgPrimaryButton(label: 'Submit complaint', icon: Icons.send_rounded, onPressed: _submitting ? null : _submit),
        ),
      ]),
    )),
  );

  Widget _label(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(label, style: const TextStyle(color: CgColors.ink, fontWeight: FontWeight.w800, fontSize: 12)),
  );
}
