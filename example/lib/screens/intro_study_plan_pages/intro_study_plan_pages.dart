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
  final Color mainColor;
  final Color buttonTextColor;
  final Color titleColor;
  final Color subTitleColor;
  final double buttonTextFontSize;
  final List<IntroStudyPlanData> tabList;
  final String? fontFamily;
  final void Function() onFinish;

  const IntroStudyPlanPages(
      {super.key,
      this.upperBackgroundColor = const Color(0xFFEEFFFA),
      this.lowerBackgroundColor = Colors.white,
      this.mainColor = const Color(0xFF579E89),
      this.buttonTextColor = Colors.white,
      this.buttonTextFontSize = 20,
      this.titleColor = Colors.black,
      this.subTitleColor = Colors.grey,
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
        child: Stack(children: [
          Column(
            children: [
              // Upper background
              Expanded(
                flex: 2,
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
                flex: 1,
                child: Stack(children: [
                  Container(color: widget.upperBackgroundColor),
                  Container(
                    decoration: BoxDecoration(
                        color: widget.lowerBackgroundColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50))),
                  ),
                ]),
              )
            ],
          ),

          // Main content
          Column(
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
        ]),
      ),
    );
  }

  _buildStudyPlanTab(BuildContext context, int index) => Column(
        children: [
          // Upper part
          Expanded(
            flex: 9,
            child: widget.tabList[index].image,
          ),

          // Page indicator and button
          Expanded(
            flex: 3,
            child: Column(
              children: [
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

  _buildNavigateSection() => Container(
        padding:
            const EdgeInsets.only(top: 10, bottom: 30, left: 30, right: 30),
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
    if (_pageController.hasClients &&
        _pageController.page != widget.tabList.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    } else {
      widget.onFinish();
    }
  }
}
