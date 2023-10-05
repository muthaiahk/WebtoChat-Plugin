import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleMessage extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime messageDate;

  SingleMessage({
    required this.message,
    required this.isMe,
    required this.messageDate,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: mediaQuery.size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? Colors.blue[100]
              : Colors.teal[50], // Use a different color for the background
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius:
                  8, // Increase the blur radius for a more prominent shadow effect
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.black : Colors.black,
                fontSize: 18, // Increase font size for better readability
                fontWeight: FontWeight.w500, // Add a font weight for emphasis
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('hh:mm a').format(messageDate),
              style: TextStyle(
                color: Colors
                    .grey[600], // Use a slightly darker color for the time text
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
