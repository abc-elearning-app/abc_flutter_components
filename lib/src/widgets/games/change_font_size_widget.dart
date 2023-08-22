import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

import '../../../models/constraints.dart';

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
              borderRadius: BorderRadius.circular(6.0),
            ),
            inactiveTrackBarHeight: 6,
          ),
          handler: FlutterSliderHandler(
              child: ValueListenableBuilder(
            valueListenable: fontSize,
            builder: (_, value, child) => Text(
              (fontSize.value / CONFIG_FONT_SIZE_DEFAULT).toStringAsFixed(1),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.brightness ==
                          Brightness.dark
                      ? Colors.black
                      : Theme.of(context).colorScheme.primary),
            ),
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
