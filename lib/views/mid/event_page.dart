// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:tech_fun/views/main/layout_page.dart';
import 'package:tech_fun/views/mid/event_detail_page.dart';

class EventPage extends StatefulWidget {

  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;

  final List<Map<String, dynamic>> eventList = [
    {
      'title': 'Flutter 3.22 Released',
      'description': 'New Material 3 widgets and performance improvements.',
      'image': 'assets/product/product1.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'AI-Powered Coding with Dart',
      'description':
          'Explore the integration of AI tools with Dart and Flutter.',
      'image': 'assets/product/product1.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'Quantum Computing Trends',
      'description': 'A look into how quantum computing impacts tech industry.',
      'image': 'assets/product/product1.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'Cloud Firestore vs. Realtime Database',
      'description': 'Which Firebase solution suits your app needs?',
      'image': 'assets/product/product2.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'Top Flutter Packages in 2025',
      'description': 'Check out the most useful Flutter packages this year.',
      'image': 'assets/product/product2.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'Understanding State Management',
      'description': 'Get a deep dive into Riverpod, Bloc and Provider.',
      'image': 'assets/product/product3.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'Google I/O 2025 Highlights',
      'description': 'Key announcements and innovations from Google.',
      'image': 'assets/product/product3.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'Dart 3.2 Brings Async Enhancements',
      'description': 'Better support for concurrent programming in Dart.',
      'image': 'assets/product/product4.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'Why You Should Learn Flutter Today',
      'description': 'Fast, cross-platform development is the future.',
      'image': 'assets/product/product4.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'Building Responsive UI in Flutter',
      'description': 'Tips and tricks for adaptive layouts.',
      'image': 'assets/product/product5.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'Tech Salaries in 2025: What’s Changing?',
      'description': 'A report on the latest compensation trends.',
      'image': 'assets/product/product5.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'Cybersecurity in Mobile Apps',
      'description': 'Best practices to protect your user data.',
      'image': 'assets/product/product6.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'Flutter for Web: Ready for Production?',
      'description': 'Analyzing the strengths and challenges.',
      'image': 'assets/product/product6.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'The Rise of Edge Computing',
      'description': 'Shifting workloads closer to users.',
      'image': 'assets/product/product7.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'Top VS Code Extensions for Flutter Devs',
      'description': 'Boost your productivity with these tools.',
      'image': 'assets/product/product7.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'Deploying Flutter Apps to App Store & Play Store',
      'description': 'Step-by-step deployment guide.',
      'image': 'assets/product/product8.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'Augmented Reality with Flutter',
      'description': 'Integrate AR features into your apps.',
      'image': 'assets/product/product8.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'CI/CD for Flutter with GitHub Actions',
      'description': 'Automate your build and release process.',
      'image': 'assets/product/product9.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'The Future of Cross-platform Development',
      'description': 'Flutter vs React Native: who wins?',
      'image': 'assets/product/product9.jpg',
      'status': EventStatus.none,
    },
    {
      'title': 'Using AI for UX Personalization',
      'description': 'Deliver smarter UI with user behavior tracking.',
      'image': 'assets/product/product10.jpg',
      'status': EventStatus.none,
    },
  ];

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
                                builder: (_) =>
                                    LayoutPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 10),

                        if (openSearch)
                          Expanded(
                            child: TextField(
                              cursorColor: const Color.fromARGB(
                                255,
                                14,
                                167,
                                134,
                              ),
                              controller: _searchController,
                              autofocus: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Tìm kiếm...',
                                hintStyle: const TextStyle(
                                  color: Colors.white54,
                                ),
                                filled: true,
                                fillColor: Colors.white10,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
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
                          icon: const Icon(Icons.search, color: Colors.white),
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

                  // Nội dung
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: const MaterialScrollBehavior().copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        },
                      ),
                      child: AnimationLimiter(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: eventList.length,
                          separatorBuilder: (context, index) => Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              width: 100,
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: techGradient,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          itemBuilder: (context, index) {
                            final event = eventList[index];

                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 600),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                curve: Curves.easeOutCubic,
                                child: FadeInAnimation(
                                  child: EventCard(
                                    title: event['title']!,
                                    description: event['description']!,
                                    image: event['image']!,
                                    gradient: techGradient,
                                    status: event['status'] ?? EventStatus.none,
                                    onPressed: () async {
                                      final result =
                                          await Navigator.push<EventStatus>(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EventDetailPage(
                                                    eventStatus:
                                                        event['status'],
                             
                                                  ),
                                            ),
                                          );
                                      if (result != null) {
                                        setState(() {
                                          event['status'] = result;
                                        });
                                      }
                                    },
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

enum EventStatus { none, joined, refused }

class EventCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final Gradient gradient;
  final EventStatus status;
  final VoidCallback onPressed;

  const EventCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.gradient,
    required this.status,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Choose border color based on status
    Color borderColor;
    switch (status) {
      case EventStatus.joined:
        borderColor = Colors.green;
        break;
      case EventStatus.refused:
        borderColor = Colors.red;
        break;
      case EventStatus.none:
        borderColor = Colors.transparent;
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: 3,
          ), // border width 3 for visible effect
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
                  image,
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
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
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
