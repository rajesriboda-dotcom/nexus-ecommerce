import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import '../providers/app_state.dart';
import '../services/mock_data.dart';
import 'product_detail_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final inWishlist = appState.isInWishlist(product.id);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => (inWishlist ? appState.removeFromWishlist(product.id) : appState.addToWishlist(product)),
            icon: Icon(inWishlist ? Icons.favorite_rounded : Icons.favorite_border_rounded),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_rounded)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: CachedNetworkImage(
                imageUrl: product.imageUrls.first,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.brand, style: TextStyle(color: Colors.blueGrey.shade600)),
                      const SizedBox(height: 6),
                      Text(product.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.orange, size: 18),
                      Text(' ${product.rating}'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(product.formattedDiscountPrice, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                const SizedBox(width: 12),
                Text(product.formattedPrice, style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey.shade500, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Includes EMI and free delivery', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600)),
            const SizedBox(height: 18),
            const Text('Available colors', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              children: product.colors.map((color) => ChoiceChip(label: Text(color), selected: false, onSelected: (_) {})).toList(),
            ),
            const SizedBox(height: 18),
            const Text('Available sizes', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              children: product.sizes.map((size) => ChoiceChip(label: Text(size), selected: false, onSelected: (_) {})).toList(),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => appState.addToCart(product),
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text('Add to Cart'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                    icon: const Icon(Icons.flash_on_rounded),
                    label: const Text('Buy Now'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Description', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
            const SizedBox(height: 10),
            Text(product.description),
            const SizedBox(height: 20),
            const Text('Specifications', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
            const SizedBox(height: 10),
            ...product.specifications.map((spec) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Text(spec)),
                    ],
                  ),
                )),
            const SizedBox(height: 20),
            const Text('Reviews', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
            const SizedBox(height: 12),
            ...MockData.sampleReviews.map((review) => Card(
                  child: ListTile(
                    title: Text(review.userName),
                    subtitle: Text(review.comment),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) => Icon(Icons.star_rounded, color: index < review.rating ? Colors.orange : Colors.grey, size: 16)),
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            const Text('Seller details', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
            const SizedBox(height: 10),
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.storefront_rounded)),
              title: Text(product.seller.name),
              subtitle: Text('${product.seller.location} • ${product.seller.rating} rating'),
            ),
            const SizedBox(height: 20),
            const Text('Related products', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: MockData.products.length > 5 ? 5 : MockData.products.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final relatedProduct = MockData.products[index];
                  return ProductCard(product: relatedProduct, width: 180);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const Text('Delivery address', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Theme.of(context).cardColor,
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Home', style: TextStyle(fontWeight: FontWeight.w700)),
                        SizedBox(height: 8),
                        Text('14, Green Acres Residency, Bengaluru, Karnataka - 560103'),
                        SizedBox(height: 6),
                        Text('Phone: 9876543210'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                  const SizedBox(height: 10),
                  ...MockData.paymentMethods.map((method) => RadioListTile(
                        value: method.name,
                        groupValue: 'UPI',
                        onChanged: (_) {},
                        title: Text(method.name),
                        secondary: Icon(method.icon),
                      )),
                  const SizedBox(height: 20),
                  const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      children: [
                        Row(children: [const Text('Subtotal'), const Spacer(), Text('₹${appState.cartSubtotal.toStringAsFixed(0)}')]),
                        const SizedBox(height: 6),
                        Row(children: [const Text('Delivery'), const Spacer(), Text('₹${appState.deliveryCharge.toStringAsFixed(0)}')]),
                        const SizedBox(height: 6),
                        Row(children: [const Text('Tax'), const Spacer(), Text('₹${appState.tax.toStringAsFixed(0)}')]),
                        const Divider(),
                        Row(children: [const Text('Total'), const Spacer(), Text('₹${appState.grandTotal.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.w800))]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
}
