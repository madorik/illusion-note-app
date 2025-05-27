import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  
  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;
    final isSystem = message.type == MessageType.system;
    
    if (isSystem) {
      return _buildSystemMessage(context);
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (message.emotion != null && !isUser)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 4),
                    child: Text(
                      '감정: ${message.emotion}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isUser 
                        ? const Color(0xFF6B73FF)
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: message.isTyping
                      ? _buildTypingIndicator()
                      : Text(
                          message.text,
                          style: TextStyle(
                            color: isUser ? Colors.white : const Color(0xFF2D3748),
                            fontSize: 15,
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                  child: Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) 
            const SizedBox(width: 32) // 사용자 메시지 아바타 자리 공백
        ],
      ),
    );
  }

  Widget _buildSystemMessage(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFECF2FE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD1DEFA),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Color(0xFF6B73FF),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message.text,
              style: const TextStyle(
                color: Color(0xFF4A5568),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF6B73FF).withOpacity(0.1),
        border: Border.all(
          color: const Color(0xFF6B73FF).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.psychology_outlined,
          color: Color(0xFF6B73FF),
          size: 18,
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(1),
        _buildDot(2),
        _buildDot(3),
      ],
    );
  }

  Widget _buildDot(int position) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 300 * position),
        builder: (context, value, child) {
          return Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF6B73FF).withOpacity(value),
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return DateFormat('HH:mm').format(timestamp);
  }
} 