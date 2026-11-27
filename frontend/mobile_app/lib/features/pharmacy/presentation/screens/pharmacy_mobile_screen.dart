import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../beneficiary/presentation/state/prescription_demo_store.dart';
import '../../../chatbot/presentation/screens/chatbot_screen.dart';
import '../../../../app/theme/brand_tokens.dart';
import '../../../../core/widgets/caregrid_brand.dart';
import '../../../auth/domain/entities/portal_user.dart';

class PharmacyMobileScreen extends StatefulWidget {
  final PortalUser user;
  final VoidCallback onSignOut;
  const PharmacyMobileScreen({super.key, required this.user, required this.onSignOut});

  @override
  State<PharmacyMobileScreen> createState() => _PharmacyMobileScreenState();
}

class _PharmacyMobileScreenState extends State<PharmacyMobileScreen> {
  int section = 0;
  void notice(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  Future<void> download(DemoPrescription record) async {
    try {
      final result = await FilePicker.platform.saveFile(fileName: record.filename, bytes: record.bytes);
      if (mounted && result != null) notice('Demo file saved.');
    } catch (_) { if (mounted) notice('Saving is unavailable on this device.'); }
  }
  Future<void> review(DemoPrescription record) async {
    final text = TextEditingController(text: record.reviewedText);
    final amount = TextEditingController(text: record.demoTotal > 0 ? record.demoTotal.toStringAsFixed(2) : '');
    final accepted = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(
      title: const Text('OCR review • Simulation'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('No actual text extraction. Inspect the fictional file and manually enter sample medicine information.'),
        const SizedBox(height: 12), TextField(controller: text, maxLines: 4, decoration: const InputDecoration(labelText: 'Reviewed fictional medicine text')),
        const SizedBox(height: 12), TextField(controller: amount, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Example bill (PKR)')),
      ])), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Verify demo'))]));
    final value = double.tryParse(amount.text); final reviewed = text.text.trim();
    text.dispose(); amount.dispose();
    if (!mounted || accepted != true) return;
    if (reviewed.isEmpty || value == null || !value.isFinite || value <= 0 || value > 1000000) { notice('Enter fictional text and a valid bill amount.'); return; }
    setState(() { record.reviewedText = reviewed; record.demoTotal = value; record.status = 'Verified (demo)'; });
  }
  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return Scaffold(
      backgroundColor: CareGridPalette.canvas,
      appBar: AppBar(
        title: const CareGridPageTitle('Pharmacy & Prescription Console'),
        actions: [
          IconButton(tooltip: 'Ask CareGrid', icon: const Icon(Icons.chat_bubble_outline), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CaregridChatbotScreen()))),
          IconButton(
            tooltip: 'Sign Out',
            icon: const Icon(Icons.logout_rounded),
            onPressed: widget.onSignOut,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: CareGridPalette.headerGradient,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(user.subtitle, style: const TextStyle(color: Color(0xFFD7F2E9), fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(spacing: 8, runSpacing: 8, children: [for (final item in ['Overview', 'Prescription inbox', 'Dispense history'].asMap().entries) ChoiceChip(label: Text(item.value), selected: section == item.key, onSelected: (_) => setState(() => section = item.key))]),
          const SizedBox(height: 16),
          if (section == 0) ...[
          Card(
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: CareGridPalette.paleMint, child: Icon(Icons.analytics_outlined, color: CareGridPalette.primary)),
              title: const Text('24 Subsidized Prescriptions', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('PKR 48,200 NGO Claims'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: CareGridPalette.goldTint, child: Icon(Icons.verified_outlined, color: CareGridPalette.goldDeep)),
              title: const Text('Active Queue Item', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('ID CG-BEN-2026-009481 • 80% Approved'),
            ),
          ),
          ] else ...[
            const CareGridSectionTag('Frontend demo only'),
            const SizedBox(height: 12),
            if (PrescriptionDemoStore.forPharmacy(user.email).where((r) => section == 2 ? r.status == 'Dispensed (demo)' : r.status != 'Dispensed (demo)').isEmpty)
              const Card(child: ListTile(title: Text('No demo prescriptions'), subtitle: Text('Sign in as a beneficiary and choose a fictional file first.'))),
            for (final record in PrescriptionDemoStore.forPharmacy(user.email).where((r) => section == 2 ? r.status == 'Dispensed (demo)' : r.status != 'Dispensed (demo)'))
              CareGridPanel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(record.filename, style: Theme.of(context).textTheme.titleMedium),
                Text('${record.id} • ${record.status}'),
                if (record.demoTotal > 0) Text('Demo bill: PKR ${record.demoTotal.toStringAsFixed(2)} • 80% NGO share: PKR ${(record.demoTotal * .8).toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  OutlinedButton.icon(onPressed: () => download(record), icon: const Icon(Icons.download), label: const Text('Download')),
                  if (section == 1) ...[
                    OutlinedButton(onPressed: () => review(record), child: const Text('Simulate OCR / Review')),
                    FilledButton(onPressed: record.status == 'Verified (demo)' ? () => setState(() => record.status = 'Dispensed (demo)') : null, child: const Text('Mark dispensed')),
                  ],
                ]),
              ])),
          ],
        ],
      ),
    );
  }
}
