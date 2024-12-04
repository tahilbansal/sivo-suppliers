import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rivus_supplier/common/shimmers/foodlist_shimmer.dart';
import 'package:rivus_supplier/hooks/fetchItems.dart';
import 'package:rivus_supplier/models/items.dart';
import 'package:rivus_supplier/views/home/widgets/empty_page.dart';
import 'package:rivus_supplier/views/home/widgets/item_tile.dart';
import 'package:rivus_supplier/views/item/item_page.dart';

class ItemList extends HookWidget {
  const ItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchFood();
    final items = hookResult.data;
    final isLoading = hookResult.isLoading;

    if (isLoading) {
      return const itemsListShimmer();
    } else if (items!.isEmpty) {
      return const EmptyPage();
    }

    return Container(
      padding: const EdgeInsets.only(
        left: 12,
        top: 10,
        right: 12,
      ),
      height: 200.h,
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            Item item = items[index];
            return CategoryItemTile(
                onTap: () {
                  Get.to(() => ItemPage(item: item),
                      transition: Transition.fadeIn,
                      duration: const Duration(milliseconds: 500));
                },
                item: item);
          }),
    );
  }
}
