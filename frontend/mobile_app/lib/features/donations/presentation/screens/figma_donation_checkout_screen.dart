import 'package:flutter/material.dart';
import '../../../../core/widgets/caregrid_brand.dart';
import '../../../../app/theme/caregrid_theme.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CareGridCheckoutApp());
}

class CareGridCheckoutApp extends StatelessWidget {
  const CareGridCheckoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareGrid | Secure Checkout',
      debugShowCheckedModeBanner: false,
      theme: CareGridTheme.light,
      home: const SecureCheckoutScreen(),
    );
  }
}

class SecureCheckoutScreen extends StatefulWidget {
  const SecureCheckoutScreen({super.key});

  @override
  State<SecureCheckoutScreen> createState() => _SecureCheckoutScreenState();
}

class _SecureCheckoutScreenState extends State<SecureCheckoutScreen> {
  final List<String> _paymentMethods = [
    'Credit / Debit Card (Visa, Mastercard)',
    'Mobile Wallet (Apple Pay / Google Pay)',
    'Instant Bank Transfer / IBFT',
    'Digital Payment Gateway (Stripe / PayPal)',
  ];

  final TextEditingController _nameController =
  TextEditingController(text: 'Usman Tariq');
  final TextEditingController _cardNumberController =
  TextEditingController(text: '4532891410294481');
  final TextEditingController _expiryController =
  TextEditingController(text: '08/29');
  final TextEditingController _cvvController = TextEditingController();

  final TextEditingController _walletContactController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _gatewayEmailController = TextEditingController();

