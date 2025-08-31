import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/constsnt.dart';
import 'package:commerce/services/database_service.dart';
import 'package:commerce/services/shared_preferences_helper.dart';
import 'package:commerce/utils/app_styless.dart';
import 'package:commerce/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.details,
  });
  final String image, name, price, details;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String? name, email, image;
  Map<String, dynamic>? paymentIntent;

  getTheSharedPref() async {
    name = await SharedPreferencesHelper().getUserName();
    email = await SharedPreferencesHelper().getUserEmail();
    image = await SharedPreferencesHelper().getUserImage();
    setState(() {});
  }

  onTheLoad() async {
    await getTheSharedPref();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    onTheLoad();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: const Color(0xfffef5f1),
      appBar: AppBar(
        backgroundColor: const Color(0xfffef5f1),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Image.network(
                widget.image,
                width: double.infinity,
                height: constraints.maxHeight * 0.4,
                fit: BoxFit.contain,
              ),
              SizedBox(height: height * 0.03),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                    vertical: height * 0.02,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title + Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.name,
                                style: AppStyless.styleBold24.copyWith(
                                  fontSize: width * 0.055, // responsive font
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            Text(
                              '\$${widget.price}',
                              style: AppStyless.styleBold18.copyWith(
                                fontSize: width * 0.05,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          'Details',
                          style: AppStyless.styleSemiBold20.copyWith(
                            fontSize: width * 0.045,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          widget.details,
                          // style: TextStyle(fontSize: width * 0.04),
                        ),
                        SizedBox(height: height * 0.1),
                        CustomButton(
                          text: 'Buy Now',
                          textColor: Colors.white,
                          backgroundColor: kMostUseColor,
                          onTap: () {
                            makePayment(widget.price);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'INR');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Adnan',
        ),
      );
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        Map<String, dynamic> orderInfoMap = {
          "Product Name": widget.name,
          "Price": widget.price,
          "Product Image": widget.image,
          "User Name": name,
          "Email": email,
          "User Image": image,
          "Status": "Pending",
          "createdAt": Timestamp.now(),
        };
        await DatabaseMethods().addOrderDetails(orderInfoMap);

if (!mounted) return;

        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text("Payment Successful"),
              ],
            ),
          ),
        );
        paymentIntent = null;
      });
    } on StripeException catch (e) {
      if (!mounted) return;
      debugPrint("Stripe error: $e");
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Cancelled"),
        ),
      );
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount) * 100);
    return calculatedAmount.toString();
  }
}
