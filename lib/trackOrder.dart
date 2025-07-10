import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class OrderTrackingMap extends StatefulWidget {
  final String orderId;

  const OrderTrackingMap({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderTrackingMap> createState() => _OrderTrackingMapState();
}

class _OrderTrackingMapState extends State<OrderTrackingMap> {
  final MapController _mapController = MapController();
  Map<String, dynamic>? _orderData;
  bool _isLoading = true;
  List<Marker> _markers = [];
  List<Polyline> _polylines = [];

  @override
  void initState() {
    super.initState();
    _fetchOrderData();
  }

  Future<void> _fetchOrderData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .doc(widget.orderId)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          _orderData = docSnapshot.data();
          _isLoading = false;
        });
        _setupMarkers();

      } else {
        log('Order document not found');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      log('Error fetching order data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _setupMarkers() {
    if (_orderData == null) return;

    List<Marker> markers = [];
    List<LatLng> points = []; // officeAdress , deliveryAddress , currentAddress
    // List<LatLng> points1 = [LatLng(27.7, 85.3117), LatLng(27.747471,85.364367), LatLng(27.7, 85.3117)];


    if (_orderData!.containsKey('officeAddress')) {
      final officeLatLng = LatLng(
        _orderData!['officeAddress']['lat'],
        _orderData!['officeAddress']['lng'],
      );
      points.add(officeLatLng);

      markers.add(
        Marker(
          point: officeLatLng,
          width: 80,
          height: 80,
          child: _buildCustomMarker(Colors.blue, 'Office'),
        ),
      );
    }


    if (_orderData!.containsKey('deliveryAddress')) {
      final deliveryLatLng = LatLng(
        _orderData!['deliveryAddress']['lat'],
        _orderData!['deliveryAddress']['lng'],
      );
      points.add(deliveryLatLng);

      markers.add(
        Marker(
          point: deliveryLatLng,
          width: 80,
          height: 80,
          child: _buildCustomMarker(Colors.green, 'Delivery'),
        ),
      );
    }


    if (_orderData!.containsKey('currentAddress')) {
      final currentLatLng = LatLng(
        _orderData!['currentAddress']['lat'],
        _orderData!['currentAddress']['lng'],
      );
      points.add(currentLatLng);

      markers.add(
        Marker(
          point: currentLatLng,
          width: 80,
          height: 80,
          child: _buildCustomMarker(Colors.red, 'Current'),
        ),
      );
    }

    setState(() {
      _markers = markers;
      log(points.toString());

    });


    if (points.isNotEmpty) {
      _fitAllMarkers(points);
    }
  }

  Widget _buildCustomMarker(Color color, String label) {
    return Column(
      children: [

        Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          width: 20,
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _fitAllMarkers(List<LatLng> points) {
    if (points.isEmpty) return;

    double minLat = 90.0;
    double maxLat = -90.0;
    double minLng = 180.0;
    double maxLng = -180.0;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    // Add padding
    final paddingDegrees = 0.005;

    // Calculate center point
    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;

    // Calculate appropriate zoom level based on bounds
    double latDelta = (maxLat + paddingDegrees) - (minLat - paddingDegrees);
    double lngDelta = (maxLng + paddingDegrees) - (minLng - paddingDegrees);

    // Use larger of the two deltas to determine zoom
    double maxDelta = latDelta > lngDelta ? latDelta : lngDelta;

    // Rough estimate of appropriate zoom level
    double zoom = 12.0;
    if (maxDelta <= 0.01) zoom = 15.0;
    else if (maxDelta <= 0.05) zoom = 13.0;
    else if (maxDelta <= 0.1) zoom = 12.0;
    else if (maxDelta <= 0.5) zoom = 10.0;
    else zoom = 8.0;

    // Move map to show all markers
    _mapController.move(LatLng(centerLat, centerLng), zoom);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_orderData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order Tracking'),
        ),
        body: const Center(
          child: Text('Order data not found'),
        ),
      );
    }

    // Default location (fallback to Nepal if no locations are available)
    final defaultLocation = LatLng(27.7000, 85.3117);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.orderId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: defaultLocation,
                initialZoom: 12,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                // PolylineLayer(polylines: _polylines),
                MarkerLayer(markers: _markers),
              ],
            ),
          ),
          // Legend
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Map Legend',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Office Location'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Delivery Location'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Current Location'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Delivery Route'),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '© anup',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}