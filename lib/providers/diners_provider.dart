// providers/diners_provider.dart
import 'package:flutter/material.dart';
import '../models/diner.dart';
import '../models/consumed_dish_info.dart';
import 'package:uuid/uuid.dart';

class DinersProvider extends ChangeNotifier {
  final List<Diner> _diners = [];

  List<Diner> get diners => List.unmodifiable(_diners);

  void addDiner(String name) {
    final diner = Diner(id: const Uuid().v4(), name: name);
    _diners.add(diner);
    notifyListeners();
  }

  void removeDiner(String id) {
    _diners.removeWhere((d) => d.id == id);
    notifyListeners();
  }

  void assignDishToDiner(String dinerId, String dishId, {bool shared = false}) {
    final diner = _diners.firstWhere((d) => d.id == dinerId);
    final current = diner.consumedDishes[dishId];
    if (current != null) {
      current.quantity += 1;
      current.isShared = shared;
    } else {
      diner.consumedDishes[dishId] = ConsumedDishInfo(quantity: 1, isShared: shared);
    }
    notifyListeners();
  }

  void unassignDishFromDiner(String dinerId, String dishId) {
    final diner = _diners.firstWhere((d) => d.id == dinerId);
    final current = diner.consumedDishes[dishId];
    if (current != null) {
      if (current.quantity > 1) {
        current.quantity -= 1;
      } else {
        diner.consumedDishes.remove(dishId);
      }
      notifyListeners();
    }
  }

  void setDishSharedStatus(String dinerId, String dishId, bool isShared) {
    final diner = _diners.firstWhere((d) => d.id == dinerId);
    final current = diner.consumedDishes[dishId];
    if (current != null) {
      current.isShared = isShared;
      notifyListeners();
    }
  }
}
