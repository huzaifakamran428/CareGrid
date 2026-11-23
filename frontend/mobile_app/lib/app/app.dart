import 'package:flutter/material.dart';
import '../features/digital_id/presentation/screens/digital_id_screen.dart';
import '../features/complaints_feedback/presentation/screens/complaints_home_screen.dart';
import '../features/complaints_feedback/presentation/widgets/complaint_components.dart';

import '../features/beneficiary/presentation/screens/beneficiary_home_screen.dart';
import '../features/beneficiary/presentation/screens/beneficiary_profile_screen.dart';
import '../features/beneficiary/presentation/screens/booking_history_screen.dart';
import '../features/beneficiary/presentation/screens/booking_screen.dart';
import '../features/beneficiary/presentation/screens/complaint_feedback_screen.dart';
import '../features/beneficiary/presentation/screens/digital_id_pass_screen.dart';
import '../features/beneficiary/presentation/screens/lab_details_screen.dart';
import '../features/beneficiary/presentation/screens/lab_list_screen.dart';
import '../features/beneficiary/presentation/screens/prescription_upload_screen.dart';
import '../features/chatbot/presentation/screens/chat_history_screen.dart';
import '../features/chatbot/presentation/screens/chatbot_screen.dart';

/// UI preview entry point. Other CareGrid modules are intentionally untouched.
class CareGridApp extends StatelessWidget {
  const CareGridApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ColorScheme.fromSeed(
      seedColor: CgColors.primary,
      primary: CgColors.primary,
      surface: Colors.white,
      brightness: Brightness.light,
    );
    return MaterialApp(
      title: 'CareGrid · Beneficiary Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colors,
        scaffoldBackgroundColor: CgColors.canvas,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: CgColors.canvas,
          foregroundColor: CgColors.ink,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: CgColors.ink,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: CgColors.line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: CgColors.primary, width: 1.7),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: CgColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: CgColors.error, width: 1.7),
          ),
        ),
      ),
      home: const BeneficiaryPortalPreview(),
    );
  }
}

/// Separate mobile beneficiary portal preview, with Digital ID and complaints tabs.
/// The web NGO and mobile screens share no backend data in this UI-only release.
class BeneficiaryPortalPreview extends StatefulWidget {
  const BeneficiaryPortalPreview({super.key});
  @override
  State<BeneficiaryPortalPreview> createState() => _BeneficiaryPortalPreviewState();
}

class _BeneficiaryPortalPreviewState extends State<BeneficiaryPortalPreview> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: _selectedIndex, children: const [
      DigitalIdScreen(),
      ComplaintsHomeScreen(),
      _NewFeaturesHub(),
    ]),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) => setState(() => _selectedIndex = index),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.badge_outlined), selectedIcon: Icon(Icons.badge), label: 'My Digital ID'),
        NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Complaints'),
        NavigationDestination(icon: Icon(Icons.apps_outlined), selectedIcon: Icon(Icons.apps), label: 'New Services'),
      ],
    ),
  );
}


/// Launcher for Umair Sultan's new mobile UI screens. Preview-only, no backend.
class _NewFeaturesHub extends StatelessWidget {
  const _NewFeaturesHub();

  @override
  Widget build(BuildContext context) {
    const features = <_NewFeature>[
      _NewFeature('Beneficiary Home', Icons.home_outlined, BeneficiaryHomeScreen()),
      _NewFeature('Beneficiary Profile', Icons.person_outline, BeneficiaryProfileScreen()),
      _NewFeature('Lab List', Icons.science_outlined, LabListScreen()),
      _NewFeature('Lab Details', Icons.biotech_outlined, LabDetailsScreen()),
      _NewFeature('Book Appointment', Icons.event_available_outlined, BookingScreen()),
      _NewFeature('Booking History', Icons.history_outlined, BookingHistoryScreen()),
      _NewFeature('Digital ID Pass', Icons.badge_outlined, DigitalIdPassScreen()),
      _NewFeature('Prescription Upload', Icons.upload_file_outlined, PrescriptionUploadScreen()),
      _NewFeature('Complaints & Feedback', Icons.rate_review_outlined, ComplaintFeedbackScreen()),
      _NewFeature('Chatbot', Icons.smart_toy_outlined, CaregridChatbotScreen()),
      _NewFeature('Chat History', Icons.forum_outlined, ChatHistoryScreen()),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('CareGrid · New Services')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: features.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final feature = features[index];
          return ListTile(
            leading: Icon(feature.icon),
            title: Text(feature.title),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => feature.screen),
            ),
          );
        },
      ),
    );
  }
}

class _NewFeature {
  final String title;
  final IconData icon;
  final Widget screen;
  const _NewFeature(this.title, this.icon, this.screen);
}
