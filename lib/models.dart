import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final String brand;
  final List<String> imageUrls;
  final double price;
  final double discountPrice;
  final int discountPercentage;
  final double rating;
  final int reviewCount;
  final int stock;
  final String description;
  final List<String> specifications;
  final List<String> colors;
  final List<String> sizes;
  final Seller seller;
  final String deliveryInfo;
  final String returnPolicy;
  final String warrantyInfo;
  final bool isFeatured;
  final bool isNewArrival;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.brand,
    required this.imageUrls,
    required this.price,
    required this.discountPrice,
    required this.discountPercentage,
    required this.rating,
    required this.reviewCount,
    required this.stock,
    required this.description,
    required this.specifications,
    required this.colors,
    required this.sizes,
    required this.seller,
    required this.deliveryInfo,
    required this.returnPolicy,
    required this.warrantyInfo,
    this.isFeatured = false,
    this.isNewArrival = false,
  });

  String get formattedPrice => '₹${price.toStringAsFixed(0)}';
  String get formattedDiscountPrice => '₹${discountPrice.toStringAsFixed(0)}';
}

class Seller {
  final String name;
  final String location;
  final double rating;
  final int positiveReviews;

  Seller({
    required this.name,
    required this.location,
    required this.rating,
    required this.positiveReviews,
  });
}

class CategoryItem {
  final String id;
  final String name;
  final IconData icon;
  final String imageUrl;

  CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.imageUrl,
  });
}

class Review {
  final String userName;
  final double rating;
  final String comment;
  final String date;
  final List<String>? imageUrls;

  Review({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
    this.imageUrls,
  });
}

class PromoBanner {
  final String title;
  final String subtitle;
  final String imageUrl;
  final Color color;

  PromoBanner({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.color,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  double get subtotal => product.discountPrice * quantity;
}

class Address {
  final String id;
  final String type;
  final String line1;
  final String city;
  final String state;
  final String zip;
  final String phone;

  Address({
    required this.id,
    required this.type,
    required this.line1,
    required this.city,
    required this.state,
    required this.zip,
    required this.phone,
  });
}

class PaymentMethod {
  final String name;
  final IconData icon;

  PaymentMethod({required this.name, required this.icon});
}

class Coupon {
  final String code;
  final String description;
  final double discountAmount;

  Coupon({
    required this.code,
    required this.description,
    required this.discountAmount,
  });
}

class UserProfile {
  final String name;
  final String email;
  final String mobile;
  final String city;

  UserProfile({
    required this.name,
    required this.email,
    required this.mobile,
    required this.city,
  });
}

class Order {
  final String id;
  final String status;
  final String date;
  final double total;
  final List<CartItem> items;

  Order({
    required this.id,
    required this.status,
    required this.date,
    required this.total,
    required this.items,
  });
}
