import 'dart:convert';
import 'trackOrder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<DocumentSnapshot> getUserData(String uid) {
    return FirebaseFirestore.instance.collection('user').doc(uid).get();
  }

  Stream<QuerySnapshot> getUserCart(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).collection('cart').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: getUserData(user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  child: Text(
                    data['name'][0].toUpperCase(),
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Text(data['name'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(data['email'], style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),


                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green),
                  title: Text(data['phone'] ?? 'N/A'),
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.orange),
                  title: Text(data['address'] ?? 'N/A'),
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.purple),
                  title: Text(data['gender'] ?? 'N/A'),
                ),

                const Divider(thickness: 1, height: 40),

                const Text("My Cart", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                StreamBuilder(
                  stream: getUserCart(user.uid),
                  builder: (context, cartSnapshot) {
                    if (!cartSnapshot.hasData) return const CircularProgressIndicator();

                    final cartItems = cartSnapshot.data!.docs
                        .where((doc) => (doc.data() as Map)['isCheckout'])
                        .toList();

                    if (cartItems.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("No items in cart."),
                      );
                    }

                    return ListView.builder(
                      itemCount: cartItems.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        final itemData = item.data() as Map<String, dynamic>;

                        return GestureDetector(
                          onTap: (){
                            itemData['isCheckout']?Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderTrackingMap(
                              orderId: itemData['orderDetails']['orderId'],
                            ))):"";
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: Image.memory(base64Decode(itemData['image']), width: 50, height: 50),
                              title: Text(itemData['name']),
                              subtitle: Text("Qty: ${itemData['qty']} • Rs.${itemData['price']}"),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(itemData['isCheckout'] ? "Checked Out" : "In Cart",
                                      style: TextStyle(color: itemData['isCheckout'] ? Colors.blue : Colors.black)),
                                  Text(itemData['isDelivered'] ? "Delivered" : "Pending",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: itemData['isDelivered'] ? Colors.green : Colors.red)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
