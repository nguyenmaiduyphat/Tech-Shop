import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tech_fun/components/post_card.dart';
import 'package:animation_list/animation_list.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      child: AnimationList(
        animationDirection: AnimationDirection.horizontal,
        duration: 1000,
        reBounceDepth: 10.0,
        children: [
          const PostCard(),
          const PostCard(),
          const PostCard(),
          const PostCard(),
          const PostCard(),
          const PostCard(),
        ],
      ),
    );
  }
}
