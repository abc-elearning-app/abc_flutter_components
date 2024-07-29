import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class ModeData {
  final int id;
  final String title;
  final String detail;

  ModeData(this.id, this.title, this.detail);
}

class ModeOptions extends StatefulWidget {
  final List<ModeData> modes;
  final Color mainColor;
  final bool isDarkMode;

  final String infoIcon;

  final void Function(int id) onSelect;

  const ModeOptions({
    super.key,
    required this.modes,
    required this.mainColor,
    required this.isDarkMode,
    required this.infoIcon,
    required this.onSelect,
  });

  @override
  State<ModeOptions> createState() => _ModeOptionsState();
}

class _ModeOptionsState extends State<ModeOptions> {
  int selectedModeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.modes.length,
        itemBuilder: (_, index) => _radioTile(widget.modes[index], index, selectedModeIndex));
  }

  Widget _radioTile(
    ModeData modeData,
    int index,
    int selectedIndex,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() => selectedModeIndex = index);
            widget.onSelect(selectedIndex);
          },
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: widget.mainColor),
                  color: selectedIndex == index ? widget.mainColor : Colors.white.withOpacity(widget.isDarkMode ? 0.16 : 1),
                  borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                // Info icon
                leading: IconWidget(icon: widget.infoIcon, height: 20, color: selectedIndex == index ? Colors.white : Colors.grey),
                title: Text(modeData.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: selectedIndex == index || widget.isDarkMode ? Colors.white : Colors.black,
                    )),

                trailing: CircleAvatar(
                  radius: 12,
                  backgroundColor: selectedIndex == index
                      ? Colors.white
                      : widget.isDarkMode
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                  child: CircleAvatar(
                    radius: selectedIndex == index ? 5 : 10,
                    backgroundColor: selectedIndex == index
                        ? widget.mainColor
                        : widget.isDarkMode
                            ? Colors.grey.shade800
                            : Colors.white,
                  ),
                ),
              )),
        ),

        // Mode detail
        AnimatedContainer(
            height: selectedIndex == index ? 50 : 0,
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
