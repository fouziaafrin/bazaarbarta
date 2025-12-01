import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../services/firestore_service.dart';
import '../../services/a_service.dart';

class AddCropScreen extends StatefulWidget {
  @override
  _AddCropScreenState createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  List<File> images = [];
  bool loading = false;

  final picker = ImagePicker();

  Future pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => images.add(File(picked.path)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Crop")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(controller: nameController, decoration: InputDecoration(labelText: "Crop Name"), validator: (v) => v!.isEmpty ? "Enter name" : null),
                    TextFormField(controller: categoryController, decoration: InputDecoration(labelText: "Category"), validator: (v) => v!.isEmpty ? "Enter category" : null),
                    TextFormField(controller: quantityController, decoration: InputDecoration(labelText: "Quantity"), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? "Enter quantity" : null),
                    TextFormField(controller: priceController, decoration: InputDecoration(labelText: "Price"), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? "Enter price" : null),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: [
                        ...images.map((img) => Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Image.file(img, width: 80, height: 80, fit: BoxFit.cover),
                                GestureDetector(
                                  onTap: () => setState(() => images.remove(img)),
                                  child: Icon(Icons.cancel, color: Colors.red),
                                ),
                              ],
                            )),
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate() && images.isNotEmpty) {
                          setState(() => loading = true);
                          String res = await FirestoreService().addCrop(
                            AuthService().currentUser!.uid,
                            nameController.text.trim(),
                            categoryController.text.trim(),
                            int.parse(quantityController.text.trim()),
                            double.parse(priceController.text.trim()),
                            images,
                          );
                          setState(() => loading = false);
                          if (res == "success") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Crop Added!")));
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $res")));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Fill all fields & add images")));
                        }
                      },
                      child: Text("Add Crop"),
                      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
