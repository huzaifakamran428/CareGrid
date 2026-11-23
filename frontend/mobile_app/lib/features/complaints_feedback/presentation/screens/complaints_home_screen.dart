import 'package:flutter/material.dart';
import '../state/complaint_demo_store.dart';
import '../widgets/complaint_components.dart';
import 'complaint_detail_screen.dart';
import 'submit_complaint_screen.dart';
import 'service_feedback_screen.dart';

/// Beneficiary complaints landing and tracking screen (UI-only).
class ComplaintsHomeScreen extends StatefulWidget {
  const ComplaintsHomeScreen({super.key});

  @override
  State<ComplaintsHomeScreen> createState() => _ComplaintsHomeScreenState();
}

class _ComplaintsHomeScreenState extends State<ComplaintsHomeScreen> {
  String _filter = 'All';

  void _startComplaint() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => const SubmitComplaintScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: complaintDemoStore,
          builder: (context, _) {
            final all = complaintDemoStore.complaints;
            final visible = all.where((complaint) {
              if (_filter == 'Active') return complaint.status != ComplaintStatus.resolved;
              if (_filter == 'Resolved') return complaint.status == ComplaintStatus.resolved;
              return true;
            }).toList();
            final active = all.where((item) => item.status != ComplaintStatus.resolved).length;
            return Column(children: [
              Expanded(child: ListView(padding: EdgeInsets.zero, children: [
                _hero(context, active, all.length),
                Padding(
                  padding: const EdgeInsets.fromLTRB(19, 22, 19, 25),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    CgCard(child: Row(children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(color: CgColors.paleMint, borderRadius: BorderRadius.circular(15)),
                        child: const Icon(Icons.edit_note_rounded, color: CgColors.primary, size: 25),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Tell us what happened', style: TextStyle(color: CgColors.ink, fontSize: 15, fontWeight: FontWeight.w800)),
                        SizedBox(height: 5),
                        Text('Submit a new complaint in a few simple steps.', style: TextStyle(color: CgColors.secondary, fontSize: 12, height: 1.5)),
                      ])),
                      const SizedBox(width: 6),
                      IconButton(
                        onPressed: _startComplaint,
                        tooltip: 'Submit a complaint',
                        icon: const Icon(Icons.arrow_forward_rounded, color: CgColors.primary),
                      ),
                    ])),
                    const SizedBox(height: 9),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const ServiceFeedbackScreen(),
                          ),
                        ),
                        icon: const Icon(Icons.star_outline_rounded),
                        label: const Text('Rate a service & share feedback'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(children: [
                      const Expanded(child: Text('My complaints', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: CgColors.ink))),
                      Text('${all.length} total', style: const TextStyle(color: CgColors.secondary, fontSize: 12)),
                    ]),
                    const SizedBox(height: 13),
                    Row(children: ['All', 'Active', 'Resolved'].map((filter) => Padding(
                      padding: const EdgeInsets.only(right: 9),
                      child: ChoiceChip(
                        label: Text(filter), selected: _filter == filter,
                        onSelected: (_) => setState(() => _filter = filter),
                        selectedColor: CgColors.paleMint,
                        backgroundColor: Colors.white,
                        side: BorderSide(color: _filter == filter ? const Color(0xFFA8DDD0) : CgColors.line),
                        labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _filter == filter ? CgColors.primary : CgColors.secondary),
                        showCheckmark: false,
                      ),
                    )).toList()),
                    const SizedBox(height: 13),
                    if (visible.isEmpty)
                      const CgCard(child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Center(child: Column(children: [
                          Icon(Icons.inbox_outlined, size: 35, color: CgColors.secondary),
                          SizedBox(height: 10),
                          Text('No complaints in this category', style: TextStyle(color: CgColors.secondary)),
                        ])),
                      ))
                    else ...visible.map((record) => ComplaintCaseCard(
                      record: record,
                      onTap: () => Navigator.push(context, MaterialPageRoute<void>(
                        builder: (_) => ComplaintDetailScreen(reference: record.reference),
                      )),
                    )),
                    const SizedBox(height: 13),
                    const DemoNotice(),
                  ]),
                ),
              ])),
            ]);
          },
        ),
      ),
    );
  }

  Widget _hero(BuildContext context, int active, int total) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [CgColors.navy, CgColors.primaryDeep], begin: Alignment.topLeft, end: Alignment.bottomRight),
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
    ),
    padding: const EdgeInsets.fromLTRB(22, 21, 22, 27),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const CareGridWordmark(inverse: true),
        const Spacer(),
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(color: Colors.white.withOpacity(.14), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.support_agent_rounded, color: Colors.white, size: 21),
        ),
      ]),
      const SizedBox(height: 27),
      const Text('BENEFICIARY SUPPORT', style: TextStyle(color: Color(0xFF8EE0CC), fontWeight: FontWeight.w800, fontSize: 10, letterSpacing: 1.7)),
      const SizedBox(height: 9),
      const Text("We're here to help.", style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w900, letterSpacing: -.65)),
      const SizedBox(height: 7),
      const Text('Raise a concern and follow every update in one place.', style: TextStyle(color: Color(0xFFCEEBE7), height: 1.5, fontSize: 13)),
      const SizedBox(height: 24),
      Row(children: [
        _heroStat('$total', 'Total requests', Icons.confirmation_number_outlined),
        const SizedBox(width: 12),
        _heroStat('$active', 'Active cases', Icons.schedule_outlined),
      ]),
    ]),
  );

  Widget _heroStat(String value, String label, IconData icon) => Expanded(child: Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: Colors.white.withOpacity(.10), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(.12))),
    child: Row(children: [
      Icon(icon, color: const Color(0xFFA4E5D7), size: 22),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: const TextStyle(fontSize: 19, color: Colors.white, fontWeight: FontWeight.w900)),
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFFC8E5E0))),
      ]),
    ]),
  ));
}
