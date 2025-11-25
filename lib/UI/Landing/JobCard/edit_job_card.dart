import 'package:carwash/Alertbox/snackBarAlert.dart';
import 'package:carwash/Bloc/JobCards/job_card_bloc.dart';
import 'package:carwash/ModelClass/Customer/getVehicleByCustomerModel.dart';
import 'package:carwash/ModelClass/JobCard/getAllServiceModel.dart' as svc;
import 'package:carwash/ModelClass/JobCard/getAllSpareModel.dart' as spa;
import 'package:carwash/ModelClass/JobCard/getCustomerDropModel.dart';
import 'package:carwash/ModelClass/JobCard/getLocationModel.dart';
import 'package:carwash/ModelClass/Payment/payment_helper.dart';
import 'package:carwash/Reusable/color.dart';
import 'package:carwash/UI/Authentication/login_screen.dart';
import 'package:carwash/UI/DashBoard/DashBoard.dart';
import 'package:carwash/UI/Landing/Customer/add_customer.dart';
import 'package:carwash/UI/Landing/JobCard/search_text_controller.dart';
import 'package:carwash/UI/Landing/Vehicle/add_vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateJobCard extends StatelessWidget {
  final bool isTablet;
  const UpdateJobCard({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JobCardBloc(),
      child: UpdateJobCardView(isTablet: isTablet),
    );
  }
}

class UpdateJobCardView extends StatefulWidget {
  final bool isTablet;
  const UpdateJobCardView({super.key, required this.isTablet});

  @override
  State<UpdateJobCardView> createState() => _UpdateJobCardViewState();
}

