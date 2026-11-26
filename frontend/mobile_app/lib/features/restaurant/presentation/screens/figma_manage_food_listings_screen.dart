import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const CareGridApp());
}

class CareGridApp extends StatelessWidget {
  const CareGridApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareGrid - Manage Food Listings',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF155E42)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ManageFoodListingsScreen(),
    );
  }
}

class ManageFoodListingsScreen extends StatefulWidget {
  const ManageFoodListingsScreen({super.key});

  @override
  State<ManageFoodListingsScreen> createState() =>
      _ManageFoodListingsScreenState();
}

class _ManageFoodListingsScreenState extends State<ManageFoodListingsScreen> {
  // Active Listing (Batch #FD-209) state
  String batch209Title = 'Chicken Pulao & Roasted Naan';
  int batch209Qty = 50;
  TimeOfDay batch209Cutoff = const TimeOfDay(hour: 23, minute: 45);
  bool isBatch209Cancelled = false;
  String batch209CancelReason = 'Items no longer suitable for donation';
  String lastEditedText = 'Last edited 2 mins ago — Synced with NGOs';

  // Cancelled Listing (Batch #FD-207) state
  final String batch207Title = 'Assorted Bakery Pastries (24 Packs)';
  final String batch207Reason = 'Items no longer suitable for donation';

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  Future<void> _pickQuickCutoffTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: batch209Cutoff,
    );
    if (picked != null) {
      setState(() {
        batch209Cutoff = picked;
        lastEditedText = 'Last edited just now — Synced with NGOs';
      });
    }
  }

  Future<void> _editQuickQuantity() async {
    final TextEditingController qtyController =
    TextEditingController(text: batch209Qty.toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Adjust Portion / Box Count',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: qtyController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantity (Boxes / Portions)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF155E42),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final int? parsed = int.tryParse(qtyController.text.trim());
                if (parsed != null && parsed > 0) {
                  setState(() {
                    batch209Qty = parsed;
                    lastEditedText = 'Last edited just now — Synced with NGOs';
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditListingDialog() async {
    final TextEditingController titleController =
    TextEditingController(text: batch209Title);
    final TextEditingController qtyController =
    TextEditingController(text: batch209Qty.toString());
    TimeOfDay tempTime = batch209Cutoff;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Text(
                'Edit Batch #FD-209',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Food Item Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: qtyController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Portions / Boxes',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: tempTime,
                        );
                        if (picked != null) {
                          setDialogState(() {
                            tempTime = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Cutoff Time:'),
                            Text(
                              _formatTime(tempTime),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF155E42),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Discard'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF155E42),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      if (titleController.text.trim().isNotEmpty) {
                        batch209Title = titleController.text.trim();
                      }
                      final int? parsedQty =
                      int.tryParse(qtyController.text.trim());
                      if (parsedQty != null && parsedQty > 0) {
                        batch209Qty = parsedQty;
                      }
                      batch209Cutoff = tempTime;
                      lastEditedText =
                      'Last edited just now — Synced with NGOs';
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showCancelListingDialog() async {
    final TextEditingController reasonController =
    TextEditingController(text: 'Items no longer suitable for donation');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Cancel Batch #FD-209?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9F1239),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This will immediately hide the listing from the NGO feed.',
                style: TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: 'Cancellation Reason',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep Listing'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  isBatch209Cancelled = true;
                  batch209CancelReason = reasonController.text.trim().isEmpty
                      ? 'Cancelled by donor'
                      : reasonController.text.trim();
                });
                Navigator.pop(context);
              },
              child: const Text('Confirm Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showAuditLogSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Donation History & Audit Log',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 14),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle, color: Color(0xFF155E42)),
                title: Text('Batch #FD-209 — $batch209Title'),
                subtitle: Text(isBatch209Cancelled
                    ? 'Status: CANCELLED • $batch209CancelReason'
                    : 'Status: AVAILABLE ($batch209Qty Portions) • Cutoff ${_formatTime(batch209Cutoff)}'),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.cancel, color: Color(0xFFDC2626)),
                title: Text('Batch #FD-207 — $batch207Title'),
                subtitle: Text('Status: CANCELLED • $batch207Reason'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF155E42),
      body: SafeArea(
        child: Column(
          children: [
            // Clean Header (Excludes top time, STORY badge, and MEDIUM badge)
            Padding(
              padding: const EdgeInsets.fromLTRB(22.0, 20.0, 22.0, 18.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Manage Food Listings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Edit quantity/details or cancel unavailable food',
                      style: TextStyle(
                        color: Color(0xFFD1FAE5),
                        fontSize: 13.5,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Updates status & removes cancelled items',
                      style: TextStyle(
                        color: Color(0xFFA7F3D0),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main White Sheet Container
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18.0, 20.0, 18.0, 16.0),
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
                      // CARD 1: Batch #FD-209 (Switches dynamically if cancelled)
                      if (!isBatch209Cancelled)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            border: Border.all(
                              color: const Color(0xFF155E42),
                              width: 1.3,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF155E42),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.circle,
                                            color: Colors.white, size: 8),
                                        SizedBox(width: 6),
                                        Text(
                                          'AVAILABLE',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Text(
                                    'Batch #FD-209',
                                    style: TextStyle(
                                      color: Color(0xFF155E42),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                batch209Title,
                                style: const TextStyle(
                                  color: Color(0xFF111827),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Updated Qty: $batch209Qty Portions • Cutoff: ${_formatTime(batch209Cutoff)}',
                                style: const TextStyle(
                                  color: Color(0xFF4B5563),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 42,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          const Color(0xFF155E42),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: _showEditListingDialog,
                                        icon: const Icon(Icons.edit_outlined,
                                            size: 16),
                                        label: const Text(
                                          'Edit Listing',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: SizedBox(
                                      height: 42,
                                      child: OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor:
                                          const Color(0xFFDC2626),
                                          side: const BorderSide(
                                            color: Color(0xFFDC2626),
                                            width: 1.2,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: _showCancelListingDialog,
                                        icon: const Icon(Icons.close, size: 16),
                                        label: const Text(
                                          'Cancel Listing',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.check,
                                      color: Color(0xFF155E42), size: 15),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      lastEditedText,
                                      style: const TextStyle(
                                        color: Color(0xFF155E42),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      else
                        _buildCancelledCard(
                          batchId: 'Batch #FD-209',
                          title: batch209Title,
                          reason: batch209CancelReason,
                          onUndo: () {
                            setState(() {
                              isBatch209Cancelled = false;
                            });
                          },
                        ),

                      const SizedBox(height: 14),

                      // CARD 2: Batch #FD-207 (Cancelled Card)
                      _buildCancelledCard(
                        batchId: 'Batch #FD-207',
                        title: batch207Title,
                        reason: batch207Reason,
                      ),

                      const SizedBox(height: 14),

                      // CARD 3: QUICK UPDATE MODE
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7).withOpacity(0.65),
                          border: Border.all(
                            color: const Color(0xFFF59E0B),
                            width: 1.1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'QUICK UPDATE MODE',
                                style: TextStyle(
                                  color: Color(0xFF1F2937),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.5,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Adjust Portion Count or Cutoff Time:',
                              style: TextStyle(
                                color: Color(0xFF1F2937),
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: _editQuickQuantity,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: const Color(0xFFD97706)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        'Qty: $batch209Qty Boxes',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Color(0xFF1F2937),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: InkWell(
                                    onTap: _pickQuickCutoffTime,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: const Color(0xFFD97706)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        'Cutoff: ${_formatTime(batch209Cutoff)}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Color(0xFF1F2937),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: const [
                                Text(
                                  '• ',
                                  style: TextStyle(
                                    color: Color(0xFF92400E),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Prevents NGOs from traveling for unavailable food',
                                    style: TextStyle(
                                      color: Color(0xFF92400E),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

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
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'All listing status updates saved and synced with NGOs!'),
                                backgroundColor: Color(0xFF155E42),
                              ),
                            );
                          },
                          child: const Text(
                            'Save Listing Status Updates',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // SECONDARY ACTION BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFF3F4F6),
                            foregroundColor: const Color(0xFF155E42),
                            side: const BorderSide(
                              color: Color(0xFFD1D5DB),
                              width: 1.1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _showAuditLogSheet,
                          child: const Text(
                            'View Donation History & Audit Log',
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

  Widget _buildCancelledCard({
    required String batchId,
    required String title,
    required String reason,
    VoidCallback? onUndo,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        border: Border.all(
          color: const Color(0xFFFDA4AF),
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(16),
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
                  color: const Color(0xFFE11D48),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.close, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'CANCELLED',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    batchId,
                    style: const TextStyle(
                      color: Color(0xFF9F1239),
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
                  ),
                  if (onUndo != null) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onUndo,
                      child: const Text(
                        'Restore',
                        style: TextStyle(
                          color: Color(0xFF155E42),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Reason: $reason',
            style: const TextStyle(
              color: Color(0xFF9F1239),
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.circle, color: Color(0xFF9F1239), size: 9),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Status updated & removed from NGO feed',
                  style: TextStyle(
                    color: Color(0xFF9F1239),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}