import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:rivus_supplier/common/app_style.dart';
import 'package:rivus_supplier/common/reusable_text.dart';
import 'package:rivus_supplier/constants/constants.dart';
import 'package:rivus_supplier/controllers/order_controller.dart';
import 'package:rivus_supplier/controllers/tab_controller.dart';
import 'package:rivus_supplier/views/home/catalog_page.dart';
import 'package:rivus_supplier/views/home/home_page.dart';
import 'package:rivus_supplier/views/message/view.dart';
import 'package:rivus_supplier/views/order/no_selection.dart';
import 'package:rivus_supplier/views/profile/profile_page.dart';
import 'package:rivus_supplier/views/sales/sales_data.dart';


Widget activeOrder = const NoSelection();

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final controller = Get.put(OrdersController());

  final List<Widget> pageList = <Widget>[
    const CatalogPage(),
    const MessagePage(),
    const HomePage(),
    SalesData(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final entryController = Get.put(MainScreenController());

    // Handle arguments to set tab index
    final args = Get.arguments;
    if (args != null && args is int) {
      Future.delayed(const Duration(milliseconds: 50), () {
        entryController.setTabIndex = args;
      });
    } else {
      entryController.setTabIndex = 1;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800;

        return Obx(() => Scaffold(
          body: Row(
            children: [
              // Navigation for Desktop View
              if (isDesktop)
                Container(
                  width: 120, // Set a fixed width for the left navigation
                  color: kPrimary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNavItem(
                        icon: Ionicons.list_outline,
                        label: 'Catalog',
                        index: 0,
                        isSelected: entryController.tabIndex == 0,
                        onTap: () => entryController.setTabIndex = 0,
                      ),
                      _buildNavItem(
                        icon: Ionicons.chatbubble_ellipses,
                        label: 'Inbox',
                        index: 1,
                        isSelected: entryController.tabIndex == 1,
                        onTap: () => entryController.setTabIndex = 1,
                      ),
                      _buildNavItem(
                        icon: FontAwesome.truck,
                        label: 'Home',
                        index: 2,
                        isSelected: entryController.tabIndex == 2,
                        onTap: () => entryController.setTabIndex = 2,
                      ),
                      _buildNavItem(
                        icon: FontAwesome.bar_chart_o,
                        label: 'Chart',
                        index: 3,
                        isSelected: entryController.tabIndex == 3,
                        onTap: () => entryController.setTabIndex = 3,
                      ),
                      _buildNavItem(
                        icon: FontAwesome.user_circle,
                        label: 'Profile',
                        index: 4,
                        isSelected: entryController.tabIndex == 4,
                        onTap: () => entryController.setTabIndex = 4,
                      ),
                    ],
                  ),
                ),
              // Main Content
              Expanded(
                child: Stack(
                  children: [
                    pageList[entryController.tabIndex],
                    if (!isDesktop)
                    // Navigation for Mobile View
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Theme(
                          data: Theme.of(context).copyWith(canvasColor: kPrimary),
                          child: BottomNavigationBar(
                            selectedFontSize: 12,
                            elevation: 0,
                            backgroundColor: entryController.tabIndex == 1
                                ? Colors.transparent
                                : kPrimary,
                            showSelectedLabels: false,
                            showUnselectedLabels: false,
                            unselectedIconTheme:
                            const IconThemeData(color: Colors.black38),
                            items: [
                              BottomNavigationBarItem(
                                icon: _buildBadgeIcon(
                                  Ionicons.list_outline,
                                  entryController.tabIndex == 0,
                                ),
                                label: 'Catalog',
                              ),
                              BottomNavigationBarItem(
                                icon: Icon(
                                  Ionicons.chatbubble_ellipses,
                                  color: entryController.tabIndex == 1
                                      ? kSecondary
                                      : null,
                                ),
                                label: 'Inbox',
                              ),
                              BottomNavigationBarItem(
                                icon: Icon(
                                  FontAwesome.truck,
                                  color: entryController.tabIndex == 2
                                      ? kSecondary
                                      : null,
                                ),
                                label: 'Home',
                              ),
                              BottomNavigationBarItem(
                                icon: Icon(
                                  FontAwesome.bar_chart_o,
                                  color: entryController.tabIndex == 3
                                      ? kSecondary
                                      : null,
                                ),
                                label: 'Chart',
                              ),
                              BottomNavigationBarItem(
                                icon: Icon(
                                  FontAwesome.user_circle,
                                  color: entryController.tabIndex == 4
                                      ? kSecondary
                                      : null,
                                ),
                                label: 'Profile',
                              ),
                            ],
                            currentIndex: entryController.tabIndex,
                            unselectedItemColor: kGray,
                            selectedItemColor: kSecondary,
                            onTap: ((value) {
                              entryController.setTabIndex = value;
                            }),
                          ),
                        ),
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

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        height: 90,
        decoration: BoxDecoration(
          color: isSelected
              ? kSecondary // Highlighted color for selected item
              : Colors.transparent, // Transparent for unselected items
          borderRadius: BorderRadius.circular(2), // Optional for rounded edges
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black38,
              size: 28,
            ),
            const SizedBox(height: 4),
            if(!isSelected)
            Text(
              label,
              style: appStyle(10, Colors.black38, FontWeight.w600),
            ),
            if (isSelected)
              Text(
                label,
                style: appStyle(10, Colors.white, FontWeight.w600),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeIcon(IconData icon, bool isSelected) {
    return Badge(
      label: Obx(() => ReusableText(
          text: controller.count.toString(),
          style: appStyle(8, kLightWhite, FontWeight.normal))),
      child: Icon(
        icon,
        color: isSelected ? kSecondary : null,
        size: 24,
      ),
    );
  }
}
