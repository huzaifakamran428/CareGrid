import 'dart:async';
import 'package:flutter/material.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../../../app/theme/brand_tokens.dart';
import '../../../../core/widgets/caregrid_brand.dart';
import '../../../auth/domain/entities/portal_user.dart';

class NgoMobileScreen extends StatefulWidget {
  final PortalUser user;
  final VoidCallback onSignOut;
  const NgoMobileScreen({super.key, required this.user, required this.onSignOut});

  @override
  State<NgoMobileScreen> createState() => _NgoMobileScreenState();
}

class _NgoMobileScreenState extends State<NgoMobileScreen> {
  Timer? _timer;
  @override
  void initState() { super.initState(); _timer = Timer.periodic(const Duration(minutes: 1), (_) { if (mounted) setState(() {}); }); }
  @override
  void dispose() { _timer?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final membership = CareGridAuthRepository.memberships[user.email];
    return Scaffold(
      backgroundColor: CareGridPalette.canvas,
      appBar: AppBar(
        title: const CareGridPageTitle('NGO Operations Console'),
        actions: [
          IconButton(
            tooltip: 'Sign Out',
            icon: const Icon(Icons.logout_rounded),
            onPressed: widget.onSignOut,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          if (membership == null || !membership.active)
            Card(child: ListTile(title: const Text('Membership expired'), subtitle: const Text('Contact Membership Admin to renew your license.'), trailing: IconButton(onPressed: widget.onSignOut, icon: const Icon(Icons.logout))))
          else ...[
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
          CareGridPanel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const CareGridSectionTag('Your NGO membership', icon: Icons.verified_user_outlined),
            const SizedBox(height: 10),
            Text(membership.planLabel, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('${membership.daysLeft} days left', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: CareGridPalette.primaryDeep)),
            const SizedBox(height: 6),
            Text('Expires ${MaterialLocalizations.of(context).formatFullDate(membership.expires)}'),
            const SizedBox(height: 10),
            if (membership.daysLeft <= 7)
              const Text('Your membership is ending soon. Contact Membership Admin to continue access.', style: TextStyle(color: CareGridPalette.goldDeep, fontWeight: FontWeight.w700))
            else
              Text(membership.plan == 'Trial' ? 'Contact Membership Admin to activate your yearly license.' : 'Contact Membership Admin to renew your license before expiry.'),
          ])),
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
        ],
      ),
    );
  }
}
