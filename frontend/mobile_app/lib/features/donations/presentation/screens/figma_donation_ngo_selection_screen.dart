import 'package:flutter/material.dart';
import '../../../../app/theme/caregrid_theme.dart';

void main() {
  runApp(const CareGridDonateApp());
}

class CareGridDonateApp extends StatelessWidget {
  const CareGridDonateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareGrid | Donate',
      debugShowCheckedModeBanner: false,
      theme: CareGridTheme.light,
      home: const DonateNgoSelectionScreen(),
    );
  }
}

class NgoItem {
  final String id;
  final String name;
  final String shortName;
  final String description;
  final List<String> activeCauses;
  final String primaryCauseTag;

  const NgoItem({
    required this.id,
    required this.name,
    required this.shortName,
    required this.description,
    required this.activeCauses,
    required this.primaryCauseTag,
  });
}

class DonateNgoSelectionScreen extends StatefulWidget {
  const DonateNgoSelectionScreen({super.key});

  @override
  State<DonateNgoSelectionScreen> createState() =>
      _DonateNgoSelectionScreenState();
}

class _DonateNgoSelectionScreenState extends State<DonateNgoSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'Food Support',
    'Healthcare',
    'Education',
  ];

  final List<NgoItem> _ngos = const [
    NgoItem(
      id: 'alkhidmat',
      name: 'Al-Khidmat Care Foundation',
      shortName: 'Al-Khidmat',
      description:
      'Verified community relief organization providing emergency food rations, insulin aid & shelter.',
      activeCauses: ['Food Support', 'Healthcare', 'Education'],
      primaryCauseTag: 'Food Support',
    ),
    NgoItem(
      id: 'hope_health',
      name: 'Hope & Health Welfare Trust',
      shortName: 'Hope & Health',
      description:
      'Dedicated maternal healthcare, pediatric clinics, and school scholarship programs.',
      activeCauses: ['Healthcare', 'Education'],
      primaryCauseTag: 'Healthcare',
    ),
    NgoItem(
      id: 'rizq_edhi_care',
      name: 'Lahore Relief & Nourish Trust',
      shortName: 'Lahore Relief',
      description:
      'Daily community kitchens, clean water drives, and primary classroom support across Lahore.',
      activeCauses: ['Food Support', 'Education'],
      primaryCauseTag: 'Food Support',
    ),
  ];

  String _selectedCategory = 'Food Support';
  String _selectedNgoId = 'alkhidmat';
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<NgoItem> get _filteredNgos {
    return _ngos.where((ngo) {
      final matchesCategory = ngo.activeCauses.contains(_selectedCategory);
      final query = _searchQuery.trim().toLowerCase();
      if (query.isEmpty) return matchesCategory;
      final matchesQuery = ngo.name.toLowerCase().contains(query) ||
          ngo.description.toLowerCase().contains(query) ||
          ngo.activeCauses.any((c) => c.toLowerCase().contains(query));
      return matchesCategory && matchesQuery;
    }).toList();
  }

  NgoItem? get _selectedNgo {
    try {
      return _ngos.firstWhere((n) => n.id == _selectedNgoId);
    } catch (_) {
      return null;
    }
  }

  void _onProceed() {
    final ngo = _selectedNgo;
    if (ngo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an approved NGO to continue.'),
          backgroundColor: Color(0xFFBC4751),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected ${ngo.name} • $_selectedCategory — Choose donation amount next.',
        ),
        backgroundColor: const Color(0xFF155E42),
      ),
    );
  }

  void _showZeroFeeInfo() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.all(22.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '100% Voluntary • Zero Platform Fee',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF155E42),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'CareGrid does not deduct platform commissions from donor contributions. Every rupee you pledge goes directly toward verified welfare operations.',
                style: TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF173D37),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleNgos = _filteredNgos;

    return Scaffold(
      backgroundColor: const Color(0xFF155E42),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 18.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'CareGrid | Donate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Select Approved NGO & Welfare Cause',
                      style: TextStyle(
                        color: Color(0xFFE5F5EE),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
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
                padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SEARCH BAR
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAF8),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFDAE8E1)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (val) {
                                  setState(() => _searchQuery = val);
                                },
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: Color(0xFF173D37),
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Search registered & approved NGOs...',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF58746D),
                                    fontSize: 13,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 6),
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: const Color(0xFF155E42),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // WELFARE CATEGORIES
                      const Text(
                        'Welfare Categories',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF173D37),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: _categories.map((category) {
                          final bool isSelected = _selectedCategory == category;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: category != _categories.last ? 8 : 0,
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() => _selectedCategory = category);
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 9,
                                    horizontal: 8,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF155E42)
                                        : const Color(0xFFE5F5EE),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF155E42)
                                          : const Color(0xFFB2DFCE),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isSelected) ...[
                                        const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                      ],
                                      Flexible(
                                        child: Text(
                                          category,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : const Color(0xFF155E42),
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

                      // REGISTERED & APPROVED NGOs
                      const Text(
                        'Registered & Approved NGOs',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF173D37),
                        ),
                      ),
                      const SizedBox(height: 10),

                      if (visibleNgos.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7FAF8),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFDAE8E1)),
                          ),
                          child: const Text(
                            'No approved NGOs match your current filter.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF58746D),
                              fontSize: 13,
                            ),
                          ),
                        )
                      else
                        ...visibleNgos.map((ngo) {
                          final bool isSelected = _selectedNgoId == ngo.id;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildNgoCard(ngo, isSelected),
                          );
                        }),

                      const SizedBox(height: 6),

                      // PRIMARY ACTION BUTTON
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
                          onPressed: _onProceed,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Next: Choose Donation Amount',
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

                      // ZERO PLATFORM FEE BANNER
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: _showZeroFeeInfo,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF4E2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE3A33B),
                                width: 1.2,
                              ),
                            ),
                            child: const Text(
                              '100% Voluntary • Zero Platform Fee',
                              style: TextStyle(
                                color: Color(0xFFAD751D),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
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

  Widget _buildNgoCard(NgoItem ngo, bool isSelected) {
    final bool isAmberBadge = !isSelected && ngo.primaryCauseTag == 'Healthcare';

    return InkWell(
      onTap: () {
        setState(() => _selectedNgoId = ngo.id);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE5F5EE)
              : const Color(0xFFF7FAF8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF155E42)
                : const Color(0xFFDAE8E1),
            width: isSelected ? 1.5 : 1.1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Checkbox square
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF155E42) : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF155E42)
                          : const Color(0xFF58746D),
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 15)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    ngo.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF173D37),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF155E42)
                        : const Color(0xFFE5F5EE),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'APPROVED ✓',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF075A50),
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
                color: Color(0xFF58746D),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Active Causes:',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF173D37),
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: ngo.activeCauses.map((cause) {
                final bool highlightGreen =
                    isSelected && cause == ngo.primaryCauseTag;
                final bool highlightAmber =
                    isAmberBadge && cause == ngo.primaryCauseTag;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: highlightGreen
                        ? const Color(0xFF155E42)
                        : highlightAmber
                        ? const Color(0xFFFFF4E2)
                        : const Color(0xFFDAE8E1).withOpacity(0.75),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: highlightGreen
                          ? const Color(0xFF155E42)
                          : highlightAmber
                          ? const Color(0xFFE3A33B)
                          : const Color(0xFFDAE8E1),
                    ),
                  ),
                  child: Text(
                    cause,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: highlightGreen
                          ? Colors.white
                          : highlightAmber
                          ? const Color(0xFFAD751D)
                          : const Color(0xFF173D37),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (isSelected) ...[
              const SizedBox(height: 10),
              Text(
                'Selected: ${ngo.shortName} • $_selectedCategory',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF155E42),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}