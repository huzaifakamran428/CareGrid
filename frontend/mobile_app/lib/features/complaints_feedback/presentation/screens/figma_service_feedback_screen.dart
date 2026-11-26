import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CareGridServiceFeedbackApp());
}

class CareGridServiceFeedbackApp extends StatelessWidget {
  const CareGridServiceFeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareGrid - Service Feedback',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF155E42)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ServiceFeedbackScreen(),
    );
  }
}

class CompletedServiceOption {
  final String id;
  final String serviceTitle;
  final String providerName;
  final String recordCode;
  final String completionLabel;
  final bool isEligibleForFeedback;

  const CompletedServiceOption({
    required this.id,
    required this.serviceTitle,
    required this.providerName,
    required this.recordCode,
    required this.completionLabel,
    this.isEligibleForFeedback = true,
  });
}

class ServiceFeedbackScreen extends StatefulWidget {
  const ServiceFeedbackScreen({super.key});

  @override
  State<ServiceFeedbackScreen> createState() => _ServiceFeedbackScreenState();
}

class _ServiceFeedbackScreenState extends State<ServiceFeedbackScreen> {
  static const int _minChars = 10;
  static const int _maxChars = 400;

  final List<CompletedServiceOption> _services = const [
    CompletedServiceOption(
      id: 'srv_505',
      serviceTitle: 'Shifa Diagnostic Lab (HbA1c Test)',
      providerName: 'Shifa Diagnostic Lab',
      recordCode: '#BK-505',
      completionLabel: 'Completed Today',
      isEligibleForFeedback: true,
    ),
    CompletedServiceOption(
      id: 'srv_512',
      serviceTitle: 'Al-Khidmat Mobile Clinic (General Checkup)',
      providerName: 'Al-Khidmat Mobile Clinic',
      recordCode: '#BK-512',
      completionLabel: 'Completed 2 Days Ago',
      isEligibleForFeedback: true,
    ),
    CompletedServiceOption(
      id: 'srv_519',
      serviceTitle: 'City Care Pharmacy (Subsidized Insulin)',
      providerName: 'City Care Pharmacy',
      recordCode: '#BK-519',
      completionLabel: 'Completed 4 Days Ago',
      isEligibleForFeedback: true,
    ),
    CompletedServiceOption(
      id: 'srv_524',
      serviceTitle: 'Lahore Relief Meal Hub (Evening Ration)',
      providerName: 'Lahore Relief Meal Hub',
      recordCode: '#BK-524',
      completionLabel: 'Pending Verification (Ineligible)',
      isEligibleForFeedback: false,
    ),
  ];

  final TextEditingController _feedbackController = TextEditingController(
    text:
    'Fast sample collection using my Digital ID and 75% subsidy applied smoothly. Suggestion: Add early 7:30 AM fasting slots for diabetic beneficiaries.',
  );

  late CompletedServiceOption _selectedService;
  int _rating = 5;
  String? _savedReceiptCode = '#FBK-3309';
  bool _hasSubmittedCurrentDraft = true;
  String _selectedTestScenario = 'Valid 5-Star';

