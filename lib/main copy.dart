import 'package:flutter/material.dart';

void main() {
  runApp(const MealSplitApp());
}

class MealSplitApp extends StatelessWidget {
  const MealSplitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealSplit',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const MealSplitScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MealSplitScreen extends StatefulWidget {
  const MealSplitScreen({super.key});

  @override
  _MealSplitScreenState createState() => _MealSplitScreenState();
}

class _MealSplitScreenState extends State<MealSplitScreen> {
  final _plates = <Plate>[];
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _peopleController = TextEditingController();
  String _result = '';

  void _addPlate() {
    final name = _nameController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final people = _peopleController.text.split(',').map((s) => s.trim()).toList();

    if (name.isNotEmpty && price > 0 && people.isNotEmpty) {
      setState(() {
        _plates.add(Plate(name, price, people));
        _nameController.clear();
        _priceController.clear();
        _peopleController.clear();
      });
    }
  }

  void _editPlate(int index) {
    final plate = _plates[index];
    _nameController.text = plate.name;
    _priceController.text = plate.price.toString();
    _peopleController.text = plate.people.join(', ');

    _deletePlate(index);
  }

  void _deletePlate(int index) {
    setState(() {
      _plates.removeAt(index);
    });
  }

  void _calculateSplit() {
    final totalPerPerson = <String, double>{};

    for (final plate in _plates) {
      final sharedPrice = plate.price / plate.people.length;
      for (final person in plate.people) {
        totalPerPerson[person] = (totalPerPerson[person] ?? 0) + sharedPrice;
      }
    }

    setState(() {
      _result = 'Total por persona:\n';
      totalPerPerson.forEach((person, total) {
        _result += '$person: €${total.toStringAsFixed(2)}\n';
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MealSplit'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del plato',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Precio (€)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _peopleController,
              decoration: const InputDecoration(
                labelText: 'Personas (separadas por coma)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addPlate,
              child: const Text('Agregar Plato'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _calculateSplit,
              child: const Text('Calcular'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _plates.length,
                itemBuilder: (context, index) {
                  final plate = _plates[index];
                  return ListTile(
                    title: Text('${plate.name} - €${plate.price.toStringAsFixed(2)}'),
                    subtitle: Text('Compartido por: ${plate.people.join(', ')}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editPlate(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deletePlate(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Text(
              _result,
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class Plate {
  final String name;
  final double price;
  final List<String> people;

  Plate(this.name, this.price, this.people);
}
