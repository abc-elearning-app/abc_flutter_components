import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SubjectData {
  final String title;
  bool isSelected;
  String icon;

  SubjectData({required this.icon, required this.title, this.isSelected = false});
}

class SelectSubjectBox extends StatelessWidget {
  const SelectSubjectBox({super.key});

  @override
  Widget build(BuildContext context) {
    final tmpList = <SubjectData>[];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // color: context.isDarkMode
        //     ? context.colorScheme.secondary
        //     : context.colorScheme.inversePrimary,
      ),
      child: Column(
        children: [
          for (int index = 0; index < tmpList.length; index++)
            _subjectTile(context, tmpList[index].icon, tmpList[index].title,
                tmpList[index].isSelected, index)
        ],
      ),
    );
  }

  Widget _subjectTile(
      BuildContext context, String icon, String title, bool isSelected, int index) {
    return CheckboxListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        secondary: SvgPicture.asset(icon),
        value: isSelected,
        // activeColor: context.colorScheme.primary,
        onChanged: (_) {
          // context.read<ExamSimulatorProvider>().toggleSubjectSelection(index);
        });
  }
}
