import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import '../providers/app_state.dart';
import '../services/mock_data.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _StatCard(title: 'Total Products', value: '1284', color: Colors.blue),
                _StatCard(title: 'Total Users', value: '22.4K', color: Colors.green),
                _StatCard(title: 'Total Orders', value: '8.7K', color: Colors.orange),
                _StatCard(title: 'Revenue', value: '₹45.2L', color: Colors.purple),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Low Stock', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
            const SizedBox(height: 12),
            ...MockData.products.take(3).map((product) => ListTile(
                  leading: CircleAvatar(child: Text(product.id.substring(1, 3))),
                  title: Text(product.name),
                  subtitle: Text('Stock: ${product.stock}'),
                  trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.edit_rounded)),
                )),
            const SizedBox(height: 20),
            const Text('Recent Orders', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
            const SizedBox(height: 12),
            ...MockData.orders.map((order) => ListTile(
                  title: Text(order.id),
                  subtitle: Text(order.status),
                  trailing: Text('₹${order.total.toStringAsFixed(0)}'),
                )),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({super.key, required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
