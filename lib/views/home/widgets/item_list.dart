import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sivo_suppliers/common/shimmers/foodlist_shimmer.dart';
import 'package:sivo_suppliers/hooks/fetchItems.dart';
import 'package:sivo_suppliers/models/items.dart';
import 'package:sivo_suppliers/views/home/widgets/empty_page.dart';
import 'package:sivo_suppliers/views/home/widgets/item_tile.dart';
import 'package:sivo_suppliers/views/item/item_page.dart';

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

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: items.length,
      itemBuilder: (context, index) {
        Item item = items[index];
        return CategoryItemTile(
          onTap: () {
            Get.to(() => ItemPage(item: item),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 500));
          },
          item: item,
        );
      },
    );
  }
}

