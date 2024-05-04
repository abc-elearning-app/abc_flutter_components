import 'pages/select_exam_date.dart';
import 'pages/select_reminder_time_page.dart';
import 'pages/start_diagnostic_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ExamTimeSelectPages extends StatefulWidget {
  final List<Widget> pageImages;
  final Color upperBackgroundColor;
  final Color lowerBackgroundColor;
  final Color mainColor;
  final Color appBarColor;
  final Color optionBoxFillColor;
  final Color mainButtonTextColor;
  final Color notNowButtonTextColor;
  final bool showBackButton;

  // Callbacks
  final void Function() onStartDiagnostic;
  final void Function() onSkipDiagnostic;
  final void Function(DateTime selectedDate) onSelectExamDate;
  final void Function(TimeOfDay selectedReminderTime) onSelectReminderTime;

  const ExamTimeSelectPages(
      {super.key,
      required this.pageImages,
      this.upperBackgroundColor = const Color(0xFFEEFFFA),
      this.lowerBackgroundColor = Colors.white,
      this.mainColor = const Color(0xFF579E89),
      this.mainButtonTextColor = Colors.white,
      this.notNowButtonTextColor = Colors.black,
      this.showBackButton = false,
      required this.onStartDiagnostic,
      required this.onSkipDiagnostic,
      required this.onSelectExamDate,
      required this.onSelectReminderTime,
      this.appBarColor = Colors.black,
      this.optionBoxFillColor = Colors.white});

  @override
  State<ExamTimeSelectPages> createState() => _ExamTimeSelectPagesState();
}

class _ExamTimeSelectPagesState extends State<ExamTimeSelectPages> {
  final List<Widget> tabList = [];
  final pageController = PageController(keepPage: true);
  final pageIndex = ValueNotifier(-1);

  // To store selected date and time at multiple screen
  Map<String, dynamic> selectedTime = {};

  @override
  void initState() {
    tabList.addAll([
      SelectExamDatePage(
        showBackButton: widget.showBackButton,
        title: 'When Is Your Exam ?',
        image: widget.pageImages[0],
        mainColor: widget.mainColor,
        appBarColor: widget.appBarColor,
        optionBoxFillColor: widget.optionBoxFillColor,
        pageController: pageController,
        selectedTime: selectedTime,
        pageIndex: pageIndex,
      ),
      SelectReminderTimePage(
        showBackButton: widget.showBackButton,
        title: 'Would You Like To Set Study Reminders?',
        image: widget.pageImages[1],
        selectedTime: selectedTime,
        pageController: pageController,
      ),
      StartDiagnosticPage(
          pageController: pageController,
          showBackButton: widget.showBackButton,
          title: 'Diagnostic Test',
          subTitle:
              'Take our diagnostic test to assess your current level and get a personalized study plan.',
          image: widget.pageImages[1])
    ]);

    // Initial selected time
    selectedTime['exam_date'] = DateTime.now().toIso8601String();
    selectedTime['reminder_hour'] = TimeOfDay.now().hour.toString();
    selectedTime['reminder_minute'] = TimeOfDay.now().minute.toString();

    pageController.addListener(() {
      if (pageController.page == 0) {
        pageIndex.value = -1;
      } else {
        pageIndex.value = pageController.page!.toInt();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    pageIndex.dispose();
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
                  itemCount: tabList.length,
                  itemBuilder: (_, index) => tabList[index])
            ]),
          ),

          // Dynamic lower background
          ValueListenableBuilder(
              valueListenable: pageIndex,
              builder: (_, value, __) => AnimatedContainer(
                    height: value == -1
                        ? 0
                        : MediaQuery.of(context).size.height * 0.2,
                    duration: const Duration(milliseconds: 200),
                    child: Stack(children: [
                      // Background
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
                              _buildNextButton(value),
                              _buildNotNowButton(value),
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

  Widget _buildNextButton(int pageIndexValue) => Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
          onPressed: () => _handleMainButtonClick(),
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: widget.mainColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          child: Text(
            _getButtonText(pageIndexValue),
            style: TextStyle(fontSize: 20, color: widget.mainButtonTextColor),
          ),
        ),
      );

  Widget _buildNotNowButton(int pageIndexValue) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: pageIndexValue < 1 ? 0 : 50,
        //show after 1st page
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
      );

  _handleMainButtonClick() {
    //if not last page
    if (pageController.page != 2) {
      if (pageController.page == 0) {
        widget.onSelectExamDate(DateTime.parse(selectedTime['exam_date']));
      } else if (pageController.page == 1) {
        widget.onSelectReminderTime(TimeOfDay(
            hour: int.parse(selectedTime['reminder_hour']),
            minute: int.parse(selectedTime['reminder_minute'])));
      }

      pageController.nextPage(
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
    // If at last page
    else {
      widget.onStartDiagnostic();
    }
  }

  _handleNotNowButtonClick() {
    if (pageController.page == 1) {
      // Skip reminder
      pageController.nextPage(
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    } else {
      // Skip diagnostic
      widget.onSkipDiagnostic();
    }
  }

  _getButtonText(int value) {
    switch (value) {
      case 0:
        return 'Next';
      case 1:
        return 'Set Reminder (Recommended)';
      case 2:
        return 'Start Diagnostic Test';
      default:
        return '';
    }
  }
}

class RightOnlyScrollPhysics extends ScrollPhysics {
  const RightOnlyScrollPhysics({super.parent});

  @override
  RightOnlyScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return RightOnlyScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double offset) {
    // Block leftward swipes by returning the offset, indicating a boundary
    if (offset < 0) {
      return offset; // Block leftward swipes
    }
    return 0; // Allow rightward swipes
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Block user-initiated leftward swipes
    if (offset < 0) {
      return 0; // No movement allowed
    }
    return offset; // Allow rightward swipes
  }
}
