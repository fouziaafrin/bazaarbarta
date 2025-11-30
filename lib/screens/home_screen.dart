import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../services/firestore_service.dart';
import '../widgets/crop_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FirestoreService().getCropsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final crops = snapshot.data!;

          return ListView.builder(
            itemCount: crops.length,
            itemBuilder: (context, index) {
              final c = crops[index];
              return CropCard(
                name: lang == 'en' ? c['name_en'] : c['name_bn'],
                price: "${c['price']} ৳",
                unit: "per ${c['unit']}",
              );
            },
          );
        },
      ),
    );
  }
}
