import 'package:flutter/material.dart';
import '../../../../app/theme/caregrid_theme.dart';
import '../../../../app/theme/brand_tokens.dart';

void main() {
  runApp(const CareGridWelfareComplaintsApp());
}

class CareGridWelfareComplaintsApp extends StatelessWidget {
  const CareGridWelfareComplaintsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareGrid - Welfare Complaints',
      debugShowCheckedModeBanner: false,
      theme: CareGridTheme.light,
      home: const WelfareComplaintsScreen(),
    );
  }
}

class WelfareServiceCategory {
  final String id;
  final String label;
  final IconData icon;
  final Color iconColor;
  final bool isValidSelection;

  const WelfareServiceCategory({
    required this.id,
    required this.label,
    required this.icon,
    required this.iconColor,
    this.isValidSelection = true,
  });
}

class WelfareComplaintsScreen extends StatefulWidget {
  const WelfareComplaintsScreen({super.key});

  @override
  State<WelfareComplaintsScreen> createState() =>
      _WelfareComplaintsScreenState();
}

class _WelfareComplaintsScreenState extends State<WelfareComplaintsScreen> {
  static const int _minChars = 15;
  static const int _maxChars = 500;

  final List<WelfareServiceCategory> _categories = const [
    WelfareServiceCategory(
      id: 'pharmacy_copay',
      label: 'Subsidized Pharmacy Dispensing Issue',
      icon: Icons.medication,
      iconColor: CareGridPalette.danger,
      isValidSelection: true,
    ),
    WelfareServiceCategory(
      id: 'lab_delay',
      label: 'Diagnostic Lab Appointment & Slot Delay',
      icon: Icons.biotech,
      iconColor: CareGridPalette.info,
      isValidSelection: true,
    ),
    WelfareServiceCategory(
      id: 'food_ration',
      label: 'Food Ration & Surplus Distribution Issue',
      icon: Icons.volunteer_activism,
      iconColor: CareGridPalette.primary,
      isValidSelection: true,
    ),
    WelfareServiceCategory(
      id: 'select_category',
      label: 'Select Category (Invalid Guard Test)',
      icon: Icons.help_outline,
      iconColor: CareGridPalette.secondaryText,
      isValidSelection: false,
    ),
  ];

  final TextEditingController _detailsController = TextEditingController(
    text:
    'Partner pharmacy asked for 40% co-pay instead of my approved 20% chronic care tier on Transaction #TXN-9038.',
  );

  String _selectedCategoryId = 'pharmacy_copay';
  String _activeRef = '#CMP-2026-4418';
  String _complaintStatusLabel = 'RESOLVED';
  String _adminReplyText =
      '"We verified #TXN-9038 and credited PKR 300 excess co-pay back to your subsidy balance. Pharmacy billing rule has been corrected."';
  String _adminReplyMeta = 'Replied by: System Admin • 14 Nov 2026';
  bool _isAccountFlagged = true;
  bool _isRefSaved = true;
  String _selectedScenario = 'Resolved Case';

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  WelfareServiceCategory get _selectedCategory {
    return _categories.firstWhere(
          (c) => c.id == _selectedCategoryId,
      orElse: () => _categories.first,
    );
  }

  String? get _categoryError {
    if (!_selectedCategory.isValidSelection) {
      return 'Please choose a valid welfare service category.';
    }
    return null;
  }

