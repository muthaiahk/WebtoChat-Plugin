import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:web2app/user_model.dart';
import 'auth_screen.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackroundHandler);
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackroundHandler(RemoteMessage message) async {
  print(message.notification!.title.toString());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Future<Widget> userSignedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      UserModel userModel = UserModel.fromJson(userData);
      return HomeScreen(user: userModel);
    } else {
      return AuthScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Help Chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: userSignedIn(),
            builder: (context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              }
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
                }));
  }
}
