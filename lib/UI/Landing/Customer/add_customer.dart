import 'package:carwash/Alertbox/snackBarAlert.dart';
import 'package:carwash/Bloc/Customer/customer_bloc.dart';
import 'package:carwash/ModelClass/Customer/postCustomerModel.dart';
import 'package:carwash/Reusable/color.dart';
import 'package:carwash/UI/Authentication/login_screen.dart';
import 'package:carwash/UI/DashBoard/DashBoard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCustomer extends StatelessWidget {
  final bool isTablet;
  const AddCustomer({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomerBloc(),
      child: AddCustomerView(isTablet: isTablet),
    );
  }
}

class AddCustomerView extends StatefulWidget {
  final bool isTablet;
  const AddCustomerView({super.key, required this.isTablet});

  @override
  State<AddCustomerView> createState() => _AddCustomerViewState();
}

class _AddCustomerViewState extends State<AddCustomerView> {
  PostCustomerModel postCustomerModel = PostCustomerModel();
  final _formKey = GlobalKey<FormState>();
  bool isActive = true;
  bool addCus = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );

    Widget mainContainer() {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Add Customer",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Name fields
                widget.isTablet
                    ? Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'First name',
                              firstNameController,
                              inputDecoration,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(
                              'Last name',
                              lastNameController,
                              inputDecoration,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildTextField(
                            'First name',
                            firstNameController,
                            inputDecoration,
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            'Last name',
                            lastNameController,
                            inputDecoration,
                          ),
                        ],
                      ),
                const SizedBox(height: 12),

                // Phone + Email
                widget.isTablet
                    ? Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Phone',
                              phoneController,
                              inputDecoration,
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(
                              'Email',
                              emailController,
                              inputDecoration,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildTextField(
                            'Phone',
                            phoneController,
                            inputDecoration,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            'Email',
                            emailController,
                            inputDecoration,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                      ),
                const SizedBox(height: 12),

                // Address
                _buildTextField(
                  'Address',
                  addressController,
                  inputDecoration,
                  maxLines: 3,
                ),
                const SizedBox(height: 8),

                // Active checkbox
                Row(
                  children: [
                    Checkbox(
                      value: isActive,
                      activeColor: appSecondaryColor,
                      onChanged: (v) => setState(() => isActive = v ?? true),
                    ),
                    const Text('Active'),
                  ],
                ),
                const SizedBox(height: 16),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: appSecondaryColor),
                      ),
                    ),
                    const SizedBox(width: 12),
                    addCus
                        ? const SpinKitCircle(color: appPrimaryColor, size: 30)
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<CustomerBloc>().add(
                                  CreateCustomer(
                                    firstNameController.text,
                                    lastNameController.text,
                                    phoneController.text,
                                    emailController.text,
                                    addressController.text,
                                    isActive,
                                  ),
                                );
                                setState(() {
                                  addCus = true;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appSecondaryColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Save changes',
                              style: TextStyle(color: whiteColor),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: appScaffoldBackground,
      body: BlocBuilder<CustomerBloc, dynamic>(
        buildWhen: (previous, current) {
          if (current is PostCustomerModel) {
            postCustomerModel = current;
            if (postCustomerModel.errorResponse?.isUnauthorized == true) {
              _handle401Error();
              return true;
            }
            if (postCustomerModel.errorResponse?.statusCode == 500) {
              showToast(
                postCustomerModel.message ?? "Server error occurred",
                context,
                color: false,
              );
              setState(() => addCus = false);
              return true;
            }
            if (postCustomerModel.success == true) {
              debugPrint("success True");
              showToast(
                postCustomerModel.message ?? "Customer created successfully",
                context,
                color: true,
              );
              setState(() {
                addCus = false;
              });
              Future.microtask(() {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const DashBoardScreen(selectedTab: 1),
                  ),
                );
              });
            } else if (postCustomerModel.success == false) {
              showToast(
                postCustomerModel.message.toString(),
                context,
                color: true,
              );
              setState(() {
                addCus = false;
              });
            } else if (postCustomerModel.errorResponse != null) {
              showToast(
                postCustomerModel.errorResponse?.message ?? "An error occurred",
                context,
                color: false,
              );
              setState(() => addCus = false);
            }
            return true;
          }
          return false;
        },
        builder: (context, state) {
          return mainContainer();
        },
      ),
    );
  }

  void _handle401Error() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove("token");
    await sharedPreferences.clear();
    showToast("Session expired. Please login again.", context, color: false);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Widget _buildTextField(
    String label,

    TextEditingController controller,
    InputDecoration decoration, {
    String? hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        TextSelectionTheme(
          data: const TextSelectionThemeData(
            cursorColor: appPrimaryColor,
            selectionColor: appPrimaryColor,
            selectionHandleColor: appPrimaryColor,
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: appPrimaryColor, fontSize: 14),
            maxLines: maxLines,
            decoration: decoration.copyWith(
              hintText: hintText,
              hintStyle: const TextStyle(color: greyColor, fontSize: 14),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: appGreyColor),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: appGreyColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: appSecondaryColor.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: redColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (v) => v == null || v.isEmpty ? 'Required field' : null,
          ),
        ),
      ],
    );
  }
}
