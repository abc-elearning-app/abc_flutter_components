import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CustomTestData {
  final int id;
  final String title;
  final int totalQuestions;
  final int doneQuestions;
  final int time;
  final int minPassValue;
  final bool isFinished;

  CustomTestData({
    required this.id,
    required this.title,
    required this.totalQuestions,
    required this.time,
    required this.minPassValue,
    required this.doneQuestions,
    required this.isFinished,
  });
}

class CustomTestBox extends StatefulWidget {
  final Color passColor;
  final Color failColor;
  final Color mainColor;
  final Color secondaryColor;
  final String editIcon;
  final String deleteIcon;

  final bool isDarkMode;
  final bool isFinished;
  final bool isUnderSelection;
  final bool selectedAll;

  final int id;
  final String title;
  final int totalQuestions;
  final int doneQuestions;
  final int time;

  final int minPassValue;

  final void Function(int id, bool isFinished) onClick;
  final void Function(int id) onEdit;
  final void Function(int id) onDelete;
  final void Function(int id, bool isSelected) onSelect;

  const CustomTestBox({
    super.key,
    required this.passColor,
    required this.failColor,
    required this.mainColor,
    required this.isDarkMode,
    required this.minPassValue,
    required this.isFinished,
    required this.title,
    required this.totalQuestions,
    required this.doneQuestions,
    required this.time,
    required this.secondaryColor,
    required this.isUnderSelection,
    required this.editIcon,
    required this.deleteIcon,
    required this.onEdit,
    required this.onDelete,
    required this.id,
    required this.onClick,
    required this.onSelect,
    required this.selectedAll,
  });

  @override
  State<CustomTestBox> createState() => _CustomTestBoxState();
}

class _CustomTestBoxState extends State<CustomTestBox> with SingleTickerProviderStateMixin {
  TextStyle get infoTextStyle => const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic);

  bool isSwiped = false;

  late ValueNotifier<bool> isSelected;

  late AnimationController controller;
  late Animation<double> swipeAnimation;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    isSelected = ValueNotifier(false);

    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    swipeAnimation = Tween<double>(begin: 0, end: -130).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomTestBox oldWidget) {
    isSwiped = false;
    controller.reverse();
    isSelected.value = widget.selectedAll;
    widget.onSelect(widget.id, widget.selectedAll);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    isSelected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isSwiped) {
          isSwiped = !isSwiped;
          controller.reverse();
        } else if (widget.isUnderSelection) {
          isSelected.value = !isSelected.value;
          widget.onSelect(widget.id, isSelected.value);
        } else {
          widget.onClick(widget.id, widget.isFinished);
        }
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) => Stack(
          alignment: Alignment.centerRight,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Opacity(
                opacity: fadeAnimation.value,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildOptionBox(Colors.blue, widget.editIcon, widget.onEdit),
                      _buildOptionBox(Colors.red, widget.deleteIcon, widget.onDelete),
                    ],
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(swipeAnimation.value, 0),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: (widget.isFinished ? _getMainColor() : widget.secondaryColor).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircularPercentIndicator(
                      radius: 24,
                      lineWidth: 5,
                      percent: widget.doneQuestions / widget.totalQuestions,
                      animation: true,
                      progressColor: _getMainColor(),
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(((widget.doneQuestions / widget.totalQuestions) * 100).toStringAsFixed(0), style: const TextStyle(fontSize: 12)),
                          const Text('%', style: TextStyle(fontSize: 8)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Column(
                      children: [
                        Row(
                          children: [
                            Text(widget.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            if (widget.isFinished)
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                decoration: BoxDecoration(
                                  color: _getMainColor().withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Text(
                                    (widget.doneQuestions / widget.totalQuestions) >= widget.minPassValue ? 'PASSED' : 'FAILED',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: _getMainColor()),
                                  ),
                                ),
                              )
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text('${widget.doneQuestions}/${widget.totalQuestions}', style: infoTextStyle),
                            Text(' Questions  ', style: infoTextStyle.copyWith(color: Colors.grey.shade600)),
                            if (widget.time > 0) Text('${widget.time ~/ 60}', style: infoTextStyle),
                            if (widget.time > 0) Text(' Minutes', style: infoTextStyle.copyWith(color: Colors.grey.shade600)),
                          ],
                        )
                      ],
                    )),
                    widget.isUnderSelection
                        ? GestureDetector(
                            onTap: () {
                              isSelected.value = !isSelected.value;
                              widget.onSelect(widget.id, isSelected.value);
                            },
                            child: ValueListenableBuilder(
                              valueListenable: isSelected,
                              builder: (_, selected, __) => Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: selected ? widget.mainColor : Colors.transparent,
                                    border: Border.all(
                                      width: 1,
                                      color: selected ? widget.mainColor : Colors.grey,
                                    )),
                                padding: const EdgeInsets.all(2),
                                child: Icon(Icons.check, color: selected ? Colors.white : Colors.transparent, size: 18),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              if (isSwiped) {
                                controller.reverse();
                              } else {
                                controller.forward();
                              }
                              isSwiped = !isSwiped;
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.more_horiz, color: Colors.grey),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionBox(Color color, String icon, void Function(int id) action) => GestureDetector(
        onTap: () => action.call(widget.id),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color.withOpacity(0.1),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(10),
          child: IconWidget(icon: icon, color: color, height: 25),
        ),
      );

  Color _getMainColor() => widget.isFinished
      ? (widget.doneQuestions / widget.totalQuestions) * 100 >= widget.minPassValue
          ? widget.passColor
          : widget.failColor
      : widget.mainColor;
}
