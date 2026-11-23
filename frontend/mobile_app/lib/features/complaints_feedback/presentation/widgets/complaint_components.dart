import 'package:flutter/material.dart';
import '../state/complaint_demo_store.dart';
import '../../../../app/theme/brand_tokens.dart';
import '../../../../core/widgets/caregrid_brand.dart';

/// Compatibility aliases: complaints share the SAME palette as every module.
abstract final class CgColors {
  static const primary = CareGridPalette.primary;
  static const primaryDeep = CareGridPalette.primaryDeep;
  static const navy = CareGridPalette.primaryDeep;
  static const ink = CareGridPalette.ink;
  static const secondary = CareGridPalette.secondaryText;
  static const canvas = CareGridPalette.canvas;
  static const line = CareGridPalette.line;
  static const paleMint = CareGridPalette.paleMint;
  static const amber = CareGridPalette.goldDeep;
  static const paleAmber = CareGridPalette.goldTint;
  static const paleBlue = CareGridPalette.infoTint;
  static const error = CareGridPalette.danger;
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

/// Legacy component now delegates to the app-wide genuine logo wordmark.
class CareGridWordmark extends StatelessWidget {
  final bool inverse;
  const CareGridWordmark({super.key, this.inverse = false});

  @override
  Widget build(BuildContext context) => CareGridBrandStrip(inverse: inverse);
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
      borderRadius: BorderRadius.circular(CareGridLayout.cardRadius),
      border: Border.all(color: CgColors.line),
      boxShadow: const [CareGridLayout.cardShadow],
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
      borderRadius: BorderRadius.circular(CareGridLayout.cardRadius),
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
