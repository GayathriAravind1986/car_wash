import 'package:carwash/Bloc/demo/demo_bloc.dart';
import 'package:carwash/Reusable/color.dart';
import 'package:carwash/Reusable/text_styles.dart';
import 'package:carwash/UI/Landing/Vehicle/add_vehicle.dart';
import 'package:carwash/UI/Landing/Vehicle/edit_vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehiclesPage extends StatelessWidget {
  const VehiclesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const VehiclesPageView(),
    );
  }
}

class VehiclesPageView extends StatefulWidget {
  const VehiclesPageView({super.key});

  @override
  State<VehiclesPageView> createState() => _VehiclesPageViewState();
}

class _VehiclesPageViewState extends State<VehiclesPageView> {
  final TextEditingController _searchController = TextEditingController();
  int currentPage = 1;
  bool? isEdit = false;
  final List<Map<String, dynamic>> vehicle = [
    {
      "make": "Swift",
      "model": "Vxi",
      "regNo": "Tn76 8986",
      "color": "White",
      "status": "Active",
    },
    {
      "make": "Swift",
      "model": "ZXI",
      "regNo": "TN76BY8986",
      "color": "White",
      "status": "Active",
    },
    {
      "make": "Mercedez",
      "model": "S-class",
      "regNo": "TN-51-MP-1208",
      "color": "White",
      "status": "Active",
    },
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

  void _showAddEditVehiclesDialog(BuildContext context) {
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
                ? EditVehicle(isTablet: isTablet)
                : AddVehicle(isTablet: isTablet, from: "vehicle", name: ""),
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
                  "Showing 1–${vehicle.length} of ${vehicle.length}",
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
          "Vehicles",
          style: TextStyle(color: blackColor87, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isEdit = false;
                  _showAddEditVehiclesDialog(context);
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
                "Add Vehicle",
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
              DataColumn(label: Text('MAKE')),
              DataColumn(label: Text('MODEL')),
              DataColumn(label: Text('REGISTRATION NUMBER')),
              DataColumn(label: Text('COLOR')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: vehicle.map((job) {
              return DataRow(
                cells: [
                  DataCell(Text(job['make']!)),
                  DataCell(Text(job['model']!)),
                  DataCell(Text(job['regNo']!)),
                  DataCell(Text(job['color']!)),
                  DataCell(_statusBadge(job['status']!)),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isEdit = true;
                              _showAddEditVehiclesDialog(context);
                            });
                          },
                          child: Icon(
                            Icons.edit,
                            color: appSecondaryColor.withOpacity(0.7),
                            size: 20,
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
      itemCount: vehicle.length,
      itemBuilder: (context, index) {
        final job = vehicle[index];
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
                      job["make"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "REGISTRATION NUMBER : ",
                          style: MyTextStyle.f13(
                            blackColor,
                            weight: FontWeight.bold,
                          ),
                        ),
                        Text("${job["regNo"]}"),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "MODEL : ",
                          style: MyTextStyle.f13(
                            blackColor,
                            weight: FontWeight.bold,
                          ),
                        ),
                        Text("${job["model"]}"),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "COLOR : ",
                      style: MyTextStyle.f13(
                        blackColor,
                        weight: FontWeight.bold,
                      ),
                    ),
                    Text("${job["color"]}"),
                  ],
                ),
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
                          _showAddEditVehiclesDialog(context);
                        });
                      },
                      child: Icon(
                        Icons.edit,
                        color: appSecondaryColor.withOpacity(0.7),
                        size: 20,
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
