import 'package:flutter/material.dart';
import 'package:tech_fun/models/chat_detail.dart';
import 'package:tech_fun/models/shop_detail.dart';
import 'package:tech_fun/utils/database_service.dart';
import 'package:tech_fun/utils/secure_storage_service.dart';

class ShopChatListPage extends StatefulWidget {
  final String shopName;
  const ShopChatListPage({super.key, required this.shopName});

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
    shopDetail = await FirebaseCloundService.getShopByNameShop(widget.shopName);
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
                return Row(
                  children: [
                    /// LEFT PANEL – SHOP LIST
                    Container(
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border(
                          right: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          const Text(
                            "Shops",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(
                                  "assets/user/user1.jpg",
                                ),
                              ),
                              title: Text(
                                shopDetail!.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,

                                  color: Colors.blueAccent,
                                ),
                              ),
                              selected: true,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// RIGHT PANEL – CHAT AREA
                    Expanded(
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage(
                                    "assets/user/user1.jpg",
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  shopDetail!.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Messages
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: chatMessages.length,
                              itemBuilder: (context, index) {
                                final msg = chatMessages[index];
                                final isMe = msg.owner == "me";

                                return Align(
                                  alignment: isMe
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                          0.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isMe
                                          ? Colors.blueAccent
                                          : Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(16),
                                        topRight: const Radius.circular(16),
                                        bottomLeft: isMe
                                            ? const Radius.circular(16)
                                            : Radius.zero,
                                        bottomRight: isMe
                                            ? Radius.zero
                                            : const Radius.circular(16),
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      msg.content,
                                      style: TextStyle(
                                        color: isMe
                                            ? Colors.white
                                            : Colors.black87,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Input box
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            color: Colors.white,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      hintText: "Type a message...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade200,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 0,
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                CircleAvatar(
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
