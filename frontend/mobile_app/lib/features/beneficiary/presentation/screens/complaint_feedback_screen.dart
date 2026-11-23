// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class ComplaintFeedbackScreen extends StatefulWidget {
  const ComplaintFeedbackScreen({super.key});

  @override
  State<ComplaintFeedbackScreen> createState() =>
      _ComplaintFeedbackScreenState();
}

class _ComplaintFeedbackScreenState extends State<ComplaintFeedbackScreen> {
  // ---------------------------------------------------------------------------
  // DESIGN SYSTEM COLORS (100% Consistent across CareGrid Screens)
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
  // MODE & FORM STATE
  // ---------------------------------------------------------------------------
  int _activeTabIndex = 0; // 0 = Submit Complaint, 1 = Rate Services

  // Complaint Form Controllers & State
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  String _selectedCategory = 'Pharmacy Subsidy Issue';
  String _selectedProvider = 'Sehat Welfare Pharmacy - Johar Town';

  final List _complaintCategories = [
    'Pharmacy Subsidy Issue',
    'Laboratory Booking / Report Delay',
    'Digital ID Verification Error',
    'Food Distribution Quality',
    'Other Welfare Support',
  ];

  final List _providersList = [
    'Sehat Welfare Pharmacy - Johar Town',
    'Chughtai Lab - Johar Town',
    'Shaukat Khanum Diagnostic Centre',
    'Al-Khidmat Foundation Lahore',
  ];

  // Service Rating State
  int _starRating = 5;
  String _ratingProvider = 'Chughtai Lab - Johar Town';
  final TextEditingController _feedbackController = TextEditingController();

