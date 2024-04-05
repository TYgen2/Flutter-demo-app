import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomBar extends StatelessWidget {
  void Function(int)? onTabChange;
  BottomBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        child: GNav(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          color: Colors.grey[400],
          activeColor: Colors.grey.shade700,
          tabActiveBorder: Border.all(color: Colors.white),
          tabBackgroundColor: Colors.grey.shade300,
          mainAxisAlignment: MainAxisAlignment.center,
          onTabChange: (value) => onTabChange!(value),
          tabs: [
            GButton(
              textColor: Colors.brown,
              iconActiveColor: Colors.brown,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              icon: Icons.home,
              gap: 8,
              text: 'Artwork',
              backgroundColor: Colors.amber[100],
            ),
            GButton(
              textColor: Colors.red,
              iconActiveColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              icon: Icons.favorite,
              gap: 8,
              text: 'Favourites',
              backgroundColor: Colors.red[100],
            )
          ],
        ),
      ),
    );
  }
}
