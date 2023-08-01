import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';


import '../model/flight_class.dart';
import '../model/hotel_class.dart';
import '../model/order.dart';
import '../model/restaurant_class.dart';

class Reservation {
// Create a new instance of Firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Add a new hotel reservation
  Future<void> addHotelReservation(
      String hotelName, DateTime checkInDate, DateTime checkOutDate) async {
    try {
      await firestore.collection('hotel_reservations').add({
        'hotel_name': hotelName,
        'check_in_date': checkInDate,
        'check_out_date': checkOutDate,
      });
    } catch (e) {
      print('Error adding hotel reservation: $e');
    }
  }

// Add a new restaurant reservation
  Future<void> addRestaurantReservation(
      String restaurantName, DateTime reservationDate) async {
    try {
      await firestore.collection('restaurant_reservations').add({
        'restaurant_name': restaurantName,
        'reservation_date': reservationDate,
      });
    } catch (e) {
      print('Error adding restaurant reservation: $e');
    }
  }

  Future<List<OrderClass>> getOrders({required String userId, String? orderId}) async {
    QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .get();
    List<OrderClass> orders = [];
    ordersSnapshot.docs.forEach((doc) {
      orders.add(OrderClass.fromSnapshot(doc));
    });
    return orders;
  }

   Future<List<HotelClass>> getHotels() async {
  try {
    QuerySnapshot hotelSnapshot = await FirebaseFirestore.instance
        .collection('hotels')
        .get();
    List<HotelClass> hotels = [];
    hotelSnapshot.docs.forEach((doc) {
      hotels.add(HotelClass.fromSnapshot(doc));
    });
    return hotels;
  } catch (error) {
    print("Error fetching hotels: $error");
    return []; 
  }
}
   Future<List<RestaurantClass>> getRestaurants() async {
  try {
    QuerySnapshot restaurantSnapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .get();
    List<RestaurantClass> restaurants = [];
    restaurantSnapshot.docs.forEach((doc) {
      restaurants.add(RestaurantClass.fromSnapshot(doc));
    });
    return restaurants;
  } catch (error) {
    print("Error fetching restaurants: $error");
    return []; 
  }
}


   Future<List<FlightClass>> getFlights() async {
  try {
    QuerySnapshot flightsSnapshot = await FirebaseFirestore.instance
        .collection('flights')
        .get();
    List<FlightClass> flights = [];
    flightsSnapshot.docs.forEach((doc) {
      flights.add(FlightClass.fromSnapshot(doc));
    });
    return flights;
  } catch (error) {
    print("Error fetching flights: $error");
    return []; 
  }
}


  Future<void> addOrder({
    required String userId,
    required String title,
    required String type,
    required double price,
    required String room,
    required String date,
    required BuildContext context,
  }) async {
    try {
      // Show confirmation dialog
      bool confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: const Text('Are you sure you want to add this order?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // User canceled
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // User confirmed
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        await firestore.collection('orders').add({
          'type': type,
          'userId': userId,
          'title': title,
          'date': date,
          'price': price,
          'room': room,
        });

        // Show success Flushbar
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          message: 'Order added successfully',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
        )..show(context);
      }
    } catch (e) {
      print('Error adding order: $e');

      // Show error Flushbar
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        message: 'An error occurred while adding the order $e',
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      )..show(context);
    }
  }
}
