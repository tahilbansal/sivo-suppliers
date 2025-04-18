import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sivo_suppliers/constants/constants.dart';

class BackGroundContainer extends StatelessWidget {
  const BackGroundContainer({
    super.key,
    required this.child,
    this.color,
  });

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: hieght,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0.r),
          topRight: Radius.circular(0.r),
        ),
        // image: const DecorationImage(
        //     image: AssetImage('assets/images/restaurant_bk.png'),
        //     fit: BoxFit.cover,
        //     opacity: 0.5),
      ),
      child: child,
    );
  }
}
