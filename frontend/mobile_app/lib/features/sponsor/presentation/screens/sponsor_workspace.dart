import 'package:flutter/material.dart';
import '../../../../core/widgets/caregrid_brand.dart';
import '../../../auth/domain/entities/portal_user.dart';
import 'Sponser.dart' as donation;
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
