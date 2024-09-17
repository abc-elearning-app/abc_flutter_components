import 'package:flutter/material.dart';

class ImprovedCurvedBottomNavBar extends StatefulWidget {
  final int itemCount;
  final PageController pageController;
  final Duration animationDuration;
  final double additionalHeight;

  final List<Widget> selectedIcons;
  final List<Widget> unselectedIcons;
  final List<String> titles;

  final Color backgroundColor;
  final Color navBarColor;
  final Color unselectedColor;
  final Color mainColor;

  final double iconScale;

  final bool isDarkMode;

  const ImprovedCurvedBottomNavBar({
    super.key,
    required this.itemCount,
    required this.pageController,
    this.additionalHeight = 0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.iconScale = 1,
    required this.backgroundColor,
    required this.navBarColor,
    required this.unselectedColor,
    required this.selectedIcons,
    required this.unselectedIcons,
    required this.titles,
    required this.isDarkMode,
    required this.mainColor,
  });

  @override
  State<ImprovedCurvedBottomNavBar> createState() => _ImprovedCurvedBottomNavBarState();
}

class _ImprovedCurvedBottomNavBarState extends State<ImprovedCurvedBottomNavBar> {
  PageController get pageController => widget.pageController;

  bool get controllerAttached => widget.pageController.hasClients && widget.pageController.page != null;

  int get itemCount => widget.itemCount;

  Duration get animationDuration => widget.animationDuration;

  Color get navBarColor => widget.isDarkMode ? Colors.grey.shade900 : widget.navBarColor;

  // Offset values
  double screenWidth = 0;
  double currentOffset = 0;
  double pageOffsetRate = 0;

  // Indexes
  int currentIndex = 0;
  int prevIndex = 0;

  // Avoid loops
  bool swipeGesture = true;

  // Lock fast click
  int prevClickTime = 0;

  double mainBoxWidth = 218;
  double navBarHeight = 90;

  bool doneSetup = false;

  _isEven() => pageController.page!.toInt() == pageController.page!;

  _onTapChangePage() {
    swipeGesture = false;
    Future.delayed(Duration(milliseconds: animationDuration.inMilliseconds + 10), () {
      if (mounted) swipeGesture = true;
    });

    final newOffset = screenWidth * ((1 / (itemCount * 2)) + currentIndex / itemCount);

    pageController.animateToPage(currentIndex, duration: animationDuration, curve: Curves.linear);

    final step = (newOffset - currentOffset).abs() / animationDuration.inMilliseconds;
    for (int i = 0; i < animationDuration.inMilliseconds; i++) {
      Future.delayed(Duration(milliseconds: i), () {
        if (mounted) {
          setState(() {
            if (newOffset > currentOffset) {
              currentOffset += step;
            } else {
              currentOffset -= step;
            }
          });
        }
      });
    }
  }

