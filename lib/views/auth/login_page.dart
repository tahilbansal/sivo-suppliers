import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sivo_suppliers/common/app_style.dart';
import 'package:sivo_suppliers/common/custom_btn.dart';
import 'package:sivo_suppliers/constants/constants.dart';
import 'package:sivo_suppliers/controllers/login_controller.dart';
import 'package:sivo_suppliers/models/login_request.dart';
import 'package:sivo_suppliers/views/auth/registration.dart';
import 'package:sivo_suppliers/views/auth/widgets/email_textfield.dart';
import 'package:sivo_suppliers/views/auth/widgets/password_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final _loginFormKey = GlobalKey<FormState>();
  final LoginController controller = Get.put(LoginController());

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool validateAndSave() {
    final form = _loginFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 40.h),
                        Text(
                          "Sivo Supplier Panel",
                          style: appStyle(24, kPrimary, FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        Lottie.asset(
                          'assets/anime/sivo_animation.json',
                          height: 200.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 40.h),
                        Form(
                          key: _loginFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              EmailTextField(
                                focusNode: _passwordFocusNode,
                                hintText: "Email",
                                controller: _emailController,
                                prefixIcon: Icon(
                                  CupertinoIcons.mail,
                                  color: Theme.of(context).dividerColor,
                                  size: 20,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordFocusNode),
                              ),
                              SizedBox(height: 16.h),
                              PasswordField(
                                controller: _passwordController,
                                focusNode: _passwordFocusNode,
                              ),
                              SizedBox(height: 8.h),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Get.to(() => const RegistrationPage());
                                  },
                                  child: Text(
                                    'Register',
                                    style: appStyle(14, kPrimary, FontWeight.w600),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.h),
                              Obx(() => controller.isLoading
                                  ? Center(
                                child: CircularProgressIndicator.adaptive(
                                  backgroundColor: kPrimary,
                                  valueColor: AlwaysStoppedAnimation<Color>(kLightWhite),
                                ),
                              )
                                  : ElevatedButton(
                                onPressed: () {
                                  if (validateAndSave()) {
                                    LoginRequest model = LoginRequest(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                                    String authData = loginRequestToJson(model);
                                    controller.loginFunc(authData, model);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimary,
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                  child: Text(
                                  "LOGIN",
                                  style: appStyle(16, Colors.white, FontWeight.bold),
                                ),
                              )),
                            ],
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: Text(
                            '© 2025 Sivo Suppliers. All rights reserved.',
                            style: appStyle(12, Colors.grey, FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

