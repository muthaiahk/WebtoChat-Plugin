// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:web2app/search_screen.dart';
import 'package:web2app/user_model.dart';

import 'auth_screen.dart';
import 'chat_screen.dart';
import 'notification_services.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  HomeScreen({required this.user, Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Instance of NotificationServices to handle notifications
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();

    // Request permission for notifications
    notificationServices.requestNotificationPermission();

    // Initialize Firebase Messaging for handling notifications
    notificationServices.firebaseInit(
        context, widget.user); // Pass the userModel here

    // Set up notification handling when app is in background or terminated
    notificationServices.setupInteractMessage(context);

    // Check for token refresh and request a new device token
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken();

    // Start a periodic timer to refresh the device token
    notificationServices.startTokenRefreshPeriodically();
  }

  // Function to handle the refresh action
  Future<void> _handleRefresh() async {
    try {
      // Fetch the updated list of messages
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .collection('messages')
          .orderBy("last_updated", descending: true)
          .get();

      // Extract the list of messages from the snapshot
      List<DocumentSnapshot> messages = snapshot.docs;

      // Filter the list of messages to only include online users
      List<DocumentSnapshot> onlineMessages = [];
      for (var message in messages) {
        String friendId = message.id;
        DocumentSnapshot friendDataSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(friendId)
            .get();
        var friendData =
            friendDataSnapshot.data() as Map<String, dynamic>; // Cast to Map
        if (friendData.containsKey('isOnline')) {
          bool isOnline = friendData['isOnline'];
          if (isOnline) {
            onlineMessages.add(message);
          }
        }
      }

      // Update the state with the filtered list of messages to trigger a rebuild
      setState(() {
        messages = onlineMessages;
      });
    } catch (e) {
      // Handle any error that may occur during the refresh
      print('Error while refreshing: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: const Text('Help Chat'),
      centerTitle: true,
      backgroundColor:
          Colors.transparent, // Set the background color to transparent
      elevation: 0, // Remove the shadow under the app bar
      actions: [
        IconButton(
          onPressed: () async {
            await GoogleSignIn().signOut();
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AuthScreen()),
              (route) => false,
            );
          },
          icon: const Icon(Icons.logout),
        )
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6B52AE),
              Color(0xFFC34F99)
            ], // Purple gradient colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );

    return SafeArea(
        child: Scaffold(
      appBar: appBar,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.user.uid)
              .collection('messages')
              .orderBy("last_updated", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> messages = snapshot.data!.docs;
              if (messages.isEmpty) {
                return const Center(
                  child: Text("No Chats Available!"),
                );
              }

              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var friendId = messages[index].id;
                  var lastMsg = messages[index]['last_msg'];

                  // Get the chat messages for the current user and friend
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.user.uid)
                        .collection('messages')
                        .doc(friendId)
                        .collection('chats')
                        .orderBy("date", descending: true)
                        .snapshots(),
                    builder: (context, chatSnapshot) {
                      if (chatSnapshot.hasData) {
                        List<DocumentSnapshot> chatMessages =
                            chatSnapshot.data!.docs;

                        // Calculate the unread message count
                        int unreadCount = chatMessages
                            .where((message) => message['isRead'] == false)
                            .length;

                        return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(friendId)
                              .get(),
                          builder: (context, asyncSnapshot) {
                            if (asyncSnapshot.hasData) {
                              var friendData = asyncSnapshot.data
                                  ?.data(); // Get the document data as a Map
                              if (friendData == null) {
                                // Handle the case where the document does not exist
                                return Container(); // Return an empty container or any other UI widget you prefer
                              }
                              // Check if the 'isOnline' field exists in the document data
                              bool isFriendOnline =
                                  friendData.containsKey('isOnline')
                                      ? friendData['isOnline']
                                      : false;
                              // If the friend is not online, skip displaying the ListTile
                              if (!isFriendOnline) {
                                return Container(); // Return an empty container or any other UI widget you prefer
                              }
                              return ListTile(
                                leading: Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(friendData['image']),
                                    ),
                                    if (unreadCount > 0)
                                      Positioned(
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                          child: Text(
                                            '$unreadCount',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                title: Text(
                                  friendData['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "$lastMsg",
                                  style: const TextStyle(color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        currentUser: widget.user,
                                        friendId: friendId,
                                        friendName: friendData['name'],
                                        friendImage: friendData['image'],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            return const LinearProgressIndicator();
                          },
                        );
                      }
                      return const LinearProgressIndicator();
                    },
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(widget.user),
            ),
          );
        },
      ),
    ));
  }
}
