import 'package:carwash/Bloc/demo/demo_bloc.dart';
import 'package:carwash/Reusable/color.dart';
import 'package:carwash/UI/Landing/JobCard/add_job_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobCardsPage extends StatelessWidget {
  const JobCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const JobCardsPageView(),
    );
  }
}

class JobCardsPageView extends StatefulWidget {
  const JobCardsPageView({super.key});

  @override
  State<JobCardsPageView> createState() => _JobCardsPageViewState();
}

class _JobCardsPageViewState extends State<JobCardsPageView> {
  final TextEditingController _searchController = TextEditingController();
  int currentPage = 1;

  final List<Map<String, dynamic>> jobCards = [
    {
      "regNo": "TN76BY8986",
      "totalCost": "₹500.00",
      "jobStatus": "pending",
      "invoiceStatus": "paid",
      "created": "30/10/2025",
    },
    {
      "regNo": "TN76BY8986",
      "totalCost": "₹12500.00",
      "jobStatus": "pending",
      "invoiceStatus": "partially-paid",
      "created": "30/10/2025",
    },
    {
      "regNo": "TN-51-MP-1208",
      "totalCost": "₹650.00",
      "jobStatus": "pending",
      "invoiceStatus": "paid",
      "created": "28/10/2025",
    },
    {
      "regNo": "TN-51-MP-1208",
      "totalCost": "₹150.00",
      "jobStatus": "in-progress",
      "invoiceStatus": "paid",
      "created": "28/10/2025",
    },
    {
      "regNo": "TN-51-MP-1208",
      "totalCost": "₹150.00",
      "jobStatus": "in-progress",
      "invoiceStatus": "paid",
      "created": "28/10/2025",
    },
    {
      "regNo": "TN-51-MP-1208",
      "totalCost": "₹150.00",
      "jobStatus": "in-progress",
      "invoiceStatus": "paid",
      "created": "28/10/2025",
    },
    {
      "regNo": "TN-51-MP-1208",
      "totalCost": "₹150.00",
      "jobStatus": "in-progress",
      "invoiceStatus": "paid",
      "created": "28/10/2025",
    },
    {
      "regNo": "TN-51-MP-1208",
      "totalCost": "₹150.00",
      "jobStatus": "in-progress",
      "invoiceStatus": "paid",
      "created": "28/10/2025",
    },
    {
      "regNo": "TN-51-MP-1208",
      "totalCost": "₹150.00",
      "jobStatus": "in-progress",
      "invoiceStatus": "paid",
      "created": "28/10/2025",
    },
    {
      "regNo": "TN-51-MP-1208",
      "totalCost": "₹150.00",
      "jobStatus": "in-progress",
      "invoiceStatus": "paid",
      "created": "28/10/2025",
    },
    {
      "regNo": "TN-51-MP-1208",
      "totalCost": "₹150.00",
      "jobStatus": "in-progress",
      "invoiceStatus": "paid",
      "created": "28/10/2025",
    },
    {
      "regNo": "TN-51-MP-1208",
      "totalCost": "₹150.00",
      "jobStatus": "in-progress",
      "invoiceStatus": "paid",
      "created": "28/10/2025",
    },
    {
      "regNo": "TN-51-MP-1208",
      "totalCost": "₹150.00",
      "jobStatus": "in-progress",
      "invoiceStatus": "paid",
      "created": "28/10/2025",
    },
    {
      "regNo": "TN-51-MP-1208",
      "totalCost": "₹150.00",
      "jobStatus": "in-progress",
      "invoiceStatus": "paid",
      "created": "28/10/2025",
    },
    {
      "regNo": "TN-51-MP-1208",
      "totalCost": "₹150.00",
      "jobStatus": "in-progress",
      "invoiceStatus": "paid",
      "created": "28/10/2025",
    },
    {
      "regNo": "TN-51-MP-1208",
      "totalCost": "₹150.00",
      "jobStatus": "in-progress",
      "invoiceStatus": "paid",
      "created": "28/10/2025",
    },
    {
      "regNo": "TN-51-MP-1208",
      "totalCost": "₹150.00",
      "jobStatus": "in-progress",
      "invoiceStatus": "paid",
      "created": "28/10/2025",
    },
  ];

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return greenColor.shade100;
      case 'partially-paid':
        return yellowColor.shade100;
      case 'pending':
        return greyColor.shade200;
      case 'in-progress':
        return amberColor.shade100;
      default:
        return greyColor.shade100;
    }
  }

  Color getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return greenColor.shade700;
      case 'partially-paid':
        return orangeColor.shade700;
      case 'pending':
        return greyColor.shade700;
      case 'in-progress':
        return amberColor.shade700;
      default:
        return blackColor87;
    }
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
                hintText: "Search by vehicle reg no...",
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
                  "Showing 1–${jobCards.length} of ${jobCards.length}",
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
          "Job Cards",
          style: TextStyle(color: blackColor87, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddJobCard(isTablet: isTablet),
                  ),
                );
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
                "Add Job Card",
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
              DataColumn(label: Text('Reg. No')),
              DataColumn(label: Text('Total Cost')),
              DataColumn(label: Text('Job Status')),
              DataColumn(label: Text('Invoice Status')),
              DataColumn(label: Text('Created')),
              DataColumn(label: Text('Actions')),
            ],
            rows: jobCards.map((job) {
              return DataRow(
                cells: [
                  DataCell(Text(job['regNo']!)),
                  DataCell(Text(job['totalCost']!)),
                  DataCell(_statusBadge(job['jobStatus']!)),
                  DataCell(_statusBadge(job['invoiceStatus']!)),
                  DataCell(Text(job['created']!)),
                  DataCell(
                    Row(
                      children: [
                        Icon(
                          Icons.edit,
                          color: appSecondaryColor.withOpacity(0.7),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.print,
                          color: appSecondaryColor.withOpacity(0.7),
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
      itemCount: jobCards.length,
      itemBuilder: (context, index) {
        final job = jobCards[index];
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
                      job["regNo"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      job["created"],
                      style: const TextStyle(color: greyColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text("Total Cost: ${job["totalCost"]}"),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _statusBadge(job["jobStatus"]),
                    const SizedBox(width: 6),
                    _statusBadge(job["invoiceStatus"]),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.edit,
                      color: appSecondaryColor.withOpacity(0.7),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.print,
                      color: appSecondaryColor.withOpacity(0.7),
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
