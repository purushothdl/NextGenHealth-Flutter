// lib/features/chat/widgets/chat_message_widget.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chat_model.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) 
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 16,
                child: Icon(Icons.medical_services, size: 20),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, h:mm a').format(message.timestamp.toLocal()),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser)
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                radius: 16,
                child: Icon(Icons.person, size: 20),
              ),
            ),
        ],
      ),
    );
  }
}