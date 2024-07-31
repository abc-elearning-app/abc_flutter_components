import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

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

class _SimpleStudyPlanSetupComponentState extends State<SimpleStudyPlanSetupComponent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Stack(
        children: [
          _buildBackground(),
          Column(
            children: [
              Expanded(
                  child: Column(
                children: [],
              )),
              SizedBox(
                height: 180,
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
                            onPressed: () {},
                          )),
                      const SizedBox(height: 10),
                      SizedBox(
                          width: double.infinity,
                          child: MainButton(
                            title: 'Not Now',
                            backgroundColor: Colors.transparent,
                            textColor: widget.isDarkMode ? Colors.white : Colors.black,
                            textStyle: const TextStyle(fontSize: 16),
                            onPressed: () {},
                          )),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
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
                height: 180,
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
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: widget.isDarkMode ? Colors.grey.shade800 : Colors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(60))),
              )
            ],
          )
        ],
      );
}
