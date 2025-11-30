import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../widgets/crop_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Map<String, String>> crops = [
    {'name': 'Potato', 'bn': 'আলু', 'price': '28 ৳/kg'},
    {'name': 'Tomato', 'bn': 'টমেটো', 'price': '45 ৳/kg'},
    {'name': 'Onion',  'bn': 'পেঁয়াজ', 'price': '65 ৳/kg'},
    {'name': 'Rice',   'bn': 'চাল', 'price': '55 ৳/kg'},
  ];

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>().lang;
    final t = context.watch<LanguageService>().text;

    return Scaffold(
      appBar: AppBar(
        title: Text(t['marketPrices']!),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) => context.read<LanguageService>().switchLang(v),
            itemBuilder: (context) => [
              PopupMenuItem(value: "en", child: Text(t['english']!)),
              PopupMenuItem(value: "bn", child: Text(t['bangla']!)),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          itemCount: crops.length,
          itemBuilder: (context, index) {
            final crop = crops[index];
            return CropCard(
              name: lang == 'en' ? crop['name']! : crop['bn']!,
              price: crop['price']!,
              unit: 'per kg',
            );
          },
        ),
      ),
    );
  }
}
