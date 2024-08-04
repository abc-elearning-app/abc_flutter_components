import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../../flutter_abc_jsc_components.dart';
import '../../icons/icon_box.dart';

class StudyPlanBoxComponent extends StatefulWidget {
  final bool isDarkMode;
  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color segmentBackgroundColor;
  final String studyPlanLogo;

  final DateTime startDate;
  final DateTime examDate;
  final List<int> valueList;

  final int expectedQuestions;

  const StudyPlanBoxComponent({
    super.key,
    required this.isDarkMode,
    required this.backgroundColor,
    required this.mainColor,
    required this.secondaryColor,
    required this.startDate,
    required this.examDate,
    required this.valueList,
    required this.expectedQuestions,
    required this.studyPlanLogo,
    this.segmentBackgroundColor = const Color(0xFFE9E6D7),
  });

  @override
  State<StudyPlanBoxComponent> createState() => _StudyPlanBoxComponentState();
}

class _StudyPlanBoxComponentState extends State<StudyPlanBoxComponent>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<bool> _isExpanded;
  late AnimationController _animationController;
  late Animation _animation;

  // late ValueNotifier<int> _displayOption;

  @override
  void initState() {
    _isExpanded = ValueNotifier(true);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 1.5 * pi, end: pi / 2)
        .animate(_animationController);

    _animationController.forward();

    // _displayOption = ValueNotifier(0);
    super.initState();
  }

  @override
  void dispose() {
    _isExpanded.dispose();
    _animationController.dispose();

    // _displayOption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, bottom: 15, top: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: widget.isDarkMode
              ? Colors.white.withOpacity(0.3)
              : widget.backgroundColor,
          boxShadow: !widget.isDarkMode
              ? [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    spreadRadius: 2,
                  )
                ]
              : null),
      child: Column(
        children: [
          GestureDetector(
            onTap: _handleToggleExpand,
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    // Icon
                    IconBox(
                      icon: widget.studyPlanLogo,
                      iconColor: Colors.white,
                      size: 35,
                      backgroundColor: widget.secondaryColor,
                    ),

                    const SizedBox(width: 15),

                    // Title
                    Expanded(
                        child: Text(
                      'Personal Plan',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black),
                    )),

                    // Dropdown button
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.rotate(
                            angle: _animation.value,
                            child: const Icon(
                              Icons.chevron_left_rounded,
                              size: 35,
                            ));
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _isExpanded,
            builder: (_, value, __) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: value ? 290 : 0,
              decoration: BoxDecoration(
                  color:
                      widget.isDarkMode ? Colors.grey.shade900 : Colors.white,
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16))),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 5,
                    right: 5,
                  ),
                  child: StudyPlanChart(
                    key: GlobalKey(),
                    isDarkMode: widget.isDarkMode,
                    lineSectionHeight: 120,
                    barSectionHeight: 150,
                    startDate: widget.startDate,
                    examDate: widget.examDate,
                    valueList: widget.valueList,
                    expectedBarValue: widget.expectedQuestions,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildSegmentController() => Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 15),
  //       child: ValueListenableBuilder(
  //         valueListenable: _displayOption,
  //         builder: (_, value, __) => SlidingSegmentedControl<int>(
  //             padding: const EdgeInsets.all(5),
  //             backgroundColor: widget.segmentBackgroundColor,
  //             children: <int, Widget>{
  //               0: _buildSegmentButton(0, '7 Days'),
  //               1: _buildSegmentButton(1, '30 Days'),
  //               2: _buildSegmentButton(2, '90 Days'),
  //             },
  //             groupValue: value,
  //             onValueChanged: _handleSelectOptions),
  //       ),
  //     );
  //
  // Widget _buildSegmentButton(int index, String title) => Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
  //       child: Text(title,
  //           style: TextStyle(
  //               fontSize: 14,
  //               fontWeight: FontWeight.w400,
  //               color: _displayOption.value == index
  //                   ? widget.secondaryColor
  //                   : Colors.black)),
  //     );
  //
  // _handleSelectOptions(int? index) {
  //   _displayOption.value = index!;
  // }

  _handleToggleExpand() {
    if (!_isExpanded.value) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _isExpanded.value = !_isExpanded.value;
  }
}
