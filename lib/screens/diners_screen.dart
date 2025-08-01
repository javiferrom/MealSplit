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
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(diner.name)),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        tooltip: 'Editar comensal',
                        onPressed: () => _showEditDinerDialog(context, diner, dinersProvider),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        tooltip: 'Eliminar comensal',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Eliminar comensal'),
                              content: Text('¿Seguro que quieres eliminar a ${diner.name}?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    dinersProvider.removeDiner(diner.id);
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text('Eliminar'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  children: dishes.map((dish) {
                    final consumedInfo = diner.consumedDishes[dish.id];
                    final quantity = consumedInfo?.quantity ?? 0;
                    final isShared = consumedInfo?.isShared ?? false;

                    return ListTile(
                      title: Text(dish.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: quantity > 0
                                ? () {
                                    dinersProvider.unassignDishFromDiner(diner.id, dish.id);
                                  }
                                : null,
                          ),
                          Text(quantity.toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              dinersProvider.assignDishToDiner(diner.id, dish.id, shared: isShared);
                            },
                          ),
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

  void _showEditDinerDialog(BuildContext context, diner, DinersProvider dinersProvider) {
    final nameController = TextEditingController(text: diner.name);
    String? nameError;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Editar comensal'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Nombre',
              errorText: nameError,
            ),
            onChanged: (_) => setState(() => nameError = null),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  dinersProvider.updateDinerName(diner.id, newName);
                  Navigator.pop(context);
                } else {
                  setState(() => nameError = 'El nombre no puede estar vacío');
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
