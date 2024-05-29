import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/image_utils.dart';

enum SettingTileType { chevronTile, switchTile, timeTile, informationTile }

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
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
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
              SvgPicture.asset('assets/images/get_pro.svg', height: 30),
            const SizedBox(width: 10),
            StatefulBuilder(
              builder: (_, setState) => Switch(
                activeColor: isDarkMode ? Colors.white : mainColor,
                inactiveTrackColor: Colors.black.withOpacity(0.08),
                inactiveThumbColor: isDarkMode ? Colors.white : Colors.black,
                activeTrackColor:
                    isDarkMode ? Colors.grey.shade800 : activeTrackColor,
                thumbIcon: MaterialStateProperty.all(
                    const Icon(Icons.abc, color: Colors.transparent)),
                trackOutlineColor: MaterialStateProperty.all(
                    isDarkMode ? Colors.white : mainColor),
                trackOutlineWidth: MaterialStateProperty.all(1),
                value: value!,
                onChanged: (_) => showPro ? null : onClick(),
              ),
            ),
          ],
        );
      case SettingTileType.timeTile:
        return const Placeholder();
      case SettingTileType.informationTile:
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(information!,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline)),
        );
    }
  }
}
