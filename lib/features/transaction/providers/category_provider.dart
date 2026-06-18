import 'package:expense_tracker_app/features/transaction/models/category.dart';
import 'package:expense_tracker_app/core/default_data/default_data.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  final List<Category> _items = [];

  CategoryProvider() {
    _items.addAll([
      Category(
        id: "sport", 
        name: "Sport", 
        imageAssets: defaultIconAssets[0]
      ),
      Category(
        id: "nourriture",
        name: "Nourriture",
        imageAssets: defaultIconAssets[1],
      ),
      Category(
        id: "shopping",
        name: "Shopping",
        imageAssets: defaultIconAssets[2],
      ),
      Category(
        id: "salaire",
        name: "Salaire",
        imageAssets: defaultIconAssets[3],
      ),
    ]);
  }
  List<Category> get all => List.unmodifiable(_items);
}
