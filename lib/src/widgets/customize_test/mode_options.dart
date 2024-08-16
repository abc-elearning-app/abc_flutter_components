import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class ModeData {
  final int id;
  final String title;
  final String detail;

  ModeData(this.id, this.title, this.detail);
}

class ModeOptions extends StatelessWidget {
  final List<ModeData> modes;
  final int value;
  final Color mainColor;
  final bool isDarkMode;
  final String infoIcon;

  final void Function(int id) onSelect;

  const ModeOptions({
    super.key,
    required this.modes,
    required this.value,
    required this.mainColor,
    required this.isDarkMode,
    required this.infoIcon,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: modes.map((e) => _radioTile(e)).toList(),
    );
  }

  Widget _radioTile(ModeData modeData) {
    bool selected = modeData.id == value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => onSelect(modeData.id),
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: mainColor),
                  color: selected ? mainColor : Colors.white.withOpacity(isDarkMode ? 0.16 : 1),
                  borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                // Info icon
                leading: IconWidget(icon: infoIcon, height: 20, color: selected ? Colors.white : Colors.grey),
                title: Text(modeData.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: selected || isDarkMode ? Colors.white : Colors.black,
                    )),

                trailing: CircleAvatar(
                  radius: 12,
                  backgroundColor: selected
                      ? Colors.white
                      : isDarkMode
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                  child: CircleAvatar(
                    radius: selected ? 5 : 10,
                    backgroundColor: selected
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
            height: selected ? 50 : 0,
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                modeData.detail,
                style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
              ),
            ))
      ],
    );
  }
}
