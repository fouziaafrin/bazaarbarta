import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/marketplace_service.dart';
import '../widgets/market_item_card.dart';
import '../services/language_service.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.text['marketPrices'] ?? 'Marketplace'),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/addItem");
        },
      ),

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: MarketplaceService().getItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;

          if (items.isEmpty) {
            return Center(
              child: Text(
                lang.text['no_items_yet'] ?? 'No items yet',
                style: const TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final item = items[i];
              return MarketItemCard(item: item);
            },
          );
        },
      ),
    );
  }
}
