import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tech_fun/components/DrawerMenuItem.dart';
import 'package:tech_fun/components/animatedsearchnar.dart';
import 'package:tech_fun/components/user_avatar.dart';
import 'package:tech_fun/views/bottom_view/community_chat_page.dart';
import 'package:tech_fun/views/bottom_view/my_store_page.dart';
import 'package:tech_fun/views/bottom_view/post_page.dart';
import 'package:tech_fun/views/main/inform_page.dart';
import 'package:tech_fun/views/mid/event_page.dart';
import 'package:tech_fun/views/mid/news_page.dart';
import 'package:tech_fun/views/mid/product_tech_page.dart';
import 'package:tech_fun/views/mid/profile_page.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> with TickerProviderStateMixin {
  bool loggedIn = false;
  late Color currentColor;
  final String userName = "John Doe";
  final String userRank = "Gold";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 0,
  );

  int maxCount = 5;

  bool showSearchBar = false;

  void _closeSearchBar([String? value]) {
    setState(() {
      showSearchBar = false;
    });
  }

  late AnimationController _bgController;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;
  late Animation<Color?> _color3;

  @override
  void initState() {
    // TODO: implement initState
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
      begin: const Color(0xFF2196F3), // Material Blue 500
      end: const Color(0xFF90A4AE), // Blue Grey 300
    ).animate(_bgController);

    _color3 = ColorTween(
      begin: const Color(0xFFFFFFFF), // White
      end: const Color(0xFF37474F), // Blue Grey 800 (deep tech grey)
    ).animate(_bgController);

    currentColor = Colors.white;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  /// widget list
  final List<Widget> bottomBarPages = [
    PostPage(),
    CommunityChatPage(),
    MyStorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return Container(
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
            child: Column(
              children: [
                // Mobile Header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[900],
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.deepOrange.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  height: 80,

                  child: Row(
                    children: [
                      // Hamburger menu
                      IconButton(
                        icon: Icon(Icons.menu, color: Colors.white),
                        onPressed: () =>
                            _scaffoldKey.currentState?.openDrawer(),
                      ),
                      SizedBox(width: 8),

                      // Centered logo or search
                      Expanded(child: Center(child: _LogoText())),
                    ],
                  ),
                ),
                // Body content with animated gradient
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: bottomBarPages,
                  ),
                ),
              ],
            ),
          );
        },
      ),

      // Footer
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: currentColor,
        showLabel: false,
        shadowElevation: 10,
        kIconSize: 28.0, // <- cái bạn thiếu
        kBottomRadius: 28.0,
        bottomBarWidth: MediaQuery.of(context).size.width * 0.95,
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(Icons.wifi_off_outlined, color: Colors.grey),
            activeItem: Icon(Icons.podcasts, color: Colors.blue),
            itemLabel: 'Posts',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.chat_bubble_outline_outlined,
              color: Colors.grey,
            ),
            activeItem: Icon(Icons.chat, color: Colors.orange),
            itemLabel: 'Community Chat',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.storefront_outlined, color: Colors.grey),
            activeItem: Icon(Icons.store, color: Colors.green),
            itemLabel: 'My Store',
          ),
        ],
        onTap: (index) {
          _controller.index = index;
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );

          setState(() {
            switch (_controller.index) {
              case 0:
                currentColor = Colors.white;
                break;
              case 1:
                currentColor = Colors.teal;
                break;
              case 2:
                currentColor = Colors.brown;
                break;
            }
          });
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blueGrey[900],
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo + Text
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Lottie.asset(
                        'assets/animation/EngineToolShape.json',
                        repeat: true,
                        animate: true,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Tech Fun",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(color: Colors.white54),

              // Menu Items
              DrawerMenuItem("Products", () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductTechPage(),
                  ),
                );
              }),
              DrawerMenuItem("News", () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsPage()),
                );
              }),
              DrawerMenuItem("Events", () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const EventPage()),
                );
              }),

              Divider(color: Colors.white54),
              DrawerMenuItem("Profile", () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              }),
              // Search Input
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: AnimatedSearchBar(
                  onSubmitted: (String) {
                    Navigator.pop(context);
                  },
                ),
              ),

              Spacer(),

              // Login/Register or Avatar
              Padding(
                padding: EdgeInsets.all(16),
                child: loggedIn
                    ? UserAvatar(
                        name: userName,
                        rank: userRank,
                        onTap: () {
                          setState(() {});
                        },
                      )
                    : Center(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InformPage(),
                                ),
                              );
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF1F1F1F),
                            ),
                            foregroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 212, 212, 212),
                            ),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            elevation: MaterialStateProperty.all(8),
                            shadowColor: MaterialStateProperty.all(
                              const Color.fromARGB(
                                255,
                                59,
                                59,
                                59,
                              ).withOpacity(0.4),
                            ),
                            // You can remove textStyle here if it's already in the theme
                          ),
                          child: const Text("Login / Register"),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _LogoText({Key? key}) {
    return Row(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: Lottie.asset(
            'assets/animation/EngineToolShape.json',
            repeat: true,
            animate: true,
          ),
        ),
        SizedBox(width: 8),
        Text(
          "Tech Fun",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
