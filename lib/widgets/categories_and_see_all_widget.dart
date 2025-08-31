import 'package:commerce/utils/app_styless.dart';
import 'package:flutter/material.dart';

class CategoriesAndSeeAllWidget extends StatelessWidget {
  const CategoriesAndSeeAllWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Categories',
          style: AppStyless.styleBold20,
        ),
        Text(
          'see all',
          style: AppStyless.styleBold18,
        ),
      ],
    );
  }
}
