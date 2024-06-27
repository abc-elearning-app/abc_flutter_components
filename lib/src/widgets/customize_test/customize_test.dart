import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/customize_test/provider/customize_test_provider.dart';
import 'package:flutter_abc_jsc_components/src/widgets/customize_test/widgets/slider_tile.dart';

import '../../../flutter_abc_jsc_components.dart';

import 'package:provider/provider.dart';

class CustomizeTestWrapper extends StatelessWidget {
  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;

  final bool isDarkMode;
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
      this.mainColor = const Color(0xFFE3A651),
      this.secondaryColor = const Color(0xFF7C6F5B),
      this.backgroundColor = const Color(0xFFF5F4EE),
      required this.isPro,
      required this.modes,
      required this.subjects,
      required this.onStart,
      required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CustomizeTestProvider(),
        child: CustomizeTest(
          mainColor: mainColor,
          secondaryColor: secondaryColor,
          backgroundColor: backgroundColor,
          isPro: isPro,
          modes: modes,
          subjects: subjects,
          onStart: onStart,
          isDarkMode: isDarkMode,
        ));
  }
}

class CustomizeTest extends StatelessWidget {
  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;

  final bool isDarkMode;
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
      required this.secondaryColor,
      required this.backgroundColor,
      required this.isPro,
      required this.isDarkMode,
      required this.modes,
      required this.subjects,
      required this.onStart});

  @override
  Widget build(BuildContext context) {
    context.read<CustomizeTestProvider>().init(subjects.length);
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: isDarkMode ? Colors.black : backgroundColor,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Feedback Modes',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: isDarkMode ? Colors.white : Colors.black,
                            )),
                      ),
                      ModeOptions(
                        modes: modes,
                        mainColor: mainColor,
                        isDarkMode: isDarkMode,
                      ),

                      // Select amount of questions
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 20),
                        child: Text('Question Count',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: isDarkMode ? Colors.white : Colors.black,
                            )),
                      ),
                      SliderTile(
                          type: SliderType.question,
                          mainColor: mainColor,
                          secondaryColor: secondaryColor,
                          isDarkMode: isDarkMode,
                          minValue: 10,
                          maxValue: 50),

                      // Select amount of minutes
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 20),
                        child: Text('Duration (minutes)',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: isDarkMode ? Colors.white : Colors.black,
                            )),
                      ),
                      SliderTile(
                          type: SliderType.duration,
                          mainColor: mainColor,
                          secondaryColor: secondaryColor,
                          isDarkMode: isDarkMode,
                          minValue: 10,
                          maxValue: 100),

                      // Select subjects
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Title
                            Text('Subjects',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                )),

                            _buildSelectAllButton(context)
                          ],
                        ),
                      ),
                      SubjectsBox(
                        subjects: subjects,
                        mainColor: mainColor,
                        secondaryColor: secondaryColor,
                        isDarkMode: isDarkMode,
                      ),

                      // Select amount of mistakes
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 20,
                        ),
                        child: Text('Passing score (%)',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color:
                                    isDarkMode ? Colors.white : Colors.black)),
                      ),
                      SliderTile(
                          type: SliderType.passingScore,
                          mainColor: mainColor,
                          secondaryColor: secondaryColor,
                          isDarkMode: isDarkMode,
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

  PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: isPro
            ? Text('Customize Test',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Customize Test',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: isDarkMode ? Colors.white : Colors.black)),
                  const SizedBox(width: 10),
                  Container(
                    width: 90,
                    height: 30,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.24)
                            : Colors.black,
                        borderRadius: BorderRadius.circular(16)),
                    child: Image.asset('assets/images/get_pro_text.png'),
                  ),
                ],
              ),
      );

  Widget _buildSelectAllButton(BuildContext context) => Row(
        children: [
          Text('Select All',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.black,
              )),
          const SizedBox(width: 10),
          Selector<CustomizeTestProvider, bool>(
            selector: (_, provider) => provider.allSubjectSelected,
            builder: (_, value, __) => Padding(
              padding: const EdgeInsets.only(right: 3),
              child: MyCheckBox(
                activeColor: mainColor,
                borderColor: mainColor,
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
