import 'package:flutter/material.dart';
import 'dart:io';
import '../../services/firestore_service.dart';
import '../../services/a_service.dart';
import 'package:image_picker/image_picker.dart';

class CropDetailsScreen extends StatefulWidget {
  final String cropId;
  final Map<String, dynamic> cropData;

  CropDetailsScreen({required this.cropId, required this.cropData});

  @override
  _CropDetailsScreenState createState() => _CropDetailsScreenState();
}

class _CropDetailsScreenState extends State<CropDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController quantityController;
  late TextEditingController priceController;
  List<File> newImages = [];
  List<String> existingImages = [];
  final picker = ImagePicker();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.cropData['name']);
    categoryController = TextEditingController(text: widget.cropData['category']);
    quantityController = TextEditingController(text: widget.cropData['quantity'].toString());
    priceController = TextEditingController(text: widget.cropData['price'].toString());
    existingImages = List<String>.from(widget.cropData['images'] ?? []);
  }

  Future pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => newImages.add(File(picked.path)));
  }

  void deleteCrop() async {
    setState(() => loading = true);
    await FirestoreService().deleteCrop(widget.cropId);
    setState(() => loading = false);
    Navigator.pop(context);
  }

  void updateCrop() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      Map<String, dynamic> data = {
        'name': nameController.text.trim(),
        'category': categoryController.text.trim(),
        'quantity': int.parse(quantityController.text.trim()),
        'price': double.parse(priceController.text.trim()),
      };
      // TODO: handle new images upload
      await FirestoreService().updateCrop(widget.cropId, data);
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Crop Updated!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crop Details"),
        actions: [
          IconButton(onPressed: deleteCrop, icon: Icon(Icons.delete, color: Colors.red))
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
                    TextFormField(controller: categoryController, decoration: InputDecoration(labelText: "Category")),
                    TextFormField(controller: quantityController, decoration: InputDecoration(labelText: "Quantity"), keyboardType: TextInputType.number),
                    TextFormField(controller: priceController, decoration: InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: [
                        ...existingImages.map((img) => Image.network(img, width: 80, height: 80, fit: BoxFit.cover)),
                        ...newImages.map((img) => Image.file(img, width: 80, height: 80, fit: BoxFit.cover)),
                        GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: Icon(Icons.add_a_photo),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: updateCrop,
                      child: Text("Update Crop"),
                      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
