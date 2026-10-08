import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../constants.dart';
import '../models.dart';
import '../providers/app_state.dart';
import '../services/mock_data.dart';
import '../utils/responsive.dart';
import 'category_screen.dart';
import 'product_listing_screen.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'admin_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _currentBanner = 0;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isMobile = ResponsiveBuilder.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1E3A8A), Color(0xFF14B8A6)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'N',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              AppStrings.appName,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())), icon: const Icon(Icons.shopping_cart_outlined)),
          IconButton(onPressed: () => appState.toggleTheme(), icon: const Icon(Icons.brightness_6_rounded)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(appState),
              const SizedBox(height: 18),
              _buildLocationRow(),
              const SizedBox(height: 18),
              _buildBannerCarousel(),
              const SizedBox(height: 22),
              _buildSectionHeader('Shop by category', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryScreen()))),
              const SizedBox(height: 12),
              _buildCategoryGrid(),
              const SizedBox(height: 22),
              _buildSectionHeader('Popular products', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductListingScreen(title: 'Popular products')))),
              const SizedBox(height: 12),
              _buildProductHorizontalList(MockData.products.take(5).toList()),
              const SizedBox(height: 22),
              _buildSectionHeader('Trending deals', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductListingScreen(title: 'Trending deals')))),
              const SizedBox(height: 12),
              _buildProductGrid(MockData.products.take(4).toList()),
              const SizedBox(height: 22),
              _buildSectionHeader('New arrivals', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductListingScreen(title: 'New arrivals')))),
              const SizedBox(height: 12),
              _buildProductGrid(MockData.products.where((p) => p.isNewArrival).toList()),
              const SizedBox(height: 22),
              _buildSectionHeader('Recommended for you', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductListingScreen(title: 'Recommended')))),
              const SizedBox(height: 12),
              _buildProductHorizontalList(MockData.products.skip(2).take(5).toList()),
              const SizedBox(height: 22),
              _buildSectionHeader('Best sellers', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductListingScreen(title: 'Best sellers')))),
              const SizedBox(height: 12),
              _buildProductGrid(MockData.products.where((p) => p.isFeatured).toList()),
              const SizedBox(height: 22),
              _buildSectionHeader('Recently viewed', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductListingScreen(title: 'Recently viewed')))),
              const SizedBox(height: 12),
              _buildProductHorizontalList(MockData.products.reversed.take(4).toList()),
              const SizedBox(height: 28),
              _buildFooter(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(AppState appState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search products, brands, categories',
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                appState.addRecentSearch(value);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductListingScreen(title: 'Search results', query: value),
                  ),
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.mic_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow() {
    return Row(
      children: [
        const Icon(Icons.location_on_outlined, color: Colors.blue),
        const SizedBox(width: 8),
        Text('Deliver to Bengaluru', style: Theme.of(context).textTheme.bodyLarge),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: const Text('Login / Register'),
        )
      ],
    );
  }

  Widget _buildBannerCarousel() {
    final banner = MockData.banners[_currentBanner];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductListingScreen(title: banner.title)),
        );
      },
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: banner.color,
          image: DecorationImage(
            image: CachedNetworkImageProvider(banner.imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.25), BlendMode.darken),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('LIMITED OFFER', style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 1.2)),
              ),
              const Spacer(),
              Text(
                banner.title,
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                banner.subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: const Text('Shop now', style: TextStyle(color: Colors.black)),
                  ),
                  const Spacer(),
                  Row(
                    children: List.generate(
                      MockData.banners.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _currentBanner == index ? 24 : 8,
                        height: 8,
                        margin: const EdgeInsets.only(left: 6),
                        decoration: BoxDecoration(
                          color: _currentBanner == index ? Colors.white : Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const Spacer(),
        TextButton(onPressed: onTap, child: const Text('View all')),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: MockData.categories.length > 12 ? 12 : MockData.categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final category = MockData.categories[index];
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductListingScreen(title: category.name, category: category.name)),
          ),
          child: Column(
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.tertiary]),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(category.icon, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 8),
              Text(category.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12), maxLines: 2),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductHorizontalList(List<Product> products) {
    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(product: product, width: 180);
        },
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product, width: 180);
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nexus Commerce', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22)),
          const SizedBox(height: 10),
          const Text('Curated shopping experiences for modern living.'),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: const [
              Text('About'),
              Text('Support'),
              Text('Careers'),
              Text('Privacy'),
              Text('Terms'),
              Text('Sitemap'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final double width;

  const ProductCard({super.key, required this.product, required this.width});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final inWishlist = appState.isInWishlist(product.id);
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
          ),
          child: Container(
            width: width,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrls.first,
                        fit: BoxFit.cover,
                        height: 150,
                        width: double.infinity,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          if (inWishlist) {
                            appState.removeFromWishlist(product.id);
                          } else {
                            appState.addToWishlist(product);
                          }
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            inWishlist ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: inWishlist ? Colors.red : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${product.discountPercentage}% OFF',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.brand, style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                      const SizedBox(height: 4),
                      Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF5B700), size: 16),
                          Text('${product.rating} (${product.reviewCount})', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(product.formattedDiscountPrice, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                          const SizedBox(width: 8),
                          Text(product.formattedPrice, style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => appState.addToCart(product),
                          icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                          label: const Text('Add to cart'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
