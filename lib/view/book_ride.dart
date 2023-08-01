import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/constants.dart';


class BookRidePage extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const BookRidePage({super.key, required this.auth, required this.firestore});
  @override
  _BookRidePageState createState() => _BookRidePageState();
}

class _BookRidePageState extends State<BookRidePage> {
  final _formKey = GlobalKey<FormState>();
  final _pickupController = TextEditingController();
  final _destinationController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _passengersController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Ride'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _pickupController,
                  decoration: const InputDecoration(
                    labelText: 'Pickup location',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter pickup location';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _destinationController,
                  decoration: const InputDecoration(
                    labelText: 'Destination',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter destination';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date (MM/DD/YYYY)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    labelText: 'Time (HH:MM AM/PM)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter time';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passengersController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Number of passengers',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter number of passengers';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(primary2),
                                ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveRideData();
                    }
                  },
                  child: const Text('Book',style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveRideData() async {
    try {
      final rideData = {
        'pickup_location': _pickupController.text,
        'destination': _destinationController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'passengers': int.parse(_passengersController.text),
      };

      await FirebaseFirestore.instance
          .collection('rides')
          .add(rideData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ride booked successfully')),
      );

      // Clear text field values
      _pickupController.clear();
      _destinationController.clear();
      _dateController.clear();
      _timeController.clear();
      _passengersController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error booking ride: $e')),
      );
    }
  }
}
