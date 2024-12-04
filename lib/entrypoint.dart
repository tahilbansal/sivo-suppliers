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

// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final controller = Get.put(OrdersController());

  List<Widget> pageList = <Widget>[
    const CatalogPage(),
    const MessagePage(),
    const HomePage(),
    SalesData(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final entryController = Get.put(MainScreenController());
    final controller = Get.put(OrdersController());

    // Use the argument to set tabIndex and control loading
    final args = Get.arguments;
    if (args != null && args is int) {
      Future.delayed(Duration(milliseconds: 50), () {
        entryController.setTabIndex = args;
      });
    } else {
      entryController.setTabIndex = 1;
    }

    return Obx(() => Scaffold(
          body: Stack(
            children: [
              pageList[entryController.tabIndex],
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
                          icon: entryController.tabIndex == 0
                              ? Badge(
                                  label: Obx(() => ReusableText(
                                      text: controller.count.toString(),
                                      style: appStyle(
                                          8, kLightWhite, FontWeight.normal))),
                                  child: const Icon(
                                    Ionicons.list_outline,
                                    size: 24,
                                  ))
                              : Badge(
                                  label: Obx(() => ReusableText(
                                      text: controller.count.toString(),
                                      style: appStyle(
                                          8, kLightWhite, FontWeight.normal))),
                                  child: const Icon(
                                    Ionicons.list_circle_sharp,
                                  ),
                                ),
                          label: 'Catalog',
                        ),
                        BottomNavigationBarItem(
                          icon: entryController.tabIndex == 1
                              ? const Icon(
                                  Ionicons.chatbubble_ellipses,
                                  color: kSecondary,
                                  size: 24,
                                )
                              : const Icon(Ionicons.chatbubble_ellipses),
                          label: 'Inbox',
                        ),
                        BottomNavigationBarItem(
                          icon: entryController.tabIndex == 2
                              ? const Icon(
                                  FontAwesome.truck,
                                  color: kSecondary,
                                  size: 24,
                                )
                              : const Icon(FontAwesome.truck),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: entryController.tabIndex == 3
                              ? const Icon(
                                  FontAwesome.bar_chart_o,
                                  size: 24,
                                )
                              : const Icon(
                                  FontAwesome.bar_chart_o,
                                ),
                          label: 'chart',
                        ),
                        BottomNavigationBarItem(
                          icon: entryController.tabIndex == 4
                              ? const Icon(
                                  FontAwesome.user_circle,
                                  size: 24,
                                )
                              : const Icon(
                                  FontAwesome.user_circle_o,
                                ),
                          label: 'Profile',
                        ),
                      ],
                      currentIndex: entryController.tabIndex,
                      unselectedItemColor: kGray,
                      selectedItemColor: kSecondary,
                      onTap: ((value) {
                        entryController.setTabIndex = value;
                      })),
                ),
              ),
            ],
          ),
        ));
  }
}
