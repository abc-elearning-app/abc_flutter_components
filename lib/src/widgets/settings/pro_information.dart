import 'package:flutter/material.dart';

import '../../../flutter_abc_jsc_components.dart';

class ProInformationTile extends StatelessWidget {
  final String appLogo;
  final String appName;
  final String appVersion;
  final String proIcon;
  final String? subtitle;
  final bool isDarkMode;
  final Color mainColor;
  final VoidCallback? onTap;
  final VoidCallback? onTapTitle;
  final EdgeInsets? padding;
  final bool proVersion;

  const ProInformationTile({
    super.key,
    required this.appLogo,
    required this.appName,
    required this.appVersion,
    required this.isDarkMode,
    required this.mainColor,
    required this.proIcon,
    required this.proVersion,
    this.onTap,
    this.onTapTitle,
    this.padding,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          IconWidget(icon: appLogo, height: 50),
          const SizedBox(width: 15),
          Expanded(
            child: GestureDetector(
              onTap: onTapTitle,
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
                        fontSize: 12, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic, color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  if(subtitle != null && subtitle!.isNotEmpty) Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w300, 
                      fontStyle: FontStyle.italic, 
                      color: isDarkMode ? Colors.white38 : Colors.grey
                    ),
                  ),
                ],
              ),
            ),
          ),
          if(proVersion) GestureDetector(
            onTap: onTap,
            child: NewProButton(
              key: GlobalKey(),
              mainColor: mainColor,
              proIcon: proIcon,
            ),
          )
        ],
      ),
    );
  }
}
