import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homepage.dart';



enum PaymentMethod { esewa, cod, khalti }

class CheckoutPage extends StatefulWidget {
  final double price;
  final List<Map<String, dynamic>> selectedItems;
  final Function onCheckoutSuccess;

  CheckoutPage({
    super.key,
    required this.price,
    required this.selectedItems,
    required this.onCheckoutSuccess,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String currentAddress = '';
  double latitude = 0.0;
  double longitude = 0.0;
  PaymentMethod? selectedPaymentMethod;
  String orderId = '';
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    orderId = DateTime.now().millisecondsSinceEpoch.toString();
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {

        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          final data = userData.data();
          if (data != null) {
            setState(() {
              phoneController.text = data['phone'] ?? '';
              emailController.text = data['email'] ?? user.email ?? '';
              addressController.text = data['address'] ?? '';
            });
          }
        } else {

          setState(() {
            emailController.text = user.email ?? '';
            phoneController.text = user.phoneNumber ?? '';
          });
        }
      } catch (e) {
        print('Error loading user details: $e');

        setState(() {
          emailController.text = user.email ?? '';
          phoneController.text = user.phoneNumber ?? '';
        });
      }
    }
  }

  Future<void> generateAndDownloadPDF() async {
    final pdf = pw.Document();
    final formatter = DateFormat('dd-MM-yyyy hh:mm a');
    final currentDate = formatter.format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('INVOICE', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Order ID: $orderId'),
                    pw.Text('Date: $currentDate'),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Customer Details:'),
                    pw.Text('Phone: ${phoneController.text}'),
                    pw.Text('Email: ${emailController.text}'),
                    pw.Text('Address: ${addressController.text}'),
                    pw.Text('Location: $currentAddress'),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 30),
            pw.Text('Order Summary', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['Product', 'Quantity', 'Unit Price', 'Total'],
              data: widget.selectedItems.map((item) {
                int qty = item['qty'] ?? 1;
                double price = double.tryParse(item['price'].toString()) ?? 0.0;
                double itemTotal = qty * price;
                return [
                  item['name'],
                  qty.toString(),
                  'Rs.${price.toStringAsFixed(2)}',
                  'Rs.${itemTotal.toStringAsFixed(2)}',
                ];
              }).toList(),
              border: null,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 30,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
              },
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Subtotal:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Rs.${widget.price.toStringAsFixed(2)}'),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Shipping:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Rs.50.00'),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Tax:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Rs.100.00'),
              ],
            ),
            pw.Divider(),
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                pw.Text('Rs.${(widget.price + 150).toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
              ],
            ),
            pw.SizedBox(height: 30),
            pw.Text('Payment Information', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Payment Method: ${selectedPaymentMethod?.name.toUpperCase() ?? "N/A"}'),
            pw.Text('Payment Status: Completed'),
            pw.SizedBox(height: 30),
            pw.Center(
              child: pw.Text('Thank you for your purchase!', style: pw.TextStyle(fontSize: 16)),
            ),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text('For any questions, please contact customer support.'),
            ),
          ];
        },
      ),
    );

    try {
      final directory = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
      final path = '${directory.path}/Invoice_$orderId.pdf';
      final file = File(path);
      await file.writeAsBytes(await pdf.save());

      OpenFile.open(path);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invoice saved to $path')),
      );
    } catch (e) {
      print('Error generating PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate invoice. Please try again.')),
      );
    }
  }

  Future<bool> sendOrderEmail(List<Map<String, dynamic>> selectedItems) async {
    final String serviceId = 'service_al7vazj';
    final String templateId = 'template_flcr12v';
    final String userId = 'oPGEMtN0yn6uz_g1n';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    List<Map<String, dynamic>> formattedCartItems = selectedItems.map((item) {
      return {
        'name': item['name'],
        'image_url': item['image'],
        'units': item['qty'] ?? 1,
        'price': item['price'].toString(),
      };
    }).toList();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'origin': 'http://localhost'
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'order_id': orderId,
          'customer_name': phoneController.text,
          'email': emailController.text,
          'orders': formattedCartItems,
          'cost': {
            'shipping': '50',
            'tax': '100',
            'total': (widget.price + 150).toString(),
          }
        },
      }),
    );

    if (response.statusCode == 200) {

      await widget.onCheckoutSuccess();
      print('Email sent successfully!');

      await saveOrderToFirestore();


      await generateAndDownloadPDF();

      return true;
    } else {
      print('Failed to send email: ${response.body}');
      throw Exception('Failed to send email: ${response.body}');
    }
  }

  Future<void> saveOrderToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    log(user!.uid.toString());
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid).collection("orders").doc(orderId)
            .set({
          'userId': user.uid,
          'orderDate': FieldValue.serverTimestamp(),
          'orderId': orderId,
          'items': widget.selectedItems,
          'total': widget.price + 150,
          'shipping': 50.0,
          'tax': 100.0,
          'subtotal': widget.price,
          'paymentMethod': selectedPaymentMethod?.name ?? 'unknown',
          'status': 'completed',
          'deliveryAddress':{
            'lat':latitude,
            'lng':longitude,
          },
          'officeAddress':{
            'lat':27.7000,
            'lng':85.3117,
          },
          'currentAddress':{
            'lat':27.7000,
            'lng':85.3117,
          }

        });
        for (int i = 0; i < widget.selectedItems.length; i++) {
          String itemId = widget.selectedItems[i]['id'];
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('cart')
              .doc(itemId)
              .update({'isCheckout': true,
            'orderDetails':{
              'userId': user.uid,
              'orderDate': FieldValue.serverTimestamp(),
              'orderId': orderId,
              'items': widget.selectedItems,
              'total': widget.price + 150,
              'shipping': 50.0,
              'tax': 100.0,
              'subtotal': widget.price,
              'paymentMethod': selectedPaymentMethod?.name ?? 'unknown',
              'status': 'completed',
              'deliveryAddress':{
                'lat':latitude,
                'lng':longitude,
              },
              'officeAddress':{
                'lat':27.7000,
                'lng':85.3117,
              },
              'currentAddress':{
                'lat':27.7000,
                'lng':85.3117,
              }

            }
          });

          // await updateCart(itemId);
        }

      } catch (e) {
        print('Error saving order to Firestore: $e');
      }
    }
  }
  Future<void> updateCart(String itemName) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cart')
          .doc(itemName)
          .update({'isCheckout': true});
    }
  }
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude;
    longitude = position.longitude;

    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    setState(() {
      currentAddress = '${place.subLocality}, ${place.locality}, ${place.country}';
    });
  }

  Future<void> proceedToPayment() async {
    if (phoneController.text.isEmpty || emailController.text.isEmpty || selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select a payment method')),
      );
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {

      if (selectedPaymentMethod == PaymentMethod.cod) {
        // await sendOrderEmail(widget.selectedItems);
        await saveOrderToFirestore();

        await generateAndDownloadPDF();

        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Order Placed'),
                content: const Text('Your order has been placed successfully! You will pay on delivery.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => homePage()),
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
        return;
      }

      KhaltiScope.of(context).pay(
        config: PaymentConfig(
            amount: (widget.price * 100).toInt(),
            productIdentity: 'shopping-items-$orderId',
            productName: 'Shopping Items'
        ),
        preferences: [
          PaymentPreference.khalti,
          PaymentPreference.connectIPS,
          PaymentPreference.eBanking,
          PaymentPreference.mobileBanking,
        ],
        onSuccess: (success) async {
          print("Payment Success: $success");

          try {
            // await sendOrderEmail(widget.selectedItems);
            await saveOrderToFirestore();

            await generateAndDownloadPDF();

            if (mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Payment Successful'),
                    content: const Text('Your order has been placed successfully!'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => homePage()),
                          );
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          } catch (e) {
            print("Error processing successful payment: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error processing your order. Please contact support.')),
            );
          } finally {
            setState(() {
              isProcessing = false;
            });
          }
        },
        onFailure: (failure) {
          print("Payment Failed: $failure");
          setState(() {
            isProcessing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment failed. Please try again.')),
          );
        },
      );
    } catch (e) {
      print("Error during payment process: $e");
      setState(() {
        isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: isProcessing
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Processing your order...'),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Additional Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Address:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(currentAddress.isEmpty ? 'Fetching address...' : currentAddress),
                ],
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<PaymentMethod>(
              value: selectedPaymentMethod,
              items: PaymentMethod.values.map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Text(method.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (method) {
                log(method.toString());
                setState(() {
                  selectedPaymentMethod = method;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Select Payment Method',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Selected Items:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Image')),
                  DataColumn(label: Text('Product')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Total')),
                ],
                rows: widget.selectedItems.map((item) {
                  int qty = item['qty'] ?? 1;
                  double price = double.tryParse(item['price'].toString()) ?? 0.0;
                  double itemTotal = qty * price;

                  return DataRow(cells: [
                    DataCell(Image.memory(base64Decode(item['image']), width: 50, height: 50)),
                    DataCell(Text(item['name'])),
                    DataCell(Text('${qty}')),
                    DataCell(Text('Rs.${price.toStringAsFixed(2)}')),
                    DataCell(Text('Rs.${itemTotal.toStringAsFixed(2)}')),
                  ]);
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal:', style: TextStyle(fontSize: 16)),
                      Text('Rs.${widget.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Shipping:', style: TextStyle(fontSize: 16)),
                      Text('Rs.50.00', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Tax:', style: TextStyle(fontSize: 16)),
                      Text('Rs.100.00', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const Divider(thickness: 1, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total: ",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Rs.${(widget.price + 150).toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: proceedToPayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Proceed to Payment",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}