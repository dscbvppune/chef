import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.red,
        buttonColor: Colors.red,
      ),
    )
  );
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String name, email, displayPicture, uid;

  final googleBlue = const Color(0xFF4285F4);
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final AuthResult authResult = await auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    Map<String, dynamic> tempMap= {
      "name": user.displayName,
      "email": user.email,
      "photo": user.photoUrl,
      "uid": user.uid
    };

    var databaseOfUsers = Firestore.instance.collection("users");
    databaseOfUsers.add(tempMap);
    return user;
  }

  Widget signInButton(){
   return new ClipRRect(
     borderRadius: BorderRadius.circular(64),
      child: new RaisedButton(
        onPressed: () async{
          FirebaseUser user = await _handleSignIn();
          name = user.displayName;
          email = user.email;
          displayPicture = user.photoUrl;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen(
                name: name,
                email: email,
                photoURL: displayPicture,
                uid: user.uid,
              )
            )
          );
        },
        padding: EdgeInsets.only(
          top: 6,
          bottom: 6,
          left: 12
        ),
        color: Colors.red,
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: 10.0,right: 10.0
              ),
              child: new Text(
                "Sign in with ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "Product Sans"
                ),
              )
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage(
                  'assets/images/google-logo.jpg',
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  signInSilently() async{
    var user = await googleSignIn.signInSilently();
    var email = user.email;

    name = user.displayName;
    displayPicture = user.photoUrl;
    var uid;
    var tempRef = await Firestore.instance.collection("users").where("email", isEqualTo: email).getDocuments();
    uid = tempRef.documents[0]["uid"];
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => HomeScreen(
          name: name,
          email: email,
          photoURL: displayPicture,
          uid: uid,
        )
      )
    );
  }

  @override
  void initState() {
    signInSilently();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 64,
              ),
              Image.asset(
                "assets/images/logo.png",
                scale: 0.5,
              ),
              SizedBox(
                height: 48,
              ),
              Text(
                "Welcome!",
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: "Montserrat"
                )
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Sign in to continue",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Montserrat"
                )
              ),
              SizedBox(
                height: 48,
              ),
              signInButton(),
              SizedBox(
                height: 64,
              )
            ],
          ),
        ),
      ),
    );
  }
}