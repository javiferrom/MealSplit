import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dishes_provider.dart';

class DishesScreen extends StatelessWidget {
  const DishesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dishesProvider = Provider.of<DishesProvider>(context);
    final dishes = dishesProvider.dishes;

    return Scaffold(
      appBar: AppBar(title: const Text('Platos')),
      body: dishes.isEmpty
          ? const Center(child: Text('No hay platos aún.'))
          : ListView.builder(
              itemCount: dishes.length,
              itemBuilder: (context, index) {
                final dish = dishes[index];
                return ListTile(
                  title: Text(dish.name),
                  subtitle: Text('${dish.price.toStringAsFixed(2)} €'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Editar',
                        onPressed: () =>
                            _showEditDishDialog(context, dish, dishesProvider),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Eliminar',
                        onPressed: () => dishesProvider.removeDish(dish.id),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDishDialog(context),
        tooltip: 'Añadir plato',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDishDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    String? priceError;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Añadir plato'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Precio',
                  errorText: priceError,
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) {
                  setState(() {
                    priceError = null;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final price = double.tryParse(priceController.text) ?? 0;

                if (name.isNotEmpty && price > 0) {
                  Provider.of<DishesProvider>(context, listen: false)
                      .addDish(name, price);
                  Navigator.pop(context);
                } else {
                  setState(() {
                    priceError = 'Ingrese un precio válido';
                  });
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDishDialog(
      BuildContext context, dish, DishesProvider dishesProvider) {
    final nameController = TextEditingController(text: dish.name);
    final priceController = TextEditingController(text: dish.price.toString());
    String? priceError;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Editar plato'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Precio',
                  errorText: priceError,
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) {
                  setState(() {
                    priceError = null;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text.trim();
                final newPrice = double.tryParse(priceController.text) ?? 0;

                if (newName.isNotEmpty && newPrice > 0) {
                  dishesProvider.editDish(dish.id, newName, newPrice);
                  Navigator.pop(context);
                } else {
                  setState(() {
                    priceError = 'Ingrese un precio válido';
                  });
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
