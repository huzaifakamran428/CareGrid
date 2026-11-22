import 'package:flutter/material.dart';
import '../features/digital_id/presentation/screens/digital_id_screen.dart';
import '../features/complaints_feedback/presentation/screens/complaints_home_screen.dart';
import '../features/complaints_feedback/presentation/widgets/complaint_components.dart';

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
    ]),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) => setState(() => _selectedIndex = index),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.badge_outlined), selectedIcon: Icon(Icons.badge), label: 'My Digital ID'),
        NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Complaints'),
      ],
    ),
  );
}
