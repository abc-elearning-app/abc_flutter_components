import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExperimentAnims extends StatefulWidget {
  const ExperimentAnims({super.key});

  @override
  State<ExperimentAnims> createState() => _ExperimentAnimsState();
}

class _ExperimentAnimsState extends State<ExperimentAnims> {
  double offset = 0;
  int itemCount = 4;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final sideBoxWidth = (MediaQuery.of(context).size.width - 218) / 2 + 10;
    final initialDistance = MediaQuery.of(context).size.width / (itemCount * 2);
    offset = initialDistance * (currentIndex * 2 + 1) - (MediaQuery.of(context).size.width / 2);
    return Scaffold(
        body: Column(
      children: [
        Expanded(
            child: Container(
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: () => setState(() => currentIndex = (currentIndex - 1).clamp(0, itemCount - 1)), child: const Text('Left')),
                  const SizedBox(width: 100),
                  ElevatedButton(onPressed: () => setState(() => currentIndex = (currentIndex + 1).clamp(0, itemCount - 1)), child: const Text('Right')),
                ],
              ),
              const SizedBox(height: 50),
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
        Container(
            height: 120,
            width: double.infinity,
            color: Colors.red,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(left: 0, child: Container(height: 80, width: (sideBoxWidth + offset).clamp(0, 10000), color: Colors.brown)),
                Transform.translate(offset: Offset(offset, 0), child: _mainItem()),
                Positioned(right: 0, child: Container(height: 80, width: (sideBoxWidth - offset).clamp(0, 10000), color: Colors.brown)),
                Row(
                  children: List.generate(
                      itemCount,
                      (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                            child: Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width / itemCount,
                              color: Colors.transparent,
                            ),
                          )),
                ),
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
                            style: TextStyle(color: currentIndex == index ? Colors.white : Colors.white.withOpacity(0.5)),
                          )),
                    ),
                  ),
                )
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
                decoration: const BoxDecoration(color: Colors.brown, borderRadius: BorderRadius.only(topRight: Radius.circular(100))),
              ),
              const SizedBox(width: 18),
              Container(
                height: 80,
                width: 100,
                decoration: const BoxDecoration(color: Colors.brown, borderRadius: BorderRadius.only(topLeft: Radius.circular(100))),
              ),
            ],
          ),
          Container(width: 80, height: 50, color: Colors.brown),
          Transform.translate(
            offset: const Offset(0, -40),
            child: const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.red,
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.brown,
              ),
            ),
          ),
        ],
      );
}
