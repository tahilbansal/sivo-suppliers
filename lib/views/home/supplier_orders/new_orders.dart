import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sivo_suppliers/common/shimmers/foodlist_shimmer.dart';
import 'package:sivo_suppliers/constants/constants.dart';
import 'package:sivo_suppliers/controllers/updates_controllers/new_orders_controller.dart';
import 'package:sivo_suppliers/hooks/fetchSupplierOrders.dart';
import 'package:sivo_suppliers/models/ready_orders.dart';
import 'package:sivo_suppliers/views/home/widgets/empty_page.dart';
import 'package:sivo_suppliers/views/home/widgets/order_tile.dart';
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
    useEffect(() {
      listenerSubscription = controller.triggerReload.listen((_) {
        refetch();
      });
      return () => listenerSubscription.cancel();
    }, [controller.triggerReload]);

    if (isLoading) {
      return const itemsListShimmer();
    } else if (orders == null || orders.isEmpty) {
      return const EmptyPage();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          color: Colors.transparent,
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, i) {
              final order = orders[i];
              return OrderTile(order: order, active: 'active');
            },
          ),
        );
      },
    );
  }
}
