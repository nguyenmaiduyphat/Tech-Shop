import 'package:flutter/material.dart';
import 'package:tech_fun/models/chat_detail.dart';
import 'package:tech_fun/models/shop_detail.dart';
import 'package:tech_fun/utils/database_service.dart';

class ShopChatListPage extends StatefulWidget {
  const ShopChatListPage({super.key});

  @override
  State<ShopChatListPage> createState() => _ShopChatListState();
}

class _ShopChatListState extends State<ShopChatListPage> {
  int selectedShopIndex = 0;
  final List<ChatDetail> chatMessages = [];

  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final shop = shops[selectedShopIndex];
    final messageText = _controller.text.trim();
    if (messageText.isEmpty) return;

    final newMessage = ChatDetail(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      avatar: "https://i.pravatar.cc/150?img=1", // assuming sender avatar
      content: messageText,
      owner: "me",
      date: DateTime.now().toIso8601String(),
      images: [],
    );

    setState(() {
      chatMessages[shop.name] ??= [];
      chatMessages[shop.name]!.add(newMessage);
    });

    _controller.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  late Future<void> _loadDataFuture;

  Future<void> loadData() async {
    chatMessages = await FirebaseCloundService.getAllChatsWithIdShop(
      id: widget.product.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop = shops[selectedShopIndex];
    final messages = chatMessages[shop.name] ?? [];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Row(
        children: [
          /// LEFT PANEL – SHOP LIST
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border(right: BorderSide(color: Colors.grey.shade300)),
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
                  child: ListView.builder(
                    itemCount: shops.length,
                    itemBuilder: (context, index) {
                      final s = shops[index];
                      final isSelected = index == selectedShopIndex;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(s.avatar),
                        ),
                        title: Text(
                          s.name,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.blueAccent
                                : Colors.black87,
                          ),
                        ),
                        selected: isSelected,
                        onTap: () {
                          setState(() {
                            selectedShopIndex = index;
                          });
                        },
                      );
                    },
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
                      CircleAvatar(backgroundImage: NetworkImage(shop.avatar)),
                      const SizedBox(width: 12),
                      Text(
                        shop.name,
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
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg.owner == "me";

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.5,
                          ),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blueAccent : Colors.white,
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
                              color: isMe ? Colors.white : Colors.black87,
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
                            contentPadding: const EdgeInsets.symmetric(
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
                          icon: const Icon(Icons.send, color: Colors.white),
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
      ),
    );
  }
}
