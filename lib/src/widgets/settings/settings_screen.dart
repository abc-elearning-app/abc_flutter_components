import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/settings/widgets/premium_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  final double buttonHeight = 70.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4EE),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PremiumButton(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                onClick: () => print('Premium button'),
                gradientColors: const [Color(0xFFFF9840), Color(0xFFFF544E)],
                buttonHeight: 70),
            _buildTitle('Settings Exam'),
            _tile()
          ],
        ),
      ),
    );
  }

  _buildTitle(String title) => Padding(
        padding: const EdgeInsets.only(left: 15, top: 20, bottom: 10),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      );

  _tile() {
    bool value = false;
    return StatefulBuilder(
      builder: (_, setState) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: const Icon(Icons.ac_unit, color: Color(0xFF212121)),
          title: const Text('Dark Mode',
              style: TextStyle(color: Color(0xFF212121))),
          trailing: Switch(
            activeColor: Color(0xFF6C5F4B),
            activeTrackColor: Color(0xFFF4E8D6),
            trackOutlineColor: MaterialStateProperty.all(Color(0xFF6C5F4B)),
            trackOutlineWidth: MaterialStateProperty.all(1),
            value: value,
            onChanged: (newValue) => setState(() => value = newValue),
          ),
        ),
      ),
    );
  }
}
