import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kibu_renting_app/view/login.dart';

import '../controller/Root/auth.dart';


class ForgotPass extends StatefulWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ForgotPass({Key? key}) : super(key: key);

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final TextEditingController _emailcontroller = TextEditingController();
  final formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Enter your Email addresss here",
                  style: TextStyle(
                      color: Color.fromARGB(
                        255,
                        1,
                        27,
                        71,
                      ),
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _emailcontroller,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  ),
                  validator: (email) => !EmailValidator.validate(email!) ?
                  "Enter Valid Email":null,
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final form=formkey.currentState;
                    if(form!.validate()){
                      final emailfield=_emailcontroller.text;

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                              child: CircularProgressIndicator(),
                            ));

                             final rvalue = await Authenticate(auth: widget.auth)
                        .resetPassword(email: emailfield);
                    Navigator.of(context).popUntil((route) => false);
          
                    if (rvalue == "Success") {
                      _emailcontroller.clear();
          
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text("Password reset Email sent"),
                            actions: [
                              TextButton(
                                child: const Text("Ok"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login(auth:widget.auth, firestore: widget.firestore)),
                          );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(rvalue!)),
                      );
                    }
                      
                    }
                    
          
                   
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 1, 27, 71))),
                  child: const Center(
                      child: Text(
                    "Verify",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}