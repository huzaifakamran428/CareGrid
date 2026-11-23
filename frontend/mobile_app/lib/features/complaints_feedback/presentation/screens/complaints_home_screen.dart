import 'package:flutter/material.dart';
import '../../../../app/theme/brand_tokens.dart';
import '../../../../core/widgets/caregrid_brand.dart';
import '../state/complaint_demo_store.dart';
import '../widgets/complaint_components.dart';
import 'complaint_detail_screen.dart';
import 'submit_complaint_screen.dart';
import 'service_feedback_screen.dart';

/// Single beneficiary support hub. Uses the same shell as Home/Labs/Profile.
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

  void _startFeedback() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => const ServiceFeedbackScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: CareGridPalette.primary,
    body: SafeArea(
      bottom: false,
      child: AnimatedBuilder(
        animation: complaintDemoStore,
        builder: (context, _) {
          final complaints = complaintDemoStore.complaints;
          final visible = complaints.where((item) {
            if (_filter == 'Active') return item.status != ComplaintStatus.resolved;
            if (_filter == 'Resolved') return item.status == ComplaintStatus.resolved;
            return true;
          }).toList();
          final active = complaints.where(
            (item) => item.status != ComplaintStatus.resolved,
          ).length;

          return Column(children: [
            CareGridBrandedHeader(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [
                      CareGridSectionTag('Beneficiary Support', icon: Icons.support_agent_outlined),
                      Spacer(),
                      Icon(Icons.favorite_border_rounded, color: CareGridPalette.gold, size: 22),
                    ]),
                    const SizedBox(height: 13),
                    const Text(
                      "We're here to help.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Raise a concern and track each update in one place.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .87),
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(children: [
                      _metric('${complaints.length}', 'Total requests', Icons.assignment_outlined),
                      const SizedBox(width: 10),
                      _metric('$active', 'Active cases', Icons.schedule_outlined),
                    ]),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: CareGridPalette.canvas,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(CareGridLayout.sheetRadius),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
                  children: [
                    CgCard(child: Row(children: [
                      Container(
                        width: 49,
                        height: 49,
                        decoration: BoxDecoration(
                          color: CareGridPalette.paleMint,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.edit_note_rounded,
                            color: CareGridPalette.primary, size: 26),
                      ),
                      const SizedBox(width: 13),
                      const Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tell us what happened', style: TextStyle(
                            color: CareGridPalette.ink, fontSize: 15,
                            fontWeight: FontWeight.w800,
                          )),
                          SizedBox(height: 4),
                          Text('Submit a concern and follow its demo reference.',
                            style: TextStyle(
                              color: CareGridPalette.secondaryText,
                              fontSize: 12, height: 1.45,
                            ),
                          ),
                        ],
                      )),
                      IconButton(
                        tooltip: 'Submit a complaint',
                        onPressed: _startComplaint,
                        icon: const Icon(Icons.arrow_forward_rounded,
                            color: CareGridPalette.primary),
                      ),
                    ])),
                    const SizedBox(height: 13),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _startFeedback,
                        icon: const Icon(Icons.star_outline_rounded),
                        label: const Text('Rate a service & share feedback'),
                      ),
                    ),
                    const SizedBox(height: 23),
                    Row(children: [
                      const Expanded(child: Text(
                        'My complaints',
                        style: TextStyle(
                          fontSize: 19, fontWeight: FontWeight.w900,
                          color: CareGridPalette.ink,
                        ),
                      )),
                      Text('${complaints.length} total', style: const TextStyle(
                        color: CareGridPalette.secondaryText, fontSize: 12,
                      )),
                    ]),
                    const SizedBox(height: 13),
                    Wrap(
                      spacing: 9,
                      runSpacing: 8,
                      children: ['All', 'Active', 'Resolved'].map((filter) =>
                        ChoiceChip(
                          label: Text(filter),
                          selected: _filter == filter,
                          onSelected: (_) => setState(() => _filter = filter),
                          selectedColor: CareGridPalette.paleMint,
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: _filter == filter
                                ? CareGridPalette.mintBorder : CareGridPalette.line,
                          ),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _filter == filter
                                ? CareGridPalette.primaryDeep : CareGridPalette.secondaryText,
                          ),
                          showCheckmark: false,
                        ),
                      ).toList(),
                    ),
                    const SizedBox(height: 14),
                    if (visible.isEmpty)
                      const CgCard(child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Column(children: [
                          Icon(Icons.inbox_outlined, size: 34,
                              color: CareGridPalette.secondaryText),
                          SizedBox(height: 10),
                          Text('No complaints in this category',
                            style: TextStyle(color: CareGridPalette.secondaryText)),
                        ]),
                      ))
                    else ...visible.map((record) => ComplaintCaseCard(
                      record: record,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ComplaintDetailScreen(reference: record.reference),
                        ),
                      ),
                    )),
                    const SizedBox(height: 10),
                    const DemoNotice(),
                  ],
                ),
              ),
            ),
          ]);
        },
      ),
    ),
  );

  Widget _metric(String value, String label, IconData icon) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .11),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white.withValues(alpha: .17)),
      ),
      child: Row(children: [
        Icon(icon, color: CareGridPalette.gold, size: 21),
        const SizedBox(width: 8),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900,
            )),
            Text(label, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: CareGridPalette.paleMint, fontSize: 10,
              ),
            ),
          ],
        )),
      ]),
    ),
  );
}
