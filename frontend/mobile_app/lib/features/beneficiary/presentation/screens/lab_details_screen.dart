// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../../../../app/theme/brand_tokens.dart';
import '../../../../core/widgets/caregrid_brand.dart';
import 'booking_screen.dart';

class LabDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? test;
  const LabDetailsScreen({super.key, this.test});

  @override
  State<LabDetailsScreen> createState() => _LabDetailsScreenState();
}

class _LabDetailsScreenState extends State<LabDetailsScreen> {
  // ---------------------------------------------------------------------------
  // DESIGN SYSTEM COLORS (100% Consistent with Home, Profile & Lab List)
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
  // DUMMY DATA
  // ---------------------------------------------------------------------------
  Map<String, dynamic> get _labTestDetails {
    const base = <String, dynamic>{
    'testName': 'Complete Blood Count (CBC)',
    'testCode': 'LAB-CBC-104',
    'category': 'Hematology & Blood Tests',
    'labName': 'Chughtai Lab - Johar Town',
    'labRegId': 'CG-LAB-0042',
    'address': 'Plot 12-B, Main Boulevard, Johar Town, Lahore',
    'distance': '1.4 km away',
    'timings': 'Mon – Sun • 08:00 AM – 10:00 PM',
    'phone': '+92 42 111 456 789',
    'sampleType': 'Venous Whole Blood (3 mL EDTA)',
    'turnaroundTime': 'Same Day (Within 6 Hours)',
    'preparation':
        'No fasting required. Drink plenty of water before sample collection and bring your CareGrid Digital ID.',
    'description':
        'Evaluates overall blood health including red blood cells, white blood cells, hemoglobin, hematocrit, and platelet counts to detect anemia, infections, and nutritional deficiencies.',
    'originalPrice': 1500,
    'subsidyPercent': 80,
    'subsidyAmount': 1200,
    'payableAmount': 300,
    'beneficiaryDigitalId': 'CG-BEN-2026-009481',
    };
    final chosen = widget.test;
    if (chosen == null) return base;
    final original = (chosen['originalPrice'] as num?)?.toInt() ?? 1500;
    final payable = (chosen['subsidizedPrice'] as num?)?.toInt() ??
        (chosen['payableAmount'] as num?)?.toInt() ?? 300;
    return {
      ...base,
      ...chosen,
      'testCode': 'LAB-DEMO',
      'labRegId': 'CG-LAB-DEMO',
      'address': 'Confirm branch address with the laboratory',
      'phone': 'Contact the laboratory directly',
      'sampleType': 'Confirm test sample requirements with the provider',
      'preparation': 'Ask the laboratory about fasting or preparation before visiting. Bring your Digital ID.',
      'description': 'This diagnostic test is listed in the CareGrid demonstration. Please confirm instructions with the laboratory.',
      'originalPrice': original,
      'payableAmount': payable,
      'subsidyAmount': original - payable,
      'turnaroundTime': chosen['turnaroundTime'] ?? 'Ask the laboratory',
    };
  }

  final List _todayAvailableSlots = [
    '09:30 AM',
    '10:15 AM',
    '11:00 AM',
    '02:30 PM',
    '04:00 PM',
    '05:15 PM',
  ];

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _primaryGreen,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
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
                        // Mint Subsidy & Price Breakdown Card
                        _buildSubsidyBreakdownCard(),
                        const SizedBox(height: 16),

