import 'dart:ui';
import 'package:flutter/material.dart';

class CommentSection extends StatelessWidget {
  final ValueNotifier<List<String>> commentsNotifier;
  final ScrollController scrollController;
  final TextEditingController commentController;
  final void Function() onSubmit;

  const CommentSection({
    super.key,
    required this.commentsNotifier,
    required this.scrollController,
    required this.commentController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF121C3D), // Deep tech blue
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          alignment: Alignment.center,
          child: const Text(
            "Comments",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),

        // Divider line
        Container(height: 1, width: double.infinity, color: Colors.grey[800]),

        // List of comments
        Expanded(
          child: Container(
            width: double.infinity,
            color: const Color(0xFF1C2331), // Slightly lighter tech color
            child: ValueListenableBuilder<List<String>>(
              valueListenable: commentsNotifier,
              builder: (context, comments, _) {
                return ScrollConfiguration(
                  behavior: const MaterialScrollBehavior().copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: AssetImage("assets/user/user1.jpg"),
                        ),
                        title: Text(
                          "User ${index + 1}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          comments[index],
                          style: const TextStyle(color: Colors.white70),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),

        // Comment input
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF2E3A59), // Input area background
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Write a comment...",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF3A4765),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onSubmitted: (_) => onSubmit(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: onSubmit,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
