import 'package:commerce/constsnt.dart';
import 'package:commerce/helper/show_snack_bar.dart';
import 'package:commerce/services/auth_service.dart';
import 'package:commerce/services/shared_preferences_helper.dart';
import 'package:commerce/utils/app_router.dart';
import 'package:commerce/utils/app_styless.dart';
import 'package:commerce/utils/assets.dart';
import 'package:commerce/widgets/custom_button.dart';
import 'package:commerce/widgets/custom_text_button.dart';
import 'package:commerce/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:random_string/random_string.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoading = false;
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  String id = randomAlphaNumeric(10);

  void signUpMethod() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await AuthService().signUp(
        name: name.text.trim(),
        email: email.text.trim(),
        password: password.text.trim(),
        id: id,
      );

      // ✅ خزن بيانات المستخدم في SharedPreferences
      await SharedPreferencesHelper().saveUserEmail(email.text.trim());
      await SharedPreferencesHelper().saveUserId(id);
      await SharedPreferencesHelper().saveUserName(name.text.trim());
      await SharedPreferencesHelper().saveUserImage("");

      showSuccessSnack(context, "Account created successfully 🎉");
      GoRouter.of(context).push(AppRouter.kBottombar);
    } catch (e) {
      showErrorSnack(context, e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    name.dispose();
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
                            'Sign Up',
                            style: AppStyless.styleBold20.copyWith(
                              fontSize: width * 0.06,
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
                          'Name',
                          style: AppStyless.styleBold20.copyWith(
                            fontSize: width * 0.045,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextFormField(
                          controller: name,
                          hintText: 'Name',
                          validator: (data) {
                            if (data == null || data.isEmpty) {
                              return 'field is required';
                            }
                            return null;
                          },
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
                            } else if (!data.contains('@') || data.length < 7) {
                              return 'please enter a vaild email';
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
                            } else if (data.length < 7) {
                              return 'must be at least 7 characters';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        SizedBox(height: height * 0.025),
                        CustomButton(
                          backgroundColor: kMostUseColor,
                          textColor: Colors.white,
                          isLoading: isLoading,
                          text: 'Sign Up',
                          onTap: () async {
                            !formKey.currentState!.validate();
                            signUpMethod();
                          },
                        ),
                        SizedBox(height: height * 0.008),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'alredy have an account...',
                              style: TextStyle(
                                fontSize: width * 0.04,
                              ),
                            ),
                            CustomTextButton(
                              text: 'Login',
                              onPressed: () {
                                GoRouter.of(context).push(AppRouter.kLoginpage);
                              },
                            ),
                          ],
                        ),
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
