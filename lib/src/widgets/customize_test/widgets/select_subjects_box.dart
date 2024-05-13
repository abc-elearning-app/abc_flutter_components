import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_themes.dart';
import '../../../../providers/exam_simulator_provider.dart';

class SelectSubjectBox extends StatelessWidget {
  const SelectSubjectBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: context.isDarkMode
            ? context.colorScheme.secondary
            : context.colorScheme.inversePrimary,
      ),
      child: Selector<ExamSimulatorProvider, List<SubjectData>>(
          selector: (_, provider) => provider.subjectList,
          builder: (_, value, __) => Column(
            children: [
              for (int index = 0; index < value.length; index++)
                _subjectTile(context, value[index].icon, value[index].title,
                    value[index].isSelected, index)
            ],
          )
      ),
    );
  }

  Widget _subjectTile(
      BuildContext context, String icon, String title, bool isSelected, int index) {
    return CheckboxListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        secondary: SvgPicture.asset(icon),
        value: isSelected,
        activeColor: context.colorScheme.primary,
        onChanged: (_) {
          context.read<ExamSimulatorProvider>().toggleSubjectSelection(index);
        });
  }
}
