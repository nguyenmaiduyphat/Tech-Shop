import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tech_fun/components/DrawerMenuItem.dart';
import 'package:tech_fun/components/animatedsearchnar.dart';
import 'package:tech_fun/components/user_avatar.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  bool loggedIn = false;
  final String userName = "John Doe";
  final String userRank = "Gold";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showSearchBar = false;

  void _closeSearchBar([String? value]) {
    setState(() {
      showSearchBar = false;
    });
  }

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
                Expanded(
                  child: showSearchBar
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: AnimatedSearchBar(
                            onSubmitted: _closeSearchBar,
                            onSearchIconPressed: _closeSearchBar,
                          ),
                        )
                      : _LogoText(),
                ),

                // Search or login
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      showSearchBar = !showSearchBar;
                    });
                  },
                ),
              ],
            ),
          ),

          // Body content
          Expanded(
            child: Center(
              child: Text(
                'Display other interfaces here',
                style: TextStyle(fontSize: 22, color: Colors.grey[700]),
              ),
            ),
          ),

          // Footer
          Container(
            height: 50,
            color: Colors.blueGrey[900],
            alignment: Alignment.center,
            child: Text(
              "@$currentYear CopyRight Tech Fun",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ],
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
                child: Container(
                  height: 36,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                      icon: Icon(Icons.search, size: 20),
                    ),
                  ),
                ),
              ),

              Spacer(),

              // Login or Avatar
              Padding(
                padding: EdgeInsets.all(16),
                child: loggedIn
                    ? UserAvatar(name: userName, rank: userRank)
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            loggedIn = true;
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Login"),
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
