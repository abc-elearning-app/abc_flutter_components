import 'package:flutter/material.dart';

import '../../../flutter_abc_jsc_components.dart';

class ProInformationTile extends StatelessWidget {
  final String appLogo;
  final String appName;
  final String appVersion;
  final String proIcon;

  final bool isDarkMode;

  final Color mainColor;

  const ProInformationTile({
    super.key,
    required this.appLogo,
    required this.appName,
    required this.appVersion,
    required this.isDarkMode,
    required this.mainColor,
    required this.proIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          IconWidget(icon: appLogo, height: 50),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Version $appVersion',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic, color: isDarkMode ? Colors.white : Colors.black.withOpacity(0.5)),
                ),
              ],
            ),
          ),
          NewProButton(
            key: GlobalKey(),
            mainColor: mainColor,
            proIcon: proIcon,
          )
        ],
      ),
    );
  }
}
