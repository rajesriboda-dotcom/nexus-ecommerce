import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import '../providers/app_state.dart';
import '../services/mock_data.dart';
import 'product_detail_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list_rounded)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: MockData.categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final category = MockData.categories[index];
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProductListingScreen(title: category.name, category: category.name)),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(category.imageUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.28), BlendMode.darken),
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      category.name,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProductListingScreen extends StatefulWidget {
  final String title;
  final String? query;
  final String? category;

  const ProductListingScreen({super.key, required this.title, this.query, this.category});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  String sortBy = 'Relevance';
  String selectedBrand = 'All';
  double minPrice = 0;

  List<Product> _filteredProducts() {
    Iterable<Product> products = MockData.products;
    if (widget.category != null && widget.category!.isNotEmpty && widget.category != 'All') {
      products = products.where((p) => p.category == widget.category);
    }
    if (widget.query != null && widget.query!.isNotEmpty) {
      final q = widget.query!.toLowerCase();
      products = products.where((p) => p.name.toLowerCase().contains(q) || p.brand.toLowerCase().contains(q) || p.category.toLowerCase().contains(q));
    }
    if (selectedBrand != 'All') {
      products = products.where((p) => p.brand == selectedBrand);
    }
    products = products.where((p) => p.discountPrice >= minPrice);

    switch (sortBy) {
      case 'Price Low to High':
        return products.toList()..sort((a, b) => a.discountPrice.compareTo(b.discountPrice));
      case 'Price High to Low':
        return products.toList()..sort((a, b) => b.discountPrice.compareTo(a.discountPrice));
      case 'Customer Rating':
        return products.toList()..sort((a, b) => b.rating.compareTo(a.rating));
      case 'Newest':
        return products.toList()..sort((a, b) => b.isNewArrival == a.isNewArrival ? 0 : (b.isNewArrival ? 1 : 0));
      default:
        return products.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts();
    final brands = ['All', ...MockData.products.map((p) => p.brand).toSet()];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.sort_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_alt_rounded)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: sortBy,
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: const [
                      'Relevance',
                      'Price Low to High',
                      'Price High to Low',
                      'Customer Rating',
                      'Newest',
                    ].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                    onChanged: (value) => setState(() => sortBy = value ?? 'Relevance'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedBrand,
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: brands.map((brand) => DropdownMenuItem(value: brand, child: Text(brand))).toList(),
                    onChanged: (value) => setState(() => selectedBrand = value ?? 'All'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Slider(
              min: 0,
              max: 100000,
              value: minPrice,
              onChanged: (value) => setState(() => minPrice = value),
              label: 'Min: ₹${minPrice.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 8),
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text('No products found'))
                  : GridView.builder(
                      itemCount: products.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (context, index) {
                        return ProductCard(product: products[index], width: 190);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final cart = appState.cart;

    if (cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: const Center(child: Text('Your cart is empty')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: cart.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = cart[index];
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: item.product.imageUrls.first,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              Text('₹${item.product.discountPrice} x ${item.quantity}', style: const TextStyle(fontSize: 13)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  IconButton(onPressed: () => appState.updateQty(item.product.id, -1), icon: const Icon(Icons.remove_circle_outline_rounded)),
                                  Text('${item.quantity}'),
                                  IconButton(onPressed: () => appState.updateQty(item.product.id, 1), icon: const Icon(Icons.add_circle_outline_rounded)),
                                ],
                              )
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => appState.removeFromCart(item.product.id),
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  _summaryRow('Subtotal', '₹${appState.cartSubtotal.toStringAsFixed(0)}'),
                  _summaryRow('Discount', '-₹${appState.cartDiscount.toStringAsFixed(0)}'),
                  _summaryRow('Delivery', '₹${appState.deliveryCharge.toStringAsFixed(0)}'),
                  _summaryRow('Tax', '₹${appState.tax.toStringAsFixed(0)}'),
                  const Divider(),
                  _summaryRow('Total', '₹${appState.grandTotal.toStringAsFixed(0)}', bold: true),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                      child: const Text('Proceed to checkout'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label),
          const Spacer(),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w500)),
        ],
      ),
    );
  }
}

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final selectedAddress = MockData.addresses.first;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(selectedAddress.type, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text('${selectedAddress.line1}, ${selectedAddress.city}, ${selectedAddress.state} - ${selectedAddress.zip}'),
                  const SizedBox(height: 6),
                  Text('Phone: ${selectedAddress.phone}'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
            const SizedBox(height: 12),
            ...MockData.paymentMethods.map((method) => RadioListTile<String>(
                  value: method.name,
                  groupValue: 'UPI',
                  onChanged: (_) {},
                  title: Row(
                    children: [
                      Icon(method.icon),
                      const SizedBox(width: 10),
                      Text(method.name),
                    ],
                  ),
                )),
            const SizedBox(height: 20),
            const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  _summaryRow('Subtotal', '₹${appState.cartSubtotal.toStringAsFixed(0)}'),
                  _summaryRow('Delivery', '₹${appState.deliveryCharge.toStringAsFixed(0)}'),
                  _summaryRow('Tax', '₹${appState.tax.toStringAsFixed(0)}'),
                  const Divider(),
                  _summaryRow('Total', '₹${appState.grandTotal.toStringAsFixed(0)}', bold: true),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  appState.placeOrder();
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderConfirmationScreen()));
                },
                child: const Text('Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label),
          const Spacer(),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w500)),
        ],
      ),
    );
  }
}

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 48, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text('Order placed successfully!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              const Text('You will receive tracking updates soon.'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MainScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainShellScreen();
  }
}
