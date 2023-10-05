import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageTextField extends StatefulWidget {
  final String currentId;
  final String friendId;

  const MessageTextField(this.currentId, this.friendId, {super.key});

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _sendMessage(String message) async {
    // Update the last_updated field for the current user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentId)
        .collection('messages')
        .doc(widget.friendId)
        .set({
      'last_msg': message,
      'last_updated': FieldValue.serverTimestamp(), // Set the current timestamp
    });

    // Add the new message to the chats collection
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentId)
        .collection('messages')
        .doc(widget.friendId)
        .collection('chats')
        .add({
      "senderId": widget.currentId,
      "receiverId": widget.friendId,
      "message": message,
      "type": "text",
      "date": FieldValue.serverTimestamp(),
      "isRead": true,
    });

    // Update the last_updated field for the friend user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.friendId)
        .collection('messages')
        .doc(widget.currentId)
        .set({
      'last_msg': message,
      'last_updated': FieldValue.serverTimestamp(), // Set the current timestamp
    });

    // Add the new message to the chats collection for the friend user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.friendId)
        .collection('messages')
        .doc(widget.currentId)
        .collection("chats")
        .add({
      "senderId": widget.currentId,
      "receiverId": widget.friendId,
      "message": message,
      "type": "text",
      "date": FieldValue.serverTimestamp(),
      "isRead": false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    labelText: "Type your Message",
                    fillColor: Colors.grey[100],
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0),
                        gapPadding: 10,
                        borderRadius: BorderRadius.circular(25))),
              )),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () async {
              String message = _controller.text;
              _controller.clear();
              await _sendMessage(message);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}