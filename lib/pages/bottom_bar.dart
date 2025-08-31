import 'package:commerce/constsnt.dart';
import 'package:commerce/pages/home_page.dart';
import 'package:commerce/pages/orders_page.dart';
import 'package:commerce/pages/profile_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selected = 0;

  final List<Widget> pageList = [
    const HomePage(),
    const OrdersPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final navBarHeight = screenHeight * 0.08;
    final iconSize = screenWidth * 0.08;

    return Scaffold(
      extendBody: true,
      body: pageList[selected],
      bottomNavigationBar: CurvedNavigationBar(
        index: selected,
        height: navBarHeight,
        backgroundColor: kPrimaryColor,
        color: Colors.black,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            selected = index;
          });
        },
        items: [
          Icon(Icons.home, size: iconSize, color: Colors.white),
          Icon(Icons.shopping_bag, size: iconSize, color: Colors.white),
          Icon(Icons.person, size: iconSize, color: Colors.white),
        ],
      ),
    );
  }
}
