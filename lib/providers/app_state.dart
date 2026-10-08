import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import '../services/mock_data.dart';

class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  final List<CartItem> _cart = [];
  final List<Product> _wishlist = [];
  final List<Order> _orders = List.from(MockData.orders);
  final List<String> _recentSearches = ['laptop', 'watch', 'phone'];
  String _selectedCategory = 'All';

  ThemeMode get themeMode => _themeMode;
  List<CartItem> get cart => _cart;
  List<Product> get wishlist => _wishlist;
  List<Order> get orders => _orders;
  List<String> get recentSearches => _recentSearches;
  String get selectedCategory => _selectedCategory;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void addToCart(Product product, {int quantity = 1}) {
    final existing = _cart.indexWhere((item) => item.product.id == product.id);
    if (existing >= 0) {
      _cart[existing].quantity += quantity;
    } else {
      _cart.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQty(String productId, int delta) {
    final index = _cart.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      final newQty = _cart[index].quantity + delta;
      if (newQty <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index].quantity = newQty;
      }
      notifyListeners();
    }
  }

  void addToWishlist(Product product) {
    if (!_wishlist.any((item) => item.id == product.id)) {
      _wishlist.add(product);
      notifyListeners();
    }
  }

  void removeFromWishlist(String productId) {
    _wishlist.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  double get cartSubtotal => _cart.fold(0, (sum, item) => sum + item.subtotal);

  double get cartDiscount => _cart.fold(0.0, (sum, item) => sum + (item.product.price - item.product.discountPrice) * item.quantity * 0.5);

  double get deliveryCharge => cartSubtotal > 0 ? 99 : 0;

  double get tax => cartSubtotal * 0.08;

  double get grandTotal => cartSubtotal + deliveryCharge + tax - cartDiscount;

  void addRecentSearch(String term) {
    if (term.trim().isEmpty) return;
    _recentSearches.remove(term);
    _recentSearches.insert(0, term);
    if (_recentSearches.length > 6) {
      _recentSearches.removeLast();
    }
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  bool isInWishlist(String productId) => _wishlist.any((product) => product.id == productId);

  void placeOrder() {
    if (_cart.isEmpty) return;
    final now = DateTime.now();
    final total = grandTotal;
    _orders.insert(
      0,
      Order(
        id: 'ORD-${now.millisecondsSinceEpoch.toString().substring(7)}',
        status: 'Ordered',
        date: '${now.day}/${now.month}/${now.year}',
        total: total,
        items: List.from(_cart),
      ),
    );
    _cart.clear();
    notifyListeners();
  }
}
