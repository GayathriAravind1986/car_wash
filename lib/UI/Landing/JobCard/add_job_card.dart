import 'package:carwash/Alertbox/snackBarAlert.dart';
import 'package:carwash/Bloc/demo/demo_bloc.dart';
import 'package:carwash/Reusable/color.dart';
import 'package:carwash/UI/Landing/Customer/add_customer.dart';
import 'package:carwash/UI/Landing/JobCard/search_text_controller.dart';
import 'package:carwash/UI/Landing/Vehicle/add_vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController searchController = TextEditingController();
  final Map<int, TextEditingController> _priceControllers = {};
  List<Map<String, dynamic>> availableServices = [
    {"name": "Water wash", "price": 500.0},
    {"name": "Wheel Alignment", "price": 2000.0},
    {"name": "Oil Change", "price": 800.0},
  ];

  List<Map<String, dynamic>> selectedServices = [];

  List<Map<String, dynamic>> availableSpares = [
    {'name': 'Bolt', 'part': '123', 'stock': 10, 'price': 10.0},
    {'name': 'Brake oil', 'part': '89200KPL', 'stock': 90, 'price': 150.0},
    {'name': 'Clutch pad', 'part': '029902', 'stock': 0, 'price': 100.0},
    {'name': 'Wheel', 'part': '12', 'stock': 5, 'price': 5000.0},
  ];

  List<Map<String, dynamic>> selectedSpares = [];

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
  void _toggleSpareSelection(Map<String, dynamic> spare) {
    final existingIndex = selectedSpares.indexWhere(
      (item) => item['part'] == spare['part'],
    );
    if (existingIndex == -1 && spare['stock'] > 0) {
      setState(() {
        selectedSpares.add({...spare, 'qty': 1});
      });
    } else if (existingIndex != -1) {
      setState(() {
        selectedSpares.removeAt(existingIndex);
      });
    }
  }

  void _incrementQty(int index) {
    setState(() {
      if (selectedSpares[index]['qty'] < selectedSpares[index]['stock']) {
        selectedSpares[index]['qty']++;
      }
    });
  }

  void _decrementQty(int index) {
    setState(() {
      if (selectedSpares[index]['qty'] > 1) {
        selectedSpares[index]['qty']--;
      } else {
        selectedSpares.removeAt(index);
      }
    });
  }

  void _removeSelected(int index) {
    setState(() {
      selectedSpares.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    for (int i = 0; i < availableSpares.length; i++) {
      _priceControllers[i] = TextEditingController(
        text: availableSpares[i]['price'].toStringAsFixed(2),
      );
    }
  }

  @override
  void dispose() {
    customerController.dispose();
    vehicleController.dispose();
    dateController.dispose();
    notesController.dispose();
    _tabController.dispose();
    for (var controller in _priceControllers.values) {
      controller.dispose();
    }
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
                _buildService(widget.isTablet),
                _buildSpares(widget.isTablet),
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

  /// Details Screen
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

  /// Service Screen
  Widget _buildService(bool isTablet) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 24 : 12),
      child: isTablet
          ? SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: _buildAvailableServicesCard()),
                  const SizedBox(width: 20),
                  Expanded(flex: 1, child: _buildSelectedServicesCard()),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildAvailableServicesCard(),
                  const SizedBox(height: 20),
                  _buildSelectedServicesCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildAvailableServicesCard() {
    return _buildCard(
      title: "Available Services",
      child: Column(
        children: [
          // 🔍 Search box just below the title
          TextField(
            decoration: InputDecoration(
              hintText: 'Search services...',
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: greyColor300!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: greyColor300!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: appSecondaryColor),
              ),
            ),
            onChanged: (value) {
              // optional: implement search filter logic
              setState(() {
                // availableServices = availableServices
                //     .where(
                //       (service) => service['name'].toLowerCase().contains(
                //         value.toLowerCase(),
                //       ),
                //     )
                //     .toList();
              });
            },
          ),
          const SizedBox(height: 10),

          // 🧾 Scrollable service list
          SingleChildScrollView(
            child: Column(
              children: availableServices.map((service) {
                bool isSelected = selectedServices.contains(service);
                return GestureDetector(
                  onTap: () => _toggleSelection(service),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? appSecondaryColor.withOpacity(0.08)
                          : whiteColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? appSecondaryColor : greyColor300!,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          service['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text("₹${service['price'].toStringAsFixed(2)}"),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedServicesCard() {
    final total = selectedServices.fold<double>(
      0.0,
      (sum, item) => sum + (item['price'] as double),
    );

    return _buildCard(
      title: "Selected Services (${selectedServices.length})",
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        constraints: const BoxConstraints(
          minHeight: 240, // Ensures consistent minimum height
        ),
        alignment: Alignment.center,
        child: selectedServices.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.info_outline, size: 20, color: greyColor),
                    const SizedBox(height: 8),
                    Text(
                      "Select services from the left panel",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: greyColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  ...selectedServices.map((service) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: appSecondaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: appSecondaryColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text("₹${service['price'].toStringAsFixed(2)}"),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => _toggleSelection(service),
                            child: const Icon(Icons.close, color: redColor),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 16,
                            color: appPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "₹${total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: appPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: greyColor300!),
        boxShadow: [
          BoxShadow(color: greyColor200!, spreadRadius: 1, blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  void _toggleSelection(Map<String, dynamic> service) {
    setState(() {
      if (selectedServices.contains(service)) {
        selectedServices.remove(service);
      } else {
        selectedServices.add(service);
      }
    });
  }

  /// spares screen
  Widget _buildSpares(bool isTablet) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 24 : 12),
      child: isTablet
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: _buildAvailableSparesCard()),
                const SizedBox(width: 20),
                Expanded(flex: 1, child: _buildSelectedSparesCard()),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildAvailableSparesCard(),
                  const SizedBox(height: 20),
                  _buildSelectedSparesCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildAvailableSparesCard() {
    return _buildSpareCard(
      title: "Available Spares",
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by name or part number...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: availableSpares.length,
              itemBuilder: (context, index) {
                final spare = availableSpares[index];
                final isSelected = selectedSpares.any(
                  (selected) => selected['part'] == spare['part'],
                );
                final inStock = spare['stock'] > 0;

                return GestureDetector(
                  onTap: inStock ? () => _toggleSpareSelection(spare) : null,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? appSecondaryColor.withOpacity(0.08)
                          : inStock
                          ? whiteColor
                          : greyColor200,
                      border: Border.all(
                        color: isSelected ? appSecondaryColor : greyColor300!,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                spare['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Part: ${spare['part']} | Stock: ${spare['stock']}',
                                style: TextStyle(
                                  color: inStock
                                      ? blackColor54
                                      : redAccentColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '₹${spare['price'].toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Selected Spares
  Widget _buildSelectedSparesCard() {
    final total = selectedSpares.fold<double>(
      0.0,
      (sum, item) => sum + (item['price'] * item['qty']),
    );
    return _buildSpareCard(
      title: "Selected Spares (${selectedSpares.length})",
      child: Column(
        children: [
          Expanded(
            child: selectedSpares.isEmpty
                ? const Center(child: Text('No spares selected yet'))
                : ListView.builder(
                    itemCount: selectedSpares.length,
                    itemBuilder: (context, index) {
                      final spare = selectedSpares[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: appSecondaryColor.withOpacity(0.08),
                          border: Border.all(color: appSecondaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  spare['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _removeSelected(index),
                                  child: const Icon(
                                    Icons.close,
                                    color: redColor,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            Text('Part: ${spare['part']}'),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, size: 20),
                                      onPressed: () => _decrementQty(index),
                                    ),
                                    Text('${spare['qty']}'),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 20),
                                      onPressed: () => _incrementQty(index),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: TextField(
                                        cursorColor: appPrimaryColor,
                                        controller: _priceControllers[index],
                                        textAlign: TextAlign.center,
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d{0,2}'),
                                          ),
                                        ],
                                        decoration: InputDecoration(
                                          prefixIcon: const Padding(
                                            padding: EdgeInsets.only(
                                              left: 10,
                                              right: 2,
                                              top: 8,
                                              bottom: 8,
                                            ),
                                            child: Text(
                                              '₹',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: blackColor87,
                                              ),
                                            ),
                                          ),
                                          prefixIconConstraints:
                                              const BoxConstraints(
                                                minWidth: 0,
                                                minHeight: 0,
                                              ),
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                vertical: 6,
                                                horizontal: 8,
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: greyColor,
                                            ), // your existing gray color
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                                borderSide: BorderSide(
                                                  color: appSecondaryColor,
                                                  width: 1.5,
                                                ),
                                              ),
                                        ),
                                        onChanged: (v) {
                                          final value =
                                              double.tryParse(v) ??
                                              spare['price'];
                                          setState(() {
                                            spare['price'] = value;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '₹${(spare['price'] * spare['qty']).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              'In stock: ${spare['stock']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: blackColor54,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(
                  color: appPrimaryColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              Text(
                '₹${total.toStringAsFixed(2)}',
                style: TextStyle(
                  color: appPrimaryColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  color: appPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '₹${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: greenColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpareCard({required String title, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
