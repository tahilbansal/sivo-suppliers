import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rivus_supplier/constants/constants.dart';
import 'package:rivus_supplier/controllers/supplier_controller.dart';
import 'package:rivus_supplier/views/home/widgets/back_ground_container.dart';
import 'package:rivus_supplier/views/home/widgets/item_list.dart';
import 'package:rivus_supplier/views/item/add_items_csv.dart';

import '../item/add_items.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final supplierController = Get.put(SupplierController());
    supplierController.setPriceVisibility = box.read('price_visibility');

    return Scaffold(
      backgroundColor: kLightWhite,
      appBar: AppBar(
        title: const Text("Catalog"),
        backgroundColor: kPrimary,
        actions: [
          Obx(() =>
              Row(
                children: [
                  const Text(
                    "Show Prices",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Switch(
                    value: supplierController.priceVisibility,
                    onChanged: (value) {
                      supplierController.supplierPriceVisibility();
                    },
                    activeColor: kSecondary,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey.shade300,
                  ),
                ],
              )),
        ],
      ),
      //appBar: CommonAppBar(titleText: "Catalog") ,
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
              Get.to(() => const AddItemsPage(),
                  transition: Transition.fadeIn,
                  duration: const Duration(milliseconds: 500));
            },
          ),
          const SizedBox(
              height: 5),
          ListTile(
            leading: const Icon(Icons.add, color: Colors.white),
            title: const Text(
              "Add Bulk Items Through CSV",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            tileColor: kSecondary, // Customize tile color
            onTap: () {
              Get.to(() => FileUploadPage(),
                  transition: Transition.fadeIn,
                  duration: const Duration(milliseconds: 500));
            },
          ),
          const SizedBox(
              height: 10),
          // Wrap the ItemList inside the BackGroundContainer
          const Expanded(
            child: BackGroundContainer(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: ItemList(),
                )),
          )
        ],
      ),
    );
  }
}
