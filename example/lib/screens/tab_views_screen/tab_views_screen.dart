import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TabViewsScreen extends StatefulWidget {
  const TabViewsScreen({super.key});

  @override
  State<TabViewsScreen> createState() => _TabViewsScreenState();
}

class _TabViewsScreenState extends State<TabViewsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentPage = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: currentPage,
    );
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 60,
            child: MyTabBarView(
                onChanging: (double page, double offset) {
                  int newPage = page.round();
                  if (currentPage != newPage) {
                    setState(() {
                      currentPage = newPage;
                    });
                  }
                },
                controller: _tabController,
                children: [
                  _makeListView(0),
                  _makeListView(1),
                  _makeListView(2),
                ]),
          ),
        ),
      ),
    );
  }

  Widget _makeListView(int currentPage) {
    return ListView.builder(
        controller: currentPage == 1 ? _scrollController : null,
        padding: const EdgeInsets.all(0),
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.center,
            height: 100,
            color: getRandomColor(),
            child: Text("${index + 1}", style: const TextStyle(fontSize: 30)),
          );
        });
  }

  Color getRandomColor() {
    List<Color> colors = [...Colors.primaries, ...Colors.accents];
    return colors[Random().nextInt(colors.length)];
  }
}
