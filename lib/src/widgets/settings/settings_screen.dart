import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/constants/app_svg_icons.dart';
import 'package:flutter_abc_jsc_components/src/widgets/settings/widgets/premium_button.dart';
import 'package:flutter_abc_jsc_components/src/widgets/settings/widgets/tiles/switch_tile.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingScreen extends StatelessWidget {
  final void Function() onClick;
  final bool isDarkMode;

  final Color mainColor;
  final Color switchActiveTrackColor;

  const SettingScreen({
    super.key,
    required this.onClick,
    required this.isDarkMode,
    this.mainColor = const Color(0xFF6C5F4B),
    this.switchActiveTrackColor = const Color(0xFFF4E8D6),
  });

  final double buttonHeight = 70.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : const Color(0xFFF5F4EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SvgPicture.asset('assets/images/avatar.svg'))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PremiumButton(
                  isDarkMode: isDarkMode,
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
                  onClick: () => print('Premium button'),
                  gradientColors: const [Color(0xFFFF9840), Color(0xFFFF544E)],
                  buttonHeight: 70),
              _buildTitle('Settings Exam'),
              _buildTileGroup([
                SwitchTile(
                    type: SettingTileType.informationTile,
                    title: 'Exam Date',
                    information: 'Jun 26 2024',
                    iconString: AppSvgIcons.settingIcons.examDate,
                    isDarkMode: isDarkMode,
                    onClick: onClick,
                    mainColor: mainColor,
                    activeTrackColor: switchActiveTrackColor),
              ]),
              _buildTitle('General Settings'),
              _buildTileGroup([
                SwitchTile(
                    type: SettingTileType.switchTile,
                    value: true,
                    title: 'Notification',
                    iconString: AppSvgIcons.settingIcons.notification,
                    isDarkMode: isDarkMode,
                    onClick: () {},
                    mainColor: mainColor,
                    activeTrackColor: switchActiveTrackColor),
                _buildDivider(),
                SwitchTile(
                    type: SettingTileType.informationTile,
                    title: 'Remind Me At',
                    information: '17:34',
                    iconString: AppSvgIcons.settingIcons.remindAt,
                    isDarkMode: isDarkMode,
                    onClick: () {}),
                _buildDivider(),
                SwitchTile(
                    type: SettingTileType.chevronTile,
                    title: 'Disable Calendar Reminder',
                    iconString: AppSvgIcons.settingIcons.disableCalendar,
                    isDarkMode: isDarkMode,
                    onClick: () {},
                    mainColor: mainColor,
                    activeTrackColor: switchActiveTrackColor),
                _buildDivider(),
                SwitchTile(
                    type: SettingTileType.chevronTile,
                    title: 'Reset Progress',
                    iconString: AppSvgIcons.settingIcons.reset,
                    isDarkMode: isDarkMode,
                    onClick: () {},
                    mainColor: mainColor,
                    activeTrackColor: switchActiveTrackColor),
                _buildDivider(),
                SwitchTile(
                    type: SettingTileType.switchTile,
                    value: isDarkMode,
                    title: 'Dark Mode',
                    iconString: AppSvgIcons.settingIcons.darkMode,
                    isDarkMode: isDarkMode,
                    showPro: true,
                    onClick: onClick,
                    mainColor: mainColor,
                    activeTrackColor: switchActiveTrackColor),
              ]),
          
              _buildTitle('App Information'),
              _buildTileGroup([
                SwitchTile(
                    type: SettingTileType.chevronTile,
                    title: 'Privacy Policy',
                    iconString: AppSvgIcons.settingIcons.privacyPolicy,
                    isDarkMode: isDarkMode,
                    onClick: () {},
                    mainColor: mainColor,
                    activeTrackColor: switchActiveTrackColor),
                _buildDivider(),
                SwitchTile(
                    type: SettingTileType.informationTile,
                    title: 'App Version',
                    information: '1.5.3',
                    iconString: AppSvgIcons.settingIcons.appVersion,
                    isDarkMode: isDarkMode,
                    onClick: () {},
                    mainColor: mainColor,
                    activeTrackColor: switchActiveTrackColor),
              ]),
          
              _buildTitle('Feedback And Sharing'),
              _buildTileGroup([
                SwitchTile(
                    type: SettingTileType.chevronTile,
                    title: 'Contact Us',
                    iconString: AppSvgIcons.settingIcons.contact,
                    isDarkMode: isDarkMode,
                    onClick: () {},
                    mainColor: mainColor),
                _buildDivider(),
                SwitchTile(
                    type: SettingTileType.chevronTile,
                    title: 'Rate Our App',
                    iconString: AppSvgIcons.settingIcons.rate,
                    isDarkMode: isDarkMode,
                    onClick: () {},
                    mainColor: mainColor),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  _buildTileGroup(List<Widget> tiles) => Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      ),
      child: Column(children: tiles));

  _buildTitle(String title) => Padding(
        padding: const EdgeInsets.only(left: 15, top: 20, bottom: 10),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      );

  _buildDivider() => const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Divider(color: Colors.grey));
}
