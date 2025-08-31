import 'package:commerce/constsnt.dart';
import 'package:commerce/helper/show_snack_bar.dart';
import 'package:commerce/services/auth_service.dart';
import 'package:commerce/services/database_service.dart';
import 'package:commerce/services/shared_preferences_helper.dart';
import 'package:commerce/utils/app_router.dart';
import 'package:commerce/utils/app_styless.dart';
import 'package:commerce/utils/assets.dart';
import 'package:commerce/widgets/admin_button.dart';
import 'package:commerce/widgets/custom_button.dart';
import 'package:commerce/widgets/custom_text_button.dart';
import 'package:commerce/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  final email = TextEditingController();
  final password = TextEditingController();

  void loginMethod() async {
    if (!formKey.currentState!.validate()) return;

    if (!mounted) return; // تأكيد قبل أي setState
    setState(() {
      isLoading = true;
    });

    try {
      final user = await AuthService().login(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      if (user != null) {
        final snapshot =
            await DatabaseMethods().getUserByEmail(email.text.trim());

        if (snapshot != null) {
          final userData = snapshot.data() as Map<String, dynamic>;

          await SharedPreferencesHelper().saveUserEmail(userData["email"]);
          await SharedPreferencesHelper().saveUserId(userData["id"]);
          await SharedPreferencesHelper().saveUserName(userData["name"]);
          await SharedPreferencesHelper().saveUserImage(userData["image"]);
        }

        if (!mounted) return; // تأكيد قبل استخدام context
        showSuccessSnack(context, "Welcome back 👋");
        GoRouter.of(context).push(AppRouter.kBottombar);
      }
    } catch (e) {
      if (!mounted) return;
      showErrorSnack(context, e.toString());
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double height = constraints.maxHeight;
          final double width = constraints.maxWidth;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الصورة الأولى تاخد جزء مرن
                SizedBox(
                  height: height * 0.3,
                  width: width,
                  child: Image.asset(
                    Assets.kLoginImage,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.06,
                    vertical: height * 0.02,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Sign In',
                            style: AppStyless.styleBold20.copyWith(
                              fontSize: width * 0.06, // الخط يتغير مع العرض
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Center(
                          child: Text(
                            'Please enter the details below to\ncontinue',
                            style: AppStyless.styleLightSemiBold20.copyWith(
                              fontSize: width * 0.04,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        Text(
                          'Email',
                          style: AppStyless.styleBold20.copyWith(
                            fontSize: width * 0.045,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextFormField(
                          controller: email,
                          hintText: 'Email',
                          validator: (data) {
                            if (data == null || data.isEmpty) {
                              return 'field is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: height * 0.03),
                        Text(
                          'Password',
                          style: AppStyless.styleBold20.copyWith(
                            fontSize: width * 0.045,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextFormField(
                          controller: password,
                          hintText: 'Password',
                          validator: (data) {
                            if (data == null || data.isEmpty) {
                              return 'field is required';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        SizedBox(height: height * 0.009),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forget password',
                            style: TextStyle(
                              color: kMostUseColor,
                              fontSize: width * 0.038,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.025),
                        CustomButton(
                          backgroundColor: kMostUseColor,
                          textColor: Colors.white,
                          text: 'Login',
                          isLoading: isLoading,
                          onTap: () async {
                            formKey.currentState!.validate();
                            loginMethod();
                          },
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Create new account...',
                              style: TextStyle(
                                fontSize: width * 0.04,
                              ),
                            ),
                            CustomTextButton(
                              text: 'Sign Up',
                              onPressed: () {
                                GoRouter.of(context)
                                    .push(AppRouter.kSignUpPage);
                              },
                            ),
                          ],
                        ),
                        Center(child: AdminButton()),
                        SizedBox(height: height * 0.05),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
