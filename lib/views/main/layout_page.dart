import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tech_fun/components/DrawerMenuItem.dart';
import 'package:tech_fun/components/animatedsearchnar.dart';
import 'package:tech_fun/components/user_avatar.dart';
import 'package:tech_fun/views/bottom_view/community_chat_page.dart';
import 'package:tech_fun/views/bottom_view/my_store_page.dart';
import 'package:tech_fun/views/bottom_view/post_page.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentColor = Colors.white;
  }

  @override
  void dispose() {
    _pageController.dispose();

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
    final currentYear = DateTime.now().year;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          // Mobile Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 80,
            color: Colors.blueGrey[900],
            child: Row(
              children: [
                // Hamburger menu
                IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                SizedBox(width: 8),

                // Centered logo or search
                Expanded(child: Center(child: _LogoText())),
              ],
            ),
          ),

          // Body content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // disables swipe
              children: bottomBarPages,
            ),
          ),
        ],
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
          _pageController.jumpToPage(index);

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
              DrawerMenuItem("Products", () => Navigator.pop(context)),
              DrawerMenuItem("News", () => Navigator.pop(context)),
              DrawerMenuItem("Events", () => Navigator.pop(context)),

              Divider(color: Colors.white54),

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
                          setState(() {
                            loggedIn = false;
                            Navigator.pop(context);
                          });
                        },
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                loggedIn = true;
                                Navigator.pop(context);
                              });
                            },
                            child: Text("Login"),
                          ),
                          SizedBox(height: 8),
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                            child: Text("Register"),
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
