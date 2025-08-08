// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tech_fun/models/news_detail.dart';
import 'package:tech_fun/utils/database_service.dart';
import 'package:tech_fun/views/main/layout_page.dart';
import 'package:tech_fun/views/mid/news_detail_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;

  List<NewsDetail> newsList = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _color1 = ColorTween(
      begin: const Color(0xFF0F2027),
      end: const Color.fromARGB(255, 82, 162, 184),
    ).animate(_controller);

    _color2 = ColorTween(
      begin: const Color(0xFF2C5364),
      end: const Color.fromARGB(255, 7, 77, 14),
    ).animate(_controller);
    _loadDataFuture = loadData();
  }

  late Future<void> _loadDataFuture;

  Future<void> loadData() async {
    newsList = await FirebaseCloundService.getAllNews();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  LinearGradient get techGradient => LinearGradient(
    colors: [const Color.fromARGB(255, 0, 8, 121), Colors.blueGrey[600]!],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  bool openSearch = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                animation: _controller,
                builder: (context, child) {
                  return Scaffold(
                    backgroundColor: _color1.value,
                    body: SafeArea(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_color1.value!, _color2.value!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          children: [
                            // AppBar
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => LayoutPage(),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 10),

                                  if (openSearch)
                                    Expanded(
                                      child: TextField(
                                        controller: _searchController,
                                        autofocus: true,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        cursorColor: const Color.fromARGB(
                                          255,
                                          14,
                                          167,
                                          134,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Tìm kiếm...',
                                          hintStyle: const TextStyle(
                                            color: Colors.white54,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white10,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        onSubmitted: (value) {
                                          // Xử lý tìm kiếm nếu cần
                                          setState(() {
                                            openSearch = false;
                                          });
                                        },
                                      ),
                                    )
                                  else
                                    const Expanded(
                                      child: Center(
                                        child: Text(
                                          'Tin tức',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (openSearch) {
                                          // Optional: reset search text
                                          _searchController.clear();
                                        }
                                        openSearch = !openSearch;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // Nội dung tin tức
                            Expanded(
                              child: ScrollConfiguration(
                                behavior: const MaterialScrollBehavior()
                                    .copyWith(
                                      dragDevices: {
                                        PointerDeviceKind.touch,
                                        PointerDeviceKind.mouse,
                                      },
                                    ),
                                child: AnimationLimiter(
                                  child: ListView.separated(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: newsList.length,
                                    separatorBuilder: (context, index) =>
                                        Center(
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            width: 100,
                                            height: 2,
                                            decoration: BoxDecoration(
                                              gradient: techGradient,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                    itemBuilder: (context, index) {
                                      final news = newsList[index];

                                      return AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration: const Duration(
                                          milliseconds: 600,
                                        ),
                                        child: SlideAnimation(
                                          verticalOffset: 50.0,
                                          curve: Curves.easeOutCubic,
                                          child: FadeInAnimation(
                                            child: NewsCard(
                                              newsDetail: news,
                                              gradient: techGradient,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
        }
      },
    );
  }
}

class NewsCard extends StatelessWidget {
  final NewsDetail newsDetail;
  final Gradient gradient;

  const NewsCard({super.key, required this.newsDetail, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(newsDetail: newsDetail),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  newsDetail.image,
                  width: 100,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newsDetail.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      newsDetail.content,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
