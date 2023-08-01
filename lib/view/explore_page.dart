import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kibu_renting_app/view/flights.dart';
import 'package:kibu_renting_app/view/hotels.dart';
import 'package:kibu_renting_app/view/restaurants.dart';

class Explore extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  const Explore({super.key, required this.auth, required this.firestore});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with SingleTickerProviderStateMixin{
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  void dispose() {
    _tabController!.dispose();
    super.dispose();
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
                    const Expanded(
                      child: TextField(
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
            
            
          bottom: TabBar(
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.blue,
            isScrollable: true,
            controller: _tabController,
            tabs: const [
              Tab(
                icon: Icon(Icons.hotel),
                text: 'Hotels',
              ),
              Tab(
                icon: Icon(Icons.restaurant),
                text: 'Restaurants',
              ),
              Tab(
                icon: Icon(Icons.flight),
                text: 'Flights',
              ),
              Tab(
                icon: Icon(Icons.location_pin),
                text: 'Places',
              ),
    
            ],
            
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children:  [
            Hotels(auth: widget.auth, firestore: widget.firestore,),
            Restaurants(auth: widget.auth, firestore: widget.firestore,),
            Flights(auth: widget.auth, firestore: widget.firestore,),
           Hotels(auth: widget.auth, firestore: widget.firestore,)
    
          ],
        ),
    
      ),
    );
  }
}