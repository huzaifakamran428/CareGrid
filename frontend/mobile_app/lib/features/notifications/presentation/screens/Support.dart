// CareGrid - Support & Alerts Module (single file)
// Home: Activity Notifications -> Registration Decision / Complaints / Feedback
// Koi extra package ya asset setup nahi chahiye: logo isi file mein embedded hai.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CareGridSupportApp());
}

// ============================================================================
// THEME
// ============================================================================
const Color kGreen = Color(0xFF155E42);
const Color kDarkGreen = Color(0xFF0E4D37);
const Color kMint = Color(0xFFECFDF5);
const Color kMintBorder = Color(0xFFA7F3D0);
const Color kAmber = Color(0xFFF59E0B);
const Color kAmberBg = Color(0xFFFFFBEB);
const Color kAmberText = Color(0xFF92400E);
const Color kRed = Color(0xFFDC2626);
const Color kInk = Color(0xFF111827);
const Color kText = Color(0xFF374151);
const Color kMuted = Color(0xFF6B7280);
const Color kBorder = Color(0xFFD1DDD6);
const Color kSurface = Color(0xFFF8FAFC);

const TextStyle kLabelStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.bold,
  color: kText,
  letterSpacing: 0.5,
);

class CareGridSupportApp extends StatelessWidget {
  const CareGridSupportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareGrid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kGreen),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ActivityNotificationsScreen(),
    );
  }
}

// ============================================================================
// BENEFICIARY SAMPLE DATA
// ============================================================================
const String kApplicantName = 'Ayesha Bibi';
const String kNgoName = 'Al-Khidmat Foundation';
const String kDecisionDate = '14 Nov 2026';
const String kDigitalId = 'CG-BEN-2026-009481';
const String kApprovedRef = '#APP-2026-0842';
const String kRejectedRef = '#APP-2026-0839';
const String kRejectionReason =
    'Submitted CNIC front/back scan was blurred and household income certificate was missing.';

// ============================================================================
// MODELS
// ============================================================================
enum AlertTarget { registration, complaints, feedback }

class ActivityAlert {
  ActivityAlert({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.statusLine,
    required this.target,
    this.timeLabel = 'Just now',
    this.refId,
    this.isRead = false,
  });

  final int id;
  final String category; // 'lab' | 'medicine' | 'account'
  final String title;
  final String subtitle;
  final String statusLine;
  final AlertTarget target;
  final String timeLabel;
  final String? refId; // service id ya complaint ref
  bool isRead;

  String get code => 'NTF-$id';
}

class ComplaintCategory {
  const ComplaintCategory(this.id, this.label, this.icon, this.color);

  final String id;
  final String label;
  final IconData icon;
  final Color color;
}

const String kNoCategory = 'select_category';

const List<ComplaintCategory> kComplaintCategories = [
  ComplaintCategory(kNoCategory, 'Select Category', Icons.help_outline,
      Color(0xFF9CA3AF)),
  ComplaintCategory('pharmacy_copay', 'Subsidized Pharmacy Dispensing Issue',
      Icons.medication, Color(0xFFEF4444)),
  ComplaintCategory('lab_delay', 'Diagnostic Lab Appointment & Slot Delay',
      Icons.biotech, Color(0xFF0284C7)),
  ComplaintCategory('food_ration', 'Food Ration & Surplus Distribution Issue',
      Icons.volunteer_activism, kGreen),
  ComplaintCategory('registration', 'Registration & Application Issue',
      Icons.assignment_ind, Color(0xFF7C3AED)),
];

class Complaint {
  Complaint({
    required this.ref,
    required this.categoryId,
    required this.details,
    required this.reply,
    required this.replyMeta,
    this.isOpen = true,
  });

  final String ref;
  final String categoryId;
  final String details;
  String reply;
  String replyMeta;
  bool isOpen;
}

class ServiceOption {
  const ServiceOption(
      this.id,
      this.title,
      this.provider,
      this.recordCode,
      this.completionLabel, {
        this.eligible = true,
      });

  final String id;
  final String title;
  final String provider;
  final String recordCode;
  final String completionLabel;
  final bool eligible;
}

const List<ServiceOption> kServices = [
  ServiceOption('srv_505', 'Shifa Diagnostic Lab (HbA1c Test)',
      'Shifa Diagnostic Lab', '#BK-505', 'Completed Today'),
  ServiceOption('srv_512', 'Al-Khidmat Mobile Clinic (General Checkup)',
      'Al-Khidmat Mobile Clinic', '#BK-512', 'Completed 2 Days Ago'),
  ServiceOption('srv_519', 'City Care Pharmacy (Subsidized Insulin)',
      'City Care Pharmacy', '#BK-519', 'Completed 4 Days Ago'),
  ServiceOption('srv_524', 'Lahore Relief Meal Hub (Evening Ration)',
      'Lahore Relief Meal Hub', '#BK-524', 'Pending Verification (Ineligible)',
      eligible: false),
];

class FeedbackEntry {
  const FeedbackEntry(this.code, this.rating, this.comment);

  final String code;
  final int rating;
  final String comment;
}

