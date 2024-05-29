import 'package:example/constants/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:provider/provider.dart';

import '../../providers/app_theme_provider.dart';

class TestSettingScreen extends StatefulWidget {
  const TestSettingScreen({super.key});

  @override
  State<TestSettingScreen> createState() => _TestSettingScreenState();
}

class _TestSettingScreenState extends State<TestSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return SettingScreen(
      isPro: false,
      notificationOn: true,
      isDarkMode: AppTheme.isDarkMode,
      onToggleDarkMode: () => setState(() =>
          Provider.of<AppThemeProvider>(context, listen: false)
              .changeAppTheme()),
      onClickPremium: () => print('Go Premium'),
      onProPurchase: () => print('Buy Pro'),
      onChangeExamDate: (date) => print(date),
      onChangeRemindTime: (time) => print(time),
      onToggleNotification: () => print('Toggle notification'),
      onClickAppVersion: () => print('App version'),
      onClickContact: () => print('Contact'),
      onClickPolicy: () => print('Policy'),
      onClickRate: () => print('Rate'),
      onDisableReminder: () => print('Disable reminder'),
      onClickReset: () => print('Click reset'),
      onShare: () => print('Sharing is caring'),
      appVersion: '1.6.9',
      examDate: DateTime.now(),
      remindTime: TimeOfDay.now(),
    );
  }
}
