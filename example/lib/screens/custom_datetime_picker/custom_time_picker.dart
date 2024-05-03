import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// DatePicker Ultra pro max
enum PickerType { hour, minute }

class CustomTimePicker extends StatefulWidget {
  final void Function(TimeOfDay selectedDate) onSelectTime;

  const CustomTimePicker({super.key, required this.onSelectTime});

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  final _hourController = FixedExtentScrollController();
  final _minuteController = FixedExtentScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int currentHour = TimeOfDay.now().hour;
      int currentMinute = TimeOfDay.now().minute;
      _hourController.animateToItem(currentHour,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
      _minuteController.animateToItem(currentMinute,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    });
    super.initState();
  }

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
        onSelectedItemChanged: (int value) => _handleSelectDate(),
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

  _getDisplayTime(int value) => value < 10 ? '0$value' : value.toString();

  _handleSelectDate() => widget.onSelectTime(TimeOfDay(
      hour: _hourController.selectedItem,
      minute: _minuteController.selectedItem));

  _getScrollController(PickerType type) =>
      type == PickerType.hour ? _hourController : _minuteController;

  _getOffAxisFraction(PickerType type) => type == PickerType.hour ? -0.5 : 0.5;
}