  String? get _detailsError {
    final String raw = _detailsController.text;
    if (raw.contains('-')) {
      return 'Negative signs (-) are not allowed in complaint details.';
    }
    final String trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return 'Complaint details cannot be empty or spaces only.';
    }
    if (trimmed.length < _minChars) {
      return 'Provide at least $_minChars characters (${trimmed.length}/$_minChars).';
    }
    if (trimmed.length > _maxChars) {
      return 'Exceeds maximum limit of $_maxChars characters.';
    }
    return null;
  }

  bool get _canSubmit => _categoryError == null && _detailsError == null;

  void _applyScenario(String scenario) {
    setState(() {
      _selectedScenario = scenario;
      switch (scenario) {
        case 'Resolved Case':
          _selectedCategoryId = 'pharmacy_copay';
          _detailsController.text =
          'Partner pharmacy asked for 40% co-pay instead of my approved 20% chronic care tier on Transaction #TXN-9038.';
          _activeRef = '#CMP-2026-4418';
          _complaintStatusLabel = 'RESOLVED';
          _adminReplyText =
          '"We verified #TXN-9038 and credited PKR 300 excess co-pay back to your subsidy balance. Pharmacy billing rule has been corrected."';
          _adminReplyMeta = 'Replied by: System Admin • 14 Nov 2026';
          _isAccountFlagged = true;
          _isRefSaved = true;
          break;
        case 'Empty Details':
          _selectedCategoryId = 'pharmacy_copay';
          _detailsController.text = '   ';
          _isRefSaved = false;
          break;
        case 'Negative Input':
          _selectedCategoryId = 'lab_delay';
          _detailsController.text = 'Wait time was -15 minutes on booking slot.';
          _isRefSaved = false;
          break;
        case 'Unselected Category':
          _selectedCategoryId = 'select_category';
          _detailsController.text =
          'Unable to view my assigned food ration pickup pass for today.';
          _isRefSaved = false;
          break;
      }
    });
  }

  void _submitComplaint() {
    if (!_canSubmit) {
      final String msg = _categoryError ??
          _detailsError ??
          'Please complete all required fields properly.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: CareGridPalette.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final int nextRef = 4420 + (_detailsController.text.length % 500);
    setState(() {
      _activeRef = '#CMP-2026-$nextRef';
      _complaintStatusLabel = 'OPEN';
      _adminReplyText =
      '"Complaint logged with System Administrator. Assigned for subsidy & service verification."';
      _adminReplyMeta = 'Queued for System Admin • Just Now';
      _isAccountFlagged = true;
      _isRefSaved = true;
      _selectedScenario = 'Custom Edit';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Complaint submitted. Issued Reference $_activeRef.'),
        backgroundColor: CareGridPalette.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showActionNotice(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: CareGridPalette.primaryDeep,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? catErr = _categoryError;
    final String? detErr = _detailsError;
    final int charCount = _detailsController.text.trim().length;

    return Scaffold(
      backgroundColor: CareGridPalette.primary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22.0, 20.0, 22.0, 18.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Welfare Complaints',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Beneficiary Mobile App • Report Issues',
                      style: TextStyle(
                        color: CareGridPalette.paleMint,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Unique Ref # issued & "Complaint" status set',
                      style: TextStyle(
                        color: CareGridPalette.mintBorder,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                      const Text(
                        'TEST SCENARIO PRESETS',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: CareGridPalette.secondaryText,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            'Resolved Case',
                            'Empty Details',
                            'Negative Input',
                            'Unselected Category',
                          ].map((preset) {
                            final bool active = _selectedScenario == preset;
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
                                        : CareGridPalette.primary,
                                  ),
                                ),
                                selected: active,
                                selectedColor: CareGridPalette.primary,
                                backgroundColor: CareGridPalette.paleMint,
                                side: const BorderSide(
                                  color: CareGridPalette.mintBorder,
                                ),
                                onSelected: (_) => _applyScenario(preset),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: _isAccountFlagged
                              ? CareGridPalette.goldTint
                              : CareGridPalette.paleMint,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _isAccountFlagged
                                ? CareGridPalette.gold
                                : CareGridPalette.primary,
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _isAccountFlagged
                                      ? Icons.warning_amber_rounded
                                      : Icons.verified_user,
                                  color: _isAccountFlagged
                                      ? CareGridPalette.goldDeep
                                      : CareGridPalette.primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    _isAccountFlagged
                                        ? 'Account Flagged: "COMPLAINT" STATUS'
                                        : 'Account Flag Cleared: Normal Standing',
                                    style: TextStyle(
                                      color: _isAccountFlagged
                                          ? CareGridPalette.goldDeep
                                          : CareGridPalette.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Active Ref: $_activeRef • Sent to Admin',
                              style: TextStyle(
                                color: _isAccountFlagged
                                    ? CareGridPalette.goldDeep
                                    : CareGridPalette.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'WELFARE SERVICE CATEGORY *',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: CareGridPalette.ink,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: CareGridPalette.canvas,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: catErr == null
                                ? CareGridPalette.primary
                                : CareGridPalette.danger,
                            width: 1.3,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCategoryId,
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: CareGridPalette.primary,
                            ),
                            items: _categories.map((cat) {
                              return DropdownMenuItem<String>(
                                value: cat.id,
                                child: Row(
                                  children: [
                                    Icon(
                                      cat.icon,
                                      color: cat.iconColor,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        cat.label,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: CareGridPalette.ink,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newId) {
                              if (newId != null) {
                                setState(() {
                                  _selectedCategoryId = newId;
                                  _isRefSaved = false;
                                  _selectedScenario = 'Custom Edit';
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      if (catErr != null) ...[
                        const SizedBox(height: 5),
                        Text(
                          catErr,
                          style: const TextStyle(
                            color: CareGridPalette.danger,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'COMPLAINT DETAILS *',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: CareGridPalette.ink,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            '$charCount/$_maxChars',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: charCount > _maxChars
                                  ? CareGridPalette.danger
                                  : CareGridPalette.secondaryText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _detailsController,
                        maxLines: 4,
                        maxLength: _maxChars + 20,
                        onChanged: (_) => setState(() {
                          _isRefSaved = false;
                          _selectedScenario = 'Custom Edit';
                        }),
                        style: const TextStyle(
                          color: CareGridPalette.ink,
                          fontSize: 13.5,
                          height: 1.38,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: CareGridPalette.canvas,
                          counterText: '',
                          hintText:
                          'Describe the issue clearly with transaction or service details...',
                          hintStyle: const TextStyle(
                            color: CareGridPalette.secondaryText,
                            fontSize: 13,
                          ),
                          errorText: detErr,
                          errorStyle: const TextStyle(
                            color: CareGridPalette.danger,
                            fontSize: 11.5,
                          ),
                          contentPadding: const EdgeInsets.all(14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: CareGridPalette.line,
                              width: 1.1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: CareGridPalette.primary,
                              width: 1.6,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: CareGridPalette.danger,
                              width: 1.3,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: CareGridPalette.danger,
                              width: 1.6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CareGridPalette.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: CareGridPalette.line,
                            disabledForegroundColor: CareGridPalette.secondaryText,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _canSubmit ? _submitComplaint : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Submit Complaint & Get Ref #',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: CareGridPalette.paleMint,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: CareGridPalette.primary,
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: CareGridPalette.primaryDeep,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.chat_bubble,
                                        color: Colors.white,
                                        size: 13,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'ADMIN RESPONSE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.5,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Status: $_complaintStatusLabel',
                                  style: const TextStyle(
                                    color: CareGridPalette.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Ref $_activeRef — Official Reply:',
                              style: const TextStyle(
                                color: CareGridPalette.ink,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _adminReplyText,
                              style: const TextStyle(
                                color: CareGridPalette.ink,
                                fontSize: 13,
                                height: 1.38,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: const [
                                Icon(
                                  Icons.check,
                                  color: CareGridPalette.primary,
                                  size: 15,
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    'Complaint info & Admin reply visible to user',
                                    style: TextStyle(
                                      color: CareGridPalette.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _adminReplyMeta,
                              style: const TextStyle(
                                color: CareGridPalette.secondaryText,
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CareGridPalette.primaryDeep,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _showActionNotice(
                            'Navigating to Service Feedback for $_activeRef.',
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Rate & Give Feedback',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () {
                            setState(() => _isRefSaved = true);
                            _showActionNotice(
                              'Reference $_activeRef copied & saved to account.',
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: CareGridPalette.paleMint,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: CareGridPalette.primary,
                                  size: 17,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _isRefSaved
                                      ? 'Reference $_activeRef Saved'
                                      : 'Save Reference $_activeRef',
                                  style: const TextStyle(
                                    color: CareGridPalette.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}