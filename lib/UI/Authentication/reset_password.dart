import 'package:carwash/Bloc/demo/demo_bloc.dart';
import 'package:carwash/UI/Authentication/login_screen.dart';
import 'package:carwash/UI/DashBoard/DashBoard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carwash/Alertbox/snackBarAlert.dart';
import 'package:carwash/Reusable/color.dart';
import 'package:carwash/Reusable/customTextfield.dart';
import 'package:carwash/Reusable/space.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const ResetPasswordView(),
    );
  }
}

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  ResetPasswordViewState createState() => ResetPasswordViewState();
}

class ResetPasswordViewState extends State<ResetPasswordView> {
  //PostLoginModel postLoginModel = PostLoginModel();

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
    final isTablet = MediaQuery.of(context).size.width > 600;
    final textTheme = Theme.of(context).textTheme;
    Widget mainContainer() {
      return Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: isTablet ? 450 : double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.symmetric(
                vertical: isTablet ? 48 : 32,
                horizontal: isTablet ? 40 : 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Column(
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
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    "Reset Password",
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: appPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Enter your email to receive a reset link",
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: appSecondaryColor.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Email field
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
                  const SizedBox(height: 24),

                  // Button
                  loginLoad
                      ? const SpinKitCircle(color: appPrimaryColor, size: 30)
                      : InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: appButton(
                            height: 50,
                            width: isTablet
                                ? size.width * 0.4
                                : size.width * 0.9,
                            buttonText: "Send Reset Link",
                          ),
                        ),
                  const SizedBox(height: 16),

                  // Back to Sign In
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Back to Sign In",
                      style: TextStyle(
                        color: appSecondaryColor.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
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
      body: BlocBuilder<DemoBloc, dynamic>(
        buildWhen: ((previous, current) {
          //            if (current is PostLoginModel) {
          //              postLoginModel = current;
          //              if (postLoginModel.success == true) {
          //                setState(() {
          //                  loginLoad = false;
          //                });
          //                showToast('${postLoginModel.message}', context, color: true);
          //                if (postLoginModel.user!.role == "OPERATOR") {
          //                  Navigator.of(context).pushAndRemoveUntil(
          //                      MaterialPageRoute(
          //                          builder: (context) => const DashBoardScreen(
          //                                selectTab: 0,
          //                              )),
          //                      (Route<dynamic> route) => false);
          //                } else {
          //                  showToast("Please Login Admin in Web", context, color: false);
          //                }
          //              } else {
          //                final errorMsg =
          //                    postLoginModel.errorResponse?.errors?.first.message ??
          //                        postLoginModel.message ??
          //                        "Login failed. Please try again.";
          //                showToast(errorMsg, context, color: false);
          //                setState(() {
          //                  loginLoad = false;
          //                });
          //              }
          //              return true;
          //            }
          return false;
        }),
        builder: (context, dynamic) {
          return mainContainer();
        },
      ),
    );
  }
}
