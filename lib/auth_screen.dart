import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'main.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future signInFunction() async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    DocumentSnapshot userExist =
        await firestore.collection('users').doc(userCredential.user!.uid).get();

    if (userExist.exists) {
      print("User Already Exists in Database");
    } else {
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'name': userCredential.user!.displayName,
        'image': userCredential.user!.photoURL,
        'uid': userCredential.user!.uid,
        'date': DateTime.now(),
      });
    }

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double deviceWidth = mediaQuery.size.width;
    final double deviceHeight = mediaQuery.size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: deviceWidth * 0.7, // Adjust the width as needed
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/paxal_logo.png"),
                    ),
                  ),
                ),
              ),
              Text(
                "Paxal Chat",
                style: TextStyle(
                    fontSize: deviceWidth * 0.1, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: deviceWidth * 0.04,
                    vertical: deviceHeight * 0.04),
                child: ElevatedButton(
                  onPressed: () async {
                    await signInFunction();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding:
                        EdgeInsets.symmetric(vertical: deviceHeight * 0.02),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png',
                        height:
                            deviceHeight * 0.05, // Adjust the height as needed
                      ),
                      SizedBox(
                        width: deviceWidth * 0.02,
                      ),
                      const Text(
                        "Sign in With Google",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
