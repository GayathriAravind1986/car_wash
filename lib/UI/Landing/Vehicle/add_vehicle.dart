import 'package:carwash/Alertbox/snackBarAlert.dart';
import 'package:carwash/Bloc/Vehicle/vehicle_bloc.dart';
import 'package:carwash/ModelClass/JobCard/getCustomerDropModel.dart';
import 'package:carwash/ModelClass/Vehicle/postVehicleModel.dart';
import 'package:carwash/Reusable/color.dart';
import 'package:carwash/UI/Authentication/login_screen.dart';
import 'package:carwash/UI/DashBoard/DashBoard.dart';
import 'package:carwash/UI/Landing/Customer/add_customer.dart';
import 'package:carwash/UI/Landing/JobCard/add_job_card.dart';
import 'package:carwash/UI/Landing/JobCard/search_text_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddVehicle extends StatelessWidget {
  final bool isTablet;
  final String from;
  final String name;
  final String cusId;
  const AddVehicle({
    super.key,
    required this.isTablet,
    required this.from,
    required this.name,
    required this.cusId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VehicleBloc(),
      child: AddVehicleView(
        isTablet: isTablet,
        from: from,
        name: name,
        cusId: cusId,
      ),
    );
  }
}

class AddVehicleView extends StatefulWidget {
  final bool isTablet;
  final String from;
  final String name;
  final String cusId;
  const AddVehicleView({
    super.key,
    required this.isTablet,
    required this.from,
    required this.name,
    required this.cusId,
  });

  @override
  State<AddVehicleView> createState() => _AddVehicleViewState();
}

class _AddVehicleViewState extends State<AddVehicleView> {
  PostVehicleModel postVehicleModel = PostVehicleModel();
  GetCustomerDropModel getCustomerDropModel = GetCustomerDropModel();
  final _formKey = GlobalKey<FormState>();
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final colorController = TextEditingController();
  final regNumberController = TextEditingController();
  final vinController = TextEditingController();
  bool isActive = true;
  bool createVehLoad = false;
  bool cusDropLoad = false;
  String? selectedYear;
  String? selectedCustomer;
  String? cusId;
  TextEditingController customerController = TextEditingController();
  @override
  void initState() {
    super.initState();
    selectedYear = DateTime.now().year.toString();
    context.read<VehicleBloc>().add(CustomerDrop());
    setState(() {
      cusDropLoad = true;
    });
  }

