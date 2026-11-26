import 'package:flutter/material.dart';
import 'figma_list_surplus_food_screen.dart' as list;
import 'figma_manage_food_listings_screen.dart' as manage;
import 'figma_surplus_food_quantity_screen.dart' as quantity;
import 'figma_collection_deadline_screen.dart' as deadline;
import '../../../../app/theme/brand_tokens.dart';
import '../../../../core/widgets/caregrid_brand.dart';
import '../../../auth/domain/entities/portal_user.dart';

class RestaurantDashboardScreen extends StatelessWidget {
  final PortalUser user;
  final VoidCallback onSignOut;
  const RestaurantDashboardScreen({super.key, required this.user, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CareGridPalette.canvas,
      appBar: AppBar(
        title: const CareGridPageTitle('Surplus Food Dispatch'),
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
          for (final item in <(String, IconData, Widget)>[
            ('List surplus food', Icons.add_circle_outline, const list.ListSurplusFoodScreen()),
            ('Manage food listings', Icons.list_alt, const manage.ManageFoodListingsScreen()),
            ('Food quantity', Icons.scale_outlined, const quantity.SurplusFoodQuantityScreen()),
            ('Collection deadline', Icons.schedule, const deadline.CollectionDeadlineScreen()),
          ])
            Card(child: ListTile(leading: Icon(item.$2, color: CareGridPalette.primary), title: Text(item.$1), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => item.$3)))),

          Card(
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: CareGridPalette.paleMint, child: Icon(Icons.analytics_outlined, color: CareGridPalette.primary)),
              title: const Text('160 Meals Pledged Today', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('45 Boxes Awaiting Pickup'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: CareGridPalette.goldTint, child: Icon(Icons.verified_outlined, color: CareGridPalette.goldDeep)),
              title: const Text('Active Queue Item', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('Batch #FD-441 • 85 Chicken Pulao Packs'),
            ),
          ),
        ],
      ),
    );
  }
}
