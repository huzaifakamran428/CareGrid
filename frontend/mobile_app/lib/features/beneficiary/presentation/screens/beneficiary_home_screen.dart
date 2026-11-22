// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BeneficiaryHomeScreen extends StatefulWidget {
  const BeneficiaryHomeScreen({super.key});

  @override
  State<BeneficiaryHomeScreen> createState() => _BeneficiaryHomeScreenState();
}

class _BeneficiaryHomeScreenState extends State<BeneficiaryHomeScreen> {
  // ---------------------------------------------------------------------------
  // DESIGN SYSTEM COLORS (Extracted directly from Figma)
  // ---------------------------------------------------------------------------
  static const Color _primaryGreen = Color(0xFF14634B);
  static const Color _headerBadgeBg = Color(0xFF1E755B);
  static const Color _headerBadgeBorder = Color(0xFF3E8E75);
  static const Color _amberBadge = Color(0xFFF4A623);

  static const Color _mintCardBg = Color(0xFFDDF2EA);
  static const Color _mintCardBorder = Color(0xFF2B7A62);
  static const Color _darkForestText = Color(0xFF1B4332);
  static const Color _mutedText = Color(0xFF4A635A);

  static const Color _softRedBg = Color(0xFFFBE9EC);
  static const Color _softRedBorder = Color(0xFFD6455D);
  static const Color _crimsonBadge = Color(0xFFD92D4B);

  static const Color _canvasBg = Color(0xFFF8FAFC);
  static const Color _neutralBtnBg = Color(0xFFF1F5F4);
  static const Color _neutralBtnBorder = Color(0xFFD5DFDC);

  // ---------------------------------------------------------------------------
  // DUMMY DATA
  // ---------------------------------------------------------------------------
  final Map _beneficiaryData = {
    'name': 'Ayesha Bibi',
    'ngoName': 'Al-Khidmat Foundation',
    'applicationRef': '#APP-2026-0842',
    'applicationStatus': 'APPROVED',
    'approvedDate': '14 Nov 2026',
    'digitalId': 'CG-BEN-2026-009481',
    'eligibilitySummary': 'Eligible for Subsidized Meds, Labs & Food',
    'medicineSubsidyPercent': 70,
    'labSubsidyPercent': 80,
    'monthlyRemainingLimit': 'Rs. 8,500 / 12,000',
    'unreadNotifications': 2,
  };

  final List _activePrescriptions = [
    {
      'id': 'RX-2026-114',
      'doctor': 'Dr. Tariq Mahmood (General Physician)',
      'date': '18 Nov 2026',
      'ocrStatus': 'OCR Verified • 3 Medicines Extracted',
    },
  ];

  final List _recentReports = [
    {
      'testName': 'Complete Blood Count (CBC)',
      'labName': 'Chughtai Lab - Lahore',
      'date': '16 Nov 2026',
      'status': 'Report Ready',
    },
  ];

  int _selectedNavIndex = 0;

