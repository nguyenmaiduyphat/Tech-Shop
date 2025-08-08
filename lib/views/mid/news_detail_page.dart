// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tech_fun/models/news_detail.dart';
import 'package:tech_fun/utils/database_service.dart';
import 'package:tech_fun/views/main/layout_page.dart';

class NewsDetailPage extends StatefulWidget {
  late NewsDetail newsDetail;
  NewsDetailPage({super.key, required this.newsDetail});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage>
    with TickerProviderStateMixin {
  bool isExpanded = false;

  bool hasViewed = false;

  bool isLiked = false;
  bool isDisliked = false;
  bool isFavorited = false;

  bool isLikeHovered = false;
  bool isDislikeHovered = false;
  bool isFavoriteHovered = false;

  List<NewsDetail> newsList = [];
  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _color1 = ColorTween(
      begin: const Color(0xFF000000), // Pure Black
      end: const Color(0xFFB0BEC5), // Blue Grey 200 (cool grey tone)
    ).animate(_bgController);

    _color2 = ColorTween(
      begin: const Color.fromARGB(255, 41, 63, 82), // Material Blue 500
      end: const Color(0xFF90A4AE), // Blue Grey 300
    ).animate(_bgController);

    _color3 = ColorTween(
      begin: const Color(0xFFFFFFFF), // White
      end: const Color(0xFF37474F), // Blue Grey 800 (deep tech grey)
    ).animate(_bgController);

    // Simulate view increment (ideally you'd call an API here)
    setState(() {
      widget.newsDetail.views++;
      hasViewed = true;
    });

    _loadDataFuture = loadData();
  }

  late Future<void> _loadDataFuture;

  Future<void> loadData() async {
    newsList = await FirebaseCloundService.getAllNews();
  }

  Widget _buildIconButtonWithHover({
    required IconData icon,
    required bool isActive,
    required bool isHovered,
    required Color activeColor,
    required VoidCallback onEnter,
    required VoidCallback onExit,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      onEnter: (_) => onEnter(),
      onExit: (_) => onExit(),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive || isHovered
                ? activeColor.withOpacity(0.2)
                : const Color(0xFF1A1A1A),
            border: Border.all(
              color: isActive || isHovered ? activeColor : Colors.grey[800]!,
            ),
          ),
          child: Icon(
            icon,
            color: isActive || isHovered ? activeColor : Colors.grey[400],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  late AnimationController _bgController;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;
  late Animation<Color?> _color3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 37, 46),

      body: FutureBuilder(
        future: _loadDataFuture,
        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading....');
            default:
              if (asyncSnapshot.hasError)
                return Text('Error: ${asyncSnapshot.error}');
              else {
                return AnimatedBuilder(
                  animation: _bgController,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        // 🔵 Animated Gradient Background
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment.center,
                                radius: 1.2,
                                colors: [
                                  _color1.value ?? Colors.black,
                                  _color2.value ?? Colors.blue,
                                  _color3.value ?? Colors.white,
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                        // Background content
                        ScrollConfiguration(
                          behavior: const MaterialScrollBehavior().copyWith(
                            dragDevices: {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                            },
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(16, 60, 16, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Date & Time
                                Text(
                                  widget.newsDetail.date,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Title and views
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.newsDetail.title,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.remove_red_eye,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${widget.newsDetail.views}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // Owner
                                Text(
                                  'by ${widget.newsDetail.owner}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 8),

                                // Likes/Dislikes
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.thumb_up_alt_outlined,
                                      size: 18,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.newsDetail.likes}',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    const SizedBox(width: 16),
                                    const Icon(
                                      Icons.thumb_down_alt_outlined,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.newsDetail.dislikes}',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // Content (max 20 lines)
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E1E1E),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey[800]!,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.newsDetail.content,
                                        maxLines: isExpanded ? null : 20,
                                        overflow: isExpanded
                                            ? TextOverflow.visible
                                            : TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () => setState(
                                            () => isExpanded = !isExpanded,
                                          ),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.cyanAccent,
                                          ),
                                          child: Text(
                                            isExpanded
                                                ? 'View Less'
                                                : 'View More',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Divider(height: 32),

                                // Action Icons: Like, Dislike, Comment, Share
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // LIKE
                                    Column(
                                      children: [
                                        _buildIconButtonWithHover(
                                          icon: Icons.thumb_up_alt,
                                          isActive: isLiked,
                                          isHovered: isLikeHovered,
                                          activeColor: Colors.green,
                                          onEnter: () => setState(
                                            () => isLikeHovered = true,
                                          ),
                                          onExit: () => setState(
                                            () => isLikeHovered = false,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              if (isLiked) {
                                                widget.newsDetail.likes--;
                                                isLiked = false;
                                              } else {
                                                widget.newsDetail.likes++;
                                                isLiked = true;
                                                if (isDisliked) {
                                                  widget.newsDetail.dislikes--;
                                                  isDisliked = false;
                                                }
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),

                                    // DISLIKE
                                    Column(
                                      children: [
                                        _buildIconButtonWithHover(
                                          icon: Icons.thumb_down_alt,
                                          isActive: isDisliked,
                                          isHovered: isDislikeHovered,
                                          activeColor: Colors.red,
                                          onEnter: () => setState(
                                            () => isDislikeHovered = true,
                                          ),
                                          onExit: () => setState(
                                            () => isDislikeHovered = false,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              if (isDisliked) {
                                                widget.newsDetail.dislikes--;
                                                isDisliked = false;
                                              } else {
                                                widget.newsDetail.dislikes++;
                                                isDisliked = true;
                                                if (isLiked) {
                                                  widget.newsDetail.likes--;
                                                  isLiked = false;
                                                }
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),

                                    // COMMENT
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.comment_outlined,
                                        color: Colors.white70,
                                      ),
                                    ),

                                    // SHARE
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.share_outlined,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),

                                const Divider(height: 32),

                                // List of Reference News
                                const Text(
                                  'Related News',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...newsList
                                    .take(10)
                                    .map(
                                      (news) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                        ),
                                        child: ListTile(
                                          leading: const Icon(
                                            Icons.article_outlined,
                                            color: Colors.white60,
                                          ),
                                          title: Text(
                                            news.title, // Replace with correct field if different
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          subtitle: Text(
                                            news.content, // Replace with correct field if different
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          tileColor: const Color(0xFF1E1E1E),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            side: BorderSide(
                                              color: Colors.grey[800]!,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NewsDetailPage(
                                                      newsDetail: news,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ],
                            ),
                          ),
                        ),

                        // Home Icon (Top-Left)
                        Positioned(
                          top: 20,
                          left: 16,
                          child: IconButton(
                            icon: const Icon(Icons.home, color: Colors.white70),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LayoutPage(),
                                ),
                              );
                            },
                          ),
                        ),

                        // Favorite Icon (Top-Right)
                        Positioned(
                          top: 20,
                          right: 16,
                          child: MouseRegion(
                            onEnter: (_) =>
                                setState(() => isFavoriteHovered = true),
                            onExit: (_) =>
                                setState(() => isFavoriteHovered = false),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFavorited = !isFavorited;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (isFavorited || isFavoriteHovered)
                                      ? Colors.red.withOpacity(0.2)
                                      : Colors.transparent,
                                  border: Border.all(color: Colors.grey[800]!),
                                ),
                                child: Icon(
                                  isFavorited
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: (isFavorited || isFavoriteHovered)
                                      ? Colors.red
                                      : Colors.white70,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}
