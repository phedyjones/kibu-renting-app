import 'package:flutter/material.dart';


class SuggestMarket extends StatefulWidget {
  const SuggestMarket({super.key});

  @override
  State<SuggestMarket> createState() => _SuggestMarketState();
}

class _SuggestMarketState extends State<SuggestMarket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text("Market Suggesstion")),
    );
  }
}