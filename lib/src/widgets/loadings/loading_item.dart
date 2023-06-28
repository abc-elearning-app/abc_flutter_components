import 'package:flutter/material.dart';

Widget makeLoading(BuildContext context,
    {Color? color, double strokeWidth = 1.0, double? size}) {
  // MyColorScheme myColorScheme = getMyColorScheme(context);
  Color color0 = color ?? Colors.blue;
  if (size != null && size > 0) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: size,
          width: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(color0),
          ),
        ),
      ],
    );
  }
  return Center(
    child: CircularProgressIndicator(
      strokeWidth: strokeWidth,
      valueColor: AlwaysStoppedAnimation<Color>(color0),
    ),
  );
}
