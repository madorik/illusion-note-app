import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                // 감정 선택 버튼
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[100],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined),
                    color: const Color(0xFF6B73FF),
                    onPressed: () {
                      // 감정 선택 모달 (나중에 구현)
                      _showEmotionSelector(context);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                
                // 메시지 입력 필드
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: chatProvider.textController,
                      focusNode: chatProvider.inputFocusNode,
                      enabled: !chatProvider.isLoading,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 5,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: '메시지를 입력하세요',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        chatProvider.setCurrentInput(value);
                      },
                      onSubmitted: (value) {
                        if (!chatProvider.isLoading) {
                          chatProvider.sendMessage();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                
                // 전송 버튼
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: chatProvider.currentInput.trim().isEmpty || chatProvider.isLoading
                        ? Colors.grey[300]
                        : const Color(0xFF6B73FF),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.white,
                    onPressed: chatProvider.currentInput.trim().isEmpty || chatProvider.isLoading
                        ? null
                        : () => chatProvider.sendMessage(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEmotionSelector(BuildContext context) {
    // 샘플 감정 리스트
    final emotions = [
      '행복', '슬픔', '불안', '화남', '우울', '혼란', '걱정', '만족',
      '기쁨', '희망', '좌절', '안도', '무기력', '설렘', '후회'
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '현재 감정을 선택하세요',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '선택한 감정을 바탕으로 대화를 시작할 수 있어요.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 240,
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: emotions.length,
                  itemBuilder: (context, index) {
                    final emotion = emotions[index];
                    return _buildEmotionItem(context, emotion);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmotionItem(BuildContext context, String emotion) {
    return InkWell(
      onTap: () {
        final provider = Provider.of<ChatProvider>(context, listen: false);
        provider.textController.text = '저는 지금 $emotion 감정을 느끼고 있어요.';
        provider.setCurrentInput(provider.textController.text);
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF6B73FF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF6B73FF).withOpacity(0.3),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          emotion,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B73FF),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
} 