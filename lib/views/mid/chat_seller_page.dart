import 'package:flutter/material.dart';
import 'package:tech_fun/models/comment_detail.dart';

class ChatSellerPage extends StatefulWidget {
  const ChatSellerPage({super.key});

  @override
  State<ChatSellerPage> createState() => _ChatSellerPageState();
}

class _ChatSellerPageState extends State<ChatSellerPage> {
  final TextEditingController _controller = TextEditingController();

  /// demo list messages (thay bằng dữ liệu từ Firebase)
  final List<CommentDetail> _messages = [
    CommentDetail(
      id: "1",
      content: "Xin chào, tôi muốn hỏi về sản phẩm",
      avatar: "https://i.pravatar.cc/150?img=1",
      user: "customer",
    ),
    CommentDetail(
      id: "2",
      content: "Dạ vâng, bạn cần tư vấn về sản phẩm nào ạ?",
      avatar: "https://i.pravatar.cc/150?img=2",
      user: "seller",
    ),
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        CommentDetail(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: _controller.text,
          avatar: "https://i.pravatar.cc/150?img=1",
          user: "customer", // giả định current user là customer
        ),
      );
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Chat with Seller"),
      ),
      body: Column(
        children: [
          /// list messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg.user == "customer";

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
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
                      boxShadow: [
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

          /// input box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
    );
  }
}
