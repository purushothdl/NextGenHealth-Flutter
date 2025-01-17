// lib/features/chat/models/chat_model.dart
class ChatSession {
  final String sessionId;
  final String userId;
  final String? ticketId;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatSession({
    required this.sessionId,
    required this.userId,
    this.ticketId,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      sessionId: json['session_id'],
      userId: json['user_id'],
      ticketId: json['ticket_id'],
      messages: (json['messages'] as List)
          .map((msg) => ChatMessage.fromJson(msg))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

// lib/features/chat/models/chat_model.dart
class ChatMessage {
  final String sender;
  final String text;
  final DateTime timestamp;
  final String? imagePath;
  final String? documentPath;

  bool get isUser => sender == 'user';

  ChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
    this.imagePath,
    this.documentPath,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      sender: json['sender'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
      imagePath: json['image_path'],
      documentPath: json['document_path'],
    );
  }
}