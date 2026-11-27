import 'package:flutter/material.dart';
import '../../../../app/theme/brand_tokens.dart';
import '../../../../core/widgets/caregrid_brand.dart';
import '../../../../app/theme/caregrid_theme.dart';

void main() {
  runApp(const CareGridSurplusApp());
}

class CareGridSurplusApp extends StatelessWidget {
  const CareGridSurplusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareGrid - List Surplus Food',
      debugShowCheckedModeBanner: false,
      theme: CareGridTheme.light,
      home: const ListSurplusFoodScreen(),
    );
  }
}

class ListSurplusFoodScreen extends StatefulWidget {
  const ListSurplusFoodScreen({super.key});

  @override
  State<ListSurplusFoodScreen> createState() => _ListSurplusFoodScreenState();
}

class _ListSurplusFoodScreenState extends State<ListSurplusFoodScreen> {
  final TextEditingController _foodNameController = TextEditingController(
    text: 'Chicken Pulao & Roasted Naan',
  );
  final TextEditingController _descriptionController = TextEditingController(
    text:
    'Freshly prepared lunch surplus packed in sealed food-grade foil trays. Kept in temperature-controlled warmer.',
  );
  final TextEditingController _addressController = TextEditingController(
    text: 'MM Alam Road, Gulberg III, Lahore',
  );

  final List<String> _foodTypes = [
    'Cooked Meal',
    'Bakery & Bread',
    'Fresh Produce',
    'Packaged Goods',
  ];
  final List<String> _dietaryTags = [
    '100% Halal',
    'Vegetarian',
    'Dairy-Free',
    'Nut-Free',
  ];

  String _selectedFoodType = 'Cooked Meal';
  String _selectedDietaryTag = '100% Halal';
  bool _notifyEligibleNgos = true;
  bool _isPublished = false;

