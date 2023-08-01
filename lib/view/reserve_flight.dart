


import 'package:flutter/material.dart';

class Flight extends StatefulWidget {
  const Flight({super.key});

  @override
  State<Flight> createState() => _FlightState();
}

class _FlightState extends State<Flight> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        
        child: Text("Reserve flight"),
      ),
    );
  }
}