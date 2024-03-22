import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PIUImageCard extends StatelessWidget {
  const PIUImageCard({super.key, required this.child, required this.jacketFileName});

  final Widget child;
  final String jacketFileName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(8.r),
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
          image: AssetImage('assets/jacket/$jacketFileName'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
