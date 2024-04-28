import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/exam_time_setup/select_exam_date_page.dart';
import 'package:flutter_abc_jsc_components/src/widgets/exam_time_setup/select_reminder_time_page.dart';
import 'package:flutter_abc_jsc_components/src/widgets/exam_time_setup/start_diagnostic_page.dart';

import 'date_option_page.dart';

class ExamDateSelectPages extends StatefulWidget {
  final List<Widget> pageImages;
  final Color upperBackgroundColor;
  final Color lowerBackgroundColor;
  final Color mainColor;

  const ExamDateSelectPages({
    super.key,
    required this.pageImages,
    this.upperBackgroundColor = const Color(0xFFEEFFFA),
    this.lowerBackgroundColor = Colors.white,
    this.mainColor = const Color(0xFF579E89),
  });

  @override
  State<ExamDateSelectPages> createState() => _ExamDateSelectPagesState();
}

class _ExamDateSelectPagesState extends State<ExamDateSelectPages> {
  List<Widget> tabList = [];
  final pageController = PageController(keepPage: true);
  final _pageIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    tabList = [
      DateOptionPage(
        title: 'When Is Your Exam ?',
        image: widget.pageImages[0],
        pageController: pageController,
      ),
      SelectExamDatePage(
        title: 'When Is Your Exam ?',
        image: widget.pageImages[1],
        pageController: pageController,
      ),
      SelectReminderTimePage(
          title: 'Would you like to set study reminders ?',
          image: widget.pageImages[2],
          pageController: pageController),
      StartDiagnosticPage(
          title: 'Diagnostic Test',
          subTitle:
              'Take our diagnostic test to assess your current level and get a personalized study plan.',
          image: widget.pageImages[3])
    ];

    pageController.addListener(() {
      _pageIndex.value = pageController.page!.toInt();
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    _pageIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEFFFA),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(alignment: Alignment.center, children: [
              Container(color: widget.lowerBackgroundColor),
              Container(
                decoration: BoxDecoration(
                    color: widget.upperBackgroundColor,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(50))),
              ),
              PageView.builder(
                  // physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  itemCount: 4,
                  itemBuilder: (_, index) => tabList[index])
            ]),
          ),
          ValueListenableBuilder(
              valueListenable: _pageIndex,
              builder: (_, value, __) => AnimatedContainer(
                    height: value == 0
                        ? 0
                        : MediaQuery.of(context).size.height * 0.2,
                    duration: const Duration(milliseconds: 200),
                    child: Stack(children: [
                      Container(color: widget.upperBackgroundColor),
                      Container(
                        decoration: BoxDecoration(
                            color: widget.lowerBackgroundColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50))),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.95,
                              child: ElevatedButton(
                                onPressed: () {
                                  pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeInOut);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    backgroundColor: widget.mainColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                child: Text(
                                  _getButtonText(value),
                                  style: const TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            if (value > 1)
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: const Text(
                                      'Not Now',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300),
                                    )),
                              )
                          ],
                        ),
                      )
                    ]),
                  ))
        ],
      ),
    );
  }

  _getButtonText(int value) {
    switch (value) {
      case 1:
        return 'Next';
      case 2:
        return 'Set Reminder (Recommended)';
      case 3:
        return 'Start Diagnostic Test';
      default:
        return '';
    }
  }
}
