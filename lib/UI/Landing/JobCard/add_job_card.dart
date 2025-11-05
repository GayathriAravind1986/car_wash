import 'package:carwash/Alertbox/snackBarAlert.dart';
import 'package:carwash/Bloc/demo/demo_bloc.dart';
import 'package:carwash/Reusable/color.dart';
import 'package:carwash/UI/Landing/Customer/add_customer.dart';
import 'package:carwash/UI/Landing/JobCard/search_text_controller.dart';
import 'package:carwash/UI/Landing/Vehicle/add_vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddJobCard extends StatelessWidget {
  final bool isTablet;
  const AddJobCard({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: AddJobCardView(isTablet: isTablet),
    );
  }
}

class AddJobCardView extends StatefulWidget {
  final bool isTablet;
  const AddJobCardView({super.key, required this.isTablet});

  @override
  State<AddJobCardView> createState() => _AddJobCardViewState();
}

class _AddJobCardViewState extends State<AddJobCardView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers for searchable fields
  TextEditingController customerController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();

  String? selectedCustomer;
  String? selectedVehicle;
  String? selectedLocation;
  String? selectedStatus = "Pending";
  TextEditingController dateController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  final List<Map<String, String>> customers = [
    {"name": "Prakash Prakash", "email": "", "phone": "8908907654"},
    {
      "name": "Saranya Thangaraj",
      "email": "sentinix@gmail.com",
      "phone": "8908907654",
    },
    {
      "name": "Pradeep M",
      "email": "pradeep@yopmail.com",
      "phone": "8908907654",
    },
  ];

  final List<Map<String, String>> vehicles = [
    {"name": "Swift ZXI", "regNo": "TN-51-MP-1208"},
    {"name": "Swift Vxi", "regNo": "TN-23-BC-2021"},
  ];
  final List<String> locations = ["Chennai", "Madurai", "Coimbatore"];
  final List<String> statuses = ["Pending", "In Progress", "Completed"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    customerController.dispose();
    vehicleController.dispose();
    dateController.dispose();
    notesController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Widget mainContainer() {
      return Column(
        children: [
          Container(
            color: whiteColor,
            child: TabBar(
              controller: _tabController,
              labelColor: appPrimaryColor,
              unselectedLabelColor: greyColor,
              indicatorColor: appPrimaryColor,
              tabs: const [
                Tab(text: "Details"),
                Tab(text: "Services"),
                Tab(text: "Spares"),
                Tab(text: "Summary"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDetailsForm(widget.isTablet, textTheme),
                const Center(child: Text("Services content here")),
                const Center(child: Text("Spares content here")),
                const Center(child: Text("Summary content here")),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: appScaffoldBackground,
      appBar: AppBar(
        title: const Text(
          "Create Job Card",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: whiteColor,
        elevation: 0,
        foregroundColor: blackColor87,
      ),
      body: BlocBuilder<DemoBloc, dynamic>(
        buildWhen: ((previous, current) => false),
        builder: (context, dynamic) {
          return mainContainer();
        },
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
            child: AddCustomer(isTablet: isTablet),
          ),
        );
      },
    );
  }

  void _showAddVehiclesDialog(BuildContext context) {
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
            child: AddVehicle(
              isTablet: isTablet,
              from: "addJobCard",
              name: customerController.text,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailsForm(bool isTablet, TextTheme textTheme) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 60 : 16,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchableDropdown(
            label: "Customer",
            controller: customerController,
            items: customers.map((c) => c['name']!).toList(),
            icon: Icons.person_outline,
            onAddNew: () => _showAddCustomerDialog(context),
            displayBuilder: (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customers[index]['name']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: appPrimaryColor,
                    ),
                  ),
                  if (customers[index]['email']!.isNotEmpty)
                    Text(
                      customers[index]['email']!,
                      style: const TextStyle(fontSize: 12, color: greyColor),
                    ),
                ],
              );
            },
            onItemSelected: (selectedItem) {
              setState(() {
                customerController.text = selectedItem;
                debugPrint("Selected Customer: $selectedItem");
              });
            },
          ),
          if (customerController.text.isNotEmpty) const SizedBox(height: 10),
          if (customerController.text.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: appSecondaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: appSecondaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerController.text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: appPrimaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "email",
                    style: const TextStyle(
                      fontSize: 12,
                      color: appSecondaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "phone",
                    style: const TextStyle(
                      fontSize: 12,
                      color: appSecondaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),

          _buildSearchableDropdown(
            label: "Vehicle",
            controller: vehicleController,
            items: vehicles.map((c) => c['name']!).toList(),
            icon: Icons.directions_car_outlined,
            onAddNew: () {
              if (customerController.text.isEmpty) {
                showToast(
                  "Choose customer to add new vehicle",
                  context,
                  color: false,
                );
              } else {
                _showAddVehiclesDialog(context);
              }
            },
            displayBuilder: (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicles[index]['name']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: appPrimaryColor,
                    ),
                  ),
                  if (vehicles[index]['regNo']!.isNotEmpty)
                    Text(
                      vehicles[index]['regNo']!,
                      style: const TextStyle(fontSize: 12, color: greyColor),
                    ),
                ],
              );
            },
            onItemSelected: (selectedItem) {
              setState(() {
                vehicleController.text = selectedItem;
                debugPrint("Selected vehicles: $selectedItem");
              });
            },
          ),
          if (vehicleController.text.isNotEmpty) const SizedBox(height: 10),
          if (vehicleController.text.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: appSecondaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: appSecondaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicleController.text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: appPrimaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "regNo",
                    style: const TextStyle(
                      fontSize: 12,
                      color: appSecondaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "phone",
                    style: const TextStyle(
                      fontSize: 12,
                      color: appSecondaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),

          _buildDropdown(
            label: "Select Location *",
            value: selectedLocation,
            items: locations,
            onChanged: (v) => setState(() => selectedLocation = v),
          ),
          const SizedBox(height: 20),

          sectionTitle(Icons.calendar_today_outlined, "Service Date"),
          TextField(
            controller: dateController,
            readOnly: true,
            onTap: _pickDate,
            cursorColor: appPrimaryColor,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: appPrimaryColor,
            ),
            decoration: InputDecoration(
              hintText: 'Select Date',
              hintStyle: const TextStyle(fontSize: 14, color: greyColor),
              suffixIcon: const Icon(Icons.calendar_today_outlined),
              filled: true,
              fillColor: greyColor200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),

          _buildDropdown(
            label: "Status",
            value: selectedStatus,
            items: statuses,
            icon: Icons.check_circle_outline,
            onChanged: (v) => setState(() => selectedStatus = v),
          ),
          const SizedBox(height: 20),

          sectionTitle(Icons.note_outlined, "Notes"),
          TextField(
            controller: notesController,
            maxLines: 4,
            cursorColor: appPrimaryColor,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: appPrimaryColor,
            ),
            decoration: InputDecoration(
              hintText: "Add any additional notes...",
              hintStyle: const TextStyle(fontSize: 14, color: greyColor),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Searchable Dropdown Widget
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

  Widget sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black87),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    IconData? icon,
    VoidCallback? onAddNew,
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
        DropdownButtonFormField<String>(
          value: value,
          hint: Text("Select $label", style: TextStyle(fontSize: 14)),
          decoration: InputDecoration(
            filled: true,
            fillColor: greyColor200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: TextStyle(fontSize: 14, color: appPrimaryColor),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
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

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }
}
