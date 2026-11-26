import 'package:flutter/material.dart';

void main() {
  runApp(const CareGridActivityNotificationsApp());
}

class CareGridActivityNotificationsApp extends StatelessWidget {
  const CareGridActivityNotificationsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareGrid - Activity Notifications',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF155E42)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ActivityNotificationsScreen(),
    );
  }
}

class ActivityAlertItem {
  final String id;
  final String categoryKey; // 'lab' | 'medicine' | 'account'
  final String badgeText;
  final IconData badgeIcon;
  final Color badgeBg;
  final Color badgeFg;
  final String timeLabel;
  final String title;
  final String subtitle;
  final String statusLine;
  final Color statusColor;
  final IconData statusIcon;
  final bool isFeatured;
  bool isRead;

  ActivityAlertItem({
    required this.id,
    required this.categoryKey,
    required this.badgeText,
    required this.badgeIcon,
    required this.badgeBg,
    required this.badgeFg,
    required this.timeLabel,
    required this.title,
    required this.subtitle,
    required this.statusLine,
    required this.statusColor,
    required this.statusIcon,
    this.isFeatured = false,
    this.isRead = false,
  });
}

class ActivityNotificationsScreen extends StatefulWidget {
  const ActivityNotificationsScreen({super.key});

  @override
  State<ActivityNotificationsScreen> createState() =>
      _ActivityNotificationsScreenState();
}