// ============================================================================
// SHARED STORE (in-memory, app restart par reset)
// ============================================================================
class SupportStore extends ChangeNotifier {
  int _nextAlert = 9922;
  int _nextComplaint = 4419;
  int _nextFeedback = 3310;
  bool pushActive = true;

  final List<ActivityAlert> alerts = [
    ActivityAlert(
      id: 9921,
      category: 'lab',
      title: 'Booking #BK-505 Confirmed',
      subtitle: 'Shifa Diagnostic Lab • Sun 15 Nov, 09:30 AM',
      statusLine: 'Rate this service after your visit',
      target: AlertTarget.feedback,
      refId: 'srv_505',
      timeLabel: '2 mins ago',
    ),
    ActivityAlert(
      id: 9920,
      category: 'medicine',
      title: 'Prescription Subsidized (80% Covered)',
      subtitle: 'CarePlus Medicos • Claim #TXN-9042 Verified',
      statusLine: 'Targeted delivery to $kApplicantName',
      target: AlertTarget.complaints,
      timeLabel: '1 hr ago',
    ),
    ActivityAlert(
      id: 9919,
      category: 'account',
      title: 'Digital ID & Profile Synced',
      subtitle: 'Annual eligibility renewal verified by NGO',
      statusLine: 'Registration decision available',
      target: AlertTarget.registration,
      timeLabel: 'Yesterday',
    ),
  ];

  final List<Complaint> complaints = [
    Complaint(
      ref: '#CMP-2026-4418',
      categoryId: 'pharmacy_copay',
      details:
      'Partner pharmacy asked for 40% co-pay instead of my approved 20% chronic care tier on Transaction #TXN-9038.',
      reply:
      '"We verified #TXN-9038 and credited PKR 300 excess co-pay back to your subsidy balance. Pharmacy billing rule has been corrected."',
      replyMeta: 'Replied by: System Admin • 14 Nov 2026',
      isOpen: false,
    ),
  ];

  final Map<String, FeedbackEntry> feedback = {};

  bool get isAccountFlagged => complaints.any((c) => c.isOpen);
  int get unreadCount => alerts.where((a) => !a.isRead).length;

  void _addAlert({
    required String category,
    required String title,
    required String subtitle,
    required AlertTarget target,
    String? refId,
  }) {
    final id = _nextAlert++;
    alerts.insert(
      0,
      ActivityAlert(
        id: id,
        category: category,
        title: title,
        subtitle: subtitle,
        statusLine: 'Stored in Notification Ledger #NTF-$id',
        target: target,
        refId: refId,
      ),
    );
  }

  void addTestAlert() {
    _addAlert(
      category: 'lab',
      title: 'Sample Report Ready #LAB-$_nextAlert',
      subtitle: 'Shifa Diagnostic Lab • Verified Digital Copy',
      target: AlertTarget.feedback,
      refId: 'srv_505',
    );
    notifyListeners();
  }

  void markRead(ActivityAlert alert) {
    alert.isRead = true;
    notifyListeners();
  }

  void togglePush() {
    pushActive = !pushActive;
    notifyListeners();
  }

  Complaint submitComplaint(String categoryId, String details) {
    final complaint = Complaint(
      ref: '#CMP-2026-${_nextComplaint++}',
      categoryId: categoryId,
      details: details,
      reply:
      '"Complaint logged with System Administrator. Assigned for subsidy & service verification."',
      replyMeta: 'Queued for System Admin • Just Now',
    );
    complaints.insert(0, complaint);
    _addAlert(
      category: 'account',
      title: 'Complaint ${complaint.ref} Submitted',
      subtitle: 'Status: OPEN • Sent to System Admin',
      target: AlertTarget.complaints,
      refId: complaint.ref,
    );
    notifyListeners();
    return complaint;
  }

  /// Demo: admin ka jawab simulate karta hai.
  void resolveComplaint(Complaint complaint) {
    complaint.isOpen = false;
    complaint.reply =
    '"Your complaint has been verified and resolved. Thank you for reporting it."';
    complaint.replyMeta = 'Replied by: System Admin • Just Now';
    _addAlert(
      category: 'account',
      title: 'Complaint ${complaint.ref} Resolved',
      subtitle: 'Admin reply is now available',
      target: AlertTarget.complaints,
      refId: complaint.ref,
    );
    notifyListeners();
  }

  FeedbackEntry submitFeedback(ServiceOption service, int rating, String text) {
    final entry = FeedbackEntry('#FBK-${_nextFeedback++}', rating, text);
    feedback[service.id] = entry;
    _addAlert(
      category: 'account',
      title: 'Feedback Saved ${entry.code}',
      subtitle: '${service.provider} • $rating.0/5.0',
      target: AlertTarget.feedback,
      refId: service.id,
    );
    notifyListeners();
    return entry;
  }
}

final SupportStore store = SupportStore();

// ============================================================================
// NAVIGATION + HELPERS
// ============================================================================
void openScreen(BuildContext context, Widget screen) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
}

void showNotice(BuildContext context, String text, {Color color = kGreen}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
}

// ============================================================================
// SHARED WIDGETS
// ============================================================================
final _logoBytes = base64Decode(_kLogoBase64);

