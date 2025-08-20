// ignore_for_file: unused_element

import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_fun/components/animated_chatmessage.dart';
import 'package:tech_fun/utils/database_service.dart';
import 'package:tech_fun/utils/secure_storage_service.dart';

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

  // Convert ChatMessage to a Map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'text': text,
      'image': image,
      'sentAt': sentAt,
    };
  }

  // Create ChatMessage from a Map
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userAvatarUrl: map['userAvatarUrl'] ?? '',
      text: map['text'] ?? '',
      image: map['image'] ?? '',
      sentAt: map['sentAt'] ?? '',
    );
  }
}

class CommunityChatPage extends StatefulWidget {
  const CommunityChatPage({super.key});

  @override
  State<CommunityChatPage> createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends State<CommunityChatPage>
    with SingleTickerProviderStateMixin {
  List<ChatMessage> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final String currentUserId = "user_1"; // fake current user ID

  Future<void> _sendMessage() async {
    if (SecureStorageService.user == null) return;
    final text = _controller.text.trim();
    if (text.isEmpty && _xfile == null) return;

    final newMessage = ChatMessage(
      userId: SecureStorageService.user!.email,
      userName: SecureStorageService.user == null
          ? 'Guest'
          : SecureStorageService.user!.email,
      userAvatarUrl: "assets/user/user1.jpg",
      text: text,
      image: 'assets/product/image.png',
      sentAt: DateTime.now().toString().split('.')[0],
    );

    await FirebaseCloundService.addMessage(newMessage);
    setState(() {
      messages.add(newMessage);
      _controller.clear();
      _xfile = null;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  XFile? _xfile;
  Uint8List? _imageBytes;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      if (kIsWeb) {
        // Web: cần dùng readAsBytes
        _imageBytes = await pickedFile.readAsBytes();
      }
      setState(() {
        _xfile = pickedFile;
      });
    }
  }

  // MESSAGE FORM
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
          mainAxisAlignment: isMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(
              isMe
                  ? "${message.sentAt} - You"
                  : "${message.userName} - ${message.sentAt}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isMe
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : const Color.fromARGB(255, 255, 153, 0),
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
            color: isMe ? Colors.teal[300] : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(isMe ? 12 : 0),
              bottomRight: Radius.circular(isMe ? 0 : 12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (message.text.isNotEmpty)
                Text(
                  message.text,
                  style: TextStyle(
                    fontSize: 14,
                    color: isMe
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(255, 255, 153, 0),
                  ),
                ),
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

  Widget buildSelectedImageWidget() {
    if (_xfile == null) return const SizedBox();

    if (kIsWeb) {
      if (_imageBytes == null) return const Text("No image data");
      return Image.memory(
        _imageBytes!,
        height: 120,
        width: 120,
        fit: BoxFit.cover,
      );
    } else {
      final file = File(_xfile!.path);
      if (!file.existsSync()) return const Text("File not found");
      return Image.file(file, height: 120, width: 120, fit: BoxFit.cover);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadDataFuture = loadData();
  }

  late Future<void> _loadDataFuture;

  Future<void> loadData() async {
    messages = await FirebaseCloundService.getAllMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      // or use animateTo for smooth scroll:
      // _scrollController.animateTo(
      //   _scrollController.position.maxScrollExtent,
      //   duration: Duration(milliseconds: 300),
      //   curve: Curves.easeOut,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: _loadDataFuture,
        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading....');
            default:
              if (asyncSnapshot.hasError) {
                return Text('Error: ${asyncSnapshot.error}');
              } else {
                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 75 + bottomPadding),
                      child: ScrollConfiguration(
                        behavior: const MaterialScrollBehavior().copyWith(
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                          },
                        ),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final isMe = SecureStorageService.user != null
                                ? message.userId ==
                                      SecureStorageService.user!.email
                                : false;
                            return AnimatedChatMessage(
                              message: message,
                              isMe: isMe,
                            );
                          },
                        ),
                      ),
                    ),

                    // Input box
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 10,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_xfile != null)
                            Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: buildSelectedImageWidget(),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _xfile = null;
                                        _imageBytes = null;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
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
                                  icon: const Icon(
                                    Icons.image,
                                    color: Colors.teal,
                                  ),
                                  onPressed: _pickImage,
                                ),
                                Expanded(
                                  child: TextField(
                                    cursorColor: const Color.fromARGB(
                                      255,
                                      14,
                                      167,
                                      134,
                                    ),
                                    controller: _controller,
                                    decoration: const InputDecoration(
                                      hintText: "Type a message...",
                                      border: InputBorder.none,
                                    ),
                                    onSubmitted: (_) => _sendMessage(),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.teal,
                                  ),
                                  onPressed: _sendMessage,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
          }
        },
      ),
    );
  }
}
