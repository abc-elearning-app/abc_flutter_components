import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:intl/intl.dart';

class SettingComponent extends StatefulWidget {
  final bool isDarkMode;
  final bool isPro;
  final DateTime examDate;
  final TimeOfDay remindTime;
  final String appVersion;
  final bool notificationOn;

  final bool isLoggedIn;
  final String avatar;
  final String username;
  final String crownIcon;

  final Color mainColor;
  final Color backgroundColor;
  final Color switchActiveTrackColor;

  final String circleIcon;
  final String dnaIcon;
  final String starIcon;
  final String triangleIcon;
  final String premiumIcon;

  final void Function() onAvatarClick;

  // Callbacks
  final void Function(bool value) onToggleNotification;
  final void Function() onProPurchase;
  final void Function() onDisableReminder;
  final void Function() onClickReset;
  final void Function() onToggleDarkMode;
  final void Function() onClickPolicy;
  final void Function() onClickAppVersion;
  final void Function() onClickContact;
  final void Function() onClickRate;
  final void Function() onShare;
  final void Function(DateTime date) onChangeExamDate;
  final void Function(TimeOfDay time) onChangeRemindTime;

  const SettingComponent({
    super.key,
    this.mainColor = const Color(0xFF6C5F4B),
    this.switchActiveTrackColor = const Color(0xFFF4E8D6),
    this.backgroundColor = const Color(0xFFF5F4EE),
    required this.isDarkMode,
    required this.isPro,
    required this.examDate,
    required this.remindTime,
    required this.onToggleDarkMode,
    required this.onProPurchase,
    required this.onToggleNotification,
    required this.onChangeRemindTime,
    required this.onDisableReminder,
    required this.onClickReset,
    required this.onClickPolicy,
    required this.onClickAppVersion,
    required this.onClickContact,
    required this.onClickRate,
    required this.onChangeExamDate,
    required this.onShare,
    required this.appVersion,
    required this.notificationOn,
    required this.onAvatarClick,
    required this.avatar,
    required this.circleIcon,
    required this.dnaIcon,
    required this.starIcon,
    required this.triangleIcon,
    required this.premiumIcon,
    required this.isLoggedIn,
    required this.username,
    required this.crownIcon,
  });

  @override
  State<SettingComponent> createState() => _SettingComponentState();
}

class _SettingComponentState extends State<SettingComponent> {
  final double _buttonHeight = 70;
  late ValueNotifier _remindTime;
  late ValueNotifier _examDate;
  late ValueNotifier _notificationOn;

  @override
  void initState() {
    _examDate = ValueNotifier<DateTime>(widget.examDate);
    _remindTime = ValueNotifier<TimeOfDay>(widget.remindTime);
    _notificationOn = ValueNotifier<bool>(widget.notificationOn);
    super.initState();
  }