class CareGridLogo extends StatelessWidget {
  const CareGridLogo({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F9F2),
        borderRadius: BorderRadius.circular(size * 0.26),
      ),
      child: Image.memory(
        _logoBytes,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        semanticLabel: 'CareGrid logo',
      ),
    );
  }
}

/// Har screen ka same layout: header (back + logo + title) aur white sheet.
class CareGridPage extends StatelessWidget {
  const CareGridPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.caption,
    required this.child,
    this.showBack = true,
  });

  final String title;
  final String subtitle;
  final String caption;
  final Widget child;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final double textIndent = showBack ? 12 : 0;

    return Scaffold(
      backgroundColor: kGreen,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(showBack ? 8 : 20, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (showBack)
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          tooltip: 'Back',
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.chevron_left,
                              color: Colors.white, size: 28),
                        ),
                      const CareGridLogo(),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: textIndent, top: 6),
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFFD1FAE5),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: textIndent, top: 2),
                    child: Text(
                      caption,
                      style: const TextStyle(
                          color: kMintBorder, fontSize: 12.5),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                      18, 18, 18, 18 + MediaQuery.of(context).padding.bottom),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.arrow_forward,
    this.color = kGreen,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFD1D5DB),
          disabledForegroundColor: kMuted,
          elevation: 0,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14.5, fontWeight: FontWeight.bold),
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

class CareChip extends StatelessWidget {
  const CareChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : kGreen,
          ),
        ),
        selected: selected,
        showCheckmark: false,
        selectedColor: kGreen,
        backgroundColor: kMint,
        side: const BorderSide(color: kMintBorder),
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class ChipStrip extends StatelessWidget {
  const ChipStrip({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: children),
    );
  }
}

class ErrorLine extends StatelessWidget {
  const ErrorLine(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        message,
        style: const TextStyle(
            color: kRed, fontSize: 11.5, fontWeight: FontWeight.w600),
      ),
    );
  }
}

BoxDecoration boxStyle(Color fill, Color border, {double radius = 14}) {
  return BoxDecoration(
    color: fill,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: border, width: 1.2),
  );
}

InputDecoration areaDecoration(String hint, String? error) {
  OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: color, width: width),
  );

  return InputDecoration(
    filled: true,
    fillColor: const Color(0xFFFAFAFA),
    counterText: '',
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
    errorText: error,
    errorMaxLines: 3,
    contentPadding: const EdgeInsets.all(14),
    enabledBorder: border(const Color(0xFFD1D5DB), 1.1),
    focusedBorder: border(kGreen, 1.6),
    errorBorder: border(kRed, 1.3),
    focusedErrorBorder: border(kRed, 1.6),
  );
}

// ============================================================================
// SCREEN 1 (HOME): ACTIVITY NOTIFICATIONS
// ============================================================================
class ActivityNotificationsScreen extends StatefulWidget {
  const ActivityNotificationsScreen({super.key});

  @override
  State<ActivityNotificationsScreen> createState() =>
      _ActivityNotificationsScreenState();
}

