import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ToggleButton extends StatefulWidget {
  final double iconSize;
  final String unselectedIcon;
  final String selectedIcon;
  final bool isSelected;
  final Color color;
  final void Function(bool isSelected) onToggle;

  const ToggleButton(
      {super.key,
      this.iconSize = 25,
      required this.unselectedIcon,
      required this.selectedIcon,
      required this.isSelected,
      required this.onToggle,
      required this.color});

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  late bool isSelected;

  @override
  void initState() {
    isSelected = widget.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => setState(() {
              isSelected = !isSelected;
              widget.onToggle(isSelected);
            }),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: isSelected
              ? SvgPicture.asset(
                  widget.selectedIcon,
                  height: widget.iconSize,
                )
              : SvgPicture.asset(
                  widget.unselectedIcon,
                  height: widget.iconSize,
                  colorFilter: ColorFilter.mode(widget.color, BlendMode.srcIn),
                ),
        ));
  }
}
