import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/customize_test/provider/customize_test_provider.dart';
import 'package:flutter_abc_jsc_components/src/widgets/icons/icon_box.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final Color backgroundColor;
  final Color subjectIconColor;
  final Color subjectIconBackgroundColor;

  const SubjectsBox({
    super.key,
    required this.subjects,
    required this.mainColor,
    required this.backgroundColor,
    required this.subjectIconColor,
    required this.subjectIconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: mainColor),
          borderRadius: BorderRadius.circular(20),
          color: backgroundColor,
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
            IconBox(
                iconColor: subjectIconColor,
                backgroundColor: subjectIconBackgroundColor,
                icon: 'assets/images/subject_icon_$index.svg'),
            const SizedBox(width: 15),

            // Title
            Expanded(
              child: Text(subjectData.title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis)),
            ),

            // Checkbox
            Selector<CustomizeTestProvider, bool>(
                selector: (_, provider) => provider.subjectSelection[index],
                builder: (_, value, __) => MyCheckBox(
                    activeColor: mainColor,
                    checkColor: mainColor,
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
