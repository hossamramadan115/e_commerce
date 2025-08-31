import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/constsnt.dart';
import 'package:commerce/helper/functions.dart';
import 'package:commerce/services/shared_preferences_helper.dart';
import 'package:commerce/utils/app_styless.dart';
import 'package:commerce/utils/assets.dart';
import 'package:commerce/widgets/categories_and_see_all_widget.dart';
import 'package:commerce/widgets/custom_cart.dart';
import 'package:commerce/widgets/custom_category_tile.dart';
import 'package:commerce/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List categories = [
    Assets.kHeadPhoneIcone,
    Assets.kLaptopIcon,
    Assets.kWatchIcon,
    Assets.kTvIcon,
  ];

  List categoryName = ["Headphones", "Laptop", "Watch", "TV"];

  String? name, image;
  bool isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  List<String> allProductNames = []; // كل أسماء المنتجات
  List<String> suggestions = []; // الاقتراحات اللي بتظهر
  String selectedProductName = ""; // المنتج اللي اتحدد من البحث

  Future<void> getTheSharedPref() async {
    name = await SharedPreferencesHelper().getUserName();
    image = await SharedPreferencesHelper().getUserImage();
    setState(() {
      isLoading = false;
    });
  }

  // Future<void> fetchAllProductNames() async {
  //   final snapshot =
  //       await FirebaseFirestore.instance.collection('products').get();
  //   setState(() {
  //     allProductNames = snapshot.docs
  //         .map((doc) => (doc.data() as Map<String, dynamic>)['name'] as String)
  //         .toList();
  //   });
  // }

  Future<void> fetchAllProductNames() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('products').get();

    setState(() {
      allProductNames =
          snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getTheSharedPref();
    fetchAllProductNames();
    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      if (query.isNotEmpty) {
        setState(() {
          suggestions = allProductNames
              .where((name) => name.toLowerCase().contains(query))
              .toList();
        });
      } else {
        setState(() {
          suggestions = [];
          selectedProductName = "";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                  top: screenHeight * 0.05,
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ====== Top Row (اسم + صورة بروفايل) ======
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              limitText('Hey, ${name ?? "User"}', 16),
                              style: AppStyless.styleBold24,
                            ),
                            Text(
                              'Good Morning',
                              style: AppStyless.styleLightSemiBold20,
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.05),
                          child: image != null
                              ? Image.network(
                                  image!,
                                  height: screenWidth * 0.18,
                                  width: screenWidth * 0.18,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.person,
                                        size: screenWidth * 0.18);
                                  },
                                )
                              : Icon(Icons.person, size: screenWidth * 0.18),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    /// ====== Search Box ======
                    CustomTextFormField(
                      controller: _searchController,
                      backgroundColor: Colors.white,
                      hintText: 'Search product',
                      icon: Icons.search,
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    /// ====== عرض الاقتراحات لو موجودة ======
                    if (suggestions.isNotEmpty && selectedProductName.isEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: suggestions.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(suggestions[index]),
                              onTap: () {
                                setState(() {
                                  selectedProductName = suggestions[index];
                                  suggestions = [];
                                  _searchController.text = selectedProductName;
                                });
                              },
                            );
                          },
                        ),
                      ),

                    /// ====== لو اختار منتج من البحث ======
                    if (selectedProductName.isNotEmpty)
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('products')
                            .where("name", isEqualTo: selectedProductName)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Text("No product found");
                          }

                          final product = snapshot.data!.docs.first.data()
                              as Map<String, dynamic>;

                          return CustomCart(
                            imageUrl: product['image'],
                            name: product['name'],
                            price: product['price'].toString(),
                            details: product['details'],
                          );
                        },
                      )
                    else

                      /// ====== الصفحة العادية ======
                      Column(
                        children: [
                          const CategoriesAndSeeAllWidget(),
                          SizedBox(height: screenHeight * 0.015),

                          /// ====== Categories ======
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(screenWidth * 0.05),
                                  margin: EdgeInsets.only(
                                      right: screenWidth * 0.05),
                                  decoration: BoxDecoration(
                                    color: kMostUseColor,
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.03),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'All',
                                        style: AppStyless.styleBold20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: screenHeight * 0.15,
                                  child: ListView.builder(
                                    itemCount: categories.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return CustomCategoryTile(
                                        image: categories[index],
                                        name: categoryName[index],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.025),
                          const CategoriesAndSeeAllWidget(),

                          /// ====== Products Stream ======
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('products')
                                .orderBy("createdAt", descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Text("No products found");
                              }

                              final products = snapshot.data!.docs;

                              return GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 15,
                                  childAspectRatio: .62,
                                ),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index].data()
                                      as Map<String, dynamic>;
                                  return CustomCart(
                                    imageUrl: product['image'],
                                    name: product['name'],
                                    price: product['price'].toString(),
                                    details: product['details'],
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.025),
                        ],
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
