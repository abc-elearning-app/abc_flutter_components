import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

const CONFIG_FONT_SIZE_DEFAULT = 15;

void showChangeFontSizeDialog({
  required BuildContext context,
  required VoidCallback firebaseCallBack,
  required ValueNotifier<double> fontSize,
  required Function(double) onChangeFinished,
}) {
  firebaseCallBack.call();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      insetPadding: const EdgeInsets.all(24),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      title: Text(
        "Change Font Size",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      content: ChangeFontSizeWidget(
        fontSize: fontSize,
        onChangeFinished: onChangeFinished,
      ),
    ),
  );
}

// class ChangeFontSizeIcon extends StatelessWidget {
//   const ChangeFontSizeIcon({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         child: Container(
//           margin: const EdgeInsets.only(right: 12),
//           padding: const EdgeInsets.all(4),
//           alignment: Alignment.center,
//           child: SvgPicture.asset(
//             "assets/static/alpha_icon.svg",
//             width: 24,
//             color: Theme.of(context).colorScheme.brightness == Brightness.dark
//                 ? Colors.white
//                 : const Color(0xFF0C1827),
//           ),
//         ),
//         onTap: () {
//           showModalBottomSheet(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             context: context,
//             builder: (context) {
//               return SafeArea(
//                 child: Container(
//                   color: Colors.white,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.only(top: 8, bottom: 4),
//                         child: Text("Change Font Size",
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.black.withOpacity(0.52))),
//                       ),
//                       const ChangeFontSizeWidget(),
//                       SizedBox(
//                         width: double.infinity,
//                         child: MainButton(
//                           backgroundColor: Colors.white,
//                           title: "Cancel",
//                           borderSize: BorderSide.none,
//                           textColor: Colors.black,
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         });
//   }
// }

class ChangeFontSizeWidget extends StatelessWidget {
  final ValueNotifier<double> fontSize;
  final Function(double) onChangeFinished;

  const ChangeFontSizeWidget({
    super.key,
    required this.fontSize,
    required this.onChangeFinished,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).popupMenuTheme.textStyle;
    int x = fontSize.value ~/ CONFIG_FONT_SIZE_DEFAULT;
    double y = fontSize.value % CONFIG_FONT_SIZE_DEFAULT;
    if (x == 0 && y > 0) {
      y = 10 - (CONFIG_FONT_SIZE_DEFAULT - fontSize.value);
    }
    if (y >= 10) {
      x += 1;
      y = y - 10;
    }
    return Container(
        width: 300,
        height: 40,
        margin: const EdgeInsets.only(bottom: 20),
        child: FlutterSlider(
          handlerWidth: 30,
          handlerHeight: 30,
          tooltip: FlutterSliderTooltip(disabled: true),
          trackBar: FlutterSliderTrackBar(
            activeTrackBarHeight: 6,
            activeTrackBar: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: Theme.of(context).colorScheme.primary,
            ),
            inactiveTrackBar: BoxDecoration(
              color: textStyle?.color?.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6.0),
            ),
            inactiveTrackBarHeight: 6,
          ),
          handler: FlutterSliderHandler(
              child: Text(
            "$x.${y.round()}",
            style: textStyle?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color:
                    Theme.of(context).colorScheme.brightness == Brightness.dark
                        ? Colors.black
                        : Theme.of(context).colorScheme.primary),
          )),
          selectByTap: true,
          values: [fontSize.value],
          min: 14,
          max: 30,
          onDragCompleted: (int handlerIndex, lowerValue, upperValue) {
            fontSize.value = lowerValue as double;
            onChangeFinished.call(fontSize.value);
          },
          onDragging: (int handlerIndex, lowerValue, upperValue) {
            fontSize.value = lowerValue as double;
            onChangeFinished.call(fontSize.value);
          },
        ));
  }
}
