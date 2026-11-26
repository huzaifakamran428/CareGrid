import 'package:flutter/material.dart';
import '../../../../core/widgets/caregrid_brand.dart';
import '../state/complaint_demo_store.dart';
import '../widgets/complaint_components.dart';

/// Beneficiary can view the complaint reference, status and any example admin reply.
class ComplaintDetailScreen extends StatelessWidget {
  final String reference;
  const ComplaintDetailScreen({super.key, required this.reference});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const CareGridPageTitle('Complaint details')),
    body: SafeArea(child: AnimatedBuilder(
      animation: complaintDemoStore,
      builder: (context, _) {
        final record = complaintDemoStore.findByReference(reference);
        if (record == null) {
          return const Center(child: Text('Complaint not found.', style: TextStyle(color: CgColors.secondary)));
        }
        return ListView(padding: const EdgeInsets.fromLTRB(19, 10, 19, 27), children: [
          const Text('YOUR SUPPORT REQUEST', style: TextStyle(color: CgColors.primary, fontWeight: FontWeight.w800, letterSpacing: 1.2, fontSize: 10)),
          const SizedBox(height: 9),
          Text(record.subject, style: const TextStyle(color: CgColors.ink, fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: -.5)),
          const SizedBox(height: 15),
          Row(children: [
            ComplaintStatusBadge(status: record.status),
            const SizedBox(width: 10),
            Flexible(child: Text(complaintDate(record.createdAt), style: const TextStyle(color: CgColors.secondary, fontSize: 12))),
          ]),
          const SizedBox(height: 19),
          CgCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _label('Complaint reference'),
            SelectableText(record.reference, style: const TextStyle(color: CgColors.primary, fontSize: 13, fontWeight: FontWeight.w800)),
            const Divider(height: 29, color: CgColors.line),
            _label('Category'),
            Text(record.category, style: const TextStyle(color: CgColors.ink, fontWeight: FontWeight.w700)),
            if (record.serviceReference.isNotEmpty) ...[
              const Divider(height: 29, color: CgColors.line),
              _label('Related service reference'),
              Text(record.serviceReference, style: const TextStyle(color: CgColors.ink, fontWeight: FontWeight.w700)),
            ],
            const Divider(height: 29, color: CgColors.line),
            _label('Your message'),
            Text(record.description, style: const TextStyle(color: CgColors.ink, height: 1.65, fontSize: 13)),
          ])),
          const SizedBox(height: 22),
          const Text('Complaint timeline', style: TextStyle(color: CgColors.ink, fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 13),
          CgCard(child: Column(children: [
            _timeline(Icons.check_circle_rounded, 'Complaint received', 'A reference number has been created in this preview.', true),
            Container(height: 21, width: 2, color: CgColors.line, margin: const EdgeInsets.only(left: 16)),
            _timeline(Icons.manage_search_rounded, 'Under review', record.status == ComplaintStatus.submitted ? 'Waiting for a support team response.' : 'Case review is underway.', record.status != ComplaintStatus.submitted),
            Container(height: 21, width: 2, color: CgColors.line, margin: const EdgeInsets.only(left: 16)),
            _timeline(Icons.verified_rounded, 'Resolved', record.status == ComplaintStatus.resolved ? 'Your case has been marked resolved.' : 'Pending resolution.', record.status == ComplaintStatus.resolved),
          ])),
          const SizedBox(height: 22),
          const Text('Administrator response', style: TextStyle(color: CgColors.ink, fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 13),
          CgCard(
            color: record.adminResponse == null ? Colors.white : CgColors.paleMint,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 37, height: 37,
                decoration: BoxDecoration(color: record.adminResponse == null ? CgColors.canvas : Colors.white, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.support_agent_rounded, color: CgColors.primary, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(record.adminResponse == null ? 'No response yet' : 'CareGrid support', style: const TextStyle(color: CgColors.ink, fontSize: 13, fontWeight: FontWeight.w800)),
                const SizedBox(height: 7),
                Text(record.adminResponse ?? 'Once an administrator replies, the response will appear here after backend integration.', style: const TextStyle(color: CgColors.secondary, height: 1.65, fontSize: 12)),
              ])),
            ]),
          ),
          const SizedBox(height: 20),
          const DemoNotice(),
        ]);
      },
    )),
  );

  Widget _label(String value) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(value, style: const TextStyle(color: CgColors.secondary, fontSize: 11, fontWeight: FontWeight.w700)),
  );

  Widget _timeline(IconData icon, String title, String detail, bool done) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Container(
      width: 34, height: 34,
      decoration: BoxDecoration(color: done ? CgColors.paleMint : CgColors.canvas, borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, size: 18, color: done ? CgColors.primary : CgColors.secondary),
    ),
    const SizedBox(width: 13),
    Expanded(child: Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(color: done ? CgColors.ink : CgColors.secondary, fontWeight: FontWeight.w800, fontSize: 13)),
        const SizedBox(height: 3),
        Text(detail, style: const TextStyle(color: CgColors.secondary, height: 1.45, fontSize: 11)),
      ]),
    )),
  ]);
}
