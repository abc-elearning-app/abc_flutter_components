import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/diagnostic_test_result/widgets/general_result_box.dart';
import 'package:flutter_abc_jsc_components/src/widgets/diagnostic_test_result/widgets/subject_tile.dart';

class SubjectResultData {
  final String title;
  final double progress;
  final String icon;

  SubjectResultData(this.title, this.progress, this.icon);
}

class DiagnosticTestResult extends StatelessWidget {
  final List<SubjectResultData> subjectList;
  final Color boxColor;
  final Color beginnerColor;
  final Color intermediateColor;
  final Color advancedColor;
  final Color linearProgressColor;
  final String? beginnerImage;
  final String? intermediateImage;
  final String? advancedImage;
  final String? circleProgressImage;
  final Color backgroundColor;
  final Color mainColor;
  final double levelImageScale;
  final DateTime testDate;
  final double mainProgress;
  final void Function() onNext;

  const DiagnosticTestResult(
      {super.key,
      this.beginnerColor = const Color(0xFFFC5656),
      this.intermediateColor = const Color(0xFFFFB443),
      this.advancedColor = const Color(0xFF2C9CB5),
      required this.subjectList,
      this.backgroundColor = const Color(0xFFEEFFFA),
      this.mainColor = const Color(0xFF579E89),
      required this.onNext,
      this.boxColor = Colors.white,
      this.linearProgressColor = const Color(0xFF77C4FC),
      this.beginnerImage,
      this.intermediateImage,
      this.advancedImage,
      this.circleProgressImage,
      required this.testDate,
      this.levelImageScale = 1.2,
      required this.mainProgress});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: const Text(
          'Diagnostic Test',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    GeneralResultBox(
                      mainProgress: mainProgress,
                      boxColor: boxColor,
                      levelImageScale: levelImageScale,
                      linearProgressColor: linearProgressColor,
                      testDate: testDate,
                      beginnerColor: beginnerColor,
                      intermediateColor: intermediateColor,
                      advancedColor: advancedColor,
                      circleProgressImage: circleProgressImage,
                      beginnerImage: beginnerImage,
                      intermediateImage: intermediateImage,
                      advancedImage: advancedImage,
                    ),

                    // List of subject results
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: subjectList.length,
                        itemBuilder: (_, index) {
                          final current = subjectList[index];
                          return SubjectTile(
                              title: current.title,
                              boxColor: boxColor,
                              icon: current.icon,
                              progress: current.progress,
                              color: _getLevelColor(current.progress));
                        })
                  ],
                ),
              )),

              // Next button
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  child: MainButton(
                    title: 'Next',
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 20),
                    onPressed: () => onNext(),
                    backgroundColor: mainColor,
                  ))
            ],
          ),
        ),
      ),
    );
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
}
