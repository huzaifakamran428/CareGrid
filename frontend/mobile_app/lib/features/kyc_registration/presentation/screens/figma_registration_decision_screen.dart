import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CareGridRegistrationDecisionApp());
}

class CareGridRegistrationDecisionApp extends StatelessWidget {
  const CareGridRegistrationDecisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareGrid - Registration Decision',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF155E42)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const RegistrationDecisionScreen(),
    );
  }
}

class RegistrationDecisionScreen extends StatefulWidget {
  const RegistrationDecisionScreen({super.key});

  @override
  State<RegistrationDecisionScreen> createState() =>
      _RegistrationDecisionScreenState();
}

class _RegistrationDecisionScreenState
    extends State<RegistrationDecisionScreen> {
  // 'both' | 'approved' | 'rejected'
  String _viewMode = 'both';
  String _selectedCard = 'approved';

  final String _applicantName = 'Ayesha Bibi';
  final String _ngoName = 'Al-Khidmat Foundation';
  final String _decisionDate = '14 Nov 2026';
  final String _digitalId = 'CG-BEN-2026-009481';
  final String _approvedRef = '#APP-2026-0842';

  final String _rejectedRef = '#APP-2026-0839';
  final String _rejectionReason =
      'Submitted CNIC front/back scan was blurred and household income certificate was missing.';

  void _showNotice(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF155E42),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openDigitalIdPassSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CareGrid Beneficiary Digital ID',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF155E42),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Beneficiary: $_applicantName\nPartner NGO: $_ngoName\nDigital ID: $_digitalId\nApplication Ref: $_approvedRef',
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF1F2937),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _digitalId));
                        Navigator.pop(context);
                        _showNotice('Copied $_digitalId to clipboard.');
                      },
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Copy ID'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF155E42),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _showNotice('Digital ID Pass ready for verification.');
                      },
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool showApproved = _viewMode == 'both' || _viewMode == 'approved';
    final bool showRejected = _viewMode == 'both' || _viewMode == 'rejected';
    final bool isDigitalIdEnabled =
        _viewMode == 'approved' || (_viewMode == 'both' && _selectedCard == 'approved');

    return Scaffold(
      backgroundColor: const Color(0xFF155E42),
      body: SafeArea(
        child: Column(
          children: [
            // Clean Header (Excludes top time, STORY badge, and HIGH badge)
            Padding(
              padding: const EdgeInsets.fromLTRB(22.0, 20.0, 22.0, 18.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Registration Decision',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Beneficiary Application Approval / Rejection',
                      style: TextStyle(
                        color: Color(0xFFD1FAE5),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Includes decision status & rejection reason',
                      style: TextStyle(
                        color: Color(0xFFA7F3D0),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main White Sheet
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
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
                      // VIEW MODE TOGGLE FOR TESTING BOTH STATES
                      Row(
                        children: [
                          _modeChip('Both', 'both'),
                          const SizedBox(width: 8),
                          _modeChip('Approved', 'approved'),
                          const SizedBox(width: 8),
                          _modeChip('Rejected', 'rejected'),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // APPROVED CARD
                      if (showApproved) ...[
                        InkWell(
                          onTap: () => setState(() => _selectedCard = 'approved'),
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: _selectedCard == 'approved'
                                    ? const Color(0xFF155E42)
                                    : const Color(0xFFA7F3D0),
                                width: _selectedCard == 'approved' ? 1.6 : 1.1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0E4D37),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 13,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            'DECISION: APPROVED',
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
                                      _decisionDate,
                                      style: const TextStyle(
                                        color: Color(0xFF155E42),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Congratulations, $_applicantName!',
                                  style: const TextStyle(
                                    color: Color(0xFF111827),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your CareGrid beneficiary registration via $_ngoName has been APPROVED.',
                                  style: const TextStyle(
                                    color: Color(0xFF4B5563),
                                    fontSize: 13,
                                    height: 1.38,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF155E42),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Text(
                                    'Digital ID: $_digitalId',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF0E4D37),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
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
                                        'Eligible for Subsidized Meds, Labs & Food',
                                        style: TextStyle(
                                          color: Color(0xFF155E42),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Application Ref: $_approvedRef',
                                  style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (showRejected) const SizedBox(height: 14),
                      ],

                      // REJECTED CARD
                      if (showRejected)
                        InkWell(
                          onTap: () => setState(() => _selectedCard = 'rejected'),
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: _selectedCard == 'rejected'
                                    ? const Color(0xFFDC2626)
                                    : const Color(0xFFFECACA),
                                width: _selectedCard == 'rejected' ? 1.5 : 1.1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDC2626),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 13,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            'DECISION: REJECTED',
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
                                    const Text(
                                      'Sample Notice',
                                      style: TextStyle(
                                        color: Color(0xFFBE123C),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Application $_rejectedRef Declined',
                                  style: const TextStyle(
                                    color: Color(0xFF111827),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Your registration request could not be approved during NGO & Admin verification.',
                                  style: TextStyle(
                                    color: Color(0xFF4B5563),
                                    fontSize: 13,
                                    height: 1.38,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFFECACA),
                                      width: 1.1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'DOCUMENTED REJECTION REASON:',
                                        style: TextStyle(
                                          color: Color(0xFFBE123C),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        _rejectionReason,
                                        style: const TextStyle(
                                          color: Color(0xFF374151),
                                          fontSize: 13,
                                          height: 1.38,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.check,
                                      color: Color(0xFFBE123C),
                                      size: 16,
                                    ),
                                    SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Mandatory rejection reason clearly displayed',
                                        style: TextStyle(
                                          color: Color(0xFFBE123C),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  'Visit nearest NGO desk to re-apply with valid ID.',
                                  style: TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      // OPEN DIGITAL ID PASS BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF155E42),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFFD1D5DB),
                            disabledForegroundColor: const Color(0xFF6B7280),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed:
                          isDigitalIdEnabled ? _openDigitalIdPassSheet : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Open Digital ID Pass',
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

                      // NEED HELP / SUBMIT COMPLAINT BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFF3F6F4),
                            foregroundColor: const Color(0xFF1F2937),
                            side: const BorderSide(
                              color: Color(0xFFD1DDD6),
                              width: 1.1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _showNotice(
                            'Opening Welfare Complaints for $_rejectedRef.',
                          ),
                          child: const Text(
                            'Need Help? Submit a Complaint',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
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

  Widget _modeChip(String label, String modeValue) {
    final bool selected = _viewMode == modeValue;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() {
          _viewMode = modeValue;
          if (modeValue == 'approved' || modeValue == 'rejected') {
            _selectedCard = modeValue;
          }
        }),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF155E42) : const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? const Color(0xFF155E42)
                  : const Color(0xFFA7F3D0),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : const Color(0xFF155E42),
            ),
          ),
        ),
      ),
    );
  }
}