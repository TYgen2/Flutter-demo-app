import 'package:demo_app/components/bottom_bar.dart';
import 'package:demo_app/pages/about_page.dart';
import 'package:demo_app/pages/art_page.dart';
import 'package:demo_app/pages/favourite_page.dart';
import 'package:demo_app/pages/intro.dart';
import 'package:demo_app/pages/search.dart';
import 'package:demo_app/services/auth.dart';
import 'package:demo_app/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demo_app/models/user.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // keep tracking the selected index for controling page switch
  int _selectedIndex = 0;
  final AuthService _auth = AuthService();

  // Update selected index by tapping the bottom bar
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    // artwork page
    const ArtPage(),

    // search page
    const FavouritePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<myUser?>(context);
    bool isDark =
        Provider.of<ThemeProvider>(context, listen: false).checkTheme();

    MaterialStateProperty<Icon?> thumbIcon =
        MaterialStateProperty.resolveWith<Icon?>(
      (Set<MaterialState> states) {
        if (isDark == true) {
          return const Icon(
            CupertinoIcons.moon_fill,
            color: Colors.black,
          );
        } else {
          return const Icon(
            Icons.light_mode,
            color: Colors.white,
          );
        }
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: BottomBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: const AssetImage('lib/images/chiori.jpg'),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.7), BlendMode.dstATop),
                  )),
                  child: null,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Divider(
                color: Colors.grey[800],
              ),
            ),

            // About page
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: ListTile(
                leading: const Icon(
                  Icons.info,
                  color: Colors.white,
                ),
                title: const Text(
                  'About',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const AboutPage()));
                },
              ),
            ),

            // Search function
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: ListTile(
                leading: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                title: const Text('Search',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SearchPage()));
                },
              ),
            ),

            // Theme toggle
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: ListTile(
                leading: const Icon(
                  Icons.lightbulb,
                  color: Colors.white,
                ),
                title: const Text(
                  'Theme',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Switch(
                  thumbIcon: thumbIcon,
                  inactiveTrackColor: Colors.white,
                  activeTrackColor: Colors.black,
                  inactiveThumbColor: Colors.black,
                  activeColor: Colors.white,
                  value: isDark,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                ),
              ),
            ),
            const SizedBox(height: 200),

            // Back to home for guest mode, log out for signed in user
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: ListTile(
                leading: Icon(
                  (user?.isGuest == true) ? Icons.home : Icons.logout,
                  color: Colors.white,
                ),
                title: Text(
                  (user?.isGuest == true) ? 'Home page' : 'Log out',
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  await _auth.userSignOut();
                  setState(() {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => IntroPage()));
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
