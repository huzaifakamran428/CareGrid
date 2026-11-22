import 'package:flutter/material.dart';
import '../state/complaint_demo_store.dart';

abstract final class CgColors {
  static const primary = Color(0xFF098979);
  static const primaryDeep = Color(0xFF0C5A57);
  static const navy = Color(0xFF14364A);
  static const ink = Color(0xFF203748);
  static const secondary = Color(0xFF758995);
  static const canvas = Color(0xFFF6F8FA);
  static const line = Color(0xFFE4ECEF);
  static const paleMint = Color(0xFFE7F7F0);
  static const amber = Color(0xFFB98132);
  static const paleAmber = Color(0xFFFFF3E2);
  static const paleBlue = Color(0xFFE8F1FD);
  static const error = Color(0xFFD85E61);
}

String complaintDate(DateTime value) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${value.day} ${months[value.month - 1]} ${value.year}';
}

String statusLabel(ComplaintStatus status) => switch (status) {
  ComplaintStatus.submitted => 'Submitted',
  ComplaintStatus.inProgress => 'In review',
  ComplaintStatus.resolved => 'Resolved',
};

class ComplaintStatusBadge extends StatelessWidget {
  final ComplaintStatus status;
  const ComplaintStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final background = switch (status) {
      ComplaintStatus.submitted => CgColors.paleAmber,
      ComplaintStatus.inProgress => CgColors.paleBlue,
      ComplaintStatus.resolved => CgColors.paleMint,
    };
    final foreground = switch (status) {
      ComplaintStatus.submitted => CgColors.amber,
      ComplaintStatus.inProgress => const Color(0xFF427BB8),
      ComplaintStatus.resolved => CgColors.primary,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(30)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: foreground, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(statusLabel(status), style: TextStyle(color: foreground, fontWeight: FontWeight.w800, fontSize: 11)),
      ]),
    );
  }
}

class CareGridWordmark extends StatelessWidget {
  final bool inverse;
  const CareGridWordmark({super.key, this.inverse = false});

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(
      height: 30, width: 30,
      decoration: BoxDecoration(color: inverse ? Colors.white.withOpacity(.15) : CgColors.paleMint, borderRadius: BorderRadius.circular(10)),
      child: Icon(Icons.spa_rounded, color: inverse ? Colors.white : CgColors.primary, size: 18),
    ),
    const SizedBox(width: 9),
    Text.rich(TextSpan(children: [
      TextSpan(text: 'Care', style: TextStyle(color: inverse ? Colors.white : CgColors.ink)),
      TextSpan(text: 'Grid', style: TextStyle(color: inverse ? const Color(0xFF84E0CA) : CgColors.primary)),
    ]), style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, letterSpacing: -.7)),
  ]);
}

class CgCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  const CgCard({super.key, required this.child, this.padding = const EdgeInsets.all(18), this.color = Colors.white});

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: CgColors.line),
      boxShadow: const [BoxShadow(color: Color(0x0A193D4E), blurRadius: 18, offset: Offset(0, 6))],
    ),
    child: child,
  );
}

class CgPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData icon;
  const CgPrimaryButton({super.key, required this.label, required this.onPressed, this.icon = Icons.arrow_forward_rounded});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 54,
    width: double.infinity,
    child: FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: CgColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
    ),
  );
}

class ComplaintCaseCard extends StatelessWidget {
  final ComplaintRecord record;
  final VoidCallback onTap;
  const ComplaintCaseCard({super.key, required this.record, required this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(border: Border.all(color: CgColors.line), borderRadius: BorderRadius.circular(18)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(record.reference, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: CgColors.primary))),
              ComplaintStatusBadge(status: record.status),
            ]),
            const SizedBox(height: 12),
            Text(record.subject, style: const TextStyle(fontWeight: FontWeight.w800, color: CgColors.ink, fontSize: 15)),
            const SizedBox(height: 7),
            Text(record.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: CgColors.secondary, fontSize: 12, height: 1.55)),
            const SizedBox(height: 14),
            Row(children: [
              const Icon(Icons.calendar_today_outlined, size: 13, color: CgColors.secondary),
              const SizedBox(width: 5),
              Text(complaintDate(record.createdAt), style: const TextStyle(color: CgColors.secondary, fontSize: 11)),
              const Spacer(),
              Text('View details', style: TextStyle(color: CgColors.primary, fontSize: 11, fontWeight: FontWeight.w800)),
              const SizedBox(width: 3),
              const Icon(Icons.arrow_forward_ios_rounded, color: CgColors.primary, size: 12),
            ]),
          ]),
        ),
      ),
    ),
  );
}

class DemoNotice extends StatelessWidget {
  const DemoNotice({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: CgColors.paleMint, borderRadius: BorderRadius.circular(12)),
    child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.info_outline, size: 17, color: CgColors.primary),
      SizedBox(width: 9),
      Expanded(child: Text('UI prototype: example records and local-only submissions. No complaint is sent to a real administrator.', style: TextStyle(color: CgColors.primaryDeep, fontSize: 11, height: 1.5))),
    ]),
  );
}
