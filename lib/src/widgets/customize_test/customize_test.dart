import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/customize_test/provider/customize_test_provider.dart';
import 'package:flutter_abc_jsc_components/src/widgets/customize_test/widgets/slider_tile.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../flutter_abc_jsc_components.dart';

import 'package:provider/provider.dart';

class CustomizeTestWrapper extends StatelessWidget {
  final Color mainColor;
  final Color defaultColor;
  final Color backgroundColor;
  final Color subjectIconColor;
  final Color subjectIconBackgroundColor;

  final bool isPro;
  final List<ModeData> modes;
  final List<CustomizeSubjectData> subjects;

  // Callback
  final void Function(
    int modeIndex,
    int questionCount,
    int duration,
    int passingScore,
    List<bool> subjectSelections,
  ) onStart;

  const CustomizeTestWrapper(
      {super.key,
      required this.mainColor,
      this.defaultColor = Colors.white,
      required this.backgroundColor,
      required this.subjectIconColor,
      required this.subjectIconBackgroundColor,
      required this.isPro,
      required this.modes,
      required this.subjects,
      required this.onStart});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CustomizeTestProvider(),
        child: CustomizeTest(
          mainColor: mainColor,
          backgroundColor: backgroundColor,
          defaultColor: defaultColor,
          isPro: isPro,
          subjectIconBackgroundColor: subjectIconBackgroundColor,
          subjectIconColor: subjectIconColor,
          modes: modes,
          subjects: subjects,
          onStart: onStart,
        ));
  }
}

class CustomizeTest extends StatelessWidget {
  final Color mainColor;
  final Color defaultColor;
  final Color backgroundColor;
  final Color subjectIconColor;
  final Color subjectIconBackgroundColor;

  final bool isPro;
  final List<ModeData> modes;
  final List<CustomizeSubjectData> subjects;

  final void Function(
    int modeIndex,
    int questionCount,
    int duration,
    int passingScore,
    List<bool> subjectSelections,
  ) onStart;

  const CustomizeTest(
      {super.key,
      required this.mainColor,
      this.defaultColor = Colors.white,
      required this.backgroundColor,
      required this.subjectIconColor,
      required this.subjectIconBackgroundColor,
      required this.isPro,
      required this.modes,
      required this.subjects,
      required this.onStart});

  @override
  Widget build(BuildContext context) {
    context.read<CustomizeTestProvider>().init(subjects.length);
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Answer mode
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Feedback Modes',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20)),
                      ),
                      ModeOptions(
                        modes: modes,
                        mainColor: mainColor,
                        defaultColor: defaultColor,
                      ),

                      // Select amount of questions
                      const Padding(
                        padding: EdgeInsets.only(left: 10, top: 20),
                        child: Text('Question Count',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20)),
                      ),
                      SliderTile(
                          type: SliderType.question,
                          mainColor: mainColor,
                          backgroundColor: defaultColor,
                          minValue: 10,
                          maxValue: 50),

                      // Select amount of minutes
                      const Padding(
                        padding: EdgeInsets.only(left: 10, top: 20),
                        child: Text('Duration (minutes)',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20)),
                      ),
                      SliderTile(
                          type: SliderType.duration,
                          mainColor: mainColor,
                          backgroundColor: defaultColor,
                          minValue: 10,
                          maxValue: 100),

                      // Select subjects
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Title
                            const Text('Subjects',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20)),

                            _buildSelectAllButton(context)
                          ],
                        ),
                      ),
                      SubjectsBox(
                        subjects: subjects,
                        mainColor: mainColor,
                        backgroundColor: defaultColor,
                        subjectIconColor: subjectIconColor,
                        subjectIconBackgroundColor: subjectIconBackgroundColor,
                      ),

                      // Select amount of mistakes
                      const Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: Text('Passing score (%)',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20)),
                      ),
                      SliderTile(
                          type: SliderType.passingScore,
                          mainColor: mainColor,
                          backgroundColor: defaultColor,
                          minValue: 10,
                          maxValue: 100),
                    ],
                  ),
                ),
              ),
              _buildStartButton(context)
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
        centerTitle: true,
        backgroundColor: backgroundColor,
        scrolledUnderElevation: 0,
        title: isPro
            ? const Text('Customize Test',
                style: TextStyle(fontWeight: FontWeight.w500))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Customize Test',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(width: 10),
                  SvgPicture.asset('assets/images/pro.svg'),
                ],
              ),
      );

  Widget _buildSelectAllButton(BuildContext context) => Row(
        children: [
          const Text('Select All',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
          const SizedBox(width: 10),
          Selector<CustomizeTestProvider, bool>(
            selector: (_, provider) => provider.allSubjectSelected,
            builder: (_, value, __) => Padding(
              padding: const EdgeInsets.only(right: 3),
              child: MyCheckBox(
                activeColor: mainColor,
                checkColor: mainColor,
                value: value,
                onChanged: (value) => context
                    .read<CustomizeTestProvider>()
                    .toggleAllSubjects(value),
              ),
            ),
          ),
        ],
      );

  Widget _buildStartButton(BuildContext context) {
    final provider = context.read<CustomizeTestProvider>();
    return Container(
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      child: MainButton(
        textStyle: const TextStyle(fontSize: 18),
        title: 'Start',
        backgroundColor: const Color(0xFFE3A651),
        onPressed: () => onStart(
          provider.selectedModeIndex,
          provider.selectedQuestions,
          provider.selectedDuration,
          provider.selectedPassingScore,
          provider.subjectSelection,
        ),
      ),
    );
  }
}
