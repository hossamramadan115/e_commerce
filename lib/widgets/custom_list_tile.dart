import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;

  const CustomListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenWidth * 0.009,
        ),
        leading: Icon(
          icon,
          size: screenWidth * 0.07,
          color: iconColor ?? Colors.blueAccent,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: screenWidth * 0.046,
            fontWeight: FontWeight.w500,
            // color: kSplashColor,
          ),
        ),
        trailing: IconButton(
          onPressed: onTap,
          icon: Icon(
            Icons.arrow_forward_ios,
            size: screenWidth * 0.045,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
