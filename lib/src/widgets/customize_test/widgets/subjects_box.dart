import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/customize_test/provider/customize_test_provider.dart';
import 'package:provider/provider.dart';

class CustomizeSubjectData {
  final String title;
  bool isSelected;
  String icon;

  CustomizeSubjectData({
    required this.icon,
    required this.title,
    this.isSelected = false,
  });
}

class SubjectsBox extends StatelessWidget {
  final List<CustomizeSubjectData> subjects;
  final Color mainColor;
  final Color secondaryColor;
  final bool isDarkMode;

  const SubjectsBox({
    super.key,
    required this.subjects,
    required this.mainColor,
    required this.secondaryColor,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: mainColor),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(isDarkMode ? 0.16 : 1),
        ),
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 5),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: subjects.length,
            itemBuilder: (_, index) =>
                _subjectTile(context, subjects[index], index)));
  }

  Widget _subjectTile(
    BuildContext context,
    CustomizeSubjectData subjectData,
    int index,
  ) {
    return GestureDetector(
      onTap: () => _toggle(context, index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 30,
              height: 30,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(8)
                ),
              child: IconWidget(icon: subjectData.icon, color: Colors.white, width: 24),
            ),
            const SizedBox(width: 15),
            // Title
            Expanded(
              child: Text(subjectData.title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: isDarkMode ? Colors.white : Colors.black,
                      overflow: TextOverflow.ellipsis)),
            ),

            // Checkbox
            Selector<CustomizeTestProvider, bool>(
                selector: (_, provider) => provider.subjectSelection[index],
                builder: (_, value, __) => MyCheckBox(
                    activeColor: mainColor,
                    fillColor: Colors.white.withOpacity(0.08),
                    borderColor:
                        isDarkMode ? Colors.white.withOpacity(0.16) : mainColor,
                    iconColor: Colors.white,
                    value: value,
                    onChanged: (_) => _toggle(context, index)))
          ],
        ),
      ),
    );
  }

  _toggle(BuildContext context, int index) =>
      context.read<CustomizeTestProvider>().toggleSubject(index);
}
