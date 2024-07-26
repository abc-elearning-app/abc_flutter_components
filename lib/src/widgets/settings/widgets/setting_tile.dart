import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

enum SettingTileType { chevronTile, switchTile, informationTile }

class SettingTile extends StatelessWidget {
  final SettingTileType type;

  final String icon;
  final String title;
  final bool showPro;

  // Trailing
  final bool? value;
  final String? information;

  // Colors
  final bool isDarkMode;
  final Color? activeThumbColor;
  final Color? activeTrackColor;

  final void Function() onClick;
  final void Function()? onProPurchase;

  const SettingTile({
    super.key,
    this.value,
    this.information,
    this.showPro = false,
    this.activeThumbColor = const Color(0xFF6C5F4B),
    this.activeTrackColor = const Color(0xFFF4E8D6),
    required this.isDarkMode,
    required this.icon,
    required this.title,
    required this.type,
    required this.onClick,
    this.onProPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => showPro ? onProPurchase!() : onClick(),
      leading: IconWidget(icon: icon, color: isDarkMode ? Colors.white : Colors.black),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: isDarkMode ? Colors.white : Colors.black)),
      trailing: _buildTrailing(),
    );
  }

  Widget _buildTrailing() {
    switch (type) {
      case SettingTileType.chevronTile:
        return const Icon(Icons.chevron_right_rounded, size: 35, color: Colors.grey);
      case SettingTileType.switchTile:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showPro) GetProIcon(padding: const EdgeInsets.all(5), margin: const EdgeInsets.only(right: 8), darkMode: isDarkMode),
            const SizedBox(width: 10),
            StatefulBuilder(
              builder: (_, setState) => Switch(
                value: value!,
                activeColor: activeThumbColor,
                inactiveTrackColor: Colors.black.withOpacity(0.08),
                inactiveThumbColor: isDarkMode ? Colors.white : Colors.black,
                activeTrackColor: activeTrackColor,
                thumbIcon: const MaterialStatePropertyAll(Icon(Icons.abc, color: Colors.transparent)),
                trackOutlineColor: MaterialStatePropertyAll(isDarkMode ? Colors.white : activeThumbColor),
                trackOutlineWidth: const MaterialStatePropertyAll(1),
                onChanged: (_) => showPro ? onProPurchase!() : onClick(),
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
                decoration: TextDecoration.underline,
              )),
        );
    }
  }
}
