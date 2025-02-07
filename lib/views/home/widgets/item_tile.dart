import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:sivo_suppliers/common/app_style.dart';
import 'package:sivo_suppliers/common/reusable_text.dart';
import 'package:sivo_suppliers/constants/constants.dart';
import 'package:sivo_suppliers/controllers/items_controller.dart';
import 'package:sivo_suppliers/models/items.dart';
import 'package:sivo_suppliers/views/home/widgets/delete_confirmation_dialog.dart';
import 'package:sivo_suppliers/views/item/edit_item_page.dart';

class CategoryItemTile extends StatelessWidget {
  const CategoryItemTile({
    super.key,
    required this.item,
    this.onTap,
  });

  final Item item;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 80.h,
            width: width,
            decoration: const BoxDecoration(
                color: kLightWhite,
                borderRadius: BorderRadius.all(Radius.circular(9))),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Stack(
                      children: [
                        if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                          SizedBox(
                              height: 80.h,
                              width: 80.h,
                              child: Image.network(
                                item.imageUrl![0],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const SizedBox.shrink(),
                              )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      ReusableText(
                          text: item.title,
                          style: appStyle(
                              kFontSizeBodySmall, kDark, FontWeight.w400)),
                      const SizedBox(
                        height: 2,
                      ),
                      if (item.price != null)
                        Container(
                          width: 65.h,
                          height: 24.h,
                          decoration: const BoxDecoration(
                              color: kPrimary,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                          child: Center(
                            child: ReusableText(
                              text: "\₹ ${item.price.toString()}",
                              style: appStyle(kFontSizeSubtext, kLightWhite,
                                  FontWeight.bold),
                            ),
                          ),
                        ),
                      // ReusableText(
                      //     text: "${item.price}",
                      //     style: appStyle(
                      //         kFontSizeSubtext, kGray, FontWeight.w400)),
                      const SizedBox(
                        height: 5,
                      ),
                      // SizedBox(
                      //   height: 18,
                      //   width: width * 0.68,
                      // child: ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: food.additives.length,
                      //     itemBuilder: (context, i) {
                      //       final addittives = food.additives[i];
                      //       return Container(
                      //         padding: EdgeInsets.symmetric(horizontal: 6),
                      //        // width: 60.h,
                      //         height: 19.h,
                      //         decoration: const BoxDecoration(
                      //             color: kPrimary,
                      //             borderRadius: BorderRadius.all(
                      //               Radius.circular(10),
                      //             )),
                      //         child: Center(
                      //           child: ReusableText(
                      //             text: addittives.title,
                      //             style: appStyle(kFontSizeSubtext, kLightWhite, FontWeight.bold),
                      //           ),
                      //         ),
                      //       );
                      //     }),
                      // ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
              right: 45.h,
              top: 6.h,
              child: Container(
                width: 24.h,
                height: 24.h,
                decoration: const BoxDecoration(
                    color: kSecondary,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => EditItemPage(item: item),
                        transition: Transition.native,
                        duration: const Duration(seconds: 1));
                  },
                  child: const Center(
                    child: Icon(
                      MaterialCommunityIcons.pencil,
                      size: 17,
                      color: kLightWhite,
                    ),
                  ),
                ),
              )),
          Positioned(
              right: 10.h,
              top: 6.h,
              child: Container(
                width: 24.h,
                height: 24.h,
                decoration: const BoxDecoration(
                    color: kRed,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: GestureDetector(
                  onTap: () {
                    showDeleteConfirmationDialog(
                      context: context,
                      onConfirm: () async {
                        final itemsController = Get.put(ItemsController());
                        await itemsController.deleteItem(item.id);
                      },
                    );
                  },
                  child: const Center(
                    child: Icon(
                      MaterialCommunityIcons.trash_can,
                      size: 17,
                      color: kLightWhite,
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
