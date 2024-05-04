import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../page_indicator/page_indicator.dart';

class IntroPersonalPlanData {
  final int index;
  final Widget image;
  final String title;
  final String subtitle;

  IntroPersonalPlanData({
    required this.index,
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

class IntroPersonalPlanPages extends StatefulWidget {
  final Color upperBackgroundColor;
  final Color lowerBackgroundColor;
  final Color mainColor;
  final Color buttonTextColor;
  final Color titleColor;
  final Color subTitleColor;
  final double buttonTextFontSize;
  final List<IntroPersonalPlanData> tabList;
  final String fontFamily;
  final void Function() onFinish;

  const IntroPersonalPlanPages(
      {super.key,
      this.upperBackgroundColor = const Color(0xFFEEFFFA),
      this.lowerBackgroundColor = Colors.white,
      this.mainColor = const Color(0xFF579E89),
      this.buttonTextColor = Colors.white,
      this.buttonTextFontSize = 20,
      this.titleColor = Colors.black,
      this.subTitleColor = Colors.grey,
      this.fontFamily = 'Poppins',
      required this.tabList,
      required this.onFinish});

  @override
  State<IntroPersonalPlanPages> createState() => _IntroPersonalPlanPagesState();
}

class _IntroPersonalPlanPagesState extends State<IntroPersonalPlanPages> {
  final _pageController = PageController(initialPage: 0, keepPage: true);
  final _pageIndex = ValueNotifier<double>(0);

  @override
  void initState() {
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
    return Stack(children: [
      Scaffold(
        body: Theme(
          data: ThemeData(fontFamily: widget.fontFamily),
          child: Stack(children: [
            _buildBackground(),
            Column(
              children: [
                // Images and Texts
                Expanded(
                  child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.tabList.length,
                      itemBuilder: (_, index) =>
                          _buildStudyPlanTab(context, index)),
                ),

                // Page indicator and button
                _buildNavigateSection()
              ],
            ),
          ]),
        ),
      ),

      // Debug back button
      if (kDebugMode && Platform.isIOS)
        Column(
          children: [
            const SizedBox(height: 100),
            IconButton(
                onPressed: () => Navigator.of(context).pop(context),
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.red,
                )),
          ],
        )
    ]);
  }

  Widget _buildBackground() => Column(
        children: [
          // Upper background
          Expanded(
            flex: 3,
            child: Stack(alignment: Alignment.center, children: [
              Container(color: widget.lowerBackgroundColor),
              Container(
                decoration: BoxDecoration(
                    color: widget.upperBackgroundColor,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(50))),
              ),
            ]),
          ),

          // Lower background
          Expanded(
            flex: 2,
            child: Stack(children: [
              Container(color: widget.upperBackgroundColor),
              Container(
                decoration: BoxDecoration(
                    color: widget.lowerBackgroundColor,
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
            child: widget.tabList[index].image,
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
                        color: widget.titleColor,
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
                          color: widget.subTitleColor,
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

  Widget _buildNavigateSection() => Container(
        padding: const EdgeInsets.all(30),
        color: widget.lowerBackgroundColor,
        child: Row(
          children: [
            // Page indicator
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: _pageIndex,
                  builder: (_, value, __) => PageIndicator(
                      pageCount: widget.tabList.length,
                      currentPage: value.toInt(),
                      color: widget.mainColor)),
            ),

            ElevatedButton(
              onPressed: () => _handleButtonClick(),
              style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                      fontFamily: widget.fontFamily,
                      fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  backgroundColor: widget.mainColor,
                  foregroundColor: widget.buttonTextColor),
              child: ValueListenableBuilder(
                valueListenable: _pageIndex,
                builder: (_, value, __) => Text(
                  _pageIndex.value != widget.tabList.length - 1
                      ? 'Next'
                      : 'Start',
                  style: TextStyle(fontSize: widget.buttonTextFontSize),
                ),
              ),
            )
          ],
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
