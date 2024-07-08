import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/statistic_tab_widgets/study_activity_chart.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tuple/tuple.dart';

import '../../../icons/icon_box.dart';
import '../../../segment_control/custom_segment_control.dart';

class StudyActivityBox extends StatefulWidget {
  final bool isDarkMode;
  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color segmentBackgroundColor;

  const StudyActivityBox({
    super.key,
    required this.isDarkMode,
    required this.backgroundColor,
    required this.mainColor,
    required this.secondaryColor,
    this.segmentBackgroundColor = const Color(0xFFE9E6D7),
  });

  @override
  State<StudyActivityBox> createState() => _StudyActivityBoxState();
}

class _StudyActivityBoxState extends State<StudyActivityBox>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<bool> _isExpanded;
  late AnimationController _animationController;
  late Animation _animation;

  late ValueNotifier<int> _displayOption;

  @override
  void initState() {
    _isExpanded = ValueNotifier(false);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 0, end: pi).animate(_animationController);

    _displayOption = ValueNotifier(0);
    super.initState();
  }

  @override
  void dispose() {
    _isExpanded.dispose();
    _animationController.dispose();

    _displayOption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: widget.isDarkMode
            ? Colors.white.withOpacity(0.3)
            : widget.backgroundColor,
      ),
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
                      icon: 'assets/images/subject_icon.svg',
                      iconColor: Colors.white,
                      size: 35,
                      backgroundColor: widget.secondaryColor,
                    ),

                    const SizedBox(width: 15),

                    // Title
                    Expanded(
                        child: Text(
                      'Study Activity',
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
                          child: SvgPicture.asset(
                            'assets/images/chevron_down.svg',
                            color:
                                widget.isDarkMode ? Colors.white : Colors.black,
                            height: 10,
                          ),
                        );
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
              height: value ? 400 : 0,
              decoration: BoxDecoration(
                  color:
                      widget.isDarkMode ? Colors.grey.shade900 : Colors.white,
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Segment controller
                    _buildSegmentController(),

                    // Main chart
                    ValueListenableBuilder(
                      valueListenable: _displayOption,
                      builder: (_, option, __) {
                        return StudyActivityChart(
                          displayDays: option == 0
                              ? 7
                              : option == 1
                                  ? 30
                                  : 90,
                          dataList: const [
                            Tuple2(35, 6),
                            Tuple2(40, 8),
                            Tuple2(36, 7),
                            Tuple2(42, 8),
                            Tuple2(35, 6),
                            // Tuple2(38, 12),
                            // Tuple2(38, 12),
                          ],
                          isDarkMode: widget.isDarkMode,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentController() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: ValueListenableBuilder(
          valueListenable: _displayOption,
          builder: (_, value, __) => SlidingSegmentedControl<int>(
              padding: const EdgeInsets.all(5),
              backgroundColor: widget.segmentBackgroundColor,
              children: <int, Widget>{
                0: _buildSegmentButton(0, '7 Days'),
                1: _buildSegmentButton(1, '30 Days'),
                2: _buildSegmentButton(2, '90 Days'),
              },
              groupValue: value,
              onValueChanged: _handleSelectOptions),
        ),
      );

  Widget _buildSegmentButton(int index, String title) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Text(title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: _displayOption.value == index
                    ? widget.secondaryColor
                    : Colors.black)),
      );

  _handleSelectOptions(int? index) {
    _displayOption.value = index!;
  }

  _handleToggleExpand() {
    if (!_isExpanded.value) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _isExpanded.value = !_isExpanded.value;
  }
}