                        // Primary CTA Button
                        _buildPrimaryButton(
                          label: 'Select Time Slot & Book Appointment',
                          icon: Icons.calendar_month_rounded,
                          onTap: () =>
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => BookingScreen(test: _labTestDetails),
                                ),
                              ),
                        ),
                        const SizedBox(height: 18),

                        // Laboratory Branch & Location Details Card
                        _buildLabLocationCard(),
                        const SizedBox(height: 16),

                        // Test Overview & Preparation Instructions Card
                        _buildTestOverviewCard(),
                        const SizedBox(height: 16),

                        // Today's Available Time Slots Preview Card
                        _buildAvailableSlotsCard(),
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
          // Top Navigation & Status Badges
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 8,
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
                        'BACK TO LABS',
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
                child: Text(
                  '${_labTestDetails['subsidyPercent']}% SUBSIDIZED',
                  style: const TextStyle(
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

          // Test Title
          Text(
            _labTestDetails['testName'].toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),

          // Partner Lab Name
          Row(
            children: [
              const Icon(Icons.verified_rounded,
                  color: _amberBadge, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${_labTestDetails['labName']} • ${_labTestDetails['distance']}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MINT SUBSIDY & FEE BREAKDOWN CARD
  // ---------------------------------------------------------------------------
  Widget _buildSubsidyBreakdownCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _mintCardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _mintCardBorder, width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _primaryGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, color: Colors.white, size: 13),
                    SizedBox(width: 4),
                    Text(
                      'ELIGIBILITY VERIFIED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _labTestDetails['testCode'].toString(),
                style: const TextStyle(
                  color: _darkForestText,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Fee Breakdown Rows
          _buildPriceRow(
            'Standard Laboratory Fee',
            'Rs. ${_labTestDetails['originalPrice']}',
            isStrikethrough: true,
          ),
          const SizedBox(height: 6),
          _buildPriceRow(
            'Welfare Subsidy (${_labTestDetails['subsidyPercent']}%)',
            '- Rs. ${_labTestDetails['subsidyAmount']}',
            valueColor: _primaryGreen,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: _mintCardBorder, height: 1),
          ),

          // White Final Payable Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _mintCardBorder, width: 1.2),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 8,
              runSpacing: 8,
              children: [
                const Text(
                  'Net Payable at Lab:',
                  style: TextStyle(
                    color: _darkForestText,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Rs. ${_labTestDetails['payableAmount']}',
                  style: const TextStyle(
                    color: _primaryGreen,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Linked Digital ID: ${_labTestDetails['beneficiaryDigitalId']}',
            style: const TextStyle(
              color: _mutedText,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isStrikethrough = false,
    Color valueColor = _darkForestText,
  }) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 8,
      runSpacing: 8,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _darkForestText,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            decoration: isStrikethrough ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // PARTNER LAB LOCATION & CONTACT CARD
  // ---------------------------------------------------------------------------
  Widget _buildLabLocationCard() {
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
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 8,
            children: [
              const Text(
                'Diagnostic Center Details',
                style: TextStyle(
                  color: _darkForestText,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _mintCardBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Verified Partner',
                  style: TextStyle(
                    color: _primaryGreen,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildIconDetailRow(
            Icons.location_on_outlined,
            _labTestDetails['address'].toString(),
          ),
          const SizedBox(height: 9),
          _buildIconDetailRow(
            Icons.access_time_rounded,
            _labTestDetails['timings'].toString(),
          ),
          const SizedBox(height: 9),
          _buildIconDetailRow(
            Icons.phone_outlined,
            _labTestDetails['phone'].toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildIconDetailRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _primaryGreen, size: 17),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _darkForestText,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TEST OVERVIEW & PREPARATION CARD
  // ---------------------------------------------------------------------------
  Widget _buildTestOverviewCard() {
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
          const Text(
            'Test Information & Preparation',
            style: TextStyle(
              color: _darkForestText,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _labTestDetails['description'].toString(),
            style: const TextStyle(
              color: _mutedText,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          _buildSpecLine('Sample Type', _labTestDetails['sampleType'].toString()),
          const SizedBox(height: 8),
          _buildSpecLine(
              'Report Delivery', _labTestDetails['turnaroundTime'].toString()),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _neutralBtnBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _neutralBtnBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Patient Preparation Instructions:',
                  style: TextStyle(
                    color: _darkForestText,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _labTestDetails['preparation'].toString(),
                  style: const TextStyle(
                    color: _mutedText,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecLine(String label, String value) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 8,
      runSpacing: 8,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _mutedText,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: _darkForestText,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // AVAILABLE TIME SLOTS PREVIEW CARD
  // ---------------------------------------------------------------------------
  Widget _buildAvailableSlotsCard() {
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
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 8,
            children: [
              const Text(
                'Sample appointment slots (demo)',
                style: TextStyle(
                  color: _darkForestText,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${_todayAvailableSlots.length} Open',
                style: const TextStyle(
                  color: _primaryGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _todayAvailableSlots.map((slot) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _mintCardBg,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: _mintCardBorder, width: 1),
                ),
                child: Text(
                  slot.toString(),
                  style: const TextStyle(
                    color: _darkForestText,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PRIMARY BUTTON
  // ---------------------------------------------------------------------------
  Widget _buildPrimaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, size: 18),
          ],
        ),
      ),
    );
  }
}