  int _selectedMethodIndex = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _walletContactController.dispose();
    _ibanController.dispose();
    _gatewayEmailController.dispose();
    super.dispose();
  }

  String _sanitizeNoNegative(String value) {
    return value.replaceAll('-', '');
  }

  String? _validateExpiry(String raw) {
    final cleaned = _sanitizeNoNegative(raw.trim());
    if (cleaned.isEmpty) {
      return 'Enter expiry as MM/YY';
    }
    final match = RegExp(r'^(\d{2})/(\d{2})$').firstMatch(cleaned);
    if (match == null) {
      return 'Use MM/YY format (e.g. 08/29)';
    }

    final int? month = int.tryParse(match.group(1)!);
    final int? twoDigitYear = int.tryParse(match.group(2)!);
    if (month == null || twoDigitYear == null || month < 1 || month > 12) {
      return 'Month must be between 01 and 12';
    }

    final int fullYear = 2000 + twoDigitYear;
    final DateTime now = DateTime.now();
    final int currentYear = now.year;
    final int currentMonth = now.month;

    if (fullYear < currentYear ||
        (fullYear == currentYear && month < currentMonth)) {
      return 'Expiry date cannot be in the past';
    }

    return null;
  }

  String? _validateCardNumber(String raw) {
    final digitsOnly = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length < 13 || digitsOnly.length > 19) {
      return 'Enter a valid 13–19 digit card number';
    }
    return null;
  }

  String? _validateCvv(String raw) {
    final digitsOnly = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length < 3 || digitsOnly.length > 4) {
      return 'CVV must be 3 or 4 digits';
    }
    return null;
  }

  String? _validateHolderName(String raw) {
    final trimmed = _sanitizeNoNegative(raw.trim());
    if (trimmed.length < 2) {
      return 'Enter account/cardholder name';
    }
    if (RegExp(r'^\d+$').hasMatch(trimmed)) {
      return 'Name cannot be numbers only';
    }
    return null;
  }

  String? _validateWalletContact(String raw) {
    final trimmed = _sanitizeNoNegative(raw.trim());
    if (trimmed.isEmpty) {
      return 'Enter wallet email or mobile number';
    }
    final isEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmed);
    final digits = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
    final isPhone = digits.length >= 10 && digits.length <= 15;
    if (!isEmail && !isPhone) {
      return 'Use valid email or 10–15 digit phone';
    }
    return null;
  }

  String? _validateIban(String raw) {
    final cleaned =
    _sanitizeNoNegative(raw.trim().toUpperCase()).replaceAll(' ', '');
    if (cleaned.length < 12 || cleaned.length > 34) {
      return 'Enter a valid IBAN / Account (12–34 chars)';
    }
    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(cleaned)) {
      return 'Only letters and numbers allowed';
    }
    return null;
  }

  String? _validateGatewayEmail(String raw) {
    final trimmed = _sanitizeNoNegative(raw.trim());
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmed)) {
      return 'Enter valid email (e.g. name@example.com)';
    }
    return null;
  }

  bool get _isCurrentMethodValid {
    switch (_selectedMethodIndex) {
      case 0:
        return _validateHolderName(_nameController.text) == null &&
            _validateCardNumber(_cardNumberController.text) == null &&
            _validateExpiry(_expiryController.text) == null &&
            _validateCvv(_cvvController.text) == null;
      case 1:
        return _validateHolderName(_nameController.text) == null &&
            _validateWalletContact(_walletContactController.text) == null;
      case 2:
        return _validateHolderName(_nameController.text) == null &&
            _validateIban(_ibanController.text) == null;
      case 3:
        return _validateGatewayEmail(_gatewayEmailController.text) == null;
      default:
        return false;
    }
  }

  void _showUiMessage(String message) {
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
    final String selectedMethod = _paymentMethods[_selectedMethodIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF155E42),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 18.0, 20.0, 18.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CareGridBrandStrip(compact: true),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => _showUiMessage('Back action (UI preview)'),
                          borderRadius: BorderRadius.circular(20),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Expanded(
                          child: Text(
                            'Secure Checkout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 34.0, top: 3.0),
                      child: Text(
                        'Select Supported Online Payment Method',
                        style: TextStyle(
                          color: Color(0xFFE5F5EE),
                          fontSize: 13.5,
                        ),
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
                      // SELECT PAYMENT METHOD
                      const Text(
                        'Select Payment Method',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF173D37),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Processed safely via External Payment Gateway',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF58746D),
                        ),
                      ),
                      const SizedBox(height: 12),

                      ...List.generate(_paymentMethods.length, (index) {
                        final bool isSelected = _selectedMethodIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            onTap: () =>
                                setState(() => _selectedMethodIndex = index),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 13,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFE5F5EE)
                                    : const Color(0xFFF7FAF8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF155E42)
                                      : const Color(0xFFDAE8E1),
                                  width: isSelected ? 1.5 : 1.1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF155E42)
                                            : const Color(0xFF58746D),
                                        width: 1.8,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Center(
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF155E42),
                                        ),
                                      ),
                                    )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _paymentMethods[index],
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? const Color(0xFF173D37)
                                            : const Color(0xFF173D37),
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

                      // DYNAMIC FIELDS BASED ON SELECTED PAYMENT METHOD
                      _buildMethodSpecificFields(),

                      const SizedBox(height: 16),

                      // TLS SECURITY BANNER
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4E2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE3A33B),
                            width: 1.1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.lock,
                              color: Color(0xFFE3A33B),
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                '256-Bit TLS Gateway • Instant Receipt Generated',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xFFAD751D),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // GENERALIZED CONFIRM & PAY BUTTON
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
                          onPressed: _isCurrentMethodValid
                              ? () => _showUiMessage(
                            'UI Preview: Confirming payment via $selectedMethod',
                          )
                              : null,
                          child: const Text(
                            'Confirm & Pay Now',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // PAY VIA EXTERNAL GATEWAY BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE3A33B),
                            foregroundColor: const Color(0xFF173D37),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _showUiMessage(
                            'UI Preview: Opening External Gateway for $selectedMethod',
                          ),
                          child: const Text(
                            'Pay via External Gateway',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
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

  Widget _buildMethodSpecificFields() {
    switch (_selectedMethodIndex) {
      case 0:
        final String? nameErr = _validateHolderName(_nameController.text);
        final String? cardErr = _validateCardNumber(_cardNumberController.text);
        final String? expErr = _validateExpiry(_expiryController.text);
        final String? cvvErr = _validateCvv(_cvvController.text);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cardholder Name',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF173D37),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              onChanged: (_) => setState(() {}),
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[-0-9]')),
              ],
              style: const TextStyle(fontSize: 14, color: Color(0xFF173D37)),
              decoration: _inputDecoration(
                hint: 'Full name on card (letters only)',
                errorText: nameErr,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Card Number',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF173D37),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAF8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: cardErr == null
                      ? const Color(0xFF155E42)
                      : const Color(0xFFBC4751),
                  width: 1.3,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(19),
                      ],
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF173D37),
                        letterSpacing: 0.6,
                      ),
                      decoration: const InputDecoration(
                        hintText: '16-digit card number (e.g. 4532891410294481)',
                        hintStyle: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF58746D),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const Text(
                    'VISA',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF155E42),
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
            if (cardErr != null) _errorText(cardErr),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Expiry Date',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF173D37),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _expiryController,
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          final cleaned = _sanitizeNoNegative(val);
                          if (cleaned != val) {
                            _expiryController.value = TextEditingValue(
                              text: cleaned,
                              selection: TextSelection.collapsed(
                                offset: cleaned.length,
                              ),
                            );
                          }
                          setState(() {});
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                          LengthLimitingTextInputFormatter(5),
                        ],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF173D37),
                        ),
                        decoration: _inputDecoration(
                          hint: 'MM/YY (e.g. 08/29)',
                          errorText: expErr,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CVV',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF173D37),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _cvvController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        onChanged: (_) => setState(() {}),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF173D37),
                        ),
                        decoration: _inputDecoration(
                          hint: '3 or 4 digits',
                          errorText: cvvErr,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );

      case 1:
        final String? nameErr = _validateHolderName(_nameController.text);
        final String? walletErr =
        _validateWalletContact(_walletContactController.text);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Wallet Holder Name',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF173D37),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              onChanged: (_) => setState(() {}),
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[-0-9]')),
              ],
              style: const TextStyle(fontSize: 14, color: Color(0xFF173D37)),
              decoration: _inputDecoration(
                hint: 'Account holder name',
                errorText: nameErr,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Wallet Email or Mobile Number',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF173D37),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _walletContactController,
              onChanged: (val) {
                final cleaned = _sanitizeNoNegative(val);
                if (cleaned != val) {
                  _walletContactController.text = cleaned;
                }
                setState(() {});
              },
              style: const TextStyle(fontSize: 14, color: Color(0xFF173D37)),
              decoration: _inputDecoration(
                hint: 'name@example.com or 03001234567',
                errorText: walletErr,
              ),
            ),
          ],
        );

      case 2:
        final String? nameErr = _validateHolderName(_nameController.text);
        final String? ibanErr = _validateIban(_ibanController.text);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Title',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF173D37),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              onChanged: (_) => setState(() {}),
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[-0-9]')),
              ],
              style: const TextStyle(fontSize: 14, color: Color(0xFF173D37)),
              decoration: _inputDecoration(
                hint: 'Bank account title',
                errorText: nameErr,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'IBAN / Account Number',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF173D37),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _ibanController,
              onChanged: (val) {
                final cleaned = _sanitizeNoNegative(val.toUpperCase());
                if (cleaned != val) {
                  _ibanController.value = TextEditingValue(
                    text: cleaned,
                    selection: TextSelection.collapsed(offset: cleaned.length),
                  );
                }
                setState(() {});
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 ]')),
                LengthLimitingTextInputFormatter(34),
              ],
              style: const TextStyle(fontSize: 14, color: Color(0xFF173D37)),
              decoration: _inputDecoration(
                hint: 'PK36MEZN0002140101234567',
                errorText: ibanErr,
              ),
            ),
          ],
        );

      case 3:
      default:
        final String? emailErr =
        _validateGatewayEmail(_gatewayEmailController.text);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gateway Account Email',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF173D37),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _gatewayEmailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (val) {
                final cleaned = _sanitizeNoNegative(val);
                if (cleaned != val) {
                  _gatewayEmailController.text = cleaned;
                }
                setState(() {});
              },
              style: const TextStyle(fontSize: 14, color: Color(0xFF173D37)),
              decoration: _inputDecoration(
                hint: 'name@example.com (PayPal / Stripe email)',
                errorText: emailErr,
              ),
            ),
          ],
        );
    }
  }

  InputDecoration _inputDecoration({
    required String hint,
    String? errorText,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF7FAF8),
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF58746D)),
      errorText: errorText,
      errorStyle: const TextStyle(fontSize: 11.5, color: Color(0xFFBC4751)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDAE8E1), width: 1.1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF155E42), width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFBC4751), width: 1.3),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFBC4751), width: 1.6),
      ),
    );
  }

  Widget _errorText(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 4),
      child: Text(
        message,
        style: const TextStyle(fontSize: 11.5, color: Color(0xFFBC4751)),
      ),
    );
  }
}