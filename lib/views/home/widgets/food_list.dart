import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rivus_supplier/common/shimmers/foodlist_shimmer.dart';
import 'package:rivus_supplier/hooks/fetchItems.dart';
import 'package:rivus_supplier/models/items.dart';
import 'package:rivus_supplier/views/food/food_page.dart';
import 'package:rivus_supplier/views/home/widgets/empty_page.dart';
import 'package:rivus_supplier/views/home/widgets/food_tile.dart';
import 'package:get/get.dart';

class FoodList extends HookWidget {
  const FoodList({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchFood();
    final foods = hookResult.data;
    final isLoading = hookResult.isLoading;

    if (isLoading) {
      return const FoodsListShimmer();
    } else if (foods!.isEmpty) {
      return const EmptyPage();
    }

    return Container(
      padding: const EdgeInsets.only(
        left: 12,
        top: 10,
        right: 12,
      ),
      height: 190.h,
      child: ListView.builder(
          itemCount: foods.length,
          itemBuilder: (context, index) {
            Item item = foods[index];
            return CategoryFoodTile(
                onTap: () {
                  Get.to(() => FoodPage(item: item),
                      transition: Transition.fadeIn,
                      duration: const Duration(milliseconds: 500));
                },
                item: item);
          }),
    );
  }
}
