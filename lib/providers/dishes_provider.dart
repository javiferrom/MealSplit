// providers/dishes_provider.dart
import 'package:flutter/material.dart';
import '../models/dish.dart';
import 'package:uuid/uuid.dart';

class DishesProvider extends ChangeNotifier {
  final List<Dish> _dishes = [];

  List<Dish> get dishes => List.unmodifiable(_dishes);

  void addDish(String name, double price) {
    final dish = Dish(id: const Uuid().v4(), name: name, price: price);
    _dishes.add(dish);
    notifyListeners();
  }

  void editDish(String id, String newName, double newPrice) {
    final index = _dishes.indexWhere((d) => d.id == id);
    if (index >= 0) {
      _dishes[index] = Dish(id: id, name: newName, price: newPrice);
      notifyListeners();
    }
  }

  void removeDish(String id) {
    _dishes.removeWhere((d) => d.id == id);
    notifyListeners();
  }
}
