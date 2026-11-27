import 'package:flutter/material.dart';
import 'theme/caregrid_theme.dart';
import '../features/auth/presentation/screens/demo_role_workspaces.dart';
import '../features/chatbot/presentation/screens/chatbot_screen.dart';
import '../features/chatbot/presentation/screens/chat_history_screen.dart';
import '../features/auth/domain/entities/portal_user.dart';
import '../features/auth/presentation/screens/unified_auth_screen.dart';
import '../features/beneficiary/presentation/screens/beneficiary_home_screen.dart';
import '../features/beneficiary/presentation/screens/beneficiary_profile_screen.dart';
import '../features/beneficiary/presentation/screens/booking_history_screen.dart';
import '../features/beneficiary/presentation/screens/booking_screen.dart';
import '../features/beneficiary/presentation/screens/digital_id_pass_screen.dart';
import '../features/beneficiary/presentation/screens/lab_list_screen.dart';
import '../features/beneficiary/presentation/screens/prescription_upload_screen.dart';
import '../features/complaints_feedback/presentation/screens/complaints_home_screen.dart';
import '../features/complaints_feedback/presentation/screens/submit_complaint_screen.dart';
import '../features/complaints_feedback/presentation/screens/service_feedback_screen.dart';
import '../features/restaurant/presentation/screens/restaurant_dashboard_screen.dart';
import '../features/pharmacy/presentation/screens/pharmacy_mobile_screen.dart';
import '../features/lab_booking/presentation/screens/lab_mobile_screen.dart';
import '../features/ngo/presentation/screens/ngo_mobile_screen.dart';
import '../features/admin/presentation/screens/admin_mobile_screen.dart';

class CareGridApp extends StatefulWidget {
  final bool startAuthenticated;
  const CareGridApp({super.key, this.startAuthenticated = false});

  @override
  State<CareGridApp> createState() => _CareGridAppState();
}

class _CareGridAppState extends State<CareGridApp> {
  PortalUser? _currentUser;

  @override
  void initState() {
    super.initState();
    if (widget.startAuthenticated) {
      _currentUser = const PortalUser(
        id: 'CG-BEN-2026-009481',
        name: 'Ayesha Bibi',
        email: 'ayesha.bibi@caregrid.pk',
        role: CareGridPortalRole.beneficiary,
        subtitle: 'CNIC: 35202-8492014-6',
      );
    }
  }

  Widget _buildPortalForUser(PortalUser user) {
    void signOut() => setState(() => _currentUser = null);
    return switch (user.role) {
      CareGridPortalRole.beneficiary => BeneficiaryShell(onSignOut: signOut, demoEmail: user.email),
      CareGridPortalRole.restaurant => RestaurantDashboardScreen(user: user, onSignOut: signOut),
      CareGridPortalRole.pharmacy => PharmacyMobileScreen(user: user, onSignOut: signOut),
      CareGridPortalRole.lab => LabMobileScreen(user: user, onSignOut: signOut),
      CareGridPortalRole.ngo => NgoMobileScreen(user: user, onSignOut: signOut),
      CareGridPortalRole.admin => AdminMobileScreen(user: user, onSignOut: signOut),
      CareGridPortalRole.membershipAdmin => MembershipWorkspace(user: user, onSignOut: signOut),
      CareGridPortalRole.sponsor => SponsorWorkspace(user: user, onSignOut: signOut),
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareGrid · Compassion Connected',
      debugShowCheckedModeBanner: false,
      theme: CareGridTheme.light,
      home: _currentUser == null
          ? UnifiedAuthScreen(onAuthenticated: (user) => setState(() => _currentUser = user))
          : _buildPortalForUser(_currentUser!),
    );
  }
}

class BeneficiaryShell extends StatefulWidget {
  final VoidCallback? onSignOut;
  final String demoEmail;
  const BeneficiaryShell({super.key, this.onSignOut, this.demoEmail = 'ayesha.bibi@caregrid.pk'});

  @override
  State<BeneficiaryShell> createState() => _BeneficiaryShellState();
}

class _BeneficiaryShellState extends State<BeneficiaryShell> {
  int _tab = 0;

  void _open(String destination) {
    switch (destination) {
      case 'home': setState(() => _tab = 0); return;
      case 'labs': setState(() => _tab = 1); return;
      case 'bookings': setState(() => _tab = 2); return;
      case 'support': setState(() => _tab = 3); return;
      case 'profile': setState(() => _tab = 4); return;
      case 'logout':
      case 'sign-out':
        widget.onSignOut?.call();
        return;
    }
    final Widget? screen = switch (destination) {
      'digital-id' => const DigitalIdPassScreen(),
      'prescription' => PrescriptionUploadScreen(demoEmail: widget.demoEmail),
      'chatbot' => const CaregridChatbotScreen(),
      'chat-history' => const ChatHistoryScreen(),
      'feedback' => const ServiceFeedbackScreen(),
      'new-complaint' => const SubmitComplaintScreen(),
      'book-test' => const BookingScreen(),
      _ => null,
    };
    if (screen != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      BeneficiaryHomeScreen(onOpen: _open),
      const LabListScreen(),
      const BookingHistoryScreen(),
      const ComplaintsHomeScreen(),
      BeneficiaryProfileScreen(onOpen: _open),
    ];
    return Scaffold(
      body: IndexedStack(index: _tab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.biotech_outlined), selectedIcon: Icon(Icons.biotech_rounded), label: 'Labs'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month_rounded), label: 'Bookings'),
          NavigationDestination(icon: Icon(Icons.support_agent_outlined), selectedIcon: Icon(Icons.support_agent_rounded), label: 'Support'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
