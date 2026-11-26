import 'package:flutter/material.dart';
import '../../../../core/widgets/caregrid_brand.dart';
import 'package:flutter/services.dart';
import '../widgets/complaint_components.dart';
import 'complaint_detail_screen.dart';

/// Confirmation with the client-generated DEMO reference; does not claim server submission.
class ComplaintSubmittedScreen extends StatelessWidget {
  final String reference;
  const ComplaintSubmittedScreen({super.key, required this.reference});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const CareGridPageTitle('Complaint saved'), automaticallyImplyLeading: false),
    body: SafeArea(child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 25),
      child: Column(children: [
        const Spacer(),
        Container(
          height: 99, width: 99,
          decoration: BoxDecoration(color: CgColors.paleMint, borderRadius: BorderRadius.circular(29)),
          child: const Icon(Icons.task_alt_rounded, color: CgColors.primary, size: 54),
        ),
        const SizedBox(height: 27),
        const Text('Your complaint is saved!', textAlign: TextAlign.center, style: TextStyle(color: CgColors.ink, fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: -.5)),
        const SizedBox(height: 11),
        const Text('Your complaint has been added to this UI preview. Use the reference below to find it in your local complaint list.', textAlign: TextAlign.center, style: TextStyle(color: CgColors.secondary, fontSize: 13, height: 1.7)),
        const SizedBox(height: 27),
        CgCard(color: const Color(0xFFFBFEFC), child: Column(children: [
          const Text('YOUR DEMO REFERENCE NUMBER', style: TextStyle(color: CgColors.secondary, fontWeight: FontWeight.w800, letterSpacing: 1, fontSize: 10)),
          const SizedBox(height: 9),
          SelectableText(reference, textAlign: TextAlign.center, style: const TextStyle(color: CgColors.primary, fontSize: 16, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: reference));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demo reference copied')));
            },
            icon: const Icon(Icons.copy_rounded, size: 16), label: const Text('Copy reference'),
          ),
        ])),
        const Spacer(),
        const DemoNotice(),
        const SizedBox(height: 16),
        CgPrimaryButton(
          label: 'Track this complaint',
          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
            builder: (_) => ComplaintDetailScreen(reference: reference),
          )),
        ),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Back to my complaints', style: TextStyle(color: CgColors.primary, fontWeight: FontWeight.w800)),
        )),
      ]),
    )),
  );
}
