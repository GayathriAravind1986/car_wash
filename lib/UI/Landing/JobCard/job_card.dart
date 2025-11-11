import 'package:carwash/Alertbox/snackBarAlert.dart';
import 'package:carwash/Bloc/JobCards/job_card_bloc.dart';
import 'package:carwash/ModelClass/JobCard/getAllJobCardModel.dart';
import 'package:carwash/Reusable/color.dart';
import 'package:carwash/Reusable/date_formatter.dart';
import 'package:carwash/UI/Authentication/login_screen.dart';
import 'package:carwash/UI/Landing/JobCard/add_job_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobCardsPage extends StatelessWidget {
  const JobCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JobCardBloc(),
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
  GetAllJobCardModel getAllJobCardModel = GetAllJobCardModel();
  final TextEditingController _searchController = TextEditingController();
  int currentPage = 1;
  int offset = 0;
  int limit = 10;
  bool jobLoad = false;

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
  void initState() {
    super.initState();
    context.read<JobCardBloc>().add(
      JobCardList(_searchController.text, offset.toString()),
    );
    setState(() {
      jobLoad = true;
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
              onChanged: (value) {
                _searchController
                  ..text = (value)
                  ..selection = TextSelection.collapsed(
                    offset: _searchController.text.length,
                  );
                setState(() {
                  context.read<JobCardBloc>().add(
                    JobCardList(_searchController.text, offset.toString()),
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
                OutlinedButton(
                  onPressed: currentPage > 1
                      ? () {
                          setState(() {
                            currentPage--;
                            offset = (currentPage - 1) * limit;
                          });
                          context.read<JobCardBloc>().add(
                            JobCardList(
                              _searchController.text,
                              offset.toString(),
                            ),
                          );
                        }
                      : null,
                  child: const Text("Prev"),
                ),
                Text(
                  "Showing $currentPage–${getAllJobCardModel.result?.length} of ${getAllJobCardModel.result?.length}",
                  style: const TextStyle(color: blackColor54),
                ),

                // Next button
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      currentPage++;
                      offset = (currentPage - 1) * limit;
                    });
                    context.read<JobCardBloc>().add(
                      JobCardList(_searchController.text, offset.toString()),
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
        automaticallyImplyLeading: false,
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
      body: BlocBuilder<JobCardBloc, dynamic>(
        buildWhen: ((previous, current) {
          if (current is GetAllJobCardModel) {
            getAllJobCardModel = current;
            if (getAllJobCardModel.success == true) {
              setState(() {
                jobLoad = false;
              });
            } else if (getAllJobCardModel.errorResponse != null) {
              debugPrint("Error: ${getAllJobCardModel.errorResponse?.message}");
              setState(() {
                jobLoad = false;
              });
            }
            if (getAllJobCardModel.errorResponse?.isUnauthorized == true) {
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
    return jobLoad
        ? Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
            ),
            alignment: Alignment.center,
            child: const SpinKitFadingCube(color: appPrimaryColor, size: 30),
          )
        : (getAllJobCardModel.result?.isEmpty ?? true)
        ? Center(
            child: Text(
              _searchController.text.trim().isNotEmpty
                  ? 'No records found'
                  : 'No JobCards Added yet',
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 800, // Set a wider width to allow scroll
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columnSpacing: 30,
                  headingRowColor: WidgetStateProperty.all(greyColor.shade200),
                  columns: const [
                    DataColumn(label: Text('Reg. No')),
                    DataColumn(label: Text('Total Cost')),
                    DataColumn(label: Text('Job Status')),
                    DataColumn(label: Text('Invoice Status')),
                    DataColumn(label: Text('Created')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: (getAllJobCardModel.result ?? []).map((job) {
                    return DataRow(
                      cells: [
                        DataCell(Text("${job.registrationNumber}")),
                        DataCell(Text("${job.totalCost}")),
                        DataCell(_statusBadge("${job.status}")),
                        DataCell(_statusBadge("${job.invoiceStatus}")),
                        DataCell(Text(formatDate("${job.createdAt}"))),
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
    return jobLoad
        ? Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
            ),
            alignment: Alignment.center,
            child: const SpinKitFadingCube(color: appPrimaryColor, size: 30),
          )
        : (getAllJobCardModel.result?.isEmpty ?? true)
        ? Center(
            child: Text(
              _searchController.text.trim().isNotEmpty
                  ? 'No records found'
                  : 'No JobCards Added yet',
            ),
          )
        : ListView.builder(
            itemCount: getAllJobCardModel.result!.length,
            itemBuilder: (context, index) {
              final job = getAllJobCardModel.result![index];
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
                            "${job.registrationNumber}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            formatDate("${job.createdAt}"),
                            style: const TextStyle(
                              color: greyColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text("Total Cost: ${job.totalCost}"),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text("Status: "),
                          _statusBadge("${job.status}"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text("Invoice Status: "),
                          _statusBadge("${job.invoiceStatus}"),
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