  @override
  void dispose() {
    _examDate.dispose();
    _remindTime.dispose();
    _notificationOn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : widget.backgroundColor,
      // body: SafeArea(
      //   child: SingleChildScrollView(
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         if (!widget.isPro)
      //           PremiumButton(
      //             isDarkMode: widget.isDarkMode,
      //             margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
      //             onClick: widget.onProPurchase,
      //             buttonHeight: _buttonHeight,
      //             circleIcon: widget.circleIcon,
      //             dnaIcon: widget.dnaIcon,
      //             starIcon: widget.starIcon,
      //             triangleIcon: widget.triangleIcon,
      //             premiumIcon: widget.premiumIcon,
      //           ),
      //         _title('Settings Exam'),
      //         _tileGroup([
      //           ValueListenableBuilder(
      //             valueListenable: _examDate,
      //             builder: (_, value, __) => SettingTile(
      //                 type: SettingTileType.informationTile,
      //                 title: 'Exam Date',
      //                 information: _formatDate(value),
      //                 icon: AppSvgIcons.settingIcons.examDate,
      //                 isDarkMode: widget.isDarkMode,
      //                 onClick: () => _changeDate(context),
      //                 activeThumbColor: widget.mainColor,
      //                 activeTrackColor: widget.switchActiveTrackColor),
      //           )
      //         ]),
      //         _title('General Settings'),
      //         _tileGroup([
      //           ValueListenableBuilder(
      //             valueListenable: _notificationOn,
      //             builder: (_, value, __) => SettingTile(
      //                 type: SettingTileType.switchTile,
      //                 value: value,
      //                 title: 'Notification',
      //                 icon: AppSvgIcons.settingIcons.notification,
      //                 isDarkMode: widget.isDarkMode,
      //                 onClick: _toggleNotification,
      //                 activeThumbColor: widget.mainColor,
      //                 activeTrackColor: widget.switchActiveTrackColor),
      //           ),
      //           ValueListenableBuilder(
      //             valueListenable: _remindTime,
      //             builder: (_, value, __) => SettingTile(
      //                 type: SettingTileType.informationTile,
      //                 title: 'Remind Me At',
      //                 information: _formatTime(value),
      //                 icon: AppSvgIcons.settingIcons.remindAt,
      //                 isDarkMode: widget.isDarkMode,
      //                 onClick: () => _changeTime(context)),
      //           ),
      //           SettingTile(
      //               type: SettingTileType.chevronTile,
      //               title: 'Disable Calendar Reminder',
      //               icon: AppSvgIcons.settingIcons.disableCalendar,
      //               isDarkMode: widget.isDarkMode,
      //               onClick: widget.onDisableReminder,
      //               activeThumbColor: widget.mainColor,
      //               activeTrackColor: widget.switchActiveTrackColor),
      //           SettingTile(
      //               type: SettingTileType.chevronTile,
      //               title: 'Reset Progress',
      //               icon: AppSvgIcons.settingIcons.reset,
      //               isDarkMode: widget.isDarkMode,
      //               onClick: widget.onClickReset,
      //               activeThumbColor: widget.mainColor,
      //               activeTrackColor: widget.switchActiveTrackColor),
      //           SettingTile(
      //             type: SettingTileType.switchTile,
      //             value: widget.isDarkMode,
      //             title: 'Dark Mode',
      //             icon: AppSvgIcons.settingIcons.darkMode,
      //             isDarkMode: widget.isDarkMode,
      //             showPro: !widget.isPro,
      //             activeThumbColor: widget.mainColor,
      //             activeTrackColor: widget.switchActiveTrackColor,
      //             onClick: widget.onToggleDarkMode,
      //             onProPurchase: widget.onProPurchase,
      //           ),
      //         ]),
      //         _title('App Information'),
      //         _tileGroup([
      //           SettingTile(
      //               type: SettingTileType.chevronTile,
      //               title: 'Privacy Policy',
      //               icon: AppSvgIcons.settingIcons.privacyPolicy,
      //               isDarkMode: widget.isDarkMode,
      //               onClick: widget.onClickPolicy,
      //               activeThumbColor: widget.mainColor,
      //               activeTrackColor: widget.switchActiveTrackColor),
      //           SettingTile(
      //               type: SettingTileType.informationTile,
      //               title: 'App Version',
      //               information: widget.appVersion,
      //               icon: AppSvgIcons.settingIcons.appVersion,
      //               isDarkMode: widget.isDarkMode,
      //               onClick: widget.onClickAppVersion,
      //               activeThumbColor: widget.mainColor,
      //               activeTrackColor: widget.switchActiveTrackColor),
      //         ]),
      //         _title('Feedback And Sharing'),
      //         _tileGroup([
      //           SettingTile(
      //               type: SettingTileType.chevronTile,
      //               title: 'Contact Us',
      //               icon: AppSvgIcons.settingIcons.contact,
      //               isDarkMode: widget.isDarkMode,
      //               onClick: widget.onClickContact,
      //               activeThumbColor: widget.mainColor),
      //           SettingTile(
      //               isDarkMode: widget.isDarkMode,
      //               icon: AppSvgIcons.settingIcons.rate,
      //               title: 'Rate Our App',
      //               onClick: widget.onClickRate,
      //               type: SettingTileType.chevronTile),
      //           SettingTile(
      //               isDarkMode: widget.isDarkMode,
      //               icon: AppSvgIcons.settingIcons.share,
      //               title: 'Share App With Friends',
      //               onClick: widget.onShare,
      //               type: SettingTileType.chevronTile)
      //         ]),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  _toggleNotification() {
    _notificationOn.value = !_notificationOn.value;
    widget.onToggleNotification(_notificationOn.value);
  }

  _changeDate(BuildContext context) async {
    final date = await showDatePicker(
        context: context,
        builder: (_, child) => Theme(
            data: ThemeData(
              fontFamily: 'Poppins',
              colorScheme: widget.isDarkMode ? const ColorScheme.dark() : const ColorScheme.light(),
            ),
            child: child!),
        firstDate: DateTime(DateTime.now().year, 1, 1),
        lastDate: DateTime(DateTime.now().year, 12, 31));

    if (date != null) {
      _examDate.value = date;
      widget.onChangeExamDate(date);
    }
  }

  _changeTime(BuildContext context) async {
    final time = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 0, minute: 0),
        builder: (_, child) => Theme(
            data: ThemeData(
              useMaterial3: false,
              colorScheme: widget.isDarkMode ? const ColorScheme.dark() : const ColorScheme.light(),
            ),
            child: child!));

    if (time != null) {
      _remindTime.value = time;
      widget.onChangeRemindTime(time);
    }
  }
}
