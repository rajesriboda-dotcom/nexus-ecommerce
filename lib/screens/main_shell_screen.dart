import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../constants.dart';
import '../models.dart';
import '../providers/app_state.dart';
import '../services/mock_data.dart';
import 'home_screen.dart';
import 'category_screen.dart';
import 'wishlist_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    CategoryScreen(),
    WishlistScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          const NavigationDestination(icon: Icon(Icons.category_rounded), label: 'Categories'),
          NavigationDestination(
            icon: Badge(
              label: Text('${state.wishlist.length}'),
              isLabelVisible: state.wishlist.isNotEmpty,
              child: const Icon(Icons.favorite_border_rounded),
            ),
            label: 'Wishlist',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('${state.orders.length}'),
              isLabelVisible: state.orders.isNotEmpty,
              child: const Icon(Icons.receipt_long_rounded),
            ),
            label: 'Orders',
          ),
          const NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
