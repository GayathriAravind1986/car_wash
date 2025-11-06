import 'package:carwash/Bloc/Authentication/login_bloc.dart';
import 'package:carwash/Bloc/demo/demo_bloc.dart';
import 'package:carwash/ModelClass/Authentication/postLoginModel.dart';
import 'package:carwash/UI/Authentication/reset_password.dart';
import 'package:carwash/UI/DashBoard/DashBoard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carwash/Alertbox/snackBarAlert.dart';
import 'package:carwash/Reusable/color.dart';
import 'package:carwash/Reusable/customTextfield.dart';
import 'package:carwash/Reusable/space.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginInBloc(),
      child: const LoginScreenView(),
    );
  }
}

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({super.key});

  @override
  LoginScreenViewState createState() => LoginScreenViewState();
}

class LoginScreenViewState extends State<LoginScreenView> {
  PostLoginModel postLoginModel = PostLoginModel();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  RegExp emailRegex = RegExp(r'\S+@\S+\.\S+');
  String? errorMessage;
  var showPassword = true;
  bool loginLoad = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    final textTheme = Theme.of(context).textTheme;
    // Define breakpoints
    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth < 1100;
    bool isDesktop = screenWidth >= 1100;
    Widget mainContainer() {
      return Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: isMobile
                  ? screenWidth *
                        0.9 // Mobile: take most of the width
                  : isTablet
                  ? screenWidth *
                        0.6 // Tablet: medium width
                  : screenWidth * 0.4, // Desktop: smaller width
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
                // border: Border.all(color: appPrimaryColor),
                boxShadow: [
                  BoxShadow(
                    color: blackColor12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.settings,
                        color: appPrimaryColor,
                        size: isTablet ? 50 : 40,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "SenX",
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: blackColor87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: isMobile ? 22 : 26,
                      fontWeight: FontWeight.bold,
                      color: appPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Sign in to your account',
                    style: TextStyle(fontSize: isMobile ? 14 : 16),
                  ),
                  const SizedBox(height: 12),

                  // Email Field
                  CustomTextField(
                    hint: "Email Address",
                    readOnly: false,
                    controller: email,
                    baseColor: appPrimaryColor,
                    borderColor: appGreyColor,
                    errorColor: redColor,
                    inputType: TextInputType.text,
                    showSuffixIcon: false,
                    FTextInputFormatter: FilteringTextInputFormatter.allow(
                      RegExp("[a-zA-Z0-9.@]"),
                    ),
                    obscureText: false,
                    maxLength: 30,
                    onChanged: (val) => _formKey.currentState!.validate(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Password Field
                  CustomTextField(
                    hint: "Password",
                    readOnly: false,
                    controller: password,
                    baseColor: appPrimaryColor,
                    borderColor: appGreyColor,
                    errorColor: redColor,
                    inputType: TextInputType.text,
                    obscureText: showPassword,
                    showSuffixIcon: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility_off : Icons.visibility,
                        color: appGreyColor,
                      ),
                      onPressed: () {
                        setState(() => showPassword = !showPassword);
                      },
                    ),
                    maxLength: 80,
                    onChanged: (val) => _formKey.currentState!.validate(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ResetPassword(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: appSecondaryColor.withOpacity(0.6),
                              fontSize: isMobile ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  loginLoad
                      ? const SpinKitCircle(color: appPrimaryColor, size: 30)
                      : InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loginLoad = true;
                              });
                              context.read<LoginInBloc>().add(
                                LoginIn(email.text, password.text),
                              );
                            }
                          },
                          child: appButton(
                            height: 50,
                            width: isMobile
                                ? screenWidth * 0.9
                                : screenWidth * 0.4,
                            buttonText: "Sign In",
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      body: BlocBuilder<LoginInBloc, dynamic>(
        buildWhen: ((previous, current) {
          if (current is PostLoginModel) {
            postLoginModel = current;
            if (postLoginModel.success == true) {
              setState(() {
                loginLoad = false;
              });
              showToast('${postLoginModel.message}', context, color: true);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const DashBoardScreen(selectedTab: 0),
                ),
                (Route<dynamic> route) => false,
              );
            } else {
              final errorMsg =
                  postLoginModel.errorResponse?.errors?.first.message ??
                  postLoginModel.message ??
                  "Login failed. Please try again.";
              showToast(errorMsg, context, color: false);
              setState(() {
                loginLoad = false;
              });
            }
            return true;
          }
          return false;
        }),
        builder: (context, dynamic) {
          return mainContainer();
        },
      ),
    );
  }
}
