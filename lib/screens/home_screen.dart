import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../services/firestore_service.dart';
import '../services/cache_service.dart';
import '../services/network_service.dart';
import '../screens/marketplace_screen.dart';
import '../screens/market_prices_tab.dart';
import '../widgets/crop_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MarketPricesTab(),  // your existing crop list logic
    const MarketplaceScreen(), // your marketplace screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Prices'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Marketplace'),
        ],
      ),
    );
  }
}

