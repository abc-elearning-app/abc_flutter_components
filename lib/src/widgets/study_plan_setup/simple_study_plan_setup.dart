import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/custom_datetime_picker/custom_time_picker.dart';
import 'package:flutter_abc_jsc_components/src/widgets/custom_datetime_picker/custom_unrestrict_date_picker.dart';

class SimpleStudyPlanSetupComponent extends StatefulWidget {
  final bool isDarkMode;

  final Color mainColor;
  final Color backgroundColor;

  final String dateImage;
  final String timeImage;

  const SimpleStudyPlanSetupComponent({
    super.key,
    required this.mainColor,
    required this.backgroundColor,
    required this.isDarkMode,
    required this.dateImage,
    required this.timeImage,
  });

  @override
  State<SimpleStudyPlanSetupComponent> createState() => _SimpleStudyPlanSetupComponentState();
}

class _SimpleStudyPlanSetupComponentState extends State<SimpleStudyPlanSetupComponent> with SingleTickerProviderStateMixin {
  late PageController pageController;
  late AnimationController buttonController;
  late Animation buttonAnimation;

  @override
  void initState() {
    pageController = PageController();
    buttonController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    buttonAnimation = Tween<double>(begin: 0, end: 50).animate(buttonController);
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
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            index == 0 ? 'When Is Your Exam?' : 'Would You Like To Set Study Reminders?',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Image.asset(index == 0 ? widget.dateImage : widget.timeImage, height: 250),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.symmetric(vertical: index == 0 ? 80 : 0),
                          child: index == 0 ? CustomUnrestrictedDatePicker(onSelectDate: (date) {}) : CustomTimePicker(onSelectTime: (time) {}),
                        ))
                      ],
                    ),
                  )),
                  SizedBox(
                    height: 120,
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
                                onPressed: () {
                                  if (pageController.page == 0) {
                                    pageController.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
                                    buttonController.forward();
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                },
                              )),
                          Expanded(
                            child: Padding(
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
                                      onPressed: () => Navigator.of(context).pop(),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
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
}
