import 'package:flutter/material.dart';
import '../../../../app/theme/brand_tokens.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/portal_user.dart';
import '../../../sponsor/presentation/screens/Sponser.dart' as donation;

class MembershipWorkspace extends StatefulWidget {
  final PortalUser user;
  final VoidCallback onSignOut;
  const MembershipWorkspace({super.key, required this.user, required this.onSignOut});
  @override
  State<MembershipWorkspace> createState() => _MembershipWorkspaceState();
}

class _MembershipWorkspaceState extends State<MembershipWorkspace> {
  final repo = CareGridAuthRepository();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  void dispose() { name.dispose(); email.dispose(); password.dispose(); super.dispose(); }
  String date(DateTime d) => '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}';
  void register() {
    final ok = repo.registerNgo(name.text, email.text, password.text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Trial account created. Sign in using the assigned credentials.' : 'Enter a unique email, name and password of at least 8 characters.')));
    if (ok) { name.clear(); email.clear(); password.clear(); setState(() {}); }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('NGO Memberships'), actions: [IconButton(tooltip: 'Sign Out', onPressed: widget.onSignOut, icon: const Icon(Icons.logout))]),
    body: ListView(padding: const EdgeInsets.all(18), children: [
      const Text('Membership administration', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: CareGridPalette.primaryDeep)),
      const Text('Local mobile demo: one calendar month free, then annual licensing. Changes reset on app restart.'),
      const SizedBox(height: 16),
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Register NGO and assign credentials', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(controller: name, decoration: const InputDecoration(labelText: 'NGO name')),
        TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Demo email')),
        TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Temporary demo password')),
        const SizedBox(height: 12),
        FilledButton(onPressed: register, child: const Text('Start one-month trial')),
      ]))),
      const SizedBox(height: 16),
      for (final item in CareGridAuthRepository.memberships.values)
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(item.email),
          Text('${item.status} - expires ${date(item.expires)}'),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: () => setState(() => repo.renew(item.email)), child: Text(item.plan == 'Trial' ? 'Activate annual license' : 'Renew annual license')),
        ]))),
    ]),
  );
}

class SponsorWorkspace extends StatelessWidget {
  final PortalUser user;
  final VoidCallback onSignOut;
  const SponsorWorkspace({super.key, required this.user, required this.onSignOut});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Sponsor workspace'), actions: [IconButton(tooltip: 'Sign Out', onPressed: onSignOut, icon: const Icon(Icons.logout))]),
    body: Navigator(onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => const donation.DonateNgoSelectionScreen())),
  );
}
