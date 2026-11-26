import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import '../../app/theme/brand_tokens.dart';

/// The real CareGrid logo (not a generic medical icon) and the same wordmark
/// appear on every mobile module. [inverse] is intended for emerald headers.
class CareGridBrandStrip extends StatelessWidget {
  const CareGridBrandStrip({super.key, this.inverse = true, this.compact = false});
  final bool inverse;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final care = inverse ? Colors.white : CareGridPalette.primaryDeep;
    final caption = inverse ? const Color(0xFFD9F2E9) : CareGridPalette.secondaryText;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 34 : 42,
          height: compact ? 34 : 42,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFFFB),
            borderRadius: BorderRadius.circular(compact ? 10 : 13),
            border: Border.all(color: CareGridPalette.mintBorder, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(compact ? 8 : 10),
            child: Image.asset(
              'assets/images/caregrid_logo.jpg',
              fit: BoxFit.contain,
              errorBuilder: (context, _, __) => const Icon(
                Icons.favorite_outline_rounded, color: CareGridPalette.primary),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(children: [
                TextSpan(text: 'Care', style: TextStyle(color: care)),
                const TextSpan(text: 'Grid', style: TextStyle(color: CareGridPalette.gold)),
              ]),
              style: TextStyle(
                fontSize: compact ? 17 : 21,
                fontWeight: FontWeight.w900,
                letterSpacing: -.65,
                height: 1,
              ),
            ),
            if (!compact) ...[
              const SizedBox(height: 5),
              Text(
                'COMPASSION · CONNECTED',
                style: TextStyle(
                  color: caption,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// Consistent app bar title for detail pages, complaint forms, chat history,
/// feedback and all future modules.
class CareGridPageTitle extends StatelessWidget {
  const CareGridPageTitle(this.title, {super.key});
  final String title;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const CareGridBrandStrip(inverse: false, compact: true),
      const SizedBox(width: 12),
      Flexible(
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: CareGridPalette.ink,
          ),
        ),
      ),
    ],
  );
}

/// Shared emerald header chrome for the beneficiary dashboard and every
/// full-screen module; the existing per-page heading lives below the wordmark.
class CareGridBrandedHeader extends StatelessWidget {
  const CareGridBrandedHeader({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(18, 10, 18, 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: CareGridBrandStrip(),
        ),
      ),
      child,
    ],
  );
}

class CareGridSectionTag extends StatelessWidget {
  const CareGridSectionTag(this.label, {super.key, this.icon});
  final String label;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: CareGridPalette.goldTint,
      borderRadius: BorderRadius.circular(9),
      border: Border.all(color: CareGridPalette.gold.withValues(alpha: .35)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[
          Icon(icon, size: 13, color: CareGridPalette.goldDeep),
          const SizedBox(width: 5),
        ],
        Text(label.toUpperCase(), style: const TextStyle(
          color: CareGridPalette.goldDeep,
          fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: .7,
        )),
      ]),
    ),
  );
}

class CareGridPanel extends StatelessWidget {
  const CareGridPanel({super.key, required this.child, this.padding = const EdgeInsets.all(18)});
  final Widget child;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(CareGridLayout.cardRadius),
      boxShadow: const [CareGridLayout.cardShadow],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(CareGridLayout.cardRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: CareGridPalette.glassGradient,
            borderRadius: BorderRadius.circular(CareGridLayout.cardRadius),
            border: Border.all(color: CareGridPalette.glassBorder),
          ),
          child: child,
        ),
      ),
    ),
  );
}