class _ActivityNotificationsScreenState
    extends State<ActivityNotificationsScreen> {
  static const Map<String, String> _filters = {
    'all': 'All',
    'lab': 'Lab Appointment',
    'medicine': 'Medicine Subsidy',
    'account': 'Account Activity',
  };

  String _filter = 'all';
  int? _expandedId = 9921;

  void _openAlert(ActivityAlert alert) {
    switch (alert.target) {
      case AlertTarget.registration:
        openScreen(context, const RegistrationDecisionScreen());
        break;
      case AlertTarget.complaints:
        openScreen(context, WelfareComplaintsScreen(viewRef: alert.refId));
        break;
      case AlertTarget.feedback:
        openScreen(context, ServiceFeedbackScreen(serviceId: alert.refId));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CareGridPage(
      showBack: false,
      title: 'Activity Notifications',
      subtitle: 'Beneficiary, Sponsor, Restaurant & Provider App',
      caption: 'Targeted alerts stored in user inbox',
      child: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final visible = store.alerts
              .where((a) => _filter == 'all' || a.category == _filter)
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick access
              Row(
                children: [
                  _shortcut(Icons.assignment_turned_in, 'Registration',
                      const RegistrationDecisionScreen()),
                  const SizedBox(width: 8),
                  _shortcut(Icons.report_problem_outlined, 'Complaints',
                      const WelfareComplaintsScreen()),
                  const SizedBox(width: 8),
                  _shortcut(Icons.star_outline_rounded, 'Feedback',
                      const ServiceFeedbackScreen()),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: boxStyle(kSurface, kBorder),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active,
                        color: kAmber, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Inbox (${visible.length} Alerts) • ${store.unreadCount} Unread',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: kInk,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        store.addTestAlert();
                        setState(() {
                          _filter = 'all';
                          _expandedId = store.alerts.first.id;
                        });
                      },
                      child: const Text(
                        '+ Test Alert',
                        style: TextStyle(
                          color: kGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ChipStrip(
                children: _filters.entries
                    .map((e) => CareChip(
                  label: e.value,
                  selected: _filter == e.key,
                  onTap: () => setState(() => _filter = e.key),
                ))
                    .toList(),
              ),
              const SizedBox(height: 8),
              if (visible.isEmpty)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(20),
                  decoration: boxStyle(kSurface, kBorder),
                  child: const Text(
                    'No notifications in this category filter.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kMuted, fontSize: 13),
                  ),
                )
              else
                ...visible.map(_alertCard),
              const SizedBox(height: 4),
              PrimaryButton(
                label: 'View Registration Alerts',
                onPressed: () =>
                    openScreen(context, const RegistrationDecisionScreen()),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: store.togglePush,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: store.pushActive
                        ? const Color(0xFFDDF5E8)
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    store.pushActive
                        ? '● Push & In-App Alerts Active'
                        : '○ Push & In-App Alerts Paused',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: store.pushActive ? kGreen : kMuted,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _shortcut(IconData icon, String label, Widget screen) {
    return Expanded(
      child: InkWell(
        onTap: () => openScreen(context, screen),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: boxStyle(kMint, kMintBorder),
          child: Column(
            children: [
              Icon(icon, color: kGreen, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: kGreen,
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _alertCard(ActivityAlert alert) {
    final expanded = _expandedId == alert.id;
    final highlight = expanded || !alert.isRead;

    final String badge;
    final IconData badgeIcon;
    final Color badgeBg;
    final Color badgeFg;
    switch (alert.category) {
      case 'lab':
        badge = 'LAB APPOINTMENT';
        badgeIcon = Icons.biotech;
        badgeBg = kDarkGreen;
        badgeFg = Colors.white;
        break;
      case 'medicine':
        badge = 'MEDICINE SUBSIDY';
        badgeIcon = Icons.medication;
        badgeBg = const Color(0xFFF3F4F6);
        badgeFg = kText;
        break;
      default:
        badge = 'ACCOUNT ACTIVITY';
        badgeIcon = Icons.credit_card;
        badgeBg = kAmberBg;
        badgeFg = kAmberText;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() => _expandedId = expanded ? null : alert.id);
          store.markRead(alert);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: boxStyle(
            highlight ? kMint : kSurface,
            highlight ? kGreen : const Color(0xFFD1D5DB),
            radius: 16,
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
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(badgeIcon, color: badgeFg, size: 13),
                        const SizedBox(width: 5),
                        Text(
                          badge,
                          style: TextStyle(
                            color: badgeFg,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    alert.timeLabel,
                    style: const TextStyle(color: kMuted, fontSize: 11.5),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              Text(
                alert.title,
                style: const TextStyle(
                  color: kInk,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(alert.subtitle,
                  style: const TextStyle(color: kText, fontSize: 12.5)),
              const SizedBox(height: 6),
              Text(
                '✓ ${alert.statusLine}',
                style: const TextStyle(
                  color: kGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              if (expanded) ...[
                const Divider(color: kBorder),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Alert ID: ${alert.code} • ${alert.isRead ? "Read" : "Unread"}',
                        style: const TextStyle(
                          color: Color(0xFF065F46),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        store.markRead(alert);
                        _openAlert(alert);
                      },
                      child: const Text(
                        'Inspect Details →',
                        style: TextStyle(
                          color: kGreen,
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
      ),
    );
  }
}

// ============================================================================
// SCREEN 2: REGISTRATION DECISION
// ============================================================================
class RegistrationDecisionScreen extends StatefulWidget {
  const RegistrationDecisionScreen({super.key});

  @override
  State<RegistrationDecisionScreen> createState() =>
      _RegistrationDecisionScreenState();
}

class _RegistrationDecisionScreenState
    extends State<RegistrationDecisionScreen> {
  String _viewMode = 'both'; // 'both' | 'approved' | 'rejected'
  String _selectedCard = 'approved';

  void _openDigitalIdPass() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  CareGridLogo(size: 36),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'CareGrid Beneficiary Digital ID',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: kGreen,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Beneficiary: $kApplicantName\nPartner NGO: $kNgoName\nDigital ID: $kDigitalId\nApplication Ref: $kApprovedRef',
                style: TextStyle(fontSize: 13.5, color: kInk, height: 1.5),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(
                            const ClipboardData(text: kDigitalId));
                        Navigator.pop(sheetContext);
                        showNotice(context, 'Copied $kDigitalId to clipboard.');
                      },
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Copy ID'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showApproved = _viewMode != 'rejected';
    final showRejected = _viewMode != 'approved';
    final idEnabled = showApproved && _selectedCard == 'approved';
    final rejectedSelected = _selectedCard == 'rejected';

    return CareGridPage(
      title: 'Registration Decision',
      subtitle: 'Beneficiary Application Approval / Rejection',
      caption: 'Includes decision status & rejection reason',
      child: Column(
        children: [
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
          if (showApproved) _approvedCard(),
          if (showApproved && showRejected) const SizedBox(height: 14),
          if (showRejected) _rejectedCard(),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Open Digital ID Pass',
            onPressed: idEnabled ? _openDigitalIdPass : null,
          ),
          const SizedBox(height: 10),
          PrimaryButton(
            label: 'Need Help? Submit a Complaint',
            icon: Icons.support_agent,
            color: kDarkGreen,
            onPressed: () => openScreen(
              context,
              WelfareComplaintsScreen(
                initialCategory: 'registration',
                initialDetails:
                'I need help with my application ${rejectedSelected ? kRejectedRef : kApprovedRef}: ',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeChip(String label, String value) {
    final selected = _viewMode == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() {
          _viewMode = value;
          if (value != 'both') _selectedCard = value;
        }),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: boxStyle(selected ? kGreen : kMint,
              selected ? kGreen : kMintBorder,
              radius: 10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : kGreen,
            ),
          ),
        ),
      ),
    );
  }

  Widget _decisionBadge(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _approvedCard() {
    return InkWell(
      onTap: () => setState(() => _selectedCard = 'approved'),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: boxStyle(
            kMint, _selectedCard == 'approved' ? kGreen : kMintBorder,
            radius: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _decisionBadge('DECISION: APPROVED', Icons.check, kDarkGreen),
                const Text(
                  kDecisionDate,
                  style: TextStyle(
                    color: kGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Congratulations, $kApplicantName!',
              style: TextStyle(
                  color: kInk, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your CareGrid beneficiary registration via $kNgoName has been APPROVED.',
              style: TextStyle(color: kText, fontSize: 13, height: 1.38),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: boxStyle(Colors.white, kGreen, radius: 12),
              child: const Text(
                'Digital ID: $kDigitalId',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kDarkGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '✓ Eligible for Subsidized Meds, Labs & Food',
              style: TextStyle(
                  color: kGreen, fontWeight: FontWeight.bold, fontSize: 12.5),
            ),
            const SizedBox(height: 3),
            const Text('Application Ref: $kApprovedRef',
                style: TextStyle(color: kMuted, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _rejectedCard() {
    const rose = Color(0xFFBE123C);
    return InkWell(
      onTap: () => setState(() => _selectedCard = 'rejected'),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: boxStyle(
          const Color(0xFFFEF2F2),
          _selectedCard == 'rejected' ? kRed : const Color(0xFFFECACA),
          radius: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _decisionBadge('DECISION: REJECTED', Icons.close, kRed),
                const Text(
                  'Sample Notice',
                  style: TextStyle(
                      color: rose, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Application $kRejectedRef Declined',
              style: TextStyle(
                  color: kInk, fontWeight: FontWeight.bold, fontSize: 15.5),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your registration request could not be approved during NGO & Admin verification.',
              style: TextStyle(color: kText, fontSize: 13, height: 1.38),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: boxStyle(Colors.white, const Color(0xFFFECACA),
                  radius: 12),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DOCUMENTED REJECTION REASON:',
                    style: TextStyle(
                        color: rose, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                  SizedBox(height: 5),
                  Text(
                    kRejectionReason,
                    style: TextStyle(color: kText, fontSize: 13, height: 1.38),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Visit nearest NGO desk to re-apply with valid ID.',
              style: TextStyle(color: kMuted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SCREEN 3: WELFARE COMPLAINTS
// ============================================================================
class WelfareComplaintsScreen extends StatefulWidget {
  const WelfareComplaintsScreen({
    super.key,
    this.initialCategory,
    this.initialDetails,
    this.viewRef,
  });

  final String? initialCategory;
  final String? initialDetails;
  final String? viewRef;

  @override
  State<WelfareComplaintsScreen> createState() =>
      _WelfareComplaintsScreenState();
}

class _WelfareComplaintsScreenState extends State<WelfareComplaintsScreen> {
  static const int _minChars = 15;
  static const int _maxChars = 500;

  late final TextEditingController _details;
  late String _categoryId;
  late String _activeRef;
  String _scenario = '';

  @override
  void initState() {
    super.initState();
    _details = TextEditingController(text: widget.initialDetails ?? '');
    _categoryId = widget.initialCategory ?? kNoCategory;
    _activeRef = widget.viewRef ?? store.complaints.first.ref;
  }

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Complaint get _active => store.complaints.firstWhere(
        (c) => c.ref == _activeRef,
    orElse: () => store.complaints.first,
  );

  String? get _categoryError => _categoryId == kNoCategory
      ? 'Please choose a valid welfare service category.'
      : null;

  String? get _detailsError {
    final raw = _details.text;
    // Sirf negative number block hota hai; "co-pay" ya "TXN-9038" allowed hain.
    if (RegExp(r'(^|\s)-\s*\d').hasMatch(raw)) {
      return 'Negative values are not allowed in complaint details.';
    }
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return 'Complaint details cannot be empty or spaces only.';
    }
    if (trimmed.length < _minChars) {
      return 'Provide at least $_minChars characters (${trimmed.length}/$_minChars).';
    }
    if (trimmed == widget.initialDetails?.trim()) {
      return 'Describe your issue after the reference number.';
    }
    if (trimmed.length > _maxChars) {
      return 'Exceeds maximum limit of $_maxChars characters.';
    }
    return null;
  }

  bool get _canSubmit => _categoryError == null && _detailsError == null;

  void _applyScenario(String scenario) {
    setState(() {
      _scenario = scenario;
      switch (scenario) {
        case 'Valid Case':
          _categoryId = 'pharmacy_copay';
          _details.text =
          'Partner pharmacy asked for 40% co-pay instead of my approved 20% tier.';
          break;
        case 'Empty Details':
          _categoryId = 'pharmacy_copay';
          _details.text = '   ';
          break;
        case 'Negative Input':
          _categoryId = 'lab_delay';
          _details.text = 'Wait time was -15 minutes on booking slot.';
          break;
        case 'Unselected Category':
          _categoryId = kNoCategory;
          _details.text =
          'Unable to view my assigned food ration pickup pass for today.';
          break;
      }
    });
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final complaint =
    store.submitComplaint(_categoryId, _details.text.trim());
    setState(() {
      _activeRef = complaint.ref;
      _categoryId = kNoCategory;
      _details.clear();
      _scenario = '';
    });
    showNotice(
        context, 'Complaint submitted. Issued Reference ${complaint.ref}.');
  }

  void _rateService() {
    const serviceForCategory = {
      'pharmacy_copay': 'srv_519',
      'lab_delay': 'srv_505',
      'food_ration': 'srv_524',
    };
    openScreen(
      context,
      ServiceFeedbackScreen(
          serviceId: serviceForCategory[_active.categoryId]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pristine form par error na dikhe.
    final touched = _details.text.isNotEmpty || _scenario.isNotEmpty;
    final categoryError = touched ? _categoryError : null;
    final detailsError = touched ? _detailsError : null;

    return CareGridPage(
      title: 'Welfare Complaints',
      subtitle: 'Beneficiary Mobile App • Report Issues',
      caption: 'Unique Ref # issued & "Complaint" status set',
      child: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final active = _active;
          final flagged = store.isAccountFlagged;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('TEST SCENARIO PRESETS', style: kLabelStyle),
              ChipStrip(
                children: [
                  'Valid Case',
                  'Empty Details',
                  'Negative Input',
                  'Unselected Category',
                ]
                    .map((p) => CareChip(
                  label: p,
                  selected: _scenario == p,
                  onTap: () => _applyScenario(p),
                ))
                    .toList(),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: boxStyle(
                    flagged ? kAmberBg : kMint, flagged ? kAmber : kGreen),
                child: Text(
                  flagged
                      ? '⚠ Account Flagged: "COMPLAINT" STATUS'
                      : '✓ Account Flag Cleared: Normal Standing',
                  style: TextStyle(
                    color: flagged ? kAmberText : kGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('WELFARE SERVICE CATEGORY *', style: kLabelStyle),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: boxStyle(const Color(0xFFFAFAFA),
                    categoryError == null ? kGreen : kRed,
                    radius: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _categoryId,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    items: kComplaintCategories
                        .map((cat) => DropdownMenuItem(
                      value: cat.id,
                      child: Row(
                        children: [
                          Icon(cat.icon, color: cat.color, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              cat.label,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: kInk,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                        .toList(),
                    onChanged: (id) => setState(() {
                      _categoryId = id ?? kNoCategory;
                      _scenario = '';
                    }),
                  ),
                ),
              ),
              if (categoryError != null) ErrorLine(categoryError),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text('COMPLAINT DETAILS *', style: kLabelStyle),
                  ),
                  Text('${_details.text.trim().length}/$_maxChars',
                      style: kLabelStyle),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _details,
                maxLines: 4,
                maxLength: _maxChars,
                onChanged: (_) => setState(() => _scenario = ''),
                style: const TextStyle(color: kText, fontSize: 13.5),
                decoration: areaDecoration(
                  'Describe the issue clearly with transaction or service details...',
                  detailsError,
                ),
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                label: 'Submit Complaint & Get Ref #',
                onPressed: _canSubmit ? _submit : null,
              ),
              const SizedBox(height: 18),
              const Text('MY COMPLAINTS', style: kLabelStyle),
              ChipStrip(
                children: store.complaints
                    .map((c) => CareChip(
                  label: c.ref,
                  selected: c.ref == active.ref,
                  onTap: () => setState(() => _activeRef = c.ref),
                ))
                    .toList(),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: boxStyle(kMint, kGreen, radius: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text('ADMIN RESPONSE', style: kLabelStyle),
                        ),
                        Text(
                          'Status: ${active.isOpen ? "OPEN" : "RESOLVED"}',
                          style: TextStyle(
                            color: active.isOpen ? kAmberText : kGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your complaint: ${active.details}',
                      style: const TextStyle(color: kMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ref ${active.ref} — Official Reply:',
                      style: const TextStyle(
                        color: kInk,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      active.reply,
                      style: const TextStyle(
                          color: kText, fontSize: 13, height: 1.38),
                    ),
                    const SizedBox(height: 6),
                    Text(active.replyMeta,
                        style:
                        const TextStyle(color: kMuted, fontSize: 11.5)),
                    if (active.isOpen)
                      TextButton(
                        onPressed: () => store.resolveComplaint(active),
                        child: const Text('Demo: Admin Resolve'),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                label: 'Rate & Give Feedback',
                color: const Color(0xFF062E20),
                onPressed: _rateService,
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                label: 'Copy Reference ${active.ref}',
                icon: Icons.copy,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: active.ref));
                  showNotice(context, 'Reference ${active.ref} copied.');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================================
// SCREEN 4: SERVICE FEEDBACK
// ============================================================================
class ServiceFeedbackScreen extends StatefulWidget {
  const ServiceFeedbackScreen({super.key, this.serviceId});

  final String? serviceId;

  @override
  State<ServiceFeedbackScreen> createState() => _ServiceFeedbackScreenState();
}

class _ServiceFeedbackScreenState extends State<ServiceFeedbackScreen> {
  static const int _minChars = 10;
  static const int _maxChars = 400;

  final _comment = TextEditingController();
  late String _serviceId;
  int _rating = 0;
  String _scenario = '';

  @override
  void initState() {
    super.initState();
    _serviceId = widget.serviceId ?? kServices.first.id;
    _loadSaved();
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  ServiceOption get _service =>
      kServices.firstWhere((s) => s.id == _serviceId);

  FeedbackEntry? get _saved => store.feedback[_serviceId];

  /// Agar is service ka feedback pehle diya hai to wohi dikhao.
  void _loadSaved() {
    _rating = _saved?.rating ?? 0;
    _comment.text = _saved?.comment ?? '';
  }

  String get _ratingDescriptor {
    const labels = [
      'Select Star Rating',
      'Poor Service',
      'Below Expectations',
      'Satisfactory Service',
      'Very Good Service',
      'Excellent Service',
    ];
    return labels[_rating];
  }

  String? get _serviceError => _service.eligible
      ? null
      : 'Feedback is only enabled for verified completed services.';

  String? get _ratingError =>
      _rating < 1 ? 'Select a rating between 1 and 5 stars.' : null;

  String? get _commentError {
    final trimmed = _comment.text.trim();
    if (trimmed.isEmpty) {
      return 'Feedback cannot be empty or spaces only.';
    }
    if (trimmed.length < _minChars) {
      return 'Enter at least $_minChars characters (${trimmed.length}/$_minChars).';
    }
    return null;
  }

  bool get _canSubmit =>
      _saved == null &&
          _serviceError == null &&
          _ratingError == null &&
          _commentError == null;

  void _applyScenario(String scenario) {
    setState(() {
      _scenario = scenario;
      switch (scenario) {
        case 'Valid 5-Star':
          _serviceId = 'srv_505';
          _rating = 5;
          _comment.text =
          'Fast sample collection using my Digital ID. Suggestion: Add early 7:30 AM fasting slots.';
          break;
        case 'Low Rating (2★)':
          _serviceId = 'srv_512';
          _rating = 2;
          _comment.text =
          'Waiting time exceeded 45 minutes. Suggestion: Separate queue for elderly beneficiaries.';
          break;
        case 'Empty Text':
          _serviceId = 'srv_505';
          _rating = 4;
          _comment.text = '   ';
          break;
        case 'Zero Stars':
          _serviceId = 'srv_505';
          _rating = 0;
          _comment.text =
          'Smooth consultation and clear guidance from clinic staff.';
          break;
        case 'Ineligible Service':
          _serviceId = 'srv_524';
          _rating = 4;
          _comment.text =
          'Testing submission guard on a service not yet verified.';
          break;
      }
    });
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final entry =
    store.submitFeedback(_service, _rating, _comment.text.trim());
    setState(() => _scenario = '');
    showNotice(
      context,
      'Feedback saved (${entry.code}) for ${_service.provider} ($_rating.0/5.0).',
    );
  }

  @override
  Widget build(BuildContext context) {
    final saved = _saved;
    final serviceError = _serviceError;
    final locked = saved != null;
    final commentError =
    _comment.text.isEmpty || locked ? null : _commentError;

    return CareGridPage(
      title: 'Service Feedback',
      subtitle: 'Beneficiary Rating & Improvement Suggestions',
      caption: 'Saved on service & reviewed by Administrators',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('TEST SCENARIO PRESETS', style: kLabelStyle),
          ChipStrip(
            children: [
              'Valid 5-Star',
              'Low Rating (2★)',
              'Empty Text',
              'Zero Stars',
              'Ineligible Service',
            ]
                .map((p) => CareChip(
              label: p,
              selected: _scenario == p,
              onTap: () => _applyScenario(p),
            ))
                .toList(),
          ),
          const SizedBox(height: 12),
          const Text('SELECT COMPLETED CAREGRID SERVICE *',
              style: kLabelStyle),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: boxStyle(const Color(0xFFF3F6F4),
                serviceError == null ? kGreen : kRed),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _serviceId,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    items: kServices
                        .map((s) => DropdownMenuItem(
                      value: s.id,
                      child: Text(
                        s.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: kInk,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                        ),
                      ),
                    ))
                        .toList(),
                    onChanged: (id) {
                      if (id == null) return;
                      setState(() {
                        _serviceId = id;
                        _scenario = '';
                        _loadSaved();
                      });
                    },
                  ),
                ),
                Text(
                  'Service Record ${_service.recordCode} • ${_service.completionLabel}',
                  style: TextStyle(
                    color: _service.eligible ? kText : kRed,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (serviceError != null) ErrorLine(serviceError),
          const SizedBox(height: 16),
          const Text('RATE YOUR SERVICE EXPERIENCE *', style: kLabelStyle),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: boxStyle(kMint, kGreen),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final filled = index < _rating;
                    return IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: locked
                          ? null
                          : () => setState(() {
                        _rating = index + 1;
                        _scenario = '';
                      }),
                      icon: Icon(
                        filled
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: filled ? kAmber : const Color(0xFF9CA3AF),
                        size: 34,
                      ),
                    );
                  }),
                ),
                Text(
                  '$_rating.0 / 5.0 — $_ratingDescriptor',
                  style: const TextStyle(
                    color: kInk,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text('FEEDBACK & IMPROVEMENT SUGGESTION *',
                    style: kLabelStyle),
              ),
              Text('${_comment.text.trim().length}/$_maxChars',
                  style: kLabelStyle),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _comment,
            readOnly: locked,
            maxLines: 4,
            maxLength: _maxChars,
            onChanged: (_) => setState(() => _scenario = ''),
            style: const TextStyle(color: kText, fontSize: 13.5),
            decoration: areaDecoration(
              'Share your service experience and suggestions for improvement...',
              commentError,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: boxStyle(kAmberBg, kAmber),
            child: Text(
              'Feedback Binding & Admin Visibility:\n'
                  '• Linked to Service: ${_service.provider} (${_service.recordCode})\n'
                  '• Rating ($_rating.0/5.0) & comments stored in Feedback DB\n'
                  '✓ Visible to authorized System Administrators',
              style: const TextStyle(
                  color: kAmberText, fontSize: 12.5, height: 1.6),
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: saved != null
                ? 'Feedback Saved (${saved.code})'
                : 'Submit Service Feedback',
            icon: Icons.check,
            onPressed: _canSubmit ? _submit : null,
          ),
          const SizedBox(height: 10),
          PrimaryButton(
            label: 'Back to Notifications',
            icon: Icons.notifications,
            color: kDarkGreen,
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EMBEDDED LOGO (PNG, base64) - isay edit na karein
// ============================================================================
const String _kLogoBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAHgAAAB4CAMAAAAOusbgAAAAwFBMVEX7/vr3/fn2/vn2+/X2'
    '+/T2+/P3+vT1/Pf1+vb1+vT1+vP2+fT3+/H2+fH5/O37++L0/PT0+vP0+fX0+fP0+fL0+fDz'
    '/Pbz+/Dz+vPz+vDz+fLw/PTw+vLs/ffg/Pb3+PP0+PLy+PLz9/D599/257r5y2P5w1f3ulHb'
    '8OW96eDrx3jKyqFyybZnu6lExKo/uqPxsEnpnzHVn0JrqZs/r5oxq5Y3nos7h3gmnIgikH0g'
    'hnQahXIcemkQdGYQbWAQY1f3MXwuAAAZp0lEQVR42p2bCXvayLKGBUhCCCS070ILOAEbxonB'
    '4AU7//9f3a+qteF4zjnP7cl4kUGvqru6ti4kXfd03XXdmSzLOgZ9mU1mGBPX1T1P/7fRvB4v'
    '8ehVnvhh8Hq6Kf0/m7VXPI9+m83oukQX+Df+Az2Fzn+a0JeZ111sb+x5UWTbNl2SW2Yzqqry'
    'PMWm0dx1Ire3FkOZ8YPQnSV+Dvq1AXv0DpfAdNGTcSVJcCP6X09oRJFlRT2YXuEZvk9g/GRH'
    'URS34Jn6BSwehCbiBoy5dfUebM9mka77vlHq9kSejKbTycwzjDiyrZRurUZ4TFvB25IsclVV'
    'wZCVMMuySLNsRZlpTmQPwZ4rTyYtuFkJmoEJD/4RFyCYrZd1nAZBnq+akedBEMiFF+kWJEsj'
    'w06DKPL90Fwu181YmuYC9MhfTLRGHSYTuZN1Itg34OZP/LvnG0UxH41X291uvz80Y7/f73ar'
    'fDzSwQ1t10kyMNebzeZ+MPDr2oxiQ50Xi26aW7AQiyVm7uTmD1U1L+ZTKd/u9ocTjcd+/HPY'
    'EztIfMNNzCUzf4rxo/1O8KWpaNpEqA42gNsJhrsPwLNu2bHQ+FOd5iumtrjhODA7izMT1J+/'
    'frY8jJ8D9tpc2JDU/wpuJG5+5quKodPqenWVr/aH5+fHoaTD8fgI9DhdP/z61YMbePv9jtCK'
    'HzqOjvs63WQzUYCxM3jD24ahTDQnqyHt4XyD/QImsfe7PF5v7m+4P4n7Q4y7O5J6aVaabpia'
    '5rmdvATmh2jBepRaE6dQV7vT+fn5+WZp/wJjAJ2tv5A7LrN/EDrUtFDReoldIbGrsS3ga5FT'
    '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'
    'P4P/D3fHVKNPu17yAAAAAElFTkSuQmCC';