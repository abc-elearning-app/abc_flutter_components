import 'package:flutter/material.dart';

import '../../custom_datetime_picker/custom_date_picker.dart';

class SelectExamDatePage extends StatefulWidget {
  final String title;
  final Widget image;
  final Color appBarColor;
  final Color mainColor;
  final Color optionBoxFillColor;
  final bool showBackButton;
  final Map<String, dynamic> selectedTime;

  final PageController pageController;
  final ValueNotifier<int> pageIndex;

  const SelectExamDatePage({
    super.key,
    required this.title,
    required this.image,
    required this.pageController,
    required this.appBarColor,
    required this.mainColor,
    required this.optionBoxFillColor,
    required this.selectedTime,
    required this.pageIndex,
    required this.showBackButton,
  });

  @override
  State<SelectExamDatePage> createState() => _SelectExamDatePageState();
}

class _SelectExamDatePageState extends State<SelectExamDatePage> {
  final _selectedIndex = ValueNotifier<int>(-1);

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Title
            Stack(alignment: Alignment.center, children: [
              if (widget.showBackButton)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 30,
                      )),
                ),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(widget.title,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: widget.appBarColor))),
            ]),

            // Image
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: widget.image),

            // Option tile & Exam time picker
            ValueListenableBuilder(
              valueListenable: _selectedIndex,
              builder: (_, selectedIndex, __) => AnimatedCrossFade(
                  crossFadeState: selectedIndex != 0
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 200),
                  firstChild: _buildOptions(selectedIndex),
                  secondChild: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: CustomDatePicker(
                        onSelectDate: (selectedDate) =>
                            widget.selectedTime['exam_date'] =
                                selectedDate.toIso8601String()),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions(int selectedIndex) => Column(
        children: [
          // Select exam date option
          _selectedOptionFrame(
              index: 0,
              isSelected: selectedIndex == 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose A Date',
                    style: TextStyle(
                        color: _isColorLight(selectedIndex == 0
                                ? widget.mainColor
                                : widget.optionBoxFillColor)
                            ? Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  Text('Pick A Date From Calendar',
                      style: TextStyle(
                        color: _isColorLight(selectedIndex == 0
                                ? widget.mainColor
                                : widget.optionBoxFillColor)
                            ? Colors.black
                            : Colors.white,
                        fontSize: 15,
                      )),
                ],
              )),

          // Skip select date option
          _selectedOptionFrame(
              index: 1,
              isSelected: selectedIndex == 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "I Don't Know My Exam Date Yet",
                  style: TextStyle(
                      color: _isColorLight(selectedIndex == 1
                              ? widget.mainColor
                              : widget.optionBoxFillColor)
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
              )),
        ],
      );

  // Outer frame of the options
  Widget _selectedOptionFrame(
          {required int index,
          required bool isSelected,
          required Widget child}) =>
      GestureDetector(
        onTap: () => _handleSelectOption(index),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: isSelected
                ? null
                : Border.all(width: 1, color: widget.mainColor),
            color: isSelected ? widget.mainColor : widget.optionBoxFillColor,
          ),
          child: Row(
            children: [
              Expanded(child: child),
              CircleAvatar(
                radius: 12,
                backgroundColor: isSelected ? Colors.white : Colors.grey,
                child: CircleAvatar(
                  radius: isSelected ? 5 : 11,
                  backgroundColor: isSelected ? widget.mainColor : Colors.white,
                ),
              )
            ],
          ),
        ),
      );

  _handleSelectOption(int index) {
    _selectedIndex.value = index;

    if (_selectedIndex.value == 0) {
      widget.pageIndex.value = 0;
    } else {
      // Delay for smoother animation
      Future.delayed(const Duration(milliseconds: 200), () {
        widget.pageController.animateToPage(2,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut);
      });
    }
  }

  // Utils to change text color when
  _isColorLight(Color color) {
    // Normalize the RGB components to 0-1 range
    final r = color.red / 255.0;
    final g = color.green / 255.0;
    final b = color.blue / 255.0;

    // Calculate luminance using the WCAG formula
    final luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b;

    return luminance > 0.8;
  }
}
