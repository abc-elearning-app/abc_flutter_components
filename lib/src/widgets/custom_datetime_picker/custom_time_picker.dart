import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// DatePicker Ultra pro max
enum PickerType { hour, minute }

class CustomTimePicker extends StatefulWidget {
  final void Function(DateTime selectedDate) onSelectDate;

  const CustomTimePicker({super.key, required this.onSelectDate});

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  final _hourController = FixedExtentScrollController(initialItem: 0);
  final _minuteController = FixedExtentScrollController(initialItem: 0);

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 90, child: _customCupertinoPicker(PickerType.hour)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                ' : ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
            SizedBox(
                width: 90, child: _customCupertinoPicker(PickerType.minute)),
          ],
        ),
      ),

      // Magnifier section
      IgnorePointer(
        ignoring: true,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 40,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
      )
    ]);
  }

  Widget _customCupertinoPicker(PickerType type) => CupertinoPicker(
        scrollController: _getScrollController(type),
        selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
            background: Colors.transparent),
        offAxisFraction: _getOffAxisFraction(type),
        itemExtent: 35,
        magnification: 1.2,
        diameterRatio: 2,
        squeeze: 0.9,
        onSelectedItemChanged: (int value) => _handleSelectDate(type, value),
        children: List.generate(
            type == PickerType.hour ? 24 : 59,
            (index) => Align(
                  alignment: type != PickerType.hour
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Text(
                    (type == PickerType.hour
                            ? _getDisplayTime(index)
                            : _getDisplayTime(index + 1))
                        .toString(),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                )),
      );

  _getDisplayTime(int index) {
    if (index < 10) return '0$index';
    return index;
  }

  _handleSelectDate(PickerType type, int value) {}

  _update() {
    // widget.onSelectDate(DateTime(
    //     DateTime.now().year + _yearController.selectedItem,
    //     _minuteController.selectedItem + 1,
    //     _hourController.selectedItem + 1));
  }

  _getScrollController(PickerType type) {
    switch (type) {
      case PickerType.hour:
        return _hourController;
      case PickerType.minute:
        return _minuteController;
    }
  }

  _getOffAxisFraction(PickerType type) {
    switch (type) {
      case PickerType.hour:
        return -0.5;
      case PickerType.minute:
        return 0.5;
    }
  }
}
