import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/constsnt.dart';
import 'package:commerce/services/database_service.dart';
import 'package:commerce/widgets/custom_cart.dart';
import 'package:flutter/material.dart';

class SameCategoriesPage extends StatelessWidget {
  final String categoryName;

  const SameCategoriesPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      backgroundColor: kPrimaryColor,
      body: StreamBuilder(
        stream: DatabaseMethods().getProducts(categoryName),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: .67,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];

              return CustomCart(
                imageUrl: ds["image"],
                name: ds["name"],
                price: ds["price"],
                details: ds["details"],
              );
            },
          );
        },
      ),
    );
  }
}
