// CareGrid - Donation Module (single file)
// Flow: Donate (NGO + cause) -> Amount -> Secure Checkout -> Success -> History
// Koi extra package ya asset setup nahi chahiye: logo isi file mein embedded hai.

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/theme/brand_tokens.dart';

void main() {
  runApp(const CareGridDonationApp());
}

// ============================================================================
// THEME COLORS
// ============================================================================
const Color kGreen = CareGridPalette.primary;
const Color kDarkGreen = CareGridPalette.primaryDeep;
const Color kMint = CareGridPalette.paleMint;
const Color kAmber = CareGridPalette.gold;
const Color kAmberBg = CareGridPalette.goldTint;
const Color kAmberText = CareGridPalette.goldDeep;
const Color kRed = CareGridPalette.danger;
const Color kInk = CareGridPalette.ink;
const Color kText = CareGridPalette.ink;
const Color kMuted = CareGridPalette.secondaryText;
const Color kBorder = CareGridPalette.line;
const Color kSurface = CareGridPalette.canvas;

// ============================================================================
// APP
// ============================================================================
class CareGridDonationApp extends StatelessWidget {
  const CareGridDonationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareGrid | Donate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kGreen),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const DonateNgoSelectionScreen(),
    );
  }
}

// ============================================================================
// MODELS + SHARED STORE
// ============================================================================
class NgoItem {
  final String id;
  final String name;
  final String shortName;
  final String initials;
  final String description;
  final List<String> activeCauses;
  final String primaryCauseTag;

  const NgoItem({
    required this.id,
    required this.name,
    required this.shortName,
    required this.initials,
    required this.description,
    required this.activeCauses,
    required this.primaryCauseTag,
  });
}

const List<String> kCategories = ['Food Support', 'Healthcare', 'Education'];

const List<NgoItem> kNgos = [
  NgoItem(
    id: 'alkhidmat',
    name: 'Al-Khidmat Care Foundation',
    shortName: 'Al-Khidmat',
    initials: 'AK',
    description:
    'Verified community relief organization providing emergency food rations, insulin aid & shelter.',
    activeCauses: ['Food Support', 'Healthcare', 'Education'],
    primaryCauseTag: 'Food Support',
  ),
  NgoItem(
    id: 'hope_health',
    name: 'Hope & Health Welfare Trust',
    shortName: 'Hope & Health',
    initials: 'HH',
    description:
    'Dedicated maternal healthcare, pediatric clinics, and school scholarship programs.',
    activeCauses: ['Healthcare', 'Education'],
    primaryCauseTag: 'Healthcare',
  ),
  NgoItem(
    id: 'rizq_edhi_care',
    name: 'Lahore Relief & Nourish Trust',
    shortName: 'Lahore Relief',
    initials: 'LR',
    description:
    'Daily community kitchens, clean water drives, and primary classroom support across Lahore.',
    activeCauses: ['Food Support', 'Education'],
    primaryCauseTag: 'Food Support',
  ),
];

/// Ek donation ka data jo screen se screen aage jata hai.
class DonationDraft {
  NgoItem? ngo;
  String category = kCategories.first;
  String currency = 'USD';
  double? amount = 50;
  bool isVolunteer = true;

  bool get hasValidAmount => amount != null && amount! > 0;
  String get roleLabel => isVolunteer ? 'Volunteer' : 'Donor / Sponsor';
}

class DonationRecord {
  final String txnId;
  final DateTime date;
  final String ngoName;
  final double amount;
  final String currency;
  final String category;
  final String paymentMethod;
  final String receiptNumber;
  final String role;

  const DonationRecord({
    required this.txnId,
    required this.date,
    required this.ngoName,
    required this.amount,
    required this.currency,
    required this.category,
    required this.paymentMethod,
    required this.receiptNumber,
    this.role = 'Volunteer',
  });
}

