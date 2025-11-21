import 'package:carwash/Alertbox/snackBarAlert.dart';
import 'package:carwash/Bloc/Vehicle/vehicle_bloc.dart';
import 'package:carwash/ModelClass/Vehicle/getOneVehicleModel.dart';
import 'package:carwash/ModelClass/Vehicle/updateVehicleModel.dart';
import 'package:carwash/Reusable/color.dart';
import 'package:carwash/UI/Authentication/login_screen.dart';
import 'package:carwash/UI/DashBoard/DashBoard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditVehicle extends StatelessWidget {
  final bool isTablet;
  final String vehId;
  const EditVehicle({super.key, required this.isTablet, required this.vehId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VehicleBloc(),
      child: EditVehicleView(isTablet: isTablet, vehId: vehId),
    );
  }
}

class EditVehicleView extends StatefulWidget {
  final bool isTablet;
  final String vehId;
  const EditVehicleView({
    super.key,
    required this.isTablet,
    required this.vehId,
  });

  @override
  State<EditVehicleView> createState() => _EditVehicleViewState();
}

class _EditVehicleViewState extends State<EditVehicleView> {
  GetOneVehicleModel getOneVehicleModel = GetOneVehicleModel();
  UpdateVehicleModel updateVehicleModel = UpdateVehicleModel();
  final _formKey = GlobalKey<FormState>();
  bool isActive = true;
  bool vehLoad = false;
  bool updateLoad = false;

  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final colorController = TextEditingController();
  final regNumberController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<VehicleBloc>().add(VehicleById(widget.vehId.toString()));
    setState(() {
      vehLoad = true;
    });
  }

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
      return vehLoad
          ? Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
              ),
              alignment: Alignment.center,
              child: const SpinKitFadingCube(color: appPrimaryColor, size: 30),
            )
          : Padding(
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
                        decoration: inputDecoration.copyWith(
                          labelText: 'Status',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Active',
                            child: Text('Active'),
                          ),
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
                          updateLoad
                              ? const SpinKitCircle(
                                  color: appPrimaryColor,
                                  size: 30,
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<VehicleBloc>().add(
                                        UpdateVehicle(
                                          widget.vehId,
                                          makeController.text,
                                          modelController.text,
                                          getOneVehicleModel.result!.year
                                              .toString(),
                                          regNumberController.text,
                                          colorController.text,
                                          isActive,
                                          getOneVehicleModel.result!.customerId
                                              .toString(),
                                          getOneVehicleModel.result!.shopId
                                              .toString(),
                                        ),
                                      );
                                      setState(() {
                                        updateLoad = true;
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
      body: BlocBuilder<VehicleBloc, dynamic>(
        buildWhen: ((previous, current) {
          if (current is GetOneVehicleModel) {
            getOneVehicleModel = current;
            if (getOneVehicleModel.success == true) {
              setState(() {
                vehLoad = false;
                makeController.text = getOneVehicleModel.result!.make
                    .toString();
                modelController.text = getOneVehicleModel.result!.model
                    .toString();
                colorController.text = getOneVehicleModel.result!.color
                    .toString();
                regNumberController.text = getOneVehicleModel
                    .result!
                    .registrationNumber
                    .toString();
                isActive = getOneVehicleModel.result!.isActive ?? false;
              });
            } else if (getOneVehicleModel.errorResponse != null) {
              debugPrint("Error: ${getOneVehicleModel.errorResponse?.message}");
              setState(() {
                vehLoad = false;
              });
            }
            if (getOneVehicleModel.errorResponse?.isUnauthorized == true) {
              _handle401Error();
              return true;
            }
            return true;
          }
          if (current is UpdateVehicleModel) {
            updateVehicleModel = current;
            if (updateVehicleModel.errorResponse?.isUnauthorized == true) {
              _handle401Error();
              return true;
            }
            if (updateVehicleModel.errorResponse?.statusCode == 500) {
              showToast(
                updateVehicleModel.message ?? "Server error occurred",
                context,
                color: false,
              );
              setState(() => updateLoad = false);
              return true;
            }
            if (updateVehicleModel.success == true) {
              showToast(
                updateVehicleModel.message ?? "Customer Updated successfully",
                context,
                color: true,
              );
              setState(() {
                updateLoad = false;
              });
              Future.microtask(() {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const DashBoardScreen(selectedTab: 2),
                  ),
                );
              });
            } else if (updateVehicleModel.success == false) {
              showToast(
                updateVehicleModel.message.toString(),
                context,
                color: true,
              );
              setState(() {
                updateLoad = false;
              });
            } else if (updateVehicleModel.errorResponse != null) {
              showToast(
                updateVehicleModel.errorResponse?.message ??
                    "An error occurred",
                context,
                color: false,
              );
              setState(() => updateLoad = false);
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
