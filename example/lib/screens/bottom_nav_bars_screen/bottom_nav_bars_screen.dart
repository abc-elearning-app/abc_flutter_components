import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class BottomNavBarsScreen extends StatefulWidget {
  const BottomNavBarsScreen({super.key});

  @override
  State<BottomNavBarsScreen> createState() => _BottomNavBarsScreenState();
}

class _BottomNavBarsScreenState extends State<BottomNavBarsScreen> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("Bubble Bottom Nav Bar"),
            const SizedBox(
              height: 10,
            ),
            BubbleBottomNavBar(
                items: List.generate(4, (index) => index)
                    .map((e) => BubbleBottomBarItem(
                          icon: Icon(
                            Icons.home_outlined,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          title: const Text("Home"),
                          activeIcon: Icon(
                            Icons.home,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ))
                    .toList(),
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                iconSize: 24,
                opacity: 1.0,
                borderRadius: BorderRadius.circular(12),
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.primary,
                hasNotch: true,
                hasInk: true,
                fabLocation: BubbleBottomBarFabLocation.end,
                inkColor: Theme.of(context).colorScheme.primary,
                currentIndex: _currentIndex),
            const SizedBox(
              height: 30,
            ),
            const Text("Fancy Bottom Nav Bar"),
            const SizedBox(
              height: 40,
            ),
            FancyBottomNavBar(
              textColor: Theme.of(context).colorScheme.onPrimary,
              inactiveIconColor: Theme.of(context).colorScheme.onPrimary,
              activeIconColor: Theme.of(context).colorScheme.primary,
              barBackgroundColor: Theme.of(context).colorScheme.primary,
              initialSelection: _currentIndex,
              circleColor: Theme.of(context).colorScheme.onPrimary,
              onTabChangedListener: (index) =>
                  setState(() => _currentIndex = index),
              tabs: List.generate(4, (index) => index)
                  .map((tab) => TabData(
                      iconData: Icons.home, title: "Home", onclick: () {}))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
