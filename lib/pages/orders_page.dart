import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/constsnt.dart';
import 'package:commerce/helper/functions.dart';
import 'package:commerce/helper/show_custom_dialog.dart';
import 'package:commerce/services/database_service.dart';
import 'package:commerce/services/shared_preferences_helper.dart';
import 'package:commerce/utils/app_styless.dart';
import 'package:commerce/widgets/custom_no_orders.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String? email;
  getTheSharedPref() async {
    email = await SharedPreferencesHelper().getUserEmail();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTheSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          "My Orders",
          style: AppStyless.styleBold20,
        ),
        centerTitle: true,
      ),
      body: email == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: DatabaseMethods().getOrders(email),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: CustomNoOrders());
                }
                final orders = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index].data() as Map<String, dynamic>;

                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.005,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenHeight * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                      child: Stack(
                        children: [
                          // الكارد نفسه
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02,
                              vertical: screenHeight * 0.02,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.03),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.03),
                                  child: Image.network(
                                    order["Product Image"],
                                    height: screenHeight * 0.15,
                                    width: screenWidth * 0.25,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      limitText(
                                          order["Product Name"] ?? "Unknown",
                                          13),
                                      style: AppStyless.styleSemiBold20,
                                    ),
                                    Text(
                                      "\$${order["Price"]}",
                                      style: AppStyless.styleBold20
                                          .copyWith(color: kMostUseColor),
                                    ),
                                    Text(
                                      limitText(
                                          "Status : ${order["Status"] ?? "Pending"}",
                                          20),
                                      style: AppStyless.styleBold18,
                                    ),
                                  ],
                                ),
                                SizedBox(width: screenWidth * 0.07),
                              ],
                            ),
                          ),

                          // زرار الحذف فوق على اليمين
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(FontAwesomeIcons.xmark,
                                  color: Colors.black),
                              onPressed: () async {
                                showCustomDialog(
                                  context: context,
                                  title: "Delete Confirmation",
                                  content:
                                      "Are you sure you want to delete this order? This action cannot be undone.",
                                  confirmText: "Delete",
                                  onConfirm: () async {
                                    await DatabaseMethods()
                                        .deleteOrder(orders[index].id);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