  void _copyDigitalId() {
    Clipboard.setData(
      ClipboardData(text: _beneficiaryData['digitalId'].toString()),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Digital ID ${_beneficiaryData['digitalId']} copied'),
        backgroundColor: _primaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showPlaceholderAction(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $title'),
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
            _buildTopHeader(),

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
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Digital ID & Approval Status Card
                        _buildDigitalIdCard(),
                        const SizedBox(height: 16),

                        // Primary CTA Button
                        _buildPrimaryButton(
                          label: 'Open Digital ID Pass',
                          icon: Icons.arrow_forward,
                          onTap: () =>
                              _showPlaceholderAction('Digital ID Pass'),
                        ),
                        const SizedBox(height: 20),

                        // Welfare Services Grid
                        const Text(
                          'Welfare Services',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _darkForestText,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildServicesGrid(),
                        const SizedBox(height: 20),

                        // Uploaded Prescription Card
                        _buildPrescriptionsCard(),
                        const SizedBox(height: 16),

                        // Lab Reports Card
                        _buildLabReportsCard(),
                        const SizedBox(height: 18),

                        // Secondary Outlined Buttons
                        _buildSecondaryButton(
                          label: 'Need Help? Submit a Complaint',
                          onTap: () =>
                              _showPlaceholderAction('Submit a Complaint'),
                        ),
                        const SizedBox(height: 10),
                        _buildSecondaryButton(
                          label: 'Rate Services & Share Feedback',
                          onTap: () =>
                              _showPlaceholderAction('Service Feedback'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // ---------------------------------------------------------------------------
  // TOP HEADER WIDGET
  // ---------------------------------------------------------------------------
  Widget _buildTopHeader() {
    final int unreadCount = _beneficiaryData['unreadNotifications'] as int;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Status Pill Row + Notification Bell
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Amber Status Pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _amberBadge,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'VERIFIED BENEFICIARY',
                  style: TextStyle(
                    color: _darkForestText,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
              ),

              // Right Outlined Pill + Notification Bell
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _headerBadgeBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _headerBadgeBorder, width: 1),
                    ),
                    child: Text(
                      'SUBSIDY: ${_beneficiaryData['medicineSubsidyPercent']}%–${_beneficiaryData['labSubsidyPercent']}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => _showPlaceholderAction('Notifications'),
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _headerBadgeBg,
                            shape: BoxShape.circle,
                            border: Border.all(color: _headerBadgeBorder),
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: _amberBadge,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$unreadCount',
                                style: const TextStyle(
                                  color: _darkForestText,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Main Title
          Text(
            'Assalam-o-Alaikum, ${_beneficiaryData['name']}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle
          Text(
            'Registered via ${_beneficiaryData['ngoName']}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Monthly Subsidy Balance: ${_beneficiaryData['monthlyRemainingLimit']}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MINT APPROVED DIGITAL ID CARD
  // ---------------------------------------------------------------------------
  Widget _buildDigitalIdCard() {
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
          // Top Row: Approved Pill + Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _primaryGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check, color: Colors.white, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      'STATUS: ${_beneficiaryData['applicationStatus']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _beneficiaryData['approvedDate'].toString(),
                style: const TextStyle(
                  color: _darkForestText,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Card Heading
          const Text(
            'Active CareGrid Welfare Pass',
            style: TextStyle(
              color: _darkForestText,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Show this Digital ID at registered Pharmacies & Laboratories for instant eligibility check.',
            style: TextStyle(
              color: _darkForestText.withValues(alpha: 0.85),
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),

          // White Digital ID Box
          InkWell(
            onTap: _copyDigitalId,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _mintCardBorder, width: 1.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Digital ID: ${_beneficiaryData['digitalId']}',
                    style: const TextStyle(
                      color: _darkForestText,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Icon(
                    Icons.copy_rounded,
                    size: 16,
                    color: _primaryGreen,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Eligibility Checkmark Line
          Row(
            children: [
              const Icon(Icons.check, color: _primaryGreen, size: 15),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _beneficiaryData['eligibilitySummary'].toString(),
                  style: const TextStyle(
                    color: _primaryGreen,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),

          // Application Ref Line
          Text(
            'Application Ref: ${_beneficiaryData['applicationRef']}',
            style: const TextStyle(
              color: _mutedText,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // WELFARE SERVICES GRID
  // ---------------------------------------------------------------------------
  Widget _buildServicesGrid() {
    final List services = [
      {
        'title': 'Upload Prescription',
        'subtitle': 'AI Prescription Scan',
        'icon': Icons.document_scanner_outlined,
      },
      {
        'title': 'Subsidized Labs',
        'subtitle': 'Search & Book Tests',
        'icon': Icons.biotech_outlined,
      },
      {
        'title': 'Subsidy & Meds',
        'subtitle': '70% Pharmacy Cap',
        'icon': Icons.medication_outlined,
      },
      {
        'title': 'CareGrid AI Chat',
        'subtitle': 'Platform Help & Info',
        'icon': Icons.smart_toy_outlined,
      },
      {
        'title': 'Medical Reports',
        'subtitle': 'View & Download PDF',
        'icon': Icons.assignment_outlined,
      },
      {
        'title': 'Application Status',
        'subtitle': 'Docs & Decision Info',
        'icon': Icons.verified_user_outlined,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.65,
      ),
      itemBuilder: (context, index) {
        final Map item = services[index] as Map;
        return InkWell(
          onTap: () => _showPlaceholderAction(item['title'].toString()),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _neutralBtnBorder, width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: _mintCardBg,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: _primaryGreen,
                    size: 18,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _darkForestText,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['subtitle'].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _mutedText,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // PRESCRIPTIONS CARD
  // ---------------------------------------------------------------------------
  Widget _buildPrescriptionsCard() {
    final Map rx = _activePrescriptions.first as Map;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
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
                'My Uploaded Prescription',
                style: TextStyle(
                  color: _darkForestText,
                  fontSize: 14.5,
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
                  'Active',
                  style: TextStyle(
                    color: _primaryGreen,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${rx['id']} • ${rx['doctor']}',
            style: const TextStyle(
              color: _darkForestText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${rx['ocrStatus']} (${rx['date']})',
            style: const TextStyle(
              color: _primaryGreen,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _showPlaceholderAction('View / Replace Prescription'),
                  icon: const Icon(Icons.visibility_outlined, size: 15),
                  label: const Text('View / Update'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primaryGreen,
                    side: const BorderSide(color: _primaryGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () =>
                    _showPlaceholderAction('Delete Prescription'),
                icon: const Icon(Icons.delete_outline, size: 15),
                label: const Text('Delete'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _crimsonBadge,
                  backgroundColor: _softRedBg,
                  side: const BorderSide(color: _softRedBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LAB BOOKINGS & REPORTS CARD
  // ---------------------------------------------------------------------------
  Widget _buildLabReportsCard() {
    final Map report = _recentReports.first as Map;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
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
                'Recent Lab Report',
                style: TextStyle(
                  color: _darkForestText,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _primaryGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  report['status'].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            report['testName'].toString(),
            style: const TextStyle(
              color: _darkForestText,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${report['labName']} • ${report['date']}',
            style: const TextStyle(
              color: _mutedText,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () =>
                  _showPlaceholderAction('Download Digital Report'),
              icon: const Icon(Icons.download_rounded, size: 16),
              label: const Text('Download Digital Report'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _darkForestText,
                backgroundColor: _neutralBtnBg,
                side: const BorderSide(color: _neutralBtnBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // REUSABLE BUTTONS
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
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: _neutralBtnBg,
          foregroundColor: _darkForestText,
          side: const BorderSide(color: _neutralBtnBorder, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM NAVIGATION BAR
  // ---------------------------------------------------------------------------
  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: _neutralBtnBorder, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) {
          setState(() => _selectedNavIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _primaryGreen,
        unselectedItemColor: _mutedText,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.biotech_outlined),
            activeIcon: Icon(Icons.biotech),
            label: 'Labs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'AI Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}