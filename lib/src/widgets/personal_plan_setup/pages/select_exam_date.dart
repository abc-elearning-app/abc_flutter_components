import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/custom_datetime_picker/custom_unrestrict_date_picker.dart';

class SelectExamDatePage extends StatefulWidget {
  final String title;
  final String image;
  final Color mainColor;
  final Color secondaryColor;
  final bool isDarkMode;

  final void Function(int index) onSelectOption;
  final void Function(DateTime selectedDate) onSelectDate;

  const SelectExamDatePage({
    super.key,
    required this.title,
    required this.image,
    required this.mainColor,
    required this.isDarkMode,
    required this.secondaryColor,
    required this.onSelectDate,
    required this.onSelectOption,
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:
                            widget.isDarkMode ? Colors.white : Colors.black))),

            // Image
            Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Image.asset(widget.image, height: 280)),

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
                      child: CustomUnrestrictedDatePicker(
                        onSelectDate: widget.onSelectDate,
                      ),
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose A Date',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                  Text('Pick A Date From Calendar',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      )),
                ],
              )),

          // Skip select date option
          _selectedOptionFrame(
              index: 1,
              selectedIndex: selectedIndex,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "I Don't Know My Exam Date Yet",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              )),
        ],
      );

  // Outer frame of the options
  Widget _selectedOptionFrame({
    required int index,
    required int selectedIndex,
    required Widget child,
  }) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => _handleSelectOption(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: isSelected ? null : Border.all(color: widget.secondaryColor),
          color: isSelected ? widget.secondaryColor : Colors.white,
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
    widget.onSelectOption(index);
  }
}
