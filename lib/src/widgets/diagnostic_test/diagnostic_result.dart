import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/diagnostic_test/widgets/general_result_box.dart';
import 'package:flutter_abc_jsc_components/src/widgets/diagnostic_test/widgets/result_subject_tile.dart';

import '../../../flutter_abc_jsc_components.dart';

class SubjectResultData {
  final String title;
  final double progress;
  final String icon;

  SubjectResultData({
    required this.title,
    required this.progress,
    required this.icon,
  });
}

class DiagnosticResult extends StatelessWidget {
  final List<SubjectResultData> subjectList;
  final bool isDarkMode;

  final Color beginnerColor;
  final Color intermediateColor;
  final Color advancedColor;
  final Color beginnerBackgroundColor;
  final Color intermediateBackgroundColor;
  final Color advancedBackgroundColor;

  final String beginnerImage;
  final String intermediateImage;
  final String advancedImage;

  final String beginnerIcon;
  final String intermediateIcon;
  final String advancedIcon;

  final String circleProgressImage;
  final Color backgroundColor;
  final Color mainColor;
  final DateTime testDate;
  final double mainProgress;
  final void Function() onNext;

  const DiagnosticResult({
    super.key,
    this.beginnerColor = const Color(0xFFFC5656),
    this.intermediateColor = const Color(0xFFFF8754),
    this.advancedColor = const Color(0xFF2C9CB5),
    this.backgroundColor = const Color(0xFFF5F4EE),
    this.beginnerBackgroundColor = const Color(0xFFFF9B9B),
    this.intermediateBackgroundColor = const Color(0xFFFFA57E),
    this.advancedBackgroundColor = const Color(0xFF51DFFF),
    this.beginnerIcon = 'assets/images/beginner.svg',
    this.intermediateIcon = 'assets/images/intermediate.svg',
    this.advancedIcon = 'assets/images/advanced.svg',
    this.beginnerImage = 'assets/images/result_beginner.png',
    this.intermediateImage = 'assets/images/result_intermediate.png',
    this.advancedImage = 'assets/images/result_advanced.png',
    this.circleProgressImage = 'assets/images/progress_result.png',
    this.mainColor = const Color(0xFFE3A651),
    required this.subjectList,
    required this.onNext,
    required this.testDate,
    required this.mainProgress,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: isDarkMode ? Colors.black : backgroundColor,
        appBar: AppBar(
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
          title: Text(
            'Diagnostic Test',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GeneralResultBox(
                        isDarkMode: isDarkMode,
                        testDate: testDate,
                        mainProgress: mainProgress,
                        beginnerColor: beginnerColor,
                        intermediateColor: intermediateColor,
                        advancedColor: advancedColor,
                        beginnerBackgroundColor: beginnerBackgroundColor,
                        intermediateBackgroundColor:
                            intermediateBackgroundColor,
                        advancedBackgroundColor: advancedBackgroundColor,
                        circleProgressImage: circleProgressImage,
                        beginnerImage: beginnerImage,
                        intermediateImage: intermediateImage,
                        advancedImage: advancedImage,
                      ),

                      // List of subject results
                      _buildSubjectResultList()
                    ],
                  ),
                )),

                // Next button
                Container(
                    margin: const EdgeInsets.only(top: 15),
                    width: double.infinity,
                    child: MainButton(
                        title: 'Next',
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle: const TextStyle(fontSize: 20),
                        onPressed: () => onNext(),
                        backgroundColor: mainColor))
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildSubjectResultList() {
    subjectList.sort(
        (subject1, subject2) => subject1.progress < subject2.progress ? 0 : 1);

    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 8),
        itemCount: subjectList.length,
        itemBuilder: (_, index) {
          final currentSubject = subjectList[index];
          return ResultSubjectTile(
            isDarkMode: isDarkMode,
            title: currentSubject.title,
            icon: currentSubject.icon,
            progress: currentSubject.progress,
            color: _getLevelColor(currentSubject.progress),
            iconBackgroundColor:
                _getLevelBackgroundColor(currentSubject.progress),
            beginnerIcon: beginnerIcon,
            intermediateIcon: intermediateIcon,
            advancedIcon: advancedIcon,
          );
        });
  }

  Color _getLevelColor(double progress) {
    if (progress < 20) {
      return beginnerColor;
    } else if (progress < 80) {
      return intermediateColor;
    } else {
      return advancedColor;
    }
  }

  Color _getLevelBackgroundColor(double progress) {
    if (progress < 20) {
      return beginnerBackgroundColor;
    } else if (progress < 80) {
      return intermediateBackgroundColor;
    } else {
      return advancedBackgroundColor;
    }
  }
}
