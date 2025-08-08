// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tech_fun/models/post_info.dart';
import 'package:tech_fun/views/main/layout_page.dart';

class PostStorePage extends StatefulWidget {
  const PostStorePage({super.key});

  @override
  _MyPostsPageState createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<PostStorePage> {
  List<PostInfo> posts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF141E30), Color(0xFF243B55)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                kToolbarHeight + 24,
                16,
                16,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, i) {
                        final p = posts[i];
                        return Card(
                          color: Color(0xFF1F2A38),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                postImagePreview(p.imageContent),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.title,
                                        style: const TextStyle(
                                          color: Colors.cyanAccent,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        p.content,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.favorite,
                                            size: 16,
                                            color: Colors.pinkAccent,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${p.emojiTotal}',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Icon(
                                            Icons.comment,
                                            size: 16,
                                            color: Colors.greenAccent,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${p.commentTotal}',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.amber,
                                  ),
                                  onPressed: () =>
                                      _showPostDialog(post: p, index: i),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Custom Top Icons (Left & Right)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Row(
                children: [
                  // Left top icon
                  IconButton(
                    icon: const Icon(
                      Icons.add_box_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: _showPostDialog,
                  ),
                  Spacer(),

                  Text(
                    'My Store',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Spacer(),
                  // Right top Home button
                  IconButton(
                    icon: const Icon(
                      Icons.home_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LayoutPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPostDialog({PostInfo? post, int? index}) {
    final nameCtrl = TextEditingController(text: post?.title ?? '');
    final contentCtrl = TextEditingController(text: post?.content ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[850],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          post == null ? 'Add Post' : 'Edit Post',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentCtrl,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Content',
                hintStyle: TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () {
              final name = nameCtrl.text.trim(),
                  content = contentCtrl.text.trim();
              if (name.isEmpty || content.isEmpty) return;
              setState(() {
                if (post != null && index != null) {
                  posts[index] = PostInfo(
                    title: name,
                    content: content,
                    imageContent: [],
                    emojiTotal: 0,
                    commentTotal: 0,
                    shareTotal: 0,
                    currentIcon: '',
                    avatarUser: '',
                    nameUser: '',
                    datePost: '',
                    id: '',
                  );
                } else {
                  posts.add(
                    PostInfo(
                      title: name,
                      content: content,
                      emojiTotal: 0,
                      commentTotal: 0,
                      shareTotal: 0,
                      currentIcon: '',
                      avatarUser: '',
                      nameUser: '',
                      datePost: '',
                      imageContent: [],
                      id: '',
                    ),
                  );
                }
              });
              Navigator.pop(context);
            },
            child: Text(post == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  Widget postImagePreview(List<String> images) {
    int total = images.length;
    return SizedBox(
      width: 80,
      height: 80,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemCount: total > 4 ? 4 : total,
        itemBuilder: (context, i) {
          final isLast = i == 3 && total > 4;
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  images[i],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (isLast)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '+${total - 3}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