class _ActivityNotificationsScreenState
    extends State<ActivityNotificationsScreen> {
  // 'all' | 'lab' | 'medicine' | 'account'
  String _selectedFilter = 'all';
  String? _expandedAlertId = 'ntf_1';
  bool _pushAndInAppActive = true;
  int _simulatedCounter = 9922;

  late final List<ActivityAlertItem> _alerts = [
    ActivityAlertItem(
      id: 'ntf_1',
      categoryKey: 'lab',
      badgeText: 'LAB APPOINTMENT',
      badgeIcon: Icons.biotech,
      badgeBg: const Color(0xFF0E4D37),
      badgeFg: Colors.white,
      timeLabel: '2 mins ago',
      title: 'Booking #BK-505 Confirmed',
      subtitle: 'Shifa Diagnostic Lab • Sun 15 Nov, 09:30 AM',
      statusLine: 'Stored in Notification Ledger #NTF-9921',
      statusColor: const Color(0xFF155E42),
      statusIcon: Icons.circle,
      isFeatured: true,
    ),
    ActivityAlertItem(
      id: 'ntf_2',
      categoryKey: 'medicine',
      badgeText: 'MEDICINE SUBSIDY',
      badgeIcon: Icons.medication,
      badgeBg: const Color(0xFFF3F4F6),
      badgeFg: const Color(0xFF374151),
      timeLabel: '1 hr ago',
      title: 'Prescription Subsidized (80% Covered)',
      subtitle: 'CarePlus Medicos • Claim #TXN-9042 Verified',
      statusLine: 'Targeted delivery to Ayesha Bibi',
      statusColor: const Color(0xFF4B5563),
      statusIcon: Icons.check,
    ),
    ActivityAlertItem(
      id: 'ntf_3',
      categoryKey: 'account',
      badgeText: 'ACCOUNT ACTIVITY',
      badgeIcon: Icons.credit_card,
      badgeBg: const Color(0xFFFFFBEB),
      badgeFg: const Color(0xFF92400E),
      timeLabel: 'Yesterday',
      title: 'Digital ID & Profile Synced',
      subtitle: 'Annual eligibility renewal verified by NGO',
      statusLine: 'Notification metadata archived',
      statusColor: const Color(0xFF4B5563),
      statusIcon: Icons.check,
    ),
  ];

  List<ActivityAlertItem> get _filteredAlerts {
    if (_selectedFilter == 'all') return _alerts;
    return _alerts.where((a) => a.categoryKey == _selectedFilter).toList();
  }

  String get _filterDisplayLabel {
    switch (_selectedFilter) {
      case 'lab':
        return 'Lab Appointments';
      case 'medicine':
        return 'Medicine Subsidy';
      case 'account':
        return 'Account Activity';
      default:
        return 'All Event Types';
    }
  }

  void _showNotice(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: const Color(0xFF155E42),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addTestAlert() {
    final int code = _simulatedCounter++;
    setState(() {
      _alerts.insert(
        0,
        ActivityAlertItem(
          id: 'ntf_$code',
          categoryKey: 'lab',
          badgeText: 'LAB APPOINTMENT',
          badgeIcon: Icons.biotech,
          badgeBg: const Color(0xFF0E4D37),
          badgeFg: Colors.white,
          timeLabel: 'Just now',
          title: 'Sample Report Ready #LAB-$code',
          subtitle: 'Shifa Diagnostic Lab • Verified Digital Copy',
          statusLine: 'Stored in Notification Ledger #NTF-$code',
          statusColor: const Color(0xFF155E42),
          statusIcon: Icons.circle,
          isFeatured: true,
        ),
      );
      _expandedAlertId = 'ntf_$code';
    });
    _showNotice('Added sample alert #NTF-$code to inbox.');
  }

  @override
  Widget build(BuildContext context) {
    final List<ActivityAlertItem> visibleAlerts = _filteredAlerts;

    return Scaffold(
      backgroundColor: const Color(0xFF155E42),
      body: SafeArea(
        child: Column(
          children: [
            // Clean CareGrid Header (Excludes top time, STORY badge, and HIGH badge)
            Padding(
              padding: const EdgeInsets.fromLTRB(22.0, 20.0, 22.0, 18.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Activity Notifications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Beneficiary, Sponsor, Restaurant & Provider App',
                      style: TextStyle(
                        color: Color(0xFFD1FAE5),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Targeted alerts stored in user inbox',
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
                      // INBOX SUMMARY BAR + ADD TEST ALERT
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFD1DDD6),
                            width: 1.1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.notifications_active,
                                    color: Color(0xFFF59E0B),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Inbox (${visibleAlerts.length} Stored Alerts) • $_filterDisplayLabel',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xFF1F2937),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: _addTestAlert,
                              borderRadius: BorderRadius.circular(8),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                child: Text(
                                  '+ Test Alert',
                                  style: TextStyle(
                                    color: Color(0xFF155E42),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // FILTER CHIPS
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _filterChip('All', 'all'),
                            const SizedBox(width: 8),
                            _filterChip('Lab Appointment', 'lab'),
                            const SizedBox(width: 8),
                            _filterChip('Medicine Subsidy', 'medicine'),
                            const SizedBox(width: 8),
                            _filterChip('Account Activity', 'account'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // NOTIFICATION CARDS
                      if (visibleAlerts.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: const Text(
                            'No notifications in this category filter.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 13,
                            ),
                          ),
                        )
                      else
                        ...visibleAlerts.map((item) {
                          final bool isExpanded = _expandedAlertId == item.id;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildAlertCard(item, isExpanded),
                          );
                        }),

                      // EVENT NOTIFICATION ENGINE SUMMARY CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFD1DDD6),
                            width: 1.1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              children: [
                                Icon(
                                  Icons.inbox,
                                  color: Color(0xFF2563EB),
                                  size: 17,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Event Notification Engine:',
                                  style: TextStyle(
                                    color: Color(0xFF1F2937),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              '• Routes alerts strictly to relevant user IDs',
                              style: TextStyle(
                                color: Color(0xFF4B5563),
                                fontSize: 12.5,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              '• Full timestamp & payload stored in DB',
                              style: TextStyle(
                                color: Color(0xFF4B5563),
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // VIEW REGISTRATION ALERTS BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF155E42),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _showNotice(
                            'Navigating to Registration Alerts.',
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'View Registration Alerts',
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

                      // PUSH & IN-APP ALERTS STATUS TOGGLE BANNER
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _pushAndInAppActive = !_pushAndInAppActive;
                            });
                            _showNotice(
                              _pushAndInAppActive
                                  ? 'Push & In-App Alerts enabled.'
                                  : 'Push & In-App Alerts paused (UI preview).',
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: _pushAndInAppActive
                                  ? const Color(0xFFDDF5E8)
                                  : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: _pushAndInAppActive
                                      ? const Color(0xFF155E42)
                                      : const Color(0xFF6B7280),
                                  size: 10,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _pushAndInAppActive
                                      ? 'Push & In-App Alerts Active'
                                      : 'Push & In-App Alerts Paused',
                                  style: TextStyle(
                                    color: _pushAndInAppActive
                                        ? const Color(0xFF155E42)
                                        : const Color(0xFF4B5563),
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

  Widget _filterChip(String label, String key) {
    final bool selected = _selectedFilter == key;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.bold,
          color: selected ? Colors.white : const Color(0xFF155E42),
        ),
      ),
      selected: selected,
      selectedColor: const Color(0xFF155E42),
      backgroundColor: const Color(0xFFECFDF5),
      side: const BorderSide(color: Color(0xFFA7F3D0)),
      onSelected: (_) => setState(() => _selectedFilter = key),
    );
  }

  Widget _buildAlertCard(ActivityAlertItem item, bool isExpanded) {
    final bool highlightCard = item.isFeatured || isExpanded;

    return InkWell(
      onTap: () => setState(() {
        _expandedAlertId = isExpanded ? null : item.id;
        item.isRead = true;
      }),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: highlightCard
              ? const Color(0xFFECFDF5)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: highlightCard
                ? const Color(0xFF155E42)
                : const Color(0xFFD1D5DB),
            width: highlightCard ? 1.3 : 1.0,
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
                    color: item.badgeBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item.badgeIcon, color: item.badgeFg, size: 13),
                      const SizedBox(width: 5),
                      Text(
                        item.badgeText,
                        style: TextStyle(
                          color: item.badgeFg,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.5,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  item.timeLabel,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
            Text(
              item.title,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontWeight: FontWeight.bold,
                fontSize: 14.5,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              item.subtitle,
              style: const TextStyle(
                color: Color(0xFF4B5563),
                fontSize: 12.5,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  item.statusIcon,
                  color: item.statusColor,
                  size: item.statusIcon == Icons.circle ? 9 : 15,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.statusLine,
                    style: TextStyle(
                      color: item.statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFD1DDD6)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Alert ID: ${item.id.toUpperCase()} • ${item.isRead ? "Read" : "Unread"}',
                    style: const TextStyle(
                      color: Color(0xFF065F46),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () => _showNotice('Opened payload for ${item.title}'),
                    child: const Text(
                      'Inspect Details →',
                      style: TextStyle(
                        color: Color(0xFF155E42),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}