import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newflutterproject/login_Page.dart';
import 'package:newflutterproject/productPage.dart';

class HomePage extends StatefulWidget {




  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> images2=[
    'assets/2b8e9feb-f73a-4a31-af9f-5874d1bba166.jpg',
  ];
  final List<String> images=[
    'assets/OIP.jpg',
    'assets/OIP1.jpg',
    'assets/OIP2.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        appBar: AppBar(
          title: Text("Home page"),
        ),
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
                        backgroundImage: AssetImage
                          ('assets/2b8e9feb-f73a-4a31-af9f-5874d1bba166.jpg'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey)
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.camera_alt, size: 20),

                        ),
                      )
                    ],
                  ),
                )
            ),
            Expanded(
              child: ListView(
            padding: EdgeInsets.zero,
            children: [

                  ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Home"),
                  onTap: ()=>Navigator.pop(context),
                ),


               ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text("Cart"),
                onTap: (){
                },
              ),
              ListTile(
                leading: const Icon(Icons.sell),
                title: const Text("Seller"),
                onTap:() {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> productPage()));
                },
              )
            ],
          ),

            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log Out"),
              onTap: () async{
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=> LonginScreen()), (route)=>false );

              },
            ),

          ],

        ),
      ),
      body: Column(
        children: [
          CarouselSlider(
              options: CarouselOptions(
                height: 150,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16/9,
                viewportFraction: 0.9,
              ),
            items: images.map((imageUrl) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(10),
                   image: DecorationImage(
                       image: AssetImage(imageUrl),
                       fit: BoxFit.cover,
                   )
                 ),
                 // or Image.network(imageUrl)
              );
            }).toList(),
          )
        ],
      ),
    )
    );
  }
}
