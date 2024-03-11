import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piu_util/app/config/app_color.dart';
import 'package:piu_util/oss_licenses.dart';

class LicencesPage extends StatelessWidget {
  const LicencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.bg,
        title: const Text("Open Source Licences"),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: ossLicenses.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: EdgeInsets.all(8.w),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.cardPrimary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => LicenceDetailPage(
                        title: ossLicenses[index].name[0].toUpperCase() + ossLicenses[index].name.substring(1),
                        licence: ossLicenses[index].license!,
                      ),
                    ),
                  );
                },
                title: Text(ossLicenses[index].name[0].toUpperCase() + ossLicenses[index].name.substring(1)),
                subtitle: Text(ossLicenses[index].description),
              ),
            ),
          );
        },
      ),
    );
  }
}

//detail page for the licence
class LicenceDetailPage extends StatelessWidget {
  final String title, licence;
  const LicenceDetailPage({super.key, required this.title, required this.licence});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(title),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(color: AppColor.cardPrimary, borderRadius: BorderRadius.circular(8.r)),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Text(
                    licence,
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
