import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kibu_renting_app/constants/constants.dart';
import 'package:kibu_renting_app/view/restaurant_res.dart';
import 'package:share_plus/share_plus.dart';


class RestaurantDetailsPage extends StatefulWidget {
  final String name;
  final String image;
  final double amount;
  final String description;
  final String location;
  final String rating;
  final String reviews;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final List<dynamic> rooms;

  const RestaurantDetailsPage({
    Key? key,
    required this.name,
    required this.image,
    required this.amount,
    required this.description,
    required this.location,
    required this.rating,
    required this.reviews, required this.auth, required this.firestore, required this.rooms,
  }) : super(key: key);

  @override
  State<RestaurantDetailsPage> createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
   bool _isOffered = false;

   void shareHotelDetails() {
    final String text = 'Check out this hotel:\n'
        'Name: ${widget.name}\n'
        'Price: \$${widget.amount}\n';
    Share.share(text);
  }

 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Stack(
                      children: [
                        SizedBox(
                          height: 300,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Image.network(widget.image),
                              Image.network(widget.image),
                              Image.network(widget.image),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 70,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(FontAwesomeIcons.heart),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          left: 10,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 10,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () {
                                shareHotelDetails();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        widget.name,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        children: [
                          const Icon(FontAwesomeIcons.locationPin, size: 16),
                          Text(
                            widget.location,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 16,
                              ),
                              Text(
                                '${widget.rating} (${widget.reviews} review)',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Text(
                            '\$${widget.amount}/night',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: ExpandableText(
                        widget.description,
                        style: const TextStyle(fontSize: 16),
                        expandText: 'Read more',
                        collapseText: 'Read less',
                        maxLines: 3,
                        linkColor: Colors.blue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'What we offer',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          IconButton(onPressed: (){
                            setState(() {
                              _isOffered = !_isOffered;
                            });
                          }, icon: _isOffered ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down))
                        ],
                      ),
                    ),
                    _isOffered? const SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FacilityItem(icon: Icons.wifi, name: 'Wifi'),
                          FacilityItem(icon: Icons.pool, name: 'Pool'),
                          FacilityItem(icon: Icons.sports_gymnastics, name: 'Gym'),
                          FacilityItem(icon: Icons.local_parking, name: 'Parking'),
                        ],
                      ),
                    ) : Container(),
                    const Divider()
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: 300,

              color: Colors.white,
              child: Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AddRestaurantReservationScreen(
                                          auth: widget.auth,
                                          firestore: widget.firestore,
                                          rooms: widget.rooms,
                                        )));
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                   
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FacilityItem extends StatelessWidget {
  final IconData icon;
  final String name;

  const FacilityItem({
    Key? key,
    required this.icon,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 100,
      width: 100,
      child: Container(
        height: 80,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.grey,

        borderRadius: BorderRadius.circular(10.0)),
      
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(name),
          ],
        ),
      ),
    );
  }
}
