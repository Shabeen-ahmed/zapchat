import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test1/Screens/LoginPage.dart';
import 'package:test1/Screens/MessageScreen.dart';
import 'MessageScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'kConstants.dart';

class registerpage extends StatefulWidget {
  @override
  _registerpageState createState() => _registerpageState();
}

class _registerpageState extends State<registerpage> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          Expanded(flex: 2, child: Container()),
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      fillColor: Colors.black12,
                      filled: true,
                      icon: Icon(
                        Icons.email,
                        color: Colors.red,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          gapPadding: 0,
                          borderRadius: BorderRadius.circular(18)),
                      hintText: 'Email',
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.black,
                      ),
                    ),
                    onChanged: (value) {
                      email = value;
                    },
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        fillColor: Colors.black12,
                        filled: true,
                        icon: Icon(
                          Icons.password,
                          color: Colors.red,
                        ),
                        hintText: 'Password',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            gapPadding: 15,
                            borderRadius: BorderRadius.circular(18))),
                    onChanged: (value) {
                      password = value;
                    },
                    textAlign: TextAlign.center,
                  ),
                  kButton(
                      buttonLabel: 'Register',
                      onpress: () async {
                        try {
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          if (newUser != null) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return messagepage();
                            }));
                          }
                        } catch (e) {
                          String errorr=e.toString();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Error"),
                                  content: Text(errorr),
                                  actions: [
                                    FlatButton(
                                      child: Text("Ok"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        }
                        ;
                      }),
                ],
              )),
            ),
          ),
          Expanded(child: Container()),
        ]),
      ),
    );
  }
}
