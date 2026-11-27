// CareGrid - Surplus Food Module (single file)
// Home: Manage Food Listings
// New listing: List Surplus Food -> Quantity -> Collection Deadline -> Publish
// Koi extra package ya asset setup nahi chahiye (intl bhi nahi).

import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../app/theme/caregrid_theme.dart';
import '../../../../app/theme/brand_tokens.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CareGridFoodApp());
}

// ============================================================================
// THEME
// ============================================================================
const Color kGreen = CareGridPalette.primary;
const Color kDarkGreen = CareGridPalette.primaryDeep;
const Color kMint = CareGridPalette.paleMint;
const Color kMintBorder = CareGridPalette.mintBorder;
const Color kAmber = CareGridPalette.gold;
const Color kAmberBg = CareGridPalette.goldTint;
const Color kAmberText = CareGridPalette.goldDeep;
const Color kRed = CareGridPalette.danger;
const Color kRose = CareGridPalette.danger;
const Color kRoseBg = CareGridPalette.dangerTint;
const Color kRoseBorder = CareGridPalette.dangerBorder;
const Color kInk = CareGridPalette.ink;
const Color kText = CareGridPalette.ink;
const Color kMuted = CareGridPalette.secondaryText;
const Color kBorder = CareGridPalette.line;
const Color kSurface = CareGridPalette.canvas;

const TextStyle kLabelStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.bold,
  color: kText,
  letterSpacing: 0.5,
);

const String kPartnerName = 'Bundoo Khan Kitchens';
const int kNearbyNgos = 6;

class CareGridFoodApp extends StatelessWidget {
  const CareGridFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareGrid - Surplus Food',
      debugShowCheckedModeBanner: false,
      theme: CareGridTheme.light,
      home: const ManageFoodListingsScreen(),
    );
  }
}

// ============================================================================
// DATE / TIME HELPERS
// ============================================================================
const List<String> _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];
const List<String> _weekdays = [
  'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
];

String fmtTime(DateTime d) {
  final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final minute = d.minute.toString().padLeft(2, '0');
  return '${hour.toString().padLeft(2, '0')}:$minute ${d.hour < 12 ? 'AM' : 'PM'}';
}

String fmtDate(DateTime d) =>
    '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]} ${d.year}';

String fmtDateTime(DateTime d) =>
    '${d.day} ${_months[d.month - 1]}, ${fmtTime(d)}';

bool sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

DateTime withTime(DateTime day, TimeOfDay time) =>
    DateTime(day.year, day.month, day.day, time.hour, time.minute);

/// Deadline ka time; 12:00 AM ka matlab us din ki raat (midnight) hai.
DateTime deadlineOn(DateTime day, TimeOfDay time) {
  final result = withTime(day, time);
  if (time.hour == 0 && time.minute == 0 && sameDay(result, day)) {
    return DateTime(day.year, day.month, day.day + 1);
  }
  return result;
}

String timeLeft(DateTime deadline) {
  final left = deadline.difference(DateTime.now());
  if (left.isNegative) return 'Expired';
  final days = left.inDays;
  final hours = left.inHours % 24;
  final minutes = left.inMinutes % 60;
  if (days > 0) return '${days}d ${hours}h left';
  if (hours > 0) return '${hours}h ${minutes}m left';
  return '${minutes}m left';
}

// ============================================================================
// MODELS + STORE (in-memory, app restart par reset)
// ============================================================================
enum ListingStatus { available, expired, cancelled }

class FoodDraft {
  String name = 'Chicken Pulao & Roasted Naan';
  String type = 'Cooked Meal';
  String dietaryTag = '100% Halal';
  String description =
      'Freshly prepared lunch surplus packed in sealed food-grade foil trays. Kept in temperature-controlled warmer.';
  String address = 'MM Alam Road, Gulberg III, Lahore';
  bool notifyNgos = true;

  int quantity = 65;
  String unit = 'Portions';

  late DateTime start;
  late DateTime deadline;

