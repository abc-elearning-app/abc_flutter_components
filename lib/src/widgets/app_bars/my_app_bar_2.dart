import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/menus/menu_item.dart';

class MyAppBar2 extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar2({
    super.key,
    this.titlePanel,
    this.backButton,
    this.elevation = 3,
    this.color,
    this.gradientColor,
    this.popupMenuButton,
    this.bottomPanel,
    this.backEvent,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  final Widget? titlePanel;
  final Icon? backButton;
  final Color? color;
  final Color? gradientColor;
  final PopupMenuButton<MenuItem>? popupMenuButton;
  final double? elevation;
  final Widget? bottomPanel;
  final Function? backEvent;

  @override
  final Size preferredSize; // default is 56.0

  @override
  State<MyAppBar2> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar2> {
  @override
  Widget build(BuildContext context) {
    IconButton? backIconButton;
    if (widget.backButton != null) {
      backIconButton = IconButton(
          icon: widget.backButton!,
          onPressed: () {
            if (widget.backEvent != null) {
              widget.backEvent!();
            } else {
              Navigator.of(context).pop();
            }
          });
    }
    Color? c = widget.color;
    c ??= Colors.blue;
    return AppBar(
      elevation: widget.elevation,
      leading: backIconButton,
      title: widget.titlePanel,
      actions: widget.popupMenuButton != null ? [widget.popupMenuButton!] : [],
      backgroundColor: c,
    );
  }
}