  _onSwipePage() {
    if (swipeGesture) {
      pageOffsetRate = pageController.page! / (itemCount - 1); // From 0 to 1
      setState(() {
        currentOffset = screenWidth * ((1 / (itemCount * 2)) + pageOffsetRate * ((itemCount - 1) / itemCount));
        if (_isEven()) {
          currentIndex = pageController.page!.toInt();
        }
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      screenWidth = MediaQuery.of(context).size.width;
      setState(() => currentOffset = screenWidth / (itemCount * 2));

      doneSetup = true;
    });

    pageController.addListener(_onSwipePage);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!doneSetup) return const SizedBox();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(color: widget.isDarkMode ? Colors.black : widget.backgroundColor, boxShadow: [
              BoxShadow(
                color: widget.isDarkMode ? Colors.black : widget.backgroundColor,
                blurRadius: 10,
                spreadRadius: 10,
              )
            ]),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Positioned(
                  left: 0,
                  child: Container(height: navBarHeight, width: (currentOffset - mainBoxWidth / 2).clamp(0, 10000), color: navBarColor),
                ),
                Positioned(
                  left: 0,
                  child: Transform.translate(
                    offset: Offset(currentOffset - mainBoxWidth / 2, 0),
                    child: _mainItem(),
                  ),
                ),
                Positioned(
                    left: currentOffset + mainBoxWidth / 2,
                    child: Container(height: navBarHeight, width: (screenWidth - currentOffset - mainBoxWidth / 2).clamp(0, 10000), color: navBarColor)),

                // Unselected icons
                Row(
                  children: List.generate(
                    itemCount,
                    (index) => SizedBox(
                        width: screenWidth / itemCount,
                        child: Transform.translate(
                          offset: Offset(0, _getUnselectedIconPosition(index) - 45),
                          child: Opacity(
                            opacity: _getUnselectedIconOpacity(index),
                            child: Transform.scale(
                              scale: widget.iconScale,
                              child: widget.unselectedIcons[index],
                            ),
                          ),
                        )),
                  ),
                ),

                // Titles
                Transform.translate(
                  offset: const Offset(0, -15),
                  child: Row(
                    children: List.generate(
                      itemCount,
                      (index) => SizedBox(
                          width: screenWidth / itemCount,
                          child: Text(
                            widget.titles[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: widget.isDarkMode
                                  ? Color.lerp(widget.mainColor, Colors.white, 1.0 - _getTextOpacity(index))
                                  : widget.unselectedColor.withOpacity(_getTextOpacity(index)),
                            ),
                          )),
                    ),
                  ),
                ),

                // Gesture detectors
                Row(
                  children: List.generate(
                      itemCount,
                      (index) => GestureDetector(
                            onTap: () {
                              if (DateTime.now().millisecondsSinceEpoch < prevClickTime + 250) return;
                              prevClickTime = DateTime.now().millisecondsSinceEpoch;

                              setState(() {
                                if (currentIndex != index) {
                                  prevIndex = currentIndex;
                                  currentIndex = index;
                                  _onTapChangePage();
                                }
                              });
                            },
                            child: Container(
                              height: 120,
                              width: screenWidth / itemCount,
                              color: Colors.transparent,
                            ),
                          )),
                ),
              ],
            )),
        Container(
          width: double.infinity,
          height: widget.additionalHeight,
          color: navBarColor,
        )
      ],
    );
  }

  _mainItem() => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: navBarHeight,
                width: 100,
                decoration: BoxDecoration(color: navBarColor, borderRadius: const BorderRadius.only(topRight: Radius.circular(100))),
              ),
              const SizedBox(width: 18),
              Container(
                height: navBarHeight,
                width: 100,
                decoration: BoxDecoration(color: navBarColor, borderRadius: const BorderRadius.only(topLeft: Radius.circular(100))),
              ),
            ],
          ),
          Container(width: 80, height: 60, color: navBarColor),
          Transform.translate(
            offset: const Offset(0, -44),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: widget.isDarkMode ? Colors.black : widget.backgroundColor,
              child: CircleAvatar(
                radius: 35,
                backgroundColor: navBarColor,
                child: Stack(alignment: Alignment.center, children: [
                  Container(
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                  ),
                  Opacity(
                    opacity: _getSelectedIconOpacity(),
                    child: Transform.scale(scale: widget.iconScale, child: widget.selectedIcons[controllerAttached ? pageController.page!.round() : 0]),
                  ),
                ]),
              ),
            ),
          ),
        ],
      );

  _getTextOpacity(int index) {
    if (!controllerAttached) return 0.0;

    if ((pageController.page! - index).abs() >= 1) return widget.isDarkMode ? 0 : 0.5;
    return 1.0 - (pageController.page! - index).abs().clamp(0, widget.isDarkMode ? 1 : 0.5);
  }

  _getSelectedIconOpacity() {
    if (!controllerAttached) return 0.0;

    final midPoint = pageController.page!.floor() + 0.5;
    return ((pageController.page! - midPoint).abs() * 2).clamp(0.6, 1);
  }

  _getUnselectedIconOpacity(int index) {
    if (!controllerAttached) return 0.0;

    if ((pageController.page! - index).abs() >= 1) return 1.0;

    return (pageController.page! - index).abs();
  }

  _getUnselectedIconPosition(int index) {
    if (!controllerAttached) return 0.0;

    if ((pageController.page! - index).abs() >= 1) return 0.0;

    return (1.0 - (pageController.page! - index).abs()) * 30;
  }
}
