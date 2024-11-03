import 'package:flutter/material.dart';
import 'package:rivus_supplier/common/common_appbar.dart';
import 'package:rivus_supplier/common/custom_appbar.dart';
import 'package:rivus_supplier/constants/constants.dart';
import 'package:rivus_supplier/views/home/supplier_orders/self_deliveries.dart';
import 'package:rivus_supplier/views/home/widgets/back_ground_container.dart';

class SelfDeliveredPage extends StatelessWidget {
  const SelfDeliveredPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightWhite,
      appBar: CommonAppBar(titleText: "Self delivery orders"), /*AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: CustomAppBar(
          title: "View all internal deliveries and delivery earnings",
          heading: "Welcome Foodly",
        ),
        elevation: 0,
        backgroundColor: kLightWhite,
      ),*/
      body: const BackGroundContainer(child: SelfDeliveries()),
    );
  }
}
