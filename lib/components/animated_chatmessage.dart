import 'package:flutter/material.dart';
import 'package:tech_fun/views/bottom_view/community_chat_page.dart';

class AnimatedChatMessage extends StatefulWidget {
  final ChatMessage message;
  final bool isMe;

  const AnimatedChatMessage({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  State<AnimatedChatMessage> createState() => _AnimatedChatMessageState();
}

class _AnimatedChatMessageState extends State<AnimatedChatMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Slide from left (not me) or right (me)
    _offsetAnimation = Tween<Offset>(
      begin: widget.isMe ? const Offset(1, 0) : const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: _buildMessage(context),
    );
  }

  Widget _buildMessage(BuildContext context) {
    final avatar = CircleAvatar(
      backgroundImage: AssetImage(widget.message.userAvatarUrl),
      radius: 20,
    );

    final msgBubble = Column(
      crossAxisAlignment: widget.isMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.isMe
                  ? "${widget.message.sentAt} - ${widget.message.userName}"
                  : "${widget.message.userName} - ${widget.message.sentAt}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: widget.isMe ? Colors.orange : Colors.white,
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
            gradient: LinearGradient(
              colors: widget.isMe
                  ? [
                      Color(0xFF43cea2),
                      Color(0xFF185a9d),
                    ] // Gradient for sender
                  : [
                      Color(0xFFf7971e),
                      Color(0xFFffd200),
                    ], // Gradient for receiver
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: widget.isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (widget.message.text.isNotEmpty)
                Text(widget.message.text, style: TextStyle(fontSize: 14)),
              if (widget.message.image.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      widget.message.image,
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
        mainAxisAlignment: widget.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.isMe
            ? [msgBubble, const SizedBox(width: 8), avatar]
            : [avatar, const SizedBox(width: 8), msgBubble],
      ),
    );
  }
}
