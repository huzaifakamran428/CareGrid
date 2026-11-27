import 'package:flutter/material.dart';
import '../../../../app/theme/brand_tokens.dart';
import '../../../../core/widgets/caregrid_brand.dart';
import '../../../../app/theme/caregrid_theme.dart';

void main() {
  runApp(const CareGridQuantityApp());
}

class CareGridQuantityApp extends StatelessWidget {
  const CareGridQuantityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareGrid - Surplus Food Quantity',
      debugShowCheckedModeBanner: false,
      theme: CareGridTheme.light,
      home: const SurplusFoodQuantityScreen(),
    );
  }
}

class SurplusFoodQuantityScreen extends StatefulWidget {
  const SurplusFoodQuantityScreen({super.key});

  @override
  State<SurplusFoodQuantityScreen> createState() =>
      _SurplusFoodQuantityScreenState();
}

class _SurplusFoodQuantityScreenState extends State<SurplusFoodQuantityScreen> {
  int _quantity = 65;
  String _selectedUnit = 'Portions';
  bool _isConfirmed = true;

  final List<String> _units = ['Portions', 'Kg / Wt', 'Trays'];

  void _decrementQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
        _isConfirmed = false;
      });
    }
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      _isConfirmed = false;
    });
  }

  void _selectUnit(String unit) {
    setState(() {
      _selectedUnit = unit;
      _isConfirmed = false;
    });
  }

  String get _unitLabel {
    switch (_selectedUnit) {
      case 'Kg / Wt':
        return 'KG';
      case 'Trays':
        return 'TRAYS';
      default:
        return 'MEAL BOXES';
    }
  }

  String get _shortUnitName {
    switch (_selectedUnit) {
      case 'Kg / Wt':
        return 'Kg';
      case 'Trays':
        return 'Trays';
      default:
        return 'Boxes';
    }
  }

  double get _estimatedWeightKg {
    if (_selectedUnit == 'Kg / Wt') {
      return _quantity.toDouble();
    } else if (_selectedUnit == 'Trays') {
      return _quantity * 4.5;
    }
    return (_quantity * 0.43);
  }

  String get _transportEstimate {
    if (_quantity == 0) {
      return 'Add quantity above 0 to estimate transport';
    }
    if (_estimatedWeightKg <= 35) {
      return 'Fits 1 Standard NGO Pickup Van / 2 Bikes';
    } else if (_estimatedWeightKg <= 120) {
      return 'Fits 1 NGO Cargo Van / Utility Vehicle';
    }
    return 'Requires Dedicated NGO Delivery Truck';
  }

  void _confirmQuantity() {
    if (_quantity <= 0) return;

    setState(() {
      _isConfirmed = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Confirmed $_quantity $_selectedUnit for Chicken Pulao & Roasted Naan.',
        ),
        backgroundColor: CareGridPalette.primary,
      ),
    );
  }

  void _onNextPressed() {
    if (_quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Quantity cannot be 0. Increase quantity before proceeding.',
          ),
          backgroundColor: CareGridPalette.danger,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Proceeding to Collection Deadline with $_quantity $_selectedUnit...',
        ),
        backgroundColor: CareGridPalette.primaryDeep,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canSend = _quantity > 0;

    return Scaffold(
      backgroundColor: CareGridPalette.primary,
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
                    CareGridBrandStrip(compact: true),
                    SizedBox(height: 10),
                    Text(
                      'Surplus Food Quantity',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Specify exact portions & weight for NGOs',
                      style: TextStyle(
                        color: CareGridPalette.paleMint,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Displayed directly on each listed food item',
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
                      // ITEM SUMMARY CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: CareGridPalette.canvas,
                          border: Border.all(color: CareGridPalette.line),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Chicken Pulao & Roasted Naan',
                              style: TextStyle(
                                color: CareGridPalette.ink,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Category: Cooked Meal • Batch #FD-209',
                              style: TextStyle(
                                color: CareGridPalette.secondaryText,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ENTER AVAILABLE QUANTITY
                      const Text(
                        'ENTER AVAILABLE QUANTITY *',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: CareGridPalette.ink,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: CareGridPalette.paleMint,
                          border: Border.all(
                            color: CareGridPalette.primary,
                            width: 1.3,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Minus Button (Disabled at 0, never negative)
                            InkWell(
                              onTap: _quantity > 0 ? _decrementQuantity : null,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: _quantity > 0
                                        ? CareGridPalette.primary
                                        : CareGridPalette.line,
                                    width: 1.4,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.remove,
                                  color: _quantity > 0
                                      ? CareGridPalette.primary
                                      : CareGridPalette.secondaryText,
                                  size: 22,
                                ),
                              ),
                            ),

                            // Quantity Number & Label
                            Column(
                              children: [
                                Text(
                                  '$_quantity',
                                  style: TextStyle(
                                    color: _quantity > 0
                                        ? CareGridPalette.ink
                                        : CareGridPalette.danger,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  _unitLabel,
                                  style: const TextStyle(
                                    color: CareGridPalette.ink,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ],
                            ),

                            // Plus Button
                            InkWell(
                              onTap: _incrementQuantity,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: CareGridPalette.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // MEASUREMENT UNIT
                      const Text(
                        'MEASUREMENT UNIT *',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: CareGridPalette.ink,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: _units.map((unit) {
                          final bool isSelected = _selectedUnit == unit;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: unit != _units.last ? 10 : 0,
                              ),
                              child: InkWell(
                                onTap: () => _selectUnit(unit),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 11),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? CareGridPalette.primary
                                        : CareGridPalette.canvas,
                                    border: Border.all(
                                      color: isSelected
                                          ? CareGridPalette.primary
                                          : CareGridPalette.line,
                                      width: 1.2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    unit,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : CareGridPalette.ink,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),

                      // PACKAGING & TRANSPORT ESTIMATE CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: CareGridPalette.canvas,
                          border: Border.all(color: CareGridPalette.line),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Packaging & Transport Estimate',
                              style: TextStyle(
                                color: CareGridPalette.ink,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '• $_quantity Individual Sealed $_selectedUnit (~${_estimatedWeightKg.toStringAsFixed(0)} kg)',
                              style: const TextStyle(
                                color: CareGridPalette.secondaryText,
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '• $_transportEstimate',
                              style: const TextStyle(
                                color: CareGridPalette.secondaryText,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // NGO LISTING QUANTITY PREVIEW CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: CareGridPalette.goldTint.withOpacity(0.55),
                          border: Border.all(
                            color: CareGridPalette.gold,
                            width: 1.1,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'NGO LISTING QUANTITY PREVIEW',
                              style: TextStyle(
                                color: CareGridPalette.goldDeep,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.5,
                                letterSpacing: 0.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: CareGridPalette.gold,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Chicken Pulao • Qty: $_quantity $_selectedUnit',
                                style: const TextStyle(
                                  color: CareGridPalette.ink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  canSend ? Icons.check : Icons.info_outline,
                                  color: canSend
                                      ? CareGridPalette.goldDeep
                                      : CareGridPalette.danger,
                                  size: 15,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    canSend
                                        ? 'Quantity is attached & visible to NGOs'
                                        : 'Quantity cannot be 0 to send/confirm',
                                    style: TextStyle(
                                      color: canSend
                                          ? CareGridPalette.goldDeep
                                          : CareGridPalette.danger,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // CONFIRM / SEND QUANTITY BUTTON (Disabled at 0)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CareGridPalette.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: CareGridPalette.line,
                            disabledForegroundColor: CareGridPalette.secondaryText,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: canSend ? _confirmQuantity : null,
                          child: Text(
                            canSend
                                ? 'Confirm Quantity ($_quantity $_shortUnitName)${_isConfirmed ? ' ✓' : ''}'
                                : 'Confirm Quantity (0 $_shortUnitName)',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // NEXT BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: canSend
                                ? CareGridPalette.primaryDeep
                                : CareGridPalette.line,
                            foregroundColor: canSend
                                ? Colors.white
                                : CareGridPalette.secondaryText,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _onNextPressed,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Next: Set Collection Deadline',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.arrow_forward, size: 16),
                            ],
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
}