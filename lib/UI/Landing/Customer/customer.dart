import 'package:carwash/Alertbox/snackBarAlert.dart';
import 'package:carwash/Bloc/Customer/customer_bloc.dart';
import 'package:carwash/ModelClass/Customer/getAllCustomerModel.dart';
import 'package:carwash/Reusable/color.dart';
import 'package:carwash/UI/Authentication/login_screen.dart';
import 'package:carwash/UI/Landing/Customer/add_customer.dart';
import 'package:carwash/UI/Landing/Customer/edit_customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomerBloc(),
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
  GetAllCustomerModel getAllCustomerModel = GetAllCustomerModel();
  final TextEditingController _searchController = TextEditingController();
  int offset = 0;
  int limit = 10;
  int currentPage = 1;
  bool? isEdit = false;
  bool customerLoad = false;

  Color getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return greenColor.shade100;
      case 'In-Active':
        return redColor.shade100;
      default:
        return greyColor.shade100;
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case 'Active':
        return greenColor;
      case 'In-Active':
        return redColor;
      default:
        return blackColor87;
    }
  }

  void _showAddEditCustomerDialog(BuildContext context, String? cusId) {
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
                ? EditCustomer(isTablet: isTablet, cusId: cusId.toString())
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
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(
      CustomerList(_searchController.text, offset.toString()),
    );
    setState(() {
      customerLoad = true;
    });
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
              onChanged: (value) {
                _searchController
                  ..text = (value)
                  ..selection = TextSelection.collapsed(
                    offset: _searchController.text.length,
                  );
                setState(() {
                  context.read<CustomerBloc>().add(
                    CustomerList(_searchController.text, offset.toString()),
                  );
                });
              },
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
                // Prev button
                OutlinedButton(
                  onPressed: currentPage > 1
                      ? () {
                          setState(() {
                            currentPage--;
                            offset = (currentPage - 1) * limit;
                          });
                          context.read<CustomerBloc>().add(
                            CustomerList(
                              _searchController.text,
                              offset.toString(),
                            ),
                          );
                        }
                      : null,
                  child: const Text("Prev"),
                ),
                Text(
                  "Showing $currentPage–${getAllCustomerModel.result?.items!.length} of ${getAllCustomerModel.result?.items!.length}",
                  style: const TextStyle(color: blackColor54),
                ),

                // Next button
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      currentPage++;
                      offset = (currentPage - 1) * limit;
                    });
                    context.read<CustomerBloc>().add(
                      CustomerList(_searchController.text, offset.toString()),
                    );
                  },
                  child: const Text("Next"),
                ),
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
                  _showAddEditCustomerDialog(context, "");
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
      body: BlocBuilder<CustomerBloc, dynamic>(
        buildWhen: ((previous, current) {
          if (current is GetAllCustomerModel) {
            getAllCustomerModel = current;
            if (getAllCustomerModel.success == true) {
              setState(() {
                customerLoad = false;
              });
            } else if (getAllCustomerModel.errorResponse != null) {
              debugPrint(
                "Error: ${getAllCustomerModel.errorResponse?.message}",
              );
              setState(() {
                customerLoad = false;
              });
            }
            if (getAllCustomerModel.errorResponse?.isUnauthorized == true) {
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

  // 🔹 Tablet View => DataTable Layout
  Widget _buildScrollableTable() {
    return customerLoad
        ? Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
            ),
            alignment: Alignment.center,
            child: const SpinKitFadingCube(color: appPrimaryColor, size: 30),
          )
        : (getAllCustomerModel.result?.items?.isEmpty ?? true)
        ? Center(
            child: Text(
              _searchController.text.trim().isNotEmpty
                  ? 'No records found'
                  : 'No customer Added yet',
            ),
          )
        : SingleChildScrollView(
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
                  rows: (getAllCustomerModel.result?.items ?? []).map((job) {
                    return DataRow(
                      cells: [
                        DataCell(Text("${job.firstName} ${job.lastName}")),
                        DataCell(Text("${job.phone}")),
                        DataCell(
                          _statusBadge(
                            job.isActive == true ? "Active" : "In-Active",
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isEdit = true;
                                    _showAddEditCustomerDialog(context, job.id);
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
    debugPrint("mobileViewCustomer");
    return customerLoad
        ? Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
            ),
            alignment: Alignment.center,
            child: const SpinKitFadingCube(color: appPrimaryColor, size: 30),
          )
        : (getAllCustomerModel.result?.items?.isEmpty ?? true)
        ? Center(
            child: Text(
              _searchController.text.trim().isNotEmpty
                  ? 'No records found'
                  : 'No customer Added yet',
            ),
          )
        : ListView.builder(
            itemCount: getAllCustomerModel.result?.items!.length,
            itemBuilder: (context, index) {
              final job = getAllCustomerModel.result?.items![index];
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
                            "${job?.firstName} ${job?.lastName}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text("Contact: ${job?.phone}"),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _statusBadge(
                            job?.isActive == true ? "Active" : "In-Active",
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isEdit = true;
                                _showAddEditCustomerDialog(context, job?.id);
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
