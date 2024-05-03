import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/exam_time_setup/pages/date_option_page.dart';
import 'package:flutter_abc_jsc_components/src/widgets/exam_time_setup/pages/select_exam_date_page.dart';
import 'package:flutter_abc_jsc_components/src/widgets/exam_time_setup/pages/select_reminder_time_page.dart';
import 'package:flutter_abc_jsc_components/src/widgets/exam_time_setup/pages/start_diagnostic_page.dart';

class ExamDateSelectPages extends StatefulWidget {
  final List<Widget> pageImages;
  final Color upperBackgroundColor;
  final Color lowerBackgroundColor;
  final Color mainColor;
  final Color appBarColor;
  final Color optionBoxFillColor;
  final Color mainButtonTextColor;
  final Color notNowButtonTextColor;

  // Callbacks
  final void Function() onStartDiagnostic;
  final void Function() onSkipDiagnostic;
  final void Function(DateTime selectedDate) onSelectExamDate;
  final void Function(TimeOfDay selectedReminderTime) onSelectReminderTime;

  const ExamDateSelectPages(
      {super.key,
        required this.pageImages,
        this.upperBackgroundColor = const Color(0xFFEEFFFA),
        this.lowerBackgroundColor = Colors.white,
        this.mainColor = const Color(0xFF579E89),
        this.mainButtonTextColor = Colors.white,
        this.notNowButtonTextColor = Colors.black,
        required this.onStartDiagnostic,
        required this.onSkipDiagnostic,
        required this.onSelectExamDate,
        required this.onSelectReminderTime,
        this.appBarColor = Colors.black,
        this.optionBoxFillColor = Colors.white});

  @override
  State<ExamDateSelectPages> createState() => _ExamDateSelectPagesState();
}

class _ExamDateSelectPagesState extends State<ExamDateSelectPages> {
  List<Widget> tabList = [];
  final pageController = PageController(keepPage: true);
  final _pageIndex = ValueNotifier<int>(0);

  Map<String, dynamic> selectedTime = {};

  @override
  void initState() {
    tabList = [
      DateOptionPage(
        title: 'When Is Your Exam ?',
        image: widget.pageImages[0],
        mainColor: widget.mainColor,
        appBarColor: widget.appBarColor,
        optionBoxFillColor: widget.optionBoxFillColor,
        pageController: pageController,
      ),
      SelectExamDatePage(
          title: 'When Is Your Exam ?',
          image: widget.pageImages[1],
          pageController: pageController,
          selectedTime: selectedTime),
      SelectReminderTimePage(
        title: 'Would you like to set study reminders ?',
        image: widget.pageImages[2],
        selectedTime: selectedTime,
        pageController: pageController,
      ),
      StartDiagnosticPage(
          title: 'Diagnostic Test',
          subTitle:
          'Take our diagnostic test to assess your current level and get a personalized study plan.',
          image: widget.pageImages[3])
    ];

    // Initial selected time
    selectedTime['exam_date'] = DateTime.now().toIso8601String();
    selectedTime['reminder_hour'] = TimeOfDay.now().hour.toString();
    selectedTime['reminder_minute'] = TimeOfDay.now().minute.toString();

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
      body: Column(
        children: [
          // Upper background
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

              // Main content
              PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  itemCount: 4,
                  itemBuilder: (_, index) => tabList[index])
            ]),
          ),

          // Dynamic lower background
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

                  // Buttons
                  Center(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Next button
                          Container(
                            width: double.infinity,
                            margin:
                            const EdgeInsets.symmetric(horizontal: 10),
                            child: ElevatedButton(
                              onPressed: () => _handleMainButtonClick(),
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15),
                                  backgroundColor: widget.mainColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(15))),
                              child: Text(
                                _getButtonText(value),
                                style: TextStyle(
                                    fontSize: 22,
                                    color: widget.mainButtonTextColor),
                              ),
                            ),
                          ),

                          // Not now button
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: double.infinity,
                            height: value <= 1 ? 0 : 50,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: ElevatedButton(
                                onPressed: () => _handleNotNowButtonClick(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Not Now',
                                  style: TextStyle(
                                      color: widget.notNowButtonTextColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                )),
                          )
                        ],
                      ),
                    ),
                  )
                ]),
              ))
        ],
      ),
    );
  }

  _handleMainButtonClick() {
    if (pageController.page != 3) {
      if (pageController.page == 1) {
        widget.onSelectExamDate(DateTime.parse(selectedTime['exam_date']));
      } else if (pageController.page == 2) {
        widget.onSelectReminderTime(TimeOfDay(
            hour: int.parse(selectedTime['reminder_hour']),
            minute: int.parse(selectedTime['reminder_minute'])));
      }
      pageController.nextPage(
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    } else {
      widget.onStartDiagnostic();
    }
  }

  _handleNotNowButtonClick() {
    if (pageController.page == 2) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    } else {
      widget.onSkipDiagnostic();
    }
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
