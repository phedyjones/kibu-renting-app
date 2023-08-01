import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kibu_renting_app/constants/constants.dart';
import 'package:kibu_renting_app/model/restaurant_class.dart';
import 'package:kibu_renting_app/services/reservation.dart';

class AddRestaurantReservationScreen extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final List<dynamic> rooms;

  const AddRestaurantReservationScreen(
      {super.key,
      required this.auth,
      required this.firestore,
      required this.rooms});

  @override
  _AddRestaurantReservationScreenState createState() =>
      _AddRestaurantReservationScreenState();
}

class _AddRestaurantReservationScreenState
    extends State<AddRestaurantReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _restaurantNameController = TextEditingController();
  DateTime _reservationDate = DateTime.now();
  final _numPeopleController = TextEditingController();

  final reservation = Reservation();

  final bool _isSaving = false;

  List<String> _restaurants = [];
  String _selectedRestaurant = '';

  Future<List<String>> extractHotelNames() async {
    List<RestaurantClass> restaurantList = await reservation.getRestaurants();

    List<String> restaurantNames = [];
    for (var restaurant in restaurantList) {
      restaurantNames.add(restaurant.name);
    }

    return restaurantNames;
  }

   List<int>roomslist = [];
  int? firstRoom; 



  @override
  void initState() {
    super.initState();
  widget.rooms.forEach((element) {
      roomslist.add(element);
    });
   firstRoom = roomslist[0];
    extractHotelNames().then((value) {
      setState(() {
        _restaurants = value;
        if (_restaurants.isNotEmpty) {
          _selectedRestaurant = _restaurants[0];
        }
      });
    });
  }

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _numPeopleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Restaurant Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select a Restaurant',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: _selectedRestaurant,
                  items: _restaurants
                      .map((restaurant) => DropdownMenuItem(
                          value: restaurant, child: Text(restaurant)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRestaurant = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a restaurant';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<int>(
  value: firstRoom,
  items: roomslist.map((int room) {
    return DropdownMenuItem<int>(
      value: room,
      child: Text(room.toString()),
    );
  }).toList(),
  onChanged: (int? newValue) {
    setState(() {
      firstRoom = newValue;
    });
  },
  decoration: InputDecoration(
    labelText: 'Select a Room',
  ),
),
                const SizedBox(height: 16.0),
                
                const SizedBox(height: 16.0),
                InkWell(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _reservationDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _reservationDate = pickedDate;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.calendar,
                        color: primary2,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        'Reservation Date: ${_reservationDate.day}/${_reservationDate.month}/${_reservationDate.year}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(primary2),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final restaurantName = _selectedRestaurant;
                            final reservationdtm = _reservationDate;
                            await reservation.addOrder(
                                date: reservationdtm.toString(),
                                price: 10000,
                                title: restaurantName,
                                room: firstRoom.toString(),
                                type: 'RESTAURANT',
                                userId: widget.auth.currentUser!.uid,
                                context: context);
                          }
                        },
                        child: const Text(
                          'Add Reservation',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
