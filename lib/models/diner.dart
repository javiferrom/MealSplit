// models/diner.dart
import 'consumed_dish_info.dart';

class Diner {
  final String id;
  final String name;
  Map<String, ConsumedDishInfo> consumedDishes; // dishId -> info

  Diner({
    required this.id,
    required this.name,
    Map<String, ConsumedDishInfo>? consumedDishes,
  }) : consumedDishes = consumedDishes ?? {};
}
