import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ChatMessage {
  final String userId;
  final String userName;
  final String userAvatarUrl;
  final String text;
  final String image;
  final String sentAt;

  ChatMessage({
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
    required this.text,
    required this.image,
    required this.sentAt,
  });
}

class CommunityChatPage extends StatefulWidget {
  const CommunityChatPage({super.key});

  @override
  State<CommunityChatPage> createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends State<CommunityChatPage> {
  final List<ChatMessage> messages = [
    ChatMessage(
      userId: "user_2",
      userName: "Alice",
      userAvatarUrl: "assets/user/user1.jpg",
      text: "Hey there!",
      image: "assets/product/product1.jpg",
      sentAt: '21/07/2025 14:32:50',
    ),
    ChatMessage(
      userId: "user_3",
      userName: "Alice",
      userAvatarUrl: "assets/user/user1.jpg",
      text: "Hey there!",
      image: "assets/product/product3.jpg",
      sentAt: '19/06/2025 14:32:50',
    ),
    ChatMessage(
      userId: "user_4",
      userName: "Alice",
      userAvatarUrl: "assets/user/user1.jpg",
      text: "Hey there!",
      image: "assets/product/product2.jpg",
      sentAt: '19/06/2025 07:32:50',
    ),
    ChatMessage(
      userId: "user_5",
      userName: "Alice",
      userAvatarUrl: "assets/user/user1.jpg",
      text: "Hey there!",
      image: "assets/product/product6.jpg",
      sentAt: '16/06/2025 17:32:50',
    ),
  ];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  File? _selectedImage;

  final String currentUserId = "user_1"; // fake current user ID

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty && _selectedImage == null) return;

    final newMessage = ChatMessage(
      userId: currentUserId,
      userName: "You",
      userAvatarUrl: "assets/user/user1.jpg",
      text: text,
      image: "",
      sentAt: DateTime.now().toString().split('.')[0],
    );

    setState(() {
      messages.add(newMessage);
      _controller.clear();
      _selectedImage = null;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  File? _imageFile;
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery, // or ImageSource.camera
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Widget _buildMessage(ChatMessage message) {
    final isMe = message.userId == currentUserId;

    final avatar = CircleAvatar(
      backgroundImage: AssetImage(message.userAvatarUrl),
      radius: 20,
    );

    final msgBubble = Column(
      crossAxisAlignment: isMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              isMe
                  ? "${message.sentAt} - ${message.userName}"
                  : "${message.userName} - ${message.sentAt}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.65,
          ),
          decoration: BoxDecoration(
            color: isMe ? Colors.teal[100] : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (message.text.isNotEmpty)
                Text(message.text, style: TextStyle(fontSize: 14)),
              if (message.image.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      message.image,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isMe
            ? [msgBubble, const SizedBox(width: 8), avatar]
            : [avatar, const SizedBox(width: 8), msgBubble],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 90 + bottomPadding),
          child: ScrollConfiguration(
            behavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
            ),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemBuilder: (context, index) => _buildMessage(messages[index]),
            ),
          ),
        ),

        // Input box
        Positioned(
          left: 16,
          right: 16,
          bottom: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image, color: Colors.teal),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.teal),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
