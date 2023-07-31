import 'package:flutter/material.dart';

class MyAppBar1 extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final Widget? leading;
  final Widget title;
  final Widget? action;
  final Color? backgroundColor;

  const MyAppBar1(
      {super.key,
      this.action,
      this.leading,
      required this.title,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
    Widget? tempLeading = leading;
    if (canPop) {
      tempLeading = useCloseButton ? const CloseButton() : const BackButton();
    }
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: kToolbarHeight,
      color: backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          tempLeading != null
              ? Container(
                  alignment: Alignment.center, width: 60, child: tempLeading)
              : const SizedBox(),
          Expanded(child: title),
          action ?? const SizedBox()
        ],
      ),
    );
  }
}
