import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/games/change_font_size_widget.dart';
import 'package:whale/components/change_font_size_widget.dart';
import 'package:whale/generated/locale_keys.g.dart';

enum MenuItemGame {
  BOOKMARK, REPORT_MISTAKE, FINISH_TEST
}

class MenuItem {
  const MenuItem({ this.id,this.title, this.icon, this.appName, this.package, this.iconURL, this.isLabel = true });
  final int id;
  final String title;
  final IconData icon;
  final String package;
  final String appName;
  final String iconURL;
  final bool isLabel;
}

PopupMenuButton<MenuItem> makeGamePopupMenuItem({bool bookmark, BuildContext context, Function bookmarkQuestion, Function showReportMistake, bool showOnlyChangeFont = false}) {
  return PopupMenuButton<MenuItem>(
      icon: Icon(Icons.more_vert),
      onSelected: (item) {
        if(item.id == 1) {
          if(bookmarkQuestion != null){
            bookmarkQuestion();
          }
        } else if(item.id == 2) {
          if(showReportMistake != null){
            showReportMistake();
          }
        }
      },
      itemBuilder: (BuildContext context) {
        List<PopupMenuItem<MenuItem>> items = [];
        if(!showOnlyChangeFont){
          _getMenuItems(context, bookmark: bookmark).forEach((item) {
            Color color = Theme.of(context).popupMenuTheme.textStyle.color;
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
        items.add(makeChangeFontSizeWidget(context, showHr: !showOnlyChangeFont ));
        return items;
      }
  );
}

List<MenuItem> _getMenuItems(BuildContext context, { bool bookmark }) {
  List<MenuItem> result = [];
  result = <MenuItem>[
    MenuItem(
        id: 1,
        title: LocaleKeys.addToFavorites.tr(),
        icon: bookmark ? Icons.favorite : Icons.favorite_border),
    MenuItem(
        id: 2,
        title: LocaleKeys.reportMistake.tr(),
        icon: Icons.report),
  ];
  return result;
}


Widget makeChangeFontSizeWidget(BuildContext context, { bool showHr = true }) {
  return PopupMenuItem<MenuItem>(
    enabled: false,
    height: 30,
    child: Column(
      children: <Widget>[
        showHr ? Container(
            height: 1, width: double.infinity,
            color: Theme.of(context).popupMenuTheme.textStyle.color,
            margin: EdgeInsets.only(bottom: 20, top: 10)
        ) : SizedBox(),
        Text(LocaleKeys.font_size.tr(), style: Theme.of(context).popupMenuTheme.textStyle,),
        ChangeFontSizeWidget(),
      ],
    ),
  );
}
