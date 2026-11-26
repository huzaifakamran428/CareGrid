import 'package:flutter/material.dart';
import '../../../../core/widgets/caregrid_brand.dart';
import '../../../../app/theme/caregrid_theme.dart';

void main() {
  runApp(const CareGridEnterDonationApp());
}

class CareGridEnterDonationApp extends StatelessWidget {
  const CareGridEnterDonationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareGrid | Enter Donation',
      debugShowCheckedModeBanner: false,
      theme: CareGridTheme.light,
      home: const EnterDonationScreen(),
    );
  }
}

class EnterDonationScreen extends StatefulWidget {
  const EnterDonationScreen({super.key});

  @override
  State<EnterDonationScreen> createState() => _EnterDonationScreenState();
}

class _EnterDonationScreenState extends State<EnterDonationScreen> {
  final TextEditingController _amountController =
  TextEditingController(text: '50.00');

  final List<String> _currencies = ['USD', 'PKR'];
  final Map<String, List<double>> _currencyPresets = const {
    'USD': [10, 50, 100, 250],
    'PKR': [1000, 5000, 10000, 25000],
  };

  String _selectedCurrency = 'USD';
  double? _amount = 50.00;
  bool _isVolunteer = true;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String get _currencyPrefix => _selectedCurrency == 'PKR' ? 'Rs ' : '\$';

  bool get _isValidAmount => _amount != null && _amount! > 0;

  void _onCurrencyChanged(String? newCurrency) {
    if (newCurrency == null || newCurrency == _selectedCurrency) return;
    setState(() {
      _selectedCurrency = newCurrency;
      final double defaultPreset = _currencyPresets[newCurrency]![1];
      _amount = defaultPreset;
      _amountController.text = defaultPreset.toStringAsFixed(2);
    });
  }

  void _selectPreset(double value) {
    setState(() {
      _amount = value;
      _amountController.text = value.toStringAsFixed(2);
    });
  }

  void _onAmountChanged(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      setState(() => _amount = null);
      return;
    }

    if (trimmed.startsWith('-')) {
      setState(() => _amount = -1);
      return;
    }

