import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/customize_test/provider/customize_test_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ModeData {
  final int id;
  final String title;
  final String detail;

  ModeData(this.id, this.title, this.detail);
}

class ModeOptions extends StatelessWidget {
  final List<ModeData> modes;
  final Color mainColor;
  final bool isDarkMode;
  final String infoIcon;

  const ModeOptions({
    super.key,
    required this.modes,
    required this.mainColor,
    required this.isDarkMode,
    required this.infoIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<CustomizeTestProvider, int>(
      selector: (_, provider) => provider.selectedModeValue,
      builder: (_, selectedModeIndex, __) => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: modes.length,
          itemBuilder: (_, index) => _radioTile(
              context, modes[index], modes[index].id, selectedModeIndex)),
    );
  }

  Widget _radioTile(
    BuildContext context,
    ModeData modeData,
    int modeValue,
    int selectedIndex,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () =>
              context.read<CustomizeTestProvider>().selectMode(modeValue),
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: mainColor),
                  color: selectedIndex == modeValue
                      ? mainColor
                      : Colors.white.withOpacity(isDarkMode ? 0.16 : 1),
                  borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                // Info icon
                leading: IconWidget(
                    icon: infoIcon,
                    height: 20,
                    color: selectedIndex == modeValue
                        ? Colors.white
                        : Colors.grey),
                title: Text(modeData.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: selectedIndex == modeValue || isDarkMode
                            ? Colors.white
                            : Colors.black)),

                trailing: CircleAvatar(
                  radius: 12,
                  backgroundColor: selectedIndex == modeValue
                      ? Colors.white
                      : isDarkMode
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                  child: CircleAvatar(
                    radius: selectedIndex == modeValue ? 5 : 10,
                    backgroundColor: selectedIndex == modeValue
                        ? mainColor
                        : isDarkMode
                            ? Colors.grey.shade800
                            : Colors.white,
                  ),
                ),
              )),
        ),

        // Mode detail
        AnimatedContainer(
            height: selectedIndex == modeValue ? 50 : 0,
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                modeData.detail,
                style:
                    const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
              ),
            ))
      ],
    );
  }
}
