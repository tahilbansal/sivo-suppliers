import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sivo_suppliers/common/app_style.dart';
import 'package:sivo_suppliers/common/reusable_text.dart';
import 'package:sivo_suppliers/constants/constants.dart';

// ignore: must_be_immutable
class HomeHeading extends StatelessWidget {
  HomeHeading({super.key, required this.heading, this.supplier});

  final String heading;
  bool? supplier;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ReusableText(
                text: heading, style: appStyle(16, kDark, FontWeight.bold)),
          ),
          supplier == true || supplier != null
              ? const SizedBox.shrink()
              : const Icon(
                  AntDesign.appstore1,
                  size: 20,
                  color: kSecondary,
                )
        ],
      ),
    );
  }
}
