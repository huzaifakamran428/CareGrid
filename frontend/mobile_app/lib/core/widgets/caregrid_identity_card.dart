import 'package:flutter/material.dart';
import '../../app/theme/brand_tokens.dart';

/// Screenshot-matched beneficiary Digital ID presentation.
/// Preview-only: no signed credential, NFC/QR verification or NGO API.
class CareGridIdentityCard extends StatelessWidget {
  const CareGridIdentityCard({
    super.key,
    required this.name,
    required this.digitalId,
    required this.issuedAt,
    this.cnic = 'Not recorded',
    this.address = 'Lahore',
    this.status = 'ACTIVE · DEMO',
    this.compact = false,
  });

  final String name;
  final String digitalId;
  final String issuedAt;
  final String cnic;
  final String address;
  final String status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: CareGridPalette.mintBorder),
        boxShadow: const [CareGridLayout.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: CareGridPalette.headerGradient,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 12 : 16, vertical: 15,
            ),
            child: Row(children: [
              Container(
                width: compact ? 37 : 45,
                height: compact ? 37 : 45,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.asset(
                    'assets/images/caregrid_logo.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CareGrid',
                    style: TextStyle(color: Colors.white,
                      fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text('NGO BENEFICIARY CARD',
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .85),
                      letterSpacing: 1.05, fontSize: 9,
                      fontWeight: FontWeight.w800)),
                ],
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .17),
                  border: Border.all(color: Colors.white.withValues(alpha: .35)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(status,
                  style: const TextStyle(color: Colors.white,
                    fontSize: 9, fontWeight: FontWeight.w800)),
              ),
            ]),
          ),
          Container(
            color: const Color(0xFFF7FCF9),
            padding: EdgeInsets.all(compact ? 13 : 17),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: compact ? 76 : 96,
                  height: compact ? 111 : 130,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9ECE6),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(Icons.people_alt_outlined,
                    color: CareGridPalette.primary, size: 43),
                ),
                const SizedBox(width: 13),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _detail('BENEFICIARY NAME', name),
                    _detail('DIGITAL ID', digitalId),
                    _detail('CNIC', cnic),
                    _detail('RESIDENTIAL ADDRESS', address, last: true),
                  ],
                )),
              ],
            ),
          ),
          Container(
            color: CareGridPalette.paleMint,
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 9, runSpacing: 6,
              children: [
                Text('Issued $issuedAt', style: const TextStyle(
                  color: CareGridPalette.secondaryText, fontSize: 10,
                )),
                const Text('FRONTEND PROTOTYPE · NOT VALID FOR VERIFICATION',
                  style: TextStyle(color: CareGridPalette.primaryDeep,
                    fontSize: 8, fontWeight: FontWeight.w900,
                    letterSpacing: .25)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detail(String label, String value, {bool last = false}) =>
      Padding(
        padding: EdgeInsets.only(bottom: last ? 0 : 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(
              fontSize: 9, letterSpacing: .9,
              color: CareGridPalette.secondaryText,
              fontWeight: FontWeight.w800,
            )),
            const SizedBox(height: 2),
            Text(value, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: CareGridPalette.ink,
                fontSize: compact ? 12 : 13,
                fontWeight: FontWeight.w800,
              )),
          ],
        ),
      );
}
