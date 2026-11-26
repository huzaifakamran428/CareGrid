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
      title: 'CareGrid - Collection Deadline',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF087C69)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
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
      backgroundColor: const Color(0xFF0A4730),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar / Header info (Story & High badges removed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
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
                      color: Color(0xFFB2DFDB),
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
                          color: Color(0xFF374151),
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
                            color: const Color(0xFFEBF5EE),
                            border: Border.all(color: const Color(0xFF2E7D56), width: 1.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month, color: Color(0xFF2E7D56), size: 20),
                              const SizedBox(width: 12),
                              Text(
                                formattedDateText,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.edit_calendar, color: Color(0xFF2E7D56), size: 18),
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
                                    color: Color(0xFF374151),
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
                                      border: Border.all(color: const Color(0xFFD1D5DB)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time_rounded, color: Color(0xFF6B7280), size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatTime(pickupWindowStart),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1F2937),
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
                                    color: Color(0xFF374151),
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
                                      color: const Color(0xFFFEF3C7),
                                      border: Border.all(color: const Color(0xFFE3A33B), width: 1.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.alarm, color: Color(0xFFD97706), size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatTime(collectionDeadline),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF92400E),
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
                          color: const Color(0xFFF0FDF4),
                          border: Border.all(color: const Color(0xFFA7F3D0)),
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
                                    color: Color(0xFF065F46),
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
                                Text('✓ ', style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 13)),
                                Expanded(
                                  child: Text(
                                    'Expired listings removed from NGO feed',
                                    style: TextStyle(color: Color(0xFF065F46), fontWeight: FontWeight.bold, fontSize: 13),
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
                          color: const Color(0xFFFFF1F2),
                          border: Border.all(color: const Color(0xFFFECDD3)),
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
                                    color: const Color(0xFFE11D48),
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
                                color: Color(0xFF9F1239),
                                fontSize: 13.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Hidden from NGO search results after 04:00 PM',
                              style: TextStyle(
                                color: Color(0xFF881337),
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
                          color: Color(0xFF374151),
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
                            backgroundColor: const Color(0xFF087C69),
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
                                backgroundColor: const Color(0xFF087C69),
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
                          color: const Color(0xFFD1FAE5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.circle, color: Color(0xFF059669), size: 10),
                            const SizedBox(width: 8),
                            Text(
                              'Active Until ${DateFormat('d MMM yyyy').format(selectedDate)}, ${_formatTime(collectionDeadline)}',
                              style: const TextStyle(
                                color: Color(0xFF065F46),
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
        const Text('• ', style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 14)),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF065F46),
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
          color: isSelected ? const Color(0xFF087C69) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF087C69) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF374151),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}