import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../styles/colors/color_manager.dart';

customToast({
      required String title,
      required Color color
    })
{
  Fluttertoast.showToast(
      msg: title,
      textColor: ColorManager.whiteColor,
      backgroundColor: color,
      gravity: ToastGravity.BOTTOM
  );

}