/// Simple in-memory store. App restart karne par naye records reset ho jate hain.
class DonationStore extends ChangeNotifier {
  final List<DonationRecord> _records = [
    DonationRecord(
      txnId: 'TXN-98412',
      date: DateTime(2026, 11, 15),
      ngoName: 'Al-Khidmat Care Foundation',
      amount: 50,
      currency: 'USD',
      category: 'Food Support',
      paymentMethod: 'Visa •••• 8914',
      receiptNumber: '#CG-R-2026-091',
    ),
    DonationRecord(
      txnId: 'TXN-97104',
      date: DateTime(2026, 11, 2),
      ngoName: 'Hope & Health Welfare Trust',
      amount: 50,
      currency: 'USD',
      category: 'Healthcare',
      paymentMethod: 'Receipt Sent',
      receiptNumber: '#CG-R-2026-074',
    ),
    DonationRecord(
      txnId: 'TXN-95820',
      date: DateTime(2026, 10, 19),
      ngoName: 'Edhi Education Initiative',
      amount: 50,
      currency: 'USD',
      category: 'Education',
      paymentMethod: 'Receipt Sent',
      receiptNumber: '#CG-R-2026-041',
    ),
  ];

  int _nextTxn = 98413;
  int _nextReceipt = 92;

  List<DonationRecord> get records => List.unmodifiable(_records);

  DonationRecord add(DonationDraft draft, String paymentMethod) {
    final now = DateTime.now();
    final record = DonationRecord(
      txnId: 'TXN-${_nextTxn++}',
      date: now,
      ngoName: draft.ngo!.name,
      amount: draft.amount!,
      currency: draft.currency,
      category: draft.category,
      paymentMethod: paymentMethod,
      receiptNumber:
      '#CG-R-${now.year}-${(_nextReceipt++).toString().padLeft(3, '0')}',
      role: draft.roleLabel,
    );
    _records.insert(0, record);
    notifyListeners();
    return record;
  }
}

final DonationStore donationStore = DonationStore();

// ============================================================================
// HELPERS
// ============================================================================
String money(String currency, double value) {
  final prefix = currency == 'PKR' ? 'Rs ' : '\$';
  return '$prefix${value.toStringAsFixed(2)}';
}

String formatDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
}

void showNotice(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: kGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
}

void openHistory(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const DonationHistoryScreen()),
  );
}

/// Pehli screen par wapas, naye (khali) donation ke sath.
void startNewDonation(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const DonateNgoSelectionScreen()),
        (route) => false,
  );
}

