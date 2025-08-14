import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tech_fun/components/post_card.dart';
import 'package:animation_list/animation_list.dart';
import 'package:tech_fun/models/post_info.dart';
import 'package:tech_fun/utils/database_service.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late List<PostInfo> postInfos = [];

  late List<Widget> postCards = [];

  @override
  void initState() {
    super.initState();

    _loadDataFuture = loadData();
  }

  late Future<void> _loadDataFuture;

  Future<void> loadData() async {
    postInfos = await FirebaseCloundService.getAllPosts();
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
    return FutureBuilder(
      future: _loadDataFuture,
      builder: (context, asyncSnapshot) {
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading....');
          default:
            if (asyncSnapshot.hasError) {
              return Text('Error: ${asyncSnapshot.error}');
            } else {
              return ScrollConfiguration(
                behavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
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
      },
    );
  }
}
