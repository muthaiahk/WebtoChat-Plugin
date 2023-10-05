  // chat_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web2app/message_textfield.dart';
import 'package:web2app/single_message.dart';
import 'package:web2app/user_model.dart';

class ChatScreen extends StatefulWidget {
  final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendImage;

  const ChatScreen({
    super.key,
    required this.currentUser,
    required this.friendId,
    required this.friendName,
    required this.friendImage,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  DateTime? parseTimestamp(dynamic timestampData) {
    if (timestampData == null) {
// Return a default date or handle it as needed
      return null; // Return null if timestampData is null
    } else {
      return (timestampData as Timestamp).toDate();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This callback is executed after the widget is fully built
      scrollToBottom();
    });
  }

  // Rest of your code...

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.friendImage),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Text(
              widget.friendName,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.currentUser.uid)
                    .collection('messages')
                    .doc(widget.friendId)
                    .collection('chats')
                    .orderBy("date", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error fetching data"));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("Say Hi"),
                    );
                  }

                  final messages = snapshot.data!.docs.reversed.toList();
                  List<Widget> messageWidgets = [];
                  DateTime? currentDate;

                  for (int i = messages.length - 1; i >= 0; i--) {
                    final message = messages[i];
                    final messageDate = parseTimestamp(message['date']);

                    if (messageDate != null) {
                      final formattedDate =
                          DateFormat('MMM dd, yyyy').format(messageDate);

                      if (currentDate == null ||
                          !isSameDate(currentDate, messageDate)) {
                        currentDate = messageDate;
                        messageWidgets.insert(
                          0,
                          _buildDateSeparator(formattedDate),
                        );
                      }

// Check if the message is from the friend and is unread
                      if (message['senderId'] == widget.friendId &&
                          !message['isRead']) {
// Update the "isRead" field to true
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(widget.currentUser.uid)
                            .collection('messages')
                            .doc(widget.friendId)
                            .collection('chats')
                            .doc(message.id)
                            .update({
                          "isRead": true,
                        });
                      }

                      messageWidgets.insert(
                          0,
                          SingleMessage(
                            message: message['message'],
                            isMe: message['senderId'] == widget.currentUser.uid,
                            messageDate: messageDate,
                          ));
                    }
                  }

                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: messageWidgets.length,
                    itemBuilder: (context, index) {
                      return messageWidgets[index];
                    },
                  );
                },
              ),
            ),
          ),
          MessageTextField(widget.currentUser.uid, widget.friendId),
        ],
      ),
    );
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildDateSeparator(String formattedDate) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      child: Text(
        formattedDate,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    );
  }
}
