// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../../../../app/theme/brand_tokens.dart';
import '../../../../core/widgets/caregrid_brand.dart';
import '../state/booking_demo_store.dart';
import 'booking_screen.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
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

  static const Color _softRedBg = CareGridPalette.dangerTint;
  static const Color _softRedBorder = CareGridPalette.dangerBorder;
  static const Color _crimsonBadge = CareGridPalette.danger;

  static const Color _canvasBg = CareGridPalette.canvas;
  static const Color _neutralBtnBg = CareGridPalette.paleNeutral;
  static const Color _neutralBtnBorder = CareGridPalette.line;

  // ---------------------------------------------------------------------------
  // FILTER STATE & DUMMY BOOKINGS DATA
  // ---------------------------------------------------------------------------
  String _selectedTab = 'All';
  final List _tabs = ['All', 'Upcoming', 'Completed', 'Cancelled'];

  // Shared with the booking form so newly added entries appear here.
  List<Map<String, dynamic>> get _bookings => bookingDemoStore.bookings;

  @override
  void initState() {
    super.initState();
    bookingDemoStore.addListener(_refresh);
  }

  @override
  void dispose() {
    bookingDemoStore.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  List get _filteredBookings {
    if (_selectedTab == 'All') return _bookings;
    return _bookings.where((item) {
      final Map booking = item as Map;
      return booking['status'] == _selectedTab;
    }).toList();
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

  Future<void> _cancelBooking(Map booking) async {
    final reference = booking['bookingRef'].toString();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel demo appointment?'),
        content: Text('Cancel $reference? You can create a new booking later.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep booking'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Cancel appointment'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    final cancelled = bookingDemoStore.cancel(reference);
    _showSnack(cancelled
        ? 'Demo appointment $reference cancelled'
        : 'This appointment can no longer be cancelled');
  }

  @override
  Widget build(BuildContext context) {
    final List visibleBookings = _filteredBookings;

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
                  child: Column(
                    children: [
                      // Filter Tabs Row
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                        child: _buildStatusFilterTabs(),
                      ),

                      // Bookings List
                      Expanded(
                        child: visibleBookings.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 4, 16, 28),
                                itemCount: visibleBookings.length,
                                itemBuilder: (context, index) {
                                  final Map booking =
                                      visibleBookings[index] as Map;
                                  return _buildBookingCard(booking);
                                },
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

  // ---------------------------------------------------------------------------
  // TOP HEADER
  // ---------------------------------------------------------------------------
  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
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
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _amberBadge,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'APPOINTMENTS & REPORTS',
                  style: TextStyle(
                    color: _darkForestText,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _headerBadgeBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _headerBadgeBorder, width: 1),
                ),
                child: Text(
                  '${_bookings.length} TOTAL RECORDS',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'My Lab Bookings & Reports',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Manage your demo appointments here. Laboratory reports need a backend connection.',
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
  // FILTER TABS ROW
  // ---------------------------------------------------------------------------
  Widget _buildStatusFilterTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _neutralBtnBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _neutralBtnBorder),
      ),
      child: Row(
        children: _tabs.map((tab) {
          final String label = tab.toString();
          final bool isSelected = _selectedTab == label;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = label),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? _primaryGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : _mutedText,
                      fontSize: 11.5,
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
  // BOOKING / REPORT CARD
  // ---------------------------------------------------------------------------
  Widget _buildBookingCard(Map booking) {
    final String status = booking['status'].toString();
    final bool isUpcoming = status == 'Upcoming';
    final bool isCompleted = status == 'Completed';
    final bool isCancelled = status == 'Cancelled';

    Color badgeBg = _mintCardBg;
    Color badgeText = _primaryGreen;
    Color cardBorder = _neutralBtnBorder;

    if (isUpcoming) {
      badgeBg = _amberBadge;
      badgeText = _darkForestText;
      cardBorder = _mintCardBorder;
    } else if (isCompleted) {
      badgeBg = _primaryGreen;
      badgeText = Colors.white;
    } else if (isCancelled) {
      badgeBg = _softRedBg;
      badgeText = _crimsonBadge;
      cardBorder = _softRedBorder.withValues(alpha: 0.6);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Status Pill + Booking Ref
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: badgeText,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Text(
                'Ref: ${booking['bookingRef']}',
                style: const TextStyle(
                  color: _mutedText,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Test Title & Partner Lab
          Text(
            booking['testName'].toString(),
            style: const TextStyle(
              color: _darkForestText,
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            booking['labName'].toString(),
            style: const TextStyle(
              color: _primaryGreen,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),

          // Date, Time Slot & Subsidized Fee Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: _neutralBtnBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 14, color: _mutedText),
                    const SizedBox(width: 6),
                    Text(
                      '${booking['date']} • ${booking['timeSlot']}',
                      style: const TextStyle(
                        color: _darkForestText,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Paid: Rs. ${booking['payableAmount']}',
                  style: const TextStyle(
                    color: _primaryGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          // Conditional Action Footer
          if (isUpcoming) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => BookingScreen(
                          test: Map<String, dynamic>.from(booking),
                          rescheduleReference: booking['bookingRef'].toString(),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.edit_calendar_outlined, size: 15),
                    label: const Text('Reschedule'),
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
                  onPressed: () => _cancelBooking(booking),
                  icon: const Icon(Icons.close_rounded, size: 15),
                  label: const Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _crimsonBadge,
                    backgroundColor: _softRedBg,
                    side: const BorderSide(color: _softRedBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                  ),
                ),
              ],
            ),
          ],

          if (isCompleted) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showSnack(
                    'PDF report download requires backend integration'),
                icon: const Icon(Icons.download_rounded, size: 16),
                label: const Text(
                  'View Lab Report (demo unavailable)',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY FILTER STATE
  // ---------------------------------------------------------------------------
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: _mintCardBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_busy_rounded,
                color: _primaryGreen,
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No $_selectedTab Bookings',
              style: const TextStyle(
                color: _darkForestText,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Any lab appointments matching this filter will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _mutedText,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}