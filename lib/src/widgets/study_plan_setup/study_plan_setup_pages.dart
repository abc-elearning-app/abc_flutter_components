import 'pages/select_exam_date.dart';
import 'pages/select_reminder_time_page.dart';
import 'pages/start_diagnostic_page.dart';
import 'package:flutter/material.dart';

class StudyPlanSetupComponent extends StatefulWidget {
  final List<String> pageImages;
  final bool isDarkMode;
  final Color upperBackgroundColor;
  final Color lowerBackgroundColor;
  final Color mainColor;
  final Color secondaryColor;

  // Callbacks
  final void Function() onStartDiagnostic;
  final void Function() onSkipDiagnostic;
  final void Function() onSkipSetup;
  final void Function() onSkipNotification;
  final void Function(DateTime selectedDate) onSelectExamDate;
  final void Function(TimeOfDay selectedReminderTime) onSelectReminderTime;

  const StudyPlanSetupComponent({
    super.key,
    required this.pageImages,
    this.upperBackgroundColor = const Color(0xFFF5F4EE),
    this.lowerBackgroundColor = Colors.white,
    this.mainColor = const Color(0xFFE3A651),
    this.secondaryColor = const Color(0xFF7C6F5B),
    required this.onStartDiagnostic,
    required this.onSkipDiagnostic,
    required this.onSelectExamDate,
    required this.onSelectReminderTime,
    required this.onSkipSetup,
    required this.isDarkMode,
    required this.onSkipNotification,
  });

  @override
  State<StudyPlanSetupComponent> createState() => _StudyPlanSetupComponentState();
}

class _StudyPlanSetupComponentState extends State<StudyPlanSetupComponent> {
  late List<Widget> _tabList;
  late PageController _pageController;
  late ValueNotifier<int> _pageIndex;

  // To store selected date and time at multiple screen
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  bool examDateSelected = false;

  @override
  void initState() {
    _pageController = PageController(keepPage: true);
    _pageIndex = ValueNotifier(-1);

    _tabList = [
      SelectExamDatePage(
        title: 'When Is Your Exam ?',
        isDarkMode: widget.isDarkMode,
        image: widget.pageImages[0],
        mainColor: widget.mainColor,
        secondaryColor: widget.secondaryColor,
        onSelectDate: (selectedDate) {
          examDateSelected = true;
          this.selectedDate = selectedDate;
        },
        onSelectOption: (optionIndex) {
          if (optionIndex == 0) {
            _pageIndex.value = 0;
          } else {
            // Delay for smoother animation
            Future.delayed(const Duration(milliseconds: 200), () {
              _pageController.animateToPage(2, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
            });
          }
        },
      ),
      SelectReminderTimePage(
        title: 'Would You Like To Set Study Reminders?',
        isDarkMode: widget.isDarkMode,
        image: widget.pageImages[1],
        onSelectTime: (selectedTime) => this.selectedTime = selectedTime,
      ),
      StartDiagnosticPage(
        isDarkMode: widget.isDarkMode,
        image: widget.pageImages[2],
        title: 'Diagnostic Test',
        subTitle: 'Take our diagnostic test to assess your current level and get a personalized study plan.',
      )
    ];

    _pageController.addListener(() {
      if (_pageController.page == 0) {
        _pageIndex.value = -1;
      } else {
        _pageIndex.value = _pageController.page!.toInt();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
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
              Container(color: widget.isDarkMode ? Colors.grey.shade800 : widget.lowerBackgroundColor),
              Container(
                decoration: BoxDecoration(
                    color: widget.isDarkMode ? Colors.black : widget.upperBackgroundColor,
                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(50))),
              ),

              // Main content
              PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  itemCount: _tabList.length,
                  itemBuilder: (_, index) => _tabList[index])
            ]),
          ),

          // Dynamic lower background
          ValueListenableBuilder(
              valueListenable: _pageIndex,
              builder: (_, value, __) => AnimatedContainer(
                    height: value == -1 ? 0 : MediaQuery.of(context).size.height * 0.2,
                    duration: const Duration(milliseconds: 200),
                    child: Stack(children: [
                      // Background
                      Container(color: widget.isDarkMode ? Colors.black : widget.upperBackgroundColor),
                      Container(
                        decoration: BoxDecoration(
                            color: widget.isDarkMode ? Colors.grey.shade800 : widget.lowerBackgroundColor,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(50))),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          child: Text(
            _getButtonText(pageIndexValue),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
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
              style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black, fontSize: 16, fontWeight: FontWeight.w300),
            )),
      );

  _handleMainButtonClick() {
    switch (_pageController.page) {
      case 0:
        {
          widget.onSelectExamDate(selectedDate);
          _pageController.nextPage(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
          break;
        }
      case 1:
        {
          widget.onSelectReminderTime(selectedTime);
          _pageController.nextPage(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        }
      default:
        {
          widget.onStartDiagnostic();
        }
    }
  }

  _handleNotNowButtonClick() {
    if (_pageController.page == 1) {
      // Skip reminder
      _pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
      widget.onSkipNotification();
    } else {
      // Skip diagnostic
      if (examDateSelected) {
        widget.onSkipDiagnostic();
      } else {
        // If user not setup study plan
        widget.onSkipSetup();
      }
    }
  }

  _getButtonText(int value) {
    switch (value) {
      case 1:
        return 'Set Reminder (Recommended)';
      case 2:
        return 'Start Diagnostic Test';
      default:
        return 'Next';
    }
  }
}
