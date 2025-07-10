import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newflutterproject/CheckOut.dart';
import 'dart:convert';

import 'package:newflutterproject/CheckOut.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key,}
      );

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
// this function update the qty
  Future<void> updateQty(String docId, int qty) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cart')
          .doc(docId)
          .update({'qty': qty});
    }
  }

  Future<void> clearCart() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null){
      final cartCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cart');

      final querySnapshot = await cartCollection
          .where('isCheckout', isEqualTo: false)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    }
  }

  double calculateTotal(List<QueryDocumentSnapshot> items) {
    double total = 0.0;
    for (var item in items) {
      final data = item.data() as Map<String, dynamic>;
      final qty = data['qty'] ?? 1;
      final price = double.tryParse(data['price'].toString()) ?? 0.0;
      total += qty * price;
    }
    return total;
  }

  Future<void> proceedToCheckout(List<QueryDocumentSnapshot> items, double totalPrice) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    List<Map<String, dynamic>> selectedItems = items.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'name': data['name'],
        'price': data['price'],
        'qty': data['qty'] ?? 1,
        'image': data['image'],
      };
    }).toList();


    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(

          price: totalPrice,
          selectedItems: selectedItems,
          onCheckoutSuccess: () async {

            for (var doc in items) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('cart')
                  .doc(doc.id)
                  .update({'isCheckout': true});
            }
          },
        ),
      ),
    );


    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checkout completed successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('User not logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Clear Unchecked Items',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Clear Cart"),
                  content: const Text("Remove all items from cart that are not yet checked out?"),
                  actions: [

                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                    ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Clear")),
                  ],
                ),
              );

              if (confirm == true) {
                await clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Unchecked items removed from cart.')),
                );
              }
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('cart')
            .where('isCheckout', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final items = snapshot.data!.docs;

          if (items.isEmpty) return const Center(child: Text("Cart is empty"));

          final totalPrice = calculateTotal(items);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final data = items[index].data() as Map<String, dynamic>;
                    final id = items[index].id;
                    final qty = data['qty'] ?? 1;

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: Image.memory(
                          base64Decode(data['image']),
                          width: 50,
                          height: 50,
                        ),
                        title: Text(data['name']),
                        subtitle: Text("Price: Rs.${data['price']}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                if (qty > 1) {
                                  await updateQty(id, qty - 1);
                                } else {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(uid)
                                      .collection('cart')
                                      .doc(id)
                                      .delete();
                                }
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Text(qty.toString()),
                            IconButton(
                              onPressed: () => updateQty(id, qty + 1),
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Total: Rs. ${totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: items.isEmpty
                          ? null
                          : () => proceedToCheckout(items, totalPrice),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Checkout",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}