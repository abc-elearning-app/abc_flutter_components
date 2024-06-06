import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../flutter_abc_jsc_components.dart';

class ChallengeSection extends StatefulWidget {
  final bool isStarted;
  final Color mainColor;

  const ChallengeSection({
    super.key,
    required this.isStarted,
    required this.mainColor,
  });

  @override
  State<ChallengeSection> createState() => _ChallengeSectionState();
}

class _ChallengeSectionState extends State<ChallengeSection> {
  late ValueNotifier<int> _currentPageIndex;
  late PageController _pageController;
  late ScrollController _scrollController;

  double _maxScrollValue = 0;

  @override
  void initState() {
    _currentPageIndex = ValueNotifier(0);
    _pageController = PageController();
    _scrollController = ScrollController();

    _pageController.addListener(() {
      _currentPageIndex.value = _pageController.page?.toInt() ?? 0;
    });

    _scrollController.addListener(() {
      _currentPageIndex.value = _scrollController.offset <
              _scrollController.position.maxScrollExtent / 2
          ? 0
          : 1;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maxScrollValue = _scrollController.position.maxScrollExtent;
    });
    super.initState();
  }

  _onCenteredScroll() {
    if (_scrollController.offset < _maxScrollValue / 2) {
      // _currentPageIndex.value = 0;
      print('scroll back');
      if (_scrollController.offset != 0) {
        _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut);
      }
    } else {
      // _currentPageIndex.value = 1;
      print('scroll forward');
      if (_scrollController.offset != _maxScrollValue) {
        _scrollController.animateTo(_maxScrollValue,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut);
      }
    }
  }

  @override
  void dispose() {
    _currentPageIndex.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.isStarted
            ? SizedBox(
                height: 150,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification) {
                      _onCenteredScroll();
                    }
                    return true;
                  },
                  child: ListView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.03),
                    shrinkWrap: true,
                    children: [
                      _borderedBox(child: _challengeContent(14, 12)),
                      _borderedBox(child: _shieldContent())
                    ],
                  ),
                ),
              )
            : _borderedBox(
                child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset('assets/images/join_challenge.png'),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Keep the streak going!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: MainButton(
                              title: 'Join Challenge',
                              backgroundColor: widget.mainColor,
                              onPressed: () {},
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                        )
                      ],
                    ),
                  )
                ],
              )),
        Align(
          alignment: Alignment.center,
          child: ValueListenableBuilder(
            valueListenable: _currentPageIndex,
            builder: (_, value, __) => PageIndicator(
              pageCount: 2,
              currentPage: value,
              color: widget.mainColor,
              selectedWidth: 10,
              selectHeight: 10,
            ),
          ),
        ),
      ],
    );
  }

  _borderedBox({required Widget child}) => Container(
        width: MediaQuery.of(context).size.width * 0.93,
        margin: const EdgeInsets.only(bottom: 10, right: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: widget.mainColor),
            borderRadius: BorderRadius.circular(16)),
        child: child,
      );

  _challengeContent(int challengeDays, int currentDay) => Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$challengeDays Day Challenge',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Day $currentDay Of $challengeDays',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (_, constraints) =>
                Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: 40,
                child: LinearPercentIndicator(
                  lineHeight: 12,
                  padding: EdgeInsets.zero,
                  barRadius: const Radius.circular(100),
                  percent: 12 / 14,
                  progressColor: widget.mainColor,
                  backgroundColor: const Color(0xFF212121).withOpacity(0.08),
                ),
              ),
              Positioned(
                  left: constraints.maxWidth * 7 / 30,
                  child: Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: widget.mainColor,
                    ),
                    child: Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5))),
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5))),
                                child: const Center(
                                  child: Text(
                                    '7',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  )),
              Positioned(
                  left: constraints.maxWidth * 14 / 30,
                  child: Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: widget.mainColor,
                    ),
                    child: Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5))),
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5))),
                                child: const Center(
                                  child: Text(
                                    '14',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  )),
              Positioned(
                  left: constraints.maxWidth - 40,
                  child: Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: widget.mainColor,
                    ),
                    child: Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5))),
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5))),
                                child: const Center(
                                  child: Text(
                                    '30',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  )),
            ]),
          )
        ],
      );

  _shieldContent() => Row(
        children: [
          Image.asset('assets/images/shields.png'),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text(
                    'Additional protection for your chain.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                    width: double.infinity,
                    child: MainButton(
                        title: 'Join Challenge',
                        backgroundColor: const Color(0xFF39ACF0),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        onPressed: () {}))
              ],
            ),
          )
        ],
      );
}
