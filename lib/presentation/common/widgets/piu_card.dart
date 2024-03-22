import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piu_util/app/config/app_color.dart';

class PIUCard extends StatelessWidget {
  const PIUCard({super.key, required this.child, this.padding, this.margin});

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: padding ?? EdgeInsets.all(12.w),
      margin: margin ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColor.cardPrimary,
      ),
      child: child,
    );
  }
}
