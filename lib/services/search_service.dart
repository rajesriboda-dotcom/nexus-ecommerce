import 'package:flutter/material.dart';

class SearchService {
  static List<T> search<T>(
    List<T> items,
    String query, {
    required String Function(T) label,
  }) {
    if (query.trim().isEmpty) return items;
    final lower = query.toLowerCase();
    return items.where((item) {
      return label(item).toLowerCase().contains(lower);
    }).toList();
  }
}
