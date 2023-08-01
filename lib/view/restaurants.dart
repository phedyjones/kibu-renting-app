import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kibu_renting_app/model/restaurant_class.dart';
import 'package:kibu_renting_app/services/reservation.dart';
import 'package:kibu_renting_app/view/dashboard.dart';


class Restaurants extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  const Restaurants({super.key, required this.auth, required this.firestore});

  @override
  State<Restaurants> createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  Future<List<RestaurantClass>>? _restaurantFuture;
  final Reservation reservation = Reservation();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _restaurantFuture = reservation.getRestaurants();
  }

  List<RestaurantClass> filterRestaurants(List<RestaurantClass> restaurants) {
    if (searchQuery.isEmpty) {
      return restaurants;
    } else {
      return restaurants
          .where((restaurant) =>
              restaurant.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white70,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {
              _restaurantFuture = reservation.getRestaurants();
            });
            return _restaurantFuture!;
          },
          child: FutureBuilder(
            future: _restaurantFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Text("Loading....."));
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error retrieving data'));
              } else {
                List<RestaurantClass> allRestaurants =
                    snapshot.data as List<RestaurantClass>;
                List<RestaurantClass> filteredRestaurants =
                    filterRestaurants(allRestaurants);
                return ListView.builder(
                  itemCount: filteredRestaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = filteredRestaurants[index];
                    return RestaurantCard(
                      auth: widget.auth,
                      firestore: widget.firestore,
                      amount: restaurant.amount,
                      image: restaurant.image,
                      name: restaurant.name,
                      description: restaurant.description,
                      location: restaurant.location,
                      rating: restaurant.rating,
                      reviews: restaurant.reviews,
                      rooms: restaurant.rooms!,
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