  FoodDraft() {
    final now = DateTime.now();
    start = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    deadline = start.add(const Duration(hours: 2));
  }
}

class FoodListing {
  FoodListing({
    required this.batch,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.start,
    required this.deadline,
    this.cancelReason,
  });

  final String batch;
  String name;
  int quantity;
  final String unit;
  final DateTime start;
  DateTime deadline;
  String? cancelReason;
  FoodDraft? source;

  ListingStatus get status {
    if (cancelReason != null) return ListingStatus.cancelled;
    if (!DateTime.now().isBefore(deadline)) return ListingStatus.expired;
    return ListingStatus.available;
  }
}

class FoodStore extends ChangeNotifier {
  FoodStore() {
    final now = DateTime.now();
    listings.addAll([
      FoodListing(
        batch: 'FD-209',
        name: 'Chicken Pulao & Roasted Naan',
        quantity: 50,
        unit: 'Portions',
        start: now.subtract(const Duration(hours: 1)),
        deadline: now.add(const Duration(hours: 5)),
      ),
      FoodListing(
        batch: 'FD-207',
        name: 'Assorted Bakery Pastries (24 Packs)',
        quantity: 24,
        unit: 'Portions',
        start: now.subtract(const Duration(days: 1, hours: 5)),
        deadline: now.subtract(const Duration(days: 1)),
        cancelReason: 'Items no longer suitable for donation',
      ),
      FoodListing(
        batch: 'FD-204',
        name: 'Lunch Biryani',
        quantity: 40,
        unit: 'Portions',
        start: now.subtract(const Duration(days: 2, hours: 4)),
        deadline: now.subtract(const Duration(days: 2)),
      ),
    ]);
  }

  final List<FoodListing> listings = [];
  final List<String> auditLog = [];
  int _nextBatch = 210;

  String get nextBatch => 'FD-$_nextBatch';

  void _log(String text) {
    auditLog.insert(0, '${fmtDateTime(DateTime.now())} • $text');
  }

  FoodListing publish(FoodDraft draft) {
    final listing = FoodListing(
      batch: 'FD-${_nextBatch++}',
      name: draft.name.trim(),
      quantity: draft.quantity,
      unit: draft.unit,
      start: draft.start,
      deadline: draft.deadline,
    )..source = draft;
    listings.insert(0, listing);
    _log('Batch #${listing.batch} published (${listing.quantity} ${listing.unit})'
        '${draft.notifyNgos ? ', $kNearbyNgos NGOs notified' : ''}');
    notifyListeners();
    return listing;
  }

  void update(FoodListing listing,
      {String? name, int? quantity, DateTime? deadline}) {
    listing.name = name ?? listing.name;
    listing.quantity = quantity ?? listing.quantity;
    listing.deadline = deadline ?? listing.deadline;
    _log('Batch #${listing.batch} updated: ${listing.quantity} ${listing.unit}, '
        'cutoff ${fmtDateTime(listing.deadline)}');
    notifyListeners();
  }

  void cancel(FoodListing listing, String reason) {
    listing.cancelReason = reason;
    _log('Batch #${listing.batch} cancelled: $reason');
    notifyListeners();
  }

  void restore(FoodListing listing) {
    listing.cancelReason = null;
    _log('Batch #${listing.batch} restored');
    notifyListeners();
  }
}

final FoodStore store = FoodStore();

// ============================================================================
// SHARED WIDGETS
// ============================================================================

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
        color: CareGridPalette.canvas,
        borderRadius: BorderRadius.circular(size * 0.26),
      ),
      child: Image.asset(
        'assets/images/caregrid_logo.png',
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        semanticLabel: 'CareGrid logo',
      ),
    );
  }
}

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
    final double indent = showBack ? 12 : 0;

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
                    padding: EdgeInsets.only(left: indent, top: 6),
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        color: CareGridPalette.paleMint,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: indent, top: 2),
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
                      18, 20, 18, 18 + MediaQuery.of(context).padding.bottom),
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
          disabledBackgroundColor: CareGridPalette.line,
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

