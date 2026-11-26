import 'package:flutter/material.dart';
import '../../../../app/theme/brand_tokens.dart';
import '../../../auth/domain/entities/portal_user.dart';
import '../../../auth/data/repositories/auth_repository.dart';

class AdminMobileScreen extends StatelessWidget {
  final PortalUser user;
  final VoidCallback onSignOut;
  const AdminMobileScreen({super.key, required this.user, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CareGridPalette.canvas,
      appBar: AppBar(
        title: Text('System Admin Console'),
        actions: [
          IconButton(
            tooltip: 'Sign Out',
            icon: const Icon(Icons.logout_rounded),
            onPressed: onSignOut,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: CareGridPalette.headerGradient,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(user.subtitle, style: const TextStyle(color: Color(0xFFD7F2E9), fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('System-wide demo registry', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          for (final account in CareGridAuthRepository.users.where((a) => a.role != CareGridPortalRole.membershipAdmin && a.role != CareGridPortalRole.admin))
            Card(child: ListTile(title: Text(account.name), subtitle: Text('${account.role.name} - ${account.id}\n${account.email}'))),

          Card(
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: CareGridPalette.paleMint, child: Icon(Icons.analytics_outlined, color: CareGridPalette.primary)),
              title: const Text('34 Verified Partner Entities', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('100% Audit Trail Synced'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: CareGridPalette.goldTint, child: Icon(Icons.verified_outlined, color: CareGridPalette.goldDeep)),
              title: const Text('Active Queue Item', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('Root Role & Account Control'),
            ),
          ),
        ],
      ),
    );
  }
}
