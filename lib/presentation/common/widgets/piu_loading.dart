import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piu_util/app/config/app_typeface.dart';

class PIULoading extends StatelessWidget {
  const PIULoading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 8.h),
          Text(text, style: AppTypeFace().loading),
        ],
      ),
    );
  }
}
