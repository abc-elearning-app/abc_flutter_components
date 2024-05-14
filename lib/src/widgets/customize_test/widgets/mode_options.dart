import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/customize_test/provider/customize_test_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ModeData {
  final String title;
  final String detail;

  ModeData(this.title, this.detail);
}

class ModeOptions extends StatelessWidget {
  final List<ModeData> modes;
  final Color mainColor;
  final Color defaultColor;

  const ModeOptions({
    super.key,
    required this.modes,
    required this.mainColor,
    required this.defaultColor,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<CustomizeTestProvider, int>(
      selector: (_, provider) => provider.selectedModeIndex,
      builder: (_, selectedModeIndex, __) => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: modes.length,
          itemBuilder: (_, index) =>
              _radioTile(context, modes[index], index, selectedModeIndex)),
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
                  color: selectedIndex == modeValue ? mainColor : defaultColor,
                  borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                // Info icon
                leading: SvgPicture.asset('assets/images/info.svg',
                    height: 20,
                    colorFilter: ColorFilter.mode(
                        selectedIndex == modeValue ? Colors.white : Colors.grey,
                        BlendMode.srcIn)),

                title: Text(modeData.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: selectedIndex == modeValue
                            ? Colors.white
                            : Colors.black)),

                trailing: CircleAvatar(
                  radius: 12,
                  backgroundColor: selectedIndex == modeValue
                      ? defaultColor
                      : Colors.grey.shade300,
                  child: CircleAvatar(
                    radius: selectedIndex == modeValue ? 5 : 10,
                    backgroundColor:
                        selectedIndex == modeValue ? mainColor : defaultColor,
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
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ))
      ],
    );
  }
}
