import 'package:commerce/utils/app_styless.dart';
import 'package:flutter/material.dart';

class CustomNoOrders extends StatelessWidget {
  const CustomNoOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/empty_cart0.png",
          height: 200,
        ),
        const SizedBox(height: 10),
        Text(
          "No Orders Yet",
          style: AppStyless.styleLightSemiBold20.copyWith(),
        ),
        const SizedBox(height: 10),
        Text(
          "Start shopping and your orders will appear here!",
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
