import 'package:flutter/material.dart';
import '../../../../app/theme/brand_tokens.dart';
import '../../../../core/widgets/caregrid_brand.dart';
import '../../../auth/domain/entities/portal_user.dart';

class NgoMobileScreen extends StatelessWidget {
  final PortalUser user;
  final VoidCallback onSignOut;
  const NgoMobileScreen({super.key, required this.user, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CareGridPalette.canvas,
      appBar: AppBar(
        title: const CareGridPageTitle('NGO Operations Console'),
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
          Card(
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: CareGridPalette.paleMint, child: Icon(Icons.analytics_outlined, color: CareGridPalette.primary)),
              title: const Text('1,428 Active Beneficiaries', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('PKR 2.45M Subsidy Pool'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: CareGridPalette.goldTint, child: Icon(Icons.verified_outlined, color: CareGridPalette.goldDeep)),
              title: const Text('Active Queue Item', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('19 Pending KYC Applications'),
            ),
          ),
        ],
      ),
    );
  }
}
