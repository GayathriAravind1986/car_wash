import 'package:carwash/Alertbox/AlertDialogBox.dart';
import 'package:carwash/Reusable/color.dart';
import 'package:carwash/UI/Authentication/login_screen.dart';
import 'package:carwash/UI/Landing/Customer/customer.dart';
import 'package:carwash/UI/Landing/JobCard/job_card.dart';
import 'package:carwash/UI/Landing/Report/report.dart';
import 'package:carwash/UI/Landing/Vehicle/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoardScreen extends StatefulWidget {
  final int? selectedTab;
  const DashBoardScreen({super.key, this.selectedTab});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int selectedIndex = 0;
  dynamic firstName;
  dynamic lastName;
  dynamic role;
  final List<Map<String, dynamic>> menuItems = [
    // {'icon': Icons.dashboard, 'title': 'Dashboard'},
    {'icon': Icons.assignment, 'title': 'Job Cards'},
    //{'icon': Icons.inventory_2, 'title': 'Spare Parts'},
    //{'icon': Icons.build, 'title': 'Services'},
    {'icon': Icons.people, 'title': 'Customers'},
    {'icon': Icons.directions_car, 'title': 'Vehicles'},
    {'icon': Icons.insert_chart_outlined, 'title': 'Report'},
  ];

  final List<Map<String, dynamic>> bottomItems = [
    {'icon': Icons.person, 'title': 'Profile'},
    {'icon': Icons.location_on, 'title': 'Locations'},
    {'icon': Icons.settings, 'title': 'Settings'},
  ];
  final List<Widget> pages = const [
    JobCardsPage(),
    CustomersPage(),
    VehiclesPage(),
    ReportsPage(),
  ];
  void _onSelectMenu(int index) {
    setState(() {
      selectedIndex = index;
    });
    // Close drawer automatically on mobile
    Navigator.of(context).maybePop();
  }

  Future<void> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString("firstName");
      lastName = prefs.getString("lastName");
      role = prefs.getString("role");
    });
    debugPrint("firstName: $firstName");
    debugPrint("lastName: $lastName");
    debugPrint("role: $role");
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    if (widget.selectedTab != null) {
      selectedIndex = widget.selectedTab!;
      debugPrint("selectedTabDash:${widget.selectedTab}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTabletOrDesktop = screenWidth > 700;
    if (isTabletOrDesktop) {
      return Scaffold(
        body: Column(
          children: [
            // 🟣 Add top AppBar for tablet/desktop
            Container(
              color: appPrimaryColor.withOpacity(0.9),
              height: 60,
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.handyman, color: orangeColor),
                      SizedBox(width: 10),
                      Text(
                        "Rolex Car Workshop",
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "$firstName $lastName",
                        style: const TextStyle(
                          color: whiteColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "$role",
                        style: const TextStyle(
                          color: whiteColor70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 250,
                    color: appPrimaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //_buildHeader(),
                        const SizedBox(height: 10),
                        Expanded(child: _buildMenuList(isTabletOrDesktop)),
                        _buildLogoutButton(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: whiteColor,
                      child: pages[selectedIndex],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: appPrimaryColor.withOpacity(0.9),
          iconTheme: const IconThemeData(color: whiteColor),
          title: const Text(
            'Rolex car workshop',
            style: TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),
              child: Column(
                children: [
                  Text(
                    "$firstName $lastName",
                    style: const TextStyle(
                      color: whiteColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "$role",
                    style: const TextStyle(color: whiteColor70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: appPrimaryColor,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 10),
                Expanded(child: _buildMenuList(isTabletOrDesktop)),
                _buildLogoutButton(),
              ],
            ),
          ),
        ),
        body: Container(color: whiteColor, child: pages[selectedIndex]),
      );
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: const [
          Icon(Icons.handyman, color: orangeColor),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              'Rolex car workshop',
              style: TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(bool isTabletOrDesktop) {
    return ListView.builder(
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        final isSelected = selectedIndex == index;

        return InkWell(
          onTap: () => _onSelectMenu(index),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? appSecondaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Row(
              children: [
                Icon(item['icon'], color: isSelected ? whiteColor : greyColor),
                const SizedBox(width: 15),
                Text(
                  item['title'],
                  style: TextStyle(
                    color: isSelected ? whiteColor : greyColor,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          // Handle logout logic here
          // e.g., clear SharedPreferences and navigate to Login screen
          showLogoutDialog(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: appSecondaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: const [
              Icon(Icons.logout, color: whiteColor),
              SizedBox(width: 10),
              Text(
                'Logout',
                style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
