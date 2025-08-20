import 'package:flutter/material.dart';
import 'package:tech_fun/models/chat_detail.dart';
import 'package:tech_fun/models/product_detail.dart';
import 'package:tech_fun/models/shop_detail.dart';
import 'package:tech_fun/utils/database_service.dart';
import 'package:tech_fun/utils/secure_storage_service.dart';
import 'package:tech_fun/views/mid/product_detail_page.dart';

class ShopChatListPage extends StatefulWidget {
  final ProductDetail product;
  const ShopChatListPage({super.key, required this.product});

  @override
  State<ShopChatListPage> createState() => _ShopChatListState();
}

class _ShopChatListState extends State<ShopChatListPage> {
  ShopDetail? shopDetail;
  int selectedShopIndex = 0;
  List<ChatDetail> chatMessages = [];

  final TextEditingController _controller = TextEditingController();

  Future<void> _sendMessage() async {
    final messageText = _controller.text.trim();
    if (messageText.isEmpty) return;

    final newMessage = ChatDetail(
      idUser: SecureStorageService.user!.email,
      idShop: shopDetail!.name,
      avatar: "assets/user/user1.jpg", // assuming sender avatar
      content: messageText,
      owner: "me",
      date: DateTime.now().toIso8601String(),
      images: [],
    );

    await FirebaseCloundService.addChat(newMessage);
    setState(() {
      chatMessages.add(newMessage);
    });

    _controller.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadDataFuture = loadData();
  }

  late Future<void> _loadDataFuture;

  Future<void> loadData() async {
    shopDetail = await FirebaseCloundService.getShopByNameShop(
      widget.product.shop,
    );
    chatMessages = await FirebaseCloundService.getAllChatsWithIdShop(
      idUser: SecureStorageService.user!.email,
      idShop: shopDetail!.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
                return Expanded(
                  child: Column(
                    children: [
                      // Custom Header
                      Material(
                        elevation: 2,
                        color: Colors.white,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailPage(
                                        productDetail: widget.product,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(
                                  "assets/user/user1.jpg",
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  shopDetail!.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Messages
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          itemCount: chatMessages.length,
                          itemBuilder: (context, index) {
                            final msg = chatMessages[index];
                            final isMe = msg.owner == "me";

                            return ChatMessageBubble(
                              text: msg.content,
                              isMe: isMe,
                            );
                          },
                        ),
                      ),

                      // Input box
                      SafeArea(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          color: Colors.white,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    hintText: "Type a message...",
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.blueAccent,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                  onPressed: _sendMessage,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

class ChatMessageBubble extends StatefulWidget {
  final String text;
  final bool isMe;

  const ChatMessageBubble({Key? key, required this.text, required this.isMe})
    : super(key: key);

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  List<List<Color>> gradients = [
    [Colors.blue, Colors.indigo],
    [Colors.purple, Colors.deepPurple],
    [Colors.teal, Colors.green],
  ];

  int _currentGradient = 0;

  @override
  void initState() {
    super.initState();

    // Slide-in animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(widget.isMe ? 1 : -1, 0), // Slide from left or right
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Change gradient every few seconds (optional looping animation)
    Future.delayed(const Duration(milliseconds: 800), _cycleGradient);
  }

  void _cycleGradient() {
    if (!mounted) return;

    setState(() {
      _currentGradient = (_currentGradient + 1) % gradients.length;
    });

    Future.delayed(const Duration(seconds: 3), _cycleGradient);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Align(
        alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: AnimatedContainer(
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.isMe
                  ? gradients[_currentGradient]
                  : [Colors.grey.shade200, Colors.grey.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(widget.isMe ? 16 : 0),
              bottomRight: Radius.circular(widget.isMe ? 0 : 16),
            ),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.isMe ? Colors.white : Colors.black87,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
