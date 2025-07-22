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
          const Divider(height: 8, color: Colors.white54),
          const SizedBox(height: 5),
          Expanded(
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
                        title: Text("User ${index + 1}"),
                        subtitle: Text(comments[index]),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: "Write a comment...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onSubmitted: (_) => onSubmit(),
                ),
              ),
              IconButton(icon: const Icon(Icons.send), onPressed: onSubmit),
            ],
          ),
        ],
      ),
    );
  }
}
