import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_strings.dart';
import '../../../../constants/app_themes.dart';
import '../../../../providers/exam_simulator_provider.dart';

class SelectAnswerModeBlock extends StatelessWidget {
  const SelectAnswerModeBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<ExamSimulatorProvider, int>(
        selector: (context, provider) => provider.selectedMode,
        builder: (_, selectedMode, __) => Column(
              children: [
                _radioTile(context, AppStrings.extraTestsStrings.examSimNewbieMode, 0, selectedMode),
                _radioTile(context, AppStrings.extraTestsStrings.examSimFastMode, 1, selectedMode),
                _radioTile(context, AppStrings.extraTestsStrings.examSimExamMode, 2, selectedMode),
              ],
            ));
  }

  Widget _radioTile(BuildContext context, String title, int value, int groupValue) =>
      Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                color: context.isDarkMode
                    ? context.colorScheme.secondary
                    : context.colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: RadioListTile(
                controlAffinity: ListTileControlAffinity.trailing,
                secondary: IconButton(
                    icon: Icon(Icons.info_outline,
                        color: value ==
                                context.read<ExamSimulatorProvider>().selectedMode
                            ? context.colorScheme.primary
                            : Colors.grey.shade300),
                    onPressed: () {}),
                groupValue: groupValue,
                value: value,
                activeColor: context.colorScheme.primary,
                title: Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: context.isDarkMode
                            ? context.colorScheme.onSurface
                            : value == groupValue
                                ? context.colorScheme.primary
                                : context.colorScheme.secondary)),
                onChanged: (value) {
                  context.read<ExamSimulatorProvider>().selectedMode = value!;
                },
              ),
            ),
          ),
          AnimatedContainer(
            height: value == groupValue ? 50 : 0,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            child: Text(AppStrings.extraTestsStrings.examSimNewbieModeDetail),
          ),
        ],
      );
}
