import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/constants.dart';
import 'controller/Root/root.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      textTheme: GoogleFonts.robotoCondensedTextTheme(),
       primaryColor: Colors.white,
        
        buttonTheme: ButtonThemeData(
          buttonColor: primary2,
          textTheme: ButtonTextTheme.primary
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
        
      ),
      home:const  Root()
    );
  }
}

