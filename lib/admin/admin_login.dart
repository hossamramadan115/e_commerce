import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/helper/show_snack_bar.dart';
import 'package:commerce/services/shared_preferences_helper.dart';
import 'package:commerce/utils/app_router.dart';
import 'package:commerce/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:commerce/utils/app_styless.dart';
import 'package:commerce/widgets/custom_button.dart';
import 'package:commerce/widgets/custom_text_form_field.dart';
import 'package:commerce/constsnt.dart';
import 'package:go_router/go_router.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  bool isLoading = false;
  final userName = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> loginAdmin() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("Admin")
          .where("username", isEqualTo: userName.text.trim())
          .where("password", isEqualTo: password.text.trim())
          .get();

      if (snapshot.docs.isNotEmpty) {
              await SharedPreferencesHelper().saveIsAdminLoggedIn(true);

        showSuccessSnack(context, ' Welcome Admin 👑');
        GoRouter.of(context).go(AppRouter.kAdminHomePage);
      } else {
        showErrorSnack(context, "Invalid username or password");
      }
    } catch (e) {
      showErrorSnack(context, "Error: $e");
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // 👈 عشان الصورة تطلع ورا الـ AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 👈 شفاف
        elevation: 0, // 👈 من غير ظل
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_outlined,
              color: Colors.black), // 👈 ممكن تغير اللون حسب الصورة
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double height = constraints.maxHeight;
          final double width = constraints.maxWidth;

          return SingleChildScrollView(
            child: Column(
              children: [
                // 👇 الصورة هتاخد العرض كله وتبدأ من فوق
                SizedBox(
                  height: height * 0.35,
                  width: width,
                  child: Image.asset(
                    Assets.kLoginImage,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: height * 0.08),
                Text("Admin Panel",
                    style: AppStyless.styleBold20.copyWith(fontSize: 24)),
                SizedBox(height: height * 0.05),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          controller: userName,
                          hintText: 'Username',
                          validator: (data) =>
                              data == null || data.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: height * 0.03),
                        CustomTextFormField(
                          controller: password,
                          hintText: 'Password',
                          obscureText: true,
                          validator: (data) =>
                              data == null || data.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: height * 0.05),
                        CustomButton(
                          backgroundColor: kMostUseColor,
                          textColor: Colors.white,
                          isLoading: isLoading,
                          text: 'Login',
                          onTap: loginAdmin,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:commerce/helper/show_snack_bar.dart';
// import 'package:commerce/utils/app_router.dart';
// import 'package:commerce/utils/assets.dart';
// import 'package:flutter/material.dart';
// import 'package:commerce/utils/app_styless.dart';
// import 'package:commerce/widgets/custom_button.dart';
// import 'package:commerce/widgets/custom_text_form_field.dart';
// import 'package:commerce/constsnt.dart';
// import 'package:go_router/go_router.dart';

// class AdminLogin extends StatefulWidget {
//   const AdminLogin({super.key});

//   @override
//   State<AdminLogin> createState() => _AdminLoginState();
// }

// class _AdminLoginState extends State<AdminLogin> {
//   bool isLoading = false;
//   final userName = TextEditingController();
//   final password = TextEditingController();
//   final formKey = GlobalKey<FormState>();

//   Future<void> loginAdmin() async {
//     if (!formKey.currentState!.validate()) return;
//     setState(() => isLoading = true);
//     try {
//       // 🔹 جلب بيانات الـ admin من Firestore
//       final snapshot = await FirebaseFirestore.instance
//           .collection("Admin")
//           .where("username", isEqualTo: userName.text.trim())
//           .where("password", isEqualTo: password.text.trim())
//           .get();

//       if (snapshot.docs.isNotEmpty) {
//         showSuccessSnack(context, ' Welcome Admin 👑');
//         GoRouter.of(context).push(AppRouter.kAdminHomePage);
//       } else {
//         showErrorSnack(context, "Invalid username or password");
//       }
//     } catch (e) {
//       showErrorSnack(context, "Error: $e");
//     }
//     setState(() => isLoading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: const Icon(Icons.arrow_back_ios_new_outlined),
//         ),
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           final double height = constraints.maxHeight;
//           final double width = constraints.maxWidth;

//           return SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: width * 0.06),
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: height * 0.3,
//                       width: width,
//                       child: Image.asset(
//                         Assets.kLoginImage,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     SizedBox(height: height * 0.15),
//                     Text("Admin Panel",
//                         style: AppStyless.styleBold20.copyWith(fontSize: 24)),
//                     SizedBox(height: height * 0.05),

//                     // Username
//                     CustomTextFormField(
//                       controller: userName,
//                       hintText: 'Username',
//                       validator: (data) =>
//                           data == null || data.isEmpty ? 'Required' : null,
//                     ),
//                     SizedBox(height: height * 0.03),

//                     // Password
//                     CustomTextFormField(
//                       controller: password,
//                       hintText: 'Password',
//                       obscureText: true,
//                       validator: (data) =>
//                           data == null || data.isEmpty ? 'Required' : null,
//                     ),
//                     SizedBox(height: height * 0.05),

//                     CustomButton(
//                       backgroundColor: kMostUseColor,
//                       textColor: Colors.white,
//                       isLoading: isLoading,
//                       text: 'Login',
//                       onTap: loginAdmin,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
