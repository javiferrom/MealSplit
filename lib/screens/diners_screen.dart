// screens/diners_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/diners_provider.dart';
import '../providers/dishes_provider.dart';

class DinersScreen extends StatelessWidget {
  const DinersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dinersProvider = Provider.of<DinersProvider>(context);
    final dishesProvider = Provider.of<DishesProvider>(context);

    final diners = dinersProvider.diners;
    final dishes = dishesProvider.dishes;

    return Scaffold(
      appBar: AppBar(title: const Text('Comensales')),
      body: diners.isEmpty
          ? const Center(child: Text('No hay comensales aún.'))
          : ListView.builder(
              itemCount: diners.length,
              itemBuilder: (context, index) {
                final diner = diners[index];
                return ExpansionTile(
                  title: Text(diner.name),
                  subtitle: Text(
                      'Platos consumidos: ${diner.consumedDishes.length}'),
                  children: dishes.map((dish) {
                    final consumedInfo = diner.consumedDishes[dish.id];
                    final quantity = consumedInfo?.quantity ?? 0;
                    final isShared = consumedInfo?.isShared ?? false;

                    return ListTile(
                      title: Text('${dish.name} (${dish.price.toStringAsFixed(2)} €)'),
                      subtitle: quantity > 0
                          ? Text('Cantidad: $quantity | Compartido: ${isShared ? "Sí" : "No"}')
                          : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Botón para quitar plato
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: quantity > 0
                                ? () {
                                    dinersProvider.unassignDishFromDiner(diner.id, dish.id);
                                  }
                                : null,
                          ),
                          // Mostrar cantidad
                          Text(quantity.toString()),
                          // Botón para agregar plato
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              dinersProvider.assignDishToDiner(diner.id, dish.id, shared: isShared);
                            },
                          ),
                          // Toggle para compartir
                          Checkbox(
                            value: isShared,
                            onChanged: quantity > 0
                                ? (value) {
                                    dinersProvider.setDishSharedStatus(
                                        diner.id, dish.id, value ?? false);
                                  }
                                : null,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDinerDialog(context),
        tooltip: 'Añadir comensal',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDinerDialog(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Añadir comensal'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                Provider.of<DinersProvider>(context, listen: false).addDiner(name);
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
