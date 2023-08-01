import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kibu_renting_app/constants/constants.dart';
import 'package:kibu_renting_app/controller/Root/auth.dart';
import 'package:kibu_renting_app/model/hotel_class.dart';
import 'package:kibu_renting_app/model/restaurant_class.dart';
import 'package:kibu_renting_app/services/reservation.dart';
import 'package:kibu_renting_app/view/book_ride.dart';
import 'package:kibu_renting_app/view/hotel_details.dart';
import 'package:kibu_renting_app/view/hotels.dart';
import 'package:kibu_renting_app/view/login.dart';
import 'package:kibu_renting_app/view/restaurant_details.dart';
import 'package:kibu_renting_app/view/restaurants.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomePage extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const WelcomePage({super.key, required this.auth, required this.firestore});
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final Reservation reservation = Reservation();

  Future<List<HotelClass>>? _hotelsFuture;

  Future<List<RestaurantClass>>? _restaurantFuture;


  @override
  void initState() {
    super.initState();
    _hotelsFuture = reservation.getHotels();
    _restaurantFuture = reservation.getRestaurants();
  }

  Future _showSuccessMessage(String massage, Color color) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: color,
      message: massage,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Let's ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "Explore",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        elevation: 0,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'Logout',
                  child: Row(
                    children: [
                      Icon(FontAwesomeIcons.rightToBracket,size: 16,),
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            },
            onSelected: (value) async {
              if (value == 'Logout') {
                String? rvalue =
                    await Authenticate(auth: widget.auth).signOut();
                if (rvalue == "Success") {
                  _showSuccessMessage("Logout Successfull", Colors.green);
                  Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => Login(
                        auth: widget.auth,
                        firestore: widget.firestore,
                      ),
                    ),
                  );
                } else {
                  _showSuccessMessage(rvalue!, Colors.red);
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 400,
        child: Stack(
          children: [
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search,color: Colors.white,),
              ),
             ),
            CarouselSlider(
              items: [
                Image.asset(
                  'assets/images/hotel2.jpeg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Image.asset(
                  'assets/images/restaurant.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Image.asset(
                  'assets/images/flight.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ],
              options: CarouselOptions(
                height: 400,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                autoPlay: true,
              ),
            ),
            Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Welcome to our travel booking app',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Book your hotel, restaurant and flight with ease',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0),
            child: Text(
              'Featured Hotels',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => Hotels(
                    auth: widget.auth,
                    firestore: widget.firestore,
                  ),
                ),
              );
            },
            child: Text(
              "See All",
              style: TextStyle(fontSize: 16, color: primary),
            ),
          ),
        ],
      ),
      FutureBuilder(
        future: _hotelsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error retrieving data'));
          } else {
            List<HotelClass> hotels = snapshot.data as List<HotelClass>;
            return SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: hotels.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final hotel = hotels[index];
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
              ),
            );
          }
        },
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0),
            child: Text(
              'Featured Restaurants',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => Restaurants(
                    auth: widget.auth,
                    firestore: widget.firestore,
                  ),
                ),
              );
            },
            child: Text(
              "See All",
              style: TextStyle(fontSize: 16, color: primary),
            ),
          ),
        ],
      ),
      FutureBuilder(
        future: _restaurantFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error retrieving data'));
          } else {
            List<RestaurantClass> restaurants =
                snapshot.data as List<RestaurantClass>;
            return SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: restaurants.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final restaurant = restaurants[index];
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
              ),
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

class HotelCard extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final String image;
  final String name;
  final dynamic amount;
  final String description;
  final String location;
  final String rating;
  final String reviews;
  final List<dynamic> rooms;

  const HotelCard(
      {super.key,
      required this.auth,
      required this.firestore,
      required this.image,
      required this.name,
      required this.amount,
      required this.description,
      required this.location,
      required this.rating,
      required this.reviews,
       required this.rooms});

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.image,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Starting at \$${widget.amount}/night',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primary2),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HotelDetailsPage(
                                  auth: widget.auth,
                                  firestore: widget.firestore,
                                  amount: widget.amount,
                                  description: widget.description,
                                  image: widget.image,
                                  location: widget.location,
                                  name: widget.name,
                                  rating: widget.rating,
                                  reviews: widget.reviews,
                                   rooms: widget.rooms,
                                )),
                      );
// Navigate to hotel reservation page
                    },
                    child: const Text(
                      'View Details',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantCard extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final String image;
  final String name;
  final dynamic amount;
  final String description;
  final String location;
  final String rating;
  final String reviews;
  final List<dynamic> rooms;

  const RestaurantCard(
      {super.key,
      required this.auth,
      required this.firestore,
      required this.image,
      required this.name,
      required this.amount,
      required this.description,
      required this.location,
      required this.rating,
      required this.reviews, required this.rooms});
  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.image,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Starting at \$${widget.amount}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primary2),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RestaurantDetailsPage(
                                  auth: widget.auth,
                                  firestore: widget.firestore,
                                  amount: widget.amount,
                                  description: widget.description,
                                  image: widget.image,
                                  location: widget.location,
                                  name: widget.name,
                                  rating: widget.rating,
                                  reviews: widget.reviews,
                                  rooms: widget.rooms,
                                )),
                      );
// Navigate to restaurant reservation page
                    },
                    child: const Text(
                      'View Details',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlightCard extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final String image;
  final String name;
  final double amount;

  const FlightCard(
      {super.key,
      required this.auth,
      required this.firestore,
      required this.image,
      required this.name,
      required this.amount});

  @override
  State<FlightCard> createState() => _FlightCardState();
}

class _FlightCardState extends State<FlightCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              widget.image,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Starting at \$${widget.amount}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primary2),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookRidePage(
                                  auth: widget.auth,
                                  firestore: widget.firestore,
                                )),
                      );
                    },
                    child: const Text(
                      'Book Now',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShoppingCard extends StatefulWidget {
  final String image;
  final String market;
  final String location;

  const ShoppingCard(
      {super.key,
      required this.image,
      required this.market,
      required this.location});
  @override
  State<ShoppingCard> createState() => _ShoppingCardState();
}

class _ShoppingCardState extends State<ShoppingCard> {
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri(scheme: "https", host: url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              widget.image,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.market,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.location,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primary2),
                    ),
                    onPressed: () {
                      _launchURL("www.citycentremuscat.com");
                    },
                    child: const Text(
                      'Visit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
