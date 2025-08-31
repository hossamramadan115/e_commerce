import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/admin/custom_order_card.dart';
import 'package:commerce/constsnt.dart';
import 'package:commerce/services/database_service.dart';
import 'package:commerce/utils/app_styless.dart';
import 'package:flutter/material.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  final List<String> statusList = [
    "Pending",
    "On The Way",
    "Delivered",
    "Cancelled",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        title: Text("All Orders", style: AppStyless.styleBold20),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 35),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseMethods().getAllOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Orders Found"));
          }

          final orders = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data["Status"] != "Delivered" &&
                data["Status"] != "Cancelled";
          }).toList();

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderDoc = orders[index];
              final order = orderDoc.data() as Map<String, dynamic>;

              return CustomOrderCard(
                orderDoc: orderDoc,
                order: order,
                statusList: statusList,
                onStatusChanged: () => setState(() {}),
              );
            },
          );
        },
      ),
    );
  }
}
