import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class productPage extends StatefulWidget {
  const productPage({super.key});

  @override
  State<productPage> createState() => _productPageState();
}

class _productPageState extends State<productPage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? baseImage;


  // it is function that store the data in firestore if written correctly

  Future<void> createProduct({
    required String name,
    required String price,
    required String description,
    required String baseImage,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('product').add({
        'name': name,
        'price': price,
        'description': description,
        'image': baseImage,
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error creating product$e");
    }
  }

  // is the function will pick an image and compressed it store that into String? baseImage;
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();// it is a flutter plugin used to open camera or gallery
    final pickedFile = await picker.pickImage(source: source, imageQuality: 70); // it will open the UI to pick image and store that into pickedFile
    if (pickedFile != null) {// if the image will picked than it will encode in string and store that into compressed
      final compressed = await FlutterImageCompress.compressWithFile(
        pickedFile.path,
        quality: 70,
      );
      if (compressed != null) { // if compressed image not empty it will encode the image and store that into baseImage
        setState(() {
          baseImage = base64Encode(compressed);
        });
      }
    }
  }
  // product validation function that validates if user have leaves blank text field or nah it send the data to the firestore database
  void productValidation() {
    if (nameController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the product name");
    } else if (priceController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the Price");
    } else if (descriptionController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the product description");
    } else {
      createProduct(
        name: nameController.text.trim(),
        price: priceController.text.trim(),
        description: descriptionController.text.trim(),
        baseImage: baseImage!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Create your Product"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Product Name"),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Product Name",
                  hintStyle: TextStyle(color: Colors.black38),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Align(alignment: Alignment.centerLeft, child: Text("Price")),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.black38),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Product Description"),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.black38),
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),
              // these are the button of image picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Gallery"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  ),

                  SizedBox(width: 15),

                  ElevatedButton(
                    onPressed: () {
                      productValidation();
                    },
                    child: Text("Add"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
