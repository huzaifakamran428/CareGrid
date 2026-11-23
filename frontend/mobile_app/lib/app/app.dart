import 'package:flutter/material.dart';

import '../features/beneficiary/presentation/screens/beneficiary_home_screen.dart';
import '../features/beneficiary/presentation/screens/beneficiary_profile_screen.dart';
import '../features/beneficiary/presentation/screens/booking_history_screen.dart';
import '../features/beneficiary/presentation/screens/booking_screen.dart';
import '../features/beneficiary/presentation/screens/digital_id_pass_screen.dart';
import '../features/beneficiary/presentation/screens/lab_list_screen.dart';
import '../features/beneficiary/presentation/screens/prescription_upload_screen.dart';
import '../features/chatbot/presentation/screens/chatbot_screen.dart';
import '../features/chatbot/presentation/screens/chat_history_screen.dart';
import '../features/complaints_feedback/presentation/screens/complaints_home_screen.dart';
import '../features/complaints_feedback/presentation/screens/submit_complaint_screen.dart';
import '../features/complaints_feedback/presentation/screens/service_feedback_screen.dart';
import '../features/complaints_feedback/presentation/widgets/complaint_components.dart';

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
      title: 'CareGrid · Beneficiary',
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
        ),
      ),
      home: const BeneficiaryShell(),
    );
  }
}

/// One navigation hierarchy for the beneficiary experience. Feature details
/// are pushed on top of this shell, rather than nested inside another tab bar.
class BeneficiaryShell extends StatefulWidget {
  const BeneficiaryShell({super.key});

  @override
  State<BeneficiaryShell> createState() => _BeneficiaryShellState();
}

class _BeneficiaryShellState extends State<BeneficiaryShell> {
  int _tab = 0;

  void _switchTab(int index) {
    if (!mounted) return;
    setState(() => _tab = index);
  }

  void _open(String destination) {
    switch (destination) {
      case 'home': _switchTab(0); return;
      case 'labs': _switchTab(1); return;
      case 'bookings': _switchTab(2); return;
      case 'support': _switchTab(3); return;
      case 'profile': _switchTab(4); return;
    }

    final Widget? screen = switch (destination) {
      'digital-id' => const DigitalIdPassScreen(),
      'prescription' => const PrescriptionUploadScreen(),
      'chatbot' => const CaregridChatbotScreen(),
      'chat-history' => const ChatHistoryScreen(),
      'feedback' => const ServiceFeedbackScreen(),
      'new-complaint' => const SubmitComplaintScreen(),
      'book-test' => const BookingScreen(),
      _ => null,
    };
    if (screen == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This service is not ready in the demo.')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: [
          BeneficiaryHomeScreen(onOpen: _open),
          const LabListScreen(),
          const BookingHistoryScreen(),
          const ComplaintsHomeScreen(),
          BeneficiaryProfileScreen(onOpen: _open),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: _switchTab,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.science_outlined),
              selectedIcon: Icon(Icons.science), label: 'Labs'),
          NavigationDestination(icon: Icon(Icons.event_note_outlined),
              selectedIcon: Icon(Icons.event_note), label: 'Bookings'),
          NavigationDestination(icon: Icon(Icons.support_agent_outlined),
              selectedIcon: Icon(Icons.support_agent), label: 'Support'),
          NavigationDestination(icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
