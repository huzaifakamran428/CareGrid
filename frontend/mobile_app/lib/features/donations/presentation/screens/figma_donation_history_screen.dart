import 'package:flutter/material.dart';
import '../../../../core/widgets/caregrid_brand.dart';
import '../../../../app/theme/caregrid_theme.dart';

void main() {
  runApp(const CareGridHistoryApp());
}

class CareGridHistoryApp extends StatelessWidget {
  const CareGridHistoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareGrid | Donation History',
      debugShowCheckedModeBanner: false,
      theme: CareGridTheme.light,
      home: const DonationHistoryScreen(),
    );
  }
}

class DonationReceiptRecord {
  final String txnId;
  final String dateLabel;
  final String ngoName;
  final double amount;
  final String category;
  final String paymentMethodDetail;
  final String receiptNumber;
  final bool isFeatured;
  final bool showReceiptSentText;

  const DonationReceiptRecord({
    required this.txnId,
    required this.dateLabel,
    required this.ngoName,
    required this.amount,
    required this.category,
    required this.paymentMethodDetail,
    required this.receiptNumber,
    this.isFeatured = false,
    this.showReceiptSentText = false,
  });
}

class DonationHistoryScreen extends StatefulWidget {
  const DonationHistoryScreen({super.key});

  @override
  State<DonationHistoryScreen> createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen> {
  final List<DonationReceiptRecord> _records = const [
    DonationReceiptRecord(
      txnId: 'TXN-98412',
      dateLabel: '15 Nov 2026',
      ngoName: 'Al-Khidmat Care Foundation',
      amount: 50.00,
      category: 'Food Support',
      paymentMethodDetail: 'Visa •••• 8914',
      receiptNumber: '#CG-R-2026-091',
      isFeatured: true,
    ),
    DonationReceiptRecord(
      txnId: 'TXN-97104',
      dateLabel: '02 Nov 2026',
      ngoName: 'Hope & Health Welfare Trust',
      amount: 50.00,
      category: 'Healthcare',
      paymentMethodDetail: 'Receipt Sent',
      receiptNumber: '#CG-R-2026-074',
      showReceiptSentText: true,
    ),
    DonationReceiptRecord(
      txnId: 'TXN-95820',
      dateLabel: '19 Oct 2026',
      ngoName: 'Edhi Education Initiative',
      amount: 50.00,
      category: 'Education',
      paymentMethodDetail: 'Receipt ${'#CG-R-2026-041'}',
      receiptNumber: '#CG-R-2026-041',
    ),
  ];

  String? _selectedTxnId = 'TXN-98412';

  double get _totalAmount =>
      _records.fold(0.0, (sum, item) => sum + item.amount);

  void _showUiNotice(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: const Color(0xFF155E42),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openReceiptPreview(DonationReceiptRecord record) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Receipt ${record.receiptNumber}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF155E42),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${record.ngoName} • ${record.txnId} (${record.dateLabel})',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF173D37),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Amount: \$${record.amount.toStringAsFixed(2)} • Category: ${record.category} • Platform Fee: \$0.00',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF58746D),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF155E42),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _showUiNotice(
                      'UI Preview: Downloaded ${record.receiptNumber}.pdf',
                    );
                  },
                  child: const Text('Save PDF Copy'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String totalFormatted = _totalAmount.toStringAsFixed(2);

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
                          onTap: () => _showUiNotice('Back navigation (UI preview)'),
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
                            'Donation History',
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
                        'Past Contributions & Payment Receipts',
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
                      // TOTAL SUMMARY CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4E2),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFE3A33B),
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Total Voluntary Donations:',
                              style: TextStyle(
                                color: Color(0xFFAD751D),
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$$totalFormatted',
                              style: const TextStyle(
                                color: Color(0xFF075A50),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '(Zero platform fees applied • ${_records.length} Paid Receipts)',
                              style: const TextStyle(
                                color: Color(0xFF075A50),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // TRANSACTION CARDS
                      ..._records.map((record) {
                        final bool isSelected = _selectedTxnId == record.txnId;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildTransactionCard(record, isSelected),
                        );
                      }),

                      const SizedBox(height: 4),

                      // EXPORT ANNUAL STATEMENT BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF075A50),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _showUiNotice(
                            'UI Preview: Exporting annual donation statement (\$$totalFormatted)...',
                          ),
                          child: const Text(
                            'Export Annual Donation Statement',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // MAKE ANOTHER DONATION BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFF7FAF8),
                            foregroundColor: const Color(0xFF173D37),
                            side: const BorderSide(
                              color: Color(0xFFDAE8E1),
                              width: 1.1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _showUiNotice(
                            'UI Preview: Opening new voluntary donation screen.',
                          ),
                          child: const Text(
                            '+ Make Another Voluntary Donation',
                            style: TextStyle(
                              fontSize: 13.5,
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

  Widget _buildTransactionCard(DonationReceiptRecord record, bool isSelected) {
    final bool useDarkPaidBadge = record.isFeatured || isSelected;

    return InkWell(
      onTap: () => setState(() => _selectedTxnId = record.txnId),
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
                ? const Color(0xFF075A50)
                : const Color(0xFFDAE8E1),
            width: isSelected ? 1.5 : 1.1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${record.txnId} • ${record.dateLabel}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF58746D),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: useDarkPaidBadge
                        ? const Color(0xFF075A50)
                        : const Color(0xFFE5F5EE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'PAID ✓',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: useDarkPaidBadge
                          ? Colors.white
                          : const Color(0xFF075A50),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    record.ngoName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF173D37),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '\$${record.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF075A50),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Category: ${record.category} • ${record.paymentMethodDetail}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF58746D),
              ),
            ),
            if (record.isFeatured) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.check,
                    color: Color(0xFF075A50),
                    size: 14,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'Payment Confirmed • Receipt ${record.receiptNumber}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF075A50),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF173D37),
                    side: const BorderSide(
                      color: Color(0xFF075A50),
                      width: 1.2,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _openReceiptPreview(record),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download, size: 16, color: Color(0xFF58746D)),
                      SizedBox(width: 6),
                      Text(
                        'Download Official PDF Receipt',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (record.showReceiptSentText) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5F5EE),
                    foregroundColor: const Color(0xFF173D37),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _openReceiptPreview(record),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.download,
                        size: 16,
                        color: Color(0xFF58746D),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Download Receipt (${record.receiptNumber})',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}