import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/constants/app_svg_icons.dart';
import 'package:flutter_abc_jsc_components/src/widgets/settings/widgets/premium_button.dart';
import 'package:flutter_abc_jsc_components/src/widgets/settings/widgets/tile.dart';
import 'package:intl/intl.dart';

class SettingScreen extends StatefulWidget {
  final bool isDarkMode;
  final bool isPro;
  final DateTime examDate;
  final TimeOfDay remindTime;
  final String appVersion;
  final bool notificationOn;

  final Color mainColor;
  final Color backgroundColor;
  final Color switchActiveTrackColor;

  final String avatar;

  final void Function() onAvatarClick;

  // Callbacks
  final void Function() onToggleNotification;
  final void Function() onProPurchase;
  final void Function() onDisableReminder;
  final void Function() onClickReset;
  final void Function() onToggleDarkMode;
  final void Function() onClickPremium;
  final void Function() onClickPolicy;
  final void Function() onClickAppVersion;
  final void Function() onClickContact;
  final void Function() onClickRate;
  final void Function() onShare;
  final void Function(DateTime date) onChangeExamDate;
  final void Function(TimeOfDay time) onChangeRemindTime;

  const SettingScreen({
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
    required this.onClickPremium,
    required this.onChangeExamDate,
    required this.onShare,
    required this.appVersion,
    required this.notificationOn,
    required this.onAvatarClick,
    required this.avatar,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
      backgroundColor:
          widget.isDarkMode ? Colors.black : widget.backgroundColor,
      appBar: _customAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.isPro)
                PremiumButton(
                    isDarkMode: widget.isDarkMode,
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
                    onClick: () => widget.onClickPremium(),
                    buttonHeight: _buttonHeight),
              _title('Settings Exam'),
              _tileGroup([
                ValueListenableBuilder(
                  valueListenable: _examDate,
                  builder: (_, value, __) => SettingTile(
                      type: SettingTileType.informationTile,
                      title: 'Exam Date',
                      information: _formatDate(value),
                      iconString: AppSvgIcons.settingIcons.examDate,
                      isDarkMode: widget.isDarkMode,
                      onClick: () => _changeDate(context),
                      mainColor: widget.mainColor,
                      activeTrackColor: widget.switchActiveTrackColor),
                )
              ]),
              _title('General Settings'),
              _tileGroup([
                ValueListenableBuilder(
                  valueListenable: _notificationOn,
                  builder: (_, value, __) => SettingTile(
                      type: SettingTileType.switchTile,
                      value: value,
                      title: 'Notification',
                      iconString: AppSvgIcons.settingIcons.notification,
                      isDarkMode: widget.isDarkMode,
                      onClick: _toggleNotification,
                      mainColor: widget.mainColor,
                      activeTrackColor: widget.switchActiveTrackColor),
                ),
                ValueListenableBuilder(
                  valueListenable: _remindTime,
                  builder: (_, value, __) => SettingTile(
                      type: SettingTileType.informationTile,
                      title: 'Remind Me At',
                      information: _formatTime(value),
                      iconString: AppSvgIcons.settingIcons.remindAt,
                      isDarkMode: widget.isDarkMode,
                      onClick: () => _changeTime(context)),
                ),
                SettingTile(
                    type: SettingTileType.chevronTile,
                    title: 'Disable Calendar Reminder',
                    iconString: AppSvgIcons.settingIcons.disableCalendar,
                    isDarkMode: widget.isDarkMode,
                    onClick: widget.onDisableReminder,
                    mainColor: widget.mainColor,
                    activeTrackColor: widget.switchActiveTrackColor),
                SettingTile(
                    type: SettingTileType.chevronTile,
                    title: 'Reset Progress',
                    iconString: AppSvgIcons.settingIcons.reset,
                    isDarkMode: widget.isDarkMode,
                    onClick: widget.onClickReset,
                    mainColor: widget.mainColor,
                    activeTrackColor: widget.switchActiveTrackColor),
                SettingTile(
                  type: SettingTileType.switchTile,
                  value: widget.isDarkMode,
                  title: 'Dark Mode',
                  iconString: AppSvgIcons.settingIcons.darkMode,
                  isDarkMode: widget.isDarkMode,
                  showPro: !widget.isPro,
                  mainColor: widget.mainColor,
                  activeTrackColor: widget.switchActiveTrackColor,
                  onClick: widget.onToggleDarkMode,
                  onProPurchase: widget.onProPurchase,
                ),
              ]),
              _title('App Information'),
              _tileGroup([
                SettingTile(
                    type: SettingTileType.chevronTile,
                    title: 'Privacy Policy',
                    iconString: AppSvgIcons.settingIcons.privacyPolicy,
                    isDarkMode: widget.isDarkMode,
                    onClick: widget.onClickPolicy,
                    mainColor: widget.mainColor,
                    activeTrackColor: widget.switchActiveTrackColor),
                SettingTile(
                    type: SettingTileType.informationTile,
                    title: 'App Version',
                    information: widget.appVersion,
                    iconString: AppSvgIcons.settingIcons.appVersion,
                    isDarkMode: widget.isDarkMode,
                    onClick: widget.onClickAppVersion,
                    mainColor: widget.mainColor,
                    activeTrackColor: widget.switchActiveTrackColor),
              ]),
              _title('Feedback And Sharing'),
              _tileGroup([
                SettingTile(
                    type: SettingTileType.chevronTile,
                    title: 'Contact Us',
                    iconString: AppSvgIcons.settingIcons.contact,
                    isDarkMode: widget.isDarkMode,
                    onClick: widget.onClickContact,
                    mainColor: widget.mainColor),
                SettingTile(
                    isDarkMode: widget.isDarkMode,
                    iconString: AppSvgIcons.settingIcons.rate,
                    title: 'Rate Our App',
                    onClick: widget.onClickRate,
                    type: SettingTileType.chevronTile),
                SettingTile(
                    isDarkMode: widget.isDarkMode,
                    iconString: AppSvgIcons.settingIcons.share,
                    title: 'Share App With Friends',
                    onClick: widget.onShare,
                    type: SettingTileType.chevronTile)
              ]),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _customAppBar() => AppBar(
        backgroundColor: widget.isDarkMode ? Colors.black : widget.backgroundColor,
        scrolledUnderElevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop()),
        title: Text(
          'Settings',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: widget.isDarkMode ? Colors.white : Colors.black),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: IconWidget(
                  icon: widget.avatar,
                  height: 40,
                ),
                onPressed: widget.onAvatarClick,
              ))
        ],
      );

  Widget _title(String title) => Padding(
      padding: const EdgeInsets.only(left: 15, top: 20, bottom: 10),
      child: Text(title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          )));

  Widget _tileGroup(List<Widget> tiles) => Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(widget.isDarkMode ? 0.16 : 1)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tiles.length,
        itemBuilder: (_, index) => tiles[index],
        separatorBuilder: (BuildContext context, int index) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(color: Colors.grey)),
      ));

  _formatDate(DateTime date) => DateFormat('MMM dd yyyy').format(date);

  _formatTime(TimeOfDay time) {
    final displayHour = time.hour < 10 ? '0${time.hour}' : time.hour.toString();
    final displayMinute =
        time.minute < 10 ? '0${time.minute}' : time.minute.toString();
    return '$displayHour:$displayMinute';
  }

  _toggleNotification() {
    _notificationOn.value = !_notificationOn.value;
    widget.onToggleNotification();
  }

  _changeDate(BuildContext context) async {
    final date = await showDatePicker(
        context: context,
        builder: (_, child) => Theme(
            data: ThemeData(
              colorScheme: widget.isDarkMode
                  ? const ColorScheme.dark()
                  : const ColorScheme.light(),
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
              colorScheme: widget.isDarkMode
                  ? const ColorScheme.dark()
                  : const ColorScheme.light(),
            ),
            child: child!));

    if (time != null) {
      _remindTime.value = time;
      widget.onChangeRemindTime(time);
    }
  }
}
