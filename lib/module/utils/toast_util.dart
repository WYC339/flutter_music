import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static void show(String message, {bool isLong = false}) {
    Fluttertoast.showToast(
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      msg: message,
      toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
