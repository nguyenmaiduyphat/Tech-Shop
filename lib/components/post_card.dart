import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tech_fun/components/hovericonbutton.dart';
import 'package:tech_fun/components/reactionbutton.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late final ScrollController _listScrollController;

  final List<List<Color>> gradientColors = [
    [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
    [Color(0xFF232526), Color(0xFF414345)],
    [Color(0xFF1D4350), Color(0xFFA43931)],
    [Color(0xFF141E30), Color(0xFF243B55)],
  ];

  int _currentGradientIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emojiTotal = 14;
    commentTotal = 14;
    shareTotal = 14;
    _listScrollController = ScrollController();
    _startGradientLoop();
  }

  void _startGradientLoop() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 4));
      setState(() {
        _currentGradientIndex =
            (_currentGradientIndex + 1) % gradientColors.length;
      });
      return true;
    });
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: const Duration(seconds: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors[_currentGradientIndex],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserHeader(context),
                const SizedBox(height: 8),
                const Text(
                  "Post title goes here",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "This is the post content. It can contain any kind of text or emojis.",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                _buildImagePreview(),
                const SizedBox(height: 8),
                _buildStatsRow(),
                const Divider(height: 24, color: Colors.white24),
                _buildReactionBar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => {},
          child: const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("assets/user/user1.jpg"),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => {},
          child: const Text(
            "John Doe",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          "21/07/2025 14:32:50",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white70),
          onPressed: () => {},
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        "assets/product/product1.jpg",
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
      ),
    );
  }

  Widget _buildReactionBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ReactionButton(
            emojiTotal: emojiTotal,
            onEmojiTotalChanged: (newTotal) {
              setState(() {
                emojiTotal = newTotal;
              });
            },
          ),
        ),
        SizedBox(width: 4),
        Expanded(
          child: HoverIconButton(
            icon: Icons.comment_outlined,
            onPressed: () => _showCommentBottomSheet(context),
          ),
        ),
        SizedBox(width: 4),
        Expanded(
          child: HoverIconButton(
            icon: Icons.share_outlined,
            onPressed: () => print("Share tapped"),
          ),
        ),
      ],
    );
  }

  Widget _commentBottomSlider() {
    final List<String> comments = [
      "Great post!",
      "Love it 😍",
      "Interesting thoughts.",
      "🔥🔥🔥",
      "Thanks for sharing!",
      "Thanks for sharing!",
      "Thanks for sharing!",
      "Thanks for sharing!",
      "Thanks for sharing!",
      "Thanks for sharing!",
      "Thanks for sharing!",
      "Thanks for sharing!",
      "Thanks for sharing!",
      "Thanks for sharing!",
      "Thanks for sharing!",
    ];

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const Text(
            "Comments",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 5),
          Divider(height: 8, color: Colors.white54),
          const SizedBox(height: 5),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                // allow the sheet to drag only when list is at the top
                return false; // Let ListView handle the scroll
              },
              child: ScrollConfiguration(
                behavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: ListView.builder(
                  controller: _listScrollController,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage("assets/user/user1.jpg"),
                      ),
                      title: Text("User ${index + 1}"),
                      subtitle: Text(comments[index]),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // cho phép nội dung tràn
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, controller) => _commentBottomSlider(),
        );
      },
    );
  }

  late int emojiTotal, commentTotal, shareTotal;
  Widget _buildStatsRow() {
    return Align(
      alignment: Alignment.centerRight, // ⬅️ Anchor to right
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emoji_emotions, size: 18, color: Colors.orange),
          SizedBox(width: 4),
          Text(emojiTotal.toString(), style: TextStyle(color: Colors.white)),
          SizedBox(width: 16),
          Icon(Icons.comment, size: 18, color: Colors.white70),
          SizedBox(width: 4),
          Text(commentTotal.toString(), style: TextStyle(color: Colors.white)),
          SizedBox(width: 16),
          Icon(Icons.share, size: 18, color: Colors.white70),
          SizedBox(width: 4),
          Text(shareTotal.toString(), style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
