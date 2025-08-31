import 'package:commerce/services/shared_preferences_helper.dart';
import 'package:commerce/utils/app_router.dart';
import 'package:commerce/utils/app_styless.dart';
import 'package:commerce/widgets/custom_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        title: Text("Home Admin", style: AppStyless.styleBold20),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: screenWidth * 0.1),
            CustomListTile(
              icon: Icons.add,
              title: 'Add Product',
              onTap: () {
                GoRouter.of(context).push(AppRouter.kAddProductPage);
              },
            ),
            SizedBox(height: screenWidth * 0.08),
            CustomListTile(
              icon: Icons.shopping_bag_outlined,
              title: 'All Orders',
              onTap: () {
                GoRouter.of(context).push(AppRouter.kAllOrders);
              },
            ),
            SizedBox(height: screenWidth * 0.08),
            CustomListTile(
              icon: Icons.logout,
              title: 'Sign Out',
              onTap: () async {
                final prefs = SharedPreferencesHelper();
                final isAdmin = await prefs.getIsAdminLoggedIn() ?? false;
                if (isAdmin) {
                  await prefs.clearAdminLogin();
                } else {
                  await FirebaseAuth.instance.signOut();
                  await prefs.clearPrefs();
                }
                GoRouter.of(context).go(AppRouter.kOnBoarding);
              },
            ),
          ],
        ),
      ),
    );
  }
}