  @override
  void dispose() {
    customerController.dispose();
    super.dispose();
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
      if (getCustomerDropModel.result == null) {
        return const Center(
          child: SpinKitFadingCube(color: appPrimaryColor, size: 30),
        );
      }
      final customers = getCustomerDropModel.result!.map((c) {
        return {
          "cusId": c.id ?? "",
          "firstName": c.firstName ?? "",
          "lastName": c.lastName ?? "",
          "email": c.email ?? "",
          "phone": c.phone ?? "",
        };
      }).toList();
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
                      "Create New Vehicle",
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
                if (widget.from == "addJobCard")
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: appSecondaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Customer: ${widget.name}",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                if (widget.from == "vehicle")
                  _buildSearchableDropdown(
                    label: "Customer",
                    controller: customerController,
                    items: customers
                        .map((c) => "${c['firstName']} ${c['lastName']}".trim())
                        .toList(),
                    icon: Icons.person_outline,
                    onAddNew: () => _showAddCustomerDialog(context),
                    displayBuilder: (index) {
                      final fullName =
                          "${customers[index]['firstName']} ${customers[index]['lastName']}"
                              .trim();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: appPrimaryColor,
                            ),
                          ),
                          if (customers[index]['email']!.isNotEmpty)
                            Text(
                              customers[index]['email']!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: greyColor,
                              ),
                            ),
                        ],
                      );
                    },
                    onItemSelected: (selectedItem) {
                      final selectedIndex = customers
                          .map(
                            (c) => "${c['firstName']} ${c['lastName']}".trim(),
                          )
                          .toList()
                          .indexOf(selectedItem);

                      if (selectedIndex == -1) return;
                      setState(() {
                        customerController.text = selectedItem;
                        cusId = customers[selectedIndex]['cusId'] ?? "";
                        debugPrint("Selected Customer: $selectedItem");
                      });
                    },
                  ),
                const SizedBox(height: 16),
                widget.isTablet
                    ? Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Make *',
                              hintText: "Toyota",
                              makeController,
                              inputDecoration,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(
                              'Model *',
                              hintText: "Camry",
                              modelController,
                              inputDecoration,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildTextField(
                            'Make *',
                            hintText: "Toyota",
                            makeController,
                            inputDecoration,
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            'Model *',
                            hintText: "Camry",
                            modelController,
                            inputDecoration,
                          ),
                        ],
                      ),
                const SizedBox(height: 16),

                // Year & Color
                widget.isTablet
                    ? Row(
                        children: [
                          Expanded(
                            child: _buildDropdownField(
                              'Year',
                              selectedYear,
                              inputDecoration,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(
                              'Color',
                              hintText: "Black",
                              colorController,
                              inputDecoration,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildDropdownField(
                            'Year',
                            selectedYear,
                            inputDecoration,
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            'Color',
                            hintText: "Black",
                            colorController,
                            inputDecoration,
                          ),
                        ],
                      ),
                const SizedBox(height: 16),

                // Registration Number
                _buildTextField(
                  'Registration Number *',
                  hintText: "ABC-1234",
                  regNumberController,
                  inputDecoration,
                ),
                const SizedBox(height: 16),

                // VIN
                _buildTextField(
                  'VIN',
                  hintText: "1G1YY22G965123456",
                  vinController,
                  inputDecoration,
                  isRequired: false,
                ),
                const SizedBox(height: 8),
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
                    createVehLoad
                        ? const SpinKitCircle(color: appPrimaryColor, size: 30)
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<VehicleBloc>().add(
                                  CreateVehicle(
                                    makeController.text,
                                    modelController.text,
                                    selectedYear.toString(),
                                    regNumberController.text,
                                    colorController.text,
                                    isActive,
                                    widget.from == "addJobCard"
                                        ? widget.cusId
                                        : cusId.toString(),
                                  ),
                                );
                                setState(() {
                                  createVehLoad = true;
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
                              'Create Vehicle',
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
          if (current is GetCustomerDropModel) {
            getCustomerDropModel = current;
            if (getCustomerDropModel.success == true) {
              setState(() {
                cusDropLoad = false;
              });
            } else if (getCustomerDropModel.errorResponse != null) {
              debugPrint(
                "Error: ${getCustomerDropModel.errorResponse?.message}",
              );
              setState(() {
                cusDropLoad = false;
              });
            }
            if (getCustomerDropModel.errorResponse?.isUnauthorized == true) {
              _handle401Error();
              return true;
            }
            return true;
          }
          if (current is PostVehicleModel) {
            postVehicleModel = current;
            if (postVehicleModel.errorResponse?.isUnauthorized == true) {
              _handle401Error();
              return true;
            }
            if (postVehicleModel.errorResponse?.statusCode == 500) {
              showToast(
                postVehicleModel.message ?? "Server error occurred",
                context,
                color: false,
              );
              setState(() => createVehLoad = false);
              return true;
            }
            if (postVehicleModel.success == true) {
              showToast(
                postVehicleModel.message ?? "Vehicle Created successfully",
                context,
                color: true,
              );
              setState(() {
                createVehLoad = false;
              });
              Future.microtask(() {
                widget.from == "addJobCard"
                    ? Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              AddJobCard(isTablet: widget.isTablet),
                        ),
                      )
                    : Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              const DashBoardScreen(selectedTab: 2),
                        ),
                      );
              });
            } else if (postVehicleModel.success == false) {
              showToast(
                postVehicleModel.message.toString(),
                context,
                color: true,
              );
              setState(() {
                createVehLoad = false;
              });
            } else if (postVehicleModel.errorResponse != null) {
              showToast(
                postVehicleModel.errorResponse?.message ?? "An error occurred",
                context,
                color: false,
              );
              setState(() => createVehLoad = false);
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

  Widget _buildSearchableDropdown({
    required String label,
    required TextEditingController controller,
    required List<String> items,
    IconData? icon,
    VoidCallback? onAddNew,
    Widget Function(int index)? displayBuilder,
    ValueChanged<String>? onItemSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          icon: icon ?? Icons.label_outline,
          title: label,
          trailing: onAddNew != null ? _buildAddNewButton(onAddNew) : null,
        ),
        const SizedBox(height: 6),
        SearchableTextField(
          controller: controller,
          items: items,
          hintText: "Search $label",
          onItemSelected: onItemSelected,
          displayBuilder: displayBuilder,
        ),
      ],
    );
  }

  Widget _sectionTitle({
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: appPrimaryColor),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: appPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildAddNewButton(VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        "+ Add New",
        style: TextStyle(
          color: appSecondaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  void _showAddCustomerDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: greyColor.withOpacity(0.85),
      builder: (context) {
        final isTablet = MediaQuery.of(context).size.width > 600;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          insetPadding: EdgeInsets.symmetric(
            horizontal: isTablet ? 100 : 16,
            vertical: isTablet ? 60 : 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: AddCustomer(isTablet: isTablet, from: "vehicle"),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    InputDecoration decoration, {
    String? hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool isRequired = true,
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
            validator: isRequired
                ? (v) => v == null || v.isEmpty ? 'Required field' : null
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String? selectedValue,
    InputDecoration decoration,
  ) {
    final currentYear = DateTime.now().year;
    final years = List.generate(
      30,
      (index) => (currentYear - index).toString(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items: years
              .map((year) => DropdownMenuItem(value: year, child: Text(year)))
              .toList(),
          onChanged: (value) => setState(() => selectedYear = value),
          decoration: decoration,
        ),
      ],
    );
  }
}
