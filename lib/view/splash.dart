import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kibu_renting_app/controller/Root/root.dart';
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();

  
}

class _SplashState extends State<Splash> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 4)).then((value) => {
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (ctx)=>const Root()))
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child: Container(
          height: 100,
          width: 100,
          decoration: const BoxDecoration(
            color: Colors.blue,
            
            borderRadius: BorderRadius.all(Radius.circular(50))),
          child:  const Center(
            child: Text("ToRm",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 32),),
          )
          ),
        ),
        
        );
    
    
  }
}
