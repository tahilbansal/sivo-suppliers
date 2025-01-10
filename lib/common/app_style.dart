import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle appStyle(double size, Color color, FontWeight fw) {
  double adjustedSize = size;
  // Adjust font size based on screen width
  if (ScreenUtil().screenWidth > 600) {
    adjustedSize = size * 0.45; // Reduce size for larger screens
  }
  return GoogleFonts.poppins(fontSize: adjustedSize.sp, color: color, fontWeight: fw);
}
