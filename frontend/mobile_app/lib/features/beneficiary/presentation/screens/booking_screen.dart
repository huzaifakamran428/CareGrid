// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../state/booking_demo_store.dart';
import 'booking_history_screen.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic>? test;
  final String? rescheduleReference;
  const BookingScreen({super.key, this.test, this.rescheduleReference});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
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

  static const Color _canvasBg = Color(0xFFF8FAFC);
  static const Color _neutralBtnBg = Color(0xFFF1F5F4);
  static const Color _neutralBtnBorder = Color(0xFFD5DFDC);

  // ---------------------------------------------------------------------------
  // DUMMY DATA & SELECTION STATE
  // ---------------------------------------------------------------------------
  Map<String, dynamic> get _bookingContext {
    const base = <String, dynamic>{
    'testName': 'Complete Blood Count (CBC)',
    'testCode': 'LAB-CBC-104',
    'labName': 'Chughtai Lab - Johar Town',
    'address': 'Plot 12-B, Main Boulevard, Johar Town, Lahore',
    'beneficiaryName': 'Ayesha Bibi',
    'digitalId': 'CG-BEN-2026-009481',
    'originalPrice': 1500,
    'subsidyPercent': 80,
    'subsidyAmount': 1200,
    'payableAmount': 300,
    'linkedPrescription': 'RX-2026-114 (Demo)',
    };
    final chosen = widget.test;
    if (chosen == null) return base;
    final original = (chosen['originalPrice'] as num?)?.toInt() ?? 1500;
    final payable = (chosen['payableAmount'] as num?)?.toInt() ??
        (chosen['subsidizedPrice'] as num?)?.toInt() ?? 300;
    return {
      ...base,
      ...chosen,
      'originalPrice': original,
      'payableAmount': payable,
      'subsidyAmount': original - payable,
      'digitalId': chosen['digitalId'] ?? chosen['beneficiaryDigitalId'] ?? base['digitalId'],
    };
  }

  final List<Map<String, String>> _availableDates = List.generate(4, (offset) {
    final d = DateTime.now().add(Duration(days: offset));
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final shortDate = '${d.day} ${months[d.month - 1]}';
    return {
      'day': days[d.weekday - 1],
      'date': shortDate,
      'fullDate': '${days[d.weekday - 1]}, $shortDate ${d.year}',
    };
  });

  final List _timeSlots = [
    {'time': '09:30 AM', 'available': true},
    {'time': '10:15 AM', 'available': true},
    {'time': '11:00 AM', 'available': false},
    {'time': '12:30 PM', 'available': true},
    {'time': '02:30 PM', 'available': true},
    {'time': '04:00 PM', 'available': true},
    {'time': '05:15 PM', 'available': false},
    {'time': '06:30 PM', 'available': true},
  ];

  int _selectedDateIndex = 0;
  String _selectedSlot = '10:15 AM';
  bool _attachPrescription = true;
  bool _isBookingConfirmed = false;
  String _generatedBookingRef = '';

  void _confirmBooking() {
    final date = DateTime.now().add(Duration(days: _selectedDateIndex));
    if (widget.rescheduleReference != null) {
      final ref = widget.rescheduleReference!;
      if (!bookingDemoStore.reschedule(ref, date: date, timeSlot: _selectedSlot)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking is no longer available to reschedule.')),
        );
        return;
      }
      _generatedBookingRef = ref;
    } else {
      final booking = bookingDemoStore.add(
        test: _bookingContext,
        date: date,
        timeSlot: _selectedSlot,
        attachPrescription: _attachPrescription,
      );
      _generatedBookingRef = booking['bookingRef'].toString();
    }
    setState(() => _isBookingConfirmed = true);
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
                    child: _isBookingConfirmed
                        ? _buildConfirmedReceiptView()
                        : _buildBookingFormView(),
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
                child: Text(
                  _isBookingConfirmed ? 'BOOKING CONFIRMED' : 'APPOINTMENT SLOT',
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
          Text(
            _isBookingConfirmed
                ? 'Appointment Scheduled'
                : 'Book Subsidized Lab Test',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_bookingContext['testName']} • ${_bookingContext['labName']}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOOKING SELECTION FORM VIEW
  // ---------------------------------------------------------------------------
  Widget _buildBookingFormView() {
    final Map selectedDateObj = _availableDates[_selectedDateIndex] as Map;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Beneficiary & Digital ID Verification Banner
        _buildBeneficiaryIdentityCard(),
        const SizedBox(height: 16),

        // Date Selection Card
        _buildDateSelectorCard(),
        const SizedBox(height: 16),

        // Time Slot Selection Card
        _buildTimeSlotSelectorCard(),
        const SizedBox(height: 16),

        // Optional Prescription Attachment Toggle Card
        _buildPrescriptionToggleCard(),
        const SizedBox(height: 16),

        // Final Fee Summary Card
        _buildFeeSummaryCard(selectedDateObj['fullDate'].toString()),
        const SizedBox(height: 18),

        // Confirm Booking Primary Button
        _buildPrimaryButton(
          label: widget.rescheduleReference == null ? 'Save Demo Appointment' : 'Save New Date & Time',
          icon: Icons.check_circle_outline_rounded,
          onTap: _confirmBooking,
        ),
      ],
    );
  }

  Widget _buildBeneficiaryIdentityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _mintCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _mintCardBorder, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: _primaryGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.badge_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _bookingContext['beneficiaryName'].toString(),
                  style: const TextStyle(
                    color: _darkForestText,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Digital ID: ${_bookingContext['digitalId']}',
                  style: const TextStyle(
                    color: _primaryGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: _mintCardBorder),
            ),
            child: const Text(
              'Verified',
              style: TextStyle(
                color: _primaryGreen,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelectorCard() {
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
            '1. Select Appointment Date',
            style: TextStyle(
              color: _darkForestText,
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(_availableDates.length, (index) {
              final Map item = _availableDates[index] as Map;
              final bool isSelected = _selectedDateIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDateIndex = index),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: index == _availableDates.length - 1 ? 0 : 8,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: isSelected ? _primaryGreen : _neutralBtnBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? _primaryGreen : _neutralBtnBorder,
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          item['day'].toString(),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.85)
                                : _mutedText,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item['date'].toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : _darkForestText,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotSelectorCard() {
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
                '2. Select Available Time Slot',
                style: TextStyle(
                  color: _darkForestText,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                _selectedSlot,
                style: const TextStyle(
                  color: _primaryGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _timeSlots.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 3.2,
            ),
            itemBuilder: (context, index) {
              final Map slot = _timeSlots[index] as Map;
              final String time = slot['time'].toString();
              final bool isAvailable = slot['available'] as bool;
              final bool isSelected = _selectedSlot == time && isAvailable;

              return GestureDetector(
                onTap: isAvailable
                    ? () => setState(() => _selectedSlot = time)
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: !isAvailable
                        ? _neutralBtnBg.withValues(alpha: 0.6)
                        : isSelected
                            ? _mintCardBg
                            : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: !isAvailable
                          ? _neutralBtnBorder
                          : isSelected
                              ? _primaryGreen
                              : _neutralBtnBorder,
                      width: isSelected ? 1.5 : 1.1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      isAvailable ? time : '$time (Full)',
                      style: TextStyle(
                        color: !isAvailable
                            ? _mutedText.withValues(alpha: 0.55)
                            : isSelected
                                ? _primaryGreen
                                : _darkForestText,
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionToggleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _neutralBtnBorder, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _mintCardBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: _primaryGreen,
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Attach Uploaded Prescription',
                  style: TextStyle(
                    color: _darkForestText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _bookingContext['linkedPrescription'].toString(),
                  style: const TextStyle(
                    color: _mutedText,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _attachPrescription,
            activeColor: _primaryGreen,
            onChanged: (val) => setState(() => _attachPrescription = val),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeSummaryCard(String fullDate) {
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
            '3. Booking & Subsidy Summary',
            style: TextStyle(
              color: _darkForestText,
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          _buildSummaryRow('Date & Time', '$fullDate • $_selectedSlot'),
          const SizedBox(height: 7),
          _buildSummaryRow(
            'Standard Lab Fee',
            'Rs. ${_bookingContext['originalPrice']}',
          ),
          const SizedBox(height: 7),
          _buildSummaryRow(
            'CareGrid Subsidy (${_bookingContext['subsidyPercent']}%)',
            '- Rs. ${_bookingContext['subsidyAmount']}',
            valueColor: _primaryGreen,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: _neutralBtnBorder, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Amount Payable at Counter',
                style: TextStyle(
                  color: _darkForestText,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Rs. ${_bookingContext['payableAmount']}',
                style: const TextStyle(
                  color: _primaryGreen,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    Color valueColor = _darkForestText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _mutedText,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: valueColor,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // CONFIRMED BOOKING PASS / RECEIPT VIEW
  // ---------------------------------------------------------------------------
  Widget _buildConfirmedReceiptView() {
    final Map selectedDateObj = _availableDates[_selectedDateIndex] as Map;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mint Confirmation Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
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
                          'DEMO SAVED',
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
                    'Ref: $_generatedBookingRef',
                    style: const TextStyle(
                      color: _darkForestText,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                _bookingContext['testName'].toString(),
                style: const TextStyle(
                  color: _darkForestText,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _bookingContext['labName'].toString(),
                style: const TextStyle(
                  color: _primaryGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),

              // White Pass Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _mintCardBorder, width: 1.1),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      'Appointment Date',
                      selectedDateObj['fullDate'].toString(),
                    ),
                    const SizedBox(height: 7),
                    _buildSummaryRow('Time Slot', _selectedSlot),
                    const SizedBox(height: 7),
                    _buildSummaryRow(
                      'Digital ID',
                      _bookingContext['digitalId'].toString(),
                    ),
                    const SizedBox(height: 7),
                    _buildSummaryRow(
                      'Net Payable at Lab',
                      'Rs. ${_bookingContext['payableAmount']}',
                      valueColor: _primaryGreen,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'This is a demonstration booking only. No appointment has been sent to a laboratory.',
                style: TextStyle(
                  color: _darkForestText,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Modify / Reschedule Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => const BookingHistoryScreen(),
              ),
            ),
            icon: const Icon(Icons.edit_calendar_outlined, size: 17),
            label: const Text(
              'View My Demo Bookings',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
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
        ),
      ],
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
            Text(
              label,
              style: const TextStyle(
                fontSize: 14.5,
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
}