BoxDecoration boxStyle(Color fill, Color border, {double radius = 14}) {
  return BoxDecoration(
    color: fill,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: border, width: 1.2),
  );
}

class ChoiceBox extends StatelessWidget {
  const ChoiceBox({
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: boxStyle(
            selected ? kGreen : kSurface, selected ? kGreen : kBorder,
            radius: 10),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : kText,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

/// Har step par dikhta hai ke user kahan hai.
class StepBar extends StatelessWidget {
  const StepBar(this.step, {super.key});

  final int step;

  @override
  Widget build(BuildContext context) {
    const labels = ['Details', 'Quantity', 'Deadline'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: List.generate(3, (i) {
          final done = i < step;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < 2 ? 6 : 0),
              child: Column(
                children: [
                  Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: done ? kGreen : CareGridPalette.line,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${i + 1}. ${labels[i]}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: done ? kGreen : kMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ============================================================================
// HOME: MANAGE FOOD LISTINGS
// ============================================================================
class ManageFoodListingsScreen extends StatefulWidget {
  const ManageFoodListingsScreen({super.key});

  @override
  State<ManageFoodListingsScreen> createState() =>
      _ManageFoodListingsScreenState();
}

class _ManageFoodListingsScreenState extends State<ManageFoodListingsScreen> {
  Timer? _timer;
  String? _selectedBatch;

  @override
  void initState() {
    super.initState();
    // Countdown aur auto-expiry ke liye refresh.
    _timer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Quick Update ke liye selected (ya pehli) available listing.
  FoodListing? get _quickTarget {
    final live = store.listings
        .where((l) => l.status == ListingStatus.available)
        .toList();
    if (live.isEmpty) return null;
    return live.firstWhere((l) => l.batch == _selectedBatch,
        orElse: () => live.first);
  }

  void _newListing([FoodDraft? draft]) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => ListSurplusFoodScreen(draft: draft ?? FoodDraft())),
    );
  }

  /// Expired listing ko naye time ke sath dobara list karna.
  void _relist(FoodListing listing) {
    final draft = FoodDraft()
      ..name = listing.name
      ..quantity = listing.quantity
      ..unit = listing.unit;
    final old = listing.source;
    if (old != null) {
      draft
        ..type = old.type
        ..dietaryTag = old.dietaryTag
        ..description = old.description
        ..address = old.address
        ..notifyNgos = old.notifyNgos;
    }
    _newListing(draft);
  }

  Future<void> _edit(FoodListing listing) async {
    final result = await showDialog<EditResult>(
      context: context,
      builder: (_) => EditListingDialog(listing: listing),
    );
    if (result == null || !mounted) return;
    if (listing.status != ListingStatus.available) {
      showNotice(context, 'This listing has already expired.', color: kRose);
      return;
    }
    store.update(listing,
        name: result.name,
        quantity: result.quantity,
        deadline: result.deadline);
    showNotice(context, 'Batch #${listing.batch} updated & synced with NGOs.');
  }

  Future<void> _cancel(FoodListing listing) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => CancelListingDialog(batch: listing.batch),
    );
    if (reason == null || !mounted) return;
    store.cancel(listing, reason);
    showNotice(context, 'Batch #${listing.batch} removed from NGO feed.',
        color: kRose);
  }

  void _showAuditLog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Donation History & Audit Log',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...store.listings.map(
                  (l) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Batch #${l.batch} — ${l.name}'),
                subtitle: Text(
                    'Status: ${l.status.name.toUpperCase()} • ${l.quantity} ${l.unit} • Cutoff ${fmtDateTime(l.deadline)}'),
              ),
            ),
            if (store.auditLog.isNotEmpty) const Divider(),
            ...store.auditLog.map(
                  (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(entry,
                    style: const TextStyle(fontSize: 12.5, color: kText)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CareGridPage(
      showBack: false,
      title: 'Manage Food Listings',
      subtitle: 'Edit quantity/details or cancel unavailable food',
      caption: 'Updates status & removes cancelled items',
      child: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final target = _quickTarget;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryButton(
                label: 'List New Surplus Food',
                icon: Icons.add,
                onPressed: _newListing,
              ),
              const SizedBox(height: 14),
              ...store.listings.map(_listingCard),
              if (target != null) _quickUpdate(target),
              PrimaryButton(
                label: 'View Donation History & Audit Log',
                icon: Icons.history,
                color: kDarkGreen,
                onPressed: _showAuditLog,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _listingCard(FoodListing listing) {
    final status = listing.status;
    final live = status == ListingStatus.available;
    final selected = _quickTarget?.batch == listing.batch;
    final accent = live ? kGreen : kRose;
    final canRestore = status == ListingStatus.cancelled &&
        DateTime.now().isBefore(listing.deadline);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: live
            ? () => setState(() => _selectedBatch = listing.batch)
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: boxStyle(
            live ? kMint : kRoseBg,
            live ? (selected ? kGreen : kMintBorder) : kRoseBorder,
            radius: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Batch #${listing.batch}',
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                listing.name,
                style: const TextStyle(
                  color: kInk,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Qty: ${listing.quantity} ${listing.unit} • Cutoff: ${fmtDateTime(listing.deadline)}',
                style: const TextStyle(color: kText, fontSize: 12.5),
              ),
              const SizedBox(height: 6),
              Text(
                live
                    ? '⏳ ${timeLeft(listing.deadline)} • Visible to NGOs'
                    : status == ListingStatus.cancelled
                    ? 'Reason: ${listing.cancelReason}'
                    : 'Auto-expired & hidden from NGO feed',
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              if (live) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _edit(listing),
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: kRed,
                          side: const BorderSide(color: kRed),
                        ),
                        onPressed: () => _cancel(listing),
                        icon: const Icon(Icons.close, size: 16),
                        label: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ],
              if (canRestore)
                TextButton(
                  onPressed: () => store.restore(listing),
                  child: const Text('Restore Listing'),
                ),
              if (status == ListingStatus.expired)
                TextButton(
                  onPressed: () => _relist(listing),
                  child: const Text('List Again'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickUpdate(FoodListing target) {
    Widget quickBox(String label, VoidCallback onTap) {
      return Expanded(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: boxStyle(Colors.white, kAmber, radius: 10),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: kInk, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: boxStyle(kAmberBg, kAmber, radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QUICK UPDATE • Batch #${target.batch}',
            style: const TextStyle(
                color: kAmberText, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              quickBox('Qty: ${target.quantity} ${target.unit}',
                      () => _edit(target)),
              const SizedBox(width: 10),
              quickBox('Cutoff: ${fmtTime(target.deadline)}',
                      () => _edit(target)),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '• Prevents NGOs from traveling for unavailable food',
            style: TextStyle(color: kAmberText, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// DIALOGS
// ============================================================================
class EditResult {
  const EditResult(this.name, this.quantity, this.deadline);

  final String name;
  final int quantity;
  final DateTime deadline;
}

class EditListingDialog extends StatefulWidget {
  const EditListingDialog({super.key, required this.listing});

  final FoodListing listing;

  @override
  State<EditListingDialog> createState() => _EditListingDialogState();
}

class _EditListingDialogState extends State<EditListingDialog> {
  late final TextEditingController _name;
  late final TextEditingController _qty;
  late DateTime _deadline;
  String? _error;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.listing.name);
    _qty = TextEditingController(text: '${widget.listing.quantity}');
    _deadline = widget.listing.deadline;
  }

  @override
  void dispose() {
    _name.dispose();
    _qty.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_deadline),
    );
    if (picked == null || !mounted) return;
    // 12:00 AM wali deadline pichle din ki raat mani jati hai.
    final old = widget.listing.deadline;
    final day = old.hour == 0 && old.minute == 0
        ? old.subtract(const Duration(days: 1))
        : old;
    setState(() => _deadline = deadlineOn(day, picked));
  }

  void _save() {
    final name = _name.text.trim();
    final qty = int.tryParse(_qty.text) ?? 0;
    String? error;
    if (name.isEmpty) {
      error = 'Food title cannot be empty.';
    } else if (qty <= 0) {
      error = 'Quantity must be greater than 0.';
    } else if (!_deadline.isAfter(DateTime.now()) ||
        !_deadline.isAfter(widget.listing.start)) {
      error = 'Cutoff must be after the current time and pickup start.';
    }
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.pop(context, EditResult(name, qty, _deadline));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Batch #${widget.listing.batch}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                  labelText: 'Food Item Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _qty,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: InputDecoration(
                  labelText: 'Quantity (${widget.listing.unit})',
                  border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pickTime,
              icon: const Icon(Icons.access_time),
              label: Text('Cutoff: ${fmtDateTime(_deadline)}'),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_error!,
                    style: const TextStyle(color: kRed, fontSize: 12)),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Discard'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save Changes')),
      ],
    );
  }
}

class CancelListingDialog extends StatefulWidget {
  const CancelListingDialog({super.key, required this.batch});

  final String batch;

  @override
  State<CancelListingDialog> createState() => _CancelListingDialogState();
}

class _CancelListingDialogState extends State<CancelListingDialog> {
  final _reason =
  TextEditingController(text: 'Items no longer suitable for donation');

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancel Batch #${widget.batch}?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('This will immediately hide the listing from the NGO feed.'),
          const SizedBox(height: 12),
          TextField(
            controller: _reason,
            decoration: const InputDecoration(
                labelText: 'Cancellation Reason', border: OutlineInputBorder()),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Keep Listing'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: kRed),
          onPressed: () => Navigator.pop(
            context,
            _reason.text.trim().isEmpty
                ? 'Cancelled by donor'
                : _reason.text.trim(),
          ),
          child: const Text('Confirm Cancel'),
        ),
      ],
    );
  }
}

// ============================================================================
// STEP 1: LIST SURPLUS FOOD
// ============================================================================
class ListSurplusFoodScreen extends StatefulWidget {
  const ListSurplusFoodScreen({super.key, required this.draft});

  final FoodDraft draft;

  @override
  State<ListSurplusFoodScreen> createState() => _ListSurplusFoodScreenState();
}

class _ListSurplusFoodScreenState extends State<ListSurplusFoodScreen> {
  static const _types = [
    'Cooked Meal',
    'Bakery & Bread',
    'Fresh Produce',
    'Packaged Goods',
  ];
  static const _tags = ['100% Halal', 'Vegetarian', 'Dairy-Free', 'Nut-Free'];

  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _address;

  FoodDraft get _draft => widget.draft;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: _draft.name);
    _description = TextEditingController(text: _draft.description);
    _address = TextEditingController(text: _draft.address);
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _address.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _draft.name.trim().isNotEmpty &&
          _draft.description.trim().isNotEmpty &&
          _draft.address.trim().isNotEmpty;

  Widget _field(
      String label,
      TextEditingController controller,
      ValueChanged<String> onChanged, {
        int maxLines = 1,
        IconData? icon,
      }) {
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: kLabelStyle),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            onChanged: (value) => setState(() => onChanged(value)),
            style: const TextStyle(color: kInk, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: CareGridPalette.canvas,
              prefixIcon:
              icon == null ? null : Icon(icon, color: kRed, size: 20),
              errorText:
              controller.text.trim().isEmpty ? 'This field is required' : null,
              contentPadding: const EdgeInsets.all(14),
              enabledBorder: border(CareGridPalette.line, 1.1),
              focusedBorder: border(kGreen, 1.6),
              errorBorder: border(kRed, 1.3),
              focusedErrorBorder: border(kRed, 1.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdown(
      String value, List<String> options, ValueChanged<String> onChanged) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: boxStyle(kSurface, kBorder, radius: 12),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: Colors.white,
            style: const TextStyle(
                color: kInk, fontWeight: FontWeight.bold, fontSize: 13),
            items: options
                .map((o) => DropdownMenuItem(
              value: o,
              child: Text(o, overflow: TextOverflow.ellipsis),
            ))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => onChanged(v));
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CareGridPage(
      title: 'List Surplus Food',
      subtitle: 'Restaurant Mobile App • Create Donation',
      caption: 'Publish food details & notify nearby NGOs',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepBar(1),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: boxStyle(kSurface, kBorder, radius: 12),
            child: const Row(
              children: [
                Icon(Icons.restaurant_menu, color: kGreen, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '$kPartnerName • Verified Partner',
                    style: TextStyle(
                        color: kInk,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _field('SURPLUS FOOD ITEM NAME *', _name, (v) => _draft.name = v),
          const Text('FOOD TYPE & DIETARY TAG *', style: kLabelStyle),
          const SizedBox(height: 8),
          Row(
            children: [
              _dropdown(_draft.type, _types, (v) => _draft.type = v),
              const SizedBox(width: 12),
              _dropdown(_draft.dietaryTag, _tags, (v) => _draft.dietaryTag = v),
            ],
          ),
          const SizedBox(height: 16),
          _field('FOOD DESCRIPTION & STORAGE *', _description,
                  (v) => _draft.description = v,
              maxLines: 3),
          _field('RESTAURANT PICKUP ADDRESS *', _address,
                  (v) => _draft.address = v,
              icon: Icons.location_on),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: boxStyle(kMint, kMintBorder),
            child: Row(
              children: [
                const Icon(Icons.notifications_active,
                    color: kAmber, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _draft.notifyNgos
                        ? 'Auto-notify $kNearbyNgos verified NGOs within 8 km'
                        : 'NGO auto-notifications paused',
                    style: const TextStyle(
                        color: kGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.5),
                  ),
                ),
                Switch(
                  value: _draft.notifyNgos,
                  onChanged: (v) => setState(() => _draft.notifyNgos = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            label: 'Next: Add Quantity',
            onPressed: _isValid
                ? () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) =>
                        SurplusFoodQuantityScreen(draft: _draft)),
              );
            }
                : null,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// STEP 2: QUANTITY
// ============================================================================
class SurplusFoodQuantityScreen extends StatefulWidget {
  const SurplusFoodQuantityScreen({super.key, required this.draft});

  final FoodDraft draft;

  @override
  State<SurplusFoodQuantityScreen> createState() =>
      _SurplusFoodQuantityScreenState();
}

class _SurplusFoodQuantityScreenState extends State<SurplusFoodQuantityScreen> {
  static const _units = ['Portions', 'Kg', 'Trays'];
  static const int _maxQty = 9999;

  late final TextEditingController _controller;
  bool _confirmed = false;

  FoodDraft get _draft => widget.draft;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${_draft.quantity}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setQuantity(int value) {
    setState(() {
      _draft.quantity = value.clamp(0, _maxQty).toInt();
      _controller.text = '${_draft.quantity}';
      _confirmed = false;
    });
  }

  double get _weightKg {
    if (_draft.unit == 'Kg') return _draft.quantity.toDouble();
    if (_draft.unit == 'Trays') return _draft.quantity * 4.5;
    return _draft.quantity * 0.43;
  }

  String get _transport {
    if (_draft.quantity == 0) {
      return 'Add quantity above 0 to estimate transport';
    }
    if (_weightKg <= 35) return 'Fits 1 Standard NGO Pickup Van / 2 Bikes';
    if (_weightKg <= 120) return 'Fits 1 NGO Cargo Van / Utility Vehicle';
    return 'Requires Dedicated NGO Delivery Truck';
  }

  @override
  Widget build(BuildContext context) {
    final qty = _draft.quantity;
    final hasQty = qty > 0;

    return CareGridPage(
      title: 'Surplus Food Quantity',
      subtitle: 'Specify exact portions & weight for NGOs',
      caption: 'Displayed directly on each listed food item',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepBar(2),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: boxStyle(kSurface, kBorder),
            child: Text(
              '${_draft.name}\nCategory: ${_draft.type} • Batch #${store.nextBatch}',
              style: const TextStyle(
                  color: kInk, fontWeight: FontWeight.bold, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          const Text('ENTER AVAILABLE QUANTITY *', style: kLabelStyle),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: boxStyle(kMint, kGreen),
            child: Row(
              children: [
                IconButton.outlined(
                  onPressed: hasQty ? () => _setQuantity(qty - 1) : null,
                  icon: const Icon(Icons.remove),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    onChanged: (v) => setState(() {
                      _draft.quantity = int.tryParse(v) ?? 0;
                      _confirmed = false;
                    }),
                    style: TextStyle(
                      color: hasQty ? kInk : kRed,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                      helperText: _draft.unit.toUpperCase(),
                    ),
                  ),
                ),
                IconButton.filled(
                  onPressed: qty < _maxQty ? () => _setQuantity(qty + 1) : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('MEASUREMENT UNIT *', style: kLabelStyle),
          const SizedBox(height: 8),
          Row(
            children: _units
                .map((unit) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: unit != _units.last ? 10 : 0),
                child: ChoiceBox(
                  label: unit,
                  selected: _draft.unit == unit,
                  onTap: () => setState(() {
                    _draft.unit = unit;
                    _confirmed = false;
                  }),
                ),
              ),
            ))
                .toList(),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: boxStyle(kSurface, kBorder),
            child: Text(
              'Packaging & Transport Estimate\n'
                  '• $qty ${_draft.unit} (~${_weightKg.toStringAsFixed(0)} kg)\n'
                  '• $_transport',
              style: const TextStyle(color: kText, fontSize: 12.5, height: 1.6),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: boxStyle(kAmberBg, kAmber),
            child: Text(
              'NGO LISTING PREVIEW\n${_draft.name} • Qty: $qty ${_draft.unit}',
              style: const TextStyle(
                  color: kAmberText,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.5,
                  height: 1.6),
            ),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            label:
            'Confirm Quantity ($qty ${_draft.unit})${_confirmed ? ' ✓' : ''}',
            icon: Icons.check,
            onPressed: hasQty && !_confirmed
                ? () {
              FocusScope.of(context).unfocus();
              setState(() => _confirmed = true);
            }
                : null,
          ),
          const SizedBox(height: 10),
          PrimaryButton(
            label: 'Next: Set Collection Deadline',
            color: kDarkGreen,
            onPressed: hasQty && _confirmed
                ? () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) =>
                      CollectionDeadlineScreen(draft: _draft)),
            )
                : null,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// STEP 3: COLLECTION DEADLINE + PUBLISH
// ============================================================================
class CollectionDeadlineScreen extends StatefulWidget {
  const CollectionDeadlineScreen({super.key, required this.draft});

  final FoodDraft draft;

  @override
  State<CollectionDeadlineScreen> createState() =>
      _CollectionDeadlineScreenState();
}

class _CollectionDeadlineScreenState extends State<CollectionDeadlineScreen> {
  String? _preset = '+2 Hours';
  bool _published = false;

  FoodDraft get _draft => widget.draft;

  String? get _error {
    if (!_draft.deadline.isAfter(_draft.start)) {
      return 'Deadline must be after the pickup window start.';
    }
    if (!_draft.deadline.isAfter(DateTime.now())) {
      return 'Deadline cannot be in the past.';
    }
    return null;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _draft.start.isBefore(today) ? today : _draft.start,
      firstDate: today,
      lastDate: today.add(const Duration(days: 30)),
    );
    if (picked == null || !mounted) return;
    setState(() {
      final window = _draft.deadline.difference(_draft.start);
      _draft.start =
          withTime(picked, TimeOfDay.fromDateTime(_draft.start));
      _draft.deadline = _draft.start.add(window);
    });
  }

  Future<void> _pickStart() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_draft.start),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _draft.start = withTime(_draft.start, picked);
      if (_preset != null) _applyPreset(_preset!);
    });
  }

  Future<void> _pickDeadline() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_draft.deadline),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _preset = null;
      _draft.deadline = deadlineOn(_draft.start, picked);
    });
  }

  void _applyPreset(String preset) {
    final start = _draft.start;
    _preset = preset;
    if (preset == '+1 Hour') {
      _draft.deadline = start.add(const Duration(hours: 1));
    } else if (preset == '+2 Hours') {
      _draft.deadline = start.add(const Duration(hours: 2));
    } else {
      _draft.deadline = DateTime(start.year, start.month, start.day + 1);
    }
  }

  void _publish() {
    if (_published) return;
    if (_error != null) {
      setState(() {});
      return;
    }
    _published = true;
    final listing = store.publish(_draft);
    showNotice(
      context,
      _draft.notifyNgos
          ? 'Batch #${listing.batch} published & $kNearbyNgos NGOs notified!'
          : 'Batch #${listing.batch} published to listings.',
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Widget _picker(String label, String value, IconData icon, VoidCallback onTap,
      {Color fill = Colors.white, Color border = CareGridPalette.line}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: kLabelStyle),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: boxStyle(fill, border, radius: 12),
            child: Row(
              children: [
                Icon(icon, color: kGreen, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                        color: kInk,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    final nextDay = !sameDay(_draft.start, _draft.deadline);

    return CareGridPage(
      title: 'Collection Deadline',
      subtitle: 'Set pickup date, cutoff time & auto-expiry',
      caption: 'Expired listings automatically hidden from NGOs',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepBar(3),
          _picker('AVAILABILITY DATE *', fmtDate(_draft.start),
              Icons.calendar_month, _pickDate,
              fill: kMint, border: kGreen),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _picker('PICKUP START', fmtTime(_draft.start),
                    Icons.access_time, _pickStart),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _picker(
                    'DEADLINE *${nextDay ? ' (next day)' : ''}',
                    fmtTime(_draft.deadline),
                    Icons.alarm,
                    _pickDeadline,
                    fill: kAmberBg,
                    border: error == null ? kAmber : kRed),
              ),
            ],
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(error,
                  style: const TextStyle(color: kRed, fontSize: 12)),
            ),
          const SizedBox(height: 16),
          const Text('QUICK DEADLINE PRESETS', style: kLabelStyle),
          const SizedBox(height: 10),
          Row(
            children: ['+1 Hour', '+2 Hours', 'Midnight']
                .map((p) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceBox(
                  label: p,
                  selected: _preset == p,
                  onTap: () => setState(() => _applyPreset(p)),
                ),
              ),
            ))
                .toList(),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: boxStyle(kMint, kMintBorder, radius: 12),
            child: Text(
              '⏳ ${error == null ? timeLeft(_draft.deadline) : 'Fix the deadline'}\n'
                  '• NGOs see live countdown badge on listing\n'
                  '• At ${fmtTime(_draft.deadline)}, status switches to EXPIRED\n'
                  '✓ Expired listings removed from NGO feed\n'
                  '• Ensures food safety & freshness compliance',
              style: const TextStyle(
                  color: CareGridPalette.primaryDeep, fontSize: 12.5, height: 1.6),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: boxStyle(kRoseBg, kRoseBorder, radius: 12),
            child: Text(
              'AUTO-EXPIRY GUARD\n${_draft.name} • ${_draft.quantity} ${_draft.unit}\n'
                  'Will be hidden from NGOs after ${fmtDateTime(_draft.deadline)}',
              style: const TextStyle(
                  color: kRose, fontSize: 12.5, height: 1.6),
            ),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            label: 'Publish Surplus Listing',
            icon: Icons.check,
            onPressed: error == null ? _publish : null,
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