import 'consumed_dish_info.dart';

class Diner {
  final String id;
  String name;
  Map<String, ConsumedDishInfo> consumedDishes;

  Diner({
    required this.id,
    required this.name,
    Map<String, ConsumedDishInfo>? consumedDishes,
  }) : consumedDishes = consumedDishes ?? {};
}