    final cleaned = trimmed.replaceAll(RegExp(r'[^0-9.]'), '');
    final parsed = double.tryParse(cleaned);
    setState(() {
      _amount = parsed;
    });
  }

  void _showPreviewSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF155E42),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String formattedAmount =
    _isValidAmount ? _amount!.toStringAsFixed(2) : '0.00';
    final List<double> activePresets = _currencyPresets[_selectedCurrency]!;

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
                    CareGridBrandStrip(compact: true),
                    SizedBox(height: 10),
                    Text(
                      'CareGrid | Enter Donation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Associate NGO, Welfare Cause & Amount',
                      style: TextStyle(
                        color: Color(0xFFE5F5EE),
                        fontSize: 13.5,
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
                padding: const EdgeInsets.fromLTRB(18.0, 20.0, 18.0, 16.0),
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
                      // SELECTED NGO & CAUSE BANNER
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF075A50),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5F5EE),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'AK',
                                style: TextStyle(
                                  color: Color(0xFF075A50),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SELECTED NGO & CAUSE',
                                    style: TextStyle(
                                      color: Color(0xFFB2DFCE),
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Al-Khidmat Care Foundation',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Category: Food Support',
                                    style: TextStyle(
                                      color: Color(0xFFE3A33B),
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

                      // CONTRIBUTING AS
                      const Text(
                        'Contributing As:',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF173D37),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _isVolunteer = true),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: _isVolunteer
                                      ? const Color(0xFFE5F5EE)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _isVolunteer
                                        ? const Color(0xFF155E42)
                                        : const Color(0xFFDAE8E1),
                                    width: _isVolunteer ? 1.5 : 1.1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_isVolunteer) ...[
                                      const Icon(
                                        Icons.check,
                                        color: Color(0xFF155E42),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 5),
                                    ],
                                    Flexible(
                                      child: Text(
                                        'Volunteer (${_currencyPrefix}0 Fee)',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: _isVolunteer
                                              ? const Color(0xFF155E42)
                                              : const Color(0xFF58746D),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _isVolunteer = false),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: !_isVolunteer
                                      ? const Color(0xFFFFECEE)
                                      : const Color(0xFFFFECEE),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: !_isVolunteer
                                        ? const Color(0xFFBC4751)
                                        : const Color(0xFFE5A1A7),
                                    width: !_isVolunteer ? 1.5 : 1.1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (!_isVolunteer) ...[
                                      const Icon(
                                        Icons.check,
                                        color: Color(0xFFBC4751),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 5),
                                    ],
                                    const Flexible(
                                      child: Text(
                                        'Donor / Sponsor',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Color(0xFFBC4751),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
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

                      const SizedBox(height: 16),

                      // ENTER VOLUNTARY DONATION AMOUNT + CURRENCY DROPDOWN
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Enter Voluntary Donation Amount',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF173D37),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5F5EE),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF155E42),
                                width: 1.2,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCurrency,
                                isDense: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xFF155E42),
                                  size: 18,
                                ),
                                style: const TextStyle(
                                  color: Color(0xFF155E42),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.5,
                                ),
                                items: _currencies.map((String currency) {
                                  return DropdownMenuItem<String>(
                                    value: currency,
                                    child: Text(currency),
                                  );
                                }).toList(),
                                onChanged: _onCurrencyChanged,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _isValidAmount
                                ? const Color(0xFF155E42)
                                : const Color(0xFFBC4751),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _currencyPrefix,
                              style: TextStyle(
                                fontSize: _selectedCurrency == 'PKR' ? 22 : 28,
                                fontWeight: FontWeight.bold,
                                color: _isValidAmount
                                    ? const Color(0xFF173D37)
                                    : const Color(0xFFBC4751),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _amountController,
                                keyboardType:
                                const TextInputType.numberWithOptions(
                                  decimal: true,
                                  signed: false,
                                ),
                                onChanged: _onAmountChanged,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: _isValidAmount
                                      ? const Color(0xFF173D37)
                                      : const Color(0xFFBC4751),
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding:
                                  EdgeInsets.symmetric(vertical: 6),
                                ),
                              ),
                            ),
                            Text(
                              _selectedCurrency,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF173D37),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (!_isValidAmount) ...[
                        const SizedBox(height: 6),
                        const Text(
                          'Enter a positive amount greater than 0.',
                          style: TextStyle(
                            color: Color(0xFFBC4751),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),

                      // AMOUNT PRESET CHIPS
                      Row(
                        children: activePresets.map((preset) {
                          final bool isSelected =
                              _amount != null && (_amount! - preset).abs() < 0.001;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: preset != activePresets.last ? 8 : 0,
                              ),
                              child: InkWell(
                                onTap: () => _selectPreset(preset),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 11),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF155E42)
                                        : const Color(0xFFF7FAF8),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF155E42)
                                          : const Color(0xFFDAE8E1),
                                    ),
                                  ),
                                  child: Text(
                                    '$_currencyPrefix${preset.toInt()}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF173D37),
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

                      // DONATION TRANSPARENCY SUMMARY
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAF8),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFDAE8E1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Donation Transparency Summary',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF173D37),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Contribution Amount:',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: Color(0xFF58746D),
                                  ),
                                ),
                                Text(
                                  '$_currencyPrefix$formattedAmount',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF173D37),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _isVolunteer
                                      ? 'Volunteer Platform Fee:'
                                      : 'Donor Platform Fee:',
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: Color(0xFF58746D),
                                  ),
                                ),
                                Text(
                                  '${_currencyPrefix}0.00 (Free)',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF155E42),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(
                                height: 1,
                                color: Color(0xFFDAE8E1),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Going to NGO:',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF173D37),
                                  ),
                                ),
                                Text(
                                  '$_currencyPrefix$formattedAmount',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF155E42),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // PROCEED TO ONLINE PAYMENT BUTTON (Disabled on negative / zero)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF075A50),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFFDAE8E1),
                            disabledForegroundColor: const Color(0xFF58746D),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isValidAmount
                              ? () {
                            final roleLabel = _isVolunteer
                                ? 'Volunteer'
                                : 'Donor / Sponsor';
                            _showPreviewSnackBar(
                              'UI Preview: $roleLabel • $_currencyPrefix$formattedAmount $_selectedCurrency for Al-Khidmat Care Foundation.',
                            );
                          }
                              : null,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Proceed to Online Payment',
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

                      // LINKED TO BANNER BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () {
                            _showPreviewSnackBar(
                              'Linked to Al-Khidmat Care Foundation • Food Support',
                            );
                          },
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
                              'Linked to: Al-Khidmat • Food Support',
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
}