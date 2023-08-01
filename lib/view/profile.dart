import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kibu_renting_app/view/login.dart';

import '../controller/Root/auth.dart';



class Profile extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  const Profile({super.key, required this.auth, required this.firestore});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

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
    return SafeArea(
      child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
          children: [
            IconButton(onPressed: (){
              Navigator.pop(context);},
               icon:  Icon(FontAwesomeIcons.angleLeft,size: 24,)),
             const Padding(
              padding: EdgeInsets.only(left:30.0),
              child: Text('My Profile',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,),),
            ),
          ],
        ),
            Container(
              height: 80,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0),border: Border.all(color: Colors.grey),),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading:  Icon(FontAwesomeIcons.user,size: 32,),
                  trailing:  Icon(FontAwesomeIcons.angleRight,),
                  title: Row(
                    children: [
                      Text("${widget.auth.currentUser?.email}"),
                      const Icon(Icons.verified,color: Colors.blue,)
                    ],
                  ) ,
                  onTap: () {
                    
                  },
                ),
              ),
            ),
            Divider(),
            Container(
              height: 50,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0),border: Border.all(color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.only(bottom:10.0),
                child: ListTile(
                  leading:  Icon(FontAwesomeIcons.creditCard,size: 32,),
                  trailing:  const Icon(FontAwesomeIcons.angleRight, ),
                  title:  Text("Payments & purchases") ,
                  onTap: () {
                    
                  },
                ),
              ),
            ),
            Divider(),
             const Text("Settings & Preferences",),
            const SizedBox(height: 5,),
            Container(
              height: 50,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0),border: Border.all(color: Colors.grey)),
              child: Padding(
                 padding: const EdgeInsets.only(bottom:10.0),
                child: ListTile(
                  leading:  Icon(Icons.notifications,),
                  title:  const Text('Notification',),
                  trailing:  Icon(FontAwesomeIcons.angleRight),
                  onTap: () {
                    
                  },
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              height: 50,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0),border: Border.all(color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.only(bottom:10.0),
                child: ListTile(
                  leading:  const Icon(Icons.dark_mode),
                  title:  const Text('Dark Mode',),
                  trailing: Switch(
                    value: true, 
                    onChanged: (value) {
                   
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              height: 50,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0),border: Border.all(color: Colors.grey)),
              child: Padding(
                 padding: const EdgeInsets.only(bottom:10.0),
                child: ListTile(
                  title:  const Text('Language',),
                  leading: const Icon(FontAwesomeIcons.language,),
                  trailing:  const Icon(FontAwesomeIcons.angleRight,),
                  onTap: () {
                    
                  },
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              height: 50,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0),border: Border.all(color: Colors.grey)),
              child: Padding(
                 padding: const EdgeInsets.only(bottom:10.0),
                child: ListTile(
                  title: const Text('Security',),
                  leading: Icon(FontAwesomeIcons.shield,),
                 trailing:  const Icon(FontAwesomeIcons.angleRight,),
                  onTap: () {
                    
                  },
                ),
              ),
            ),
            Divider(),
            //Support Section
            Text('Support',),
            const SizedBox(height: 5,),
            Container(
              height: 50,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0),border: Border.all(color: Colors.grey)),
              child: Padding(
                 padding: const EdgeInsets.only(bottom:10.0),
                child: ListTile(
                      title: Text('Help center'),
                      leading:  const Icon(FontAwesomeIcons.book,),
                      trailing:  Icon(FontAwesomeIcons.angleRight,),
                      onTap: () {
                        
                      },
                    ),
              ),
            ),
            const SizedBox(height: 10,),
                Container(
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0),border: Border.all(color: Colors.grey)),
                  child: Padding(
                     padding: const EdgeInsets.only(bottom:10.0),
                    child: ListTile(
                      title: const Text('Report a bug'),
                      leading: Icon(FontAwesomeIcons.flag,),
                     trailing:  Icon(FontAwesomeIcons.angleRight,),
                      onTap: () {
                        
                      },
                    ),
                  ),
                ),
                Divider(),
                TextButton(onPressed: ()async{
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

                }, child:  const Row(
                  children: [
                    Icon(FontAwesomeIcons.arrowRightToBracket),
                    SizedBox(width: 10,),
                    Text("Logout",style: TextStyle(letterSpacing: 0.5,fontSize: 24,fontWeight: FontWeight.bold),)
                  ],
                ))
          ],
        ),
      ),
    )
    );
  }
}
