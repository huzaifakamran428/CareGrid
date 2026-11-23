// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../complaints_feedback/presentation/state/complaint_demo_store.dart';

class BeneficiaryProfileScreen extends StatefulWidget {
  final ValueChanged<String> onOpen;
  const BeneficiaryProfileScreen({super.key, required this.onOpen});

  @override
  State<BeneficiaryProfileScreen> createState() =>
      _BeneficiaryProfileScreenState();
}

class _BeneficiaryProfileScreenState extends State<BeneficiaryProfileScreen> {
  // ---------------------------------------------------------------------------
  // DESIGN SYSTEM COLORS (100% Consistent with Home Screen)
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
  String _currentStatus = 'APPROVED'; // Switchable demo: APPROVED / PENDING / REJECTED

  final Map _profileData = {
    'fullName': 'Ayesha Bibi',
    'cnic': '35202-4819204-8',
    'phone': '+92 300 4829104',
    'city': 'Lahore, Punjab',
    'address': 'House 14, Street 6, Township, Lahore',
    'familyMembers': '5 Members',
    'monthlyIncome': 'Rs. 24,000',
    'ngoName': 'Al-Khidmat Foundation',
    'applicationRef': '#APP-2026-0842',
    'submittedDate': '10 Nov 2026',
    'decisionDate': '14 Nov 2026',
    'digitalId': 'CG-BEN-2026-009481',
    'rejectionReason':
        'Submitted CNIC front/back scan was blurred and household income certificate was missing.',
    'medicineSubsidy': '70% Covered',
    'labSubsidy': '80% Covered',
    'monthlyCap': 'Rs. 12,000',
    'remainingBalance': 'Rs. 8,500',
  };

  final List _uploadedDocuments = [
    {
      'title': 'CNIC (Front & Back)',
      'fileName': 'ayesha_cnic_verified.pdf',
      'status': 'Verified',
      'required': true,
    },
    {
      'title': 'Applicant Photograph',
      'fileName': 'profile_photo_2026.jpg',
      'status': 'Verified',
      'required': true,
    },
    {
      'title': '3 Months Utility Bills',
      'fileName': 'lesco_aug_oct_2026.pdf',
      'status': 'Verified',
      'required': true,
    },
    {
      'title': 'Salary Slip / Income Proof',
      'fileName': 'income_certificate.pdf',
      'status': 'Verified',
      'required': false,
    },
    {
      'title': 'Bank Statement',
      'fileName': 'Not Provided (Optional)',
      'status': 'Optional',
      'required': false,
    },
  ];

