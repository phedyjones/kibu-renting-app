

import 'package:flutter/material.dart';

class TransportVersility extends StatefulWidget {
  const TransportVersility({super.key});

  @override
  State<TransportVersility> createState() => _TransportVersilityState();
}

class _TransportVersilityState extends State<TransportVersility> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text("Transport"),
      ),
    );
  }
}