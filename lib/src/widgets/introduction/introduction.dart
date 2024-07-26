import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class IntroductionData {
  final int index;
  final String image;
  final String title;
  final String subtitle;

  IntroductionData({
    required this.index,
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

class IntroductionComponent extends StatefulWidget {
  final Color upperBackgroundColor;
  final Color lowerBackgroundColor;
  final Color mainColor;

  final List<IntroductionData> tabList;
  final void Function() onFinish;

  const IntroductionComponent({
    super.key,
    this.upperBackgroundColor = const Color(0xFFF5F4EE),
    this.lowerBackgroundColor = Colors.white,
    this.mainColor = const Color(0xFFE3A651),
    required this.tabList,
    required this.onFinish,
  });

  @override
  State<IntroductionComponent> createState() => _IntroductionComponentState();
}

class _IntroductionComponentState extends State<IntroductionComponent> {
  late PageController _pageController;
  late ValueNotifier _pageIndex;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _pageIndex = ValueNotifier<double>(0);

    _pageController.addListener(_nextPageListener);

    super.initState();
  }

  void _nextPageListener() => _pageIndex.value = _pageController.page!;

  @override
  void dispose() {
    _pageController.removeListener(_nextPageListener);
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
                      itemBuilder: (_, index) => _buildStudyPlanTab(index))),
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

  Widget _buildStudyPlanTab(int index) => Column(
        children: [
          // Upper part
          Expanded(
            flex: 9,
            child: Image.asset(
              widget.tabList[index].image,
              width: 300,
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
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
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
                          color: const Color(0xFF3C3C3C).withOpacity(0.52),
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
                  textStyle: const TextStyle(fontSize: 20),
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