class _UpdateJobCardViewState extends State<UpdateJobCardView>
    with SingleTickerProviderStateMixin {
  GetCustomerDropModel getCustomerDropModel = GetCustomerDropModel();
  GetVehicleByCustomerModel getVehicleByCustomerModel =
      GetVehicleByCustomerModel();
  GetLocationModel getLocationModel = GetLocationModel();
  svc.GetAllServiceModel getAllServiceModel = svc.GetAllServiceModel();
  spa.GetAllSpareModel getAllSpareModel = spa.GetAllSpareModel();
  late TabController _tabController;
  bool jobLoad = false;
  bool vehLoad = false;
  // Controllers for searchable fields
  TextEditingController customerController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController searchServiceController = TextEditingController();
  String? email;
  String? phone;
  String? cusId;
  String? regNo;
  String? year;
  String? locId;
  String? selectedStatus = "Pending";
  TextEditingController dateController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController amountPaymentController = TextEditingController();
  TextEditingController notesPaymentController = TextEditingController();
  final Map<int, TextEditingController> _priceControllers = {};

  List<svc.Result> selectedServices = [];
  List<svc.Result> allServices = [];
  List<svc.Result> filteredServices = [];
  List<Map<String, dynamic>> allSpares = [];
  List<Map<String, dynamic>> filteredSpares = [];
  List<Map<String, dynamic>> selectedSpares = [];
  double totalPrice = 0.0;
  final List<String> locations = ["Chennai", "Madurai", "Coimbatore"];
  final List<String> statuses = ["Pending", "In Progress", "Completed"];
  List<Payment> payments = [];
  bool showAddForm = false;
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
        _priceControllers.clear();
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
        _priceControllers.clear();
      }
    });
  }

  void _removeSelected(int index) {
    setState(() {
      selectedSpares.removeAt(index);
      _priceControllers.clear();
    });
  }

  void _recalculateTotal() {
    totalPrice = selectedSpares.fold<double>(
      0.0,
      (sum, spare) => sum + (spare['price'] as double? ?? 0.0),
    );
  }

  String selectedMethod = "Cash";
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    context.read<JobCardBloc>().add(CustomerDrop());
    context.read<JobCardBloc>().add(LocationDrop());
    context.read<JobCardBloc>().add(ServiceList());

    setState(() {
      jobLoad = true;
    });
    for (int i = 0; i < filteredSpares.length; i++) {
      _priceControllers[i] = TextEditingController(
        text: filteredSpares[i]['price'].toStringAsFixed(2),
      );
    }
  }

  @override
  void dispose() {
    customerController.dispose();
    vehicleController.dispose();
    locationController.dispose();
    dateController.dispose();
    notesController.dispose();
    _tabController.dispose();
    for (var controller in _priceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// service summary
  double get serviceTotal {
    return selectedServices.fold(0.0, (sum, item) => sum + (item.price ?? 0));
  }

  /// spares summary
  double get partsTotal {
    return selectedSpares.fold(
      0.0,
      (sum, item) => sum + ((item['price'] ?? 0) * (item['qty'] ?? 1)),
    );
  }

  ///summary total
  double get grandTotal => serviceTotal + partsTotal;

  /// payment section

  void addPayment(Payment data) {
    setState(() {
      payments.add(data);
      showAddForm = false; // Hide entry row after adding
    });
  }

  void removePayment(int index) {
    setState(() {
      payments.removeAt(index);
    });
  }

  double get totalPaid {
    return payments.fold(0, (sum, p) => sum + p.amount);
  }

  double get balanceDue {
    return grandTotal - totalPaid;
  }

  void _recalculateTotals() {
    totalPaid;
    balanceDue;
    setState(() {});
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
                _buildDetailsForm(widget.isTablet, textTheme, context),
                _buildService(widget.isTablet),
                _buildSpares(widget.isTablet),
                _buildSummary(widget.isTablet),
              ],
            ),
          ),
        ],
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const DashBoardScreen(selectedTab: 0),
          ),
          (route) => false,
        );
      },
      child: Scaffold(
        backgroundColor: appScaffoldBackground,
        appBar: AppBar(
          title: const Text(
            "Edit Job Card",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const DashBoardScreen(selectedTab: 0),
                ),
                (route) => false,
              );
            },
          ),
          backgroundColor: whiteColor,
          elevation: 0,
          foregroundColor: blackColor87,
        ),
        body: BlocBuilder<JobCardBloc, dynamic>(
          buildWhen: ((previous, current) {
            if (current is GetCustomerDropModel) {
              getCustomerDropModel = current;
              if (getCustomerDropModel.success == true) {
                setState(() {
                  jobLoad = false;
                });
              } else if (getCustomerDropModel.errorResponse != null) {
                debugPrint(
                  "Error: ${getCustomerDropModel.errorResponse?.message}",
                );
                setState(() {
                  jobLoad = false;
                });
              }
              if (getCustomerDropModel.errorResponse?.isUnauthorized == true) {
                _handle401Error();
                return true;
              }
              return true;
            }
            if (current is GetVehicleByCustomerModel) {
              getVehicleByCustomerModel = current;
              if (getVehicleByCustomerModel.success == true) {
                setState(() {
                  vehLoad = false;
                });
              } else if (getVehicleByCustomerModel.errorResponse != null) {
                debugPrint(
                  "Error: ${getVehicleByCustomerModel.errorResponse?.message}",
                );
                setState(() {
                  vehLoad = false;
                });
              }
              if (getVehicleByCustomerModel.errorResponse?.isUnauthorized ==
                  true) {
                _handle401Error();
                return true;
              }
              return true;
            }
            if (current is GetLocationModel) {
              getLocationModel = current;
              if (getLocationModel.success == true) {
                setState(() {
                  jobLoad = false;
                });
              } else if (getLocationModel.errorResponse != null) {
                debugPrint("Error: ${getLocationModel.errorResponse?.message}");
                setState(() {
                  jobLoad = false;
                });
              }
              if (getLocationModel.errorResponse?.isUnauthorized == true) {
                _handle401Error();
                return true;
              }
              return true;
            }
            if (current is svc.GetAllServiceModel) {
              getAllServiceModel = current;
              if (getAllServiceModel.success == true) {
                if (getAllServiceModel.result != null) {
                  allServices = getAllServiceModel.result!;
                  filteredServices = List.from(allServices);
                }
                setState(() {
                  jobLoad = false;
                });
              } else if (getAllServiceModel.errorResponse != null) {
                debugPrint(
                  "Error: ${getAllServiceModel.errorResponse?.message}",
                );

                setState(() {
                  jobLoad = false;
                });
              }
              if (getAllServiceModel.errorResponse?.isUnauthorized == true) {
                _handle401Error();
                return true;
              }
              return true;
            }
            if (current is spa.GetAllSpareModel) {
              getAllSpareModel = current;
              if (getAllSpareModel.success == true) {
                if (getAllSpareModel.result != null) {
                  allSpares = getAllSpareModel.result!.map((spare) {
                    return {
                      'id': spare.id,
                      'name': spare.name ?? "",
                      'part': spare.partNumber ?? "",
                      'stock': spare.inStock ?? 0,
                      'price': double.tryParse(spare.unitPrice ?? "0") ?? 0.0,
                    };
                  }).toList();

                  filteredSpares = List.from(allSpares);
                }
                setState(() {
                  jobLoad = false;
                });
              } else if (getAllSpareModel.errorResponse != null) {
                debugPrint("Error: ${getAllSpareModel.errorResponse?.message}");
                setState(() {
                  jobLoad = false;
                });
              }
              if (getAllSpareModel.errorResponse?.isUnauthorized == true) {
                _handle401Error();
                return true;
              }
              return true;
            }
            return false;
          }),
          builder: (context, dynamic) {
            return mainContainer();
          },
        ),
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
            child: AddCustomer(isTablet: isTablet, from: "addJobCard"),
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
              cusId: cusId.toString(),
            ),
          ),
        );
      },
    );
  }

  /// Details Screen
  Widget _buildDetailsForm(
    bool isTablet,
    TextTheme textTheme,
    BuildContext pageContext,
  ) {
    if (getCustomerDropModel.result == null) {
      return const Center(
        child: SpinKitFadingCube(color: appPrimaryColor, size: 30),
      );
    }
    final customers = getCustomerDropModel.result!.map((c) {
      return {
        "id": c.id,
        "firstName": c.firstName ?? "",
        "lastName": c.lastName ?? "",
        "email": c.email ?? "",
        "phone": c.phone ?? "",
      };
    }).toList();
    if (getLocationModel.result == null) {
      return const Center(
        child: SpinKitFadingCube(color: appPrimaryColor, size: 30),
      );
    }
    final locations = getLocationModel.result!.map((l) {
      return {
        "id": l.id,
        "locationName": l.locationName ?? "",
        "address": l.addressLine1 ?? "",
        "city": l.city ?? "",
        "state": l.state ?? "",
      };
    }).toList();
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
            items: customers
                .map((c) => "${c['firstName']} ${c['lastName']}".trim())
                .toList(),
            icon: Icons.person_outline,
            onAddNew: () {
              debugPrint("ADD NEW PRESSED");
              FocusScope.of(context).unfocus();
              setState(() {});
              _showAddCustomerDialog(context);
            },
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
                      style: const TextStyle(fontSize: 12, color: greyColor),
                    ),
                ],
              );
            },
            onItemSelected: (selectedItem) {
              final selectedIndex = customers
                  .map((c) => "${c['firstName']} ${c['lastName']}".trim())
                  .toList()
                  .indexOf(selectedItem);

              if (selectedIndex == -1) return; // Safety check

              setState(() {
                customerController.text = selectedItem;
                cusId = customers[selectedIndex]['id'] ?? "";
                email = customers[selectedIndex]['email'] ?? "";
                phone = customers[selectedIndex]['phone'] ?? "";
                vehicleController.clear();
                regNo = "";
                getVehicleByCustomerModel = GetVehicleByCustomerModel(
                  result: [],
                  success: true,
                );
                context.read<JobCardBloc>().add(
                  CustomerVehicle(cusId.toString()),
                );
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
                    "$email",
                    style: const TextStyle(
                      fontSize: 12,
                      color: appSecondaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "$phone",
                    style: const TextStyle(
                      fontSize: 12,
                      color: appSecondaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          if (customerController.text.isEmpty) const SizedBox(height: 20),
          if (customerController.text.isNotEmpty) ...[
            const SizedBox(height: 20),

            _buildSearchableDropdown(
              cusKey: ValueKey(cusId),
              label: "Vehicle",
              controller: vehicleController,
              items: getVehicleByCustomerModel.result == null
                  ? ["No vehicles found"]
                  : getVehicleByCustomerModel.result!.isEmpty
                  ? ["No vehicles found"]
                  : getVehicleByCustomerModel.result!
                        .map((v) => "${v.make} ${v.model}".trim())
                        .toList(),
              icon: Icons.directions_car_outlined,
              onAddNew: () => _showAddVehiclesDialog(context),

              displayBuilder: (index) {
                final item =
                    (getVehicleByCustomerModel.result == null ||
                        getVehicleByCustomerModel.result!.isEmpty)
                    ? "No vehicles found"
                    : "${getVehicleByCustomerModel.result![index].make} ${getVehicleByCustomerModel.result![index].model}"
                          .trim();

                if (item == "No vehicles found") {
                  return Center(
                    child: const Text(
                      "No vehicles found",
                      style: TextStyle(color: greyColor, fontSize: 14),
                    ),
                  );
                }

                final v = getVehicleByCustomerModel.result![index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${v.make} ${v.model}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: appPrimaryColor,
                      ),
                    ),
                    if (v.registrationNumber?.isNotEmpty ?? false)
                      Text(
                        v.registrationNumber!,
                        style: const TextStyle(fontSize: 12, color: greyColor),
                      ),
                  ],
                );
              },
              onItemSelected: (selected) {
                if (selected == "No vehicles found") {
                  vehicleController.clear();
                  regNo = "";
                  return;
                }
                final list = getVehicleByCustomerModel.result;

                if (list == null || list.isEmpty) return;

                final match = list.where(
                  (x) => "${x.make} ${x.model}".trim() == selected,
                );

                if (match.isEmpty) {
                  return;
                }

                final v = match.first;

                setState(() {
                  vehicleController.text = selected;
                  regNo = v.registrationNumber ?? "";
                  year = v.year ?? "";
                });
              },
            ),
          ],
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
                    "$regNo",
                    style: const TextStyle(
                      fontSize: 12,
                      color: appSecondaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "Year:$year",
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
            label: "Service Location *",
            controller: locationController,
            items: locations.map((c) => "${c['locationName']}".trim()).toList(),
            icon: Icons.person_outline,
            onAddNew: null,
            displayBuilder: (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locations[index]['locationName']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: appPrimaryColor,
                    ),
                  ),
                  Row(
                    children: [
                      if (locations[index]['address']!.isNotEmpty)
                        Text(
                          locations[index]['address']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: greyColor,
                          ),
                        ),
                      if (locations[index]['city']!.isNotEmpty)
                        Text(
                          ",${locations[index]['city']!}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: greyColor,
                          ),
                        ),
                      if (locations[index]['state']!.isNotEmpty)
                        Text(
                          ",${locations[index]['state']!}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: greyColor,
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
            onItemSelected: (selectedItem) {
              final selectedIndex = locations
                  .map((c) => "${c['locationName']}".trim())
                  .toList()
                  .indexOf(selectedItem);

              if (selectedIndex == -1) return; // Safety check

              setState(() {
                locationController.text = selectedItem;
                locId = locations[selectedIndex]['id'] ?? "";
              });
              debugPrint("locId:$locId");
              context.read<JobCardBloc>().add(SpareList(locId.toString()));
            },
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
    Key? cusKey,
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
        const SizedBox(height: 20),
        SearchableTextField(
          key: cusKey,
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {});
        onTap();
      },
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

  /// payment date selection
  DateTime selectedDate = DateTime.now();
  Future<void> _pickDatePayment(int index) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  /// Service Screen
  Widget _buildService(bool isTablet) {
    if (getAllServiceModel.result == null) {
      return const Center(
        child: SpinKitFadingCube(color: appPrimaryColor, size: 30),
      );
    }
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
            controller: searchServiceController,
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
              setState(() {
                filteredServices = allServices
                    .where(
                      (service) => (service.name ?? "").toLowerCase().contains(
                        value.toLowerCase(),
                      ),
                    )
                    .toList();
              });
            },
          ),
          const SizedBox(height: 10),

          // 🧾 Scrollable service list
          SingleChildScrollView(
            child: Column(
              children: filteredServices.map((svc.Result service) {
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
                          service.name.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text("₹${service.price?.toStringAsFixed(2)}"),
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
    final serviceTotal = selectedServices.fold<double>(
      0.0,
      (sum, item) => sum + (item.price as num).toDouble(),
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
                      widget.isTablet
                          ? "Select services from the left panel"
                          : "Select services from the top panel",
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
                                service.name.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text("₹${service.price?.toStringAsFixed(2)}"),
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
                          "₹${serviceTotal.toStringAsFixed(2)}",
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

  void _toggleSelection(svc.Result service) {
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
    if (getAllSpareModel.result == null) {
      return const Center(child: Text('Select a location to view spares'));
    }
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
            onChanged: (value) {
              setState(() {
                filteredSpares = allSpares.where((spare) {
                  final name = spare['name'].toString().toLowerCase();
                  final part = spare['part'].toString().toLowerCase();

                  return name.contains(value.toLowerCase()) ||
                      part.contains(value.toLowerCase());
                }).toList();
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredSpares.length,
              itemBuilder: (context, index) {
                final spare = filteredSpares[index];
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
    final spareTotal = selectedSpares.fold<double>(
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
                    shrinkWrap: true,
                    itemCount: selectedSpares.length,
                    itemBuilder: (context, index) {
                      final spare = selectedSpares[index];
                      if (!_priceControllers.containsKey(index)) {
                        _priceControllers[index] = TextEditingController(
                          text: spare['price'].toString(),
                        );
                      }
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
                                        onChanged: (value) {
                                          final price =
                                              double.tryParse(value.trim()) ??
                                              0.0;

                                          setState(() {
                                            spare['price'] = price;
                                            _recalculateTotal(); // Update your total immediately
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
                '₹${spareTotal.toStringAsFixed(2)}',
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
                '₹${spareTotal.toStringAsFixed(2)}',
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
              height: MediaQuery.of(context).size.height * 0.48,
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  /// Summary screen
  Widget _buildSummary(bool isTablet) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Job Card Summary",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ---- GRID BOXES ----
            GridView.count(
              crossAxisCount: isTablet ? 2 : 1,
              shrinkWrap: true,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: isTablet ? 3 : 2.6,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _summaryCard(
                  title: "Customer",
                  icon: Icons.person,
                  isEmpty: customerController.text.isEmpty,
                  emptyWidget: Text(
                    "No customer selected",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  filledWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(customerController.text),
                      Text("$email"),
                      Text("$phone"),
                    ],
                  ),
                ),
                _summaryCard(
                  title: "Vehicle",
                  icon: Icons.directions_car,
                  isEmpty: vehicleController.text.isEmpty,
                  emptyWidget: Text(
                    "No vehicle selected",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  filledWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vehicleController.text),
                      Text("$regNo"),
                      Text("$year"),
                    ],
                  ),
                ),
                _summaryCard(
                  title: "Services (${selectedServices.length})",
                  icon: Icons.build,
                  isEmpty: selectedServices.isEmpty,
                  emptyWidget: Text(
                    "No services selected",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  filledWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: selectedServices
                        .map((s) => Text("• ${s.name} - ₹${s.price}"))
                        .toList(),
                  ),
                ),
                _summaryCard(
                  title: "Spare Parts (${selectedSpares.length})",
                  icon: Icons.inventory_2,
                  isEmpty: selectedSpares.isEmpty,
                  emptyWidget: Text(
                    "No spare parts selected",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  filledWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: selectedSpares
                        .map((p) => Text("• ${p['name']} - ₹${p['price']}"))
                        .toList(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _totalCostBox(isTablet, serviceTotal, partsTotal, grandTotal),
            const SizedBox(height: 20),
            buildPaymentHistory(isTablet),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  setState(() {});
                },
                label: const Text(
                  "Create Job Card",
                  style: TextStyle(color: whiteColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required IconData icon,
    required bool isEmpty,
    required Widget emptyWidget,
    required Widget filledWidget,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: greyColor.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: blackColor87),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          isEmpty ? emptyWidget : filledWidget,
        ],
      ),
    );
  }

  Widget _totalCostBox(
    bool isTablet,
    double serviceTotal,
    double partsTotal,
    double grandTotal,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: appSecondaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Total Cost",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "Services: ₹${serviceTotal.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                "Parts: ₹${partsTotal.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          Text(
            "₹${grandTotal.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentHistory(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Payment History",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Only show Add Payment button if there's a balance due
            if (balanceDue > 0)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    // Create a new payment with default values
                    final newPayment = Payment(
                      date: DateTime.now(),
                      amount: 0,
                      mode: "Cash",
                      notes: "",
                    );
                    payments.add(newPayment);
                    // Clear controllers
                    amountPaymentController.clear();
                    notesPaymentController.clear();
                    selectedDate = DateTime.now();
                    selectedMethod = "Cash";
                  });
                },
                icon: const Icon(Icons.add, color: whiteColor),
                label: const Text(
                  "Add Payment",
                  style: TextStyle(color: whiteColor),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),

        // Show all payments in payment row format
        if (payments.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "No payments recorded yet.",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

        if (payments.isNotEmpty)
          ...payments.asMap().entries.map((entry) {
            final index = entry.key;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: greyColor.shade300),
              ),
              child: _paymentRow(index),
            );
          }),

        const Divider(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total Paid:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "₹${totalPaid.toStringAsFixed(2)}",
              style: const TextStyle(color: greenColor, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Balance Due:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "₹${balanceDue.toStringAsFixed(2)}",
              style: const TextStyle(color: redColor, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _paymentRow(int index) {
    if (index < 0 || index >= payments.length) {
      return const SizedBox(); // prevent RangeError
    }

    final payment = payments[index];

    final amountController = TextEditingController(
      text: payment.amount > 0 ? payment.amount.toString() : "",
    );
    final notesController = TextEditingController(text: payment.notes);

    final amountFocusNode = FocusNode();

    amountFocusNode.addListener(() {
      if (!amountFocusNode.hasFocus) {
        setState(() {
          payments[index].amount = double.tryParse(amountController.text) ?? 0;
          _recalculateTotals();
        });
      }
    });

    if (widget.isTablet) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: payment.date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    payments[index].date = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat("dd-MM-yyyy").format(payment.date),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  payments[index].amount = double.tryParse(value) ?? 0;
                  _recalculateTotals();
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Amount",
                prefixText: "₹",
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              value: payments[index].mode,
              items: [
                "Cash",
                "Card",
                "UPI",
                "Check",
              ].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
              onChanged: (val) {
                setState(() {
                  payments[index].mode = val!;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextField(
              controller: amountController,
              focusNode: amountFocusNode,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Amount",
                prefixText: "₹",
              ),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            icon: const Icon(Icons.close, color: redColor),
            onPressed: () {
              setState(() {
                payments.removeAt(index);
                _recalculateTotals();
              });
            },
          ),
        ],
      );
    }

    // Mobile Layout - Stacked Columns
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: payment.date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      payments[index].date = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: greyColor.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat("dd-MM-yyyy").format(payment.date),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: greyColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {
                setState(() {
                  payments.removeAt(index);
                  _recalculateTotals();
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: amountController,
                focusNode: amountFocusNode,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Amount",
                  prefixText: "₹",
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: payments[index].mode,
                items: ["Cash", "Card", "UPI", "Check"]
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    payments[index].mode = val!;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Method",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: notesController,
          onChanged: (v) {
            payments[index].notes = v;
          },
          decoration: const InputDecoration(
            hintText: "Optional notes",
            labelText: "Notes",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