  @override
  void initState() {
    super.initState();
    _selectedService = _services.first;
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  String get _ratingDescriptor {
    switch (_rating) {
      case 1:
        return 'Poor Service';
      case 2:
        return 'Below Expectations';
      case 3:
        return 'Satisfactory Service';
      case 4:
        return 'Very Good Service';
      case 5:
        return 'Excellent Service';
      default:
        return 'Select Star Rating';
    }
  }

  String? get _serviceValidationError {
    if (!_selectedService.isEligibleForFeedback) {
      return 'Feedback is only enabled for verified completed services.';
    }
    return null;
  }

  String? get _ratingValidationError {
    if (_rating < 1 || _rating > 5) {
      return 'Select a rating between 1 and 5 stars.';
    }
    return null;
  }

  String? get _feedbackValidationError {
    final String trimmed = _feedbackController.text.trim();
    if (trimmed.isEmpty) {
      return 'Feedback & improvement suggestion cannot be empty or spaces only.';
    }
    if (trimmed.length < _minChars) {
      return 'Enter at least $_minChars characters (${trimmed.length}/$_minChars).';
    }
    if (trimmed.length > _maxChars) {
      return 'Exceeds maximum limit of $_maxChars characters.';
    }
    return null;
  }

  bool get _canSubmit =>
      _serviceValidationError == null &&
          _ratingValidationError == null &&
          _feedbackValidationError == null;

  void _markDraftModified() {
    setState(() {
      _hasSubmittedCurrentDraft = false;
      _selectedTestScenario = 'Custom Edit';
    });
  }

  void _applyTestScenario(String scenario) {
    setState(() {
      _selectedTestScenario = scenario;
      _hasSubmittedCurrentDraft = false;

      switch (scenario) {
        case 'Valid 5-Star':
          _selectedService = _services[0];
          _rating = 5;
          _feedbackController.text =
          'Fast sample collection using my Digital ID and 75% subsidy applied smoothly. Suggestion: Add early 7:30 AM fasting slots for diabetic beneficiaries.';
          break;
        case 'Low Rating (2★)':
          _selectedService = _services[1];
          _rating = 2;
          _feedbackController.text =
          'Waiting time exceeded 45 minutes at registration desk. Suggestion: Separate queue for elderly beneficiaries.';
          break;
        case 'Empty Text':
          _selectedService = _services[0];
          _rating = 4;
          _feedbackController.text = '   ';
          break;
        case 'Zero Stars':
          _selectedService = _services[0];
          _rating = 0;
          _feedbackController.text =
          'Smooth consultation and clear prescription guidance from clinic staff.';
          break;
        case 'Ineligible Service':
          _selectedService = _services[3];
          _rating = 4;
          _feedbackController.text =
          'Testing submission guard on a service that is not yet verified complete.';
          break;
      }
    });
  }

  void _submitFeedback() {
    if (!_canSubmit) {
      final String message = _serviceValidationError ??
          _ratingValidationError ??
          _feedbackValidationError ??
          'Please complete all required fields.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFFB91C1C),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final int nextCodeNumber = 3310 + (_feedbackController.text.length % 600);
    setState(() {
      _savedReceiptCode = '#FBK-$nextCodeNumber';
      _hasSubmittedCurrentDraft = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Feedback saved ($_savedReceiptCode) for ${_selectedService.providerName} ($_rating.0/5.0).',
        ),
        backgroundColor: const Color(0xFF155E42),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int charCount = _feedbackController.text.trim().length;
    final String? serviceError = _serviceValidationError;
    final String? ratingError = _ratingValidationError;
    final String? textError = _feedbackValidationError;

    return Scaffold(
      backgroundColor: const Color(0xFF155E42),
      body: SafeArea(
        child: Column(
          children: [
            // Clean CareGrid Header (Excludes top time, STORY badge, and MEDIUM badge)
            Padding(
              padding: const EdgeInsets.fromLTRB(22.0, 20.0, 22.0, 18.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Service Feedback',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Beneficiary Rating & Improvement Suggestions',
                      style: TextStyle(
                        color: Color(0xFFD1FAE5),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Saved on service & reviewed by Administrators',
                      style: TextStyle(
                        color: Color(0xFFA7F3D0),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom White Sheet Container
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18.0, 20.0, 18.0, 18.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // QUICK TEST SCENARIO CHIPS (For testing validation & states)
                      const Text(
                        'TEST SCENARIO PRESETS',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B7280),
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            'Valid 5-Star',
                            'Low Rating (2★)',
                            'Empty Text',
                            'Zero Stars',
                            'Ineligible Service',
                          ].map((preset) {
                            final bool active = _selectedTestScenario == preset;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(
                                  preset,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: active
                                        ? Colors.white
                                        : const Color(0xFF155E42),
                                  ),
                                ),
                                selected: active,
                                selectedColor: const Color(0xFF155E42),
                                backgroundColor: const Color(0xFFECFDF5),
                                side: const BorderSide(
                                  color: Color(0xFFA7F3D0),
                                ),
                                onSelected: (_) => _applyTestScenario(preset),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // SELECT COMPLETED CAREGRID SERVICE DROPDOWN
                      const Text(
                        'SELECT COMPLETED CAREGRID SERVICE *',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF374151),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F6F4),
                          border: Border.all(
                            color: serviceError == null
                                ? const Color(0xFF155E42)
                                : const Color(0xFFDC2626),
                            width: 1.3,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonHideUnderline(
                              child: DropdownButton<CompletedServiceOption>(
                                value: _selectedService,
                                isExpanded: true,
                                dropdownColor: Colors.white,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xFF155E42),
                                ),
                                items: _services.map((service) {
                                  return DropdownMenuItem<CompletedServiceOption>(
                                    value: service,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.biotech,
                                          color: Color(0xFF64748B),
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            service.serviceTitle,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (CompletedServiceOption? value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedService = value;
                                      _hasSubmittedCurrentDraft = false;
                                      _selectedTestScenario = 'Custom Edit';
                                    });
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 26, top: 2),
                              child: Text(
                                'Service Record ${_selectedService.recordCode} • ${_selectedService.completionLabel}',
                                style: TextStyle(
                                  color: _selectedService.isEligibleForFeedback
                                      ? const Color(0xFF4B5563)
                                      : const Color(0xFFDC2626),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (serviceError != null) ...[
                        const SizedBox(height: 5),
                        Text(
                          serviceError,
                          style: const TextStyle(
                            color: Color(0xFFDC2626),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // RATE YOUR SERVICE EXPERIENCE (5-STAR SELECTOR)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'RATE YOUR SERVICE EXPERIENCE *',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF374151),
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (_rating > 0)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _rating = 0;
                                  _hasSubmittedCurrentDraft = false;
                                  _selectedTestScenario = 'Zero Stars';
                                });
                              },
                              child: const Text(
                                'Clear Rating',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF155E42),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: ratingError == null
                              ? const Color(0xFFECFDF5)
                              : const Color(0xFFFEF2F2),
                          border: Border.all(
                            color: ratingError == null
                                ? const Color(0xFF155E42)
                                : const Color(0xFFDC2626),
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                final int starValue = index + 1;
                                final bool filled = starValue <= _rating;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _rating = starValue;
                                        _hasSubmittedCurrentDraft = false;
                                        _selectedTestScenario = 'Custom Edit';
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Icon(
                                      filled
                                          ? Icons.star_rounded
                                          : Icons.star_outline_rounded,
                                      color: filled
                                          ? const Color(0xFFF59E0B)
                                          : const Color(0xFF9CA3AF),
                                      size: 36,
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${_rating.toStringAsFixed(1)} / 5.0 — $_ratingDescriptor',
                              style: TextStyle(
                                color: ratingError == null
                                    ? const Color(0xFF111827)
                                    : const Color(0xFFDC2626),
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (ratingError != null) ...[
                        const SizedBox(height: 5),
                        Text(
                          ratingError,
                          style: const TextStyle(
                            color: Color(0xFFDC2626),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // FEEDBACK & IMPROVEMENT SUGGESTION
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'FEEDBACK & IMPROVEMENT SUGGESTION *',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF374151),
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            '$charCount/$_maxChars',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: charCount > _maxChars
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _feedbackController,
                        maxLines: 4,
                        onChanged: (_) => _markDraftModified(),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(_maxChars + 20),
                        ],
                        style: const TextStyle(
                          color: Color(0xFF374151),
                          fontSize: 13.5,
                          height: 1.38,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFFAFAFA),
                          hintText:
                          'Share your service experience and suggestions for improvement...',
                          hintStyle: const TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 13,
                          ),
                          errorText: textError,
                          errorStyle: const TextStyle(
                            color: Color(0xFFDC2626),
                            fontSize: 11.5,
                          ),
                          contentPadding: const EdgeInsets.all(14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFFD1D5DB),
                              width: 1.1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFF155E42),
                              width: 1.6,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFFDC2626),
                              width: 1.3,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFFDC2626),
                              width: 1.6,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // FEEDBACK BINDING & ADMIN VISIBILITY CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFF59E0B),
                            width: 1.1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.bar_chart_rounded,
                                  color: Color(0xFF2563EB),
                                  size: 18,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Feedback Binding & Admin Visibility:',
                                  style: TextStyle(
                                    color: Color(0xFF92400E),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '• Linked to Service: ${_selectedService.providerName} (${_selectedService.recordCode})',
                              style: const TextStyle(
                                color: Color(0xFF78350F),
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '• Rating ($_rating.0/5.0) & comments stored in Feedback DB',
                              style: const TextStyle(
                                color: Color(0xFF78350F),
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: const [
                                Icon(
                                  Icons.check,
                                  color: Color(0xFF155E42),
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Visible to authorized System Administrators',
                                    style: TextStyle(
                                      color: Color(0xFF155E42),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // SUBMIT SERVICE FEEDBACK BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF155E42),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFFD1D5DB),
                            disabledForegroundColor: const Color(0xFF6B7280),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: _canSubmit ? _submitFeedback : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Submit Service Feedback',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.check, size: 19),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // STATUS FOOTER BANNER
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: _canSubmit
                              ? const Color(0xFFDDF5E8)
                              : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.circle,
                              color: _canSubmit
                                  ? const Color(0xFF155E42)
                                  : const Color(0xFF9CA3AF),
                              size: 10,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                _hasSubmittedCurrentDraft &&
                                    _savedReceiptCode != null
                                    ? 'Feedback Saved ($_savedReceiptCode)'
                                    : _canSubmit
                                    ? 'Ready to Submit Feedback'
                                    : 'Fix Validation Errors Before Submitting',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _canSubmit
                                      ? const Color(0xFF155E42)
                                      : const Color(0xFF4B5563),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}