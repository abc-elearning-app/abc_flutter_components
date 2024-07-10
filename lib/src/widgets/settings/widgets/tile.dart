import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/icons/get_pro_icon.dart';

import '../../../utils/image_utils.dart';

enum SettingTileType { chevronTile, switchTile, informationTile }

class SettingTile extends StatelessWidget {
  final SettingTileType type;

  final String iconString;
  final String title;
  final bool showPro;

  // Trailing
  final bool? value;
  final String? information;

  // Colors
  final bool isDarkMode;
  final Color? mainColor;
  final Color? activeTrackColor;

  final void Function() onClick;
  final void Function()? onProPurchase;

  const SettingTile(
      {super.key,
      this.value,
      this.information,
      this.showPro = false,
      this.mainColor,
      this.activeTrackColor,
      required this.isDarkMode,
      required this.iconString,
      required this.title,
      required this.onClick,
      required this.type,
      this.onProPurchase});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => showPro ? onProPurchase!() : onClick(),
      leading: ResponsiveIcon(
          content: iconString, color: isDarkMode ? 'white' : ' black'),
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: isDarkMode ? Colors.white : Colors.black
          )),
      trailing: _buildTrailing(),
    );
  }

  Widget _buildTrailing() {
    switch (type) {
      case SettingTileType.chevronTile:
        return const Icon(
          Icons.chevron_right_rounded,
          size: 35,
          color: Colors.grey,
        );
      case SettingTileType.switchTile:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showPro)
            GetProIcon(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(right: 8),
              darkMode: isDarkMode
            ),
            const SizedBox(width: 10),
            StatefulBuilder(
              builder: (_, setState) => Switch(
                activeColor: mainColor,
                inactiveTrackColor: Colors.black.withOpacity(0.08),
                inactiveThumbColor: isDarkMode ? Colors.white : Colors.black,
                activeTrackColor: activeTrackColor,
                thumbIcon: const MaterialStatePropertyAll(Icon(Icons.abc, color: Colors.transparent)),
                trackOutlineColor: MaterialStatePropertyAll(isDarkMode ? Colors.white : mainColor),
                trackOutlineWidth: const MaterialStatePropertyAll(1),
                value: value!,
                onChanged: (_) => showPro ? null : onClick(),
              ),
            ),
          ],
        );
      case SettingTileType.informationTile:
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(information!,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: isDarkMode ? Colors.white : Colors.black,
                  decoration: TextDecoration.underline)),
        );
    }
  }
}
