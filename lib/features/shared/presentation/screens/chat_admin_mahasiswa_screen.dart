import 'package:flutter/material.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  ChatMessage({required this.text, required this.isMe, required this.time});
}

class ChatAdminMahasiswaScreen extends StatefulWidget {
  final String participantName;

  const ChatAdminMahasiswaScreen({super.key, required this.participantName});

  @override
  State<ChatAdminMahasiswaScreen> createState() => _ChatAdminMahasiswaScreenState();
}

class _ChatAdminMahasiswaScreenState extends State<ChatAdminMahasiswaScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(text: 'Halo pak, saya ingin bertanya tentang jadwal sidang saya.', isMe: false, time: '10:00'),
    ChatMessage(text: 'Iya Budi, jadwal kamu sudah dijadwalkan hari Jumat.', isMe: true, time: '10:05'),
    ChatMessage(text: 'Terima kasih pak atas informasinya.', isMe: false, time: '10:06'),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text,
          isMe: true,
          time: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        ),
      );
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(widget.participantName),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isMe ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isMe ? 16 : 4),
            bottomRight: Radius.circular(message.isMe ? 4 : 16),
          ),
          border: message.isMe ? null : Border.all(color: AppColors.borderLight),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.text,
              style: AppTheme.bodyMedium.copyWith(
                color: message.isMe ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.time,
              style: AppTheme.caption.copyWith(
                color: message.isMe ? Colors.white70 : AppColors.textTertiary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16).copyWith(bottom: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ketik pesan...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: AppColors.borderLight),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 24,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
