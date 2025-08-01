import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/diners_provider.dart';
import 'providers/dishes_provider.dart';
import 'screens/dishes_screen.dart';
import 'screens/diners_screen.dart';
import 'screens/summary_screen.dart';

void main() {
  runApp(const MealSplitApp());
}

class MealSplitApp extends StatelessWidget {
  const MealSplitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DishesProvider()),
        ChangeNotifierProvider(create: (_) => DinersProvider()),
      ],
      child: MaterialApp(
        title: 'MealSplit',
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            primary: Colors.white,
            onPrimary: Colors.black,
            surface: Colors.grey.shade900,
            onSurface: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.grey.shade900,
          cardTheme: CardThemeData(
            color: Colors.grey.shade800,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.grey.shade900,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey.shade500,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white70),
            bodyMedium: TextStyle(color: Colors.white70),
            headlineSmall: TextStyle(color: Colors.white),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey.shade800,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
        ),
        home: const MainNavigation(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    const DishesScreen(),
    const DinersScreen(),
    const SummaryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Platos'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Comensales'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Resumen'),
        ],
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
