import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/page_indicator/page_indicator.dart';

class IntroStudyPlanData {
  final int index;
  final Widget image;
  final String title;
  final String subtitle;

  IntroStudyPlanData({
    required this.index,
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

class IntroStudyPlanPages extends StatefulWidget {
  final Color upperBackgroundColor;
  final Color lowerBackgroundColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final double buttonTextFontSize;
  final List<IntroStudyPlanData> tabList;
  final String? fontFamily;
  final void Function() onFinish;

  const IntroStudyPlanPages(
      {super.key,
      required this.upperBackgroundColor,
      required this.lowerBackgroundColor,
      required this.buttonColor,
      required this.buttonTextColor,
      required this.buttonTextFontSize,
      this.fontFamily,
      required this.tabList,
      required this.onFinish});

  @override
  State<IntroStudyPlanPages> createState() => _IntroStudyPlanPagesState();
}

class _IntroStudyPlanPagesState extends State<IntroStudyPlanPages> {
  late PageController _pageController;

  final _pageIndex = ValueNotifier<double>(0);

  @override
  void initState() {
    _pageController = PageController(keepPage: true, initialPage: 0);
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
      body: Theme(
        data: ThemeData(fontFamily: widget.fontFamily),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.tabList.length,
                  itemBuilder: (_, index) =>
                      _buildStudyPlanTab(context, index)),
            ),
            _buildNavigateSection()
          ],
        ),
      ),
    );
  }

  _buildStudyPlanTab(BuildContext context, int index) => Column(
        children: [
          // Upper background
          Expanded(
            flex: 8,
            child: Stack(alignment: Alignment.center, children: [
              Container(color: widget.lowerBackgroundColor),
              Container(
                decoration: BoxDecoration(
                    color: widget.upperBackgroundColor,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(50))),
              ),
              widget.tabList[index].image
            ]),
          ),

          // Lower background
          Expanded(
            flex: 3,
            child: Stack(children: [
              Container(color: widget.upperBackgroundColor),
              Container(
                decoration: BoxDecoration(
                    color: widget.lowerBackgroundColor,
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(50))),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 20),
                    child: Text(
                      widget.tabList[index].title,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      widget.tabList[index].subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              )
            ]),
          )
        ],
      );

  _buildNavigateSection() => Container(
        padding:
            const EdgeInsets.only(top: 10, bottom: 50, left: 30, right: 30),
        color: widget.lowerBackgroundColor,
        child: Row(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: _pageIndex,
                  builder: (_, value, __) => PageIndicator(
                      pageCount: widget.tabList.length,
                      currentPage: value.toInt(),
                      color: widget.buttonColor)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_pageController.hasClients &&
                    _pageController.page != widget.tabList.length - 1) {
                  _pageController.nextPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut);
                } else {
                  widget.onFinish();
                }
              },
              style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                      fontFamily: widget.fontFamily, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  backgroundColor: widget.buttonColor,
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
}
