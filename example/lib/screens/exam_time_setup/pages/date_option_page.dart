import 'package:flutter/material.dart';

class DateOptionPage extends StatefulWidget {
  final String title;
  final Widget image;
  final Color appBarColor;
  final Color mainColor;
  final Color optionBoxFillColor;

  final PageController pageController;

  const DateOptionPage({
    super.key,
    required this.title,
    required this.image,
    required this.pageController,
    required this.appBarColor,
    required this.mainColor,
    required this.optionBoxFillColor,
  });

  @override
  State<DateOptionPage> createState() => _DateOptionPageState();
}

class _DateOptionPageState extends State<DateOptionPage> {
  final _selectedIndex = ValueNotifier<int?>(null);

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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                widget.title,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: widget.appBarColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: widget.image,
            ),
            ValueListenableBuilder(
                valueListenable: _selectedIndex,
                builder: (_, value, __) => Column(
                      children: [
                        _buildSelectedOptionFrame(
                            index: 0,
                            isSelected: value == 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Choose A Date',
                                  style: TextStyle(
                                      color: _isColorLight(value == 0
                                              ? widget.mainColor
                                              : widget.optionBoxFillColor)
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                Text('Pick A Date From Calendar',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: _isColorLight(value == 0
                                            ? widget.mainColor
                                            : widget.optionBoxFillColor)
                                            ? Colors.grey.shade700
                                            : Colors.grey.shade200)),
                              ],
                            )),
                        const SizedBox(height: 20),
                        _buildSelectedOptionFrame(
                            index: 1,
                            isSelected: value == 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "I Don't Know My Exam Date Yet",
                                style: TextStyle(
                                    color: _isColorLight(value == 1
                                        ? widget.mainColor
                                        : widget.optionBoxFillColor)
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                            )),
                      ],
                    ))
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedOptionFrame(
          {required int index,
          required bool isSelected,
          required Widget child}) =>
      GestureDetector(
        onTap: () => _handleSelectOption(index),
        child: Container(
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

    // Delay for smooth animation
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_selectedIndex.value == 0) {
        widget.pageController.nextPage(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut);
      } else {
        widget.pageController.animateToPage(3,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut);
      }
    });
  }

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
