import 'package:flutter/material.dart';
import 'package:sivo_suppliers/common/common_appbar.dart';
import 'package:sivo_suppliers/common/custom_appbar.dart';
import 'package:sivo_suppliers/constants/constants.dart';
import 'package:sivo_suppliers/views/home/supplier_orders/self_deliveries.dart';
import 'package:sivo_suppliers/views/home/widgets/back_ground_container.dart';

class SelfDeliveredPage extends StatelessWidget {
  const SelfDeliveredPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightWhite,
      appBar: CommonAppBar(titleText: "Self delivery orders"),
      /*AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: CustomAppBar(
          title: "View all internal deliveries and delivery earnings",
          heading: "Welcome Sivo",
        ),
        elevation: 0,
        backgroundColor: kLightWhite,
      ),*/
      body: const BackGroundContainer(child: SelfDeliveries()),
    );
  }
}
