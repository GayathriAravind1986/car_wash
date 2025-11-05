import 'package:carwash/Bloc/demo/demo_bloc.dart';
import 'package:carwash/Reusable/color.dart';
import 'package:carwash/UI/Landing/Customer/add_customer.dart';
import 'package:carwash/UI/Landing/Customer/edit_customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const CustomersPageView(),
    );
  }
}

class CustomersPageView extends StatefulWidget {
  const CustomersPageView({super.key});

  @override
  State<CustomersPageView> createState() => _CustomersPageViewState();
}

class _CustomersPageViewState extends State<CustomersPageView> {
  final TextEditingController _searchController = TextEditingController();
  int currentPage = 1;
  bool? isEdit = false;
  final List<Map<String, dynamic>> customer = [
    {"name": "Pradeep", "contact": "9780765435", "status": "Active"},
    {"name": "Vinoth", "contact": "9996780654", "status": "Active"},
    {"name": "Daniel", "contact": "9780765890", "status": "InActive"},
    {"name": "Francis", "contact": "9980735435", "status": "Active"},
    {"name": "Francis", "contact": "9980735435", "status": "Active"},
    {"name": "Francis", "contact": "9980735435", "status": "Active"},
    {"name": "Francis", "contact": "9980735435", "status": "Active"},
    {"name": "Francis", "contact": "9980735435", "status": "Active"},
    {"name": "Francis", "contact": "9980735435", "status": "Active"},
    {"name": "Francis", "contact": "9980735435", "status": "Active"},
    {"name": "Francis", "contact": "9980735435", "status": "Active"},
    {"name": "Francis", "contact": "9980735435", "status": "Active"},
    {"name": "Francis", "contact": "9980735435", "status": "Active"},
    {"name": "Francis", "contact": "9980735435", "status": "Active"},
    {"name": "Francis", "contact": "9980735435", "status": "Active"},
    {"name": "Francis", "contact": "9980735435", "status": "Active"},
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return greenColor.shade100;
      case 'InActive':
        return redColor.shade100;
      default:
        return greyColor.shade100;
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case 'Active':
        return greenColor;
      case 'InActive':
        return redColor;
      default:
        return blackColor87;
    }
  }

  void _showAddEditCustomerDialog(BuildContext context) {
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
            child: isEdit == true
                ? EditCustomer(isTablet: isTablet)
                : AddCustomer(isTablet: isTablet),
          ),
        );
      },
    );
  }

  void showCustomerVehiclesPopup(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    showDialog(
      context: context,
      barrierColor: greyColor.withOpacity(0.85),
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: isTablet ? 150 : 20,
            vertical: isTablet ? 100 : 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: isTablet ? 400 : double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Title + Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Customer Vehicles",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: blackColor87,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: blackColor54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 🔹 Vehicle List
                Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "TN-51-MP-1208",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: blackColor87,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Mercedez - S-class",
                        style: TextStyle(fontSize: 14, color: blackColor54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    Widget mainContainer() {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 40 : 16,
          vertical: isTablet ? 24 : 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: whiteColor,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Job Cards Table
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: greyColor.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: isTablet
                    ? _buildScrollableTable() // tablet => wide table
                    : _buildListView(), // mobile => card view
              ),
            ),

            const SizedBox(height: 12),

            // Pagination Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: currentPage > 1
                      ? () => setState(() => currentPage--)
                      : null,
                  child: const Text("Prev"),
                ),
                Text(
                  "Showing 1–${customer.length} of ${customer.length}",
                  style: const TextStyle(color: blackColor54),
                ),
                OutlinedButton(onPressed: () {}, child: const Text("Next")),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: appScaffoldBackground,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        title: const Text(
          "Customers",
          style: TextStyle(color: blackColor87, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isEdit = false;
                  _showAddEditCustomerDialog(context);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blackColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              child: const Text(
                "Add Customer",
                style: TextStyle(color: whiteColor),
              ),
            ),
          ),
        ],
      ),
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

  // 🔹 Tablet View => DataTable Layout
  Widget _buildScrollableTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 800, // Set a wider width to allow scroll
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(greyColor.shade200),
            columns: const [
              DataColumn(label: Text('NAME')),
              DataColumn(label: Text('CONTACT')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: customer.map((job) {
              return DataRow(
                cells: [
                  DataCell(Text(job['name']!)),
                  DataCell(Text(job['contact']!)),
                  DataCell(_statusBadge(job['status']!)),
                  DataCell(
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isEdit = true;
                              _showAddEditCustomerDialog(context);
                            });
                          },
                          child: Icon(
                            Icons.edit,
                            color: appSecondaryColor.withOpacity(0.7),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            showCustomerVehiclesPopup(context);
                          },
                          child: Icon(
                            Icons.remove_red_eye_outlined,
                            color: appSecondaryColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // 🔹 Mobile View => ListView Layout
  Widget _buildListView() {
    return ListView.builder(
      itemCount: customer.length,
      itemBuilder: (context, index) {
        final job = customer[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      job["name"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text("Contact: ${job["contact"]}"),
                const SizedBox(height: 8),
                Row(children: [_statusBadge(job["status"])]),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isEdit = true;
                          _showAddEditCustomerDialog(context);
                        });
                      },
                      child: Icon(
                        Icons.edit,
                        color: appSecondaryColor.withOpacity(0.7),
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        showCustomerVehiclesPopup(context);
                      },
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        color: appSecondaryColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔹 Reusable status badge
  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: getStatusColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: getStatusTextColor(status),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