  // Dummy Tracked Complaints History
  final List _trackedComplaints = [
    {
      'refNo': 'CMP-2026-024',
      'category': 'Laboratory Booking / Report Delay',
      'provider': 'Chughtai Lab - Johar Town',
      'subject': 'CBC digital report upload delayed beyond 6 hours',
      'date': '20 Nov 2026',
      'status': 'Under Review',
      'adminReply':
          'Assigned to System Administrator. Lab branch notified to upload PDF.',
    },
    {
      'refNo': 'CMP-2026-019',
      'category': 'Pharmacy Subsidy Issue',
      'provider': 'Sehat Welfare Pharmacy - Johar Town',
      'subject': '70% subsidy cap not reflecting at counter',
      'date': '15 Nov 2026',
      'status': 'Resolved',
      'adminReply':
          'Your Digital ID quota has been refreshed and synced across all branches.',
    },
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _detailsController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitComplaint() {
    final String subject = _subjectController.text.trim();
    final String details = _detailsController.text.trim();

    if (subject.isEmpty || details.isEmpty) {
      _showSnack('Please fill in both subject and description fields.');
      return;
    }

    final String newRef = 'CMP-2026-0${25 + _trackedComplaints.length}';
    setState(() {
      _trackedComplaints.insert(0, {
        'refNo': newRef,
        'category': _selectedCategory,
        'provider': _selectedProvider,
        'subject': subject,
        'date': '22 Nov 2026',
        'status': 'Submitted',
        'adminReply':
            'Your complaint ($newRef) has been logged for Administrator review.',
      });
      _subjectController.clear();
      _detailsController.clear();
    });

    _showSnack('Complaint submitted • Reference ID: $newRef');
  }

  void _submitFeedback() {
    setState(() {
      _feedbackController.clear();
    });
    _showSnack('Thank you! Your $_starRating-star service rating was recorded.');
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _primaryGreen,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
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
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mode Toggle Switcher
                        _buildModeSwitcher(),
                        const SizedBox(height: 18),

                        if (_activeTabIndex == 0) ...[
                          _buildComplaintFormCard(),
                          const SizedBox(height: 20),
                          const Text(
                            'My Tracked Complaints',
                            style: TextStyle(
                              color: _darkForestText,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildTrackedComplaintsList(),
                        ] else ...[
                          _buildRatingFeedbackCard(),
                        ],
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
                  'SUPPORT & QUALITY',
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
            'Complaints & Service Feedback',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Report service issues with a tracked reference ID or rate partner pharmacies, labs & NGOs.',
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
  // MODE SWITCHER
  // ---------------------------------------------------------------------------
  Widget _buildModeSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _neutralBtnBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _neutralBtnBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _activeTabIndex = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color:
                      _activeTabIndex == 0 ? _primaryGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: Text(
                    'Submit a Complaint',
                    style: TextStyle(
                      color: _activeTabIndex == 0 ? Colors.white : _mutedText,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _activeTabIndex = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color:
                      _activeTabIndex == 1 ? _primaryGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: Text(
                    'Rate Services',
                    style: TextStyle(
                      color: _activeTabIndex == 1 ? Colors.white : _mutedText,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // COMPLAINT SUBMISSION FORM CARD
  // ---------------------------------------------------------------------------
  Widget _buildComplaintFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _neutralBtnBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Register Formal Complaint',
            style: TextStyle(
              color: _darkForestText,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Each complaint receives a unique reference number reviewed directly by the System Administrator.',
            style: TextStyle(
              color: _mutedText,
              fontSize: 12,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),

          // Issue Category Selector
          const Text(
            'Issue Category',
            style: TextStyle(
              color: _darkForestText,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          _buildDropdownBox(
            value: _selectedCategory,
            items: _complaintCategories,
            onChanged: (val) => setState(() => _selectedCategory = val),
          ),
          const SizedBox(height: 12),

          // Related Provider Selector
          const Text(
            'Related Service Provider / Branch',
            style: TextStyle(
              color: _darkForestText,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          _buildDropdownBox(
            value: _selectedProvider,
            items: _providersList,
            onChanged: (val) => setState(() => _selectedProvider = val),
          ),
          const SizedBox(height: 12),

          // Subject Input
          const Text(
            'Complaint Subject',
            style: TextStyle(
              color: _darkForestText,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          _buildTextInput(
            controller: _subjectController,
            hint: 'e.g., Delayed report or subsidy discount issue',
            maxLines: 1,
          ),
          const SizedBox(height: 12),

          // Detailed Description Input
          const Text(
            'Detailed Description',
            style: TextStyle(
              color: _darkForestText,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          _buildTextInput(
            controller: _detailsController,
            hint: 'Provide date, counter details, or booking reference...',
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          // Submit Complaint CTA
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _submitComplaint,
              icon: const Icon(Icons.send_rounded, size: 17),
              label: const Text(
                'Submit Complaint & Get Reference ID',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TRACKED COMPLAINTS LIST
  // ---------------------------------------------------------------------------
  Widget _buildTrackedComplaintsList() {
    return Column(
      children: List.generate(_trackedComplaints.length, (index) {
        final Map item = _trackedComplaints[index] as Map;
        final String status = item['status'].toString();
        final bool isResolved = status == 'Resolved';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isResolved ? _mintCardBorder : _neutralBtnBorder,
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: isResolved ? _primaryGreen : _amberBadge,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        color: isResolved ? Colors.white : _darkForestText,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    'Ref: ${item['refNo']} • ${item['date']}',
                    style: const TextStyle(
                      color: _mutedText,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                item['subject'].toString(),
                style: const TextStyle(
                  color: _darkForestText,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '${item['category']} • ${item['provider']}',
                style: const TextStyle(
                  color: _primaryGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isResolved ? _mintCardBg : _neutralBtnBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Admin Update: ${item['adminReply']}',
                  style: const TextStyle(
                    color: _darkForestText,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // SERVICE RATING & FEEDBACK CARD
  // ---------------------------------------------------------------------------
  Widget _buildRatingFeedbackCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _neutralBtnBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rate Partner Service Experience',
            style: TextStyle(
              color: _darkForestText,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your feedback helps NGOs and System Administrators maintain high service standards across partner providers.',
            style: TextStyle(
              color: _mutedText,
              fontSize: 12,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),

          const Text(
            'Select Service Provider',
            style: TextStyle(
              color: _darkForestText,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          _buildDropdownBox(
            value: _ratingProvider,
            items: _providersList,
            onChanged: (val) => setState(() => _ratingProvider = val),
          ),
          const SizedBox(height: 16),

          // 5-Star Interactive Selector
          const Text(
            'Overall Satisfaction Rating',
            style: TextStyle(
              color: _darkForestText,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: _mintCardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _mintCardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final int starIndex = index + 1;
                final bool isFilled = starIndex <= _starRating;
                return IconButton(
                  onPressed: () => setState(() => _starRating = starIndex),
                  icon: Icon(
                    isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isFilled ? _amberBadge : _mutedText,
                    size: 32,
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 14),

          const Text(
            'Additional Comments (Optional)',
            style: TextStyle(
              color: _darkForestText,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          _buildTextInput(
            controller: _feedbackController,
            hint: 'Share your experience with staff behavior, wait time, etc.',
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _submitFeedback,
              icon: const Icon(Icons.thumb_up_alt_outlined, size: 17),
              label: const Text(
                'Submit Service Rating',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // REUSABLE FORM INPUT HELPERS
  // ---------------------------------------------------------------------------
  Widget _buildDropdownBox({
    required String value,
    required List items,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _neutralBtnBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _neutralBtnBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: _primaryGreen),
          style: const TextStyle(
            color: _darkForestText,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
          items: items.map((item) {
            final String text = item.toString();
            return DropdownMenuItem<String>(
              value: text,
              child: Text(text, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hint,
    required int maxLines,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _neutralBtnBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _neutralBtnBorder),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          color: _darkForestText,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: _mutedText,
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        ),
      ),
    );
  }
}