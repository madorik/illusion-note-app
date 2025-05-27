enum MessageType {
  user,
  ai,
  system,
}

class ChatMessage {
  final String id;
  final String text;
  final MessageType type;
  final DateTime timestamp;
  final String? emotion;
  final bool isTyping;

  ChatMessage({
    required this.id,
    required this.text,
    required this.type,
    required this.timestamp,
    this.emotion,
    this.isTyping = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      text: json['text'],
      type: MessageType.values.byName(json['type']),
      timestamp: DateTime.parse(json['timestamp']),
      emotion: json['emotion'],
      isTyping: json['isTyping'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'emotion': emotion,
      'isTyping': isTyping,
    };
  }
} 