import 'package:flutter/material.dart';
import 'package:kibu_renting_app/view/dashboard.dart';

class AllMarkets extends StatefulWidget {
  const AllMarkets({super.key});

  @override
  State<AllMarkets> createState() => _AllMarketsState();
}

class _AllMarketsState extends State<AllMarkets> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
                children: [
            ShoppingCard(
            
              image: 'assets/images/market1',
              location: 'Muscat City',
              market: 'Muscat City Centre',
            ),
            ShoppingCard(
             
              image: 'assets/images/market2',
              location: 'Oman',
              market: 'Oman Avenues Mall',
            ),
            ShoppingCard(
             
              image: 'assets/images/market3',
              location: 'Salalah',
              market: 'Salalah Gardens Mall',
            ),
            ShoppingCard(
            
              image: 'assets/images/market4',
              location: 'Mutrah',
              market: 'Mutrah Fish Market',
            ),
            ShoppingCard(
             
              image: 'assets/images/market5',
              location: 'Muscat',
              market: 'Muscat Grand Mall',
            ),
            ShoppingCard(
              
              image: 'assets/images/market6',
              location: 'Alia',
              market: 'Alia Gallery ',
            ),
            ShoppingCard(
             
              image: 'assets/images/market7',
              location: 'Murtada',
              market: 'Murtada A.K. Trading Kadok',
            ),
            ShoppingCard(
             
              image: 'assets/images/market3',
              location: 'Markaz',
              market: 'Markaz Al Bahja ',
            ),
                ],
              ),
          )),
    );
  }
}
