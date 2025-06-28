import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newflutterproject/login_Page.dart';
import 'package:newflutterproject/productPage.dart';

class homePage extends StatefulWidget {
  @override
  State<homePage> createState() => _homePageState();
}
Map<int, int> _quantities = {};

class _homePageState extends State<homePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? baseImage;

  Future<void> createProfileImage({
  required String ProfileBaseImage,
}) async{
    try{
      await FirebaseFirestore.instance.collection("user").doc().collection('Profile Picture').add(
        {
          'image': ProfileBaseImage
        }
      );
    }catch(e){
      Fluttertoast.showToast(msg: "Error creating product$e");
    }
}
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();// it is a flutter plugin used to open camera or gallery
    final pickedFile = await picker.pickImage(source: source, imageQuality: 70); // it will open the UI to pick image and store that into pickedFile
    if (pickedFile != null) {// if the image will picked than it will encode in string and store that into compressed
      final compressed = await FlutterImageCompress.compressWithFile(
        pickedFile.path,
        quality: 70,
      );
      if (compressed != null) { // if compressed image is in the format of string it till sta
        setState(() {
          baseImage = base64Encode(compressed);
        });
      }
    }
  }

  //clicked add to cart in homeScreen it will add the product in the cart list
  Future<void> addToCart(Map<String, dynamic> product, int qty, BuildContext rootContext,) async{

    final user = _auth.currentUser;

    // if user have didn't login or signIn then it show a snackBar
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add to cart')),
      );
      return;
    }
// this will access the firebase database users/user.id/cart/product basically it will point on the endpoint to store product data
    final cartRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(product['id']);
    // we set the location above now this will get those data by using cartRef.get() and check if the product exist
    final existing = await cartRef.get();

// if product already exist
    if (existing.exists) {
      final currentQty = existing.data()?['qty'] ?? 1; // if quantity doesn't exist it will set to 1
      await cartRef.update({'qty': currentQty + qty});// if the product exist in the cart and clicked to add to cart it will update the qty by 1
    } else {
      await cartRef.set({
        'name': product['name'],
        'price': product['price'],
        'image': product['image'],
        'qty': qty,
        'isCheckout': false,
        'isDelivered': false,
      });
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Added to cart!')),
    );
    }

  }
  final List<String> images2 = [
    'assets/2b8e9feb-f73a-4a31-af9f-5874d1bba166.jpg',
  ];
  final List<String> images = [
    'assets/OIP.jpg',
    'assets/OIP1.jpg',
    'assets/OIP2.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    final rootContext = context;
    return SafeArea(
      child: Scaffold(

        appBar: AppBar(title: Text("Home page"),
        leading: Icon(Icons.menu, color: Colors.white,),),
        drawer: Drawer(
            child: Column(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.teal),
                  child: Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(
                            'assets/2b8e9feb-f73a-4a31-af9f-5874d1bba166.jpg',
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(onPressed: () => pickImage(ImageSource.gallery)
                              , icon: const Icon(Icons.camera_alt, size: 20),)
                          //Container(
                          //
                          //   decoration: BoxDecoration(
                          //     color: Colors.black,
                          //     shape: BoxShape.circle,
                          //     border: Border.all(color: Colors.grey),
                          //   ),
                          //   padding: const EdgeInsets.all(4),
                          //   child: const Icon(Icons.camera_alt, size: 20),
                          //
                          // ),
                       )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.home),
                        title: const Text("Home"),
                        onTap: () => Navigator.pop(context),
                      ),
            
                      ListTile(
                        leading: const Icon(Icons.shopping_cart),
                        title: const Text("Cart"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.sell),
                        title: const Text("Sellers"),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> productPage()));
                        },
                      ),
                    ],
                  ),
                ),
            
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Log Out"),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LonginScreen()) );
                  },
                ),
              ],
            ),

        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 150,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.9,
                ),
                items:
                    images.map((imageUrl) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                        // or Image.network(imageUrl)
                      );
                    }).toList(),
              ),
              SizedBox(height: 19,),

              //this container is to show the product fetch from the database in gridview
              Container(
                height: 500,
                width: 400,
                //stream builder listen to the live update in firebase product collection

                child: StreamBuilder<QuerySnapshot>(// QuerySnapshot is a type of data is expecting

                  stream: FirebaseFirestore.instance
                          .collection('product')
                          .snapshots(),//snapshot returns a stream, which is emits every times the data changes
                  //error handling and loading screen
                  builder: (context, snapshot) {

                    if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));

                    }
          
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // initializing docs with snapshot.data that has product data
                    // each docs[i].data contains the product details
                    final docs = snapshot.data!.docs;
                    // build grid
                    return GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.60,
                          ),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {

                        final data = docs[index].data() as Map<String, dynamic>;
                        //todo to ask
                        _quantities.putIfAbsent(index, () => 1);

                        // return GestureDetector(
                        //   onTap: (){
                        //     Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailPage(product: data,)));
                        //   },


                      return  Card( // card UI, shape and decoration
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // decoding the string image that in product collection initialize in data[]
                              Expanded(
                                child: data['image'] != null && data['image'] != ""
                                        ? Image.memory(
                                          base64Decode(data['image']),
                                          fit: BoxFit.cover,
                                        )
                                        : const Icon(Icons.image, size: 80),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['name'] ?? "No Name",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,color: Colors.white
                                      ),
                                    ),
                                    Text("Price: NRs .${data['price'] ?? 'N/A'}"),
                                    ElevatedButton(onPressed: (){
                                      addToCart(data,_quantities[index]! , rootContext);
                                    }, child: Text("Add to cart")),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (_quantities[index]! > 1) {
                                                _quantities[index] = _quantities[index]! - 1;
                                              }
                                            });
                                          },
                                          icon: const Icon(Icons.remove),
                                        ),
                                        Text(_quantities[index].toString()),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _quantities[index] = _quantities[index]! + 1;
                                            });
                                          },
                                          icon: const Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                        // return null;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
