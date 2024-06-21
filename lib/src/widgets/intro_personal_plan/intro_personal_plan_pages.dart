import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class IntroPersonalPlanData {
  final int index;
  final String image;
  final String imageDark;
  final String title;
  final String subtitle;

  IntroPersonalPlanData({
    required this.index,
    required this.image,
    required this.imageDark,
    required this.title,
    required this.subtitle,
  });
}

class IntroPersonalPlanPages extends StatefulWidget {
  final Color upperBackgroundColor;
  final Color lowerBackgroundColor;
  final Color mainColor;
  final Color buttonTextColor;
  final double buttonTextFontSize;
  final bool isDarkMode;

  final List<IntroPersonalPlanData> tabList;
  final void Function() onFinish;

  const IntroPersonalPlanPages(
      {super.key,
      this.upperBackgroundColor = const Color(0xFFF5F4EE),
      this.lowerBackgroundColor = Colors.white,
      this.mainColor = const Color(0xFFE3A651),
      this.buttonTextColor = Colors.white,
      this.buttonTextFontSize = 20,
      required this.tabList,
      required this.onFinish,
      required this.isDarkMode});

  @override
  State<IntroPersonalPlanPages> createState() => _IntroPersonalPlanPagesState();
}

class _IntroPersonalPlanPagesState extends State<IntroPersonalPlanPages> {
  late PageController _pageController;
  late ValueNotifier _pageIndex;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _pageIndex = ValueNotifier<double>(0);

    _pageController.addListener(() {
      _pageIndex.value = _pageController.page!;
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
      body: Stack(children: [
        _buildBackground(),
        SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.tabList.length,
                      itemBuilder: (_, index) =>
                          _buildStudyPlanTab(context, index))),
              _buildNavigateSection()
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildBackground() => Column(
        children: [
          // Upper background
          Expanded(
            flex: 3,
            child: Stack(alignment: Alignment.center, children: [
              if (widget.isDarkMode) Container(color: Colors.black),
              Container(
                  color: widget.isDarkMode
                      ? Colors.white.withOpacity(0.16)
                      : widget.lowerBackgroundColor),
              Container(
                decoration: BoxDecoration(
                    color: widget.isDarkMode
                        ? Colors.black
                        : widget.upperBackgroundColor,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(50))),
              ),
            ]),
          ),

          // Lower background
          Expanded(
            flex: 2,
            child: Stack(children: [
              Container(
                  color: widget.isDarkMode
                      ? Colors.black
                      : widget.upperBackgroundColor),
              Container(
                decoration: BoxDecoration(
                    color: widget.isDarkMode
                        ? Colors.white.withOpacity(0.16)
                        : widget.lowerBackgroundColor,
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(50))),
              ),
            ]),
          )
        ],
      );

  Widget _buildStudyPlanTab(BuildContext context, int index) => Column(
        children: [
          // Upper part
          Expanded(
            flex: 9,
            child: SizedBox(
              width: 300,
              child: Image.asset(
                widget.isDarkMode
                    ? widget.tabList[index].imageDark
                    : widget.tabList[index].image,
              ),
            ),
          ),

          // Page indicator and button
          Expanded(
            flex: 4,
            child: Column(
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                  child: Text(
                    widget.tabList[index].title,
                    style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  // Scroll view for small screen
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        widget.tabList[index].subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.isDarkMode
                              ? Colors.white.withOpacity(0.6)
                              : const Color(0xFF3C3C3C).withOpacity(0.52),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );

  Widget _buildNavigateSection() => ValueListenableBuilder(
        valueListenable: _pageIndex,
        builder: (_, value, __) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PageIndicator(
                  pageCount: widget.tabList.length,
                  currentPage: value.toInt(),
                  color: widget.mainColor),
              SizedBox(
                height: 55,
                width: 160,
                child: MainButton(
                  title: value != widget.tabList.length - 1 ? 'Next' : 'Start',
                  backgroundColor: widget.mainColor,
                  onPressed: _handleButtonClick,
                  textStyle: TextStyle(fontSize: widget.buttonTextFontSize),
                ),
              )
            ],
          ),
        ),
      );

  _handleButtonClick() {
    if (_pageController.page != widget.tabList.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    } else {
      widget.onFinish();
    }
  }
}
