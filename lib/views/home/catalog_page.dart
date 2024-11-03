import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rivus_supplier/common/common_appbar.dart';
import 'package:rivus_supplier/common/custom_appbar.dart';
import 'package:rivus_supplier/constants/constants.dart';
import 'package:rivus_supplier/views/home/widgets/back_ground_container.dart';
import 'package:rivus_supplier/views/home/widgets/food_list.dart';

import 'add_foods.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightWhite,
      appBar: CommonAppBar(titleText: "Catalog") ,
      // appBar :AppBar(
      //   automaticallyImplyLeading: false,
      //   flexibleSpace: CustomAppBar(
      //     title: "View all foods in your supplier and edit to ad information",
      //     heading: "Welcome to Foodly",
      //   ),
      //   elevation: 0,
      //   backgroundColor: kLightWhite,
      // ),
      body: Column(
        children: [
          // Add tile at the top with a plus icon
          ListTile(
            leading: const Icon(Icons.add, color: Colors.white),
            title: const Text(
              "Add Item",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            tileColor: kSecondary, // Customize tile color
            onTap: () {
              Get.to(() => const AddFoodsPage(),
                  transition: Transition.fadeIn,
                  duration: const Duration(milliseconds: 500));
            },
          ),
          const SizedBox(height: 10), // Spacing between the tile and the food list

          // Wrap the FoodList inside the BackGroundContainer
          const Expanded(
            child: BackGroundContainer(
              child: FoodList(),
            ),
          ),
        ],
      ),
    );
  }
}