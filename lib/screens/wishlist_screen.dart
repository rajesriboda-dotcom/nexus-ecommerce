import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import '../providers/app_state.dart';
import '../services/mock_data.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: appState.wishlist.isEmpty
          ? const Center(child: Text('Your wishlist is empty'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appState.wishlist.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                final product = appState.wishlist[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                        child: CachedNetworkImage(
                          imageUrl: product.imageUrls.first,
                          height: 130,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 8),
                            Text(product.formattedDiscountPrice, style: const TextStyle(fontWeight: FontWeight.w800)),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => appState.addToCart(product),
                              child: const Text('Move to cart'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appState.orders.length,
        itemBuilder: (context, index) {
          final order = appState.orders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(order.id, style: const TextStyle(fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Text(order.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Placed on ${order.date}'),
                const SizedBox(height: 12),
                ...order.items.map((item) => Text('${item.product.name} × ${item.quantity}')).toList(),
                const Divider(),
                Row(
                  children: [
                    const Text('Total'),
                    const Spacer(),
                    Text('₹${order.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = MockData.userProfile;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const CircleAvatar(radius: 30, child: Icon(Icons.person_rounded)),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22)),
                      Text(profile.email),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _InfoTile(icon: Icons.receipt_long_rounded, title: 'My Orders', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()))),
            _InfoTile(icon: Icons.favorite_rounded, title: 'Wishlist', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WishlistScreen()))),
            _InfoTile(icon: Icons.location_on_outlined, title: 'Addresses', onTap: () {}),
            _InfoTile(icon: Icons.settings_rounded, title: 'Settings', onTap: () {}),
            _InfoTile(icon: Icons.dashboard_rounded, title: 'Admin Dashboard', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()))),
            _InfoTile(icon: Icons.logout_rounded, title: 'Logout', onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _InfoTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
