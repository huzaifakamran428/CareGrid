import 'package:flutter/material.dart';
import '../../../../app/theme/brand_tokens.dart';
import '../../../../core/widgets/caregrid_brand.dart';
import '../../../../app/theme/caregrid_theme.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const CareGridApp());
}

class CareGridApp extends StatelessWidget {
  const CareGridApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareGrid - Collection Deadline',
      debugShowCheckedModeBanner: false,
      theme: CareGridTheme.light,
      home: const CollectionDeadlineScreen(),
    );
  }
}

class CollectionDeadlineScreen extends StatefulWidget {
  const CollectionDeadlineScreen({super.key});

  @override
  State<CollectionDeadlineScreen> createState() => _CollectionDeadlineScreenState();
}

class _CollectionDeadlineScreenState extends State<CollectionDeadlineScreen> {
  String selectedPreset = '+2 Hours';

  // Interactive state variables
  DateTime selectedDate = DateTime(2026, 11, 14);
  TimeOfDay pickupWindowStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay collectionDeadline = const TimeOfDay(hour: 23, minute: 45);

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickPickupTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: pickupWindowStart,
    );
    if (picked != null) {
      setState(() {
        pickupWindowStart = picked;
      });
    }
  }

  Future<void> _pickDeadlineTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: collectionDeadline,
    );
    if (picked != null) {
      setState(() {
        collectionDeadline = picked;
      });
    }
  }

  void _applyPreset(String preset) {
    setState(() {
      selectedPreset = preset;
      int totalMinutes = pickupWindowStart.hour * 60 + pickupWindowStart.minute;
      if (preset == '+1 Hour') {
        totalMinutes += 60;
      } else if (preset == '+2 Hours') {
        totalMinutes += 120;
      } else if (preset == 'Midnight') {
        totalMinutes = 24 * 60;
      }
      int newHour = (totalMinutes ~/ 60) % 24;
      int newMinute = totalMinutes % 60;
      collectionDeadline = TimeOfDay(hour: newHour, minute: newMinute);
    });
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDateText = 'Today — ${DateFormat('EEEE, d MMM yyyy').format(selectedDate)}';

    return Scaffold(
      backgroundColor: CareGridPalette.primaryDeep,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar / Header info (Story & High badges removed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CareGridBrandStrip(compact: true),
                  SizedBox(height: 10),
                  Text(
                    'Collection Deadline',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Set pickup date, cutoff time & auto-expiry\nExpired listings automatically hidden from NGOs',
                    style: TextStyle(
                      color: CareGridPalette.mintBorder,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Bottom White Card Container
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AVAILABILITY DATE (Clickable)
                      const Text(
                        'AVAILABILITY DATE *',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: CareGridPalette.ink,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: CareGridPalette.paleMint,
                            border: Border.all(color: CareGridPalette.primary, width: 1.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month, color: CareGridPalette.primary, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                formattedDateText,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CareGridPalette.ink,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.edit_calendar, color: CareGridPalette.primary, size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // PICKUP WINDOW START & COLLECTION DEADLINE (Both Clickable)
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'PICKUP WINDOW START',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: CareGridPalette.ink,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: _pickPickupTime,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: CareGridPalette.line),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time_rounded, color: CareGridPalette.secondaryText, size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatTime(pickupWindowStart),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: CareGridPalette.ink,
                                            fontSize: 13.5,
                                          ),
                                        ),
                                      ],
                                    ),
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
                                  'COLLECTION DEADLINE *',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: CareGridPalette.ink,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: _pickDeadlineTime,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: CareGridPalette.goldTint,
                                      border: Border.all(color: CareGridPalette.gold, width: 1.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.alarm, color: CareGridPalette.goldDeep, size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatTime(collectionDeadline),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: CareGridPalette.goldDeep,
                                            fontSize: 13.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // REMAINING PICKUP WINDOW INFO BOX
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CareGridPalette.paleMint,
                          border: Border.all(color: CareGridPalette.mintBorder),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text('⏳', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 8),
                                Text(
                                  'Remaining Pickup Window: Active',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CareGridPalette.primaryDeep,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _buildBulletPoint('NGOs see live countdown badge on listing'),
                            const SizedBox(height: 4),
                            _buildBulletPoint('At ${_formatTime(collectionDeadline)}, status switches to EXPIRED'),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('✓ ', style: TextStyle(color: CareGridPalette.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                                Expanded(
                                  child: Text(
                                    'Expired listings removed from NGO feed',
                                    style: TextStyle(color: CareGridPalette.primaryDeep, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            _buildBulletPoint('Ensures food safety & freshness compliance'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // AUTO-EXPIRY GUARD BOX
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CareGridPalette.dangerTint,
                          border: Border.all(color: CareGridPalette.dangerBorder),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: CareGridPalette.danger,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'AUTO-EXPIRY GUARD',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Batch #FD-204 (Lunch Biryani) — EXPIRED',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CareGridPalette.danger,
                                fontSize: 13.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Hidden from NGO search results after 04:00 PM',
                              style: TextStyle(
                                color: CareGridPalette.danger,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // QUICK DEADLINE PRESETS
                      const Text(
                        'QUICK DEADLINE PRESETS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: CareGridPalette.ink,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _buildPresetButton('+1 Hour')),
                          const SizedBox(width: 10),
                          Expanded(child: _buildPresetButton('+2 Hours')),
                          const SizedBox(width: 10),
                          Expanded(child: _buildPresetButton('Midnight')),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // SAVE COLLECTION DEADLINE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CareGridPalette.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Deadline saved successfully for ${_formatTime(collectionDeadline)}!'),
                                backgroundColor: CareGridPalette.primary,
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Save Collection Deadline',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.check, size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ACTIVE UNTIL FOOTER BANNER
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
                            const Icon(Icons.circle, color: CareGridPalette.primary, size: 10),
                            const SizedBox(width: 8),
                            Text(
                              'Active Until ${DateFormat('d MMM yyyy').format(selectedDate)}, ${_formatTime(collectionDeadline)}',
                              style: const TextStyle(
                                color: CareGridPalette.primaryDeep,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
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

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(color: CareGridPalette.primary, fontWeight: FontWeight.bold, fontSize: 14)),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: CareGridPalette.primaryDeep,
              fontSize: 12.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPresetButton(String label) {
    bool isSelected = selectedPreset == label;
    return GestureDetector(
      onTap: () => _applyPreset(label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? CareGridPalette.primary : CareGridPalette.paleNeutral,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? CareGridPalette.primary : CareGridPalette.line,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : CareGridPalette.ink,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}