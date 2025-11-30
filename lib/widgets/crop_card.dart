import 'package:flutter/material.dart';

class CropCard extends StatelessWidget {
  final String name;
  final String price;
  final String unit;

  const CropCard({
    super.key,
    required this.name,
    required this.price,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.eco, size: 34),
        title: Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        subtitle: Text(unit),
        trailing: Text(
          price,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
