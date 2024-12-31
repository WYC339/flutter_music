import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

BuildContext? loadingContext;

void showLoadingDialog(BuildContext context, {String? content}) {
  loadingContext = context;
  //content ??= "加载中";
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            backgroundColor: Colors.transparent,
            child: Container(
                height: 100.h,
                alignment: Alignment.center,
                child: Center(
                  child: content == null
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Column(children: [
                          const CircularProgressIndicator(
                              color: Colors.black),
                          SizedBox(height: 10.h),
                          Text(
                            content,
                            style: TextStyle(
                                color: Colors.black87, fontSize: 13.sp),
                          )
                        ]),
                )));
      });
}

void dismissLoadingDialog() {
  if (loadingContext != null) {
    Navigator.pop(loadingContext!);
    loadingContext = null;
  }
}
