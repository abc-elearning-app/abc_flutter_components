import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/customize_test/widgets/select_answer_mode_block.dart';
import 'package:flutter_abc_jsc_components/src/widgets/customize_test/widgets/slider_tile.dart';
import 'package:provider/provider.dart';

class ExamSimulatorScreen extends StatelessWidget {
  const ExamSimulatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // color: context.colorScheme.background,
          // image: context.isDarkMode
          //     ? null
          //     : DecorationImage(
          //     image: AssetImage(AppAssets.imageAssets.appBackground),
          //     fit: BoxFit.cover)
          ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Customize Test',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Answer mode
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                              'HELLO EVERYONE',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black)),
                        ),
                        const SelectAnswerModeBlock(),

                        // Select amount of questions
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 20),
                          child: Text(
                              'How many questions',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        SliderTile(
                            minValue: 10,
                            maxValue: 50,
                            type: ValueType.question),

                        // Select amount of minutes
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 20),
                          child: Text(
                              AppStrings.extraTestsStrings.howManyMinutes,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        SliderTile(
                            minValue: 10,
                            maxValue: 100,
                            type: ValueType.minute),

                        // Select subjects
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppStrings.extraTestsStrings.subject,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Row(
                                children: [
                                  Selector<ExamSimulatorProvider,
                                          List<SubjectData>>(
                                      selector: (_, provider) =>
                                          provider.subjectList,
                                      builder: (_, value, __) => Checkbox(
                                          value: _getAllSubjectCheckBoxValue(
                                              value),
                                          onChanged: (value) => context
                                              .read<ExamSimulatorProvider>()
                                              .selectAllSubject(value!))),
                                  const Text('Select All',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SelectSubjectBox(),

                        // Select amount of mistakes
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 20),
                          child: Text(
                              AppStrings.extraTestsStrings.examSimPassRate,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        const SliderTile(
                            minValue: 10,
                            maxValue: 100,
                            type: ValueType.passRate),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: MainButton(
                    textStyle: const TextStyle(fontSize: 18),
                    title: AppStrings.extraTestsStrings.startTest,
                    backgroundColor: context.isDarkMode
                        ? context.colorScheme.secondary
                        : context.colorScheme.primary,
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Check if all subject is selected
  _getAllSubjectCheckBoxValue(List<SubjectData> list) =>
      list.where((e) => e.isSelected).length == list.length;
}
