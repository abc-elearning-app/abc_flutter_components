import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

import '../icons/icon_box.dart';

class TopicGrid extends StatelessWidget {
  final bool isDarkMode;

  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;

  final List<PracticeTestData> topicList;

  final void Function(int id) onSelect;

  const TopicGrid({
    super.key,
    this.mainColor = const Color(0xFFE3A651),
    this.secondaryColor = const Color(0xFF7C6F5B),
    this.backgroundColor = const Color(0xFFF5F4EE),
    required this.isDarkMode,
    required this.onSelect,
    required this.topicList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : backgroundColor,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : backgroundColor,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Practice Tests',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black,
            )),
      ),
      body: SafeArea(
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
            ),
            padding: const EdgeInsets.all(10),
            itemCount: topicList.length,
            itemBuilder: (_, index) => _topicBox(topicList[index])),
      ),
    );
  }

  Widget _topicBox(PracticeTestData data) => GestureDetector(
        onTap: () => onSelect(data.id),
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(data.background),
                fit: BoxFit.cover,
              )),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Blur background
                Container(
                  color: (isDarkMode ? Colors.black : secondaryColor)
                      .withOpacity(0.3),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 0,
                      decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.grey.shade900
                              : secondaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode
                                  ? Colors.grey.shade900
                                  : secondaryColor,
                              blurRadius: 300,
                              spreadRadius: 120,
                            )
                          ],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          )),
                    )),

                // Icon
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconBox(
                      size: 35,
                      iconColor: Colors.black,
                      backgroundColor: Colors.white,
                      icon: data.icon,
                      padding: const EdgeInsets.all(2),
                    ),
                  ),
                ),

                // Text
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      data.title,
                      maxLines: 2,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
