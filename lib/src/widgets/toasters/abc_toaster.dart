import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/utils/index.dart';
import 'package:flutter_abc_jsc_components/src/widgets/icons/toast_icons/toast_alert_triangle_icon.dart';
import 'package:flutter_abc_jsc_components/src/widgets/icons/toast_icons/toast_checked_icon.dart';
import 'package:flutter_abc_jsc_components/src/widgets/icons/toast_icons/toast_info_icon.dart';
import 'package:flutter_abc_jsc_components/src/widgets/icons/toast_icons/toast_warning_icon.dart';
import 'package:oktoast/oktoast.dart';

enum ABCToasterType { success, failed, warning, info }

class BottomPosition {
  final double width;

  BottomPosition({required this.width});
}

class ABCToaster {
  static void showWarningNoInternet(BuildContext context, bool darkMode) {
    String os = Platform.isIOS ? "iTunes Store!" : "Play Store!";
    AwesomeDialog(
      context: context,
      dialogBackgroundColor: darkMode ? Colors.black : Colors.white,
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      dialogType: DialogType.error,
      titleTextStyle: TextStyle(
          color: darkMode ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20),
      title: "Purchase failed!",
      descTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: darkMode ? Colors.white70 : const Color(0xFF8c8c8c)),
      desc: "No internet connection available. Cannot connect to $os",
      btnCancel: InkWell(
        onTap: () => Navigator.pop(context),
        child: Center(
            child: Text("Close",
                style: TextStyle(
                    color: darkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold))),
      ),
      btnCancelText: "Close",
    ).show();
  }

  static void showToast({
    required BuildContext context,
    required String msg,
    required ABCToasterType type,
    BottomPosition? position,
  }) {
    try {
      Color textColor = Colors.black;
      Color backgroundColor = const Color(0xFFf6f6f6);
      Widget iconWidget = ToastInfoIcon(
        color: getHexCssColor(textColor),
        width: 20,
        height: 20,
      );
      switch (type) {
        case ABCToasterType.failed:
          backgroundColor = const Color(0xFFFCE4E3);
          textColor = const Color(0xFFE31E18);
          iconWidget = ToastWarningIcon(
            color: getHexCssColor(textColor),
            width: 20,
            height: 20,
          );
          break;
        case ABCToasterType.info:
          backgroundColor = const Color(0xFFE4F0FB);
          textColor = const Color(0xFF2183DF);
          iconWidget = ToastInfoIcon(
            color: getHexCssColor(textColor),
            width: 20,
            height: 20,
          );
          break;
        case ABCToasterType.success:
          backgroundColor = const Color(0xFFEBFAF5);
          textColor = const Color(0xFF00C17C);
          iconWidget = ToastCheckedIcon(
            color: getHexCssColor(textColor),
            width: 20,
            height: 20,
          );
          break;
        case ABCToasterType.warning:
          backgroundColor = const Color(0xFFFDF8EF);
          textColor = const Color(0xFFEBAD34);
          iconWidget = ToastAlertTriangleIcon(
            color: getHexCssColor(textColor),
            width: 20,
            height: 20,
          );
          break;
        default:
      }
      Widget toast = IntrinsicWidth(
        child: Container(
          constraints: const BoxConstraints(
              // minWidth: 200,
              maxWidth: 300),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: backgroundColor,
              boxShadow: const [
                BoxShadow(
                    blurRadius: 2,
                    color: Color(0xFFE5E5E5),
                    spreadRadius: 0,
                    offset: Offset(0, 1))
              ]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              const SizedBox(width: 10),
              Expanded(
                child: Text(msg,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      );
      showToastWidget(
        Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: toast,
        ),
        position: ToastPosition.center,
        context: context,
        // position: position != null ? ToastPosition.bottom : ToastPosition.center,
        // animationBuilder: position != null ? (context, child, controller, percent) {
        //   double bottom = AdsManagement.instance.isShowAd && !AdsManagement.instance.isShowNativeAd ? 150 : 120;
        //   double left = (MediaQuery.of(context).size.width - position.width) / 2;
        //   return Stack(
        //     children: [
        //       Positioned(
        //         width: position.width,
        //         left: left,
        //         bottom: bottom,
        //         child: child
        //       ),
        //     ],
        //   );
        // } : null,
      );
    } catch (e) {
      switch (type) {
        case ABCToasterType.failed:
          showToastError(msg);
          break;
        case ABCToasterType.info:
          showToastInfo(msg);
          break;
        case ABCToasterType.success:
          showToastSuccess(msg);
          break;
        case ABCToasterType.warning:
          showToastWarning(msg);
          break;
        default:
      }
    }
  }
}
