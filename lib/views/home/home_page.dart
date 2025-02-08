import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sivo_suppliers/common/app_style.dart';
import 'package:sivo_suppliers/common/custom_appbar.dart';
import 'package:sivo_suppliers/common/reusable_text.dart';
import 'package:sivo_suppliers/common/tab_widget.dart';
import 'package:sivo_suppliers/constants/constants.dart';
import 'package:sivo_suppliers/controllers/order_controller.dart';
import 'package:sivo_suppliers/controllers/supplier_controller.dart';
import 'package:sivo_suppliers/views/home/supplier_orders/cancelled_orders.dart';
import 'package:sivo_suppliers/views/home/supplier_orders/delivered.dart';
import 'package:sivo_suppliers/views/home/supplier_orders/new_orders.dart';
import 'package:sivo_suppliers/views/home/supplier_orders/preparing.dart';
import 'package:sivo_suppliers/views/home/widgets/back_ground_container.dart';

class HomePage extends StatefulHookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 4,
    vsync: this,
  );

  bool _isNavigating = false;

  void handleSupplierIdNull() {
    if (!_isNavigating) {
      _isNavigating = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: kWhite,
            title: const Text('Error'),
            content: const Text(
              'Supplier ID is null. Please set up the supplier correctly.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _isNavigating = false;
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final supplierController = Get.put(SupplierController());
    final orderController = Get.put(OrdersController());
    _tabController.animateTo(orderController.tabIndex);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: CustomAppBar(
            type: true,
            onTap: () {
              supplierController.supplierStatus();
            },
            onSupplierIdNull: handleSupplierIdNull,
          ),
          elevation: 0,
          backgroundColor: kLightWhite,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return BackGroundContainer(
              child: SizedBox(
                height: constraints.maxHeight,
                child: Column(
                  children: [
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Container(
                        height: 25.h,
                        width: constraints.maxWidth,
                        decoration: BoxDecoration(
                          color: kOffWhite,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: kPrimary,
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          labelPadding: EdgeInsets.zero,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey.withOpacity(0.7),
                          tabs: const [
                            Tab(child: TabWidget(text: "New Orders")),
                            Tab(child: TabWidget(text: "In Progress")),
                            Tab(child: TabWidget(text: "Delivered")),
                            Tab(child: TabWidget(text: "Cancelled")),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: const [
                          NewOrders(),
                          PreparingOrders(),
                          DeliveredOrders(),
                          CancelledOrders(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SivoHomeTile extends StatelessWidget {
  const SivoHomeTile({
    Key? key,
    required this.imagePath,
    required this.text,
    this.onTap,
  }) : super(key: key);

  final String imagePath;
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            imagePath,
            width: 40.w,
            height: 40.h,
          ),
          ReusableText(
            text: text,
            style: appStyle(14, kGray, FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

void showAnimatedDialog(BuildContext context, Widget dialog,
    {bool isFlip = false, bool dismissible = true}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: dismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (context, animation1, animation2) => dialog,
    transitionDuration: Duration(milliseconds: 500),
    transitionBuilder: (context, a1, a2, widget) {
      if (isFlip) {
        return Rotation3DTransition(
          alignment: Alignment.center,
          turns: Tween<double>(begin: math.pi, end: 2.0 * math.pi).animate(
              CurvedAnimation(
                  parent: a1, curve: Interval(0.0, 1.0, curve: Curves.linear))),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: a1,
                    curve: Interval(0.5, 1.0, curve: Curves.elasticOut))),
            child: widget,
          ),
        );
      } else {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      }
    },
  );
}

class Rotation3DTransition extends AnimatedWidget {
  const Rotation3DTransition({
    Key? key,
    required this.turns,
    this.alignment = Alignment.center,
    this.child,
  }) : super(key: key, listenable: turns);

  final Animation<double> turns;
  final Alignment alignment;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final double turnsValue = turns.value;
    final Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0006)
      ..rotateY(turnsValue);
    return Transform(
      transform: transform,
      alignment: FractionalOffset(0.5, 0.5),
      child: child,
    );
  }
}
