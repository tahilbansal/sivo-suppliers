// ignore_for_file: unrelated_type_equality_checks

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:sivo_suppliers/common/app_style.dart';
import 'package:sivo_suppliers/common/custom_btn.dart';
import 'package:sivo_suppliers/common/reusable_text.dart';
import 'package:sivo_suppliers/constants/constants.dart';
import 'package:sivo_suppliers/controllers/items_controller.dart';
import 'package:sivo_suppliers/models/items.dart';
import 'package:sivo_suppliers/views/home/widgets/delete_confirmation_dialog.dart';

import 'edit_item_page.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key, required this.item});

  final Item item;

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemController = Get.put(ItemsController());

    return Scaffold(
        backgroundColor: kLightWhite,
        body: ListView(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.only(bottomRight: Radius.circular(25)),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 230.h,
                        child: PageView.builder(
                            itemCount: widget.item.imageUrl!.length,
                            controller: _pageController,
                            onPageChanged: (i) {
                              itemController.currentPage(i);
                            },
                            itemBuilder: (context, i) {
                              return Container(
                                height: 230.h,
                                width: width,
                                color: kLightWhite,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: widget.item.imageUrl![i],
                                ),
                              );
                            }),
                      ),
                      Positioned(
                        bottom: 10,
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.item.imageUrl!.length,
                              (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    margin: EdgeInsets.all(4.h),
                                    width: itemController.currentPage == index
                                        ? 10
                                        : 8,
                                    height: itemController.currentPage == index
                                        ? 10
                                        : 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: itemController.currentPage == index
                                          ? kSecondary
                                          : kGrayLight,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 40.h,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Ionicons.chevron_back_circle,
                          color: kPrimary,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 10,
                    right: 15,
                    child: CustomButton(
                        btnWidth: width / 2.9,
                        radius: 30,
                        color: kPrimary,
                        onTap: () {
                          Get.to(() => EditItemPage(item: widget.item),
                              transition: Transition.native,
                              duration: const Duration(seconds: 1));
                        },
                        text: "Edit Item"))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReusableText(
                          text: widget.item.title,
                          style: appStyle(
                              kFontSizeBodyLarge, kDark, FontWeight.w600)),
                      if (widget.item.price != null)
                        ReusableText(
                            text: "\₹ ${widget.item.price.toString()}",
                            style: appStyle(
                                kFontSizeBodyLarge, kPrimary, FontWeight.w600)),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    widget.item.description!,
                    maxLines: 8,
                    style: appStyle(kFontSizeBodySmall, kGray, FontWeight.w400),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  if (widget.item.itemTags != null)
                    ReusableText(
                        text: "Item Tags",
                        style: appStyle(
                            kFontSizeBodyLarge, kDark, FontWeight.w600)),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 15.h,
                    child: ListView.builder(
                        itemCount: widget.item.itemTags.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          final tag = widget.item.itemTags[i];
                          return Container(
                            margin: EdgeInsets.only(right: 5.h),
                            decoration: BoxDecoration(
                                color: kPrimary,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.r))),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: ReusableText(
                                    text: tag,
                                    style: appStyle(
                                        10, kLightWhite, FontWeight.w400)),
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  // ReusableText(
                  //     text: "Additives and Toppings",
                  //     style: appStyle(kFontSizeBodyLarge, kDark, FontWeight.w600)),
                  // Column(
                  //   children: List.generate(widget.item.additives.length, (i) {
                  //     final additive = widget.item.additives[i];
                  //     return CheckboxListTile(
                  //       title: RowText(
                  //           first: additive.title,
                  //           second: "\$ ${additive.price}"),
                  //       contentPadding: EdgeInsets.zero,
                  //       value: true,
                  //       dense: true,
                  //       visualDensity: VisualDensity.compact,
                  //       onChanged: (bool? newValue) {},
                  //       activeColor: kPrimary,
                  //       checkColor: Colors.white,
                  //       controlAffinity: ListTileControlAffinity.leading,
                  //       tristate: false,
                  //     );
                  //   }),
                  // ),
                  SizedBox(
                    height: 15.h,
                  ),
                  ReusableText(
                      text: "Item Type",
                      style:
                          appStyle(kFontSizeBodyLarge, kDark, FontWeight.w600)),
                  SizedBox(
                    height: 10.h,
                  ),
                  // SizedBox(
                  //   height: 19.h,
                  //   child: ListView.builder(
                  //       itemCount: widget.item.itemType.length,
                  //       scrollDirection: Axis.horizontal,
                  //       itemBuilder: (context, i) {
                  //         final tag = widget.item.itemType[i];
                  //         return Container(
                  //           padding: EdgeInsets.symmetric(horizontal: 6),
                  //           // width: 60.h,
                  //           height: 19.h,
                  //           decoration: const BoxDecoration(
                  //               color: kPrimary,
                  //               borderRadius: BorderRadius.all(
                  //                 Radius.circular(10),
                  //               )),
                  //           child: Center(
                  //             child: ReusableText(
                  //               text: tag,
                  //               style: appStyle(kFontSizeSubtext, kLightWhite, FontWeight.bold),
                  //             ),
                  //           ),
                  //         );
                  //       }),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.h),
              child: CustomButton(
                text: "D E L E T E",
                onTap: () {
                  showDeleteConfirmationDialog(
                    context: context,
                    onConfirm: () async {
                      final itemsController = Get.put(ItemsController());
                      await itemsController.deleteItem(widget.item.id);
                    },
                  );
                },
                color: kRed,
                btnHieght: 35,
              ),
            )
          ],
        ));
  }
}