// ============================================================================
// SHARED WIDGETS
// ============================================================================
final Uint8List kLogoBytes = base64Decode(_kLogoBase64);

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
        kLogoBytes,
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
    required this.child,
    this.showBack = false,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool showBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (showBack)
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          tooltip: 'Back',
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 28,
                          ),
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
                      if (trailing != null) trailing!,
                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: EdgeInsets.only(left: showBack ? 12 : 0),
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFFD1FAE5),
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                clipBehavior: Clip.antiAlias,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    18,
                    20,
                    18,
                    16 + MediaQuery.of(context).padding.bottom,
                  ),
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
    this.showArrow = false,
    this.background = kDarkGreen,
    this.foreground = Colors.white,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool showArrow;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          disabledBackgroundColor: const Color(0xFFD1D5DB),
          disabledForegroundColor: const Color(0xFF6B7280),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (showArrow) ...[
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class AmberBanner extends StatelessWidget {
  const AmberBanner({super.key, required this.text, this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
        decoration: BoxDecoration(
          color: kAmberBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kAmber, width: 1.2),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: kAmberText,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  const SummaryRow(this.label, this.value, {super.key, this.strong = false});

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: strong ? 13.5 : 12.5,
              fontWeight: strong ? FontWeight.bold : FontWeight.normal,
              color: strong ? kInk : kMuted,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: strong ? 15 : 13,
                fontWeight: FontWeight.bold,
                color: strong ? kGreen : kText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration cardDecoration({bool selected = false}) {
  return BoxDecoration(
    color: selected ? kMint : kSurface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: selected ? kGreen : const Color(0xFFD1D5DB),
      width: selected ? 1.5 : 1.1,
    ),
  );
}

const TextStyle kSectionStyle = TextStyle(
  fontSize: 13.5,
  fontWeight: FontWeight.bold,
  color: kText,
);

// ============================================================================
// SCREEN 1: NGO + CAUSE SELECTION
// ============================================================================
class DonateNgoSelectionScreen extends StatefulWidget {
  const DonateNgoSelectionScreen({super.key});

  @override
  State<DonateNgoSelectionScreen> createState() =>
      _DonateNgoSelectionScreenState();
}

class _DonateNgoSelectionScreenState extends State<DonateNgoSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  final DonationDraft _draft = DonationDraft()..ngo = kNgos.first;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<NgoItem> get _visibleNgos {
    final query = _query.trim().toLowerCase();
    return kNgos.where((ngo) {
      if (!ngo.activeCauses.contains(_draft.category)) return false;
      if (query.isEmpty) return true;
      return ngo.name.toLowerCase().contains(query) ||
          ngo.description.toLowerCase().contains(query) ||
          ngo.activeCauses.any((c) => c.toLowerCase().contains(query));
    }).toList();
  }

  void _selectCategory(String category) {
    setState(() {
      _draft.category = category;
      // Agar selected NGO is cause par kaam nahi karti to selection hata do.
      if (!(_draft.ngo?.activeCauses.contains(category) ?? false)) {
        _draft.ngo = null;
      }
    });
  }

  void _proceed() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => EnterDonationScreen(draft: _draft)),
    );
  }

  void _showZeroFeeInfo() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '100% Voluntary • Zero Platform Fee',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: kGreen,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'CareGrid does not deduct platform commissions from donor contributions. Every rupee you pledge goes directly toward verified welfare operations.',
                style: TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF374151),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleNgos;
    // Search se chupi hui NGO par aage nahi ja sakte.
    final canProceed = visible.any((n) => n.id == _draft.ngo?.id);

    return CareGridPage(
      title: 'CareGrid | Donate',
      subtitle: 'Select Approved NGO & Welfare Cause',
      trailing: IconButton(
        onPressed: () => openHistory(context),
        tooltip: 'Donation History',
        icon: const Icon(Icons.history, color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _query = val),
            style: const TextStyle(fontSize: 13.5, color: kText),
            decoration: InputDecoration(
              hintText: 'Search registered & approved NGOs...',
              hintStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
              filled: true,
              fillColor: const Color(0xFFF3F6F4),
              prefixIcon: const Icon(Icons.search, color: kGreen, size: 20),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => setState(() {
                  _searchController.clear();
                  _query = '';
                }),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: kBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: kGreen, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text('Welfare Categories', style: kSectionStyle),
          const SizedBox(height: 10),
          Row(
            children: kCategories.map((category) {
              final selected = _draft.category == category;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: category != kCategories.last ? 8 : 0,
                  ),
                  child: InkWell(
                    onTap: () => _selectCategory(category),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 9,
                        horizontal: 6,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? kGreen : kMint,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? kGreen : const Color(0xFFA7F3D0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (selected) ...[
                            const Icon(Icons.check,
                                color: Colors.white, size: 14),
                            const SizedBox(width: 3),
                          ],
                          Flexible(
                            child: Text(
                              category,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: selected ? Colors.white : kGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Registered & Approved NGOs', style: kSectionStyle),
          const SizedBox(height: 10),
          if (visible.isEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(20),
              decoration: cardDecoration(),
              child: const Text(
                'No approved NGOs match your current filter.',
                textAlign: TextAlign.center,
                style: TextStyle(color: kMuted, fontSize: 13),
              ),
            )
          else
            ...visible.map(_buildNgoCard),
          const SizedBox(height: 6),
          PrimaryButton(
            label: canProceed
                ? 'Next: Choose Donation Amount'
                : 'Select an NGO to continue',
            showArrow: canProceed,
            background: kGreen,
            onPressed: canProceed ? _proceed : null,
          ),
          const SizedBox(height: 10),
          AmberBanner(
            text: '100% Voluntary • Zero Platform Fee',
            onTap: _showZeroFeeInfo,
          ),
        ],
      ),
    );
  }

  Widget _buildNgoCard(NgoItem ngo) {
    final selected = _draft.ngo?.id == ngo.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _draft.ngo = ngo),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: cardDecoration(selected: selected),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    selected ? Icons.check_box : Icons.check_box_outline_blank,
                    color: selected ? kGreen : const Color(0xFF9CA3AF),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ngo.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: kInk,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: selected ? kGreen : const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'APPROVED ✓',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color:
                        selected ? Colors.white : const Color(0xFF065F46),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                ngo.description,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: kMuted,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: ngo.activeCauses.map((cause) {
                  final active = selected && cause == _draft.category;
                  return Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: active ? kGreen : const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      cause,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: active ? Colors.white : const Color(0xFF374151),
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (selected) ...[
                const SizedBox(height: 10),
                Text(
                  'Selected: ${ngo.shortName} • ${_draft.category}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: kGreen,
                  ),
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
// SCREEN 2: ENTER DONATION AMOUNT
// ============================================================================
class EnterDonationScreen extends StatefulWidget {
  const EnterDonationScreen({super.key, required this.draft});

  final DonationDraft draft;

  @override
  State<EnterDonationScreen> createState() => _EnterDonationScreenState();
}

class _EnterDonationScreenState extends State<EnterDonationScreen> {
  static const Map<String, List<double>> _presets = {
    'USD': [10, 50, 100, 250],
    'PKR': [1000, 5000, 10000, 25000],
  };

  late final TextEditingController _amountController;

  DonationDraft get _draft => widget.draft;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: _draft.amount?.toStringAsFixed(2) ?? '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _setAmount(double value) {
    setState(() {
      _draft.amount = value;
      _amountController.text = value.toStringAsFixed(2);
    });
  }

  void _changeCurrency(String? currency) {
    if (currency == null || currency == _draft.currency) return;
    _draft.currency = currency;
    _setAmount(_presets[currency]![1]);
  }

  void _proceed() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SecureCheckoutScreen(draft: _draft)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ngo = _draft.ngo!;
    final valid = _draft.hasValidAmount;
    final total = money(_draft.currency, valid ? _draft.amount! : 0);
    final presets = _presets[_draft.currency]!;
    final amountColor = valid ? kInk : kRed;

    return CareGridPage(
      title: 'CareGrid | Enter Donation',
      subtitle: 'Associate NGO, Welfare Cause & Amount',
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected NGO banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: kDarkGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: kMint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    ngo.initials,
                    style: const TextStyle(
                      color: kDarkGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SELECTED NGO & CAUSE',
                        style: TextStyle(
                          color: Color(0xFFA7F3D0),
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ngo.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Category: ${_draft.category}',
                        style: const TextStyle(
                          color: Color(0xFFFBBF24),
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Contributing As:', style: kSectionStyle),
          const SizedBox(height: 10),
          Row(
            children: [
              _roleOption(
                label: 'Volunteer (${_draft.currency == 'PKR' ? 'Rs ' : '\$'}0 Fee)',
                value: true,
              ),
              const SizedBox(width: 12),
              _roleOption(label: 'Donor / Sponsor', value: false),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text('Enter Voluntary Donation Amount',
                    style: kSectionStyle),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: kMint,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kGreen, width: 1.2),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _draft.currency,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: kGreen, size: 18),
                    style: const TextStyle(
                      color: kGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
                    items: _presets.keys
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: _changeCurrency,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: valid ? kGreen : kRed, width: 1.5),
            ),
            child: Row(
              children: [
                Text(
                  _draft.currency == 'PKR' ? 'Rs' : '\$',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      // Sirf positive number, max 7 digits aur 2 decimals.
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final ok = RegExp(r'^\d{0,7}(\.\d{0,2})?$')
                            .hasMatch(newValue.text);
                        return ok ? newValue : oldValue;
                      }),
                    ],
                    onChanged: (raw) => setState(
                          () => _draft.amount = double.tryParse(raw),
                    ),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: amountColor,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '0.00',
                      isDense: true,
                    ),
                  ),
                ),
                Text(
                  _draft.currency,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
          if (!valid) ...[
            const SizedBox(height: 6),
            const Text(
              'Enter a positive amount greater than 0.',
              style: TextStyle(
                color: kRed,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: presets.map((preset) {
              final selected = _draft.amount == preset;
              return Expanded(
                child: Padding(
                  padding:
                  EdgeInsets.only(right: preset != presets.last ? 8 : 0),
                  child: InkWell(
                    onTap: () => _setAmount(preset),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 11, horizontal: 4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? kGreen : const Color(0xFFF3F6F4),
                        borderRadius: BorderRadius.circular(10),
                        border:
                        Border.all(color: selected ? kGreen : kBorder),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${_draft.currency == 'PKR' ? 'Rs ' : '\$'}${preset.toInt()}',
                          style: TextStyle(
                            color: selected ? Colors.white : kText,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Donation Transparency Summary',
                    style: kSectionStyle),
                const SizedBox(height: 8),
                SummaryRow('Contribution Amount:', total),
                SummaryRow(
                  _draft.isVolunteer
                      ? 'Volunteer Platform Fee:'
                      : 'Donor Platform Fee:',
                  '${money(_draft.currency, 0)} (Free)',
                ),
                const Divider(color: Color(0xFFE2E8F0)),
                SummaryRow('Total Going to NGO:', total, strong: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Proceed to Online Payment',
            showArrow: true,
            onPressed: valid ? _proceed : null,
          ),
          const SizedBox(height: 10),
          AmberBanner(
            text:
            'Linked to: ${ngo.shortName} • ${_draft.category}  (Change)',
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _roleOption({required String label, required bool value}) {
    final selected = _draft.isVolunteer == value;
    final accent = value ? kGreen : const Color(0xFFBE123C);

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _draft.isVolunteer = value),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
          decoration: BoxDecoration(
            color: selected
                ? (value ? kMint : const Color(0xFFFFF1F2))
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? accent : const Color(0xFFD1D5DB),
              width: selected ? 1.5 : 1.1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selected) ...[
                Icon(Icons.check, color: accent, size: 16),
                const SizedBox(width: 5),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? accent : kMuted,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SCREEN 3: SECURE CHECKOUT
// ============================================================================

/// Number keyboard par "/" nahi hota, is liye MM/YY khud banta hai.
class ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    var digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 4) digits = digits.substring(0, 4);
    final text = digits.length > 2
        ? '${digits.substring(0, 2)}/${digits.substring(2)}'
        : digits;
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class SecureCheckoutScreen extends StatefulWidget {
  const SecureCheckoutScreen({super.key, required this.draft});

  final DonationDraft draft;

  @override
  State<SecureCheckoutScreen> createState() => _SecureCheckoutScreenState();
}

class _SecureCheckoutScreenState extends State<SecureCheckoutScreen> {
  static const List<String> _methods = [
    'Credit / Debit Card (Visa, Mastercard)',
    'Mobile Wallet (Apple Pay / Google Pay)',
    'Instant Bank Transfer / IBFT',
    'Digital Payment Gateway (Stripe / PayPal)',
  ];

  // Demo values (testing ke liye pre-filled). CVV user khud likhega.
  final _name = TextEditingController(text: 'Usman Tariq');
  final _card = TextEditingController(text: '4532891410294481');
  final _expiry = TextEditingController(text: '08/29');
  final _cvv = TextEditingController();
  final _wallet = TextEditingController();
  final _iban = TextEditingController();
  final _email = TextEditingController();

  int _method = 0;
  bool _processing = false;

  DonationDraft get _draft => widget.draft;

  @override
  void dispose() {
    for (final c in [_name, _card, _expiry, _cvv, _wallet, _iban, _email]) {
      c.dispose();
    }
    super.dispose();
  }

  // ---------------- Validation ----------------
  String? _nameError() =>
      _name.text.trim().length < 2 ? 'Enter account/cardholder name' : null;

  String? _cardError() => _card.text.length < 13 || _card.text.length > 19
      ? 'Enter a valid 13–19 digit card number'
      : null;

  String? _expiryError() {
    final match = RegExp(r'^(\d{2})/(\d{2})$').firstMatch(_expiry.text);
    if (match == null) return 'Use MM/YY format (e.g. 08/29)';
    final month = int.parse(match.group(1)!);
    final year = 2000 + int.parse(match.group(2)!);
    if (month < 1 || month > 12) return 'Month must be between 01 and 12';
    final now = DateTime.now();
    if (year < now.year || (year == now.year && month < now.month)) {
      return 'Expiry date cannot be in the past';
    }
    return null;
  }

  String? _cvvError() =>
      _cvv.text.length < 3 ? 'CVV must be 3 or 4 digits' : null;

  bool _isEmail(String v) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);

  String? _walletError() {
    final value = _wallet.text.trim();
    final isPhone = RegExp(r'^\+?\d{10,15}$').hasMatch(value);
    return _isEmail(value) || isPhone
        ? null
        : 'Use valid email or 10–15 digit phone';
  }

  String? _ibanError() {
    final value = _iban.text.replaceAll(' ', '');
    return value.length < 12 || value.length > 34
        ? 'Enter a valid IBAN / Account (12–34 chars)'
        : null;
  }

  String? _emailError() => _isEmail(_email.text.trim())
      ? null
      : 'Enter valid email (e.g. name@example.com)';

  bool get _isValid {
    switch (_method) {
      case 0:
        return _nameError() == null &&
            _cardError() == null &&
            _expiryError() == null &&
            _cvvError() == null;
      case 1:
        return _nameError() == null && _walletError() == null;
      case 2:
        return _nameError() == null && _ibanError() == null;
      default:
        return _emailError() == null;
    }
  }

  String get _cardBrand {
    if (_card.text.startsWith('4')) return 'VISA';
    if (RegExp(r'^(5[1-5]|2[2-7])').hasMatch(_card.text)) return 'MASTERCARD';
    return 'CARD';
  }

  String get _methodSummary {
    switch (_method) {
      case 0:
        final brand = _cardBrand == 'VISA'
            ? 'Visa'
            : _cardBrand == 'MASTERCARD'
            ? 'Mastercard'
            : 'Card';
        return '$brand •••• ${_card.text.substring(_card.text.length - 4)}';
      case 1:
        return 'Mobile Wallet';
      case 2:
        return 'Bank Transfer / IBFT';
      default:
        return 'Stripe / PayPal';
    }
  }

  // ---------------- Payment (UI simulation) ----------------
  Future<void> _pay(String methodSummary) async {
    if (_processing) return;
    FocusScope.of(context).unfocus();
    setState(() => _processing = true);

    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    final record = donationStore.add(_draft, methodSummary);
    // Checkout wali screens hata do taake back se dobara payment na ho.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => PaymentSuccessScreen(record: record)),
          (route) => route.isFirst,
    );
  }

  Future<void> _payExternally() async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('External Gateway (Demo)'),
        content: Text(
          'Pay ${money(_draft.currency, _draft.amount!)} to ${_draft.ngo!.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Approve Payment'),
          ),
        ],
      ),
    );
    if (approved == true && mounted) {
      await _pay('External Gateway');
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = money(_draft.currency, _draft.amount!);

    return PopScope(
      canPop: !_processing,
      child: CareGridPage(
        title: 'Secure Checkout',
        subtitle: 'Select Supported Online Payment Method',
        showBack: true,
        child: AbsorbPointer(
          absorbing: _processing,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: cardDecoration(selected: true),
                child: Column(
                  children: [
                    SummaryRow('NGO:', _draft.ngo!.name),
                    SummaryRow('Cause:', _draft.category),
                    SummaryRow('Contributing As:', _draft.roleLabel),
                    SummaryRow('Total Payable:', total, strong: true),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Select Payment Method', style: kSectionStyle),
              const SizedBox(height: 2),
              const Text(
                'Processed safely via External Payment Gateway',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 12),
              ...List.generate(_methods.length, (index) {
                final selected = _method == index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => setState(() => _method = index),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 13),
                      decoration: cardDecoration(selected: selected),
                      child: Row(
                        children: [
                          Icon(
                            selected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color:
                            selected ? kGreen : const Color(0xFF9CA3AF),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _methods[index],
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: kText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 6),
              _buildFields(),
              const SizedBox(height: 4),
              const AmberBanner(
                text: '🔒 256-Bit TLS Gateway • Instant Receipt Generated',
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                label: _processing
                    ? 'Processing payment...'
                    : 'Confirm & Pay $total',
                onPressed: _isValid && !_processing
                    ? () => _pay(_methodSummary)
                    : null,
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                label: 'Pay via External Gateway',
                background: kAmber,
                foreground: kText,
                onPressed: _processing ? null : _payExternally,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFields() {
    final nameFormatters = <TextInputFormatter>[
      FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
    ];

    switch (_method) {
      case 0:
        return Column(
          children: [
            _field(
              label: 'Cardholder Name',
              hint: 'Full name on card',
              controller: _name,
              error: _nameError(),
              formatters: nameFormatters,
            ),
            _field(
              label: 'Card Number',
              hint: '13–19 digit card number',
              controller: _card,
              error: _cardError(),
              keyboard: TextInputType.number,
              suffix: _cardBrand,
              formatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(19),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _field(
                    label: 'Expiry Date',
                    hint: 'MM/YY',
                    controller: _expiry,
                    error: _expiryError(),
                    keyboard: TextInputType.number,
                    formatters: [ExpiryFormatter()],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    label: 'CVV',
                    hint: '3 or 4 digits',
                    controller: _cvv,
                    error: _cvvError(),
                    keyboard: TextInputType.number,
                    obscure: true,
                    formatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            _field(
              label: 'Wallet Holder Name',
              hint: 'Account holder name',
              controller: _name,
              error: _nameError(),
              formatters: nameFormatters,
            ),
            _field(
              label: 'Wallet Email or Mobile Number',
              hint: 'name@example.com or 03001234567',
              controller: _wallet,
              error: _walletError(),
              keyboard: TextInputType.emailAddress,
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            _field(
              label: 'Account Title',
              hint: 'Bank account title',
              controller: _name,
              error: _nameError(),
              formatters: nameFormatters,
            ),
            _field(
              label: 'IBAN / Account Number',
              hint: 'PK36MEZN0002140101234567',
              controller: _iban,
              error: _ibanError(),
              formatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 ]')),
                LengthLimitingTextInputFormatter(34),
                UpperCaseFormatter(),
              ],
            ),
          ],
        );
      default:
        return _field(
          label: 'Gateway Account Email',
          hint: 'name@example.com',
          controller: _email,
          error: _emailError(),
          keyboard: TextInputType.emailAddress,
        );
    }
  }

  Widget _field({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String? error,
    TextInputType? keyboard,
    List<TextInputFormatter>? formatters,
    String? suffix,
    bool obscure = false,
  }) {
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: kSectionStyle),
          const SizedBox(height: 8),
          TextField(
            key: ValueKey(label),
            controller: controller,
            keyboardType: keyboard,
            inputFormatters: formatters,
            obscureText: obscure,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(fontSize: 14, color: kInk),
            decoration: InputDecoration(
              filled: true,
              fillColor: kSurface,
              hintText: hint,
              hintStyle:
              const TextStyle(fontSize: 12.5, color: Color(0xFF9CA3AF)),
              // Error sirf tab dikhe jab user kuch likh chuka ho.
              errorText: controller.text.isEmpty ? null : error,
              errorMaxLines: 2,
              suffixText: suffix,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              enabledBorder: border(kBorder, 1.1),
              focusedBorder: border(kGreen, 1.6),
              errorBorder: border(kRed, 1.3),
              focusedErrorBorder: border(kRed, 1.6),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SCREEN 4: PAYMENT SUCCESS (new)
// ============================================================================
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key, required this.record});

  final DonationRecord record;

  @override
  Widget build(BuildContext context) {
    return CareGridPage(
      title: 'Donation Successful',
      subtitle: 'Your receipt has been generated',
      child: Column(
        children: [
          const CircleAvatar(
            radius: 38,
            backgroundColor: kMint,
            child: Icon(Icons.check_circle, color: kGreen, size: 52),
          ),
          const SizedBox(height: 12),
          const Text(
            'Thank you for your contribution!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: kInk,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            money(record.currency, record.amount),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: kDarkGreen,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: cardDecoration(),
            child: Column(
              children: [
                SummaryRow('Receipt No:', record.receiptNumber),
                SummaryRow('Transaction ID:', record.txnId),
                SummaryRow('Date:', formatDate(record.date)),
                SummaryRow('NGO:', record.ngoName),
                SummaryRow('Cause:', record.category),
                SummaryRow('Contributed As:', record.role),
                SummaryRow('Paid Via:', record.paymentMethod),
                SummaryRow('Platform Fee:', money(record.currency, 0)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'View Donation History',
            showArrow: true,
            onPressed: () => openHistory(context),
          ),
          const SizedBox(height: 10),
          AmberBanner(
            text: '+ Make Another Voluntary Donation',
            onTap: () => startNewDonation(context),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SCREEN 5: DONATION HISTORY
// ============================================================================
class DonationHistoryScreen extends StatefulWidget {
  const DonationHistoryScreen({super.key});

  @override
  State<DonationHistoryScreen> createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen> {
  String? _selectedTxnId = donationStore.records.first.txnId;

  /// USD aur PKR ko alag alag jama karta hai.
  String _totalText(List<DonationRecord> records) {
    final totals = <String, double>{};
    for (final r in records) {
      totals[r.currency] = (totals[r.currency] ?? 0.0) + r.amount;
    }
    return totals.entries.map((e) => money(e.key, e.value)).join('  +  ');
  }

  void _openReceipt(DonationRecord record) {
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
              Row(
                children: [
                  const CareGridLogo(size: 36),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Receipt ${record.receiptNumber}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kGreen,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SummaryRow('NGO:', record.ngoName),
              SummaryRow('Transaction ID:', record.txnId),
              SummaryRow('Date:', formatDate(record.date)),
              SummaryRow('Category:', record.category),
              SummaryRow('Platform Fee:', money(record.currency, 0)),
              SummaryRow('Amount:', money(record.currency, record.amount),
                  strong: true),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Save PDF Copy',
                onPressed: () {
                  Navigator.pop(sheetContext);
                  showNotice(
                    context,
                    'UI Preview: Downloaded ${record.receiptNumber}.pdf',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CareGridPage(
      title: 'Donation History',
      subtitle: 'Past Contributions & Payment Receipts',
      showBack: true,
      child: ListenableBuilder(
        listenable: donationStore,
        builder: (context, _) {
          final records = donationStore.records;
          final total = _totalText(records);

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: kAmberBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kAmber, width: 1.2),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Voluntary Donations:',
                      style: TextStyle(
                        color: kAmberText,
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        total,
                        style: const TextStyle(
                          color: kDarkGreen,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '(Zero platform fees applied • ${records.length} Paid Receipts)',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF065F46),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              ...records.map(_buildCard),
              const SizedBox(height: 4),
              PrimaryButton(
                label: 'Export Annual Donation Statement',
                onPressed: () => showNotice(
                  context,
                  'UI Preview: Exporting annual donation statement ($total)...',
                ),
              ),
              const SizedBox(height: 10),
              AmberBanner(
                text: '+ Make Another Voluntary Donation',
                onTap: () => startNewDonation(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(DonationRecord record) {
    final selected = _selectedTxnId == record.txnId;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _selectedTxnId = record.txnId),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: cardDecoration(selected: selected),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${record.txnId} • ${formatDate(record.date)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: kMuted,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: selected ? kDarkGreen : const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'PAID ✓',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color:
                        selected ? Colors.white : const Color(0xFF065F46),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      record.ngoName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: kInk,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    money(record.currency, record.amount),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Category: ${record.category} • ${record.paymentMethod}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              if (selected) ...[
                const SizedBox(height: 8),
                Text(
                  '✓ Payment Confirmed • Receipt ${record.receiptNumber}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: kText,
                      side: const BorderSide(color: kDarkGreen, width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _openReceipt(record),
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text(
                      'Download Official PDF Receipt',
                      style:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
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
