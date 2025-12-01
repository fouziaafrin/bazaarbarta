import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MarketItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const MarketItemCard({super.key, required this.item});

  void _call(String number) async {
    final uri = Uri(scheme: "tel", path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _whatsapp(String number) async {
    final uri = Uri.parse("https://wa.me/$number");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();
    final name = item["name"] ?? "";
    final price = item["price"] ?? 0;
    final phone = item["ownerPhone"] ?? "";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              "${lang.text['price'] ?? 'Price'}: $price ৳",
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.call),
                  onPressed: () => _call(phone),
                  label: Text(lang.text['call'] ?? 'Call'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(FontAwesomeIcons.whatsapp),
                  onPressed: () => _whatsapp(phone),
                  label: const Text("WhatsApp"),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              "${lang.text['seller'] ?? 'Seller'}: $phone",
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
