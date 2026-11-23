// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'lab_details_screen.dart';

class LabListScreen extends StatefulWidget {
  const LabListScreen({super.key});

  @override
  State<LabListScreen> createState() => _LabListScreenState();
}

class _LabListScreenState extends State<LabListScreen> {
  // ---------------------------------------------------------------------------
  // DESIGN SYSTEM COLORS (100% Consistent with Home & Profile Screens)
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
  // SEARCH & FILTER STATE
  // ---------------------------------------------------------------------------
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List _categories = [
    'All',
    'Blood Tests',
    'Diabetes',
    'Liver & Kidney',
    'Radiology',
  ];

  // ---------------------------------------------------------------------------
  // DUMMY DATA (Subsidized Labs & Tests)
  // ---------------------------------------------------------------------------
  final List _labTests = [
    {
      'testName': 'Complete Blood Count (CBC)',
      'category': 'Blood Tests',
      'labName': 'Chughtai Lab - Johar Town',
      'distance': '1.4 km away',
      'originalPrice': 1500,
      'subsidizedPrice': 300,
      'subsidyPercent': 80,
      'turnaroundTime': 'Same Day (6 Hours)',
      'slotsAvailable': 6,
      'verified': true,
    },
    {
      'testName': 'HbA1c (Glycated Hemoglobin)',
      'category': 'Diabetes',
      'labName': 'Shaukat Khanum Diagnostic Centre',
      'distance': '2.8 km away',
      'originalPrice': 2200,
      'subsidizedPrice': 440,
      'subsidyPercent': 80,
      'turnaroundTime': 'Next Day Report',
      'slotsAvailable': 4,
      'verified': true,
    },
    {
      'testName': 'Liver Function Tests (LFTs)',
      'category': 'Liver & Kidney',
      'labName': 'IDC - Islamabad Diagnostic Centre',
      'distance': '3.1 km away',
      'originalPrice': 2500,
      'subsidizedPrice': 500,
      'subsidyPercent': 80,
      'turnaroundTime': 'Same Day (8 Hours)',
      'slotsAvailable': 9,
      'verified': true,
    },
    {
      'testName': 'Renal Function Tests (RFTs)',
      'category': 'Liver & Kidney',
      'labName': 'Al-Khidmat Welfare Diagnostics',
      'distance': '0.9 km away',
      'originalPrice': 2000,
      'subsidizedPrice': 200,
      'subsidyPercent': 90,
      'turnaroundTime': 'Same Day (4 Hours)',
      'slotsAvailable': 11,
      'verified': true,
    },
    {
      'testName': 'Chest X-Ray (PA View)',
      'category': 'Radiology',
      'labName': 'Chughtai Lab - Township',
      'distance': '1.9 km away',
      'originalPrice': 1800,
      'subsidizedPrice': 360,
      'subsidyPercent': 80,
      'turnaroundTime': 'Within 2 Hours',
      'slotsAvailable': 5,
      'verified': true,
    },
  ];

  List get _filteredTests {
    return _labTests.where((item) {
      final Map test = item as Map;
      final bool matchesCategory =
          _selectedCategory == 'All' || test['category'] == _selectedCategory;
      final String q = _searchQuery.toLowerCase().trim();
      final bool matchesQuery = q.isEmpty ||
          test['testName'].toString().toLowerCase().contains(q) ||
          test['labName'].toString().toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final List visibleTests = _filteredTests;

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
                  child: Column(
                    children: [
                      // Search Bar & Category Chips
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSearchBar(),
                            const SizedBox(height: 12),
                            _buildCategoryFilterRow(),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Available Subsidized Tests (${visibleTests.length})',
                                  style: const TextStyle(
                                    color: _darkForestText,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const Text(
                                  'Sorted by Subsidy',
                                  style: TextStyle(
                                    color: _primaryGreen,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Lab Tests List
                      Expanded(
                        child: visibleTests.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 4, 16, 28),
                                itemCount: visibleTests.length,
                                itemBuilder: (context, index) {
                                  final Map test = visibleTests[index] as Map;
                                  return _buildLabTestCard(test);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _amberBadge,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'SUBSIDIZED DIAGNOSTICS',
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
                child: const Text(
                  'UP TO 90% OFF',
                  style: TextStyle(
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
            'Subsidized Lab Tests',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Compare verified partner laboratories and book appointments using your Digital ID.',
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
  // SEARCH BAR
  // ---------------------------------------------------------------------------
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _neutralBtnBorder, width: 1.2),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),
        style: const TextStyle(
          color: _darkForestText,
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Search test (e.g. CBC, HbA1c) or lab name...',
          hintStyle: const TextStyle(
            color: _mutedText,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: const Icon(Icons.search_rounded, color: _primaryGreen),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded,
                      size: 18, color: _mutedText),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CATEGORY CHIPS
  // ---------------------------------------------------------------------------
  Widget _buildCategoryFilterRow() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final String cat = _categories[index].toString();
          final bool isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? _primaryGreen : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? _primaryGreen : _neutralBtnBorder,
                  width: 1.2,
                ),
              ),
              child: Center(
                child: Text(
                  cat,
                  style: TextStyle(
                    color: isSelected ? Colors.white : _darkForestText,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LAB TEST COMPARISON CARD
  // ---------------------------------------------------------------------------
  Widget _buildLabTestCard(Map test) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _neutralBtnBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Badges: Category + Subsidy Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: _neutralBtnBg,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  test['category'].toString(),
                  style: const TextStyle(
                    color: _mutedText,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: _mintCardBg,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: _mintCardBorder, width: 1),
                ),
                child: Text(
                  '${test['subsidyPercent']}% Welfare Subsidy',
                  style: const TextStyle(
                    color: _primaryGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Test Title
          Text(
            test['testName'].toString(),
            style: const TextStyle(
              color: _darkForestText,
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),

          // Verified Lab Name & Distance
          Row(
            children: [
              const Icon(Icons.verified_rounded,
                  color: _primaryGreen, size: 15),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  '${test['labName']} • ${test['distance']}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _mutedText,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Price Comparison Box (Standard Fee vs. Beneficiary Payable)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _mintCardBg.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _mintCardBorder.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Standard Fee',
                      style: TextStyle(
                        color: _mutedText,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rs. ${test['originalPrice']}',
                      style: const TextStyle(
                        color: _mutedText,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'You Pay (Subsidized)',
                      style: TextStyle(
                        color: _primaryGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rs. ${test['subsidizedPrice']}',
                      style: const TextStyle(
                        color: _darkForestText,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Turnaround Info + Book Action Button
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test['turnaroundTime'].toString(),
                      style: const TextStyle(
                        color: _darkForestText,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${test['slotsAvailable']} slots available today',
                      style: const TextStyle(
                        color: _primaryGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => LabDetailsScreen(test: Map<String, dynamic>.from(test)),
                      ),
                    ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View & Book',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_rounded, size: 15),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY SEARCH STATE
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
                Icons.search_off_rounded,
                color: _primaryGreen,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'No Matching Lab Tests Found',
              style: TextStyle(
                color: _darkForestText,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Try searching another test name or reset your category filter.',
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