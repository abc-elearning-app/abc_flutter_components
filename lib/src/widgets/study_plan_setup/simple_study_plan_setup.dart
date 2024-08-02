import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/custom_datetime_picker/custom_time_picker.dart';

import '../custom_datetime_picker/custom_date_picker.dart';

class SimpleStudyPlanSetupComponent extends StatefulWidget {
  final bool isDarkMode;
  final bool showSetupReminder;

  final Color mainColor;
  final Color backgroundColor;

  final String dateImage;
  final String timeImage;

  final void Function(DateTime date) onSetExamDate;
  final void Function(TimeOfDay? date) onSetReminder;

  const SimpleStudyPlanSetupComponent({
    super.key,
    required this.mainColor,
    required this.backgroundColor,
    required this.isDarkMode,
    required this.dateImage,
    required this.timeImage,
    required this.onSetExamDate,
    required this.onSetReminder,
    required this.showSetupReminder,
  });

  @override
  State<SimpleStudyPlanSetupComponent> createState() => _SimpleStudyPlanSetupComponentState();
}

class _SimpleStudyPlanSetupComponentState extends State<SimpleStudyPlanSetupComponent> with SingleTickerProviderStateMixin {
  late PageController pageController;
  late AnimationController buttonController;
  late Animation buttonAnimation;

  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    pageController = PageController();
    buttonController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    buttonAnimation = Tween<double>(begin: 0, end: 50).animate(buttonController);

    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: widget.isDarkMode ? [Colors.black, Colors.grey.shade800] : [widget.backgroundColor, Colors.white],
                begin: AlignmentDirectional.topCenter,
                end: Alignment.bottomCenter)),
        child: SafeArea(
          child: Stack(
            children: [
              _buildBackground(),
              Column(
                children: [
                  Expanded(
                      child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    itemCount: 2,
                    itemBuilder: (_, index) => Column(
                      children: [
                        // Title
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            index == 0 ? 'When Is Your Exam?' : 'Would You Like To Set Study Reminders?',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                        ),

                        // Image
                        Image.asset(index == 0 ? widget.dateImage : widget.timeImage, height: MediaQuery.of(context).size.height * 0.3),

                        // Date and time picker
                        Expanded(
                          child: Column(
                            children: [
                              const Expanded(child: SizedBox()),
                              SizedBox(
                                height: 160,
                                child: index == 0
                                    ? CustomDatePicker(onSelectDate: (date) => selectedDate = date)
                                    : CustomTimePicker(onSelectTime: (time) => selectedTime = time),
                              ),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),

                  // Next and skip button
                  _buildButtons(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() => Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: widget.isDarkMode ? Colors.grey.shade800 : Colors.white,
                ),
              ),
              Container(
                height: 150,
                width: double.infinity,
                color: widget.isDarkMode ? Colors.black : widget.backgroundColor,
              )
            ],
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: widget.isDarkMode ? Colors.black : widget.backgroundColor,
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(60))),
                ),
              ),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: widget.isDarkMode ? Colors.grey.shade800 : Colors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(60))),
              )
            ],
          )
        ],
      );

  Widget _buildButtons() => SizedBox(
    height: 130,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: double.infinity,
              child: MainButton(
                title: 'Next',
                backgroundColor: widget.mainColor,
                textColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18),
                padding: const EdgeInsets.symmetric(vertical: 15),
                onPressed: _onSelect,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: AnimatedBuilder(
              animation: buttonAnimation,
              builder: (_, __) => SizedBox(
                  height: buttonAnimation.value,
                  width: double.infinity,
                  child: MainButton(
                    title: 'Not Now',
                    backgroundColor: Colors.transparent,
                    textColor: widget.isDarkMode ? Colors.white : Colors.black,
                    textStyle: const TextStyle(fontSize: 16),
                    onPressed: () => widget.onSetReminder(null),
                  )),
            ),
          ),
        ],
      ),
    ),
  );

  _onSelect() {
    if (pageController.page == 0) {
      widget.onSetExamDate(selectedDate);

      if (widget.showSetupReminder) {
        pageController.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
        buttonController.forward();
      } else {
        widget.onSetReminder(null);
      }
    } else {
      widget.onSetReminder(TimeOfDay(hour: selectedTime.hour, minute: selectedTime.minute + 1));
    }
  }
}
