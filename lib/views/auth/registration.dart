import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sivo_suppliers/common/app_style.dart';
import 'package:sivo_suppliers/constants/constants.dart';
import 'package:sivo_suppliers/controllers/registration_controller.dart';
import 'package:sivo_suppliers/models/registration.dart';
import 'package:sivo_suppliers/views/auth/widgets/email_textfield.dart';
import 'package:sivo_suppliers/views/auth/widgets/password_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final _registrationFormKey = GlobalKey<FormState>();
  final RegistrationController controller = Get.put(RegistrationController());

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool validateAndSave() {
    final form = _registrationFormKey.currentState;
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
                          "Sivo Registration",
                          style: appStyle(28, kPrimary, FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        Lottie.asset(
                          'assets/anime/delivery.json',
                          height: 200.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 40.h),
                        Form(
                          key: _registrationFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildTextField(
                                controller: _usernameController,
                                hintText: "Username",
                                icon: CupertinoIcons.person,
                                keyboardType: TextInputType.text,
                              ),
                              SizedBox(height: 16.h),
                              _buildTextField(
                                controller: _emailController,
                                hintText: "Email",
                                icon: CupertinoIcons.mail,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 16.h),
                              PasswordField(
                                controller: _passwordController,
                                focusNode: _passwordFocusNode,
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
                                    Registration model = Registration(
                                      username: _usernameController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                                    String userdata = registrationToJson(model);
                                    controller.registration(userdata);
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
                                  "REGISTER",
                                  style: appStyle(16, Colors.white, FontWeight.bold),
                                ),
                              )),
                            ],
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: appStyle(14, Colors.grey, FontWeight.normal),
                              ),
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: Text(
                                  'Login',
                                  style: appStyle(14, kPrimary, FontWeight.bold),
                                ),
                              ),
                            ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return EmailTextField(
      focusNode: _passwordFocusNode,
      hintText: hintText,
      controller: controller,
      prefixIcon: Icon(
        icon,
        color: Theme.of(context).dividerColor,
        size: 20,
      ),
      keyboardType: keyboardType,
      onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordFocusNode),
    );
  }
}