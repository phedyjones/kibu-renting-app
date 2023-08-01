import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kibu_renting_app/model/hotel_class.dart';
import 'package:kibu_renting_app/services/reservation.dart';
import 'package:kibu_renting_app/view/dashboard.dart';


class Hotels extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  const Hotels({super.key, required this.auth, required this.firestore});

  @override
  State<Hotels> createState() => _HotelsState();
}

class _HotelsState extends State<Hotels> {
  Future<List<HotelClass>>? _hotelFuture;
  final Reservation reservation = Reservation();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _hotelFuture = reservation.getHotels();
  }

  List<HotelClass> filterHotels(List<HotelClass> hotels) {
    if (searchQuery.isEmpty) {
      return hotels;
    } else {
      return hotels
          .where((hotel) =>
              hotel.name.toLowerCase().contains(searchQuery.toLowerCase()))
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
              _hotelFuture = reservation.getHotels();
            });
            return _hotelFuture!;
          },
          child: FutureBuilder(
            future: _hotelFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Text("Loading....."));
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error retrieving data'));
              } else {
                List<HotelClass> allHotels = snapshot.data as List<HotelClass>;
                List<HotelClass> filteredHotels = filterHotels(allHotels);
                return ListView.builder(
                  itemCount: filteredHotels.length,
                  itemBuilder: (context, index) {
                    final hotel = filteredHotels[index];
                    return HotelCard(
                      auth: widget.auth,
                      firestore: widget.firestore,
                      amount: hotel.amount,
                      image: hotel.image,
                      name: hotel.name,
                      description: hotel.description,
                      location: hotel.location,
                      rating: hotel.rating,
                      reviews: hotel.reviews,
                      rooms: hotel.rooms!,
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
