import 'package:flutter/material.dart';

import '../../index.dart';

const double circleSize = 60;
const double arcHeight = 70;
const double arcWidth = 90;
const double circleOutline = 10;
const double shadowAllowance = 20;
const double barHeight = 60;

class FancyBottomNavBar extends StatefulWidget {
  final Function(int position) onTabChangedListener;
  final Color circleColor;
  final Color activeIconColor;
  final Color inactiveIconColor;
  final Color textColor;
  final Color barBackgroundColor;
  final List<TabData> tabs;
  final int initialSelection;

  const FancyBottomNavBar({
    super.key,
    required this.tabs,
    required this.onTabChangedListener,
    this.initialSelection = 0,
    required this.circleColor,
    required this.activeIconColor,
    required this.inactiveIconColor,
    required this.textColor,
    required this.barBackgroundColor,
  }) : assert(tabs.length > 1 && tabs.length < 5);

  @override
  FancyBottomNavBarState createState() => FancyBottomNavBarState();
}

class FancyBottomNavBarState extends State<FancyBottomNavBar>
    with TickerProviderStateMixin, RouteAware {
  IconData nextIcon = Icons.search;
  IconData activeIcon = Icons.search;

  int currentSelected = 0;
  double _circleAlignX = 0;
  double _circleIconAlpha = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    activeIcon = widget.tabs[currentSelected].iconData;
  }

  @override
  void initState() {
    super.initState();
    currentSelected = widget.initialSelection;
    _setSelected(widget.tabs[widget.initialSelection].key);
  }

  _setSelected(UniqueKey key) {
    int selected = widget.tabs.indexWhere((tabData) => tabData.key == key);

    if (mounted) {
      setState(() {
        currentSelected = selected;
        _circleAlignX = -1 + (2 / (widget.tabs.length - 1) * selected);
        nextIcon = widget.tabs[selected].iconData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // overflow: Overflow.visible,
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          height: barHeight,
          decoration:
              BoxDecoration(color: widget.barBackgroundColor, boxShadow: [
            BoxShadow(
              // color: Colors.black12, offset: Offset(0, -1), blurRadius: 8)
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 3,
              blurRadius: 2,
              offset: const Offset(0, 3),
            )
          ]),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.tabs
                .map((t) => TabItem(
                    uniqueKey: t.key,
                    selected: t.key == widget.tabs[currentSelected].key,
                    iconData: t.iconData,
                    title: t.title,
                    iconColor: widget.inactiveIconColor,
                    textColor: widget.textColor,
                    callbackFunction: (uniqueKey) {
                      int selected = widget.tabs
                          .indexWhere((tabData) => tabData.key == uniqueKey);
                      widget.onTabChangedListener(selected);
                      _setSelected(uniqueKey);
                      _initAnimationAndStart(_circleAlignX, 1);
                    }))
                .toList(),
          ),
        ),
        Positioned.fill(
          top: -(circleSize + circleOutline + shadowAllowance) / 2,
          child: AnimatedAlign(
            duration: const Duration(milliseconds: animDuration),
            curve: Curves.easeOut,
            alignment: Alignment(_circleAlignX, 1),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: FractionallySizedBox(
                widthFactor: 1 / widget.tabs.length,
                child: GestureDetector(
                  onTap: () => widget.tabs[currentSelected].onclick(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: circleSize + circleOutline + shadowAllowance,
                        width: circleSize + circleOutline + shadowAllowance,
                        child: ClipRect(
                            clipper: HalfClipper(),
                            child: Center(
                              child: Container(
                                  width: circleSize + circleOutline,
                                  height: circleSize + circleOutline,
                                  decoration: BoxDecoration(
                                      color: widget.barBackgroundColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          // color: Colors.black12,
                                          // blurRadius: 8)
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 1,
                                        )
                                      ])),
                            )),
                      ),
                      SizedBox(
                          height: arcHeight,
                          width: arcWidth,
                          child: CustomPaint(
                            painter: HalfPainter(widget.barBackgroundColor),
                          )),
                      SizedBox(
                        height: circleSize,
                        width: circleSize,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.circleColor),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: AnimatedOpacity(
                              duration: const Duration(
                                  milliseconds: animDuration ~/ 5),
                              opacity: _circleIconAlpha,
                              child: Icon(
                                activeIcon,
                                color: widget.activeIconColor,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void didUpdateWidget(FancyBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelection != oldWidget.initialSelection) {
      _setSelected(widget.tabs[widget.initialSelection].key);
      _initAnimationAndStart(_circleAlignX, 1);

      setState(() {
        currentSelected = widget.initialSelection;
      });
    }
  }

  _initAnimationAndStart(double from, double to) {
    _circleIconAlpha = 0;

    Future.delayed(const Duration(milliseconds: animDuration ~/ 5), () {
      setState(() {
        activeIcon = nextIcon;
      });
    }).then((_) {
      Future.delayed(const Duration(milliseconds: (animDuration ~/ 5 * 3)), () {
        setState(() {
          _circleIconAlpha = 1;
        });
      });
    });
  }

  void setPage(int page) {
    widget.onTabChangedListener(page);
    _setSelected(widget.tabs[page].key);
    _initAnimationAndStart(_circleAlignX, 1);

    setState(() {
      currentSelected = page;
    });
  }
}

class TabData {
  TabData({
    required this.iconData,
    required this.title,
    required this.onclick,
  });

  IconData iconData;
  String title;
  Function onclick;
  final UniqueKey key = UniqueKey();
}
