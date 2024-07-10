import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/customize_test/provider/customize_test_provider.dart';
import 'package:flutter_abc_jsc_components/src/widgets/customize_test/widgets/slider_tile.dart';

import '../../../flutter_abc_jsc_components.dart';

import 'package:provider/provider.dart';

class CustomizeTestWrapper extends StatelessWidget {
  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final String getProTextImage;

  final bool isDarkMode;
  final bool isPro;
  final List<ModeData> modes;
  final List<CustomizeSubjectData> subjects;

  // Callback
  final void Function() onGetPro;
  final void Function(
    int modeIndex,
    int questionCount,
    int duration,
    int passingScore,
    List<bool> subjectSelections,
  ) onStart;

  const CustomizeTestWrapper({
    super.key,
    this.mainColor = const Color(0xFFE3A651),
    this.secondaryColor = const Color(0xFF7C6F5B),
    this.backgroundColor = const Color(0xFFF5F4EE),
    required this.getProTextImage,
    required this.isPro,
    required this.modes,
    required this.subjects,
    required this.onStart,
    required this.isDarkMode,
    required this.onGetPro,
  });

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
          onGetPro: onGetPro,
        ));
  }
}

class CustomizeTest extends StatefulWidget {
  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;

  final bool isDarkMode;
  final bool isPro;
  final List<ModeData> modes;
  final List<CustomizeSubjectData> subjects;

  final void Function() onGetPro;
  final void Function(
    int modeIndex,
    int questionCount,
    int duration,
    int passingScore,
    List<bool> subjectSelections,
  ) onStart;

  const CustomizeTest({
    super.key,
    required this.mainColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.isPro,
    required this.isDarkMode,
    required this.modes,
    required this.subjects,
    required this.onStart,
    required this.onGetPro,
  });

  @override
  State<CustomizeTest> createState() => _CustomizeTestState();
}

class _CustomizeTestState extends State<CustomizeTest> {
  @override
  void initState() {
    if (mounted) {
      context
          .read<CustomizeTestProvider>()
          .init(widget.subjects.length, widget.modes);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor:
          widget.isDarkMode ? Colors.black : widget.backgroundColor,
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
                              fontSize: 18,
                              color: _textColor(),
                            )),
                      ),
                      ModeOptions(
                        modes: widget.modes,
                        mainColor: widget.mainColor,
                        isDarkMode: widget.isDarkMode,
                      ),

                      // Select amount of questions
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 20),
                        child: Text('Question Count',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: _textColor(),
                            )),
                      ),
                      SliderTile(
                          type: SliderType.question,
                          mainColor: widget.mainColor,
                          secondaryColor: widget.secondaryColor,
                          isDarkMode: widget.isDarkMode,
                          minValue: 10,
                          maxValue: 50),

                      // Select amount of minutes
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 20),
                        child: Text('Duration (minutes)',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: _textColor(),
                            )),
                      ),
                      SliderTile(
                          type: SliderType.duration,
                          mainColor: widget.mainColor,
                          secondaryColor: widget.secondaryColor,
                          isDarkMode: widget.isDarkMode,
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
                                  fontSize: 18,
                                  color: _textColor(),
                                )),

                            _buildSelectAllButton(context)
                          ],
                        ),
                      ),
                      SubjectsBox(
                        subjects: widget.subjects,
                        mainColor: widget.mainColor,
                        secondaryColor: widget.secondaryColor,
                        isDarkMode: widget.isDarkMode,
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
                                fontSize: 18,
                                color: _textColor())),
                      ),
                      SliderTile(
                          type: SliderType.passingScore,
                          mainColor: widget.mainColor,
                          secondaryColor: widget.secondaryColor,
                          isDarkMode: widget.isDarkMode,
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
        backgroundColor:
            widget.isDarkMode ? Colors.black : widget.backgroundColor,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: widget.isPro
            ? _title()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _title(),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: widget.onGetPro,
                    child: Container(
                      width: 80,
                      height: 25,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: widget.isDarkMode
                              ? Colors.white.withOpacity(0.24)
                              : Colors.black,
                          borderRadius: BorderRadius.circular(16)),
                      child: const IconWidget(
                          icon: 'assets/images/get_pro_text.png'),
                    ),
                  ),
                ],
              ),
      );

  Widget _title() => Text('Customize Test',
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          color: widget.isDarkMode ? Colors.white : Colors.black));

  Widget _buildSelectAllButton(BuildContext context) => Row(
        children: [
          Text('Select All',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: widget.isDarkMode ? Colors.white : Colors.black,
              )),
          const SizedBox(width: 10),
          Selector<CustomizeTestProvider, bool>(
            selector: (_, provider) => provider.allSubjectSelected,
            builder: (_, value, __) => Padding(
              padding: const EdgeInsets.only(right: 3),
              child: MyCheckBox(
                activeColor: widget.mainColor,
                borderColor: widget.mainColor,
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
    return Stack(alignment: Alignment.center, children: [
      Selector<CustomizeTestProvider, bool>(
        selector: (_, provider) =>
            provider.subjectSelection.where((isSelected) => isSelected).isEmpty,
        builder: (_, value, __) => Container(
          margin: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: MainButton(
            title: 'Start Test',
            textStyle: const TextStyle(fontSize: 16),
            disabled: widget.isPro ? value : false,
            backgroundColor: Color.lerp(
                widget.mainColor, Colors.black, widget.isPro ? 0 : 0.5),
            onPressed: !widget.isPro
                ? widget.onGetPro
                : () => widget.onStart(
                      provider.selectedModeValue,
                      provider.selectedQuestions,
                      provider.selectedDuration,
                      provider.selectedPassingScore,
                      provider.subjectSelection,
                    ),
          ),
        ),
      ),
      if (!widget.isPro) const Icon(Icons.lock, size: 30, color: Colors.white)
    ]);
  }

  _textColor() => widget.isDarkMode ? Colors.white : Colors.black;
}
