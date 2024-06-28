import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

import '../../custom_datetime_picker/custom_date_picker.dart';

class SelectExamDatePage extends StatefulWidget {
  final String title;
  final String image;
  final Color mainColor;
  final Color secondaryColor;
  final Color optionBoxFillColor;
  final bool isDarkMode;
  final Map<String, dynamic> selectedTime;

  final PageController pageController;
  final ValueNotifier<int> pageIndex;

  const SelectExamDatePage({
    super.key,
    required this.title,
    required this.image,
    required this.pageController,
    required this.mainColor,
    required this.optionBoxFillColor,
    required this.selectedTime,
    required this.pageIndex,
    required this.isDarkMode,
    required this.secondaryColor,
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
            Padding(
                padding: const EdgeInsets.all(20),
                child: Text(widget.title,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color:
                            widget.isDarkMode ? Colors.white : Colors.black))),

            // Image
            Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: IconWidget(
                    icon: widget.image,
                    height: 300)),

            // Option tile & Exam time picker
            Expanded(
              child: ValueListenableBuilder(
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
              selectedIndex: selectedIndex,
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
                        fontWeight: FontWeight.w500,
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
              selectedIndex: selectedIndex,
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
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              )),
        ],
      );

  // Outer frame of the options
  Widget _selectedOptionFrame(
      {required int index, required int selectedIndex, required Widget child}) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => _handleSelectOption(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: isSelected ? null : Border.all(color: widget.secondaryColor),
          color: isSelected ? widget.secondaryColor : widget.optionBoxFillColor,
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
  }

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
