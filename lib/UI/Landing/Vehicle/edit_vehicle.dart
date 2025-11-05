import 'package:carwash/Bloc/demo/demo_bloc.dart';
import 'package:carwash/Reusable/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditVehicle extends StatelessWidget {
  final bool isTablet;
  const EditVehicle({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: EditVehicleView(isTablet: isTablet),
    );
  }
}

class EditVehicleView extends StatefulWidget {
  final bool isTablet;
  const EditVehicleView({super.key, required this.isTablet});

  @override
  State<EditVehicleView> createState() => _EditVehicleViewState();
}

class _EditVehicleViewState extends State<EditVehicleView> {
  final _formKey = GlobalKey<FormState>();
  bool isActive = true;

  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final colorController = TextEditingController();
  final regNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: whiteColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: greyColor),
      ),
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
                      "Edit Vehicle",
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
                Column(
                  children: [
                    _buildTextField(
                      'Make',
                      hintText: "Toyota",
                      makeController,
                      inputDecoration,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      'Model',
                      hintText: "Camry",
                      modelController,
                      inputDecoration,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'Color',
                  hintText: "Black",
                  colorController,
                  inputDecoration,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  'Registration Number',
                  hintText: "ABC-1234",
                  regNumberController,
                  inputDecoration,
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: isActive ? 'Active' : 'Inactive',
                  decoration: inputDecoration.copyWith(labelText: 'Status'),
                  items: const [
                    DropdownMenuItem(value: 'Active', child: Text('Active')),
                    DropdownMenuItem(
                      value: 'Inactive',
                      child: Text('Inactive'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      isActive = value == 'Active';
                    });
                  },
                ),
                const SizedBox(height: 24),

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
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context);
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
                        'Update changes',
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
            style: const TextStyle(color: appPrimaryColor, fontSize: 14),
            keyboardType: keyboardType,
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
                borderSide: BorderSide(color: appPrimaryColor),
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