  void _copyDigitalId() {
    Clipboard.setData(
      ClipboardData(text: _profileData['digitalId'].toString()),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Digital ID ${_profileData['digitalId']} copied'),
        backgroundColor: _primaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
            // 1. TOP FOREST GREEN PROFILE HEADER
            _buildTopHeader(),

            // 2. MAIN WHITE ROUNDED CONTAINER
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
                        // Status Preview Switcher (To test Approved / Pending / Rejected states)
                        _buildStatusPreviewBar(),
                        const SizedBox(height: 14),

                        // Registration Decision & Digital ID Card
                        _buildApplicationDecisionCard(),
                        const SizedBox(height: 18),

                        // Personal & Household Information Card
                        _buildPersonalInfoCard(),
                        const SizedBox(height: 18),

                        // Subsidy Entitlements & Monthly Limits Card
                        _buildSubsidyRulesCard(),
                        const SizedBox(height: 18),

                        // Uploaded Verification Documents Card
                        _buildDocumentsCard(),
                        const SizedBox(height: 18),

                        // Complaints & Admin Responses Card
                        _buildComplaintsCard(),
                        const SizedBox(height: 18),

                        // Bottom Action Buttons
                        _buildSecondaryButton(
                          label: 'Submit a New Complaint',
                          icon: Icons.report_problem_outlined,
                          onTap: () =>
                              widget.onOpen('new-complaint'),
                        ),
                        const SizedBox(height: 10),
                        _buildSecondaryButton(
                          label: 'Rate Welfare Services & Share Feedback',
                          icon: Icons.star_outline_rounded,
                          onTap: () =>
                              widget.onOpen('feedback'),
                        ),
                        const SizedBox(height: 10),
                        _buildDangerOutlineButton(
                          label: 'Sign-in requires backend integration',
                          icon: Icons.info_outline,
                          onTap: () => _showSnack('Authentication is not enabled in this demo'),
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
          // Top Pill Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _amberBadge,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'BENEFICIARY PROFILE',
                  style: TextStyle(
                    color: _darkForestText,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              InkWell(
                onTap: () => _showSnack('Editing requires the beneficiary API'),
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
                      Icon(Icons.edit_outlined, color: Colors.white, size: 13),
                      SizedBox(width: 4),
                      Text(
                        'EDIT INFO',
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
            ],
          ),
          const SizedBox(height: 14),

          // Avatar + Name + NGO Info
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: _mintCardBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Center(
                  child: Text(
                    'AB',
                    style: TextStyle(
                      color: _primaryGreen,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _profileData['fullName'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'CNIC: ${_profileData['cnic']}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_profileData['ngoName']} • Ref ${_profileData['applicationRef']}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STATUS STATE SWITCHER (Approved / Pending / Rejected)
  // ---------------------------------------------------------------------------
  Widget _buildStatusPreviewBar() {
    final List statuses = ['APPROVED', 'PENDING', 'REJECTED'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _neutralBtnBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _neutralBtnBorder),
      ),
      child: Row(
        children: statuses.map((status) {
          final bool isSelected = _currentStatus == status;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentStatus = status.toString()),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? _primaryGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: Text(
                    status.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : _mutedText,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // APPLICATION DECISION & DIGITAL ID CARD (Matches Figma Card Styles)
  // ---------------------------------------------------------------------------
  Widget _buildApplicationDecisionCard() {
    if (_currentStatus == 'REJECTED') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _softRedBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _softRedBorder, width: 1.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _crimsonBadge,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.close, color: Colors.white, size: 13),
                      SizedBox(width: 4),
                      Text(
                        'DECISION: REJECTED',
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
                  _profileData['decisionDate'].toString(),
                  style: const TextStyle(
                    color: _crimsonBadge,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Application ${_profileData['applicationRef']} Declined',
              style: const TextStyle(
                color: Color(0xFF7A1C2B),
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your registration request could not be approved during NGO & Admin verification.',
              style: TextStyle(
                color: Color(0xFF7A1C2B),
                fontSize: 12.5,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _softRedBorder, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DOCUMENTED REJECTION REASON:',
                    style: TextStyle(
                      color: _crimsonBadge,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _profileData['rejectionReason'].toString(),
                    style: const TextStyle(
                      color: Color(0xFF5C1622),
                      fontSize: 12.5,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    _showSnack('Opening Document Re-upload & Re-apply'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _crimsonBadge,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Re-upload Documents & Re-apply',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_currentStatus == 'PENDING') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8EB),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _amberBadge, width: 1.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _amberBadge,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.hourglass_top_rounded,
                          color: _darkForestText, size: 13),
                      SizedBox(width: 4),
                      Text(
                        'DECISION: PENDING REVIEW',
                        style: TextStyle(
                          color: _darkForestText,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Submitted ${_profileData['submittedDate']}',
                  style: const TextStyle(
                    color: _darkForestText,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Application ${_profileData['applicationRef']} Under Verification',
              style: const TextStyle(
                color: _darkForestText,
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your uploaded documents are being reviewed by the System Administrator. Your Digital ID will be issued upon approval.',
              style: TextStyle(
                color: _mutedText,
                fontSize: 12.5,
                height: 1.35,
              ),
            ),
          ],
        ),
      );
    }

    // APPROVED STATE (Exact Mint Card Match)
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
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, color: Colors.white, size: 13),
                    SizedBox(width: 4),
                    Text(
                      'DECISION: APPROVED',
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
                _profileData['decisionDate'].toString(),
                style: const TextStyle(
                  color: _darkForestText,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Verified Welfare Digital ID',
            style: TextStyle(
              color: _darkForestText,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Approved via ${_profileData['ngoName']} (${_profileData['applicationRef']})',
            style: TextStyle(
              color: _darkForestText.withValues(alpha: 0.85),
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 12),
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
                    'Digital ID: ${_profileData['digitalId']}',
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
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PERSONAL & HOUSEHOLD DETAILS CARD
  // ---------------------------------------------------------------------------
  Widget _buildPersonalInfoCard() {
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
            'Personal & Household Details',
            style: TextStyle(
              color: _darkForestText,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Full Name', _profileData['fullName'].toString()),
          _buildInfoRow('CNIC Number', _profileData['cnic'].toString()),
          _buildInfoRow('Phone Number', _profileData['phone'].toString()),
          _buildInfoRow('Household Size', _profileData['familyMembers'].toString()),
          _buildInfoRow('Monthly Income', _profileData['monthlyIncome'].toString()),
          _buildInfoRow('Address', _profileData['address'].toString(), isLast: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 118,
            child: Text(
              label,
              style: const TextStyle(
                color: _mutedText,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: _darkForestText,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SUBSIDY RULES & LIMITS CARD
  // ---------------------------------------------------------------------------
  Widget _buildSubsidyRulesCard() {
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
            'Subsidy Entitlements & Limits',
            style: TextStyle(
              color: _darkForestText,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  'Pharmacy Subsidy',
                  _profileData['medicineSubsidy'].toString(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile(
                  'Lab Test Subsidy',
                  _profileData['labSubsidy'].toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _neutralBtnBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Remaining Monthly Limit',
                  style: TextStyle(
                    color: _mutedText,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${_profileData['remainingBalance']} / ${_profileData['monthlyCap']}',
                  style: const TextStyle(
                    color: _primaryGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _mintCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _mintCardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _mutedText,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: _darkForestText,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UPLOADED VERIFICATION DOCUMENTS CARD
  // ---------------------------------------------------------------------------
  Widget _buildDocumentsCard() {
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
                'Verification Documents',
                style: TextStyle(
                  color: _darkForestText,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              InkWell(
                onTap: () => _showSnack('Verification document upload requires the backend'),
                child: const Text(
                  '+ Upload',
                  style: TextStyle(
                    color: _primaryGreen,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._uploadedDocuments.map((doc) {
            final Map item = doc as Map;
            final bool isVerified = item['status'] == 'Verified';
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: _neutralBtnBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _neutralBtnBorder),
              ),
              child: Row(
                children: [
                  Icon(
                    isVerified
                        ? Icons.verified_rounded
                        : Icons.description_outlined,
                    color: isVerified ? _primaryGreen : _mutedText,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'].toString(),
                          style: const TextStyle(
                            color: _darkForestText,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          item['fileName'].toString(),
                          style: const TextStyle(
                            color: _mutedText,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isVerified ? _mintCardBg : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isVerified ? _mintCardBorder : _neutralBtnBorder,
                      ),
                    ),
                    child: Text(
                      item['status'].toString(),
                      style: TextStyle(
                        color: isVerified ? _primaryGreen : _mutedText,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // COMPLAINTS & ADMIN RESPONSES CARD
  // ---------------------------------------------------------------------------
  Widget _buildComplaintsCard() {
    return AnimatedBuilder(
      animation: complaintDemoStore,
      builder: (context, _) {
        final complaints = complaintDemoStore.complaints;
        final latest = complaints.isEmpty ? null : complaints.first;
        final status = latest == null
            ? 'No complaints'
            : switch (latest.status) {
                ComplaintStatus.submitted => 'Submitted',
                ComplaintStatus.inProgress => 'In review',
                ComplaintStatus.resolved => 'Resolved',
              };
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
              const Text('My Complaints & Support',
                  style: TextStyle(color: _darkForestText,
                      fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(status,
                  style: const TextStyle(color: _primaryGreen,
                      fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(latest == null ? 'No complaints submitted yet.'
                  : '${latest.reference} • ${latest.subject}',
                  style: const TextStyle(color: _darkForestText,
                      fontSize: 13, fontWeight: FontWeight.w600)),
              if (latest?.adminResponse != null) ...[
                const SizedBox(height: 9),
                Text('Response: ${latest!.adminResponse}',
                    style: const TextStyle(color: _mutedText, fontSize: 12)),
              ],
              const SizedBox(height: 9),
              TextButton.icon(
                onPressed: () => widget.onOpen('support'),
                icon: const Icon(Icons.arrow_forward, size: 17),
                label: const Text('View & track all complaints'),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // REUSABLE BUTTONS
  // ---------------------------------------------------------------------------
  Widget _buildSecondaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 17),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: _neutralBtnBg,
          foregroundColor: _darkForestText,
          side: const BorderSide(color: _neutralBtnBorder, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildDangerOutlineButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 17),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: _softRedBg,
          foregroundColor: _crimsonBadge,
          side: const BorderSide(color: _softRedBorder, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}