  @override
  void dispose() {
    _foodNameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _foodNameController.text.trim().isNotEmpty &&
          _descriptionController.text.trim().isNotEmpty &&
          _addressController.text.trim().isNotEmpty;

  void _publishListing() {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in food name, description, and pickup address.',
          ),
          backgroundColor: CareGridPalette.danger,
        ),
      );
      return;
    }

    setState(() {
      _isPublished = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _notifyEligibleNgos
              ? 'Published "${_foodNameController.text.trim()}" & notified 6 nearby NGOs!'
              : 'Published "${_foodNameController.text.trim()}" to listings.',
        ),
        backgroundColor: CareGridPalette.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CareGridPalette.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Clean Header
            Padding(
              padding: const EdgeInsets.fromLTRB(22.0, 20.0, 22.0, 18.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CareGridBrandStrip(compact: true),
                    SizedBox(height: 10),
                    Text(
                      'List Surplus Food',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Restaurant Mobile App • Create Donation',
                      style: TextStyle(
                        color: CareGridPalette.paleMint,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Publish food details & notify nearby NGOs',
                      style: TextStyle(
                        color: CareGridPalette.mintBorder,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom White Sheet Container
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
                      // PARTNER BANNER
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: CareGridPalette.canvas,
                          border: Border.all(color: CareGridPalette.line),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.restaurant_menu,
                              color: CareGridPalette.primary,
                              size: 18,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Bundoo Khan Kitchens • Verified Partner',
                                style: TextStyle(
                                  color: CareGridPalette.ink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // SURPLUS FOOD ITEM NAME
                      const Text(
                        'SURPLUS FOOD ITEM NAME *',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: CareGridPalette.ink,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _foodNameController,
                        onChanged: (_) => setState(() => _isPublished = false),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CareGridPalette.ink,
                          fontSize: 14.5,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: CareGridPalette.primary,
                              width: 1.3,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: CareGridPalette.primaryDeep,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // FOOD TYPE & DIETARY TAG DROPDOWNS
                      const Text(
                        'FOOD TYPE & DIETARY TAG *',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: CareGridPalette.ink,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Food Type Dropdown
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: CareGridPalette.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedFoodType,
                                  isExpanded: true,
                                  dropdownColor: CareGridPalette.primary,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  items: _foodTypes.map((String type) {
                                    return DropdownMenuItem<String>(
                                      value: type,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.soup_kitchen,
                                            color: CareGridPalette.gold,
                                            size: 17,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              type,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _selectedFoodType = newValue;
                                        _isPublished = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Dietary Tag Dropdown
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: CareGridPalette.canvas,
                                border: Border.all(
                                  color: CareGridPalette.line,
                                  width: 1.2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedDietaryTag,
                                  isExpanded: true,
                                  dropdownColor: Colors.white,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: CareGridPalette.primary,
                                    size: 20,
                                  ),
                                  style: const TextStyle(
                                    color: CareGridPalette.ink,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  items: _dietaryTags.map((String tag) {
                                    return DropdownMenuItem<String>(
                                      value: tag,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.check,
                                            color: CareGridPalette.primary,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              tag,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _selectedDietaryTag = newValue;
                                        _isPublished = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // FOOD DESCRIPTION & STORAGE
                      const Text(
                        'FOOD DESCRIPTION & STORAGE *',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: CareGridPalette.ink,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 3,
                        onChanged: (_) => setState(() => _isPublished = false),
                        style: const TextStyle(
                          color: CareGridPalette.ink,
                          fontSize: 13.5,
                          height: 1.35,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: CareGridPalette.canvas,
                          contentPadding: const EdgeInsets.all(14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: CareGridPalette.line,
                              width: 1.1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: CareGridPalette.primary,
                              width: 1.6,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // RESTAURANT PICKUP ADDRESS
                      const Text(
                        'RESTAURANT PICKUP ADDRESS *',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: CareGridPalette.ink,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _addressController,
                        onChanged: (_) => setState(() => _isPublished = false),
                        style: const TextStyle(
                          color: CareGridPalette.ink,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: CareGridPalette.canvas,
                          prefixIcon: const Icon(
                            Icons.location_on,
                            color: CareGridPalette.danger,
                            size: 20,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 13,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: CareGridPalette.line,
                              width: 1.1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: CareGridPalette.primary,
                              width: 1.6,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // COMMUNICATE TO ELIGIBLE NGOs TOGGLE CARD
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: CareGridPalette.paleMint,
                          border: Border.all(
                            color: CareGridPalette.mintBorder,
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.notifications_active,
                              color: CareGridPalette.gold,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Communicate to Eligible NGOs',
                                    style: TextStyle(
                                      color: CareGridPalette.primaryDeep,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _notifyEligibleNgos
                                        ? 'Auto-notifies 6 verified NGOs within 8 km'
                                        : 'NGO auto-notifications paused',
                                    style: const TextStyle(
                                      color: CareGridPalette.primary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _notifyEligibleNgos,
                              activeColor: Colors.white,
                              activeTrackColor: CareGridPalette.primary,
                              onChanged: (value) {
                                setState(() {
                                  _notifyEligibleNgos = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // VALIDATION & BROADCAST CHECKLIST CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: CareGridPalette.canvas,
                          border: Border.all(color: CareGridPalette.line),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: _isFormValid
                                      ? CareGridPalette.primary
                                      : CareGridPalette.secondaryText,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _isFormValid
                                        ? 'Food name, type & description validated'
                                        : 'Complete required fields to validate',
                                    style: TextStyle(
                                      color: _isFormValid
                                          ? CareGridPalette.primary
                                          : CareGridPalette.secondaryText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: const [
                                Icon(
                                  Icons.check,
                                  color: CareGridPalette.primary,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Listing saved & broadcast to NGOs',
                                    style: TextStyle(
                                      color: CareGridPalette.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // PUBLISH SURPLUS LISTING BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CareGridPalette.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: _publishListing,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Publish Surplus Listing',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // STATUS FOOTER BANNER
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: CareGridPalette.paleMint,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.circle,
                              color: CareGridPalette.primary,
                              size: 10,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isPublished
                                  ? 'Status: Published & Live'
                                  : 'Status: Ready to Broadcast',
                              style: const TextStyle(
                                color: CareGridPalette.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
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