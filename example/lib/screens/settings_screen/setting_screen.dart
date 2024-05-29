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
        isDarkMode: AppTheme.isDarkMode,
        onClick: () => setState(() =>
            Provider.of<AppThemeProvider>(context, listen: false)
                .changeAppTheme()));
  }
}
