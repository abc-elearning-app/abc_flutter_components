import 'package:flutter/material.dart';

import '../../../flutter_abc_jsc_components.dart';


class MenuItem {
  const MenuItem({
    required this.id,
    required this.title,
    required this.icon,
    this.appName,
    this.package,
    this.iconURL,
    this.isLabel = true,
  });

  final int id;
  final String title;
  final IconData icon;
  final String? package;
  final String? appName;
  final String? iconURL;
  final bool isLabel;
}

PopupMenuButton<MenuItem> makeGamePopupMenuItem({
  required bool bookmark,
  required BuildContext context,
  Function? bookmarkQuestion,
  Function? showReportMistake,
  bool showOnlyChangeFont = false,
  required ValueNotifier<double> fontSize,
  required Function(double) onChangeFontSizeFinished,
}) {
  return PopupMenuButton<MenuItem>(
      icon: const Icon(Icons.more_vert),
      onSelected: (item) {
        if (item.id == 1) {
          if (bookmarkQuestion != null) {
            bookmarkQuestion();
          }
        } else if (item.id == 2) {
          if (showReportMistake != null) {
            showReportMistake();
          }
        }
      },
      itemBuilder: (BuildContext context) {
        List<PopupMenuItem<MenuItem>> items = [];
        if (!showOnlyChangeFont) {
          _getMenuItems(context, bookmark: bookmark).forEach((item) {
            Color? color = Theme.of(context).popupMenuTheme.textStyle?.color;
            Widget leading = Icon(item.icon, color: color);
            items.add(PopupMenuItem<MenuItem>(
                value: item,
                child: ListTile(
                  leading: leading,
                  title: Text(
                    item.title,
                    style: Theme.of(context).popupMenuTheme.textStyle,
                  ),
                )));
          });
        }
        items.add(
          makeChangeFontSizeWidget(
            context,
            showHr: !showOnlyChangeFont,
            fontSize: fontSize,
            onChangeFinished: onChangeFontSizeFinished,
          ),
        );
        return items;
      });
}

List<MenuItem> _getMenuItems(BuildContext context, {required bool bookmark}) {
  List<MenuItem> result = [];
  result = <MenuItem>[
    MenuItem(
        id: 1,
        title: AppStrings.menuStrings.addToFavorites,
        icon: bookmark ? Icons.favorite : Icons.favorite_border),
    MenuItem(
        id: 2, title: AppStrings.menuStrings.reportMistake, icon: Icons.report),
  ];
  return result;
}

PopupMenuItem<MenuItem> makeChangeFontSizeWidget(BuildContext context,
    {bool showHr = true,
    required ValueNotifier<double> fontSize,
    required Function(double) onChangeFinished}) {
  return PopupMenuItem<MenuItem>(
    enabled: false,
    height: 30,
    child: Column(
      children: <Widget>[
        showHr
            ? Container(
                height: 1,
                width: double.infinity,
                color: Theme.of(context).popupMenuTheme.textStyle?.color,
                margin: const EdgeInsets.only(bottom: 20, top: 10))
            : const SizedBox(),
        Text(
          AppStrings.menuStrings.fontSize,
          style: Theme.of(context).popupMenuTheme.textStyle,
        ),
        ChangeFontSizeWidget(
          fontSize: fontSize,
          onChangeFinished: onChangeFinished,
        ),
      ],
    ),
  );
}
