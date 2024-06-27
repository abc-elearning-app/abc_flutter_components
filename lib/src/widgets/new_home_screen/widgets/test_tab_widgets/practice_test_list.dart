import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../icons/icon_box.dart';

class PracticeTestData {
  final int id;
  final String title;
  final String background;
  final String icon;

  PracticeTestData(
      {required this.id,
      required this.title,
      required this.icon,
      required this.background});
}

class PracticeTestList extends StatelessWidget {
  final List<PracticeTestData> practiceTests;
  final void Function(int index) onSelect;
  final bool isDarkMode;
  final Color color;

  const PracticeTestList({
    super.key,
    required this.practiceTests,
    required this.onSelect,
    required this.isDarkMode,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: ListView.builder(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: practiceTests.length,
          itemBuilder: (_, index) => _practiceTestBox(practiceTests[index])),
    );
  }

  Widget _practiceTestBox(PracticeTestData data) => GestureDetector(
        onTap: () => onSelect(data.id),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 180,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                  image: AssetImage(data.background), fit: BoxFit.cover)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Blur background
                Container(
                  color: (isDarkMode ? Colors.black : color).withOpacity(0.3),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 0,
                      decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey.shade900 : color,
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode ? Colors.grey.shade900 : color,
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
