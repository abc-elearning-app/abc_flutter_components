import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

enum PackageType { weekly, monthly, yearly, pro }

class AccountTabComponent extends StatelessWidget {
  final bool isDarkMode;
  final bool isPro;
  final String appName;
  final String appVersion;
  final PackageType packageType;
  final DateTime? expireDate;

  final String appLogo;
  final String crownIcon;
  final String circleIcon;
  final String dnaIcon;
  final String starIcon;
  final String triangleIcon;
  final String premiumIcon;
  final String proIcon;

  final String syncIcon;
  final String deleteAccountIcon;
  final String logoutIcon;

  final String avatar;
  final String username;
  final String email;
  final bool loggedIn;

  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;

  final void Function() onUpgrade;
  final void Function() onSync;
  final void Function() onLogout;
  final void Function() onDeleteAccount;
  final bool? tester;

  const AccountTabComponent({
    super.key,
    required this.isDarkMode,
    required this.circleIcon,
    required this.dnaIcon,
    required this.starIcon,
    required this.triangleIcon,
    required this.premiumIcon,
    required this.isPro,
    required this.syncIcon,
    required this.deleteAccountIcon,
    required this.logoutIcon,
    required this.backgroundColor,
    required this.onUpgrade,
    required this.onSync,
    required this.onLogout,
    required this.onDeleteAccount,
    required this.avatar,
    required this.username,
    required this.email,
    required this.appLogo,
    required this.appName,
    required this.appVersion,
    required this.packageType,
    required this.crownIcon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.loggedIn,
    required this.proIcon,
    this.expireDate,
    this.tester
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 5,
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: isDarkMode ? Colors.grey : Colors.white),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: isDarkMode ? Colors.black : backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              )),
          child: SafeArea(
            child: Column(
              children: [
                // Premium button
                if (!isPro)
                  PremiumButton(
                      buttonHeight: 70,
                      isDarkMode: isDarkMode,
                      onClick: () {
                        Navigator.of(context).pop();
                        onUpgrade();
                      },
                      circleIcon: circleIcon,
                      dnaIcon: dnaIcon,
                      starIcon: starIcon,
                      triangleIcon: triangleIcon,
                      premiumIcon: premiumIcon),

                if (!isPro)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(),
                  ),

                // User information (avatar, email, name)
                if(loggedIn) Padding(
                  padding: EdgeInsets.only(top: isPro ? 15 : 0),
                  child: UserInformation(isPro: isPro, avatar: avatar, email: email, username: username, crownIcon: crownIcon),
                ),

                if (isPro && loggedIn)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(),
                  ),

                if (isPro) _proInformation(),

                // Action buttons
                const SizedBox(height: 10),
                _buildButton('Sync Data', syncIcon, onSync),
                _buildButton('Log Out', logoutIcon, onLogout),
                _buildButton(
                  'Delete Account',
                  deleteAccountIcon,
                  onDeleteAccount,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _proInformation() => Column(
        children: [
          ProInformationTile(
            appLogo: appLogo,
            appName: appName,
            appVersion: appVersion,
            isDarkMode: isDarkMode,
            mainColor: primaryColor,
            proIcon: proIcon,
            proVersion: isPro,
            padding: const EdgeInsets.all(0)
          ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 8),
          //   child: Row(
          //     children: [
          //       IconWidget(icon: appLogo, height: 40),
          //       const SizedBox(width: 15),
          //       Expanded(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               appName,
          //               style: const TextStyle(
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.w600,
          //               ),
          //             ),
          //             Text(
          //               'Version $appVersion',
          //               style: TextStyle(
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.w300,
          //                   fontStyle: FontStyle.italic,
          //                   color: isDarkMode ? Colors.white : Colors.black.withOpacity(0.5)),
          //             ),
          //           ],
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Package',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '${packageType.name[0].toUpperCase()}${packageType.name.substring(1, packageType.name.length)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if(expireDate != null) Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Expiration Date',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  _getDateTime(expireDate!),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
          if (isPro)
            const Padding(
              padding: EdgeInsets.only(top: 15),
              child: Divider(),
            ),
        ],
      );

  Widget _buildButton(String title, String icon, void Function() onClick, {Color? color}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ElevatedButton(
            onPressed: onClick,
            style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor: secondaryColor,
                backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade300.withOpacity(0.4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Transform.translate(offset: const Offset(-10, 0), child: IconWidget(icon: icon, color: color ?? (isDarkMode ? Colors.white : Colors.black))),
                  const SizedBox(width: 5),
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color ?? (isDarkMode ? Colors.white : Colors.black)),
                  )
                ],
              ),
            )),
      );

  _getDateTime(DateTime time) {
    final displayMonth = time.month < 10 ? '0${time.month}' : '${time.month}';
    final displayDay = time.day < 10 ? '0${time.day}' : '${time.day}';
    if(tester == true) {
      final displayHour = time.hour < 10 ? '0${time.hour}' : '${time.hour}';
      final displayMinute = time.minute < 10 ? '0${time.minute}' : '${time.minute}';
      final displaySecond = time.second < 10 ? '0${time.second}' : '${time.second}';
      return '${time.year}-$displayMonth-$displayDay $displayHour:$displayMinute:$displaySecond';
    }
    return '${time.year}-$displayMonth-$displayDay';
  }
}
