import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  @override
  void initState() {
    _currentPageIndex = ValueNotifier(0);
    _pageController = PageController();

    _pageController.addListener(() {
      _currentPageIndex.value = _pageController.page?.toInt() ?? 0;
    });
    super.initState();
  }

  @override
  void dispose() {
    _currentPageIndex.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.isStarted
            ? SizedBox(
                height: 124,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 2,
                  itemBuilder: (_, index) =>
                      _borderedBox(child: _shieldContent()),
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

  _borderedBox({
    required Widget child,
  }) =>
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: widget.mainColor),
            borderRadius: BorderRadius.circular(16)),
        child: child,
      );

  _challengeContent() => Container();

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
