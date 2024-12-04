import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rivus_supplier/common/shimmers/foodlist_shimmer.dart';
import 'package:rivus_supplier/constants/constants.dart';
import 'package:rivus_supplier/controllers/updates_controllers/new_orders_controller.dart';
import 'package:rivus_supplier/hooks/fetchSupplierOrders.dart';
import 'package:rivus_supplier/models/ready_orders.dart';
import 'package:rivus_supplier/views/home/widgets/empty_page.dart';
import 'package:rivus_supplier/views/home/widgets/order_tile.dart';
import 'package:get/get.dart';

class NewOrders extends HookWidget {
  const NewOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewOrdersController());
    final hookResult = useFetchPicked("placed");
    List<ReadyOrders>? orders = hookResult.data;
    final isLoading = hookResult.isLoading;
    final refetch = hookResult.refetch;
    late final StreamSubscription listenerSubscription;

    controller.setOnStatusChangeCallback(refetch);
    //reload if there is new notifications on order page
    // Register the listener to refetch on triggerReload
    useEffect(() {
      listenerSubscription = controller.triggerReload.listen((_) {
        refetch();
      });

      // Cleanup function to dispose of the listener
      return () {
        //controller.dispose();
        listenerSubscription.cancel();
      };
    }, [controller.triggerReload]);

    if (isLoading) {
      return const itemsListShimmer();
    } else if (orders == null) {
      return const EmptyPage();
    }

    return Container(
      height: hieght / 1.3,
      width: width,
      color: Colors.transparent,
      child: ListView.builder(
          padding: EdgeInsets.only(top: 10.h, left: 12.w, right: 12.w),
          itemCount: orders.length,
          itemBuilder: (context, i) {
            ReadyOrders order = orders[i];
            return OrderTile(order: order, active: 'active');
          }),
    );
  }
}
