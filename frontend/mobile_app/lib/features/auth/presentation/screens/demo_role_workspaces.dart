import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../app/theme/brand_tokens.dart';
import '../../../../core/widgets/caregrid_brand.dart';
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
  final documents = <String, DemoNgoDocument>{};
  static const categories = ['NGO registration certificate', 'Authorized representative ID', 'Supporting document'];
  bool picking = false;
  Future<void> pickDocument(String category) async {
    setState(() => picking = true);
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'], withData: true);
      if (!mounted || result == null) return;
      final file = result.files.single;
      final bytes = file.bytes;
      final document = bytes == null ? null : DemoNgoDocument(category, file.name, bytes);
      if (document == null || !document.valid) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Choose a valid PDF, PNG or JPEG file up to 5 MB.')));
        return;
      }
      setState(() => documents[category] = document);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open the file picker. Try again.')));
    } finally { if (mounted) setState(() => picking = false); }
  }
  @override
  void dispose() { name.dispose(); email.dispose(); password.dispose(); super.dispose(); }
  String date(DateTime d) => '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}';
  void register() {
    final ok = repo.registerNgo(name.text, email.text, password.text, documents: documents.values.toList());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Trial account created. Sign in using the assigned credentials.' : 'Enter a unique email, name and password of at least 8 characters.')));
    if (ok) { name.clear(); email.clear(); password.clear(); setState(() => documents.clear()); }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const CareGridPageTitle('Memberships'), actions: [IconButton(tooltip: 'Sign Out', onPressed: widget.onSignOut, icon: const Icon(Icons.logout))]),
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
        const Text('Registration documents', style: TextStyle(fontWeight: FontWeight.w700)),
        const Text('Optional demo files only. PDF, PNG or JPEG; maximum 5 MB each.'),
        for (final category in categories) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(onPressed: picking ? null : () => pickDocument(category), icon: const Icon(Icons.upload_file), label: Text(category)),
          if (documents.containsKey(category))
            ListTile(dense: true, title: Text(documents[category]!.name), subtitle: const Text('Attached for registration'), trailing: IconButton(tooltip: 'Remove file', onPressed: () => setState(() => documents.remove(category)), icon: const Icon(Icons.close))),
        ],
        const SizedBox(height: 12),
        FilledButton(onPressed: picking ? null : register, child: const Text('Start one-month trial')),
      ]))),
      const SizedBox(height: 16),
      for (final item in CareGridAuthRepository.memberships.values)
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(item.email),
          Text('${item.status} - expires ${date(item.expires)}'),
          for (final document in item.documents) Text('${document.category}: ${document.name}', style: Theme.of(context).textTheme.bodySmall),
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
    appBar: AppBar(title: const CareGridPageTitle('Sponsor'), actions: [IconButton(tooltip: 'Sign Out', onPressed: onSignOut, icon: const Icon(Icons.logout))]),
    body: Navigator(onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => const donation.DonateNgoSelectionScreen())),
  );
}
