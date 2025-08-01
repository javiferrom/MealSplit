import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/diners_provider.dart';
import '../providers/dishes_provider.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dinersProvider = Provider.of<DinersProvider>(context);
    final dishesProvider = Provider.of<DishesProvider>(context);
    final diners = dinersProvider.diners;
    final dishes = dishesProvider.dishes;

    Map<String, double> amountsPerDiner = {};
    Map<String, int> dishTotals = {};
    double totalGeneral = 0.0;
    final Set<String> sharedDishesCounted = {};

    for (final diner in diners) {
      double total = 0.0;

      diner.consumedDishes.forEach((dishId, info) {
        final dish = dishes.firstWhere((d) => d.id == dishId);

        final sharedConsumers = diners.where((d) {
          final dInfo = d.consumedDishes[dishId];
          return dInfo != null && dInfo.isShared && dInfo.quantity > 0;
        }).toList();

        final divisor = info.isShared && sharedConsumers.isNotEmpty
            ? sharedConsumers.length
            : 1;

        total += (dish.price * info.quantity) / divisor;

        if (info.isShared) {
          if (!sharedDishesCounted.contains(dishId)) {
            dishTotals[dishId] = (dishTotals[dishId] ?? 0) + info.quantity;
            sharedDishesCounted.add(dishId);
          }
        } else {
          dishTotals[dishId] = (dishTotals[dishId] ?? 0) + info.quantity;
        }
      });

      amountsPerDiner[diner.id] = total;
      totalGeneral += total;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Resumen del ticket')),
      body: diners.isEmpty
          ? const Center(child: Text('No hay datos aún.'))
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 16),
                    children: [
                      ...diners.map((diner) {
                        final amount = amountsPerDiner[diner.id] ?? 0;

                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            title: Text(diner.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...diner.consumedDishes.entries.map((entry) {
                                  final dish = dishes.firstWhere((d) => d.id == entry.key);
                                  final quantity = entry.value.quantity;
                                  final shared = entry.value.isShared;

                                  final sharedConsumers = diners.where((d) {
                                    final dInfo = d.consumedDishes[entry.key];
                                    return dInfo != null &&
                                        dInfo.isShared &&
                                        dInfo.quantity > 0;
                                  }).toList();

                                  final divisor = shared && sharedConsumers.isNotEmpty
                                      ? sharedConsumers.length
                                      : 1;

                                  final totalDish = (dish.price * quantity) / divisor;

                                  return Text(
                                      '${dish.name} x$quantity (${shared ? "compartido entre $divisor" : "individual"}) → ${totalDish.toStringAsFixed(2)} €');
                                }),
                                const SizedBox(height: 8),
                                Text(
                                  'Total: ${amount.toStringAsFixed(2)} €',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        );
                      }),

                      const Divider(thickness: 2),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Ticket completo',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),

                      ...dishTotals.entries.map((entry) {
                        final dish = dishes.firstWhere((d) => d.id == entry.key);
                        final quantity = entry.value;
                        final totalPrice = dish.price * quantity;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('${dish.name} x$quantity'),
                              ),
                              Text('${dish.price.toStringAsFixed(2)} €'),
                              const SizedBox(width: 12),
                              Text('= ${totalPrice.toStringAsFixed(2)} €'),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'TOTAL: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${totalGeneral.toStringAsFixed(2)} €',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
