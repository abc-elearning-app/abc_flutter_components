import 'dart:async';

import 'package:flutter/material.dart';

class ExperimentAnims extends StatefulWidget {
  const ExperimentAnims({super.key});

  @override
  State<ExperimentAnims> createState() => _ExperimentAnimsState();
}

class _ExperimentAnimsState extends State<ExperimentAnims> {
  double screenWidth = 0;

  double currentOffset = 0;

  int currentIndex = 0;
  int prevIndex = 0;

  int itemCount = 4;

  late PageController pageController;

  bool swipeGesture = true;

  int prevClickTime = 0;

  double pageOffsetRate = 0;

  _isEven() => pageController.page!.toInt() == pageController.page!;

  _onTapChangePage() {
    // print('currentIndex: $currentIndex');
    swipeGesture = false;

    final newOffset = screenWidth * ((1 / (itemCount * 2)) + currentIndex / itemCount);

    Future.delayed(const Duration(milliseconds: 210), () => swipeGesture = true);

    pageController.animateToPage(currentIndex, duration: const Duration(milliseconds: 200), curve: Curves.linear);

    final step = (newOffset - currentOffset).abs() / 200;
    for (int i = 0; i < 200; i++) {
      Future.delayed(Duration(milliseconds: i), () {
        setState(() {
          if (newOffset > currentOffset) {
            currentOffset += step;
          } else {
            currentOffset -= step;
          }
        });
      });
    }
    // timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
    //   setState(() {
    //     if (newOffset > currentOffset) {
    //       currentOffset++;
    //       if (currentOffset >= newOffset) timer.cancel();
    //     } else {
    //       currentOffset--;
    //       if (currentOffset <= newOffset) timer.cancel();
    //     }
    //   });
    // });
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
    pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      screenWidth = MediaQuery.of(context).size.width;
      setState(() {
        currentOffset = screenWidth / (itemCount * 2);
      });
    });

    pageController.addListener(_onSwipePage);

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('ANIMATION LAB')),
        body: Column(
          children: [
            Expanded(
                child: Container(
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // PageView
                  SizedBox(
                    height: 500,
                    width: 400,
                    child: PageView.builder(
                      physics: const ClampingScrollPhysics(),
                      controller: pageController,
                      itemCount: itemCount,
                      itemBuilder: (_, index) => Container(
                        height: 450,
                        width: 350,
                        color: index % 2 == 0 ? Colors.red : Colors.white,
                        margin: const EdgeInsets.all(10),
                        child: Center(child: Text('$index', style: TextStyle(fontSize: 30, color: index % 2 == 0 ? Colors.white : Colors.red))),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Markers
                  Row(
                    children: List.generate(
                        itemCount,
                        (index) => Expanded(
                                child: Container(
                              height: 10,
                              color: index % 2 == 0 ? Colors.white : Colors.red,
                              child: Center(
                                child: CircleAvatar(
                                  backgroundColor: index % 2 == 0 ? Colors.red : Colors.white,
                                  radius: 2,
                                ),
                              ),
                            ))),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )),

            // Main components
            Container(
                height: 120,
                width: double.infinity,
                color: Colors.white,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    // Main component
                    Positioned(
                      left: 0,
                      child: Container(height: 80, width: (currentOffset - 218 / 2).clamp(0, 10000), color: Colors.red),
                    ),
                    Positioned(
                      left: 0,
                      child: Transform.translate(
                        offset: Offset(currentOffset - 218 / 2, 0),
                        child: _mainItem(),
                      ),
                    ),
                    Positioned(
                        left: currentOffset + 218 - 218 / 2,
                        child: Container(height: 80, width: (screenWidth - currentOffset - 218 + 218 / 2).clamp(0, 10000), color: Colors.red)),

                    // Unselected icons
                    Row(
                      children: List.generate(
                        itemCount,
                        (index) => SizedBox(
                            width: MediaQuery.of(context).size.width / itemCount,
                            child: Transform.translate(
                              offset: Offset(0, _getUnselectedIconPosition(index) - 45),
                              child: Opacity(
                                opacity: _getUnselectedIconOpacity(index),
                                child: Icon(
                                  index % 2 == 0 ? Icons.star : Icons.ac_unit_sharp,
                                  color: Colors.white,
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
                              width: MediaQuery.of(context).size.width / itemCount,
                              child: Text(
                                'item $index',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white.withOpacity(_getTextOpacity(index))),
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
                                  width: MediaQuery.of(context).size.width / itemCount,
                                  color: Colors.transparent,
                                ),
                              )),
                    ),
                  ],
                ))
          ],
        ));
  }

  _mainItem() => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 80,
                width: 100,
                decoration: const BoxDecoration(color: Colors.red, borderRadius: BorderRadius.only(topRight: Radius.circular(100))),
              ),
              const SizedBox(width: 18),
              Container(
                height: 80,
                width: 100,
                decoration: const BoxDecoration(color: Colors.red, borderRadius: BorderRadius.only(topLeft: Radius.circular(100))),
              ),
            ],
          ),
          Container(width: 80, height: 50, color: Colors.red),
          Transform.translate(
            offset: const Offset(0, -40),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.red,
                child: Opacity(
                    opacity: _getSelectedIconOpacity(),
                    child: Icon(
                        !pageController.hasClients
                            ? Icons.abc
                            : pageController.page!.round() % 2 == 0
                                ? Icons.star
                                : Icons.ac_unit_sharp,
                        color: Colors.yellowAccent)),
              ),
            ),
          ),

          // Markers
          Container(height: 40, width: 2, color: Colors.white),
          Positioned(right: 0, child: Container(height: 80, width: 2, color: Colors.white)),
          Positioned(left: 0, child: Container(height: 80, width: 2, color: Colors.white)),
        ],
      );

  _getTextOpacity(int index) {
    if (!pageController.hasClients) return 0.0;

    if ((pageController.page! - index).abs() >= 1) return 0.5;
    return 1.0 - (pageController.page! - index).abs().clamp(0, 0.5);
  }

  _getSelectedIconOpacity() {
    if (!pageController.hasClients) return 0.0;

    final midPoint = pageController.page!.floor() + 0.5;
    return (pageController.page! - midPoint).abs() * 2;
  }

  _getUnselectedIconOpacity(int index) {
    if (!pageController.hasClients) return 0.0;

    if ((pageController.page! - index).abs() >= 1) return 1.0;

    return (pageController.page! - index).abs();
  }

  _getUnselectedIconPosition(int index) {
    if (!pageController.hasClients) return 0.0;

    if ((pageController.page! - index).abs() >= 1) return 0.0;

    return (1.0 - (pageController.page! - index).abs()) * 20;
  }
}
