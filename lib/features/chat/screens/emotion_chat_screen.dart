import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';

class EmotionChatScreen extends StatelessWidget {
  const EmotionChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: const _EmotionChatView(),
    );
  }
}

class _EmotionChatView extends StatelessWidget {
  const _EmotionChatView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '감정 대화',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF2D3748),
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Consumer<ChatProvider>(
            builder: (context, chatProvider, _) {
              return IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Color(0xFF6B73FF),
                ),
                onPressed: () => _showResetDialog(context, chatProvider),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFF718096),
            ),
            onSelected: (value) {
              switch (value) {
                case 'help':
                  _showHelpDialog(context);
                  break;
                case 'save':
                  _showSaveSuccessSnackBar(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help_outline, size: 20),
                    SizedBox(width: 8),
                    Text('도움말'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'save',
                child: Row(
                  children: [
                    Icon(Icons.bookmark_border, size: 20),
                    SizedBox(width: 8),
                    Text('대화 저장'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, _) {
                return ListView.builder(
                  controller: chatProvider.scrollController,
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(message: chatProvider.messages[index]);
                  },
                );
              },
            ),
          ),
          const ChatInput(),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, ChatProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('대화 초기화'),
        content: const Text('현재 대화 내용을 모두 지우고 새로운 대화를 시작하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              provider.clearChat();
              Navigator.of(context).pop();
            },
            child: const Text(
              '초기화',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('감정 대화 도움말'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '감정 대화 AI는 당신의 감정을 이해하고 공감하기 위해 설계되었습니다.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('● 현재 느끼는 감정을 자유롭게 표현해보세요.'),
              SizedBox(height: 8),
              Text('● 왼쪽 아래 이모티콘 버튼을 통해 감정을 선택할 수도 있어요.'),
              SizedBox(height: 8),
              Text('● AI는 당신의 감정을 분석하고 공감적인 대화를 제공합니다.'),
              SizedBox(height: 8),
              Text('● 대화 내용은 당신의 기기에만 저장되며, 원하시면 저장하거나 초기화할 수 있습니다.'),
              SizedBox(height: 16),
              Text(
                '※ 이 기능은 전문적인 심리 상담을 대체하지 않습니다. 심각한 정서적 어려움이 있다면 전문가와 상담하세요.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showSaveSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('대화 내용이 저장되었습니다.'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
} 