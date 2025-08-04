import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tech_fun/components/post_card.dart';
import 'package:animation_list/animation_list.dart';
import 'package:tech_fun/models/post_info.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late List<PostInfo> postInfos = [
    PostInfo(
      emojiTotal: 14,
      commentTotal: 14,
      shareTotal: 14,
      currentIcon: "⚫",
      avatarUser: "assets/user/user1.jpg",
      nameUser: "John Doe",
      datePost: "21/07/2025 14:32:50",
      title: "Post title goes here",
      content:
          "This is the post content. It can contain any kind of text or emojis.",
      imageContent: [
        "assets/product/product1.jpg",
        "assets/product/product2.jpg",
        "assets/product/product3.jpg",
        "assets/product/product4.jpg",
        "assets/product/product5.jpg",
        "assets/product/product6.jpg",
        "assets/product/product7.jpg",
        "assets/product/product8.jpg",
      ],
      comments: [
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
      ],
    ),
    PostInfo(
      emojiTotal: 14,
      commentTotal: 14,
      shareTotal: 14,
      currentIcon: "⚫",
      avatarUser: "assets/user/user1.jpg",
      nameUser: "John Doe",
      datePost: "21/07/2025 14:32:50",
      title: "Post title goes here",
      content:
          "This is the post content. It can contain any kind of text or emojis.",
      imageContent: [
        "assets/product/product1.jpg",
        "assets/product/product2.jpg",
        "assets/product/product3.jpg",
      ],
      comments: [
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
      ],
    ),
    PostInfo(
      emojiTotal: 14,
      commentTotal: 14,
      shareTotal: 14,
      currentIcon: "⚫",
      avatarUser: "assets/user/user1.jpg",
      nameUser: "John Doe",
      datePost: "21/07/2025 14:32:50",
      title: "Post title goes here",
      content:
          "This is the post content. It can contain any kind of text or emojis.",
      imageContent: [
        "assets/product/product1.jpg",
        "assets/product/product2.jpg",
        "assets/product/product3.jpg",
        "assets/product/product4.jpg",
        "assets/product/product5.jpg",
        "assets/product/product6.jpg",
      ],
      comments: [
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
      ],
    ),
  ];

  late List<Widget> postCards = [];

  @override
  void initState() {
    super.initState();

    for (PostInfo postInfo in postInfos) {
      postCards.add(
        PostCard(
          postInfo: postInfo,
          onPressed: () => {
            setState(() {
              postCards.removeAt(postInfos.indexOf(postInfo));
            }),
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      child: AnimationList(
        animationDirection: AnimationDirection.vertical,
        duration: 1000,
        reBounceDepth: 10.0,
        children: postCards,
      ),
    );
  }
}
