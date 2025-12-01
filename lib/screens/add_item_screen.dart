import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../services/marketplace_service.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final name = TextEditingController();
  final price = TextEditingController();
  final phone = TextEditingController();
  final unit = TextEditingController();
  final stock = TextEditingController();

  final List<XFile> images = [];
  final ImagePicker _picker = ImagePicker();
  bool uploading = false;

  /// Pick images from gallery
  Future<void> pickImage() async {
    if (images.length >= 3) return; // limit to 3 images
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => images.add(picked));
    }
  }

  /// Upload images to Firebase Storage and return list of URLs
  Future<List<String>> uploadImages() async {
    final storage = firebase_storage.FirebaseStorage.instance;
    List<String> urls = [];
    for (var img in images) {
      final ref = storage.ref().child("marketplace/${DateTime.now().millisecondsSinceEpoch}_${img.name}");
      final task = await ref.putFile(File(img.path));
      final url = await task.ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  /// Publish the item
  Future<void> publishItem() async {
    if (name.text.isEmpty || price.text.isEmpty || phone.text.isEmpty) return;
    setState(() => uploading = true);

    final imageUrls = await uploadImages();

    await MarketplaceService().addItem({
        "name": name.text.trim(),
        "price": double.tryParse(price.text) ?? 0,
        "ownerUid": FirebaseAuth.instance.currentUser?.uid ?? "",
        "ownerPhone": phone.text.trim(),
        "unit": unit.text.trim(),
        "stock": int.tryParse(stock.text) ?? 0,
        "imageUrls": imageUrls,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
    });

    setState(() => uploading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post for Sale")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: name, decoration: const InputDecoration(labelText: "Item name")),
              TextField(controller: price, decoration: const InputDecoration(labelText: "Price")),
              TextField(controller: unit, decoration: const InputDecoration(labelText: "Unit (e.g., kg, pcs)")),
              TextField(controller: stock, decoration: const InputDecoration(labelText: "Stock")),
              TextField(controller: phone, decoration: const InputDecoration(labelText: "Phone / WhatsApp")),
              const SizedBox(height: 16),
              
              // Image previews + add button
              Wrap(
                spacing: 8,
                children: [
                  ...images.map((img) => Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.file(File(img.path), width: 80, height: 80, fit: BoxFit.cover),
                          GestureDetector(
                            onTap: () => setState(() => images.remove(img)),
                            child: const Icon(Icons.close, color: Colors.red),
                          ),
                        ],
                      )),
                  if (images.length < 3)
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.add),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),

              uploading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: publishItem,
                      child: const Text("Publish"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
