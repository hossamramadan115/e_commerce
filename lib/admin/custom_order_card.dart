import 'package:flutter/material.dart';
import 'package:commerce/utils/app_styless.dart';
import 'package:commerce/constsnt.dart';
import 'package:commerce/helper/functions.dart';
import 'package:commerce/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomOrderCard extends StatelessWidget {
  final DocumentSnapshot orderDoc;
  final Map<String, dynamic> order;
  final List<String> statusList;
  final VoidCallback onStatusChanged;

  const CustomOrderCard({
    super.key,
    required this.orderDoc,
    required this.order,
    required this.statusList,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.01,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.02,
        vertical: screenHeight * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
            child: order["User Image"] != null
                ? Image.network(
                    order["User Image"]!,
                    height: screenHeight * 0.15,
                    width: screenWidth * 0.25,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person, size: screenWidth * 0.18);
                    },
                  )
                : Icon(Icons.person, size: screenWidth * 0.18),
          ),
          SizedBox(width: screenWidth * 0.08),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  limitText(order["User Name"] ?? "Unknown", 13),
                  style: AppStyless.styleSemiBold20,
                ),
                Text(
                  order["Email"] ?? "Unknown",
                  style: AppStyless.styleLightSemiBold20.copyWith(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                Text(
                  limitText(order["Product Name"] ?? "Unknown", 13),
                  style: AppStyless.styleSemiBold20,
                ),
                Text(
                  "\$${order["Price"]}",
                  style: AppStyless.styleBold20.copyWith(color: kMostUseColor),
                ),
                DropdownButton<String>(
                  value: statusList.contains(order["Status"])
                      ? order["Status"]
                      : null,
                  hint: const Text("Select Status"),
                  items: statusList.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (newStatus) async {
                    if (newStatus != null) {
                      await DatabaseMethods()
                          .updateOrderStatus(orderDoc.id, newStatus);
                      onStatusChanged(); // نعمل Refresh
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.07),
        ],
      ),
    );
  }
}
