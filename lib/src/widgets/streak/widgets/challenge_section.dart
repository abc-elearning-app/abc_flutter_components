import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/animations/page_animation.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../flutter_abc_jsc_components.dart';

enum ChallengeBoxType { notStarted, started, justStart }

class ChallengeSection extends StatefulWidget {
  final ChallengeBoxType type;
  final Color mainColor;
  final Color shieldColor;

  final int dayStreak;

  final bool isShieldUsed;

  final void Function() onJoinChallenge;
  final void Function() onUseShield;

  const ChallengeSection({
    super.key,
    required this.type,
    required this.mainColor,
    required this.onJoinChallenge,
    required this.onUseShield,
    required this.shieldColor,
    required this.dayStreak,
    required this.isShieldUsed,
  });

  @override
  State<ChallengeSection> createState() => _ChallengeSectionState();
}

class _ChallengeSectionState extends State<ChallengeSection> {
  late ValueNotifier<int> _currentPageIndex;
  late ScrollController _scrollController;
  Timer _stopTimer = Timer(const Duration(), () {});

  bool isShieldUsed = false;

  @override
  void initState() {
    _currentPageIndex = ValueNotifier(0);
    _scrollController = ScrollController();
    _setupCarouselAnimation();
    isShieldUsed = widget.isShieldUsed;
    super.initState();
  }

  _setupCarouselAnimation() {
    _scrollController.addListener(() {
      _currentPageIndex.value = _scrollController.offset <
              _scrollController.position.maxScrollExtent / 2
          ? 0
          : 1;

      if (_stopTimer != null) _stopTimer.cancel();

      double maxExtent = _scrollController.position.maxScrollExtent;

      _stopTimer = Timer(const Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.offset < maxExtent / 2 ? 0 : maxExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  void dispose() {
    _currentPageIndex.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity, child: _getChild());
  }

  _getChild() {
    switch (widget.type) {
      case ChallengeBoxType.notStarted:
        return _joinChallengeBox();
      case ChallengeBoxType.started:
        return _streakBox();
      case ChallengeBoxType.justStart:
        return PageAnimation(
          prevChild: _joinChallengeBox(),
          nextChild: _streakBox(),
        );
    }
  }

  _borderedBox({required Widget child}) => Container(
      width: MediaQuery.of(context).size.width * 0.91,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: widget.mainColor),
          borderRadius: BorderRadius.circular(16)),
      child: child);

  _challengeContent(int currentDay) {
    int challengeDay = currentDay < 6
        ? 6
        : currentDay < 18
            ? 18
            : 30;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$challengeDay Day Challenge',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Day $currentDay Of $challengeDay',
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
              height: 50,
              child: LinearPercentIndicator(
                lineHeight: 12,
                padding: EdgeInsets.zero,
                barRadius: const Radius.circular(100),
                percent: currentDay / 30,
                progressColor: widget.mainColor,
                backgroundColor: Colors.black.withOpacity(0.08),
              ),
            ),
            _buildCheckpoint(6, constraints, true),
            _buildCheckpoint(18, constraints, currentDay >= 6),
            _buildCheckpoint(30, constraints, currentDay >= 18),
          ]),
        )
      ],
    );
  }

  _buildCheckpoint(int day, BoxConstraints constraints, bool isActive) =>
      Positioned(
          left: constraints.maxWidth * day / 30 -
              (day == 18
                  ? 20
                  : day == 30
                      ? 40
                      : 10),
          child: Stack(alignment: Alignment.center, children: [
            if (isActive)
              Transform.translate(
                  offset: const Offset(0, -18),
                  child: Image.asset(
                    'assets/images/red_fire.png',
                    height: 40,
                  )),
            Container(
              height: 40,
              width: 40,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isActive ? widget.mainColor : Colors.grey.shade300,
              ),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: isActive ? Colors.red : Colors.grey.shade500,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5))),
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.white
                                  : Colors.grey.shade400,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5))),
                          child: Center(
                            child: Text(
                              day.toString(),
                              style: TextStyle(
                                color: isActive
                                    ? Colors.red
                                    : Colors.grey.shade600,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ]));

  _shieldContent() => Row(
        children: [
          Expanded(
              flex: 2,
              child: Image.asset('assets/images/sparkling_shield.gif')),
          const SizedBox(width: 10),
          Expanded(
            flex: 5,
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
                    child: StatefulBuilder(
                      builder: (_, setState) => MainButton(
                        title: isShieldUsed ? 'Used' : 'Use Now',
                        disabled: isShieldUsed,
                        backgroundColor: widget.shieldColor,
                        onPressed: () {
                          widget.onUseShield.call();
                          setState(() => isShieldUsed = true);
                        },
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))
              ],
            ),
          )
        ],
      );

  _joinChallengeBox() => Container(
        height: 160,
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: _borderedBox(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
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
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: MainButton(
                        title: 'Join Challenge',
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        backgroundColor: widget.mainColor,
                        onPressed: widget.onJoinChallenge,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )),
      );

  _streakBox() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            width: double.infinity,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _borderedBox(child: _challengeContent(widget.dayStreak)),
                  const SizedBox(width: 15),
                  _borderedBox(child: _shieldContent()),
                ],
              ),
            ),
          ),
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
