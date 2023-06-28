import 'package:flutter/material.dart';

import '../index.dart';

Future<dynamic> showMyModalBottomSheet<T>({
  required BuildContext context,
  required Widget widget,
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  Color? barrierColor,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  RouteSettings? routeSettings,
  bool isUseBackground = true,
  EdgeInsets? padding,
  required bool isDarkMode,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: padding ?? const EdgeInsets.all(0),
        child: Column(children: [
          Expanded(
              child: InkWell(
            child: Container(),
            onTap: () => Navigator.pop(context),
          )),
          isUseBackground
              ? BackgroundPanel(
                  radius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  isDarkMode: isDarkMode,
                  child: widget,
                )
              : widget,
        ]),
      );
    },
    backgroundColor: backgroundColor,
    barrierColor: barrierColor,
    clipBehavior: clipBehavior,
    elevation: elevation,
    enableDrag: enableDrag,
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled,
    routeSettings: routeSettings,
    shape: shape,
    useRootNavigator: useRootNavigator,
  );
}
