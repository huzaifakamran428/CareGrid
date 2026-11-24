// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../../../../app/theme/brand_tokens.dart';
import '../../../../core/widgets/caregrid_brand.dart';
import '../../../../core/widgets/caregrid_identity_card.dart';
import 'package:flutter/services.dart';

class DigitalIdPassScreen extends StatefulWidget {
  const DigitalIdPassScreen({super.key});

  @override
  State<DigitalIdPassScreen> createState() => _DigitalIdPassScreenState();
}

class _DigitalIdPassScreenState extends State<DigitalIdPassScreen> {
  // ---------------------------------------------------------------------------
  // DESIGN SYSTEM COLORS (100% Consistent across CareGrid Screens)
  // ---------------------------------------------------------------------------
  static const Color _primaryGreen = CareGridPalette.primary;
  static const Color _headerBadgeBg = CareGridPalette.primaryDeep;
  static const Color _headerBadgeBorder = CareGridPalette.primaryBorder;
  static const Color _amberBadge = CareGridPalette.gold;

  static const Color _mintCardBg = CareGridPalette.paleMint;
  static const Color _mintCardBorder = CareGridPalette.mintBorder;
  static const Color _darkForestText = CareGridPalette.ink;
  static const Color _mutedText = CareGridPalette.secondaryText;

  static const Color _canvasBg = CareGridPalette.canvas;
  static const Color _neutralBtnBg = CareGridPalette.paleNeutral;
  static const Color _neutralBtnBorder = CareGridPalette.line;

  // ---------------------------------------------------------------------------
  // DUMMY BENEFICIARY DIGITAL ID DATA
  // ---------------------------------------------------------------------------
  final Map _digitalPassData = {
    'fullName': 'Ayesha Bibi',
    'digitalId': 'CG-BEN-2026-009481',
    'cnic': '35202-4819204-2',
    'ngoName': 'Al-Khidmat Foundation Lahore',
    'validUntil': '31 Dec 2026',
    'monthlyCap': 'Rs. 12,000',
    'remainingBalance': 'Rs. 8,500',
    'medSubsidy': '70% Covered',
    'labSubsidy': '80% Covered',
    'foodTier': 'Active Daily Ration',
  };

  final List _recentScans = [
    {
      'provider': 'Sehat Welfare Pharmacy - Johar Town',
      'type': 'Medicine Dispensing (70% Subsidy)',
      'date': '18 Nov 2026 • 04:15 PM',
      'savedAmount': 'Rs. 1,400',
    },
    {
      'provider': 'Shaukat Khanum Diagnostic Centre',
      'type': 'HbA1c Lab Test (80% Subsidy)',
      'date': '16 Nov 2026 • 09:30 AM',
      'savedAmount': 'Rs. 1,760',
    },
    {
      'provider': 'Lahore Community Kitchen #04',
      'type': 'Family Food Pack Pickup',
      'date': '12 Nov 2026 • 01:10 PM',
      'savedAmount': 'Verified',
    },
  ];

  void _copyDigitalId() {
    Clipboard.setData(
      ClipboardData(text: _digitalPassData['digitalId'].toString()),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Digital ID copied to clipboard'),
        backgroundColor: _primaryGreen,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryGreen,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. TOP FOREST GREEN HEADER
            CareGridBrandedHeader(child: _buildTopHeader()),

            // 2. MAIN ROUNDED SHEET CONTAINER
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: _canvasBg,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Official Digital ID & QR Verification Card
                        _buildOfficialDigitalPassCard(),
                        const SizedBox(height: 18),

                        // Active Subsidy Entitlements Summary Card
                        _buildEntitlementsCard(),
                        const SizedBox(height: 18),

                        // Recent Provider Scan History
                        const Text(
                          'Recent Counter Verifications',
                          style: TextStyle(
                            color: _darkForestText,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildRecentScansList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TOP HEADER
  // ---------------------------------------------------------------------------
  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Navigator.maybePop(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _headerBadgeBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _headerBadgeBorder, width: 1),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 12),
                      SizedBox(width: 5),
                      Text(
                        'BACK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _amberBadge,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'VERIFIED PASS',
                  style: TextStyle(
                    color: _darkForestText,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'CareGrid Digital Welfare ID',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Present this pass at partner pharmacies, diagnostic labs, or food kitchens for instant verification.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // OFFICIAL DIGITAL ID & QR PASS CARD
  // ---------------------------------------------------------------------------
  Widget _buildOfficialDigitalPassCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CareGridIdentityCard(
          name: _digitalPassData['fullName'].toString(),
          digitalId: _digitalPassData['digitalId'].toString(),
          issuedAt: '14 Nov 2026',
          cnic: 'Not recorded',
          address: 'Lahore',
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _copyDigitalId,
          icon: const Icon(Icons.copy_rounded, size: 17),
          label: const Text('Copy demonstration Digital ID'),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // ACTIVE ENTITLEMENTS & SUBSIDY QUOTA CARD
  // ---------------------------------------------------------------------------
  Widget _buildEntitlementsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _neutralBtnBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Welfare Entitlements',
                style: TextStyle(
                  color: _darkForestText,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${_digitalPassData['remainingBalance']} Left',
                style: const TextStyle(
                  color: _primaryGreen,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildEntitlementRow(
            Icons.medication_outlined,
            'Pharmacy Medicines',
            _digitalPassData['medSubsidy'].toString(),
          ),
          const SizedBox(height: 9),
          _buildEntitlementRow(
            Icons.biotech_outlined,
            'Diagnostic Lab Tests',
            _digitalPassData['labSubsidy'].toString(),
          ),
          const SizedBox(height: 9),
          _buildEntitlementRow(
            Icons.volunteer_activism_outlined,
            'Food & Ration Support',
            _digitalPassData['foodTier'].toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildEntitlementRow(IconData icon, String label, String badgeText) {
    return Row(
      children: [
        Icon(icon, color: _primaryGreen, size: 18),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: _darkForestText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: _mintCardBg,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            badgeText,
            style: const TextStyle(
              color: _primaryGreen,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // RECENT COUNTER SCANS LIST
  // ---------------------------------------------------------------------------
  Widget _buildRecentScansList() {
    return Column(
      children: List.generate(_recentScans.length, (index) {
        final Map scan = _recentScans[index] as Map;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _neutralBtnBorder, width: 1.2),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: _mintCardBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: _primaryGreen,
                  size: 19,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scan['provider'].toString(),
                      style: const TextStyle(
                        color: _darkForestText,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scan['type'].toString(),
                      style: const TextStyle(
                        color: _primaryGreen,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scan['date'].toString(),
                      style: const TextStyle(
                        color: _mutedText,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _neutralBtnBg,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: _neutralBtnBorder),
                ),
                child: Text(
                  scan['savedAmount'].toString(),
                  style: const TextStyle(
                    color: _darkForestText,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}