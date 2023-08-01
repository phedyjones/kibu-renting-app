import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/order.dart';
import '../services/reservation.dart';

class OrderPage extends StatefulWidget {
  final String userId;

  OrderPage({required this.userId, required FirebaseAuth auth});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with SingleTickerProviderStateMixin {
  Future<List<OrderClass>>? _ordersFuture;
  final Reservation reservation = Reservation();
  TabController? _tabController;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _ordersFuture = reservation.getOrders(userId: widget.userId);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  void performSearch() {
    setState(() {
      _ordersFuture = reservation.getOrders(userId: widget.userId, orderId: searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.blue),
            onPressed: performSearch,
          ),
        ],
        bottom: TabBar(
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.blue,
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.upcoming),
              text: 'Upcoming',
            ),
            Tab(
              icon: Icon(Icons.history),
              text: 'History',
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () {
          setState(() {
            _ordersFuture = reservation.getOrders(userId: widget.userId);
          });
          return _ordersFuture!;
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            FutureBuilder(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error retrieving orders'));
                } else {
                  List<OrderClass> orders = snapshot.data as List<OrderClass>;
                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      DateTime parsedDate = DateTime.parse(order.date);
                      String formattedDate = DateFormat('EEEE, d MMMM').format(parsedDate);
                      return Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            leading: const Icon(Icons.shopping_basket, color: Color.fromARGB(255, 13, 165, 18)),
                            title: Text(
                              order.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 5, 119, 9)),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 5.0),
                                RichText(
                                  text: TextSpan(
                                    text: 'Order Type: ',
                                    style: const TextStyle(color: Colors.grey),
                                    children: <TextSpan>[
                                    TextSpan(
                                        text: order.type,
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: order.room,
                                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 24.0),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(height: 5.0),
                                Text(
                                  'Price: \$${order.price.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  'Date: $formattedDate',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            FutureBuilder(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error retrieving orders'));
                } else {
                  List<OrderClass> orders = snapshot.data as List<OrderClass>;
                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      DateTime parsedDate = DateTime.parse(order.date);
                      String formattedDate = DateFormat('EEEE, d MMMM').format(parsedDate);
                      return Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            leading: const Icon(Icons.shopping_basket, color: Color.fromARGB(255, 13, 165, 18)),
                            title: Text(
                              order.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 13, 165, 18)),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 5.0),
                                Text(
                                  'Order Type: ${order.type}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  'Price: \$${order.price.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  'Date: $formattedDate',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

