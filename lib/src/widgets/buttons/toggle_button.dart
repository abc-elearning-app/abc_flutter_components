import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ToggleButton extends StatefulWidget {
  final double iconSize;
  final String unselectedIcon;
  final String selectedIcon;
  final bool isSelected;
  final void Function(bool isSelected) onToggle;

  const ToggleButton(
      {super.key,
      this.iconSize = 25,
      required this.unselectedIcon,
      required this.selectedIcon,
      required this.isSelected,
      required this.onToggle});

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
          padding: const EdgeInsets.all(8),
          child: SvgPicture.asset(
            'assets/images/${isSelected ? widget.selectedIcon : widget.unselectedIcon}.svg',
            height: widget.iconSize,
          ),
        ));
  }
}
